# Implementation Plan: BR-123

**Complexity:** L (Large)
**Estimated Duration:** 3-5 days
**Risk Level:** Medium

## Summary

Create a new `fifty_scroll_sequence` package at `packages/fifty_scroll_sequence/` providing scroll-driven image sequence animation (Apple-style scrubbing). The MVP covers package scaffold, models, frame path resolution, asset-based frame loading, LRU image cache with proper `ui.Image` disposal, scroll-to-frame progress mapping, and a non-pinned `ScrollSequence` widget. No external dependencies -- Flutter SDK only.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_scroll_sequence/pubspec.yaml` | CREATE | Package manifest, Flutter SDK only, v0.1.0 |
| `packages/fifty_scroll_sequence/analysis_options.yaml` | CREATE | flutter_lints include + ecosystem lint rules |
| `packages/fifty_scroll_sequence/lib/fifty_scroll_sequence.dart` | CREATE | Barrel export for all public API |
| `packages/fifty_scroll_sequence/README.md` | CREATE | Stub with package name and basic description |
| `packages/fifty_scroll_sequence/CHANGELOG.md` | CREATE | Initial 0.1.0 entry |
| `packages/fifty_scroll_sequence/LICENSE` | CREATE | MIT license, Copyright Fifty.ai |
| `packages/fifty_scroll_sequence/lib/src/models/frame_info.dart` | CREATE | FrameInfo immutable data class |
| `packages/fifty_scroll_sequence/lib/src/models/scroll_sequence_config.dart` | CREATE | ScrollSequenceConfig data class |
| `packages/fifty_scroll_sequence/lib/src/models/models.dart` | CREATE | Barrel export for models |
| `packages/fifty_scroll_sequence/lib/src/utils/frame_path_resolver.dart` | CREATE | {index} pattern to file path resolution |
| `packages/fifty_scroll_sequence/lib/src/utils/utils.dart` | CREATE | Barrel export for utils |
| `packages/fifty_scroll_sequence/lib/src/loaders/frame_loader.dart` | CREATE | Abstract FrameLoader base class |
| `packages/fifty_scroll_sequence/lib/src/loaders/asset_frame_loader.dart` | CREATE | rootBundle-based frame loading |
| `packages/fifty_scroll_sequence/lib/src/loaders/loaders.dart` | CREATE | Barrel export for loaders |
| `packages/fifty_scroll_sequence/lib/src/core/frame_cache_manager.dart` | CREATE | LRU cache with ui.Image disposal |
| `packages/fifty_scroll_sequence/lib/src/core/frame_controller.dart` | CREATE | Progress-to-frame-index mapping |
| `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart` | CREATE | Scroll position to 0.0-1.0 progress |
| `packages/fifty_scroll_sequence/lib/src/core/core.dart` | CREATE | Barrel export for core |
| `packages/fifty_scroll_sequence/lib/src/widgets/frame_display.dart` | CREATE | RawImage renderer with gapless playback |
| `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` | CREATE | Main ScrollSequence widget |
| `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart` | CREATE | Barrel export for widgets |
| `packages/fifty_scroll_sequence/test/frame_path_resolver_test.dart` | CREATE | Unit tests for path resolution |
| `packages/fifty_scroll_sequence/test/frame_cache_manager_test.dart` | CREATE | Unit tests for LRU cache |
| `packages/fifty_scroll_sequence/test/frame_controller_test.dart` | CREATE | Unit tests for progress-to-frame mapping |

**Total: 24 files (all CREATE)**

## Implementation Steps

### Phase 1: Package Scaffold (Task 1)

Create the package directory and boilerplate files. No dependencies on other phases.

**1.1 `pubspec.yaml`**

```yaml
name: fifty_scroll_sequence
description: Scroll-driven image sequence animation for Flutter. Apple-style frame scrubbing mapped to scroll position.
version: 0.1.0
homepage: https://fifty.dev
repository: https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/fifty_scroll_sequence
issue_tracker: https://github.com/fiftynotai/fifty_flutter_kit/issues
topics:
  - flutter
  - scroll
  - animation
  - image-sequence

