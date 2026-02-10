# Implementation Plan: BR-077 - fifty_map_engine v2 Grid Game Toolkit

**Complexity:** XL
**Estimated Duration:** 1-2 weeks
**Risk Level:** Medium
**Files Affected:** 8 modified + 22 new = 30 total
**Phases:** 9

---

## Current State Analysis

### Existing Package Structure

```
packages/fifty_map_engine/lib/
  fifty_map_engine.dart              # Barrel export (re-exports Vector2 from Flame!)
  src/
    config/
      map_config.dart                # FiftyMapConfig: blockSize = 64.0
    components/
      base/
        component.dart              # FiftyBaseComponent, FiftyStaticComponent, FiftyMovableComponent
        model.dart                  # FiftyMapEntity, FiftyMapEvent, FiftyEntityType, FiftyBlockSize
        extension.dart              # FiftyMapEntityExtension (copyWith, changePosition, type guards)
        priority.dart               # FiftyRenderPriority (background=0...uiOverlay=100)
        spawner.dart                # FiftyEntitySpawner (factory pattern with custom registry)
      room_component.dart           # FiftyRoomComponent
      event_component.dart          # FiftyEventComponent
      text_component.dart           # FiftyTextComponent
    controller/
      controller.dart               # FiftyMapController (facade: bind/unbind, add/move/remove, camera)
    view/
      widget.dart                   # FiftyMapWidget (StatefulWidget wrapping GameWidget)
      map_builder.dart              # FiftyMapBuilder (FlameGame: pan/zoom, entity lifecycle)
    services/
      asset_loader_service.dart     # FiftyAssetLoader (static registry + loadAll)
      map_loader_service.dart       # FiftyMapLoader (JSON loading/serialization)
    utils/
      logger.dart                   # FiftyMapLogger (singleton, dart:developer)
      utils.dart                    # FiftyMapUtils (rotation offsets, alignment positioning)
```

### Key Architectural Observations

1. **Flame is exposed in the public API.** The barrel export re-exports `Vector2` from `package:flame/components.dart`. `FiftyMapEntity` uses `Vector2` for `gridPosition`.

2. **No tile concept exists.** The engine handles "entities" (rooms, characters, monsters, furniture, events) but has no concept of a tile grid.

3. **Input uses `onLongTapDown`.** `FiftyBaseComponent` overrides `onLongTapDown` instead of `onTapDown`, requiring a 0.5s hold. Only entities with hitboxes are tappable.

4. **FiftyMapBuilder owns the World/Camera.** Extends `FlameGame` with `MultiTouchDragDetector` for pan and `TapDetector`.

5. **Component registry is a flat `Map<String, FiftyBaseComponent>`.** New systems (tiles, overlays, decorators) will use separate registries.

6. **FiftyRenderPriority has clear layering.** background(0) < furniture(10) < door(20) < monster(30) < character(40) < event(50) < uiOverlay(100).

7. **Coordinate system flips Y-axis.** `position = Vector2(model.x, game.size.y - model.y)`. **DECISION: Remove this flip. Unify to top-down (0,0 = top-left) for both old room system and new tile grid.**

8. **Existing tests are model-level only (390 lines).** No Flame component tests.

9. **Tactical grid app uses Flutter `GridView.builder` -- NOT the engine.** Has its own `GridPosition` class (181 lines). The engine's new `GridPosition` should take inspiration from this but be generic.

---

## Files to Modify

| File | Changes |
|------|---------|
| `lib/fifty_map_engine.dart` | Add all new exports, deprecate `Vector2` re-export |
| `lib/src/components/base/component.dart` | `onLongTapDown` -> `onTapDown`, add input blocking guard |
| `lib/src/view/widget.dart` | Add `grid`, `onTileTap` parameters |
| `lib/src/view/map_builder.dart` | Add tile grid rendering, global tap handler, input manager |
| `lib/src/controller/controller.dart` | Add tile/overlay/decorator/animation/pathfinding methods |
| `lib/src/services/asset_loader_service.dart` | Add sprite sheet loading support |
| `lib/src/components/base/model.dart` | Add optional `spriteAnimation` config to `FiftyMapEntity` |
| `lib/src/components/base/priority.dart` | Add new priority levels for tiles, overlays, decorators, effects |

### New Files to Create (22 files)

