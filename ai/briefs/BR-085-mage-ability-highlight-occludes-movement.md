# BR-085: Mage Ability Highlight Occludes Movement Highlight

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-16
**Completed:**

---

## Problem

**What's broken or missing?**

When a Mage is selected, the ability range highlight (purple, Fireball radius 3 — up to 49 tiles) visually covers the movement highlight (green). Both overlays are correctly added to the engine, but they share the same render priority (`tileOverlay = 5`) and ability overlays are inserted last in `_syncHighlights()`, so they paint on top of movement overlays on all overlapping tiles. The green movement squares become invisible beneath the purple ability range.

Additionally, ability targets should NOT be shown on initial unit selection — they should only appear when the player presses the Ability button and enters targeting mode (`isAbilityTargeting = true`).

**Why does it matter?**

Players cannot see which tiles the Mage can move to, making the unit appear stuck. This forces players to guess valid movement tiles or avoid using the Mage entirely.

---

## Goal

**What should happen after this brief is completed?**

1. Movement highlights (green) should always be visible when a Mage is selected
2. Ability range highlights (purple) should only appear when the player activates ability targeting mode (presses the Ability button)
3. When both are shown during targeting mode, movement highlights should render on top of ability highlights

---

## Context & Inputs

### Affected Modules
- [ ] Other: `apps/tactical_grid` (highlight sync logic)
- [ ] Other: `packages/fifty_map_engine` (overlay render priority — optional)

### Layers Touched
- [x] View (UI widgets) — highlight sync in EngineBoardWidget
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Dependencies
- [ ] Existing service: `OverlayManager` supports multiple overlays per tile

### Related Files
- `apps/tactical_grid/lib/features/battle/views/widgets/engine_board_widget.dart` — `_syncHighlights()` (lines 319-362), `_onAbilityTargetingChanged()` (lines 397-401)
- `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — `onAbilityButtonPressed()` (lines 571-603)
- `packages/fifty_map_engine/lib/src/components/overlays/tile_overlay_component.dart` — render priority (line 37)
- `packages/fifty_map_engine/lib/src/components/base/priority.dart` — `FiftyRenderPriority.tileOverlay = 5`
- `apps/tactical_grid/lib/features/battle/models/board_state.dart` — `getAbilityTargets()` (lines 127-129)

---

## Constraints

### Architecture Rules
- Must not break attack range highlights (red)
- Must not break selection ring highlight
- Movement highlights must always be visible when a unit is selected

### Technical Constraints
- All `TileOverlayComponent` instances share priority 5 — Flame renders in insertion order within same priority
- `OverlayManager` supports stacking multiple overlays per tile via `Map<GridPosition, List<TileOverlayComponent>>`
- `_onAbilityTargetingChanged` callback already exists to clear ability highlights when targeting ends

### Out of Scope
- Changing ability range calculations
- Modifying overlay rendering in the engine (approach A alone should suffice)

---

## Tasks

### Pending
- [ ] Task 1: Remove abilityTargets rendering from `_syncHighlights()` — do NOT show ability range on initial unit selection
- [ ] Task 2: Add ability highlight rendering to `_onAbilityTargetingChanged()` — show purple overlays only when `isAbilityTargeting` becomes true
- [ ] Task 3: (Optional) Reverse insertion order in `_syncHighlights()` so movement overlays paint on top of ability overlays during targeting mode
- [ ] Task 4: Run `flutter test` on both packages
- [ ] Task 5: Manual smoke test — select Mage, verify green movement visible, press Ability, verify purple range appears

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started — investigation complete, fix identified
**Next Steps When Resuming:** Begin with Task 1
**Last Updated:** 2026-02-16
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Selecting a Mage shows movement highlights (green) clearly visible
2. [ ] Ability range highlights (purple) only appear after pressing the Ability button
3. [ ] Movement highlights remain visible even when ability highlights are shown
4. [ ] Attack range highlights (red) still work correctly
5. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Mage Selection Shows Movement
**Preconditions:** Local 1V1 game, Mage unit available
**Steps:**
1. Tap on the Mage to select it
2. Verify green movement highlights are visible
3. Verify NO purple ability highlights are shown yet

**Expected Result:** Only green movement and red attack range visible
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Ability Targeting Shows Range
**Preconditions:** Mage selected
**Steps:**
1. Press the Ability button
2. Verify purple ability range highlights appear
3. Verify green movement highlights are still visible (not hidden)

**Expected Result:** Both movement and ability highlights visible
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Root cause: `_syncHighlights()` adds all three overlay types on every state change. Ability overlays are added last (painted on top) and the Fireball's Chebyshev radius 3 covers most of the 8x8 board, completely occluding movement squares. The cleaner fix is to gate ability highlight display behind `isAbilityTargeting` rather than adjusting render priorities.

---

**Created:** 2026-02-16
**Last Updated:** 2026-02-16
**Brief Owner:** M
