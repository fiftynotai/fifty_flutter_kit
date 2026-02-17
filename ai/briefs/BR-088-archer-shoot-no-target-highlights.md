# BR-088: Archer Shoot Ability Does Not Highlight Possible Targets

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-17
**Completed:** 2026-02-17

---

## Problem

**What's broken or missing?**

When the player selects an Archer and presses the Shoot ability button, the board does not highlight the valid shot target positions. The player has no visual feedback on which tiles/enemies are within the Archer's range (Chebyshev distance 2-3), forcing them to guess.

**Current flow:**
1. Player selects Archer
2. Green movement highlights appear (correct)
3. Player presses Shoot button
4. `isAbilityTargeting` is set to `true` (correct — `battle_actions.dart:595`)
5. `_onAbilityTargetingChanged(true)` fires and reads `state.abilityTargets`
6. Expected: purple highlights appear on valid shot targets
7. Actual: no highlights appear

**Why does it matter?**

Without visual targeting feedback, the Archer's Shoot ability is unusable — players cannot see which enemies are in range and must tap blindly.

---

## Goal

**What should happen after this brief is completed?**

1. Pressing Shoot on an Archer should highlight all valid target positions (enemies at Chebyshev distance 2-3)
2. Highlights should clear when targeting is cancelled or after the ability is used

---

## Context & Inputs

### Affected Modules
- [ ] Other: `apps/tactical_grid` (ability targeting highlight flow)
- [ ] Other: `packages/fifty_map_engine` (overlay rendering — if needed)

### Layers Touched
- [x] View (UI widgets) — highlight rendering in EngineBoardWidget
- [ ] Actions (UX orchestration) — ability button press flow
- [ ] ViewModel (business logic) — abilityTargets computation
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Related Files
- `apps/tactical_grid/lib/features/battle/views/widgets/engine_board_widget.dart` — `_onAbilityTargetingChanged()` (lines 387-401), `_syncHighlights()` (lines 319-361)
- `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — `onAbilityButtonPressed()` (lines 571-603), sets `isAbilityTargeting.value = true` for shoot
- `apps/tactical_grid/lib/features/battle/models/board_state.dart` — `getAbilityTargets()` (lines 116-125), computes Chebyshev distance 2-3 enemy positions for shoot
- `apps/tactical_grid/lib/features/battle/services/game_logic_service.dart` — `selectUnit()` (line 130), computes `abilityTargets` on selection

### Investigation Notes
- `getAbilityTargets()` for `AbilityType.shoot` returns enemy unit positions at Chebyshev distance 2-3 (ranged only, not adjacent)
- `selectUnit()` computes `abilityTargets` and stores them in `GameState`
- `_onAbilityTargetingChanged(true)` reads `state.abilityTargets` and calls `highlightTiles()` — this was added in BR-085
- Possible causes: abilityTargets empty at runtime (no enemies in range 2-3), highlight style not rendering, or state stale when `_onAbilityTargetingChanged` fires

---

## Constraints

### Architecture Rules
- Must not change Archer's range or damage calculations
- Must follow existing highlight pattern (HighlightStyle.abilityTarget)

### Out of Scope
- Changing Archer ability mechanics
- Changing Fireball or other ability highlights

---

## Tasks

### Pending
- [ ] Task 1: Investigate why Archer shoot targets are not highlighted — check if `state.abilityTargets` is populated when `_onAbilityTargetingChanged` fires
- [ ] Task 2: Fix the root cause (populate targets, fix timing, or fix rendering)
- [ ] Task 3: Run `flutter test` on both packages
- [ ] Task 4: Manual smoke test — select Archer, press Shoot, verify targets highlighted

### In Progress

### Completed

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Pressing Shoot on Archer highlights valid target positions on the board
2. [ ] Highlights clear when targeting is cancelled or ability is used
3. [ ] Fireball targeting on Mage still works correctly
4. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Archer Shoot Targeting
**Preconditions:** Local 1V1 game, Archer unit available, enemies within range 2-3
**Steps:**
1. Select the Archer
2. Press the Shoot ability button
3. Verify purple/ability highlights appear on valid target tiles

**Expected Result:** Enemies at Chebyshev distance 2-3 highlighted
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Mage Fireball Still Works
**Preconditions:** Same game, Mage unit available
**Steps:**
1. Select the Mage
2. Press the Fireball ability button
3. Verify ability range highlights appear

**Expected Result:** Fireball range highlighted (no regression)
**Status:** [ ] Pass / [ ] Fail

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** M
