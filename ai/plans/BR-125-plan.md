# Implementation Plan: BR-125 -- Advanced Loading Strategies

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Add a pluggable `PreloadStrategy` system (eager/chunked/progressive), two new `FrameLoader` implementations (`NetworkFrameLoader`, `SpriteSheetLoader`), scroll direction detection in `ScrollProgressTracker`, and two convenience constructors (`ScrollSequence.network()`, `ScrollSequence.spriteSheet()`) to the `fifty_scroll_sequence` package. The existing `ScrollSequence()` constructor remains fully backward compatible.

---

## Files to Modify

| # | File | Action | Complexity | Description |
|---|------|--------|------------|-------------|
| 1 | `lib/src/loaders/frame_loader.dart` | MODIFY | S | Add optional `totalFrames` getter to interface |
| 2 | `lib/src/strategies/preload_strategy.dart` | CREATE | M | Abstract `PreloadStrategy` + `EagerPreloadStrategy`, `ChunkedPreloadStrategy`, `ProgressivePreloadStrategy` |
| 3 | `lib/src/strategies/strategies.dart` | CREATE | S | Barrel export for strategies |
| 4 | `lib/src/core/scroll_progress_tracker.dart` | MODIFY | S | Add `ScrollDirection` enum + direction detection |
| 5 | `lib/src/core/frame_cache_manager.dart` | MODIFY | M | Strategy-driven preload/evict, direction-aware preloading, progress callback |
| 6 | `lib/src/loaders/network_frame_loader.dart` | CREATE | L | HTTP download + disk cache + progress |
| 7 | `lib/src/loaders/sprite_sheet_loader.dart` | CREATE | M | Sprite sheet crop + frame extraction |
| 8 | `lib/src/widgets/scroll_sequence_widget.dart` | MODIFY | M | New constructors, accept `FrameLoader` + `PreloadStrategy`, loading progress |
| 9 | `lib/src/loaders/loaders.dart` | MODIFY | S | Add new loader exports |
| 10 | `lib/src/core/core.dart` | MODIFY | S | Ensure all core exports present |
| 11 | `lib/fifty_scroll_sequence.dart` | MODIFY | S | Add `strategies` barrel export |
| 12 | `pubspec.yaml` | MODIFY | S | Add `http` and `path_provider` as optional deps |
| 13 | `test/preload_strategy_test.dart` | CREATE | M | Strategy range/keyframe unit tests |
| 14 | `test/sprite_sheet_loader_test.dart` | CREATE | S | Crop rect calculation tests |
| 15 | `test/network_frame_loader_test.dart` | CREATE | M | Disk cache hit/miss tests |
| 16 | `test/frame_cache_manager_test.dart` | MODIFY | S | Add strategy integration tests |
| 17 | `test/scroll_progress_tracker_test.dart` | MODIFY | S | Add direction detection tests |

---

## Implementation Steps

### Phase 1: PreloadStrategy System (Pure Logic, No Dependencies)

**File 1: `lib/src/strategies/preload_strategy.dart`** (CREATE)

This is the foundation. All other work depends on this.

```dart
/// Scroll direction detected from consecutive progress deltas.
enum ScrollDirection { forward, backward, idle }

/// Abstract base class for frame preloading strategies.
///
/// A strategy decides which frame indices should be loaded given
/// the current scroll position and direction. The [FrameCacheManager]
/// calls [framesToLoad] on each frame change and evicts frames
/// not in the returned set.
abstract class PreloadStrategy {
  const PreloadStrategy();

  /// Factory: load all frames eagerly on init.
  const factory PreloadStrategy.eager() = EagerPreloadStrategy;

  /// Factory: load a sliding window around the current frame.
  const factory PreloadStrategy.chunked({
    int chunkSize,
    int preloadAhead,
    int preloadBehind,
  }) = ChunkedPreloadStrategy;

  /// Factory: load keyframes first, then fill gaps progressively.
  const factory PreloadStrategy.progressive({
    int keyframeCount,
    int windowAhead,
    int windowBehind,
  }) = ProgressivePreloadStrategy;

  /// Return the ordered list of frame indices that should be loaded
  /// given the [currentIndex], [totalFrames], and [direction].
  ///
  /// Order matters: indices at the front of the list are loaded first.
  /// The cache manager will evict indices NOT in this list (for non-eager).
  List<int> framesToLoad({
    required int currentIndex,
    required int totalFrames,
    required ScrollDirection direction,
  });

  /// Whether the cache should evict frames not in the [framesToLoad] set.
  ///
  /// Eager returns `false` (keep everything). Chunked/Progressive return `true`.
  bool get shouldEvictOutsideWindow;

  /// Maximum number of frames this strategy expects to hold in cache.
  ///
  /// Used to set the LRU cache size. Eager returns [totalFrames],
  /// chunked returns [chunkSize], progressive returns a computed value.
  int maxCacheSize(int totalFrames);
}
```

