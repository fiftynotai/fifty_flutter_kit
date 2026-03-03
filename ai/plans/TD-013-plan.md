# Implementation Plan: TD-013

**Complexity:** M
**Estimated Duration:** 3-4 hours
**Risk Level:** Low

---

## Summary

Rewrite `packages/fifty_world_engine/README.md` to document the tile-based tactical grid layer
alongside the existing entity/room system. The entity system documentation is good and stays largely
intact. Six new sections are added covering the tile, overlay, pathfinding, animation, decorator,
and input APIs.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_world_engine/README.md` | MODIFY | Rewrite per plan below |

---

## Pre-Read Requirement for FORGER

Before writing a single line of the new README, FORGER MUST read these source files:

| Source File | Sections it feeds |
|-------------|-------------------|
| `lib/fifty_world_engine.dart` | Public API boundary — what is exported vs internal |
| `lib/src/grid/tile_grid.dart` | Tile Grid section |
| `lib/src/grid/tile_type.dart` | Tile Grid section |
| `lib/src/grid/grid_position.dart` | Tile Grid section |
| `lib/src/grid/tile_overlay.dart` | Tile Overlays section |
| `lib/src/components/overlays/overlay_manager.dart` | Tile Overlays section |
| `lib/src/pathfinding/pathfinder.dart` | Pathfinding section |
| `lib/src/pathfinding/grid_graph.dart` | Pathfinding section |
| `lib/src/pathfinding/movement_range.dart` | Pathfinding section |
| `lib/src/animation/animation_queue.dart` | Animation Queue section |
| `lib/src/animation/sprite_animation_config.dart` | Animation Queue section |
| `lib/src/input/input_manager.dart` | Input section (controller API) |
| `lib/src/controller/controller.dart` | Full controller API (v2 methods) |
| `lib/src/view/widget.dart` | Widget section (grid mode params) |

---

## Updated "Why fifty_world_engine" Bullets

Replace the current 4 bullets with these 7:

```
- **Game-ready grid maps without custom renderers** -- Sprite tiles, entity hierarchy,
  pan/zoom, and tap callbacks built on Flame; no raw canvas work needed.
- **Design data, not code** -- Define maps as JSON and load them with FiftyWorldLoader;
  level designers work in data, not Dart.
- **A* pathfinding out of the box** -- GridGraph + Pathfinder give you shortest-path
  navigation with diagonal support; MovementRange computes BFS reachable tiles in one call.
- **Layered tile highlighting** -- HighlightStyle presets (validMove, attackRange, selection)
  and group-based batch clearing make tactical UI state trivial to manage.
- **Sequential animation with input blocking** -- AnimationQueue executes async entries
  in order and automatically gates tap input while animations run.
- **Extend entity types in one call** -- FiftyEntitySpawner.register() adds any custom
  game entity type without modifying engine source.
- **Safe controller pattern** -- FiftyWorldController is a no-op until bound; call any
  method before the game loads without null guards.
```

---

## Complete New README Structure

The new README follows the gold-standard order:
badges -> tagline -> description -> image -> Why -> Installation -> Quick Start -> Architecture ->
Tile Grid System (NEW) -> Tile Overlays (NEW) -> Pathfinding (NEW) -> Animation Queue (NEW) ->
Entity Decorators (NEW) -> Customization -> API Reference (ENTITY — existing) ->
API Reference (TILE — NEW) -> Configuration -> Usage Patterns -> Platform -> FDL Integration -> Version

---

## Section-by-Section Content Outline

### Sections to Keep (verbatim or light edit)

**Badges, tagline, description blurb, screenshot table** — keep as-is.

**Installation** — keep as-is.

**Architecture** — keep existing ASCII diagram. Add a second diagram showing the tile layer:

```
TileGrid (data)
    |
    +-- TileGridComponent (Flame renderer) -- renders below entities
    |
    +-- OverlayManager (batch highlight/clear)
            |
            +-- TileOverlayComponent (per-tile colored rect)

FiftyWorldController (unified facade)
    |
    +-- highlightTiles / clearHighlights / setSelection  (overlay API)
    +-- findPath / getMovementRange                      (pathfinding API)
    +-- queueAnimation / cancelAnimations                (animation API)
    +-- updateHP / setSelected / setTeamColor / ...      (decorator API)
    +-- inputManager                                     (input blocking)
