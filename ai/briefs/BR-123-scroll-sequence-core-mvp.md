# BR-123: fifty_scroll_sequence — Core Package MVP

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

There is no Flutter package on pub.dev that handles scroll-driven frame sequence animations (Apple-style "video scrubbing" on scroll). Existing scroll animation packages (`flutter_animate`, `flutter_scroll_animation`) only handle widget-level CSS-style animations (fade, slide, scale). None support image sequence scrubbing mapped to scroll position.

The Fifty Flutter Kit ecosystem needs this capability for product showcases, landing pages, and immersive scroll experiences.

**Why does it matter?**

This is a high-impact differentiator — Apple, Samsung, and premium product pages use this technique extensively. Having it as a first-class Flutter package fills a genuine gap in the ecosystem and on pub.dev.

---

## Goal

**What should happen after this brief is completed?**

A new `fifty_scroll_sequence` package exists at `packages/fifty_scroll_sequence/` with core MVP functionality:
- Package scaffold following ecosystem conventions (`lib/src/`, barrel export)
- Frame path resolution (`{index}` pattern → actual file paths with zero-padding)
- Asset-based frame loading (from Flutter asset bundle)
- Basic LRU memory cache for decoded `ui.Image` frames
- Frame controller (scroll position → frame index mapping)
- Frame display widget (renders current frame via `RawImage`)
- Basic `ScrollSequence` widget (**non-pinned mode only**) that maps scroll progress to frame index
- `flutter analyze` passes with zero issues

This is the foundation — independently useful for inline (non-pinned) scroll animations.

---

## Context & Inputs

### Affected Modules
- [ ] Other: New package `packages/fifty_scroll_sequence/`

### Layers Touched
- [x] View (UI widgets — ScrollSequence widget, FrameDisplay)
- [x] Model (FrameInfo, ScrollSequenceConfig data classes)
- [x] Service (frame loading, caching)

### API Changes
- [x] No API changes

### Dependencies
- [x] No external packages required (Flutter SDK only)
- Optional: `fifty_tokens` as peer dependency for any default styling

