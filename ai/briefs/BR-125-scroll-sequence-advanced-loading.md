# BR-125: fifty_scroll_sequence — Advanced Loading Strategies

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

After BR-123 + BR-124, the package only supports eager loading from local assets. This is fine for small frame counts (<50), but real-world usage involves 100–400+ frames at 1080p resolution. Eager loading all frames would consume 800MB+ of memory — unacceptable on mobile.

Additionally, many production use cases need to load frames from CDN URLs (web deployments, dynamic content) or use sprite sheets to reduce file count.

**Why does it matter?**

Without chunked/progressive loading, the package is unusable for real-world frame counts. Without network loading, it can't serve web or dynamic content scenarios. These are the features that make the package production-ready.

---

## Goal

**What should happen after this brief is completed?**

The `fifty_scroll_sequence` package gains:
- **PreloadStrategy** system — pluggable strategies for when/how frames are preloaded
  - `PreloadStrategy.eager()` — load all frames upfront (existing behavior, for small counts)
  - `PreloadStrategy.chunked()` — load chunks around current scroll position (default for most use cases)
  - `PreloadStrategy.progressive()` — load keyframes first, fill gaps progressively (best for large counts/network)
- **NetworkFrameLoader** — load frames from URLs with disk caching, custom headers, download progress
- **SpriteSheetLoader** — load frames from sprite sheet grid images (crop individual frames)
- **Loading progress** — `loadingBuilder` receives accurate 0.0–1.0 progress during preload
- **Scroll direction detection** — preload more frames in the user's scroll direction
- **`ScrollSequence.network()` constructor** — convenience for network-sourced sequences
- **`ScrollSequence.spriteSheet()` constructor** — convenience for sprite sheet sequences

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/`

### Layers Touched
- [x] View (ScrollSequence widget — new constructors, loading UI)
- [x] Service (new loaders, preload strategies)
- [x] Model (PreloadStrategy classes)

### API Changes
- [x] No API changes

### Dependencies
- [x] New package (optional): `http` — only for NetworkFrameLoader
- [x] Uses `path_provider` for disk cache directory (network loader)
- Depends on: BR-123 (core MVP), BR-124 (pinning/smoothing)

### Related Files (New/Modified)
- `packages/fifty_scroll_sequence/lib/src/strategies/preload_strategy.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/strategies/cache_strategy.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/loaders/network_frame_loader.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/loaders/sprite_sheet_loader.dart` (NEW)
- `packages/fifty_scroll_sequence/lib/src/core/frame_cache_manager.dart` (MODIFIED — integrate strategies, direction-aware preloading)
- `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` (MODIFIED — new constructors, loadingBuilder integration)
- `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` (MODIFIED — new exports)
- `packages/fifty_scroll_sequence/pubspec.yaml` (MODIFIED — add optional deps)

---

## Constraints

### Architecture Rules
- Preloading MUST NOT block the UI thread — all image loading/decoding is async
- NetworkFrameLoader must cache downloaded frames to disk (temp directory) — no re-downloading on subsequent loads
- SpriteSheetLoader extracts frames by drawing crop region to new `ui.Image` via `Canvas` + `PictureRecorder`
- Memory ceiling: default chunked strategy should keep usage under ~200MB for 1080p frames
- `http` dependency must be optional — package works without it if only using asset/sprite sheet loaders

### Technical Constraints
- Chunked strategy defaults: chunkSize=40, preloadAhead=30, preloadBehind=10
- Progressive strategy defaults: keyframeCount=20 (evenly-spaced priority frames loaded first)
- Scroll direction detection: use delta between consecutive scroll positions to bias preload direction
- Cache eviction must call `ui.Image.dispose()` on evicted frames
- Duplicate load requests must be deduplicated (don't start loading a frame that's already being loaded)

### Out of Scope
- ScrollSequenceController (BR-126)
- SliverScrollSequence (BR-126)
- Example app (BR-126)
- `ScrollSequence.fromVideo()` constructor (future — requires video_player dependency)

---

## Tasks

### Pending
- [ ] Task 1: Implement `PreloadStrategy` — abstract base with `eager()`, `chunked()`, `progressive()` factory constructors
- [ ] Task 2: Implement eager strategy — loads all frames on init, simplest path
- [ ] Task 3: Implement chunked strategy — maintains window of loaded frames around current position, evicts frames outside range
- [ ] Task 4: Implement progressive strategy — load keyframes (evenly spaced) first, then fill gaps bidirectionally from current position
- [ ] Task 5: Integrate strategies into `FrameCacheManager` — strategy drives what to preload/evict on each frame change
- [ ] Task 6: Add scroll direction detection to `ScrollProgressTracker` — expose `scrollDirection` (forward/backward) based on scroll delta
- [ ] Task 7: Implement `NetworkFrameLoader` — HTTP download, disk caching via path_provider temp dir, custom headers, progress callback
- [ ] Task 8: Implement `SpriteSheetLoader` — load sheet image(s), calculate crop rect per frame (`col * frameWidth, row * frameHeight`), extract to individual `ui.Image` via Canvas+PictureRecorder
- [ ] Task 9: Add `ScrollSequence.network()` named constructor — convenience wiring of NetworkFrameLoader
- [ ] Task 10: Add `ScrollSequence.spriteSheet()` named constructor — convenience wiring of SpriteSheetLoader
- [ ] Task 11: Integrate `loadingBuilder` with accurate progress tracking (loaded/total frames)
- [ ] Task 12: Write unit tests for PreloadStrategy (chunked range, progressive keyframe selection), NetworkFrameLoader (disk cache hit/miss), SpriteSheetLoader (crop rect calculation)
- [ ] Task 13: Run `flutter analyze` — zero issues

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A — all tasks done
**Last Updated:** 2026-02-25
**Blockers:** None

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `PreloadStrategy.eager()` loads all frames upfront (backward compatible with BR-123)
2. [ ] `PreloadStrategy.chunked()` keeps ~40 frames loaded around current position, evicts outside range
3. [ ] `PreloadStrategy.progressive()` loads keyframes first, then fills gaps
4. [ ] Memory usage stays under ~200MB for 150 frames at 1080p with chunked strategy
5. [ ] `ScrollSequence.network()` loads frames from URLs and caches to disk
6. [ ] `ScrollSequence.spriteSheet()` extracts frames from grid sprite sheets
7. [ ] `loadingBuilder` shows accurate loading progress (0.0–1.0)
8. [ ] Scroll direction detection biases preloading toward user's scroll direction
9. [ ] No duplicate frame load requests for the same frame index
10. [ ] `ui.Image.dispose()` called on every evicted frame — no memory leaks
11. [ ] `flutter analyze` passes (zero issues)
12. [ ] Unit tests pass for all strategies and loaders

---

## Test Plan

### Automated Tests
- [ ] Unit test: Chunked strategy — correct range around center, eviction outside range
- [ ] Unit test: Progressive strategy — keyframes evenly spaced, gap filling order
- [ ] Unit test: NetworkFrameLoader — disk cache hit returns cached, miss downloads and caches
- [ ] Unit test: SpriteSheetLoader — crop rect calculation for given columns/rows/frameWidth/frameHeight
- [ ] Unit test: FrameCacheManager — LRU eviction with strategy integration, dispose called on eviction

### Manual Test Cases

#### Test Case 1: Chunked Loading with 200 Frames
**Preconditions:** 200 asset frames, chunked strategy with default params
**Steps:**
1. Open page with ScrollSequence (200 frames, chunked)
2. Scroll slowly through entire sequence
3. Monitor memory usage (Dart DevTools)

**Expected Result:** Memory stays under 200MB. Frames load ahead of scroll position. No visible loading gaps during normal-speed scrolling.

#### Test Case 2: Network Loading
**Preconditions:** Frame images hosted on a server/CDN
**Steps:**
1. Open page with ScrollSequence.network()
2. Observe loading progress indicator
3. Scroll through after loading

**Expected Result:** Progress indicator shows accurate loading. After first load, frames cached to disk. Second visit loads instantly from disk cache.

---

## Delivery

### Code Changes
- [x] New files created: 5 (PreloadStrategy, CacheStrategy, NetworkFrameLoader, SpriteSheetLoader, direction detection)
- [x] Modified files: 4 (FrameCacheManager, ScrollSequence widget, ScrollProgressTracker, barrel export)

---

## Notes

**Memory estimates per frame (reference):**
- 1920x1080 RGBA: ~8.3 MB per frame in memory
- 1280x720 RGBA: ~3.7 MB per frame
- 40 frames at 1080p ≈ 332 MB → chunk size tuning documented in README

**Image format recommendations for README:**
- WebP: smallest file size, fast decode — best overall
- JPEG: fast decode, no transparency — good for photos
- PNG: largest, medium decode — only if transparency needed

**Sprite sheet ffmpeg command for README:**
```bash
ffmpeg -i video.mp4 -vf "fps=30,scale=320:180,tile=10x10" sprite_%02d.webp
```

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Fifty.ai