**`EagerPreloadStrategy`:**
- `framesToLoad`: returns `List.generate(totalFrames, (i) => i)` -- all frames in order
- `shouldEvictOutsideWindow`: `false`
- `maxCacheSize(totalFrames)`: `totalFrames`
- This is the existing behavior, backward compatible

**`ChunkedPreloadStrategy`:**
- Fields: `chunkSize` (default 40), `preloadAhead` (default 30), `preloadBehind` (default 10)
- `framesToLoad`: calculates window `[currentIndex - preloadBehind, currentIndex + preloadAhead]`, clamped to `[0, totalFrames-1]`. Order: current frame first, then ahead frames in order, then behind frames in order. When `direction == backward`, swap ahead/behind counts.
- `shouldEvictOutsideWindow`: `true`
- `maxCacheSize(totalFrames)`: `min(chunkSize, totalFrames)`

Key logic for direction-aware chunked:
```
if direction == forward:
  ahead = preloadAhead, behind = preloadBehind
else if direction == backward:
  ahead = preloadBehind, behind = preloadAhead  // swap
else (idle):
  ahead = chunkSize ~/ 2, behind = chunkSize ~/ 2
```

**`ProgressivePreloadStrategy`:**
- Fields: `keyframeCount` (default 20), `windowAhead` (default 15), `windowBehind` (default 5)
- `framesToLoad`: Two phases merged into one ordered list:
  1. **Keyframes** -- evenly spaced: `[0, step, 2*step, ..., totalFrames-1]` where `step = totalFrames ~/ keyframeCount`
  2. **Window around current** -- `[currentIndex - windowBehind, currentIndex + windowAhead]` clamped
  3. Deduplicate, current frame first, then window, then keyframes not in window
- `shouldEvictOutsideWindow`: `true` (evict non-keyframe, non-window frames)
- `maxCacheSize(totalFrames)`: `keyframeCount + windowAhead + windowBehind`

**File 2: `lib/src/strategies/strategies.dart`** (CREATE)

```dart
/// Strategy classes for fifty_scroll_sequence.
library;

export 'preload_strategy.dart';
```

---

### Phase 2: Scroll Direction Detection

**File 3: `lib/src/core/scroll_progress_tracker.dart`** (MODIFY)

Add direction tracking to the existing `ScrollProgressTracker`. The `ScrollDirection` enum is imported from the strategy file to avoid circular deps -- OR define it in a shared location. Since strategies need it and tracker produces it, define the enum in `preload_strategy.dart` and import it in `scroll_progress_tracker.dart`.

Add to `ScrollProgressTracker`:

```dart
import '../strategies/preload_strategy.dart' show ScrollDirection;

class ScrollProgressTracker {
  // ... existing fields and methods unchanged ...

  /// Previous progress value for direction detection.
  double _previousProgress = 0.0;

  /// Current detected scroll direction.
  ScrollDirection _direction = ScrollDirection.idle;

  /// Minimum delta to register a direction change (prevents noise).
  static const double _directionThreshold = 0.001;

  /// Current scroll direction based on recent progress changes.
  ScrollDirection get direction => _direction;

  /// Update direction from a new progress value.
  ///
  /// Call this each time progress is recalculated.
  void updateDirection(double currentProgress) {
    final delta = currentProgress - _previousProgress;
    if (delta > _directionThreshold) {
      _direction = ScrollDirection.forward;
    } else if (delta < -_directionThreshold) {
      _direction = ScrollDirection.backward;
    }
    // If |delta| <= threshold, keep previous direction (avoids idle flicker)
    _previousProgress = currentProgress;
  }
}
```

**Design note:** `updateDirection` does NOT reset to `idle` on small deltas. This is intentional -- during smooth scrolling the direction should persist. It only changes on meaningful delta. The strategy uses whatever the last meaningful direction was. `idle` is only the initial state.

---

### Phase 3: Strategy-Driven FrameCacheManager

**File 4: `lib/src/core/frame_cache_manager.dart`** (MODIFY)

This is the key integration point. The existing API must remain backward compatible (no strategy = eager behavior). Add strategy-driven preloading as an opt-in layer.

