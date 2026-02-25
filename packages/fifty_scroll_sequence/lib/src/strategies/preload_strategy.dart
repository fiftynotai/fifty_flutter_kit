import 'dart:math' as math;

/// Scroll direction detected from consecutive progress deltas.
enum ScrollDirection {
  /// User is scrolling forward (progress increasing).
  forward,

  /// User is scrolling backward (progress decreasing).
  backward,

  /// No scroll movement detected (initial state).
  idle,
}

/// Abstract base class for frame preloading strategies.
///
/// A strategy decides which frame indices should be loaded given
/// the current scroll position and direction. The [FrameCacheManager]
/// calls [framesToLoad] on each frame change and evicts frames
/// not in the returned set.
///
/// Three built-in strategies are provided:
///
/// - [EagerPreloadStrategy] -- loads all frames upfront (default, backward
///   compatible with existing behavior).
/// - [ChunkedPreloadStrategy] -- loads a sliding window around the current
///   frame, biased by scroll direction.
/// - [ProgressivePreloadStrategy] -- loads evenly-spaced keyframes first,
///   then fills a window around the current frame.
///
/// ## Example
///
/// ```dart
/// const strategy = PreloadStrategy.chunked(
///   chunkSize: 60,
///   preloadAhead: 40,
///   preloadBehind: 20,
/// );
///
/// final targets = strategy.framesToLoad(
///   currentIndex: 50,
///   totalFrames: 200,
///   direction: ScrollDirection.forward,
/// );
/// ```
abstract class PreloadStrategy {
  /// Creates a [PreloadStrategy].
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
  /// The cache manager will evict indices NOT in this list (for non-eager
  /// strategies).
  List<int> framesToLoad({
    required int currentIndex,
    required int totalFrames,
    required ScrollDirection direction,
  });

  /// Whether the cache should evict frames not in the [framesToLoad] set.
  ///
  /// [EagerPreloadStrategy] returns `false` (keep everything).
  /// [ChunkedPreloadStrategy] and [ProgressivePreloadStrategy] return `true`.
  bool get shouldEvictOutsideWindow;

  /// Maximum number of frames this strategy expects to hold in cache.
  ///
  /// Used to size the LRU cache. [EagerPreloadStrategy] returns
  /// [totalFrames], [ChunkedPreloadStrategy] returns [chunkSize],
  /// [ProgressivePreloadStrategy] returns a computed value.
  int maxCacheSize(int totalFrames);
}

/// Loads all frames eagerly on initialisation.
///
/// This is the default strategy that matches the existing behavior
/// of the package. All frames are loaded in sequential order and
/// nothing is evicted.
class EagerPreloadStrategy extends PreloadStrategy {
  /// Creates an [EagerPreloadStrategy].
  const EagerPreloadStrategy();

  @override
  List<int> framesToLoad({
    required int currentIndex,
    required int totalFrames,
    required ScrollDirection direction,
  }) {
    return List<int>.generate(totalFrames, (i) => i);
  }

  @override
  bool get shouldEvictOutsideWindow => false;

  @override
  int maxCacheSize(int totalFrames) => totalFrames;
}

/// Loads a sliding window of frames around the current scroll position.
///
/// The window is biased by scroll direction: when scrolling forward,
/// more frames are loaded ahead; when scrolling backward, more are
/// loaded behind. In idle state the window is symmetric.
///
/// ## Window Calculation
///
/// - **Forward:** `[current - preloadBehind, current + preloadAhead]`
/// - **Backward:** `[current - preloadAhead, current + preloadBehind]`
/// - **Idle:** `[current - chunkSize~/2, current + chunkSize~/2]`
///
/// All ranges are clamped to `[0, totalFrames - 1]`.
///
/// ## Example
///
/// ```dart
/// const strategy = PreloadStrategy.chunked(
///   chunkSize: 40,
///   preloadAhead: 30,
///   preloadBehind: 10,
/// );
/// ```
class ChunkedPreloadStrategy extends PreloadStrategy {
  /// Creates a [ChunkedPreloadStrategy].
  ///
  /// [chunkSize] is the maximum number of frames held in cache.
  /// [preloadAhead] is frames to load ahead of current (forward direction).
  /// [preloadBehind] is frames to load behind current (forward direction).
  const ChunkedPreloadStrategy({
    this.chunkSize = 40,
    this.preloadAhead = 30,
    this.preloadBehind = 10,
  });

