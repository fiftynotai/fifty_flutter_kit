# BR-128: PinnedScrollSection — Dead Zone in Progress Calculation

**Type:** Bug
**Priority:** P2-Medium
**Effort:** S-Small (< 1d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-02-26

---

## Problem

**What's broken or missing?**

`PinnedScrollSection` has a dead zone where frames don't update during the first portion of scrolling. When the widget is placed below other content (e.g., a spacer + instruction text), frames stay at index 0 for a significant scroll distance before suddenly jumping to ~frame 20-25.

**Root cause (two issues):**

1. **`_leadingEdgeInViewport()` uses screen-relative coordinates.** It calls `localToGlobal(Offset.zero)` which measures from the screen origin (y=0), not the scroll area origin (below app bar/safe area). This means the app bar height (~103px on iPhone) adds to the dead zone — the widget pins behind the app bar instead of at the scroll area's leading edge.

2. **`_viewportDimension()` uses `MediaQuery.sizeOf` (full screen size).** The child is sized to the full screen height, not the actual scrollable viewport height (which excludes the app bar). This makes the PinnedScrollSection's total size too large and affects pin timing.

**Combined effect:** With a typical layout (app bar + 200px spacer + instruction text), there's ~360px of scroll where progress stays at 0.0. On a normal iOS swipe with momentum, this causes frames 1-25 to be completely skipped.

**Why does it matter?**

The dead zone breaks the Apple-style scroll sequence experience. Users expect frames to update smoothly from the first scroll pixel after the widget is visible. This was discovered while testing the snap demo in the example app.

---

## Goal

**What should happen after this brief is completed?**

`PinnedScrollSection` pins at the scroll area's leading edge (below app bar/safe area), not at the screen origin. The dead zone is reduced to only the actual content above the widget in the scroll layout.

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/`

### Layers Touched
- [x] View (`PinnedScrollSection` widget)

### Files to Modify
- `packages/fifty_scroll_sequence/lib/src/widgets/pinned_scroll_section.dart`

---

## Analysis Done

Two fixes were prototyped and tested during BR-127 debugging:

### Fix 1: `_leadingEdgeInViewport` — measure relative to Scrollable

```dart
double _leadingEdgeInViewport() {
  final renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox == null || !renderBox.hasSize) return 0;

  // Measure relative to the ancestor Scrollable's viewport, not the screen.
  final scrollableState = Scrollable.maybeOf(context);
  if (scrollableState != null) {
    final scrollableRenderObject = scrollableState.context.findRenderObject();
    if (scrollableRenderObject is RenderBox) {
      final scrollableGlobal = scrollableRenderObject.localToGlobal(Offset.zero);
      final myGlobal = renderBox.localToGlobal(Offset.zero);
      final relative = myGlobal - scrollableGlobal;
      return _isVertical ? relative.dy : relative.dx;
    }
  }

  // Fallback: use screen-relative coordinates.
  final globalOffset = renderBox.localToGlobal(Offset.zero);
  return _isVertical ? globalOffset.dy : globalOffset.dx;
}
```

### Fix 2: `_viewportDimension` — use ScrollPosition.viewportDimension

```dart
double _viewportDimension(BuildContext context) {
  final position = _scrollPosition;
  if (position != null && position.hasPixels) {
    try {
      final dimension = position.viewportDimension;
      if (dimension > 0) return dimension;
    } on Object {
      // viewportDimension throws if accessed before first layout pass.
    }
  }
  final size = MediaQuery.sizeOf(context);
  return _isVertical ? size.height : size.width;
}
```

**Status:** Both fixes pass analyzer + 238 tests. Need manual verification that the visual pinning and progress feel correct across different layouts (with/without app bar, safe areas, nested scrollables).

---

## Constraints

- Must not break existing pinned mode behavior (widget pins visually at correct position)
- Must work with and without app bars
- Must work with safe area insets
- Must not affect non-pinned mode
- `viewportDimension` throws before first layout — needs guard

---

## Acceptance Criteria

1. [ ] Widget pins at scroll area leading edge, not screen origin
2. [ ] Progress starts as soon as widget reaches the scroll area top
3. [ ] Child sizes to scroll viewport, not full screen
4. [ ] Works with AppBar, without AppBar, and with safe areas
5. [ ] Horizontal mode still works correctly
6. [ ] All existing tests pass
7. [ ] `flutter analyze` passes (zero issues)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Pinned with AppBar + Lead-in Content
**Preconditions:** ScrollSequence with `pin: true` inside Scaffold with AppBar, 200px spacer above
**Steps:** Slowly scroll through the sequence
**Expected Result:** Frames start updating as soon as the PinnedScrollSection reaches the app bar's bottom edge, not after scrolling further to the screen top

#### Test Case 2: Pinned without AppBar
**Preconditions:** ScrollSequence with `pin: true`, no AppBar
**Steps:** Scroll through the sequence
**Expected Result:** Behavior unchanged from current (no app bar = no extra dead zone)

---

**Created:** 2026-02-26
**Last Updated:** 2026-02-26
**Brief Owner:** Fifty.ai