```

**Customization (custom entity types, JSON map loading)** — keep as-is.

**API Reference: FiftyWorldController** — EXTEND with new v2 methods (see below).

**API Reference: FiftyWorldBuilder / FiftyWorldWidget / FiftyWorldEntity / FiftyWorldEvent /
FiftyBlockSize / Entity Types / Event Types / Event Alignments / Component Classes / Services /
Extensions** — keep as-is.

**Configuration (FiftyWorldConfig, FiftyRenderPriority, Map JSON Format)** — keep as-is.
Add one line under FiftyRenderPriority for `tileGrid` and `tileOverlay` priorities.

**Usage Patterns (existing 4 patterns)** — keep as-is.

**Best Practices, Platform Support, FDL Integration, Version, License** — keep as-is.

---

### NEW Section: Tile Grid System

Position: immediately after the Architecture section.

**Content outline:**

Intro sentence: Two-sentence description of what TileGrid is (pure data, top-down 0,0 = top-left).

**TileType snippet** (show const constructor with id/asset/color/walkable/movementCost):
```dart
// Sprite-based tile
const TileType grass = TileType(
  id: 'grass',
  asset: 'tiles/grass.png',
  walkable: true,
  movementCost: 1.0,
);

// Color-based tile (no asset needed)
const TileType wall = TileType(
  id: 'wall',
  color: Color(0xFF444444),
  walkable: false,
);
```

**TileGrid construction snippet** (show TileGrid + fill, fillRect, fillCheckerboard, setTile, isWalkable, allPositions):
```dart
final grid = TileGrid(width: 10, height: 8);
grid.fill(grass);                                    // fill entire grid
grid.fillRect(GridPosition(0, 0), 3, 3, wall);      // 3x3 wall block
grid.setTile(GridPosition(5, 3), TileType(id: 'water', walkable: false));

// Query
grid.getTile(GridPosition(2, 1));   // TileType?
grid.isWalkable(GridPosition(2, 1)); // bool
```

**GridPosition snippet** (show constructor, zero, arithmetic, getAdjacent, distances, notation):
```dart
const pos = GridPosition(3, 2);
pos + GridPosition(1, 0);    // GridPosition(4, 2)
pos.manhattanDistanceTo(GridPosition(0, 0)); // 5
pos.getAdjacent();           // 4 cardinal neighbors
pos.getAdjacent(includeDiagonals: true); // 8 neighbors
pos.notation;                // 'D3'
pos.isValidFor(10, 8);       // true
```

**Passing the grid to the widget** (one snippet):
```dart
FiftyWorldWidget(
  grid: grid,
  controller: controller,
  onEntityTap: (entity) { ... },
  onTileTap: (GridPosition pos) {
    print('Tapped tile: $pos');
  },
);
```

Note about coordinate system: TileGrid uses top-down (0,0 = top-left); the Entity Layer uses
bottom-left origin (they are separate coordinate spaces).

---

### NEW Section: Tile Overlays

Position: after Tile Grid System.

**Content outline:**

Intro: Two sentences. Overlays are semi-transparent colored rects rendered above tiles but below
entities. Use groups for batch clearing.

**HighlightStyle presets table:**

| Preset | Color | Opacity | Group |
|--------|-------|---------|-------|
| `HighlightStyle.validMove` | Green `#4CAF50` | 0.4 | `'validMoves'` |
| `HighlightStyle.attackRange` | Red `#F44336` | 0.4 | `'attackRange'` |
| `HighlightStyle.abilityTarget` | Purple `#9C27B0` | 0.3 | `'abilityTarget'` |
| `HighlightStyle.selection` | Yellow `#FFC107` | 0.5 | `'selection'` |
| `HighlightStyle.danger` | Orange-red `#FF5722` | 0.3 | `'danger'` |

**Usage snippet** (highlight, selection, clear group, clear all):
```dart
// Highlight reachable tiles (batch)
controller.highlightTiles(reachableTiles, HighlightStyle.validMove);

// Set selected tile (clears previous selection automatically)
controller.setSelection(GridPosition(3, 4));
controller.setSelection(null);  // deselect

// Clear a specific group
controller.clearHighlights(group: 'validMoves');

// Clear everything
controller.clearHighlights();
```