| File | Purpose |
|------|---------|
| `lib/src/grid/grid_position.dart` | Integer grid coordinate class |
| `lib/src/grid/tile_type.dart` | Tile type definition model |
| `lib/src/grid/tile_grid.dart` | 2D tile grid data structure |
| `lib/src/grid/tile_overlay.dart` | Overlay model + HighlightStyle presets |
| `lib/src/components/tiles/tile_component.dart` | Flame component for single tile |
| `lib/src/components/tiles/tile_grid_component.dart` | Renders full grid, manages tiles |
| `lib/src/components/overlays/tile_overlay_component.dart` | Colored rectangle overlay on tile |
| `lib/src/components/overlays/overlay_manager.dart` | Batch overlay management |
| `lib/src/components/decorators/entity_decorator.dart` | Base decorator interface |
| `lib/src/components/decorators/health_bar_component.dart` | HP bar above entity |
| `lib/src/components/decorators/selection_ring_component.dart` | Selection border/ring |
| `lib/src/components/decorators/team_border_component.dart` | Team-colored glow |
| `lib/src/components/decorators/status_icon_component.dart` | Buff/debuff icons |
| `lib/src/components/effects/floating_text_component.dart` | Damage popup effect |
| `lib/src/input/input_manager.dart` | Input blocking state |
| `lib/src/input/tap_resolver.dart` | Screen coords -> GridPosition |
| `lib/src/animation/animation_queue.dart` | Sequential animation execution |
| `lib/src/animation/sprite_animation_config.dart` | Sprite sheet configuration |
| `lib/src/components/sprites/animated_entity_component.dart` | Entity with sprite sheet animation |
| `lib/src/pathfinding/grid_graph.dart` | Graph adapter for tile grid |
| `lib/src/pathfinding/pathfinder.dart` | A* shortest path |
| `lib/src/pathfinding/movement_range.dart` | BFS reachable tiles |

---

## Phase Implementation Details

### Phase 1: Foundation -- Grid & Coordinate System (Tasks 1-6)

**Goal:** Core data structures that everything else builds on. Pure data models first.

**Step 1.1: `GridPosition`** (`lib/src/grid/grid_position.dart`)

```dart
/// Integer grid coordinate. Replaces Vector2 for all public API methods.
class GridPosition {
  final int x;
  final int y;
  const GridPosition(this.x, this.y);

  bool isValidFor(int width, int height);
  List<GridPosition> getAdjacent({bool includeDiagonals = false});
  int manhattanDistanceTo(GridPosition other);
  double euclideanDistanceTo(GridPosition other);
  String get notation; // "A1" style
  GridPosition operator +(GridPosition other);
  GridPosition operator -(GridPosition other);
  // equality, hashCode, toString
}
```

Design: NOT hardcoded to 8x8. `const` constructor. `Comparable<GridPosition>`. No game-specific methods.

**Step 1.2: `TileType`** (`lib/src/grid/tile_type.dart`)

```dart
class TileType {
  final String id;
  final String? asset;       // sprite asset path (null = solid color)
  final Color? color;        // fallback color if no asset
  final bool walkable;
  final double movementCost; // default 1.0
  final Map<String, dynamic>? metadata;
  const TileType({...});
}
```

**Step 1.3: `TileGrid`** (`lib/src/grid/tile_grid.dart`)

```dart
class TileGrid {
  final int width;
  final int height;

  void setTile(GridPosition position, TileType type);
  TileType? getTile(GridPosition position);
  void fill(TileType type);
  void fillRect(GridPosition topLeft, int w, int h, TileType type);
  void fillCheckerboard(TileType a, TileType b);
  bool isValid(GridPosition position);
  bool isWalkable(GridPosition position);
  List<GridPosition> getWalkableNeighbors(GridPosition position, {bool diagonals = false});
  Iterable<GridPosition> get allPositions;
}
```

**Step 1.4: `TileComponent`** (internal, NOT exported)

Flame component rendering a single tile sprite. Cached sprite, positioned by grid coordinates.

**Step 1.5: `TileGridComponent`** (internal, NOT exported)

Manages full grid of `TileComponent` children. Handles grid rebuilds when tiles change.

**Step 1.6: `CoordinateAdapter`** (internal utility)

```dart
class CoordinateAdapter {
  static Vector2 gridToPixel(GridPosition pos, double tileSize, double worldHeight);
  static GridPosition pixelToGrid(Vector2 pixel, double tileSize, double worldHeight);
}
```

**CRITICAL DECISION (Monarch-approved): Unified top-down coordinates** (0,0 = top-left) for BOTH the old room system and new tile grid. Remove the Y-flip from `FiftyBaseComponent.onLoad()`. Update example app entity positions accordingly. One coordinate system, zero conversion tax.

---

### Phase 2: Overlay System (Tasks 7-10)

**Step 2.1: Overlay models** (`lib/src/grid/tile_overlay.dart`)

