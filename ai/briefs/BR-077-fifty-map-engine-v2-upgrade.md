# BR-077: fifty_map_engine v2 - Grid Game Toolkit Upgrade

**Type:** Feature
**Priority:** P1-High
**Effort:** XL-Extra Large (>1w)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-10
**Completed:**

---

## Problem

**What's broken or missing?**

`fifty_map_engine` was built as a dungeon crawler room navigator. It handles rooms, characters moving between rooms, and a camera. But it has **no concept of tiles as first-class citizens** and cannot support grid-based games (tactical, board, puzzle, chess-like).

Current critical gaps:
1. **No tile system** - No `TileComponent`, no tile layers, no tile types. Zero concept of individual tiles.
2. **No tile overlays/highlights** - No way to dynamically color tiles (valid moves, attack range, selection).
3. **Tap uses long-press (0.5s)** - `onLongTapDown` instead of `onTapDown`. Unplayable for any game.
4. **Can't tap empty tiles** - No component = no hitbox = no event. Only entities are tappable.
5. **No entity decorators** - No HP bars, selection rings, team borders, status icons.
6. **No input blocking** - Taps process during animations.
7. **No floating text** - No damage popups or temporary text effects.
8. **No tile events** - No `onTileTap`, `onTileSelect` callbacks.
9. **No sprite animation** - Static PNGs only, no sprite sheets or frame-by-frame animation.
10. **API exposes Flame internals** - Users must understand Vector2, PositionComponent, FlameGame.

The tactical grid game (BR-071) was supposed to showcase this engine but couldn't use it. If the engine can't handle a simple 8x8 board game, it's not ready for anything.

**Why does it matter?**

- The engine is the flagship infrastructure package for all grid-based games in the Fifty ecosystem
- BR-076 (tactical grid migration) is blocked until this upgrade ships
- Every future game app (board games, puzzlers, strategy) depends on this being solid
- Current state makes the package essentially unusable for its intended purpose

---

## Goal

**What should happen after this brief is completed?**

`fifty_map_engine` becomes a complete grid game toolkit where:

1. Users think in **game terms** (tiles, grid positions, entities, highlights) - never in Flame terms
2. Flame is a **hidden implementation detail** - never imported by consumers
3. The engine handles **all visual infrastructure** for any grid-based game:
   - Tile rendering with layers (ground, overlay, entity, effects)
   - Entity management with decorators (HP, selection, status)
   - Input handling (instant tap on any tile, input blocking)
   - Animations (movement, attack, damage popups, sprite sheets, death)
   - Camera (pan, zoom, center, follow)
   - Pathfinding (A*, BFS movement range)
4. Existing room/dungeon-crawler functionality is **preserved** (additive, zero breaking changes)

