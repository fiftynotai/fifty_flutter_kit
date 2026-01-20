# BG-001: Component Alignment & Layout Bugs

**Type:** Bug
**Priority:** P1-High
**Effort:** S-Small (0.5d)
**Status:** Done
**Created:** 2026-01-20
**Reported By:** Monarch

---

## Problem

Several fifty_ui components have alignment and layout issues discovered after the Design System v2 migration:

### 1. FiftyCard - Tap Area Bug
**Location:** Display page, first and second cards
**Issue:** Tapable area is only around the text, not the full card surface
**Expected:** Entire card should be tappable when `onTap` is provided

### 2. FiftyTextField - Multiline Vertical Alignment
**Location:** Input page, multiline text field
**Issue:** Hint text and actual text are not vertically centered
**Expected:** Text should be vertically centered (or top-aligned for multiline)

### 3. FiftyTextField - Block Cursor Alignment
**Location:** Input page, block cursor field
**Issue:** The block cursor square is not vertically centered
**Expected:** Block cursor should align with text baseline

### 4. FiftyTextField - Underscore Cursor Alignment
**Location:** Input page, underscore cursor field
**Issue:** Underscore cursor is not vertically aligned
**Expected:** Underscore should sit on baseline of text

### 5. FiftySlider - Thumb Position
**Location:** Input page, slider component
**Issue:** Square thumb renders below the track instead of on top
**Expected:** Thumb should be centered on the track, overlapping it

---

## Goal

Fix all alignment and layout issues so components render correctly per the v2 design specification.

---

## Files to Modify

| File | Issue |
|------|-------|
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | Tap area coverage |
| `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart` | Multiline alignment, cursor alignment |
| `packages/fifty_ui/lib/src/inputs/fifty_slider.dart` | Thumb position on track |

---

## Acceptance Criteria

- [x] FiftyCard: Full card surface is tappable when onTap is provided
- [x] FiftyTextField: Multiline hint/text aligned properly (centered or top)
- [x] FiftyTextField: Block cursor vertically centered with text
- [x] FiftyTextField: Underscore cursor aligned to baseline
- [x] FiftySlider: Thumb centered on track, not below it
- [x] All fixes verified in example app

---

## Test Plan

1. Run fifty_ui example app
2. Navigate to each page
3. Verify:
   - Cards are fully tappable
   - Text fields render with proper alignment
   - Sliders show thumb on track
4. Test in both light and dark modes

---

## Workflow State

**Phase:** Complete
**Active Agent:** None
**Retry Count:** 0

### Agent Log
- ARCHITECT: Created implementation plan
- ARTISAN: Fixed FiftyCard tap area (InkWell inside Stack with Positioned.fill)
- ARTISAN: Fixed FiftyTextField alignments (height/constraints, cursor Column centering)
- ARTISAN: Fixed FiftySlider thumb/label positioning (FractionalTranslation centering)
- SENTINEL: All 222 tests PASS
- WATCHER: APPROVED
- Manual verification: All fixes confirmed by Monarch
- Commit: `e2febe0` on branch `fix/BG-001-alignment-bugs`
