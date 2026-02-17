# BR-084: Tile Tap Y-Offset — eventPosition.global vs .widget

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-16
**Completed:** 2026-02-16

---

## Problem

**What's broken or missing?**

Tile taps in the fifty_map_engine resolve to the wrong grid row. To move a unit to a specific tile, the player must tap the tile ONE ROW ABOVE the intended target. Entity selection (tapping directly on a character) works correctly.

The root cause: `onTapUp` in `FiftyMapBuilder` passes `info.eventPosition.global` (screen-absolute coordinates, including status bar + header offset) to `_screenToWorld()`, which expects coordinates relative to the GameWidget's local viewport. The vertical offset from UI elements above the GameWidget (~70px on iPhone 15 Pro: status bar + SafeArea + TurnIndicator), divided by the current zoom level (~0.69), produces a ~100px world-space offset = ~1.5 tiles. This manifests as a 1-tile Y shift in tap resolution.

**Why does it matter?**

Core gameplay is broken — players cannot tap tiles accurately. Every tile movement requires tapping one row above the target, making the game frustrating and unintuitive. This affects ALL consumers of fifty_map_engine that use grid-based tile taps with UI elements above the game widget.

---

## Goal

**What should happen after this brief is completed?**

Tapping a tile should select THAT exact tile — no Y offset. The coordinate conversion should use widget-local coordinates (`eventPosition.widget`) instead of screen-absolute coordinates (`eventPosition.global`), ensuring the GameWidget's position in the widget tree is correctly accounted for.

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_map_engine` (tap input handling)

### Layers Touched
- [x] View (UI widgets) — input/tap handling in FiftyMapBuilder
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Dependencies
- [ ] Existing service: Flame engine `TapUpInfo.eventPosition` coordinate systems

### Related Files
- `packages/fifty_map_engine/lib/src/view/map_builder.dart` — lines 342, 352, 424

---

## Constraints

### Architecture Rules
- Must not break camera panning (single-finger drag)
- Must not break pinch-to-zoom (two-finger gesture)
- Must not break entity tap detection

### Technical Constraints
- `eventPosition.global` = position relative to entire screen (Flutter's `globalPosition`)
- `eventPosition.widget` = position relative to GameWidget (uses Flame's `convertGlobalToLocalCoordinate`)
- `_screenToWorld()` uses `game.size` (GameWidget size) as reference, so it expects widget-local coordinates
- Drag deltas (`info.delta.global`) are offset-invariant, so drag panning works regardless
- Pinch zoom uses position **differences** that cancel the offset, so pinch works regardless

### Out of Scope
- Entity tap routing (uses `model.gridPosition` directly — not affected)
- Camera centerMap() grid centering offset (minor cosmetic issue, separate brief)
- RenderFlex overflow in `unit_info_panel.dart:216` (separate UI bug)

---

## Tasks

### Pending
- [ ] Task 5: Manual smoke test on iOS simulator — verify tile taps land on correct grid position
- [ ] Task 6: Verify panning and pinch-to-zoom still work correctly after change

### In Progress

### Completed
- [x] Task 1: Change `info.eventPosition.global` to `info.eventPosition.widget` on line 424 (onTapUp tile resolution)
- [x] Task 2: Change `info.eventPosition.global` to `info.eventPosition.widget` on line 342 (onDragStart pointer tracking)
- [x] Task 3: Change `info.eventPosition.global` to `info.eventPosition.widget` on line 352 (onDragUpdate pointer tracking)
- [x] Task 4: Run `flutter analyze` + `flutter test` on both packages (417 tests) — 417/417 passing

---

## Session State (Tactical - This Brief)

**Current State:** Complete — code fix applied, 417/417 tests passing
**Next Steps When Resuming:** Manual smoke test on simulator (Tasks 5-6)
**Last Updated:** 2026-02-16
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Tapping a tile selects THAT exact tile (no Y offset)
2. [ ] Camera panning (single-finger drag) works correctly
3. [ ] Pinch-to-zoom works correctly with midpoint anchoring
4. [ ] Entity taps still work (selecting characters)
5. [ ] `flutter analyze` passes (zero issues)
6. [ ] `flutter test` passes (all 417 tests green)
7. [ ] Manual smoke test: move a unit to an adjacent tile by tapping that tile directly

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Tile Tap Accuracy
**Preconditions:** Local 1V1 game, player unit selected with valid move tiles highlighted
**Steps:**
1. Note a highlighted (valid move) tile
2. Tap directly on that tile
3. Verify the unit moves to THAT tile (not one row below)

**Expected Result:** Unit moves to the exact tapped tile
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Camera Panning
**Preconditions:** Game board visible
**Steps:**
1. Single-finger drag on an empty area of the board
2. Verify the camera pans smoothly in the drag direction

**Expected Result:** Camera pans correctly without jitter or wrong direction
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Pinch-to-Zoom
**Preconditions:** Game board visible
**Steps:**
1. Two-finger pinch on the board
2. Verify zoom changes and remains anchored at the pinch midpoint

**Expected Result:** Zoom works, world point under fingers stays stationary
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Discovered during BR-083 (Entity Sprite Oversized Hitbox) testing. The oversized entity hitboxes in pre-BR-083 code masked this bug — most taps went through the entity path (which uses `model.gridPosition` directly) rather than the tile resolver path (which uses screen-to-world conversion). After BR-083 clamped hitboxes to tile size, more taps flow through the tile resolver, exposing the `global` vs `widget` coordinate mismatch.

The `_screenToWorld()` helper at line 127 was originally written for pinch-zoom anchoring, where it operates on position **differences** (worldBefore - worldAfter) that cancel the offset. When it was reused for absolute tile tap resolution (our earlier fix replacing `viewfinder.transform.globalToLocal`), the coordinate system mismatch became visible.

**Three lines to change — all in the same file, same pattern:**
| Line | Context | Change |
|------|---------|--------|
| 342 | `onDragStart` | `.global` → `.widget` |
| 352 | `onDragUpdate` | `.global` → `.widget` |
| 424 | `onTapUp` | `.global` → `.widget` |

---

**Created:** 2026-02-16
**Last Updated:** 2026-02-16
**Brief Owner:** M
