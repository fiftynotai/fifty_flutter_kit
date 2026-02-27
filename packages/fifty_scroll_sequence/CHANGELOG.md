# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-27

### Added

- Pinned mode with `PinnedScrollSection` for viewport-sticky scrubbing.
- `SliverScrollSequence` for `CustomScrollView` integration.
- `ScrollSequenceController` for programmatic jump-to-frame/progress, preloading, and cache management.
- `NetworkFrameLoader` for HTTP frame loading with disk caching (dart:io HttpClient).
- `SpriteSheetLoader` with multi-sheet grid extraction and lazy-loaded sheet caching.
- Three `PreloadStrategy` implementations: eager, chunked (sliding window), progressive (keyframes first).
- `SnapConfig` with three constructors: explicit points, everyNFrames, scenes.
- `SnapController` with velocity-based momentum detection for fast snap triggering.
- Lifecycle callbacks: `onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack` via `ViewportObserver` state machine.
- Horizontal scrolling via `scrollDirection: Axis.horizontal` parameter.
- `builder` parameter for reactive overlay widgets.
- `loadingBuilder` with normalized 0.0-1.0 progress reporting.
- Strategy-driven cache sizing (eager keeps all frames resident).
- Direction-aware preloading for chunked and progressive strategies.
- Example app with 6 demos: basic, pinned, multi-sequence, snap, lifecycle, horizontal.

### Changed

- Ticker-based frame interpolation with configurable `lerpFactor` and `curve`.
- LRU cache uses deduplication via in-flight load tracking (Set + Completer).
- Snap controller uses raw progress (not lerped) to prevent overshoot.
- Non-pinned mode uses ScrollPosition listener instead of NotificationListener.

### Fixed

- Eager strategy cache eviction when frameCount > maxCacheSize.
- Snap overshoot caused by lerp lag in progress delta calculation.
- Non-pinned mode frame updates (NotificationListener architecture bug).
- Frame centering in pinned mode via Center wrapper.

## [0.1.0] - 2026-02-25

### Added

- `ScrollSequence` widget for scroll-driven image sequence animation.
- `FrameController` for progress-to-frame-index mapping with `ChangeNotifier`.
- `FrameCacheManager` with LRU eviction and proper `ui.Image` disposal.
- `AssetFrameLoader` for loading frames from Flutter asset bundles.
- `FramePathResolver` for `{index}` pattern-based path resolution.
- `FrameDisplay` widget with gapless playback via nearest-frame fallback.
- `ScrollProgressTracker` for viewport-relative scroll progress calculation.
- `FrameInfo` and `ScrollSequenceConfig` immutable data models.
