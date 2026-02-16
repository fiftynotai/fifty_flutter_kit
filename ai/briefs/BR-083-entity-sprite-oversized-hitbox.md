# BR-083: Entity Sprite Oversized Tap Hitbox

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** In Progress
**Created:** 2026-02-16
**Completed:**

---

## Problem

**What's broken or missing?**

Entity sprites in the tactical grid game have tap hitboxes that extend far beyond their actual tile position. During BR-082 testing, the enemy shield entity at grid position (3,1) intercepted tap events across a ~3-row vertical range in column 3, making it impossible to tap tiles at (3,2) and (3,3) via the simulator. The sprite's `TapCallbacks` bounding box covers roughly rows 1-3 in its column, preventing the tile-level tap resolver from receiving events for those tiles.

Empirical evidence from automated testing (screen coordinates with expanded info panel):
- y=275 to y=306 all resolved to `grid(3,1)` via entity sprite intercept (expected: rows 2-3)
- y=310 resolved to `grid(3,4)` via tile resolver (first non-intercepted row)
- The gap between sprite boundary and next tile row is ~4 pixels — effectively zero accessible area for row 3

This also affects other entity sprites (e.g., `e_knight_1` at (2,0) intercepted taps meant for row 3 in column 2 at y=304).

**Why does it matter?**

Players cannot tap tiles adjacent to (especially below) enemy units. This blocks valid move targets and attack positions, degrading gameplay. Any tile within ~2-3 rows below an entity sprite is effectively untappable when the entity is in the same column.

---

## Goal

**What should happen after this brief is completed?**

Entity sprite tap hitboxes should be constrained to their actual tile bounds (1 tile = 64x64 game pixels). Tapping an adjacent tile should resolve to that tile's grid position, not the entity sprite above it.

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_map_engine` (entity component rendering)
- [ ] Other: `apps/tactical_grid` (battle interaction layer)

### Layers Touched
- [x] View (UI widgets) — entity component sprite sizing/hitbox
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [x] Model (domain objects) — FiftyBaseComponent hitbox config

### API Changes
- [x] No API changes

### Dependencies
- [ ] Existing service: Flame engine `TapCallbacks` mixin on `FiftyBaseComponent`

### Related Files
- `packages/fifty_map_engine/lib/src/components/base/component.dart` — FiftyBaseComponent (entity base class with TapCallbacks)
- `packages/fifty_map_engine/lib/src/components/base/model.dart` — entity positioning/sizing
- `apps/tactical_grid/lib/features/battle/views/widgets/engine_board_widget.dart` — game-level tap handler

---

## Constraints

### Architecture Rules
- Entity sprites may be visually taller than one tile (character art), but the TAP hitbox must be limited to the tile footprint
- Must not break entity selection — tapping directly on the entity's tile must still select it

### Technical Constraints
- Flame engine `TapCallbacks` uses the component's `size` for hit detection by default
- Solution likely involves overriding `containsLocalPoint()` on `FiftyBaseComponent` to clamp the hitbox to tile dimensions, OR setting an explicit `hitbox` component

### Out of Scope
- Visual sprite sizing — sprites CAN render taller than one tile for visual fidelity
- Camera/zoom adjustments
- Tile resolver logic changes

---

## Tasks

### Pending
- [ ] Task 1: Investigate FiftyBaseComponent's current `size` and how Flame resolves tap priority between overlapping components
- [ ] Task 2: Implement hitbox clamping — override `containsLocalPoint()` or add a `RectangleHitbox` sized to tile dimensions (64x64)
- [ ] Task 3: Test that entity selection still works when tapping directly on the entity tile
- [ ] Task 4: Test that adjacent tiles are now tappable without entity interception
- [ ] Task 5: Run existing test suite to verify no regressions

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** In Progress — PLANNING phase
**Next Steps When Resuming:** Planner investigating, then coder implements
**Last Updated:** 2026-02-16
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Tapping a tile adjacent to an entity resolves to that tile's grid position (not the entity)
2. [ ] Tapping directly on an entity's tile still selects the entity
3. [ ] Entity sprites can still render larger than one tile visually
4. [ ] `flutter analyze` passes (zero issues)
5. [ ] `flutter test` passes (all existing + new tests green)
6. [ ] Manual smoke test: move a unit to a tile adjacent to an enemy without the enemy intercepting the tap

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Tap Adjacent Tile
**Preconditions:** Local 1V1 game, enemy shield at (3,1), player unit selected
**Steps:**
1. Select a player unit with valid move to (3,2) or (3,3)
2. Tap on tile (3,2) or (3,3)
3. Verify the tap resolves to the correct tile, not (3,1)

**Expected Result:** Unit moves to the tapped tile
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Entity Selection Still Works
**Preconditions:** Local 1V1 game, enemy unit visible
**Steps:**
1. Tap directly on the center of an enemy unit's tile
2. Verify the entity is reported as tapped (debug log or UI response)

**Expected Result:** Entity tap callback fires correctly
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Discovered during BR-082 (Y-Axis Movement Inversion Bug) automated testing. The oversized hitbox made it impossible to reach grid(3,3) from any direction in column 3 because the e_shield_1 sprite at (3,1) consumed all taps in that column's upper region.

Root cause is likely that entity sprites are sized to their full visual height (character art that may be 128-192px tall) rather than having a separate tap hitbox constrained to tile size (64x64).

---

**Created:** 2026-02-16
**Last Updated:** 2026-02-16
**Brief Owner:** M
