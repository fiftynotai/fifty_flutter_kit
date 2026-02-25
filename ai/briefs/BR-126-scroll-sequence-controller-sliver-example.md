# BR-126: fifty_scroll_sequence — Controller, Sliver, & Example App

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

After BR-123/124/125, the package is functionally complete but lacks:

1. **Programmatic control** — no way to jump to specific frames, query loading state, or control the sequence from code outside the widget tree.
2. **CustomScrollView support** — users building complex scroll layouts with slivers can't use ScrollSequence as a sliver. They're forced to wrap it in `SliverToBoxAdapter`, which breaks the pinning behavior.
3. **Example app** — no showcase demonstrating usage patterns for the ecosystem's `apps/` directory.
4. **Comprehensive test suite** — MVP tests exist but full coverage is needed before publish.

**Why does it matter?**

The controller is essential for advanced use cases (programmatic navigation, synced UI elements). Sliver support is required for production apps using `CustomScrollView`. The example app serves as both documentation and ecosystem showcase. Tests are required for pub.dev quality.

---

## Goal

**What should happen after this brief is completed?**

The `fifty_scroll_sequence` package is publish-ready:
- **ScrollSequenceController** — ChangeNotifier with currentFrame, progress, loadingProgress, jumpToFrame(), jumpToProgress(), preloadAll(), clearCache()
- **SliverScrollSequence** — sliver widget for CustomScrollView with proper pinning via SliverPersistentHeader
- **Example app** at `apps/scroll_sequence_example/` following ecosystem MVVM+Actions conventions
  - Basic example (simplest usage)
  - Pinned example (sticky with overlays)
  - Multi-sequence example (multiple sequences on one page)
- **Comprehensive test suite** — unit tests for all core classes, widget tests for scroll behavior
- **README** finalized with hero demo, API reference, frame preparation guide, performance tips

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/` (package)
- [ ] Other: `apps/scroll_sequence_example/` (new example app)

### Layers Touched
- [x] View (SliverScrollSequence, example app pages)
- [x] Model (ScrollSequenceController)

### API Changes
- [x] No API changes

### Dependencies
- [x] Example app depends on: `fifty_scroll_sequence`, `fifty_tokens`, `fifty_theme`, `fifty_ui`
- Depends on: BR-123, BR-124, BR-125

### Related Files (New/Modified)

**Package (new/modified):**
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_controller.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/widgets/sliver_scroll_sequence.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` (MODIFIED — accept controller)
- `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` (MODIFIED — new exports)
- `packages/fifty_scroll_sequence/README.md` (REWRITTEN — full documentation)
- `packages/fifty_scroll_sequence/test/` (NEW — comprehensive suite)

**Example app (all new):**
- `apps/scroll_sequence_example/pubspec.yaml`
- `apps/scroll_sequence_example/lib/main.dart`
- `apps/scroll_sequence_example/lib/features/basic/views/basic_page.dart`
- `apps/scroll_sequence_example/lib/features/pinned/views/pinned_page.dart`
- `apps/scroll_sequence_example/lib/features/multi/views/multi_sequence_page.dart`
- `apps/scroll_sequence_example/lib/features/menu/views/menu_page.dart`
- `apps/scroll_sequence_example/assets/frames/` (sample frames)

---

## Constraints

### Architecture Rules
- Example app must follow MVVM+Actions pattern with GetX (ecosystem standard)
- Example app must use FDL components (FiftyButton, FiftyCard, FiftyColors, etc.)
- ScrollSequenceController must extend ChangeNotifier for standard Flutter integration
- SliverScrollSequence must work correctly inside CustomScrollView alongside other slivers
- Controller is optional — ScrollSequence works without it (backward compatible)

### Technical Constraints
- `jumpToFrame()` and `jumpToProgress()` must animate the scroll position (not just snap)
- Controller must expose loading state for UI progress indicators
- SliverScrollSequence uses `SliverPersistentHeader` with `pinned: true` internally
- Sample frames for example app must be lightweight (use small resolution or few frames to keep repo size small)
- Example app needs sample frames in assets — provide ffmpeg command to generate from any video, or include ~20 low-res frames

### Out of Scope
- `ScrollSequence.fromVideo()` constructor (future feature — requires video_player)
- Pub.dev publishing (separate task)
- Integration into fifty_demo app (separate brief)
- Adding to root README showcase grid (separate brief)

---

## Tasks

### Pending
- [ ] Task 1: Implement `ScrollSequenceController` — extends ChangeNotifier, exposes currentFrame, progress, frameCount, isFullyLoaded, loadedFrameCount, loadingProgress
- [ ] Task 2: Add `jumpToFrame(int, {Duration})` and `jumpToProgress(double, {Duration})` to controller — animate scroll position to target
- [ ] Task 3: Add `preloadAll()` and `clearCache()` to controller
- [ ] Task 4: Wire controller into `ScrollSequence` widget — optional `controller` parameter, sync state bidirectionally
- [ ] Task 5: Implement `SliverScrollSequence` — sliver widget using `SliverPersistentHeader` with pinned delegate, same parameters as ScrollSequence
- [ ] Task 6: Create example app scaffold (`apps/scroll_sequence_example/`) — pubspec, main.dart, route setup, menu page
- [ ] Task 7: Create sample frame assets — either include ~20 lightweight frames or generate procedurally (gradient color frames)
- [ ] Task 8: Implement basic example page — simplest ScrollSequence usage (non-pinned)
- [ ] Task 9: Implement pinned example page — pinned mode with text overlays using builder, onFrameChanged, progress indicator
- [ ] Task 10: Implement multi-sequence example page — two ScrollSequence widgets on same page, independent state
- [ ] Task 11: Write comprehensive unit tests — FramePathResolver (all edge cases), FrameCacheManager (LRU, dispose), FrameController (lerp convergence, curves, boundaries), PreloadStrategy (all three types)
- [ ] Task 12: Write widget tests — ScrollSequence renders and updates on scroll, PinnedScrollSection pins/unpins correctly, SliverScrollSequence works in CustomScrollView
- [ ] Task 13: Finalize README — hero section, features, installation, quick start, frame preparation guide (ffmpeg), API reference, advanced usage, performance tips
- [ ] Task 14: Run `flutter analyze` on package AND example app — zero issues
- [ ] Task 15: Run `flutter test` on package — all tests pass