**New fields:**
```dart
/// Optional progress callback: (loadedCount, totalExpected)
typedef LoadProgressCallback = void Function(int loaded, int total);

class FrameCacheManager {
  FrameCacheManager({this.maxCacheSize = 100});

  // ... existing fields unchanged ...

  /// Trigger strategy-driven preloading around [currentIndex].
  ///
  /// Calls [strategy.framesToLoad] to get the target set, then:
  /// 1. Loads any missing frames (in priority order from strategy)
  /// 2. Evicts frames outside the target set if [strategy.shouldEvictOutsideWindow]
  /// 3. Reports progress via [onProgress] callback
  ///
  /// Returns a Future that completes when all target frames are loaded.
  Future<void> preloadForStrategy({
    required int currentIndex,
    required int totalFrames,
    required PreloadStrategy strategy,
    required ScrollDirection direction,
    required FrameLoader loader,
    LoadProgressCallback? onProgress,
  }) async {
    final targets = strategy.framesToLoad(
      currentIndex: currentIndex,
      totalFrames: totalFrames,
      direction: direction,
    );
    final targetSet = targets.toSet();

    // Evict frames outside target window
    if (strategy.shouldEvictOutsideWindow) {
      _evictOutsideSet(targetSet);
    }

    // Load missing frames in strategy-defined priority order
    int loadedCount = 0;
    final totalToLoad = targets.where((i) => getFrame(i) == null && !_loading.contains(i)).length;

    for (final index in targets) {
      if (getFrame(index) != null) continue; // already cached
      if (_loading.contains(index)) continue; // already loading

      await loadFrame(index, loader);
      loadedCount++;
      onProgress?.call(loadedCount, totalToLoad);
    }
  }

  /// Evict all cached frames whose indices are NOT in [keepSet].
  ///
  /// Calls [ui.Image.dispose()] on each evicted frame.
  void _evictOutsideSet(Set<int> keepSet) {
    final toEvict = _cache.keys.where((k) => !keepSet.contains(k)).toList();
    for (final key in toEvict) {
      final image = _cache.remove(key);
      image?.dispose(); // CRITICAL: free GPU texture
    }
  }
}
```

**Key decisions:**
- `preloadForStrategy` is a NEW method. The existing `loadFrame` and `_evictIfNeeded` remain untouched for backward compat.
- When strategy is in use, the widget calls `preloadForStrategy` instead of `_eagerLoadAllFrames`. The old LRU eviction (`_evictIfNeeded`) still fires inside `loadFrame` as a safety net.
- The `_evictOutsideSet` method is the strategy-specific eviction that disposes GPU textures.

---

### Phase 4: SpriteSheetLoader (No External Dependencies)

**File 5: `lib/src/loaders/sprite_sheet_loader.dart`** (CREATE)

No `http` dependency needed. Works with asset-based sprite sheets.

```dart
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'frame_loader.dart';

/// Configuration for a single sprite sheet image containing a grid of frames.
class SpriteSheetConfig {
  const SpriteSheetConfig({
    required this.assetPath,
    required this.columns,
    required this.rows,
    required this.frameWidth,
    required this.frameHeight,
  });

  /// Asset path to the sprite sheet image.
  final String assetPath;

  /// Number of columns in the sprite grid.
  final int columns;

  /// Number of rows in the sprite grid.
  final int rows;

  /// Width of each frame in pixels.
  final int frameWidth;

  /// Height of each frame in pixels.
  final int frameHeight;

  /// Total frames in this sheet (may be less if last row is partial).
  int get maxFrames => columns * rows;
}

/// Loads individual frames by cropping them from sprite sheet grid images.
///
/// Supports multiple sprite sheets for large sequences. Each sheet contains
/// a grid of frames at [columns] x [rows]. Frame index is mapped to the
/// correct sheet, row, and column.
///
/// ## Frame Extraction
///
/// Uses [Canvas] + [PictureRecorder] to draw the crop region from the
/// source sheet into a new [ui.Image], ensuring GPU-backed output.
///
/// ## Example
///
/// ```dart
/// final loader = SpriteSheetLoader(
///   sheets: [
///     SpriteSheetConfig(
///       assetPath: 'assets/sprites/sheet_01.webp',
///       columns: 10,
///       rows: 10,
///       frameWidth: 320,
///       frameHeight: 180,
///     ),
///   ],
///   totalFrames: 100,
/// );
/// ```
class SpriteSheetLoader implements FrameLoader {
  SpriteSheetLoader({
    required this.sheets,
    required this.totalFrames,
  }) : assert(sheets.isNotEmpty, 'At least one sheet required');

  /// Ordered list of sprite sheet configurations.
  final List<SpriteSheetConfig> sheets;

  /// Total frame count across all sheets.
  final int totalFrames;

  /// Cached decoded sheet images (loaded lazily).
  final Map<int, ui.Image> _sheetImages = {};

  @override
  Future<ui.Image> loadFrame(int index) async {
    // Determine which sheet and position within that sheet
    final (sheetIndex, localIndex) = _resolveSheetPosition(index);
    final sheet = sheets[sheetIndex];

    // Load sheet image if not cached
    _sheetImages[sheetIndex] ??= await _loadSheetImage(sheet.assetPath);
    final sheetImage = _sheetImages[sheetIndex]!;

    // Calculate crop rect
    final col = localIndex % sheet.columns;
    final row = localIndex ~/ sheet.columns;
    final srcRect = Rect.fromLTWH(
      col * sheet.frameWidth.toDouble(),
      row * sheet.frameHeight.toDouble(),
      sheet.frameWidth.toDouble(),
      sheet.frameHeight.toDouble(),
    );

    // Extract frame via Canvas + PictureRecorder
    return _cropFrame(sheetImage, srcRect, sheet.frameWidth, sheet.frameHeight);
  }

