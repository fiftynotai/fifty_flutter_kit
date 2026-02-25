# BR-127: fifty_scroll_sequence — Snap, Lifecycle Callbacks & Horizontal Scroll

**Type:** Feature
**Priority:** P3-Low
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

After BR-123–126, the `fifty_scroll_sequence` package handles scroll-driven image sequences with pinning, smoothing, smart loading, and programmatic control. However, three features commonly expected by developers coming from GSAP ScrollTrigger are missing:

1. **Snap** — When the user stops scrolling mid-sequence, the animation sits on an awkward in-between frame. GSAP's `snap` auto-settles to the nearest keyframe or progress point, giving a polished "click into place" feel. This is especially important for sequences with distinct scenes (e.g., frame 0–50 = front view, 51–100 = side view, 101–148 = back view).

2. **Lifecycle callbacks (onEnter/onLeave)** — Developers need to know when the sequence enters or exits the viewport to trigger preloading, analytics events, pause/resume background work, or sync other UI elements. Currently only `onFrameChanged` exists (fires during scrub), but there's no way to detect viewport entry/exit.

3. **Horizontal scroll** — Some product showcases and landing pages use horizontal scrolling. The package currently assumes vertical scroll only, blocking horizontal layout use cases.

**Why does it matter?**

These are the three most commonly expected features by web developers migrating to Flutter. Adding them makes the package feel complete and familiar to anyone who's used ScrollTrigger, without scope-creeping into a generic animation library.

---

## Goal

**What should happen after this brief is completed?**

The `fifty_scroll_sequence` package gains three polished features:

- **Snap system** — `snapPoints` parameter accepts a list of progress values (0.0–1.0) or frame indices. When user stops scrolling, the scroll position animates to the nearest snap point. Configurable snap duration and easing curve.
- **Lifecycle callbacks** — `onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack` callbacks fire when the sequence widget enters/exits the viewport from either direction. Works in both pinned and non-pinned modes.
- **Horizontal scroll** — `scrollDirection: Axis.horizontal` parameter. Frame progress maps to horizontal scroll position. Pinning works horizontally. Works in both `ScrollSequence` and `SliverScrollSequence`.

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/`

### Layers Touched
- [x] View (ScrollSequence widget — new parameters)
- [x] Model (snap config, lifecycle event types)
- [x] Service (scroll tracking — direction-aware viewport detection)

### API Changes
- [x] No API changes

### Dependencies
- [x] No new packages
- Depends on: BR-123, BR-124, BR-125, BR-126

### Related Files (New/Modified)
- `packages/fifty_scroll_sequence/lib/src/models/snap_config.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/core/snap_controller.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/core/viewport_observer.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` (MODIFIED — new parameters)
- `packages/fifty_scroll_sequence/lib/src/widgets/sliver_scroll_sequence.dart` (MODIFIED — horizontal + snap + lifecycle)
- `packages/fifty_scroll_sequence/lib/src/widgets/pinned_scroll_section.dart` (MODIFIED — horizontal support)
- `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart` (MODIFIED — horizontal + viewport enter/leave detection)
- `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` (MODIFIED — new exports)

---

## Constraints

### Architecture Rules
- Snap animation must use Flutter's `ScrollController.animateTo()` — don't fight the scroll physics
- Lifecycle callbacks must be symmetrical: onEnter/onLeave for forward scroll, onEnterBack/onLeaveBack for reverse
- Horizontal mode must share the same FrameController, cache, and loader infrastructure — only the scroll axis changes
- All three features are opt-in — default behavior is unchanged (no snap, no lifecycle callbacks, vertical scroll)

### Technical Constraints
- **Snap:** Must debounce — only snap after user stops scrolling (use `ScrollEndNotification` or idle detection with ~150ms timeout). Snap animation must be cancellable if user resumes scrolling.
- **Lifecycle:** Viewport detection must account for pinned mode (the widget is "in viewport" for the entire pin duration, so onEnter fires at pin start, onLeave fires at unpin)
- **Horizontal:** Pinning in horizontal mode means the widget sticks while horizontal scroll progresses through scrollExtent. Must work with both `SingleChildScrollView(scrollDirection: Axis.horizontal)` and `CustomScrollView(scrollDirection: Axis.horizontal)`

### Out of Scope
- Generic property scrubbing (not an image sequence feature)
- Toggle classes (Flutter has no CSS class system)
- Batch processing (not relevant to image sequences)
- Debug markers (nice-to-have for a separate brief)
- Responsive breakpoints (Flutter handles this with `LayoutBuilder`/`MediaQuery`)

---

## Tasks

### Pending

**Snap:**
- [ ] Task 1: Define `SnapConfig` model — `snapPoints` (List<double> progress values OR List<int> frame indices), `snapDuration` (default 300ms), `snapCurve` (default Curves.easeOut)
- [ ] Task 2: Implement `SnapController` — listens for scroll idle, finds nearest snap point, animates scroll to target, cancels on new scroll input
- [ ] Task 3: Add `snapConfig` parameter to `ScrollSequence` and `SliverScrollSequence` widgets
- [ ] Task 4: Add convenience constructor `SnapConfig.everyNFrames(int n)` — generates snap points every N frames
- [ ] Task 5: Add convenience constructor `SnapConfig.scenes(List<int> sceneStartFrames)` — snap to scene boundaries

**Lifecycle Callbacks:**
- [ ] Task 6: Implement `ViewportObserver` — tracks widget visibility in viewport, detects entry/exit direction (forward vs backward scroll)
- [ ] Task 7: Add `onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack` callback parameters to `ScrollSequence`
- [ ] Task 8: Handle pinned mode lifecycle — onEnter at pin start, onLeave at unpin, onEnterBack/onLeaveBack on reverse
- [ ] Task 9: Ensure callbacks fire exactly once per transition (debounce, no duplicate fires)

**Horizontal Scroll:**
- [ ] Task 10: Add `scrollDirection` parameter (default `Axis.vertical`) to `ScrollSequence` and `SliverScrollSequence`
- [ ] Task 11: Update `ScrollProgressTracker` to calculate progress on horizontal axis when `scrollDirection: Axis.horizontal`
- [ ] Task 12: Update `PinnedScrollSection` to pin horizontally (sticky left instead of sticky top)
- [ ] Task 13: Test horizontal mode in `SingleChildScrollView(scrollDirection: Axis.horizontal)` and `CustomScrollView(scrollDirection: Axis.horizontal)`

**Tests & Polish:**
- [ ] Task 14: Unit tests — SnapController (nearest point, debounce, cancel on resume), ViewportObserver (enter/leave/enterBack/leaveBack firing)
- [ ] Task 15: Widget tests — snap settles to correct point, lifecycle callbacks fire in correct order, horizontal scroll maps to frame progress
- [ ] Task 16: Update README — document snap, lifecycle, and horizontal features with examples
- [ ] Task 17: Run `flutter analyze` — zero issues

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Start with Task 1 (SnapConfig model)
**Last Updated:** 2026-02-25
**Blockers:** Depends on BR-123, BR-124, BR-125, BR-126 completion

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `snapConfig: SnapConfig(snapPoints: [0.0, 0.33, 0.66, 1.0])` causes scroll to auto-settle to nearest point when user stops scrolling
2. [ ] `SnapConfig.everyNFrames(50)` generates correct snap points for given frameCount
3. [ ] `SnapConfig.scenes([0, 50, 100])` snaps to scene boundaries
4. [ ] Snap animation is cancellable — resuming scroll mid-snap interrupts it cleanly
5. [ ] `onEnter` fires once when sequence enters viewport (forward scroll)
6. [ ] `onLeave` fires once when sequence exits viewport (forward scroll)
7. [ ] `onEnterBack` fires once when sequence re-enters viewport (backward scroll)
8. [ ] `onLeaveBack` fires once when scrolling back past sequence start
9. [ ] In pinned mode: onEnter at pin start, onLeave at unpin
10. [ ] `scrollDirection: Axis.horizontal` maps horizontal scroll progress to frame index
11. [ ] Horizontal pinning works (widget sticks during horizontal scrollExtent)
12. [ ] All three features are opt-in — omitting them preserves existing behavior
13. [ ] `flutter analyze` passes (zero issues)
14. [ ] Unit and widget tests pass

---

## Test Plan

### Automated Tests
- [ ] Unit test: SnapController — finds nearest snap point from progress value, handles edge cases (exactly on snap point, between two equidistant points)
- [ ] Unit test: SnapConfig.everyNFrames — generates correct points for various frameCounts
- [ ] Unit test: ViewportObserver — fires correct callback for each scroll direction transition
- [ ] Widget test: Snap — simulate scroll then idle, verify scroll position settles to nearest snap point
- [ ] Widget test: Lifecycle — simulate scroll through sequence, verify onEnter/onLeave fire in correct order
- [ ] Widget test: Horizontal — verify frame progress updates on horizontal scroll

### Manual Test Cases

#### Test Case 1: Scene Snapping
**Preconditions:** ScrollSequence with 150 frames and SnapConfig.scenes([0, 50, 100])
**Steps:**
1. Scroll to ~frame 35 and release
2. Observe scroll auto-settling to frame 50 (nearest scene boundary)
3. Quickly resume scrolling mid-snap

**Expected Result:** Snap animates to frame 50. Resuming scroll cancels snap cleanly.

#### Test Case 2: Lifecycle Callbacks
**Preconditions:** ScrollSequence with all 4 lifecycle callbacks logging to console
**Steps:**
1. Scroll down past the sequence (should fire onEnter then onLeave)
2. Scroll back up through the sequence (should fire onEnterBack then onLeaveBack)

**Expected Result:** Each callback fires exactly once per transition, in correct order.

#### Test Case 3: Horizontal Scroll
**Preconditions:** ScrollSequence with scrollDirection: Axis.horizontal inside horizontal SingleChildScrollView
**Steps:**
1. Swipe horizontally through the sequence
2. Observe frames updating based on horizontal scroll progress

**Expected Result:** Frames update on horizontal scroll. Pinning works horizontally.

---

## Delivery

### Code Changes
- [x] New files created: 3 (SnapConfig, SnapController, ViewportObserver)
- [x] Modified files: 5 (ScrollSequence, SliverScrollSequence, PinnedScrollSection, ScrollProgressTracker, barrel export)

### Documentation Updates
- [ ] README: Add Snap, Lifecycle, and Horizontal sections with code examples
- [ ] CHANGELOG: 0.2.0 entry for these features

---

## Notes

**Inspired by GSAP ScrollTrigger** — these three features are cherry-picked from ScrollTrigger's API as the most valuable for image sequence use cases, without scope-creeping into a generic scroll animation library.

**Snap UX reference:** Apple's own product pages snap between "scenes" in the frame sequence. For example, AirPods page snaps between front view → side view → case view. This is the exact behavior `SnapConfig.scenes()` enables.

**API examples for README:**

```dart
// Snap to scenes
ScrollSequence(
  frameCount: 148,
  framePath: 'assets/frames/shoe_{index}.webp',
  snapConfig: SnapConfig.scenes([0, 50, 100, 148]),
)

// Lifecycle callbacks
ScrollSequence(
  frameCount: 148,
  framePath: 'assets/frames/shoe_{index}.webp',
  onEnter: () => startPreloading(),
  onLeave: () => analytics.track('sequence_viewed'),
)

// Horizontal scroll
ScrollSequence(
  frameCount: 148,
  framePath: 'assets/frames/shoe_{index}.webp',
  scrollDirection: Axis.horizontal,
)
```

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Fifty.ai