environment:
  sdk: ^3.9.2
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_lints: ^5.0.0
  flutter_test:
    sdk: flutter
```

Key decisions:
- SDK constraint `^3.9.2` matches the ecosystem's current Dart version (prevents `withOpacity` deprecation issues).
- Flutter SDK is the only dependency -- zero external packages.
- `flutter_test` for test infrastructure, `flutter_lints` for analysis.

**1.2 `analysis_options.yaml`**

Match the achievement_engine's concise style (flutter_lints include + key rules):

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_single_quotes
    - sort_pub_dependencies
    - always_declare_return_types
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
```

**1.3 `LICENSE`** -- MIT, Copyright (c) 2025 Fifty.ai (same as all other packages).

**1.4 `CHANGELOG.md`** -- Keep a Changelog format, initial 0.1.0 entry.

**1.5 `README.md`** -- Stub with package name, one-line description, "See CHANGELOG.md for release notes".

**1.6 `lib/fifty_scroll_sequence.dart`** -- Barrel export using `library;` directive. Exports all subdirectory barrel files.

### Phase 2: Models (Tasks 2-3)

Foundation data classes. No dependencies on other source files.

**2.1 `lib/src/models/frame_info.dart` -- FrameInfo**

```dart
@immutable
class FrameInfo {
  const FrameInfo({
    required this.index,
    required this.path,
    this.width,
    this.height,
  });

  /// Zero-based frame index in the sequence.
  final int index;

  /// Resolved file path for this frame.
  final String path;

  /// Optional frame width in pixels (null if unknown before decode).
  final double? width;

  /// Optional frame height in pixels (null if unknown before decode).
  final double? height;
}
```

Immutable, annotated with `@immutable` from `flutter/foundation.dart`. Includes `==`, `hashCode`, `toString`, `copyWith`.

**2.2 `lib/src/models/scroll_sequence_config.dart` -- ScrollSequenceConfig**

```dart
@immutable
class ScrollSequenceConfig {
  const ScrollSequenceConfig({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.indexPadWidth,
    this.indexOffset = 0,
  });

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Path pattern with `{index}` placeholder.
  /// Example: 'assets/frames/hero_{index}.webp'
  final String framePath;

  /// Total scroll distance in logical pixels for the full sequence.
  final double scrollExtent;

  /// How frames are fitted into the display area.
  final BoxFit fit;

  /// Display width constraint (null = unconstrained).
  final double? width;

  /// Display height constraint (null = unconstrained).
  final double? height;

  /// Override for zero-pad width. Null = auto-compute from frameCount.
  final int? indexPadWidth;

  /// Starting index offset (0 = first frame is index 0, 1 = first frame is index 1).
  final int indexOffset;
}
```

**2.3 `lib/src/models/models.dart`** -- Barrel export for both model files.

### Phase 3: Utils (Task 4)

Depends on: Phase 2 (uses FrameInfo).

**3.1 `lib/src/utils/frame_path_resolver.dart` -- FramePathResolver**

```dart
class FramePathResolver {
  const FramePathResolver({
    required this.framePath,
    required this.frameCount,
    this.indexPadWidth,
    this.indexOffset = 0,
  });

  final String framePath;
  final int frameCount;
  final int? indexPadWidth;
  final int indexOffset;

  /// Effective pad width: custom override or auto-computed from frameCount.
  int get effectivePadWidth =>
      indexPadWidth ?? (frameCount + indexOffset).toString().length;

  /// Resolve the path for the given zero-based frame [index].
  ///
  /// Applies [indexOffset] to shift from zero-based to the export numbering,
  /// then zero-pads the result to [effectivePadWidth] digits.
  String resolve(int index) { ... }

  /// Resolve all frame paths, returning a list of [FrameInfo] in order.
  List<FrameInfo> resolveAll() { ... }
}
```