  @override
  String resolveFramePath(int index) {
    final (sheetIndex, localIndex) = _resolveSheetPosition(index);
    return '${sheets[sheetIndex].assetPath}#$localIndex';
  }

  @override
  void dispose() {
    for (final image in _sheetImages.values) {
      image.dispose();
    }
    _sheetImages.clear();
  }

  /// Resolve global frame index to (sheetIndex, localIndexWithinSheet).
  (int, int) _resolveSheetPosition(int globalIndex) {
    int remaining = globalIndex;
    for (int i = 0; i < sheets.length; i++) {
      final capacity = sheets[i].maxFrames;
      if (remaining < capacity) {
        return (i, remaining);
      }
      remaining -= capacity;
    }
    throw RangeError('Frame index $globalIndex exceeds total frames across all sheets');
  }

  /// Load and decode a sprite sheet image from assets.
  Future<ui.Image> _loadSheetImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  /// Crop a rectangle from [source] into a new [ui.Image].
  Future<ui.Image> _cropFrame(
    ui.Image source,
    Rect srcRect,
    int width,
    int height,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      source,
      srcRect,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint(),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    picture.dispose();
    return image;
  }
}
```

**Design decisions:**
- Supports multiple sheets via `List<SpriteSheetConfig>` for large sequences (e.g., 400 frames across 4 sheets of 10x10)
- Sheet images are lazily loaded and cached (they are the "atlas" -- we keep them in memory since they are shared across many frames)
- `dispose()` disposes all cached sheet images
- Uses Dart 3 record syntax `(int, int)` for sheet position resolution

---

### Phase 5: NetworkFrameLoader (External Dependencies)

**File 6: `lib/src/loaders/network_frame_loader.dart`** (CREATE)

This is the most complex new file. It requires `http` and `path_provider` as dependencies.

```dart
import 'dart:io';
import 'dart:ui' as ui;

import 'frame_loader.dart';

/// Callback for download progress reporting.
///
/// [bytesReceived] is bytes downloaded so far.
/// [totalBytes] is the expected total (-1 if unknown).
typedef DownloadProgressCallback = void Function(int bytesReceived, int totalBytes);

/// Loads image sequence frames from network URLs with local disk caching.
///
/// Downloaded frames are cached to [cacheDirectory] so subsequent loads
/// are served from disk without re-downloading.
///
/// ## Optional Dependency
///
/// This loader requires the `http` package. If your app only uses
/// asset-based or sprite sheet loading, you do not need this dependency.
///
/// ## Example
///
/// ```dart
/// final loader = NetworkFrameLoader(
///   frameUrlPattern: 'https://cdn.example.com/hero/frame_{index}.webp',
///   frameCount: 200,
///   cacheDirectory: (await getTemporaryDirectory()).path,
/// );
/// ```
class NetworkFrameLoader implements FrameLoader {
  NetworkFrameLoader({
    required this.frameUrlPattern,
    required this.frameCount,
    required this.cacheDirectory,
    this.headers = const {},
    this.indexPadWidth,
    this.indexOffset = 0,
    this.onDownloadProgress,
  });

  /// URL pattern with `{index}` placeholder.
  final String frameUrlPattern;

  /// Total frame count.
  final int frameCount;

  /// Local directory path for disk cache.
  final String cacheDirectory;

  /// Optional HTTP headers (e.g., auth tokens, CDN keys).
  final Map<String, String> headers;

  /// Zero-pad width for index in URL.
  final int? indexPadWidth;

  /// Index offset (0 or 1).
  final int indexOffset;

  /// Optional per-frame download progress callback.
  final DownloadProgressCallback? onDownloadProgress;

  @override
  String resolveFramePath(int index) {
    final adjusted = index + indexOffset;
    final padWidth = indexPadWidth ?? (frameCount + indexOffset).toString().length;
    final padded = adjusted.toString().padLeft(padWidth, '0');
    return frameUrlPattern.replaceAll('{index}', padded);
  }