  /// Maximum number of frames to hold in cache at once.
  final int chunkSize;

  /// Frames to load ahead of current index (in the scroll direction).
  final int preloadAhead;

  /// Frames to load behind current index (opposite to scroll direction).
  final int preloadBehind;

  @override
  List<int> framesToLoad({
    required int currentIndex,
    required int totalFrames,
    required ScrollDirection direction,
  }) {
    final int ahead;
    final int behind;

    switch (direction) {
      case ScrollDirection.forward:
        ahead = preloadAhead;
        behind = preloadBehind;
      case ScrollDirection.backward:
        ahead = preloadBehind;
        behind = preloadAhead;
      case ScrollDirection.idle:
        ahead = chunkSize ~/ 2;
        behind = chunkSize ~/ 2;
    }

    final int start = (currentIndex - behind).clamp(0, totalFrames - 1);
    final int end = (currentIndex + ahead).clamp(0, totalFrames - 1);

    final result = <int>[currentIndex.clamp(0, totalFrames - 1)];

    // Ahead frames in order (current+1 .. end).
    for (int i = currentIndex + 1; i <= end; i++) {
      if (i >= 0 && i < totalFrames) {
        result.add(i);
      }
    }

    // Behind frames in order (current-1 .. start).
    for (int i = currentIndex - 1; i >= start; i--) {
      if (i >= 0 && i < totalFrames) {
        result.add(i);
      }
    }

    return result;
  }

  @override
  bool get shouldEvictOutsideWindow => true;

  @override
  int maxCacheSize(int totalFrames) => math.min(chunkSize, totalFrames);
}

/// Loads evenly-spaced keyframes first, then fills a window around
/// the current scroll position.
///
/// This strategy provides instant scrubbing at low resolution (keyframes)
/// while progressively filling detail around the current position.
///
/// ## Loading Order
///
/// 1. Current frame (highest priority)
/// 2. Window frames `[currentIndex - windowBehind, currentIndex + windowAhead]`
/// 3. Keyframes not already in the window
///
/// ## Keyframe Distribution
///
/// Keyframes are evenly spaced across the full sequence:
/// `[0, step, 2*step, ..., totalFrames - 1]`
/// where `step = max(1, totalFrames ~/ keyframeCount)`.
///
/// ## Example
///
/// ```dart
/// const strategy = PreloadStrategy.progressive(
///   keyframeCount: 20,
///   windowAhead: 15,
///   windowBehind: 5,
/// );
/// ```
class ProgressivePreloadStrategy extends PreloadStrategy {
  /// Creates a [ProgressivePreloadStrategy].
  ///
  /// [keyframeCount] is the target number of evenly-spaced keyframes.
  /// [windowAhead] is frames to load ahead of current index.
  /// [windowBehind] is frames to load behind current index.
  const ProgressivePreloadStrategy({
    this.keyframeCount = 20,
    this.windowAhead = 15,
    this.windowBehind = 5,
  });

  /// Target number of evenly-spaced keyframes across the sequence.
  final int keyframeCount;

  /// Frames to load ahead of the current index.
  final int windowAhead;

  /// Frames to load behind the current index.
  final int windowBehind;

  @override
  List<int> framesToLoad({
    required int currentIndex,
    required int totalFrames,
    required ScrollDirection direction,
  }) {
    final seen = <int>{};
    final result = <int>[];

    void addUnique(int index) {
      if (index >= 0 && index < totalFrames && seen.add(index)) {
        result.add(index);
      }
    }

    // 1. Current frame first.
    addUnique(currentIndex);

    // 2. Window frames around current.
    final windowStart = (currentIndex - windowBehind).clamp(0, totalFrames - 1);
    final windowEnd = (currentIndex + windowAhead).clamp(0, totalFrames - 1);
    for (int i = windowStart; i <= windowEnd; i++) {
      addUnique(i);
    }

    // 3. Keyframes not already in the window.
    final step = math.max(1, totalFrames ~/ keyframeCount);
    for (int i = 0; i < totalFrames; i += step) {
      addUnique(i);
    }
    // Always include the last frame as a keyframe.
    addUnique(totalFrames - 1);

    return result;
  }

  @override
  bool get shouldEvictOutsideWindow => true;

  @override
  int maxCacheSize(int totalFrames) =>
      keyframeCount + windowAhead + windowBehind;
}