Key logic:
- `resolve(int index)`: `final adjusted = index + indexOffset;` then `adjusted.toString().padLeft(effectivePadWidth, '0')` then replace `{index}` in `framePath`.
- `resolveAll()`: iterate `0..<frameCount`, call `resolve(i)`, wrap each in `FrameInfo(index: i, path: resolved)`.
- If `framePath` does not contain `{index}`, throw `ArgumentError`.

**3.2 `lib/src/utils/utils.dart`** -- Barrel export.

### Phase 4: Loaders (Tasks 5-6)

Depends on: Phase 2 (FrameInfo), Phase 3 (FramePathResolver).

**4.1 `lib/src/loaders/frame_loader.dart` -- FrameLoader (abstract)**

```dart
import 'dart:ui' as ui;

abstract class FrameLoader {
  /// Load and decode the frame at the given zero-based [index].
  Future<ui.Image> loadFrame(int index);

  /// Resolve the file path for the given zero-based [index].
  String resolveFramePath(int index);

  /// Release any resources held by this loader.
  void dispose();
}
```

Minimal contract. Returns `ui.Image` (already decoded, ready for `RawImage`). `dispose()` for cleanup (e.g., cancel pending loads).

**4.2 `lib/src/loaders/asset_frame_loader.dart` -- AssetFrameLoader**

```dart
class AssetFrameLoader implements FrameLoader {
  AssetFrameLoader({
    required String framePath,
    required int frameCount,
    int? indexPadWidth,
    int indexOffset = 0,
  }) : _resolver = FramePathResolver(
         framePath: framePath,
         frameCount: frameCount,
         indexPadWidth: indexPadWidth,
         indexOffset: indexOffset,
       );

  final FramePathResolver _resolver;

  @override
  String resolveFramePath(int index) => _resolver.resolve(index);

  @override
  Future<ui.Image> loadFrame(int index) async {
    final path = resolveFramePath(index);
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  @override
  void dispose() {
    // No persistent resources to release in asset loader.
  }
}
```

Loading pipeline: `rootBundle.load(path)` -> `ByteData` -> `Uint8List` -> `ui.instantiateImageCodec()` -> `codec.getNextFrame()` -> `FrameInfo.image`. The codec is disposed after extracting the image to avoid holding GPU texture handles.

Important: `codec.dispose()` MUST be called after `getNextFrame()` to free the codec resource. The returned `ui.Image` is independent of the codec.

**4.3 `lib/src/loaders/loaders.dart`** -- Barrel export.

### Phase 5: Core Logic (Tasks 7-9)

Depends on: Phase 4 (FrameLoader).

**5.1 `lib/src/core/frame_cache_manager.dart` -- FrameCacheManager**

This is the most critical class for memory safety.

```dart
import 'dart:ui' as ui;

class FrameCacheManager {
  FrameCacheManager({this.maxCacheSize = 100});

  final int maxCacheSize;

  /// LRU-ordered cache: most recently used at end.
  final LinkedHashMap<int, ui.Image> _cache = LinkedHashMap<int, ui.Image>();

  /// In-flight load indices to prevent duplicate requests.
  final Set<int> _loading = <int>{};

  /// Pending load completers for deduplication.
  final Map<int, Completer<ui.Image>> _pending = <int, Completer<ui.Image>>{};

  /// Get a cached frame, or null if not cached.
  /// Promotes the entry to most-recently-used position.
  ui.Image? getFrame(int index) {
    final image = _cache.remove(index);
    if (image != null) {
      _cache[index] = image; // re-insert at end = most recent
    }
    return image;
  }

  /// Load a frame via [loader], using cache if available.
  /// Deduplicates concurrent requests for the same index.
  Future<ui.Image> loadFrame(int index, FrameLoader loader) async {
    // Return cached if available
    final cached = getFrame(index);
    if (cached != null) return cached;

    // Deduplicate in-flight requests
    if (_loading.contains(index)) {
      return _pending[index]!.future;
    }

    _loading.add(index);
    final completer = Completer<ui.Image>();
    _pending[index] = completer;

    try {
      final image = await loader.loadFrame(index);
      _evictIfNeeded();
      _cache[index] = image;
      completer.complete(image);
      return image;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _loading.remove(index);
      _pending.remove(index);
    }
  }

  /// Find nearest cached frame searching toward frame 0.
  ui.Image? nearestCachedFrame(int targetIndex) { ... }

  /// Current number of cached frames.
  int get length => _cache.length;

  /// Whether any loads are currently in flight.
  bool get isLoading => _loading.isNotEmpty;

  /// Estimated memory usage (rough: width * height * 4 bytes per image).
  int get estimatedMemoryBytes { ... }

  /// Dispose all cached images and clear state.
  void clearAll() {
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
    _loading.clear();
    _pending.clear();
  }

  void _evictIfNeeded() {
    while (_cache.length >= maxCacheSize) {
      final oldest = _cache.keys.first;
      final image = _cache.remove(oldest);
      image?.dispose(); // CRITICAL: dispose GPU texture
    }
  }
}
```