### Related Files (New)
- `packages/fifty_scroll_sequence/pubspec.yaml`
- `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` (barrel)
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart`
- `packages/fifty_scroll_sequence/lib/src/widgets/frame_display.dart`
- `packages/fifty_scroll_sequence/lib/src/core/frame_controller.dart`
- `packages/fifty_scroll_sequence/lib/src/core/frame_cache_manager.dart`
- `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart`
- `packages/fifty_scroll_sequence/lib/src/loaders/frame_loader.dart`
- `packages/fifty_scroll_sequence/lib/src/loaders/asset_frame_loader.dart`
- `packages/fifty_scroll_sequence/lib/src/models/scroll_sequence_config.dart`
- `packages/fifty_scroll_sequence/lib/src/models/frame_info.dart`
- `packages/fifty_scroll_sequence/lib/src/utils/frame_path_resolver.dart`
- `packages/fifty_scroll_sequence/analysis_options.yaml`
- `packages/fifty_scroll_sequence/README.md`
- `packages/fifty_scroll_sequence/CHANGELOG.md`
- `packages/fifty_scroll_sequence/LICENSE`

---

## Constraints

### Architecture Rules
- Follow ecosystem package conventions: `lib/src/` structure, barrel export at `lib/fifty_scroll_sequence.dart`
- Zero external dependencies for core (Flutter SDK only)
- All public APIs must have dartdoc comments
- `ui.Image` objects MUST be disposed on cache eviction to prevent memory leaks
- Frame display must NEVER show blank/empty state — always show nearest loaded frame (gapless)

### Technical Constraints
- Frame switching must happen in under 16ms (one frame at 60fps)
- All image loading/decoding async — must not block UI thread
- LRU cache with configurable max size
- Support `BoxFit` modes for frame rendering
- Scroll progress clamped to 0.0–1.0 (handle iOS overscroll bounce)

### Out of Scope
- Pinning/sticky behavior (BR-124)
- Lerping/smoothing (BR-124)
- Network frame loading (BR-125)
- Sprite sheet loading (BR-125)
- Preload strategies beyond eager (BR-125)
- ScrollSequenceController (BR-126)
- SliverScrollSequence (BR-126)
- Example app (BR-126)

---

## Tasks

### Pending
- [ ] Task 1: Create package scaffold (pubspec.yaml, analysis_options, barrel export, LICENSE, README stub, CHANGELOG)
- [ ] Task 2: Implement `FrameInfo` model (frame index, path, dimensions metadata)
- [ ] Task 3: Implement `ScrollSequenceConfig` model (configuration data class)
- [ ] Task 4: Implement `FramePathResolver` — resolve `{index}` patterns with zero-padding, auto-pad-width from frameCount, indexOffset support
- [ ] Task 5: Implement abstract `FrameLoader` base class
- [ ] Task 6: Implement `AssetFrameLoader` — load frames from rootBundle, decode via `ui.instantiateImageCodec`
- [ ] Task 7: Implement `FrameCacheManager` — LRU cache for `ui.Image` objects with configurable max size, proper disposal on eviction, duplicate load deduplication
- [ ] Task 8: Implement `FrameController` — scroll progress (0.0–1.0) → frame index mapping, clamping, listener notification (no lerping yet — that's BR-124)
- [ ] Task 9: Implement `ScrollProgressTracker` — observe scroll position, calculate normalized progress for non-pinned mode (widget position relative to viewport)
- [ ] Task 10: Implement `FrameDisplay` widget — render `ui.Image` via `RawImage`, support `BoxFit`, gapless playback (show nearest loaded frame if target not ready)
- [ ] Task 11: Implement `ScrollSequence` widget (non-pinned mode) — integrate all components, support `placeholder`, `loadingBuilder`, eager preload
- [ ] Task 12: Write unit tests for `FramePathResolver`, `FrameCacheManager`, `FrameController`
- [ ] Task 13: Run `flutter analyze` — zero issues

---

## Session State (Tactical - This Brief)

**Current State:** COMPLETE — WARDEN APPROVED, committing
**Next Steps When Resuming:** N/A — brief complete
**Last Updated:** 2026-02-25
**Blockers:** None

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] Package exists at `packages/fifty_scroll_sequence/` with proper ecosystem structure
2. [ ] `FramePathResolver` correctly resolves `{index}` patterns with zero-padding and offset
3. [ ] `AssetFrameLoader` loads and decodes frames from Flutter assets
4. [ ] `FrameCacheManager` implements LRU eviction with proper `ui.Image.dispose()` on eviction
5. [ ] `FrameController` maps progress 0.0→frame 0, progress 1.0→frame (count-1)
6. [ ] `ScrollSequence` widget renders frames that update on scroll in non-pinned mode
7. [ ] Frame display never shows blank state during scroll — gapless playback works
8. [ ] All public APIs have dartdoc comments
9. [ ] `flutter analyze` passes (zero issues)
10. [ ] Unit tests pass for FramePathResolver, FrameCacheManager, FrameController

---

## Test Plan

### Automated Tests
- [ ] Unit test: FramePathResolver — `{index}` replacement, auto-pad-width, custom pad widths, index offset, edge cases (frameCount=1)
- [ ] Unit test: FrameCacheManager — LRU eviction, max size respected, duplicate load deduplication, clearAll frees references
- [ ] Unit test: FrameController — linear progress→frame mapping, boundary conditions (0.0→0, 1.0→count-1), clamping (progress < 0 or > 1)

### Manual Test Cases

#### Test Case 1: Basic Scroll Sequence
**Preconditions:** Package integrated in a test app with sample frames in assets
**Steps:**
1. Place ScrollSequence widget in a SingleChildScrollView
2. Scroll down through the widget
3. Observe frame changes

**Expected Result:** Frames update smoothly as scroll position changes. First frame at top, last frame at bottom. No blank flashes.

---

## Delivery

### Code Changes
- [x] New files created: ~15 files (package scaffold + all source files listed above)
- [ ] Modified files: Root `pubspec.yaml` if workspace references needed
- [ ] Deleted files: None

### Documentation Updates
- [ ] README: Package README with installation, quick start, API reference
- [ ] CHANGELOG: Initial 0.1.0 entry

---

## Notes

**Reference spec:** The full technical specification is provided by the user — covers all 4 phases of implementation. This brief covers Phase 1 (Core MVP) only.

**Ecosystem naming:** Package follows `fifty_` prefix convention → `fifty_scroll_sequence` (not `scroll_sequence` as in the standalone spec).

**Key technical decisions:**
- Use `RawImage` for frame display (most performant for `ui.Image`)
- Eager loading only in this phase — chunked/progressive deferred to BR-125
- No pinning in this phase — pure viewport-relative progress tracking

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Fifty.ai