```dart
class TileOverlay {
  final Color color;
  final double opacity;
  final String? group; // for batch clear
  const TileOverlay({...});
}

class HighlightStyle {
  static const TileOverlay validMove = TileOverlay(color: Color(0xFF4CAF50), opacity: 0.4, group: 'validMoves');
  static const TileOverlay attackRange = TileOverlay(color: Color(0xFFF44336), opacity: 0.4, group: 'attackRange');
  static const TileOverlay abilityTarget = TileOverlay(color: Color(0xFF9C27B0), opacity: 0.3, group: 'abilityTarget');
  static const TileOverlay selection = TileOverlay(color: Color(0xFFFFC107), opacity: 0.5, group: 'selection');
  static const TileOverlay danger = TileOverlay(color: Color(0xFFFF5722), opacity: 0.3, group: 'danger');
  static TileOverlay custom({required Color color, double opacity = 0.4, String? group});
}
```

**Step 2.2: `TileOverlayComponent`** (internal) - colored rectangle above tile, below entities.

**Step 2.3: `OverlayManager`** (internal) - batch add/remove/clear by group.

**Step 2.4: Wire into `FiftyMapController`**

```dart
void highlightTiles(List<GridPosition> positions, TileOverlay style);
void clearHighlights({String? group});
void setSelection(GridPosition? position);
```

---

### Phase 3: Input Fix & Tile Taps (Tasks 11-15)

**Step 3.1:** Fix `onLongTapDown` -> `onTapDown` in `component.dart`. Add input blocking guard.

**Step 3.2: `InputManager`** (`lib/src/input/input_manager.dart`)

```dart
class InputManager {
  bool get isBlocked;
  void block();
  void unblock();
  VoidCallback? onUnblocked;
}
```

**Step 3.3: `TapResolver`** (`lib/src/input/tap_resolver.dart`)

Resolves screen coords -> GridPosition, accounting for camera transform.

**Step 3.4:** Add `grid` and `onTileTap` to `FiftyMapWidget`.

**Step 3.5:** Override `onTapDown` at `FiftyMapBuilder` level for global tile tap handling.

---

### Phase 4: Entity Decorators (Tasks 16-21)

**Step 4.1:** `EntityDecorator` base class - child components of entity, auto-move with entity.

**Step 4.2:** `HealthBarComponent` - colored bar above entity, dynamic width from HP ratio.

**Step 4.3:** `SelectionRingComponent` - colored border/ring around selected entity.

**Step 4.4:** `TeamBorderComponent` - team-colored glow/border.

**Step 4.5:** `StatusIconComponent` - small sprite icons for buffs/debuffs.

**Step 4.6:** Wire into `FiftyMapController`:

```dart
void addDecorator(String entityId, EntityDecoratorConfig config);
void removeDecorator(String entityId, String decoratorType);
void updateHP(String entityId, double ratio);
void setSelected(String entityId, {bool selected = true, Color? color});
void setTeamColor(String entityId, Color color);
void addStatusIcon(String entityId, String iconAsset);
void removeStatusIcon(String entityId, String iconAsset);
```

---

### Phase 5: Animation & Effects (Tasks 22-25)

**Step 5.1:** `FloatingTextComponent` - rises upward, fades out, self-removes.

**Step 5.2: `AnimationQueue`** (`lib/src/animation/animation_queue.dart`)

```dart
class AnimationQueue {
  void enqueue(AnimationEntry entry);
  void enqueueAll(List<AnimationEntry> entries);
  void cancel();
  bool get isRunning;
}

class AnimationEntry {
  final Future<void> Function() execute;
  final Duration duration;
  final VoidCallback? onComplete;
}
```

When queue starts: `inputManager.block()`. When queue empties: `inputManager.unblock()`.

**Step 5.3:** Improve attack animation - lunge toward target + return (not just scale bounce).

**Step 5.4:** Wire into `FiftyMapController`:

```dart
void showFloatingText(GridPosition position, String text, {Color? color, double? fontSize, Duration? duration});
void queueAnimation(AnimationEntry entry);
void queueAnimations(List<AnimationEntry> entries);
void cancelAnimations();
bool get isAnimating;
```

---

### Phase 6: Sprite Animation (Tasks 26-30)

**Step 6.1: `SpriteAnimationConfig`** (`lib/src/animation/sprite_animation_config.dart`)

```dart
class SpriteAnimationConfig {
  final String spriteSheetAsset;
  final int frameWidth;
  final int frameHeight;
  final Map<String, SpriteAnimationStateConfig> states;
  final String defaultState;
}

class SpriteAnimationStateConfig {
  final int startFrame;
  final int frameCount;
  final double stepTime;
  final bool loop;
}
```

**Step 6.2:** `AnimatedEntityComponent` - extends `SpriteAnimationComponent` (parallel to `FiftyMovableComponent`, NOT extending it).

