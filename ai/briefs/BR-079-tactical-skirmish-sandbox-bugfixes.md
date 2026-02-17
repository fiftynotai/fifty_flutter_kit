# BR-079: Tactical Skirmish Sandbox - Bugfixes

**Type:** Bug
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-10
**Completed:** 2026-02-13

---

## Background Context

The Tactical Skirmish Sandbox example app was built as BR-078 to demonstrate 19/21 v2 features of `fifty_map_engine`. The app is a 2-player hot-seat tactical game with a 10x8 tile grid, 6 units (3 blue, 3 red), movement via A* pathfinding, BFS movement range, and attack with damage popups.

**Previous fixes already applied (commits `38fab7b`, `d77e872`, `35ea325`):**
- Replaced old multi-file example with single-file tactical sandbox
- Fixed Flame SpriteComponent crash: entities with empty `asset` now get 1x1 transparent placeholder sprite in `component.dart`
- Added camera centering: `zoomOut()` x2 + `centerMap()` after decorator setup
- Fixed tap race condition: entity taps fire on `TapDown` (press) while tile taps fire on `TapUp` (release) - removed game logic from `_onEntityTap`, all logic now in `_onTileTap`
- Added `usedUnits` tracking to prevent re-selecting units that already moved

**Key architecture:**
- Engine: `packages/fifty_map_engine/` (Flame-based, public API hides Flame)
- Example: `packages/fifty_map_engine/example/lib/main.dart` (single-file ~660 lines)
- Tile taps: `MapBuilder.onTapUp()` -> `TapResolver.resolve()` -> `onTileTap(GridPosition)`
- Entity taps: `FiftyBaseComponent.onTapDown()` -> `onEntityTap(entity)` (currently no-op in example)
- Movement: `controller.getMovementRange()` (BFS) for range display, `controller.findPath()` (A*) for pathfinding, `controller.move()` for animation
- Grid: `TileGrid` 10x8, `TileType` with walkability + movement cost, `GridPosition` for all coordinates
- Block size: 64px (`FiftyMapConfig.blockSize`)

---

## Problem

**What's broken or missing?**

Multiple gameplay bugs exist in the tactical skirmish sandbox that break the core game loop:

### Issue 1: Movement to unhighlighted tiles
Units can be moved to tiles that are NOT highlighted as valid movement targets. This indicates a mismatch between the BFS movement range calculation (`controller.getMovementRange()`) and what tiles are actually stored in `_state.moveTargets`, OR a problem in the highlighting flow where `highlightTiles()` doesn't match the computed set.

**Investigation scope:** Check both engine-level BFS (`getMovementRange`) AND example-level tile tap logic. Verify that `_state.moveTargets` exactly matches what `highlightTiles()` renders. Check if `TapResolver.resolve()` can return grid positions that are out of bounds or misaligned with what BFS returned.

### Issue 2: Component lands shifted off-tile after moving
After movement animation completes, units sometimes land slightly offset from the tile center. They don't snap cleanly to the grid position.

**Investigation scope:** Check engine-level `controller.move()` implementation - does it snap to exact grid pixel coordinates or interpolate? Check if the step-by-step A* animation in `_moveUnit()` accumulates floating-point drift. Verify `CoordinateAdapter` grid-to-pixel conversion.

### Issue 3: Random movement on rapid clicking
When clicking rapidly between units (switching selection without choosing a movement tile), a unit sometimes moves to an unexpected position. Related to the tap race condition partially fixed in `35ea325` but may have residual timing issues.

**Investigation scope:** Example-level tap handler state management. Check if rapid `_selectUnit` -> `_deselectUnit` -> `_selectUnit` cycles leave stale `moveTargets`. Check if `_onTileTap` can process a tap while a previous `setState` hasn't flushed yet.

### Issue 4: No auto-deselect after moving
After a unit moves, it stays selected with attack range showing. The unit should auto-deselect (or lock) after completing its action so the player can select the next unit clearly.