**Custom overlay** (show TileOverlay + HighlightStyle.custom):
```dart
final custom = HighlightStyle.custom(
  color: Color(0xFF2196F3),
  opacity: 0.35,
  group: 'aoeBlast',
);
controller.highlightTiles(blastTiles, custom);
controller.clearHighlights(group: 'aoeBlast');
```

Design note: multiple overlays can be stacked on the same tile (e.g., validMove + selection).

---

### NEW Section: Pathfinding

Position: after Tile Overlays.

**Content outline:**

Intro: Two sentences. Uses A* with Manhattan heuristic (4-dir) or Chebyshev (8-dir with diagonals).
Respects tile walkability and per-tile movement costs.

**findPath snippet via controller:**
```dart
final path = controller.findPath(
  GridPosition(0, 0),
  GridPosition(7, 5),
  grid: grid,
  blocked: occupiedPositions,  // optional: entity positions
  diagonal: false,
);
// path is List<GridPosition>? -- null if unreachable
if (path != null) {
  for (final step in path) {
    print(step.notation);  // e.g. 'A1', 'B2', ...
  }
}
```

**getMovementRange snippet via controller:**
```dart
final reachable = controller.getMovementRange(
  unitPosition,
  budget: 3.0,          // movement points
  grid: grid,
  blocked: enemyPositions,
);
// reachable is Set<GridPosition>
controller.highlightTiles(reachable.toList(), HighlightStyle.validMove);
```

**Direct API usage** (show GridGraph + Pathfinder + MovementRange directly for advanced use):
```dart
// Build a graph with custom blocked set and diagonal movement
final graph = GridGraph(
  grid: grid,
  blocked: {GridPosition(3, 3), GridPosition(4, 3)},
  diagonal: true,
);

// A* -- returns null if no path
final path = Pathfinder.findPath(
  start: GridPosition(1, 1),
  goal: GridPosition(8, 6),
  graph: graph,
);

// BFS movement range -- returns Map<GridPosition, double> of pos -> cost
final rangeMap = MovementRange.calculate(
  start: GridPosition(2, 2),
  budget: 4.0,
  graph: graph,
);
final positionsOnly = MovementRange.reachable(
  start: GridPosition(2, 2),
  budget: 4.0,
  graph: graph,
);
```

Movement cost note: each `TileType` has a `movementCost` (default 1.0). Diagonal steps are
multiplied by sqrt(2) (~1.414). A tile with `movementCost: 2.0` (swamp) costs 2 points to enter.

---

### NEW Section: Animation Queue

Position: after Pathfinding.

**Content outline:**

Intro: Two sentences. AnimationQueue runs async entries sequentially and fires onStart/onComplete
for input blocking integration.

**AnimationEntry + AnimationQueue via controller:**
```dart
// Queue a move + damage pop sequence
controller.queueAnimation(AnimationEntry(
  execute: () async {
    controller.move(hero, 4.0, 3.0);
    await Future<void>.delayed(const Duration(milliseconds: 400));
  },
));
controller.queueAnimation(AnimationEntry.timed(
  action: () => controller.showFloatingText(
    GridPosition(4, 3), '-12', color: Color(0xFFFF4444),
  ),
  duration: Duration(milliseconds: 800),
));
// Input is automatically blocked until all entries complete
```

**AnimationEntry.timed factory:**
```dart
// Synchronous action + fixed wait duration
final entry = AnimationEntry.timed(
  action: () { /* do sync thing */ },
  duration: Duration(milliseconds: 500),
  onComplete: () => print('entry done'),
);
```

**isAnimating check (for input guards in game code):**
```dart
void onTileTap(GridPosition pos) {
  if (controller.isAnimating) return;  // ignore taps during animation
  // ... handle tap
}
```

**Cancel:**
```dart
controller.cancelAnimations();  // clears pending entries, current finishes
```

**InputManager direct access** (for cases where game code needs to check block state):
```dart
// The controller exposes the input manager directly if needed
controller.inputManager.isBlocked; // bool
controller.inputManager.onUnblocked = () => refreshUI();
```

---

### NEW Section: Entity Decorators

Position: after Animation Queue.

**Content outline:**

