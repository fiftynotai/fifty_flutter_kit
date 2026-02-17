# BR-082: Y-Axis Movement Inversion Bug

**Type:** Bug Fix
**Priority:** P0-Critical
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-16
**Completed:**

---

## Problem

**What's broken or missing?**

Unit movement is inverted on the Y-axis. When a unit is selected and the player taps the tile **above** it, the unit moves **down** (to the tile below) instead of up. Confirmed on iOS simulator with the Shield (Knight) unit.

**Reproduction steps:**
1. Start a LOCAL 1v1 game
2. Select a Shield (Knight) unit (Player 1, red team)
3. Tap the tile directly above the selected unit
4. **Expected:** Unit moves up to the tapped tile
5. **Actual:** Unit moves down to the tile below its starting position

**Why does it matter?**

P0-Critical: The game is unplayable. Movement goes in the opposite Y-direction from where the player taps, making tactical positioning impossible.

---

## Goal

**What should happen after this brief is completed?**

Units move to the exact tile the player taps. Tapping above moves up, tapping below moves down, tapping left moves left, tapping right moves right. All Y-axis calculations are consistent across the full movement pipeline.

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine` (engine core)
- [x] Other: `apps/tactical_grid` (battle actions, engine board widget)

### Layers Touched
- [x] View (UI widgets) — engine_board_widget.dart entity positioning
- [x] Actions (UX orchestration) — battle_actions.dart movement logic
- [x] Model (domain objects) — FiftyMapEntity Y-position formula

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing service: fifty_map_engine v2 (grid, pathfinding, animations)

### Related Files

**Engine (Y-position formula):**
- `packages/fifty_map_engine/lib/src/components/base/model.dart` — Y formula: `(gridY + blockHeight) * blockSize`
- `packages/fifty_map_engine/lib/src/components/base/extension.dart` — `changePosition()` uses same Y formula
- `packages/fifty_map_engine/lib/src/components/base/component.dart` — `FiftyBaseComponent` uses `Anchor.bottomLeft`

**Engine (tap → grid position resolution):**
- `packages/fifty_map_engine/lib/src/view/map_builder.dart` — `onTapUp` resolves world position to grid position via `TapResolver`
- `packages/fifty_map_engine/lib/src/grid/tap_resolver.dart` — Converts world coordinates to grid position

**Engine (movement):**
- `packages/fifty_map_engine/lib/src/components/base/component.dart` — `FiftyMovableComponent.moveTo()`, `moveUp()`, `moveDown()`
- `packages/fifty_map_engine/lib/src/components/base/extension.dart` — `changePosition()` converts grid pos to pixel pos

**Tactical Grid (movement pipeline):**
- `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — `_moveUnit()` calls A* pathfinding then engine `controller.move()`
- `apps/tactical_grid/lib/features/battle/views/widgets/engine_board_widget.dart` — Builds entities from Unit model, syncs engine state

**Engine (tile grid):**
- `packages/fifty_map_engine/lib/src/grid/tile_grid_component.dart` — Tile placement with `Anchor.topLeft`

### Root Cause Analysis Areas

The Y-axis inversion likely stems from a mismatch in one or more of these areas:

1. **Entity Y formula vs Tile Y formula**: Entities use `Anchor.bottomLeft` with `y = (gridY + blockHeight) * blockSize`. Tiles use `Anchor.topLeft` with `y = gridY * tileSize`. The `+blockHeight` offset means entity pixel Y increases faster than tile pixel Y — this may cause the wrong grid position to be computed when resolving taps.

2. **TapResolver**: When converting a tap's world position back to a grid position, if it doesn't account for the bottomLeft anchor offset, the resolved grid position may be off by one row.

3. **Movement direction**: In `changePosition()`, increasing `gridPosition.y` increases pixel Y. If the coordinate system has Y-down (screen space), then increasing gridY = moving down visually. But if the game logic expects Y-up, movement direction inverts.