**Step 6.3:** Simple string-based state machine (idle -> walk -> attack -> idle).

**Step 6.4:** `FiftyAssetLoader` - sprite sheets are just images, no code change needed in `loadAll`.

**Step 6.5:** Add optional `SpriteAnimationConfig? spriteAnimation` to `FiftyMapEntity`. Update `FiftyEntitySpawner` to create `AnimatedEntityComponent` when non-null.

---

### Phase 7: Pathfinding (Tasks 31-34)

**Step 7.1: `GridGraph`** - adapter from TileGrid to graph with walkability and costs.

**Step 7.2: `Pathfinder`** - A* with Manhattan/Chebyshev heuristic. Returns `List<GridPosition>?`.

**Step 7.3: `MovementRange`** - BFS within movement budget. Returns `Set<GridPosition>`.

**Step 7.4:** Wire into `FiftyMapController`:

```dart
List<GridPosition>? findPath(GridPosition from, GridPosition to, {Set<GridPosition>? blocked, bool diagonal = false});
Set<GridPosition> getMovementRange(GridPosition from, double budget, {Set<GridPosition>? blocked, bool diagonal = false});
```

---

### Phase 8: API Cleanup & Integration (Tasks 35-39)

- Deprecate (don't remove) `Vector2` re-export with `@Deprecated` annotation
- Add `FiftyMapEntity.fromGrid()` factory accepting `GridPosition`
- Export all new public classes, NOT internal Flame components
- Verify both modes work (legacy room mode + new grid mode)
- Update existing example to compile
- Create new grid-based example page

---

### Phase 9: Testing (Tasks 40-49)

**Unit tests (pure Dart, no Flame):**
- GridPosition (10+ tests)
- TileGrid (8+ tests)
- TileOverlay (4+ tests)
- OverlayManager (6+ tests)
- InputManager (5+ tests)
- AnimationQueue (5+ tests)
- Pathfinder A* (6+ tests)
- BFS MovementRange (6+ tests)
- EntityDecorator configs (5+ tests)
- SpriteAnimationConfig (4+ tests)

**Integration tests:**
- FiftyMapWidget with grid parameter
- FiftyMapWidget without grid (legacy)
- onTileTap fires

**Regression:**
- All existing 390-line tests pass
- `flutter analyze` zero issues

---

## Phase Dependencies

```
Phase 1 (Foundation) ─────┬──> Phase 2 (Overlays)
                          ├──> Phase 3 (Input) ──> Phase 5 (Animation) [blocking wire-up]
                          ├──> Phase 4 (Decorators)
                          ├──> Phase 7 (Pathfinding)
                          └──> Phase 6 (Sprites)

All features ──> Phase 8 (Cleanup) ──> Phase 9 (Testing)
```

**Phases 2, 3, 4, 6, 7 can start in parallel** after Phase 1.

**Recommended order:** 1 -> 3 -> 2 -> 5 -> 4 -> 7 -> 6 -> 8 -> 9

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Removing `Vector2` re-export breaks consumers | HIGH | HIGH | Deprecate, don't remove. Add `@Deprecated`. Provide `FiftyMapEntity.fromGrid()`. |
| `onLongTapDown` -> `onTapDown` breaks long-press consumers | MEDIUM | MEDIUM | Intentional fix per brief. Document in CHANGELOG. |
| ~~Y-axis confusion~~ | ~~HIGH~~ | ~~HIGH~~ | **ELIMINATED.** Monarch approved unifying to top-down. Remove Y-flip from old room system. One coordinate system. |
| `AnimatedEntityComponent` inheritance conflict with `SpriteComponent` | MEDIUM | MEDIUM | Create as parallel class extending `SpriteAnimationComponent`, NOT extending `FiftyMovableComponent`. |
| Performance with 64 tiles + overlays + entities + decorators | LOW | HIGH | Lightweight cached sprites. Profile after Phase 2. Batch-draw fallback if needed. |

---

## Key Architecture Decisions

1. **Unified top-down coordinate system.** (0,0 = top-left) for everything. Y-flip removed from old room system. No `CoordinateAdapter` needed.
2. **`GridPosition` is the public coordinate type.** `Vector2` internal only.
3. **Internal vs Public API boundary.** Flame components NEVER exported. Public API is pure Dart.
4. **Decorator pattern.** Decorators are child components of entity. Auto-move with entity.
5. **AnimationQueue owns input blocking.** Single source of truth.
6. **FiftyEntitySpawner extended.** Creates `AnimatedEntityComponent` when `spriteAnimation` is non-null.
7. **TileGrid is pure data.** No rendering logic. `TileGridComponent` (internal) handles rendering.

---

**Plan Created:** 2026-02-10
**Status:** Awaiting Monarch Approval