Intro: One sentence. Decorators are child components attached to entity components at runtime --
HP bars, selection rings, team color borders, status icons.

**updateHP:**
```dart
// Add or update an HP bar (ratio: 0.0 to 1.0)
controller.updateHP('hero', 0.75);
controller.updateHP('goblin', 0.3, color: Color(0xFFFF0000));
```

**setSelected:**
```dart
controller.setSelected('hero', selected: true);
controller.setSelected('hero', selected: false);  // removes ring
```

**setTeamColor:**
```dart
controller.setTeamColor('hero', Color(0xFF2196F3));    // blue team
controller.setTeamColor('goblin', Color(0xFFF44336));  // red team
```

**addStatusIcon / removeDecorators:**
```dart
controller.addStatusIcon('hero', 'P', color: Color(0xFF9C27B0)); // poisoned
controller.removeDecorators('hero');  // removes ALL decorators
```

**showFloatingText:**
```dart
controller.showFloatingText(
  GridPosition(3, 4),
  '-15',
  color: Color(0xFFFF4444),
  fontSize: 18.0,
  duration: 1.2,   // seconds
);
```

---

### Extensions to Existing API Reference Section

**FiftyWorldController** — add a "v2 Tile Methods" subsection after the existing camera section:

```dart
/// Tile Highlights
controller.highlightTiles(positions, overlay);       // add overlay at multiple tiles
controller.clearHighlights();                        // clear all overlays
controller.clearHighlights(group: 'validMoves');     // clear one group
controller.setSelection(pos);                        // yellow selection; null to deselect

/// Pathfinding
controller.findPath(from, to, grid: grid);           // A* -> List<GridPosition>?
controller.getMovementRange(from, budget: 3.0, grid: grid); // BFS -> Set<GridPosition>

/// Animation Queue
controller.queueAnimation(entry);                   // enqueue one entry
controller.queueAnimations(entries);                // enqueue multiple entries
controller.cancelAnimations();                      // clear pending
controller.isAnimating;                             // bool getter
controller.inputManager;                            // InputManager instance

/// Entity Decorators
controller.updateHP(entityId, ratio, color: ...);  // add/update HP bar
controller.setSelected(entityId, selected: true);  // selection ring
controller.setTeamColor(entityId, color);           // team border
controller.addStatusIcon(entityId, label, color: ...); // status icon
controller.removeDecorators(entityId);              // remove all decorators

/// Floating Text
controller.showFloatingText(pos, text, color: ..., fontSize: ..., duration: ...);
```

**FiftyWorldWidget** — add grid-mode parameters to the existing snippet:

```dart
FiftyWorldWidget(
  controller: controller,
  initialEntities: entities,           // optional entity layer
  onEntityTap: (entity) { ... },
  grid: grid,                          // optional tile grid
  onTileTap: (GridPosition pos) { ... }, // fires when any tile is tapped
);
```

Note: When `grid` is provided, `FiftyWorldWidget` operates in grid mode. `onTileTap` only fires
in grid mode. Both entity and grid layers can be active simultaneously.

**FiftyRenderPriority** table — add the missing tile priorities:

| Priority | Value | Description |
|----------|-------|-------------|
| `tileGrid` | (internal) | Tile grid layer (below entities) |
| `tileOverlay` | (internal) | Overlay highlights (above tiles, below entities) |
| `decorator` | (internal) | Entity decorator overlays (HP bars, rings, etc.) |

---

### NEW Section: Quick Start for Tile Mode

The existing Quick Start covers entity mode. Add a second code block titled "Tile Grid Quick Start":