  @override
  Future<ui.Image> loadFrame(int index) async {
    final url = resolveFramePath(index);
    final cacheFile = File('$cacheDirectory/scroll_seq_frame_$index');

    // Check disk cache first
    if (await cacheFile.exists()) {
      final bytes = await cacheFile.readAsBytes();
      return _decodeImage(bytes);
    }

    // Download from network
    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(Uri.parse(url));
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
      final response = await request.close();

      if (response.statusCode != 200) {
        throw HttpException(
          'Failed to download frame $index: HTTP ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }

      final bytes = await _collectBytes(response);

      // Write to disk cache (fire and forget, non-blocking)
      await cacheFile.writeAsBytes(bytes, flush: true);

      return _decodeImage(bytes);
    } finally {
      httpClient.close();
    }
  }

  @override
  void dispose() {
    // No persistent resources. Disk cache persists intentionally.
  }

  /// Decode raw bytes into a [ui.Image].
  Future<ui.Image> _decodeImage(List<int> bytes) async {
    final codec = await ui.instantiateImageCodec(
      bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
    );
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  /// Collect response bytes with progress reporting.
  Future<Uint8List> _collectBytes(HttpClientResponse response) async {
    final totalBytes = response.contentLength;
    final chunks = <List<int>>[];
    int received = 0;

    await for (final chunk in response) {
      chunks.add(chunk);
      received += chunk.length;
      onDownloadProgress?.call(received, totalBytes);
    }

    final builder = BytesBuilder(copy: false);
    for (final chunk in chunks) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}
```

**Design decisions:**
- Uses `dart:io` `HttpClient` instead of `package:http` -- this avoids the external dependency entirely. `dart:io` is available on all Flutter platforms except web. For web, users would use `AssetFrameLoader` anyway since network CORS issues make direct frame download impractical.
- This means we do NOT need `http` as a dependency at all. `dart:io` is part of Dart SDK.
- `path_provider` is still needed but only by the CONSUMER (the app), not by the package itself. The constructor takes a `cacheDirectory` string. The example/README shows how to get it via `path_provider`.
- Disk cache key: simple `scroll_seq_frame_{index}` filename in the provided directory
- `dispose()` is a no-op intentionally: disk cache should persist across sessions

**IMPORTANT REVISION:** Since `dart:io` `HttpClient` is used, the `http` package is NOT needed in pubspec.yaml. However, `dart:io` is not available on web. We need a conditional import or a platform check. Since the brief says "http must be optional", the cleanest approach is:

- `NetworkFrameLoader` uses `dart:io` `HttpClient`
- On web, this file won't compile -- but that's fine because `NetworkFrameLoader` is a concrete class, not referenced by default. Users who want network loading on web would need a web-specific loader (future scope).
- Add a comment in the class doc that this loader is not available on web.

**Alternative (cleaner):** Use conditional exports in the barrel file. Export `NetworkFrameLoader` only on non-web platforms. This is the Flutter-standard approach.

```dart
// In loaders.dart barrel:
export 'network_frame_loader.dart'
    if (dart.library.io) 'network_frame_loader.dart';
```

Actually, the simpler approach: just use `dart:io` directly. If someone imports it on web and tries to instantiate it, they'll get a compile error -- which is the correct behavior since network frame loading with disk cache doesn't make sense on web. Document this.

---

### Phase 6: ScrollSequence Widget Updates

**File 7: `lib/src/widgets/scroll_sequence_widget.dart`** (MODIFY)

This is the consumer-facing integration. Key changes:

**A) Add `loader` and `strategy` parameters to the default constructor:**

```dart
class ScrollSequence extends StatefulWidget {
  /// Creates a [ScrollSequence] widget.
  ///
  /// By default, uses [AssetFrameLoader] and [PreloadStrategy.eager()].
  const ScrollSequence({
    required this.frameCount,
    required this.framePath,
    // ... all existing params unchanged ...
    this.loader,           // NEW: custom FrameLoader (null = AssetFrameLoader)
    this.strategy,         // NEW: PreloadStrategy (null = eager)
    super.key,
  });

  /// Optional custom frame loader. If null, [AssetFrameLoader] is used.
  final FrameLoader? loader;

  /// Optional preload strategy. If null, [PreloadStrategy.eager()] is used.
  final PreloadStrategy? strategy;
```

**B) Add `ScrollSequence.network()` named constructor:**

```dart
  /// Creates a [ScrollSequence] that loads frames from network URLs.
  ///
  /// Requires a [cacheDirectory] for disk caching of downloaded frames.
  /// Typically obtained via `(await getTemporaryDirectory()).path`.
  ScrollSequence.network({
    required this.frameCount,
    required String frameUrl,          // URL pattern with {index}
    required String cacheDirectory,
    Map<String, String> headers = const {},
    DownloadProgressCallback? onDownloadProgress,
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
    this.pin = true,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    PreloadStrategy? strategy,
    super.key,
  }) : framePath = frameUrl,
       strategy = strategy ?? const PreloadStrategy.chunked(),  // Default: chunked for network
       loader = NetworkFrameLoader(
         frameUrlPattern: frameUrl,
         frameCount: frameCount,
         cacheDirectory: cacheDirectory,
         headers: headers,
         indexPadWidth: indexPadWidth,
         indexOffset: indexOffset,
         onDownloadProgress: onDownloadProgress,
       );
```

**C) Add `ScrollSequence.spriteSheet()` named constructor:**

```dart
  /// Creates a [ScrollSequence] from sprite sheet grid images.
  ScrollSequence.spriteSheet({
    required this.frameCount,
    required List<SpriteSheetConfig> sheets,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.maxCacheSize = 100,
    this.pin = true,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    PreloadStrategy? strategy,
    super.key,
  }) : framePath = '',  // Not used for sprite sheets
       indexPadWidth = null,
       indexOffset = 0,
       strategy = strategy ?? const PreloadStrategy.chunked(),
       loader = SpriteSheetLoader(sheets: sheets, totalFrames: frameCount);
```

**D) Modify `_ScrollSequenceState` to use strategy-driven loading:**

```dart
class _ScrollSequenceState extends State<ScrollSequence>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  late FrameLoader _loader;        // Changed from AssetFrameLoader
  late FrameCacheManager _cache;
  late FrameController _controller;
  late ScrollProgressTracker _tracker;
  late PreloadStrategy _strategy;  // NEW
  bool _isLoadingFrames = true;
  int _loadedCount = 0;            // NEW: for progress tracking
  int _totalToLoad = 0;            // NEW

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Use provided loader or create AssetFrameLoader (backward compat)
    _loader = widget.loader ?? AssetFrameLoader(
      framePath: widget.framePath,
      frameCount: widget.frameCount,
      indexPadWidth: widget.indexPadWidth,
      indexOffset: widget.indexOffset,
    );

    _strategy = widget.strategy ?? const PreloadStrategy.eager();

    _cache = FrameCacheManager(
      maxCacheSize: _strategy.maxCacheSize(widget.frameCount)
          .clamp(1, widget.maxCacheSize),  // Respect user max
    );

    _controller = FrameController(
      frameCount: widget.frameCount,
      vsync: this,
      lerpFactor: widget.lerpFactor,
      curve: widget.curve,
    );
    _tracker = ScrollProgressTracker(scrollExtent: widget.scrollExtent);

    _controller.addListener(_onFrameChanged);
    _initialLoad();
  }

  /// Strategy-aware initial load.
  Future<void> _initialLoad() async {
    final targets = _strategy.framesToLoad(
      currentIndex: 0,
      totalFrames: widget.frameCount,
      direction: ScrollDirection.idle,
    );
    _totalToLoad = targets.length;

    for (final index in targets) {
      if (!mounted) return;
      await _cache.loadFrame(index, _loader);
      _loadedCount++;
      if (index == targets.first && mounted) {
        setState(() => _isLoadingFrames = false);
      }
      if (mounted) setState(() {}); // Update progress
    }
    if (mounted) setState(() => _isLoadingFrames = false);
  }

  void _onFrameChanged() {
    widget.onFrameChanged?.call(
      _controller.currentIndex,
      _controller.progress,
    );

    // Trigger strategy preload on frame change (chunked/progressive)
    if (_strategy.shouldEvictOutsideWindow) {
      _preloadAroundCurrent();
    }

    if (mounted) setState(() {});
  }

  /// Preload frames around current position using strategy.
  Future<void> _preloadAroundCurrent() async {
    await _cache.preloadForStrategy(
      currentIndex: _controller.currentIndex,
      totalFrames: widget.frameCount,
      strategy: _strategy,
      direction: _tracker.direction,
      loader: _loader,
    );
  }
```

**E) Update `loadingBuilder` to receive progress:**

Change `loadingBuilder` type from `WidgetBuilder?` to a new typedef:

```dart
/// Builder for loading state, receives normalized progress (0.0 to 1.0).
typedef LoadingWidgetBuilder = Widget Function(BuildContext context, double progress);
```

In `_buildFrameContent`:
```dart
if (widget.loadingBuilder != null) {
  final progress = _totalToLoad > 0
      ? (_loadedCount / _totalToLoad).clamp(0.0, 1.0)
      : 0.0;
  return widget.loadingBuilder!(context, progress);
}
```

**BREAKING CHANGE NOTE:** Changing `loadingBuilder` type from `WidgetBuilder?` to `LoadingWidgetBuilder?` is a breaking API change. To maintain backward compat, we should make `loadingBuilder` the NEW type and add a `@Deprecated` note. Since this is a 0.1.0 package (pre-1.0), this is acceptable.

---

### Phase 7: Barrel Exports and Pubspec

**File 8: `lib/src/loaders/loaders.dart`** (MODIFY)

```dart
/// Frame loader classes for fifty_scroll_sequence.
library;

export 'asset_frame_loader.dart';
export 'frame_loader.dart';
export 'network_frame_loader.dart';
export 'sprite_sheet_loader.dart';
```

**File 9: `lib/src/core/core.dart`** (MODIFY -- no change needed, already exports all 3 core files)

**File 10: `lib/fifty_scroll_sequence.dart`** (MODIFY)

```dart
export 'src/core/core.dart';
export 'src/loaders/loaders.dart';
export 'src/models/models.dart';
export 'src/strategies/strategies.dart';  // NEW
export 'src/utils/utils.dart';
export 'src/widgets/widgets.dart';
```

**File 11: `pubspec.yaml`** (MODIFY)

Since we use `dart:io` `HttpClient` instead of `package:http`, NO new dependencies are needed. The package stays dependency-free (Flutter SDK only). This is ideal.

However, we should document in README that:
- `NetworkFrameLoader` requires `path_provider` (or equivalent) in the consuming app to get the cache directory path
- `NetworkFrameLoader` is not available on web (uses `dart:io`)

---

### Phase 8: Tests

**File 12: `test/preload_strategy_test.dart`** (CREATE)

Test cases:
1. `EagerPreloadStrategy.framesToLoad` returns all indices [0..totalFrames-1]
2. `EagerPreloadStrategy.shouldEvictOutsideWindow` is false
3. `EagerPreloadStrategy.maxCacheSize` returns totalFrames
4. `ChunkedPreloadStrategy.framesToLoad` with forward direction returns correct window
5. `ChunkedPreloadStrategy.framesToLoad` at index 0 clamps behind to 0
6. `ChunkedPreloadStrategy.framesToLoad` at last frame clamps ahead
7. `ChunkedPreloadStrategy.framesToLoad` with backward direction swaps ahead/behind
8. `ChunkedPreloadStrategy.framesToLoad` with idle direction uses symmetric window
9. `ChunkedPreloadStrategy.shouldEvictOutsideWindow` is true
10. `ChunkedPreloadStrategy.maxCacheSize` returns min(chunkSize, totalFrames)
11. `ProgressivePreloadStrategy.framesToLoad` includes evenly-spaced keyframes
12. `ProgressivePreloadStrategy.framesToLoad` includes window around current
13. `ProgressivePreloadStrategy.framesToLoad` deduplicates overlapping keyframe + window
14. `ProgressivePreloadStrategy.framesToLoad` puts current frame first
15. `ProgressivePreloadStrategy.shouldEvictOutsideWindow` is true

**File 13: `test/sprite_sheet_loader_test.dart`** (CREATE)

Test cases (uses FakeAssetBundle or direct `_resolveSheetPosition` testing):
1. Single sheet: index 0 maps to (sheet 0, local 0)
2. Single sheet: index at end of first row maps correctly
3. Multiple sheets: index spanning to second sheet resolves correctly
4. Out-of-range index throws RangeError
5. Crop rect calculation: col * frameWidth, row * frameHeight
6. `resolveFramePath` returns `assetPath#localIndex` format

**File 14: `test/network_frame_loader_test.dart`** (CREATE)

Test cases (may need test HTTP server or mock):
1. Disk cache hit returns image without network call
2. `resolveFramePath` applies index padding and offset correctly
3. Constructor stores all parameters correctly

Note: Full integration tests for network download require an HTTP server. Unit tests can verify path resolution and caching logic. We can test the decode path using pre-written bytes to a temp file.

**File 15: `test/frame_cache_manager_test.dart`** (MODIFY -- add tests)

New test cases:
1. `preloadForStrategy` loads frames in strategy order
2. `preloadForStrategy` with chunked strategy evicts outside window
3. `preloadForStrategy` calls `ui.Image.dispose()` on evicted frames
4. `_evictOutsideSet` preserves frames in keep set
5. `preloadForStrategy` reports progress via callback

**File 16: `test/scroll_progress_tracker_test.dart`** (MODIFY -- add tests)

New test cases:
1. Initial direction is `ScrollDirection.idle`
2. Increasing progress sets direction to `forward`
3. Decreasing progress sets direction to `backward`
4. Tiny delta below threshold keeps previous direction
5. Direction persists across multiple same-direction updates

---

## Integration Flow

How the pieces connect at runtime:

```
User scrolls
    |
    v
PinnedScrollSection / ScrollNotification
    |
    v
ScrollProgressTracker.calculateProgress() --> progress (0.0-1.0)
ScrollProgressTracker.updateDirection(progress) --> ScrollDirection
    |
    v
FrameController.updateFromProgress(progress) --> currentIndex (via ticker lerp)
    |
    v
_onFrameChanged()
    |
    +---> setState (rebuild FrameDisplay)
    |
    +---> _preloadAroundCurrent() [if strategy.shouldEvictOutsideWindow]
              |
              v
          FrameCacheManager.preloadForStrategy(
            currentIndex, totalFrames, strategy, direction, loader
          )
              |
              +---> strategy.framesToLoad() --> [ordered indices]
              +---> _evictOutsideSet(targetSet) --> dispose GPU textures
              +---> loadFrame(index, loader) for each missing
```

---

## Dependency Graph (Build Order)

```
Phase 1: preload_strategy.dart         (no deps)
Phase 2: scroll_progress_tracker.dart  (depends on Phase 1 for ScrollDirection enum)
Phase 3: frame_cache_manager.dart      (depends on Phase 1 for PreloadStrategy)
Phase 4: sprite_sheet_loader.dart      (depends on frame_loader.dart, no new deps)
Phase 5: network_frame_loader.dart     (depends on frame_loader.dart, dart:io)
Phase 6: scroll_sequence_widget.dart   (depends on Phases 1-5)
Phase 7: barrel exports + pubspec      (depends on all above)
Phase 8: tests                         (depends on all above)
```

Phases 4 and 5 can be done in parallel since they are independent loaders.

---

## Testing Strategy

| Component | Test Type | Approach |
|-----------|-----------|----------|
| PreloadStrategy (eager/chunked/progressive) | Unit | Pure logic, no Flutter deps. Test range calculation, direction behavior, edge cases. |
| SpriteSheetLoader | Unit | Test `_resolveSheetPosition` (make public or test via loadFrame with mock bundle). Crop rect math. |
| NetworkFrameLoader | Unit + Integration | Unit: path resolution, padding. Integration: write bytes to temp file, verify decode. |
| FrameCacheManager (strategy) | Unit | Use existing `FakeFrameLoader`. Test preloadForStrategy, eviction, dispose calls. |
| ScrollProgressTracker (direction) | Unit | Pure logic. Feed progress values, verify direction output. |
| ScrollSequence widget | Widget test | Verify backward compat: default constructor still works. Verify new constructors create correct loader/strategy. |

**Total estimated new tests:** 25-35 test cases across 4 new + 2 modified test files.

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `loadingBuilder` type change breaks existing consumers | Medium | Medium | Package is 0.1.0 (pre-1.0), breaking changes are acceptable. Document in CHANGELOG. |
| `dart:io` in `NetworkFrameLoader` prevents web compilation | Low | Low | Document web limitation. Consumers not using NetworkFrameLoader won't import it. Consider conditional export if needed. |
| Strategy preloading on every frame change causes excessive async work | Medium | Medium | Use `_loading` dedup set in `FrameCacheManager`. Debounce `_preloadAroundCurrent` if needed (not in initial impl, can add later). |
| Sprite sheet `Canvas.drawImageRect` performance on large sheets | Low | Low | Sheets are loaded once and cached. Individual crop is fast (single draw call). |
| Memory spike during strategy transitions (eviction + loading overlap) | Low | Medium | Evict BEFORE loading new frames in `preloadForStrategy`. This is already the order in the plan. |
| `ScrollDirection` enum in strategies creates import coupling | Low | Low | Single enum, clean dependency. Tracker imports from strategies. Acceptable for a single-package scope. |

---

## Backward Compatibility Checklist

- [x] `ScrollSequence()` constructor: all existing params unchanged, same defaults
- [x] `ScrollSequence()` without `loader`/`strategy`: uses `AssetFrameLoader` + `EagerPreloadStrategy` (identical to current behavior)
- [x] `FrameCacheManager` existing API: `loadFrame`, `getFrame`, `clearAll`, `nearestCachedFrame` -- all unchanged
- [x] `ScrollProgressTracker` existing API: `calculateProgress`, `calculatePinnedProgress` -- unchanged
- [x] `FrameController` -- no changes
- [x] `FrameDisplay` -- no changes
- [x] `PinnedScrollSection` -- no changes
- [x] `FramePathResolver` -- no changes
- [x] All existing barrel exports -- unchanged (only additions)

---

## Key API Design Decisions

1. **Strategy as value object (const constructors):** Allows declaration in widget constructors without allocation overhead. Strategies are stateless -- all state lives in FrameCacheManager.

2. **`framesToLoad` returns ordered list, not set:** Order determines loading priority. Current frame first, then directional bias. This is critical for perceived performance.

3. **No `http` dependency:** Using `dart:io` HttpClient avoids adding a transitive dependency. The package stays dependency-free (Flutter SDK only).

4. **`cacheDirectory` as constructor param (not auto-resolved):** Keeps `path_provider` out of the package deps. The consuming app provides the directory. This follows the dependency inversion principle.

5. **`loadingBuilder` becomes `LoadingWidgetBuilder` with progress:** The progress value (0.0-1.0) enables proper loading indicators. This is a mild breaking change acceptable at 0.1.0.

6. **`ScrollDirection` defined in strategy file:** Avoids circular dependency. Tracker imports from strategy, not the other way around.

---

**Plan created for BR-125**

**Complexity:** M (Medium)
**Files affected:** 17 (6 create, 11 modify)
**Phases:** 8

Ready for implementation.