---

## Session State (Tactical - This Brief)

**Current State:** In Progress
**Phase:** COMPLETE
**Active Agent:** None
**Next Steps When Resuming:** N/A — Brief complete
**Last Updated:** 2026-02-26
**Blockers:** None (BR-123/124/125 all Done)

### Agent Log
- ARCHITECT: Plan created at `ai/plans/BR-126-plan.md` — 4 phases, 18 files, M-complexity. Auto-approved.
- FORGER (Phase 1+2): Controller + Sliver implemented. 2 created, 2 modified. Zero analyze issues, 109 tests passing.
- FORGER (Phase 3): Example app created. 10 files. Zero analyze issues.
- FORGER (Phase 4): Tests + README. 75 new tests (184 total), README rewritten. Zero analyze issues.
- SENTINEL: PASS — 173 tests passing, zero analyze issues (package + example app), files verified, backward compatible.
- WARDEN: APPROVE — 2 minor findings fixed (sliver accessor scrollExtent, resource disposal in example). Revalidated: 173 tests, zero issues.

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `ScrollSequenceController` exposes currentFrame, progress, loadingProgress correctly
2. [ ] `jumpToFrame()` animates scroll to show the specified frame
3. [ ] `jumpToProgress()` animates scroll to the specified progress point
4. [ ] `SliverScrollSequence` works inside `CustomScrollView` with proper pinning
5. [ ] Example app runs with 3 demo pages (basic, pinned, multi-sequence)
6. [ ] Example app uses FDL components and follows MVVM+Actions pattern
7. [ ] README includes installation, quick start, ffmpeg guide, API reference, performance tips
8. [ ] Unit tests cover: FramePathResolver, FrameCacheManager, FrameController, PreloadStrategy
9. [ ] Widget tests cover: ScrollSequence rendering, pinning behavior, SliverScrollSequence
10. [ ] `flutter analyze` passes on both package and example app (zero issues)
11. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Automated Tests (Package)
- [ ] Unit test: ScrollSequenceController — state updates, jumpToFrame/Progress
- [ ] Unit test: FramePathResolver — all edge cases (pad width, offset, single frame)
- [ ] Unit test: FrameCacheManager — LRU eviction, max size, dispose on evict, dedup loads
- [ ] Unit test: FrameController — lerp convergence, all curves, boundary conditions
- [ ] Unit test: PreloadStrategy — eager (all loaded), chunked (correct window), progressive (keyframe order)
- [ ] Widget test: ScrollSequence — renders, updates on scroll, placeholder shown during load
- [ ] Widget test: PinnedScrollSection — pins at correct offset, unpins after scrollExtent
- [ ] Widget test: SliverScrollSequence — renders inside CustomScrollView, pin behavior

### Manual Test Cases

#### Test Case 1: Controller Programmatic Control
**Preconditions:** ScrollSequence with controller attached
**Steps:**
1. Call `controller.jumpToFrame(50)` programmatically
2. Observe scroll position animate to frame 50
3. Check `controller.currentFrame == 50` and `controller.progress ≈ 0.33` (for 150 frames)

**Expected Result:** Smooth scroll animation to target frame, controller state accurate.

#### Test Case 2: CustomScrollView Sliver
**Preconditions:** CustomScrollView with SliverAppBar + SliverScrollSequence + SliverList
**Steps:**
1. Scroll past SliverAppBar
2. SliverScrollSequence should pin and play frame sequence
3. After sequence complete, SliverList content scrolls in

**Expected Result:** Sliver-based pinning works seamlessly with other slivers.

---

## Delivery

### Code Changes
- [x] New files created: ~15 (controller, sliver widget, example app files, test files)
- [x] Modified files: 3 (ScrollSequence widget, barrel export, README)

### Documentation Updates
- [ ] README: Full documentation with all sections
- [ ] CHANGELOG: Updates for all 4 phases (0.1.0 initial release)

---

## Notes

**Sample frames for example app:** Generate procedural gradient frames (e.g., hue rotation from 0° to 360° across frameCount) to avoid bundling large image assets in the repo. Alternatively, include ~20 low-res (320x180) WebP frames. Keep total asset size under 2MB.

**README hero section:** Create a compelling demo GIF showing the scroll-driven animation effect. This is the #1 driver of pub.dev adoption.

**Publish preparation (not in scope, future task):**
- Update root README package table
- Add to fifty_demo app as a new demo page
- Publish to pub.dev under fifty.dev publisher

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Fifty.ai