```dart
import 'package:fifty_world_engine/fifty_world_engine.dart';

// 1. Register tile assets (if using sprite tiles)
FiftyAssetLoader.registerAssets([
  'tiles/grass.png',
  'tiles/water.png',
]);

// 2. Build your grid
final grid = TileGrid(width: 8, height: 8);
grid.fill(TileType(id: 'grass', asset: 'tiles/grass.png'));
grid.fillRect(GridPosition(2, 2), 2, 2,
    TileType(id: 'water', asset: 'tiles/water.png', walkable: false));

// 3. Create controller and widget
final controller = FiftyWorldController();

FiftyWorldWidget(
  grid: grid,
  controller: controller,
  onEntityTap: (entity) { },
  onTileTap: (GridPosition pos) {
    if (controller.isAnimating) return;
    final reachable = controller.getMovementRange(
      selected, budget: 3.0, grid: grid,
    );
    controller.clearHighlights();
    controller.highlightTiles(reachable.toList(), HighlightStyle.validMove);
    controller.setSelection(pos);
  },
);

// 4. Find a path and queue movement
final path = controller.findPath(from, to, grid: grid);
if (path != null) {
  for (final step in path.skip(1)) {
    controller.queueAnimation(AnimationEntry(
      execute: () async {
        controller.move(heroEntity, step.x.toDouble(), step.y.toDouble());
        await Future.delayed(Duration(milliseconds: 300));
      },
    ));
  }
}
```

---

### NEW Usage Pattern: Full Turn Sequence

Add a fifth Usage Pattern block after the existing four:

```dart
// Turn sequence: select -> show moves -> tap destination -> animate path
FiftyWorldEntity? _selected;

void onEntityTap(FiftyWorldEntity entity) {
  if (controller.isAnimating) return;
  _selected = entity;
  final from = GridPosition(
    entity.gridPosition.x.toInt(),
    entity.gridPosition.y.toInt(),
  );
  final reachable = controller.getMovementRange(
    from, budget: 4.0, grid: grid,
  );
  controller.clearHighlights();
  controller.highlightTiles(reachable.toList(), HighlightStyle.validMove);
  controller.setSelection(from);
}

void onTileTap(GridPosition pos) {
  if (controller.isAnimating || _selected == null) return;
  final from = GridPosition(
    _selected!.gridPosition.x.toInt(),
    _selected!.gridPosition.y.toInt(),
  );
  final path = controller.findPath(from, pos, grid: grid);
  if (path == null) return;

  controller.clearHighlights();

  for (final step in path.skip(1)) {
    final entity = _selected!;
    controller.queueAnimation(AnimationEntry(
      execute: () async {
        controller.move(entity, step.x.toDouble(), step.y.toDouble());
        await Future.delayed(Duration(milliseconds: 300));
      },
    ));
  }
  // Show damage float at destination
  controller.queueAnimation(AnimationEntry.timed(
    action: () => controller.showFloatingText(pos, 'Move!'),
    duration: Duration(milliseconds: 600),
  ));
}
```

---

### NEW Usage Pattern: Sprite Sheet Animations

Add a sixth Usage Pattern covering `SpriteAnimationConfig`:

```dart
// Define sprite sheet layout
const heroAnim = SpriteAnimationConfig(
  spriteSheetAsset: 'characters/hero_sheet.png',
  frameWidth: 32,
  frameHeight: 32,
  states: {
    'idle':   SpriteAnimationStateConfig(row: 0, frameCount: 4),
    'walk':   SpriteAnimationStateConfig(row: 1, frameCount: 6),
    'attack': SpriteAnimationStateConfig(row: 2, frameCount: 4, loop: false),
    'die':    SpriteAnimationStateConfig(row: 3, frameCount: 4, loop: false),
  },
  defaultState: 'idle',
);
```

Note: `SpriteAnimationConfig` is a data class. The engine reads it when building animated entity
components. Associate it with an entity via `FiftyWorldEntity.metadata` and implement a custom
spawner component that reads it from there.

---

## Public API Inventory (for FORGER's reference)

### Exported public classes and what they do