4. **A* path output**: The A* pathfinding returns a list of grid positions. If the path coordinates use a different Y convention than the engine's pixel conversion, intermediate steps go in the wrong direction.

5. **`controller.move()` implementation**: The engine's `move()` method calls `changePosition()` which converts grid→pixel. If this conversion has the Y offset issue, the visual movement goes wrong even though the game state is correct.

---

## Constraints

### Architecture Rules
- Must not break the 122 engine tests or 278 tactical grid tests
- Entity positioning must remain consistent with `Anchor.bottomLeft`
- Tile positioning must remain consistent with `Anchor.topLeft`
- The fix must work for all unit types (Knight, Archer, Mage, Scout, Cleric)

### Technical Constraints
- Must work on iOS simulator and web
- Must not break the example tactical skirmish sandbox app (separate from tactical_grid)

### Out of Scope
- Diagonal movement animation (already handled by A* diagonal:true)
- Combat/attack animations
- AI movement (uses same pipeline, will be fixed automatically)

---

## Tasks

### Pending
- [ ] Task 1: Trace full movement pipeline from tap → grid resolution → A* path → moveTo → pixel position
- [ ] Task 2: Add debug logging to identify where Y-axis inverts (tap grid pos vs movement target grid pos vs final pixel pos)
- [ ] Task 3: Compare tile grid Y convention with entity grid Y convention
- [ ] Task 4: Fix the Y-axis mismatch at its root (likely in model.dart Y formula or TapResolver)
- [ ] Task 5: Verify fix on iOS simulator — select unit, tap above, unit moves up
- [ ] Task 6: Verify all 400 tests still pass (278 + 122)
- [ ] Task 7: Test all 4 directions (up/down/left/right) on simulator

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A — brief complete
**Last Updated:** 2026-02-16
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Tapping tile above a selected unit moves the unit UP visually
2. [ ] Tapping tile below a selected unit moves the unit DOWN visually
3. [ ] Tapping tile left moves LEFT, tapping right moves RIGHT
4. [ ] Movement works correctly for all unit types (Knight, Archer, Mage, Scout, Cleric)
5. [ ] Movement works for both Player 1 and Player 2 units
6. [ ] AI movement also goes in correct directions
7. [ ] `dart analyze` passes (zero errors)
8. [ ] `flutter test` passes — 278 tactical grid + 122 engine tests
9. [ ] Manual smoke test on iOS simulator confirms all 4 directions

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Move Unit Up
**Preconditions:** LOCAL 1v1 game, Player 1 turn, unit selected with empty tile above
**Steps:**
1. Select a Shield (Knight) unit
2. Tap the tile directly above it
3. Observe unit movement

**Expected Result:** Unit moves UP to the tapped tile
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Move Unit Down
**Preconditions:** Same game, unit with empty tile below
**Steps:**
1. Select a unit
2. Tap tile directly below
**Expected Result:** Unit moves DOWN
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Move Unit Left/Right
**Steps:**
1. Select unit, tap left tile → moves LEFT
2. Select unit, tap right tile → moves RIGHT
**Status:** [ ] Pass / [ ] Fail

#### Test Case 4: AI Movement
**Preconditions:** LOCAL vs AI game
**Steps:**
1. End turn, observe AI unit movements
**Expected Result:** AI units move toward logical targets (not away)
**Status:** [ ] Pass / [ ] Fail

---

## Notes

- Previous fix attempt in commit `c69ae5f` changed Y formula to `(gridY + blockHeight) * blockSize` but this may have introduced or not fully resolved the inversion
- The `Anchor.bottomLeft` on entities vs `Anchor.topLeft` on tiles is the most likely source of the coordinate mismatch
- The example app (tactical skirmish sandbox) uses the same engine but with simpler movement — test it too
- Consider whether `Anchor.bottomLeft` is even necessary, or if switching entities to `Anchor.topLeft` would eliminate the entire class of Y-offset bugs

---

**Created:** 2026-02-16
**Last Updated:** 2026-02-16
**Brief Owner:** Igris AI