Critical details:
- `LinkedHashMap` maintains insertion order -- oldest entries at `keys.first`.
- `getFrame()` promotes accessed entries (remove + re-insert) for LRU behavior.
- `_evictIfNeeded()` removes from the front (oldest) and calls `image.dispose()`.
- `clearAll()` disposes ALL images -- must be called when the widget unmounts.
- `_loading` + `_pending` deduplicate concurrent requests for the same frame index.
- `nearestCachedFrame(int targetIndex)` searches `targetIndex - 1`, `targetIndex - 2`, ... down to 0 for gapless playback.

**5.2 `lib/src/core/frame_controller.dart` -- FrameController**

```dart
class FrameController extends ChangeNotifier {
  FrameController({required this.frameCount})
      : assert(frameCount > 0, 'frameCount must be positive');

  final int frameCount;

  int _currentIndex = 0;

  /// Current frame index (0-based).
  int get currentIndex => _currentIndex;

  /// Current progress value (0.0 to 1.0).
  double _progress = 0.0;
  double get progress => _progress;

  /// Update the controller from a scroll progress value (0.0 to 1.0).
  ///
  /// Clamps progress to [0.0, 1.0], maps to frame index,
  /// and notifies listeners if the index changed.
  void updateFromProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);
    final newIndex = _progressToIndex(_progress);
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  int _progressToIndex(double p) {
    if (frameCount <= 1) return 0;
    return (p * (frameCount - 1)).round().clamp(0, frameCount - 1);
  }
}
```

Key decisions:
- No lerping in MVP (deferred to BR-124).
- `round()` for index mapping gives symmetrical frame distribution.
- `clamp(0, frameCount - 1)` ensures bounds safety.
- Extends `ChangeNotifier` so widgets can listen via `AnimatedBuilder` or `ListenableBuilder`.

**5.3 `lib/src/core/scroll_progress_tracker.dart` -- ScrollProgressTracker**

Non-pinned mode only. Calculates progress based on widget position relative to viewport.

```dart
class ScrollProgressTracker {
  ScrollProgressTracker({required this.scrollExtent});

  /// Total scroll distance over which the sequence plays.
  final double scrollExtent;

  /// Calculate normalized progress (0.0 to 1.0) for non-pinned mode.
  ///
  /// Progress model:
  /// - 0.0 = widget top enters viewport bottom
  /// - 1.0 = widget bottom exits viewport top
  ///
  /// The [widgetTopInViewport] is the widget's top edge position
  /// relative to the viewport top (negative = above viewport).
  /// The [viewportHeight] is the visible area height.
  double calculateProgress({
    required double widgetTopInViewport,
    required double viewportHeight,
  }) {
    // When widget top is at viewport bottom, progress = 0.0
    // When widget top is at viewport top - scrollExtent, progress = 1.0
    final totalTravel = viewportHeight + scrollExtent;
    final traveled = viewportHeight - widgetTopInViewport;
    return (traveled / totalTravel).clamp(0.0, 1.0);
  }
}
```

Key decisions:
- Progress is viewport-relative, not absolute scroll offset. This means the animation plays while the widget is in view, regardless of where it sits in the scroll list.
- The denominator `viewportHeight + scrollExtent` creates the full travel range.
- `clamp(0.0, 1.0)` handles iOS overscroll bounce.

