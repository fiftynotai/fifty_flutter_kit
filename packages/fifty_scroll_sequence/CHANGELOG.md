# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