**Target API feel:**
```dart
// User never imports Flame
final grid = TileGrid(width: 8, height: 8);
grid.setTile(GridPosition(3, 5), TileType(asset: 'grass', walkable: true, cost: 1));

controller.highlightTiles(validMoves, HighlightStyle.validMove);
controller.moveEntity(unit, to: GridPosition(4, 5));
controller.showFloatingText(position, "-3", color: Colors.red);

FiftyMapWidget(
  grid: grid,
  controller: controller,
  onTileTap: (pos) => handleTap(pos),
);
```

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine/` - the package itself

### Layers Touched
- [x] View (UI widgets) - FiftyMapWidget, new tile components
- [x] ViewModel (business logic) - FiftyMapController extensions
- [x] Service (data layer) - asset loader, map loader extensions
- [x] Model (domain objects) - TileGrid, TileType, GridPosition, entity decorators

### API Changes
- [x] New public API: Tile system, overlay system, decorator system, input system, animation queue, pathfinding, sprite animation
- [x] Modified: FiftyMapController (extended), FiftyMapWidget (new parameters), FiftyBaseComponent (tap fix)
- [x] No breaking changes to existing API

### Dependencies
- [x] Existing package: `flame: ^1.30.1` (internal, hidden from consumers)
- [x] No new external dependencies

### Related Files

**Package root:** `/packages/fifty_map_engine/`

**Files to modify:**
- `lib/fifty_map_engine.dart` - barrel export (add new public API)
- `lib/src/components/base/component.dart` - fix `onLongTapDown` → `onTapDown`
- `lib/src/views/map_widget.dart` - add `grid`, `onTileTap` parameters
- `lib/src/views/map_builder.dart` - add tile grid rendering, global tap handler
- `lib/src/services/map_controller.dart` - add tile/overlay/decorator/animation methods
- `lib/src/services/asset_loader.dart` - extend for sprite sheets
- `lib/src/models/entity.dart` - add decorator support, sprite animation config

**Files to create (new systems):**

Tile System:
- `lib/src/grid/tile_grid.dart` - 2D tile grid data structure
- `lib/src/grid/tile_type.dart` - tile type definitions (asset, walkable, cost, metadata)
- `lib/src/grid/grid_position.dart` - integer grid coordinate (replaces Vector2 for consumers)
- `lib/src/components/tiles/tile_component.dart` - Flame component for single tile
- `lib/src/components/tiles/tile_grid_component.dart` - renders full grid efficiently

Overlay System:
- `lib/src/grid/tile_overlay.dart` - overlay model (color, style, opacity)
- `lib/src/grid/highlight_style.dart` - preset styles (validMove, attackRange, abilityTarget, selection, danger)
- `lib/src/components/overlays/tile_overlay_component.dart` - Flame component for colored overlay
- `lib/src/components/overlays/overlay_manager.dart` - batch add/remove/clear overlays

Entity Decorators:
- `lib/src/components/decorators/health_bar_component.dart` - HP bar above entity
- `lib/src/components/decorators/selection_ring_component.dart` - selection border/ring
- `lib/src/components/decorators/status_icon_component.dart` - buff/debuff icons
- `lib/src/components/decorators/team_border_component.dart` - team-colored border/glow
- `lib/src/components/decorators/entity_decorator.dart` - base decorator, compose decorators on entities

Floating Text:
- `lib/src/components/effects/floating_text_component.dart` - damage popups, temporary text

Input System:
- `lib/src/input/input_manager.dart` - global input state, blocking, tile coordinate resolution
- `lib/src/input/tap_resolver.dart` - screen coords → grid position, handles camera transform

Animation System:
- `lib/src/animation/animation_queue.dart` - sequential animation execution with callbacks
- `lib/src/animation/sprite_animation_config.dart` - sprite sheet config (frames, fps, states)
- `lib/src/components/sprites/animated_entity_component.dart` - entity with sprite sheet animation

Pathfinding:
- `lib/src/pathfinding/pathfinder.dart` - A* shortest path
- `lib/src/pathfinding/movement_range.dart` - BFS reachable tiles within budget
- `lib/src/pathfinding/grid_graph.dart` - graph adapter for tile grid (respects walkability, cost)

---

## Constraints

### Architecture Rules
- **Additive only** - Existing room/entity API must continue working. Zero breaking changes.
- **Hide Flame** - Public API must NOT expose Flame types (Vector2, Component, FlameGame). Users import only `fifty_map_engine`.
- **GridPosition over Vector2** - All public methods use `GridPosition` (integer coordinates). Vector2 conversion is internal.
- **FDL compliance** - Default colors from `fifty_tokens` where applicable. Override parameters on all visual components.
- **Consume, don't define** - Follow engine package theming rules from coding_guidelines.md.

### Technical Constraints
- Must work on iOS, Android, Web, macOS
- Flame ^1.30.1 (current dependency, no version bump unless needed)
- Performance: 64-tile grid with 12 entities + overlays must render at 60fps
- Existing example app must still compile and run

### Out of Scope
- Game rules (turn management, combat resolution, win conditions)
- AI decision making
- Character progression / stats
- Hex grid and isometric grid (future briefs - architecture should support adding them)
- Fog of war (future brief - architecture should support it)
- Tiled Map Editor (.tmx) import (future brief)

---

## Tasks

### Pending

**Phase 1: Foundation - Grid & Coordinate System**
- [ ] Task 1: Create `GridPosition` class (integer x,y with helpers: isValid, adjacent, distance, notation)
- [ ] Task 2: Create `TileType` model (asset path, walkable, movement cost, metadata)
- [ ] Task 3: Create `TileGrid` data structure (2D array, get/set tiles, query methods)
- [ ] Task 4: Create `TileComponent` (Flame component rendering single tile sprite)
- [ ] Task 5: Create `TileGridComponent` (renders full grid, manages tile components)
- [ ] Task 6: Internal coordinate adapter (GridPosition ↔ Vector2, Y-axis handling)

**Phase 2: Overlay System**
- [ ] Task 7: Create `TileOverlay` model and `HighlightStyle` presets
- [ ] Task 8: Create `TileOverlayComponent` (colored rectangle with opacity)
- [ ] Task 9: Create `OverlayManager` (batch add/remove/clear by group, z-index layering)
- [ ] Task 10: Wire overlay methods into `FiftyMapController` (highlightTiles, clearHighlights, setSelection)

**Phase 3: Input Fix & Tile Taps**
- [ ] Task 11: Fix `onLongTapDown` → `onTapDown` in `FiftyBaseComponent` (instant tap)
- [ ] Task 12: Create `InputManager` with input blocking (isBlocked flag, lock/unlock)
- [ ] Task 13: Create `TapResolver` (screen coords → GridPosition, camera-aware)
- [ ] Task 14: Add `onTileTap` callback to `FiftyMapWidget` (fires for ANY tile, occupied or empty)
- [ ] Task 15: Wire input blocking into animation system (block on animate, unlock on complete)

**Phase 4: Entity Decorators**
- [ ] Task 16: Create `EntityDecorator` base (composable child components on entities)
- [ ] Task 17: Create `HealthBarComponent` (colored bar above entity, dynamic width from HP ratio)
- [ ] Task 18: Create `SelectionRingComponent` (border/ring around selected entity)
- [ ] Task 19: Create `TeamBorderComponent` (team-colored glow/border)
- [ ] Task 20: Create `StatusIconComponent` (small icons for buffs/debuffs)
- [ ] Task 21: Wire decorator methods into `FiftyMapController` (addDecorator, removeDecorator, updateHP)

**Phase 5: Animation & Effects**
- [ ] Task 22: Create `FloatingTextComponent` (damage popup: rise + fade + remove)
- [ ] Task 23: Create `AnimationQueue` (sequential execution: move → attack → damage, with completion callbacks)
- [ ] Task 24: Improve attack animation (lunge toward target + return, not just scale bounce)
- [ ] Task 25: Add `showFloatingText()` and `queueAnimation()` to `FiftyMapController`

**Phase 6: Sprite Animation**
- [ ] Task 26: Create `SpriteAnimationConfig` (sprite sheet path, frame count, fps, animation states map)
- [ ] Task 27: Create `AnimatedEntityComponent` (extends FiftyMovableComponent with sprite sheet cycling)
- [ ] Task 28: Add animation state machine (idle → walk → attack → idle, triggered by movement/actions)
- [ ] Task 29: Extend `FiftyAssetLoader` to preload sprite sheets
- [ ] Task 30: Extend `FiftyMapEntity` model with optional `spriteAnimation` config

**Phase 7: Pathfinding**
- [ ] Task 31: Create `GridGraph` adapter (tile grid → graph with walkability and costs)
- [ ] Task 32: Implement A* pathfinder (shortest path between two GridPositions)
- [ ] Task 33: Implement BFS movement range (all reachable tiles within movement budget)
- [ ] Task 34: Wire pathfinding into `FiftyMapController` (findPath, getMovementRange)

**Phase 8: API Cleanup & Integration**
- [ ] Task 35: Audit all public exports - ensure NO Flame types leak to consumers
- [ ] Task 36: Update `FiftyMapWidget` with `grid` parameter alongside existing `initialEntities`
- [ ] Task 37: Update barrel export `fifty_map_engine.dart` with all new public API
- [ ] Task 38: Ensure existing example app still compiles and runs (backward compatibility)
- [ ] Task 39: Update/create example showing grid-based usage (8x8 board demo)

**Phase 9: Testing**
- [ ] Task 40: Unit tests for GridPosition (conversions, helpers, edge cases)
- [ ] Task 41: Unit tests for TileGrid (create, get/set, query)
- [ ] Task 42: Unit tests for OverlayManager (add/remove/clear groups)
- [ ] Task 43: Unit tests for InputManager (blocking, unlock, tap resolution)
- [ ] Task 44: Unit tests for AnimationQueue (sequential execution, callbacks)
- [ ] Task 45: Unit tests for Pathfinder (A* correctness, BFS range, obstacles)
- [ ] Task 46: Unit tests for EntityDecorator (compose, update, remove)
- [ ] Task 47: Widget/integration test for FiftyMapWidget with grid
- [ ] Task 48: Verify all existing tests still pass
- [ ] Task 49: Run flutter analyze (zero issues)

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** TESTING (Phase 9)
**Active Agent:** orchestrator
**Next Steps When Resuming:** Run reviewer, then commit
**Last Updated:** 2026-02-10
**Blockers:** None

**Agent Log:**
- 2026-02-10: Starting planner — analyze existing codebase, create implementation plan
- 2026-02-10: Planner complete — plan saved to ai/plans/BR-077-plan.md (30 files, 9 phases)
- 2026-02-10: Monarch approved plan with amendment: unify coordinate system to top-down (remove Y-flip from old room system)
- 2026-02-10: Starting coder — Phase 1: Foundation (GridPosition, TileType, TileGrid, TileComponent, TileGridComponent, CoordinateAdapter)
- 2026-02-10: Phase 1 COMPLETE — 6 files created, 1 modified, zero analyzer issues
- 2026-02-10: Starting coder — Phase 2 (Overlays) + Phase 3 (Input) in parallel
- 2026-02-10: Phase 2 COMPLETE — 3 files created (tile_overlay.dart, tile_overlay_component.dart, overlay_manager.dart), zero issues
- 2026-02-10: Phase 3 COMPLETE — 2 files created (input_manager.dart, tap_resolver.dart), 1 modified (component.dart: removed Y-flip, onLongTapDown→onTapDown, fixed move directions), 17 new tests (48 total passing), zero issues
- 2026-02-10: Starting coder — Phase 4 (Entity Decorators) + Phase 5 (Animation & Effects) + Phase 7 (Pathfinding) in parallel
- 2026-02-10: Phase 4 COMPLETE — 5 files created (entity_decorator.dart, health_bar_component.dart, selection_ring_component.dart, team_border_component.dart, status_icon_component.dart), zero issues
- 2026-02-10: Phase 5 COMPLETE — 2 files created (floating_text_component.dart, animation_queue.dart), 8 new tests, zero issues
- 2026-02-10: Phase 7 COMPLETE — 3 files created (grid_graph.dart, pathfinder.dart, movement_range.dart), 28 new tests, zero issues
- 2026-02-10: Starting coder — Phase 6 (Sprite Animation) + Phase 8 (API Integration) in parallel
- 2026-02-10: Phase 6 COMPLETE — 2 files created (sprite_animation_config.dart, animated_entity_component.dart), 3 modified (model.dart, extension.dart, spawner.dart), 13 new tests, zero issues
- 2026-02-10: Phase 8 COMPLETE — 4 files modified (fifty_map_engine.dart barrel, controller.dart, widget.dart, map_builder.dart), 22 new tests, zero issues
- 2026-02-10: Phase 9 VERIFICATION — 119 tests passing, zero analyzer issues. All phases complete.

---

## Acceptance Criteria

**The upgrade is complete when:**

1. [ ] `TileGrid` renders an 8x8 checkerboard with different tile types
2. [ ] Tile overlays dynamically highlight tiles (green/red/purple/selection)
3. [ ] Tapping ANY tile (occupied or empty) fires `onTileTap` callback instantly
4. [ ] Entity decorators (HP bar, selection ring, team border) display on entities
5. [ ] Floating text (damage popups) spawn at grid positions and animate out
6. [ ] Animation queue executes sequential animations (move → attack → damage)
7. [ ] Input is blocked during animations, unblocked on completion
8. [ ] Sprite sheet animation works (frame cycling, state machine: idle/walk/attack)
9. [ ] A* pathfinding returns shortest path between tiles
10. [ ] BFS movement range returns all reachable tiles within budget
11. [ ] Camera pan/zoom/center still works (preserved from v1)
12. [ ] Existing entity system (rooms, characters, monsters) still works (backward compatible)
13. [ ] Public API exposes ZERO Flame types (no Vector2, Component, FlameGame in exports)
14. [ ] `GridPosition` used for all public coordinate parameters
15. [ ] Example app demonstrates grid-based usage
16. [ ] `flutter analyze` passes (zero issues)
17. [ ] All existing + new tests pass
18. [ ] Tactical grid game (BR-076) can be built using ONLY this package's public API

---

## Test Plan

### Automated Tests
- [ ] GridPosition: creation, validation, adjacency, distance, notation, equality (10+ tests)
- [ ] TileGrid: creation, get/set, query walkable, query by type (8+ tests)
- [ ] TileOverlay: create, apply style, opacity (4+ tests)
- [ ] OverlayManager: add group, remove group, clear all, z-index order (6+ tests)
- [ ] InputManager: block, unblock, check state, animation integration (5+ tests)
- [ ] TapResolver: screen → grid conversion, with camera offset, with zoom (6+ tests)
- [ ] AnimationQueue: sequential execution, completion callbacks, cancel (5+ tests)
- [ ] Pathfinder A*: straight path, around obstacles, no path, diagonal (6+ tests)
- [ ] BFS range: open field, obstacles, movement costs, budget (6+ tests)
- [ ] EntityDecorator: add HP bar, update HP, remove, compose multiple (5+ tests)
- [ ] FloatingText: spawn, animate, remove after duration (3+ tests)
- [ ] SpriteAnimation: load sheet, cycle frames, state transitions (4+ tests)
- [ ] Backward compatibility: existing example app compiles and runs

### Manual Test Cases

#### Test Case 1: 8x8 Grid Rendering
**Steps:**
1. Create TileGrid(8, 8) with checkerboard pattern
2. Render via FiftyMapWidget

**Expected:** 64 tiles visible, correct checkerboard colors

#### Test Case 2: Highlight + Tap + Move Flow
**Steps:**
1. Tap tile (3,3) - entity selected
2. Highlights appear on valid move tiles (green)
3. Tap tile (3,5) - entity moves with animation
4. Highlights clear, damage popup shows on target

**Expected:** Full interaction loop works end-to-end

---

## Delivery

### Code Changes
- [ ] New files: ~30 new source files (see Tasks section)
- [ ] Modified files: ~7 existing files (controller, widget, builder, component, asset loader, entity model, barrel export)
- [ ] Deleted files: None (additive only)

### Documentation Updates
- [ ] Update package README with grid-based usage examples
- [ ] Add API documentation for all new public classes
- [ ] Add migration guide: "Using fifty_map_engine for grid games"

---

## Dependency Chain

```
BR-077 (this) → BR-076 (tactical grid migration) → BR-071 (tactical grid complete)
```

BR-076 is BLOCKED until BR-077 ships. Once the engine is upgraded, the tactical grid migration becomes straightforward.

---

## Notes

- This is additive. The room/dungeon-crawler entity system stays intact. A dungeon crawler uses entities without tiles. A tactical game uses tiles with entities on top. Both work.
- Hex grid and isometric grid support are OUT OF SCOPE but the architecture (GridPosition, TileGrid interface) should be designed to support them in future briefs.
- Fog of war is OUT OF SCOPE but the overlay layer architecture should support it later.
- The package name stays `fifty_map_engine`. No rename needed - "map" covers tiles + entities + grid.
- Flame stays as the internal rendering backend. The public API hides it completely.

---

**Created:** 2026-02-10
**Last Updated:** 2026-02-10
**Brief Owner:** Monarch