**Investigation scope:** Example-level only. After movement completes in `_moveUnit`'s `onComplete` callback, add deselect logic (clear selection ring, clear highlights) once the unit has no valid attacks remaining.

### Issue 5: Turn should auto-switch after all units moved
Currently the turn only changes via the "End Turn" button. It should automatically switch to the other player after all friendly units have been used (moved). Each player has 3 units, so after 3 moves the turn should auto-switch with visual feedback.

**Investigation scope:** Example-level only. Track `usedUnits.length` against team unit count. When all friendly units are used, auto-call `_endTurn()` with a brief delay for feedback (e.g., a snackbar or visual flash).

### Issue 6: Movement range calculation looks incorrect
The BFS movement range displayed for units appears to include tiles that shouldn't be reachable (too many tiles, wrong shape). Need to audit the full BFS pipeline:
1. `controller.getMovementRange(position, budget, grid, blocked)` - engine BFS
2. Movement cost per tile type (grass=1, forest=2, water/wall=impassable)
3. Blocked positions (occupied tiles)
4. The returned set vs what gets highlighted

**Investigation scope:** Engine-level BFS algorithm (`getMovementRange`) AND example-level parameters passed to it. Verify movement costs are respected, diagonal vs cardinal movement, budget consumption.

**Why does it matter?**
These bugs break the core gameplay loop. Players can't trust movement ranges, units don't behave predictably, and the turn system requires manual intervention.

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine/example/` (Issues 1,3,4,5)
- [x] Other: `packages/fifty_map_engine/lib/` (Issues 1,2,6 - engine level)

### Layers Touched
- [x] View (UI widgets) - example app
- [x] Model (domain objects) - game state
- [x] Service (engine internals) - BFS, pathfinding, movement

### API Changes
- [x] No API changes expected

### Dependencies
- [x] Existing service: `fifty_map_engine` v2 public API

### Related Files
- `packages/fifty_map_engine/example/lib/main.dart` - All example-level fixes
- `packages/fifty_map_engine/lib/src/grid/movement_range.dart` - BFS algorithm (Issue 1, 6)
- `packages/fifty_map_engine/lib/src/pathfinding/` - A* pathfinding (Issue 2)
- `packages/fifty_map_engine/lib/src/input/tap_resolver.dart` - Tap coordinate resolution (Issue 1)
- `packages/fifty_map_engine/lib/src/components/base/component.dart` - Entity positioning (Issue 2)
- `packages/fifty_map_engine/lib/src/controller/controller.dart` - move(), getMovementRange() (Issue 1, 2, 6)
- `packages/fifty_map_engine/lib/src/view/map_builder.dart` - Entity movement, coordinate system (Issue 2)

### Investigation Strategy Per Issue

| Issue | Check Engine? | Check Example? | Test Method |
|-------|--------------|----------------|-------------|
| 1 - Move to unhighlighted | YES (BFS, TapResolver) | YES (moveTargets logic) | Run in Chrome, select unit, verify highlight set matches moveTargets |
| 2 - Shifted after move | YES (move(), CoordinateAdapter) | YES (step animation) | Run in Chrome, move unit, inspect final position alignment |
| 3 - Random move on clicks | NO | YES (state management) | Run in Chrome, rapidly click between units |
| 4 - No auto-deselect | NO | YES (onComplete callback) | Run in Chrome, move unit, verify deselect |
| 5 - Auto turn switch | NO | YES (turn management) | Run in Chrome, move all 3 units, verify auto-switch |
| 6 - Movement range off | YES (BFS algorithm) | YES (parameters) | Run in Chrome, compare range vs expected tiles |

---

## Constraints

### Architecture Rules
- Single-file example in `example/lib/main.dart`
- Only use public API from `fifty_map_engine` barrel export
- No direct Flame imports in example code
- Engine fixes in appropriate engine source files

### Technical Constraints
- Must run `flutter analyze` clean after fixes
- Must pass all 119 existing engine tests
- Test each fix by running example in Chrome (`flutter run -d chrome`)

---

## Tasks

### Pending
- [ ] Task 1: Investigate Issue 6 first (BFS movement range) - engine level audit
- [ ] Task 2: Investigate Issue 1 (move to unhighlighted tile) - may be same root cause as Issue 6
- [ ] Task 3: Fix Issue 2 (shifted landing position) - engine move() snapping
- [ ] Task 4: Fix Issue 3 (random movement on rapid clicks) - state guard
- [ ] Task 5: Fix Issue 4 (auto-deselect after move)
- [ ] Task 6: Fix Issue 5 (auto turn switch after all units moved)
- [ ] Task 7: Run flutter analyze + flutter test on package
- [ ] Task 8: Test all fixes in Chrome browser

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** COMPLETE
**Active Agent:** none
**Next Steps When Resuming:** N/A - Brief complete. Commit: 0d82bdf
**Plan:** N/A (create during implementation)
**Last Updated:** 2026-02-10
**Blockers:** None

---

## Acceptance Criteria

**The fix is complete when:**

1. [ ] Units can ONLY move to highlighted (blue) tiles - no movement to unhighlighted positions
2. [ ] Units land precisely aligned on the target tile after movement animation
3. [ ] Rapid clicking between units does not cause unintended movement
4. [ ] Units auto-deselect after completing their move action
5. [ ] Turn auto-switches to opponent after all friendly units have acted, with visual feedback
6. [ ] BFS movement range matches expected tiles based on unit move range and terrain costs
7. [ ] `flutter analyze` passes (zero issues) on the package
8. [ ] `flutter test` passes (all 119 tests green)
9. [ ] All fixes verified by running example in Chrome

---

## Test Plan

### Automated Tests
- [ ] Existing 119 engine tests pass (regression)
- [ ] Consider adding BFS movement range unit tests if bug found in engine

### Manual Test Cases

#### Test Case 1: Movement Range Accuracy
**Steps:** Select each unit type (warrior/archer/mage), compare highlighted tiles against expected range
**Expected:** Warrior (3 range) shows ~12 tiles on grass, fewer near forest/water. Archer (3 range) same. Mage (2 range) shows ~8 tiles.

#### Test Case 2: Movement Restricted to Highlights
**Steps:** Select unit, tap an unhighlighted tile
**Expected:** Unit does NOT move, deselects instead

#### Test Case 3: Precise Tile Landing
**Steps:** Move unit to various tiles, inspect alignment
**Expected:** Unit sprite centered/aligned on target tile, no offset

#### Test Case 4: Rapid Click Stability
**Steps:** Rapidly tap between multiple friendly units 10+ times
**Expected:** No unintended movement occurs

#### Test Case 5: Auto-Deselect After Move
**Steps:** Select unit, move it to valid tile
**Expected:** After animation, unit deselects, highlights clear

#### Test Case 6: Auto Turn Switch
**Steps:** Move all 3 blue units, observe turn indicator
**Expected:** After 3rd unit moves, turn auto-switches to Red with visual feedback

---

## Delivery

### Code Changes
- [ ] Modified files: `packages/fifty_map_engine/example/lib/main.dart`
- [ ] Possibly modified: engine BFS/movement/coordinate files (if engine bugs found)

### Documentation Updates
- [ ] N/A

---

## Notes

- Issues 1 and 6 are likely related - if BFS returns wrong tiles, that explains both
- Issue 2 might be floating-point accumulation in step-by-step A* animation
- Issue 3 may be a residual race condition from the TapDown/TapUp dual-callback system
- Previous fix added `usedUnits` tracking but the re-selection guard alone doesn't prevent all movement bugs
- For each fix: investigate -> fix -> run in Chrome -> verify -> next issue

---

**Created:** 2026-02-10
**Last Updated:** 2026-02-10
**Brief Owner:** Igris AI
