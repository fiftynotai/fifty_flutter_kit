# BR-124: fifty_scroll_sequence — Pinning & Smoothing

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

After BR-123, the `fifty_scroll_sequence` package has basic non-pinned scroll-to-frame mapping. But the signature Apple-style effect requires two critical features:

1. **Pinning (sticky behavior):** The section must "stick" to the viewport while the user scrolls through the frame sequence, then release. Without this, the animation just plays as the widget passes through the viewport — not the immersive full-screen experience.

2. **Smooth lerping:** Without interpolation, frame transitions are instant and jittery — jumping directly to the target frame on each scroll event. A ticker-based lerp toward the target frame creates the buttery-smooth feel users expect.

**Why does it matter?**

Pinning + smoothing are what make this effect actually look like Apple's product pages. Without them, it's just an image slideshow. These are the features that justify the package's existence.

---

## Goal

**What should happen after this brief is completed?**

The `fifty_scroll_sequence` package gains:
- **PinnedScrollSection** — widget stays fixed on screen while scrollExtent pixels are scrolled through, then releases
- **Ticker-based frame lerping** — smooth interpolation from current frame toward target at configurable lerpFactor (default 0.15)
- **`builder` parameter** — wrap frame image with overlay widgets reacting to frameIndex and progress
- **`onFrameChanged` callback** — fires when displayed frame index changes
- **Gapless playback hardened** — never show blank during fast scrolling in pinned mode
- Pin mode works in `SingleChildScrollView`, `ListView`, and `CustomScrollView` contexts

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/`

### Layers Touched
- [x] View (PinnedScrollSection widget, ScrollSequence widget updates)
- [x] Model (config updates for pin/lerp parameters)

### API Changes
- [x] No API changes

### Dependencies
- [x] No new packages — uses Flutter's `Ticker`, `ScrollNotification`, `SliverLayoutBuilder`
- Depends on: BR-123 (core MVP)

### Related Files (Modified/New)
- `packages/fifty_scroll_sequence/lib/src/widgets/pinned_scroll_section.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` (MODIFIED — add pin, builder, onFrameChanged, lerpFactor, curve)
- `packages/fifty_scroll_sequence/lib/src/core/frame_controller.dart` (MODIFIED — add ticker-based lerp loop)
- `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart` (MODIFIED — add pinned mode tracking)
- `packages/fifty_scroll_sequence/lib/src/utils/lerp_util.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` (MODIFIED — add new exports)

---

## Constraints

### Architecture Rules
- Lerp ticker MUST run independently of scroll events via `Ticker` or `AnimationController` (vsync'd at 60fps)
- Scroll events update the target; ticker drives the display — this prevents jank when scroll events fire irregularly
- Pin implementation must not break non-pinned mode — `pin: false` should still work exactly as BR-123
- Widget lifecycle: ticker MUST stop on dispose, pause when app backgrounded (`WidgetsBindingObserver`)
- iOS overscroll bounce: progress clamped 0.0–1.0 even with bounce physics

### Technical Constraints
- Pinned section creates scroll "runway" of `scrollExtent` pixels while keeping display viewport-sized
- Multiple ScrollSequence widgets on same page must each have independent state (no globals)
- `builder` callback receives `(context, frameIndex, progress, child)` — child is the frame image

### Out of Scope
- Advanced preload strategies (BR-125)
- Network/sprite sheet loading (BR-125)
- ScrollSequenceController (BR-126)
- SliverScrollSequence (BR-126)

---

## Tasks

### Pending
- [ ] Task 1: Implement `LerpUtil` — smooth frame interpolation helper, configurable lerpFactor
- [ ] Task 2: Add ticker-based lerp loop to `FrameController` — runs at vsync, interpolates `_currentFrameFloat` toward target, notifies only on actual frame change
- [ ] Task 3: Add `WidgetsBindingObserver` to pause/resume ticker on app lifecycle changes
- [ ] Task 4: Implement `PinnedScrollSection` — creates SizedBox(height: viewportHeight + scrollExtent), positions child sticky while scroll passes through, calculates progress 0.0→1.0 during pin phase
- [ ] Task 5: Update `ScrollProgressTracker` to support pinned mode — detect when section top reaches viewport top, track progress through scrollExtent, detect unpin
- [ ] Task 6: Update `ScrollSequence` widget — add `pin`, `builder`, `onFrameChanged`, `lerpFactor`, `curve` parameters
- [ ] Task 7: Integrate `Curve` transform in `FrameController` — apply curve to progress before mapping to frame index
- [ ] Task 8: Harden gapless playback for pinned mode — fallback to nearest loaded frame during fast scroll
- [ ] Task 9: Write unit tests for lerp convergence, pin progress calculation, curve transforms
- [ ] Task 10: Write widget test for pinning behavior (pins at correct position, unpins after scrollExtent)
- [ ] Task 11: Run `flutter analyze` — zero issues

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Start with Task 1 (LerpUtil)
**Last Updated:** 2026-02-25
**Blockers:** Depends on BR-123 completion

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `pin: true` causes the widget to stick while scrollExtent pixels are consumed, then release
2. [ ] Frame transitions are smooth with default lerpFactor (0.15) — no jittery frame jumping
3. [ ] Lerp ticker runs at vsync and pauses/resumes with app lifecycle
4. [ ] `builder` callback works — overlays can react to frameIndex and progress
5. [ ] `onFrameChanged` fires on each frame index change with correct index and progress
6. [ ] `curve` parameter applies transform to scroll-to-frame mapping (e.g., `Curves.easeInOut`)
7. [ ] `pin: false` still works correctly (non-pinned mode from BR-123 unbroken)
8. [ ] No blank frames visible during normal-speed scrolling in pinned mode
9. [ ] iOS overscroll bounce handled — progress clamped 0.0–1.0
10. [ ] `flutter analyze` passes (zero issues)
11. [ ] Unit and widget tests pass

---

## Test Plan

### Automated Tests
- [ ] Unit test: FrameController lerp — converges toward target, respects lerpFactor
- [ ] Unit test: FrameController curve — easeInOut transform applied correctly
- [ ] Unit test: Pin progress — 0.0 at pin start, 1.0 at pin end, clamped
- [ ] Widget test: PinnedScrollSection — widget pins at correct scroll offset, unpins after scrollExtent

### Manual Test Cases

#### Test Case 1: Pinned Scroll Sequence
**Preconditions:** ScrollSequence with pin: true in a scrollable page
**Steps:**
1. Scroll down until the sequence section reaches the top
2. Continue scrolling — section should stay fixed while frames animate
3. After scrollExtent consumed, section should unpin and scroll away

**Expected Result:** Section pins, frames animate smoothly through full range, section unpins. No jitter or blank frames.

#### Test Case 2: Builder Overlay
**Preconditions:** ScrollSequence with builder that shows text overlay at specific frame ranges
**Steps:**
1. Scroll through the pinned sequence
2. Observe overlay text appearing/disappearing based on frame index

**Expected Result:** Overlay widgets render correctly, react to frameIndex and progress values.

---

## Delivery

### Code Changes
- [x] New files created: 2 (PinnedScrollSection, LerpUtil)
- [x] Modified files: 4 (ScrollSequence widget, FrameController, ScrollProgressTracker, barrel export)

---

## Notes

**Critical implementation detail from spec:** The lerping MUST run on a ticker (vsync'd animation frame loop), NOT only on scroll events. Scroll events fire irregularly and can stop firing while the lerp is still catching up. Use a `Ticker` or `AnimationController` to drive the lerp loop at 60fps, and update the target from scroll events.

**Pinning approach:** Use `SizedBox(height: viewportHeight + scrollExtent)` as the scroll runway, with a `Stack` + `Positioned` child that calculates its sticky offset based on scroll position. When the section's top reaches the viewport top, start tracking progress until scrollExtent is consumed.

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Fifty.ai