**5.4 `lib/src/core/core.dart`** -- Barrel export for all three core files.

### Phase 6: Widgets (Tasks 10-11)

Depends on: all previous phases.

**6.1 `lib/src/widgets/frame_display.dart` -- FrameDisplay**

```dart
class FrameDisplay extends StatelessWidget {
  const FrameDisplay({
    required this.frameIndex,
    required this.cacheManager,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    super.key,
  });

  final int frameIndex;
  final FrameCacheManager cacheManager;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // Try exact frame first, then fallback to nearest for gapless playback
    final image = cacheManager.getFrame(frameIndex) ??
        cacheManager.nearestCachedFrame(frameIndex);

    if (image == null) {
      // No frames loaded yet -- show empty SizedBox (only during initial load)
      return SizedBox(width: width, height: height);
    }

    return RawImage(
      image: image,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
```

Key decisions:
- `RawImage` directly renders `ui.Image` -- zero copy overhead, sub-16ms.
- Gapless playback: if target frame is not cached, use `nearestCachedFrame()` which searches toward frame 0.
- The empty `SizedBox` only shows during the very first render before any frames are loaded (brief flash, acceptable for MVP). A `placeholder` image on the parent `ScrollSequence` widget covers this.

**6.2 `lib/src/widgets/scroll_sequence_widget.dart` -- ScrollSequence**

This is the main public widget. It integrates all components.

```dart
class ScrollSequence extends StatefulWidget {
  const ScrollSequence({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    super.key,
  });

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Path pattern with {index} placeholder.
  final String framePath;

  /// Scroll distance in logical pixels for the full animation.
  final double scrollExtent;

  /// How frames fit within the display area.
  final BoxFit fit;

  /// Display width (null = parent width).
  final double? width;

  /// Display height (null = parent height).
  final double? height;

  /// Placeholder image shown while frames are loading.
  final ImageProvider? placeholder;

  /// Builder shown during initial frame loading.
  final WidgetBuilder? loadingBuilder;

  /// Called when the displayed frame index changes.
  final ValueChanged<int>? onFrameChanged;

  /// Override for zero-pad width of frame indices.
  final int? indexPadWidth;

  /// Frame index offset (0 or 1 typically).
  final int indexOffset;

  /// Maximum frames to keep in memory cache.
  final int maxCacheSize;

  @override
  State<ScrollSequence> createState() => _ScrollSequenceState();
}

class _ScrollSequenceState extends State<ScrollSequence> {
  late AssetFrameLoader _loader;
  late FrameCacheManager _cache;
  late FrameController _controller;
  late ScrollProgressTracker _tracker;
  bool _isLoadingFrames = true;

  @override
  void initState() {
    super.initState();
    _loader = AssetFrameLoader(
      framePath: widget.framePath,
      frameCount: widget.frameCount,
      indexPadWidth: widget.indexPadWidth,
      indexOffset: widget.indexOffset,
    );
    _cache = FrameCacheManager(maxCacheSize: widget.maxCacheSize);
    _controller = FrameController(frameCount: widget.frameCount);
    _tracker = ScrollProgressTracker(scrollExtent: widget.scrollExtent);

    _controller.addListener(_onFrameChanged);
    _eagerLoadAllFrames();
  }

  void _onFrameChanged() {
    widget.onFrameChanged?.call(_controller.currentIndex);
    if (mounted) setState(() {});
  }

  Future<void> _eagerLoadAllFrames() async {
    for (int i = 0; i < widget.frameCount; i++) {
      if (!mounted) return;
      await _cache.loadFrame(i, _loader);
      // Trigger rebuild after first frame so placeholder disappears fast
      if (i == 0 && mounted) setState(() => _isLoadingFrames = false);
    }
    if (mounted) setState(() => _isLoadingFrames = false);
  }

  @override
  void dispose() {
    _controller.removeListener(_onFrameChanged);
    _controller.dispose();
    _cache.clearAll();
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: SizedBox(
        width: widget.width,
        height: widget.height ?? widget.scrollExtent,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoadingFrames && _cache.length == 0) {
      // No frames loaded yet
      if (widget.placeholder != null) {
        return Image(image: widget.placeholder!, fit: widget.fit);
      }
      if (widget.loadingBuilder != null) {
        return widget.loadingBuilder!(context);
      }
      return const SizedBox.shrink();
    }

    return FrameDisplay(
      frameIndex: _controller.currentIndex,
      cacheManager: _cache,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    // Calculate widget position relative to viewport using context
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;

    final viewportHeight = notification.metrics.viewportDimension;
    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    final progress = _tracker.calculateProgress(
      widgetTopInViewport: widgetTopInViewport,
      viewportHeight: viewportHeight,
    );

    _controller.updateFromProgress(progress);
    return false; // Don't absorb the notification
  }
}
```