| Class | Exported | Purpose |
|-------|----------|---------|
| `TileGrid` | YES | 2D grid data (width, height, setTile, getTile, fill, fillRect, fillCheckerboard, isWalkable, allPositions) |
| `TileType` | YES | Tile definition (id, asset?, color?, walkable, movementCost, metadata?) |
| `GridPosition` | YES | Integer coordinate (x, y, zero, +, -, getAdjacent, manhattanDistanceTo, euclideanDistanceTo, notation, isValidFor) |
| `TileOverlay` | YES | Overlay data (color, opacity, group?) |
| `HighlightStyle` | YES | Preset overlays + `custom()` factory |
| `GridGraph` | YES | Graph adapter (grid, blocked, diagonal, neighbors, cost) |
| `Pathfinder` | YES | A* static class -- `findPath()` |
| `MovementRange` | YES | BFS static class -- `calculate()`, `reachable()` |
| `AnimationQueue` | YES | Sequential executor (enqueue, enqueueAll, cancel, isRunning, length) |
| `AnimationEntry` | YES | Entry data class (execute, onComplete, `.timed()` factory) |
| `SpriteAnimationConfig` | YES | Sprite sheet config (asset, frameWidth, frameHeight, states, defaultState) |
| `SpriteAnimationStateConfig` | YES | Per-state config (row, frameCount, stepTime, loop) |
| `InputManager` | YES | Input block state (isBlocked, block, unblock, onUnblocked) |
| `FiftyTileTapCallback` | YES (via widget.dart) | typedef `void Function(GridPosition)` |
| `CoordinateAdapter` | NO (internal) | Do NOT document in public API |
| `TapResolver` | NO (internal) | Do NOT document in public API |
| `TileComponent` | NO (internal) | Do NOT document |
| `TileGridComponent` | NO (internal) | Do NOT document |
| `TileOverlayComponent` | NO (internal) | Do NOT document |
| `OverlayManager` | NO (internal) | Do NOT document as standalone; expose via controller only |
| `EntityDecorator` | NO | Only document via controller methods |
| Decorator subclasses | NO | Same -- controller API only |
| `FloatingTextComponent` | NO | Same -- `showFloatingText` only |

### Controller v2 method groupings (for API Reference subsection)

**Overlay:** `highlightTiles`, `clearHighlights`, `setSelection`
**Pathfinding:** `findPath`, `getMovementRange`
**Animation:** `queueAnimation`, `queueAnimations`, `cancelAnimations`, `isAnimating`, `inputManager`
**Decorators:** `updateHP`, `setSelected`, `setTeamColor`, `addStatusIcon`, `removeDecorators`
**Effects:** `showFloatingText`

---

## Testing Strategy

This is a documentation-only change. No automated tests needed.

Manual verification checklist for FORGER:
- [ ] Every code snippet compiles against exported public API only (no internals)
- [ ] `GridPosition` uses integer constructor `GridPosition(x, y)` not `Vector2`
- [ ] `TileGrid` uses top-down coordinate language (0,0 = top-left), not bottom-left
- [ ] `controller.move()` uses `double` args (existing entity API) not `GridPosition`
- [ ] `FiftyWorldWidget.onTileTap` typedef is `FiftyTileTapCallback = void Function(GridPosition)`
- [ ] The `OverlayManager` is not mentioned as a direct-use class (it's internal)
- [ ] `CoordinateAdapter` and `TapResolver` are not mentioned (internal)
- [ ] `centerMap` signature in controller shows `animate:` and `duration:` params (they were added in v2)

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Code snippets reference non-exported internals | Low | Medium | Use the Public API Inventory table above as a whitelist |
| Entity coordinate system confused with TileGrid coordinate system | Medium | Medium | Explicit note in Architecture and Tile Grid sections about the two separate systems |
| Incorrect method signatures (e.g. missing params) | Low | Low | FORGER must read controller.dart before writing the API Reference extension |
| README becomes too long | Low | Low | Keep existing sections trimmed; no duplication between new and old Quick Start |

---

## Notes for FORGER

- The `SpriteAnimationConfig` usage pattern is speculative (the engine doesn't auto-wire it to
  entities yet). Write it as a "configuration data class" section, not as a fully wired workflow.
  Show the data class only. Do not imply the engine reads it automatically.
- `controller.move()` takes `double x, double y` (entity grid coords as doubles) -- NOT a
  `GridPosition`. This is the existing entity-layer API and stays as-is.
- `TileGrid` uses top-down (0,0 = top-left), while `FiftyWorldEntity.gridPosition` uses bottom-left
  (0,0 = bottom-left). Document both conventions clearly so consumers understand they are distinct.
- `InputManager` is exported (it's in the barrel). Document it in the Animation Queue section as
  the mechanism for input blocking, accessible via `controller.inputManager`.
- `FiftyTileTapCallback` is defined in `widget.dart` and re-exported from the barrel. Document it
  as a typedef in the Widget section.
- The Vector2 re-export is marked `@Deprecated` in the barrel. Do not encourage its use in any
  new code snippets. Use `GridPosition` for tile coordinates throughout.