Key architectural decisions:
- `NotificationListener<ScrollNotification>` captures scroll events without needing an explicit ScrollController from the parent (composable).
- `renderBox.localToGlobal(Offset.zero).dy` gives the widget's top position relative to the viewport -- this is the input to `ScrollProgressTracker`.
- Returns `false` from `_handleScroll` so the notification continues bubbling (doesn't break parent scroll listeners).
- `_eagerLoadAllFrames()` is fire-and-forget async. It loads frames sequentially (0, 1, 2, ...) and triggers rebuild after frame 0 loads for fast initial display.
- Full disposal chain: controller listener removed -> controller disposed -> cache cleared (all images disposed) -> loader disposed.

**6.3 `lib/src/widgets/widgets.dart`** -- Barrel export.

### Phase 7: Barrel Export Assembly

**7.1 `lib/fifty_scroll_sequence.dart`**

```dart
/// Scroll-driven image sequence animation for Flutter.
///
/// Provides Apple-style frame scrubbing mapped to scroll position,
/// with asset-based loading, LRU caching, and gapless playback.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
///
/// ScrollSequence(
///   frameCount: 120,
///   framePath: 'assets/hero/frame_{index}.webp',
///   scrollExtent: 3000,
///   fit: BoxFit.cover,
/// )
/// ```
library;

export 'src/core/core.dart';
export 'src/loaders/loaders.dart';
export 'src/models/models.dart';
export 'src/utils/utils.dart';
export 'src/widgets/widgets.dart';
```

### Phase 8: Unit Tests (Task 12)

Depends on: Phases 3, 5 (the classes being tested).

**8.1 `test/frame_path_resolver_test.dart`**

Test groups:
- `resolve()` basic: `'assets/frame_{index}.webp'` with frameCount=10, index=3 -> `'assets/frame_03.webp'`
- Auto pad width from frameCount: 200 frames -> pad 3 -> `'001'`, `'199'`
- Custom padWidth override: padWidth=5, index=7 -> `'00007'`
- indexOffset: offset=1, index=0 -> `'001'` (frame 0 maps to file 1)
- Edge case: frameCount=1, index=0 -> `'0'` (pad width 1)
- Edge case: `framePath` without `{index}` -> throws `ArgumentError`
- `resolveAll()` returns correct length and paths

**8.2 `test/frame_cache_manager_test.dart`**

Test groups (using a mock FrameLoader):
- `getFrame()` returns null for uncached index
- `loadFrame()` caches and returns image
- `loadFrame()` deduplicates concurrent requests (same completer returned)
- LRU eviction: load maxCacheSize+1 frames -> first frame evicted
- `getFrame()` promotes entry (doesn't get evicted next)
- `clearAll()` empties cache and sets length to 0
- `nearestCachedFrame()` returns closest loaded frame toward 0
- `nearestCachedFrame()` returns null when nothing cached

Note: `ui.Image` cannot be easily mocked in pure unit tests. The test will use a mock `FrameLoader` that returns a test image created via `decodeImageFromList()` from a 1x1 PNG byte array. Alternatively, the tests can run as `flutter_test` widget tests to access the full Flutter test infrastructure for `ui.Image` creation.

**8.3 `test/frame_controller_test.dart`**

Test groups:
- Initial state: currentIndex = 0, progress = 0.0
- `updateFromProgress(0.0)` -> index 0
- `updateFromProgress(1.0)` -> index (frameCount - 1)
- `updateFromProgress(0.5)` -> middle frame
- Clamping: `updateFromProgress(-0.5)` -> index 0
- Clamping: `updateFromProgress(1.5)` -> index (frameCount - 1)
- Notification: listener called when index changes
- No notification: listener NOT called when progress changes but index stays same
- frameCount=1: always index 0 regardless of progress

### Phase 9: Analysis Pass (Task 13)

Run `flutter analyze` in the package directory. Fix any issues. Must be zero warnings/errors.

## Dependency Graph (File Creation Order)

```
Phase 1: Scaffold (no deps)
  pubspec.yaml, analysis_options.yaml, LICENSE, CHANGELOG.md, README.md

Phase 2: Models (no deps on other src)
  models/frame_info.dart
  models/scroll_sequence_config.dart
  models/models.dart

Phase 3: Utils (depends on models)
  utils/frame_path_resolver.dart
  utils/utils.dart

Phase 4: Loaders (depends on models, utils)
  loaders/frame_loader.dart
  loaders/asset_frame_loader.dart
  loaders/loaders.dart

Phase 5: Core (depends on loaders)
  core/frame_cache_manager.dart
  core/frame_controller.dart
  core/scroll_progress_tracker.dart
  core/core.dart

Phase 6: Widgets (depends on all above)
  widgets/frame_display.dart
  widgets/scroll_sequence_widget.dart
  widgets/widgets.dart

Phase 7: Barrel export (depends on all src)
  lib/fifty_scroll_sequence.dart

Phase 8: Tests (depends on phases 3, 5)
  test/frame_path_resolver_test.dart
  test/frame_cache_manager_test.dart
  test/frame_controller_test.dart

Phase 9: Analysis pass
  flutter analyze -> zero issues
```

## Public API Summary

### Models

| Class | Import | Key Members |
|-------|--------|-------------|
| `FrameInfo` | models | `index`, `path`, `width?`, `height?` |
| `ScrollSequenceConfig` | models | `frameCount`, `framePath`, `scrollExtent`, `fit`, `width?`, `height?`, `indexPadWidth?`, `indexOffset` |

### Utils

| Class | Import | Key Members |
|-------|--------|-------------|
| `FramePathResolver` | utils | `resolve(int index)`, `resolveAll()`, `effectivePadWidth` |

### Loaders

| Class | Import | Key Members |
|-------|--------|-------------|
| `FrameLoader` | loaders | `loadFrame(int)`, `resolveFramePath(int)`, `dispose()` (abstract) |
| `AssetFrameLoader` | loaders | Implements `FrameLoader` for `rootBundle` assets |

### Core

| Class | Import | Key Members |
|-------|--------|-------------|
| `FrameCacheManager` | core | `getFrame(int)`, `loadFrame(int, FrameLoader)`, `nearestCachedFrame(int)`, `clearAll()`, `length`, `estimatedMemoryBytes` |
| `FrameController` | core | `updateFromProgress(double)`, `currentIndex`, `progress`, `frameCount` (extends `ChangeNotifier`) |
| `ScrollProgressTracker` | core | `calculateProgress(widgetTopInViewport:, viewportHeight:)` |

### Widgets

| Class | Import | Key Members |
|-------|--------|-------------|
| `FrameDisplay` | widgets | `frameIndex`, `cacheManager`, `fit`, `width?`, `height?` |
| `ScrollSequence` | widgets | `frameCount`, `framePath`, `scrollExtent`, `fit`, `width?`, `height?`, `placeholder?`, `loadingBuilder?`, `onFrameChanged?`, `indexPadWidth?`, `indexOffset`, `maxCacheSize` |

## Testing Strategy

| Component | Test Type | Framework | Key Scenarios |
|-----------|-----------|-----------|---------------|
| `FramePathResolver` | Unit | `flutter_test` | Pattern resolution, auto-padding, custom padding, offset, edge cases, error cases |
| `FrameCacheManager` | Unit | `flutter_test` | LRU eviction, dedup, disposal, nearest-frame search |
| `FrameController` | Unit | `flutter_test` | Progress mapping, clamping, notification, single-frame edge |
| `ScrollProgressTracker` | Unit (add if time) | `flutter_test` | Viewport-relative calculation, clamp |
| `ScrollSequence` | Manual | Test app | Visual scroll-to-frame behavior, gapless playback |

For `FrameCacheManager` tests, create a minimal mock:
```dart
class FakeFrameLoader implements FrameLoader {
  int loadCount = 0;

  @override
  Future<ui.Image> loadFrame(int index) async {
    loadCount++;
    // Create 1x1 test image
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawRect(Rect.fromLTWH(0, 0, 1, 1), Paint());
    final picture = recorder.endRecording();
    final image = await picture.toImage(1, 1);
    picture.dispose();
    return image;
  }

  @override
  String resolveFramePath(int index) => 'test_frame_$index.png';

  @override
  void dispose() {}
}
```

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `ui.Image` memory leaks from missed disposal | Medium | High | LRU eviction always calls `dispose()`. `clearAll()` in widget `dispose()`. Code review focus on disposal paths. |
| `rootBundle.load()` failure for missing assets | Medium | Medium | AssetFrameLoader propagates error. FrameCacheManager catches in `loadFrame()`. Gapless fallback shows nearest frame. |
| `NotificationListener` not receiving scroll events if widget is deeply nested | Low | Medium | Standard Flutter pattern -- works in `SingleChildScrollView`, `ListView`, `CustomScrollView`. Tested in BR-126 example app. |
| Widget position calculation via `localToGlobal` inaccurate during layout | Low | Medium | Only called in scroll notification handler (post-layout). `hasSize` guard prevents pre-layout access. |
| Eager loading all frames at once causes memory spike | Medium | Medium | `maxCacheSize` caps memory. For 200+ frame sequences, user should increase `maxCacheSize` or wait for BR-125 chunked loading. |
| `codec.dispose()` before frame extraction causes issues | Low | High | Codec is disposed AFTER `getNextFrame()` returns. The `ui.Image` is independent of the codec lifecycle (verified in Flutter engine source). |
| Sequential eager loading too slow for large sequences (200+ frames) | Medium | Low | Acceptable for MVP. BR-125 adds chunked/progressive strategies. First frame loads fast (sub-100ms), so placeholder disappears quickly. |

## Notes for FORGER

1. **Import `dart:ui` as `ui`** -- standard convention for `ui.Image`, `ui.instantiateImageCodec`, etc.
2. **All `ui.Image` objects are GPU-backed** -- they MUST be disposed when no longer needed. Every eviction path and `clearAll()` must call `image.dispose()`.
3. **`LinkedHashMap` is from `dart:collection`** -- needs explicit import.
4. **`rootBundle` is from `package:flutter/services.dart`** -- only needed in `AssetFrameLoader`.
5. **`ChangeNotifier` is from `package:flutter/foundation.dart`** -- used by `FrameController`.
6. **`RawImage` is from `package:flutter/widgets.dart`** -- zero-copy GPU texture rendering.
7. **Do NOT import `fifty_tokens` or `fifty_ui`** -- this package has zero FDL dependencies by design (it renders raw images, not styled UI components).
8. **`ScrollSequenceConfig` is currently unused by the widget** (the widget takes individual parameters). It exists as a convenience data class for consumers who want to pass config around. BR-124+ will use it more heavily.
9. **Test images**: Use `PictureRecorder` to create 1x1 test images in `flutter_test` environment. Do NOT rely on test asset files.
10. **Barrel exports**: Each subdirectory gets its own `{name}.dart` barrel file. The top-level barrel exports the subdirectory barrels, not individual files.

---

**Plan created for BR-123**

**Complexity:** L
**Files affected:** 24
**Phases:** 9

Ready for implementation.
