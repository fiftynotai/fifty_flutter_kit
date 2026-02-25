import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';
import '../loaders/frame_loader.dart';

/// Provides read-only access to scroll sequence internals for the controller.
///
/// Implemented by the widget state and passed to [ScrollSequenceController]
/// via [ScrollSequenceController._attach]. This decouples the controller
/// from the concrete state class.
abstract class ScrollSequenceStateAccessor {
  /// The ancestor scroll position, or null if not yet available.
  ScrollPosition? get scrollPosition;

  /// The scroll extent configured on the widget.
  double get scrollExtent;

  /// Whether the widget is in pinned mode.
  bool get isPinned;

  /// The vertical offset of the widget in the scroll view.
  ///
  /// For pinned mode this is the top of the [PinnedScrollSection] in the
  /// scroll content, used to calculate jump offsets.
  double get widgetTopOffset;
}

/// A public controller for programmatic interaction with a [ScrollSequence].
///
/// Provides read-only access to the current frame, progress, and loading
/// state, plus commands for programmatic scrolling, preloading, and cache
/// management.
///
/// ## Lifecycle
///
/// Create the controller in your widget state and pass it to [ScrollSequence].
/// The widget attaches internal references in `initState` and detaches them
/// in `dispose`. Do NOT call [dispose] before the [ScrollSequence] is removed
/// from the tree.
///
/// ## Example
///
/// ```dart
/// class MyWidget extends StatefulWidget {
///   @override
///   State<MyWidget> createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> {
///   final _controller = ScrollSequenceController();
///
///   @override
///   void dispose() {
///     _controller.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ScrollSequence(
///       frameCount: 120,
///       framePath: 'assets/hero/frame_{index}.webp',
///       controller: _controller,
///       scrollExtent: 3000,
///     );
///   }
/// }
/// ```
class ScrollSequenceController extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Internal attachment state
  // ---------------------------------------------------------------------------

  FrameCacheManager? _cacheManager;
  FrameLoader? _loader;
  ScrollSequenceStateAccessor? _accessor;
  int _frameCount = 0;

  // ---------------------------------------------------------------------------
  // Synced state (updated by the widget via _updateState)
  // ---------------------------------------------------------------------------

  int _currentFrame = 0;
  double _progress = 0.0;
  int _loadedFrameCount = 0;

  /// Guard flag to prevent infinite notification loops.
  ///
  /// When the controller triggers a scroll animation (jumpToFrame/Progress),
  /// the resulting scroll events cause the widget to call [_updateState],
  /// which would call [notifyListeners] again. This flag breaks the cycle.
  bool _isUpdatingFromController = false;

  // ---------------------------------------------------------------------------
  // Read-only state
  // ---------------------------------------------------------------------------

  /// Current frame index (zero-based).
  int get currentFrame => _currentFrame;

  /// Current interpolated progress (0.0 to 1.0).
  double get progress => _progress;

  /// Total number of frames in the attached sequence.
  int get frameCount => _frameCount;

  /// Whether all frames have been loaded into the cache.
  bool get isFullyLoaded =>
      _frameCount > 0 && _loadedFrameCount >= _frameCount;

  /// Number of frames currently in the cache.
  int get loadedFrameCount => _loadedFrameCount;

  /// Loading progress as a fraction (0.0 to 1.0).
  ///
  /// Returns 0.0 when no frames are loaded or no sequence is attached.
  double get loadingProgress =>
      _frameCount > 0 ? (_loadedFrameCount / _frameCount).clamp(0.0, 1.0) : 0.0;

  /// Whether a [ScrollSequence] widget is currently attached.
  bool get isAttached => _cacheManager != null;

  // ---------------------------------------------------------------------------
  // Commands
  // ---------------------------------------------------------------------------

  /// Programmatically scroll to the given [frame] index.
  ///
  /// Animates the ancestor scroll position so that the scroll sequence
  /// displays the target frame. The [duration] controls the animation speed.
  ///
  /// Throws [StateError] if no [ScrollSequence] is attached.
  void jumpToFrame(
    int frame, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    _assertAttached();
    final clampedFrame =
        frame.clamp(0, _frameCount > 1 ? _frameCount - 1 : 0);
    final targetProgress =
        _frameCount > 1 ? clampedFrame / (_frameCount - 1) : 0.0;
    jumpToProgress(targetProgress, duration: duration);
  }

  /// Programmatically scroll to the given [progress] value (0.0 to 1.0).
  ///
  /// Animates the ancestor scroll position so that the scroll sequence
  /// reflects the target progress. The [duration] controls animation speed.
  ///
  /// Throws [StateError] if no [ScrollSequence] is attached.
  void jumpToProgress(
    double progress, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    _assertAttached();
    final accessor = _accessor!;
    final scrollPosition = accessor.scrollPosition;
    if (scrollPosition == null) return;

    final clampedProgress = progress.clamp(0.0, 1.0);
    final targetOffset =
        accessor.widgetTopOffset + clampedProgress * accessor.scrollExtent;
    final clampedOffset = targetOffset.clamp(
      scrollPosition.minScrollExtent,
      scrollPosition.maxScrollExtent,
    );

    _isUpdatingFromController = true;
    scrollPosition
        .animateTo(
      clampedOffset,
      duration: duration,
      curve: Curves.easeInOut,
    )
        .whenComplete(() {
      _isUpdatingFromController = false;
    });
  }

  /// Preload all frames in the sequence.
  ///
  /// Loads every frame from index 0 to [frameCount] - 1 into the cache.
  /// Returns a [Future] that completes when all frames are loaded.
  ///
  /// Throws [StateError] if no [ScrollSequence] is attached.
  Future<void> preloadAll() async {
    _assertAttached();
    final cache = _cacheManager!;
    final loader = _loader!;

    for (int i = 0; i < _frameCount; i++) {
      await cache.loadFrame(i, loader);
    }

    _loadedFrameCount = cache.length;
    notifyListeners();
  }

  /// Clear all cached frames.
  ///
  /// This disposes all GPU textures in the cache. The widget will show
  /// placeholder or empty content until frames are re-loaded via scrolling.
  ///
  /// Throws [StateError] if no [ScrollSequence] is attached.
  void clearCache() {
    _assertAttached();
    _cacheManager!.clearAll();
    _loadedFrameCount = 0;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Internal API (called by widget state)
  // ---------------------------------------------------------------------------

  /// Attach internal references from the widget state.
  ///
  /// Called by [_ScrollSequenceState.initState] after creating internals.
  // ignore: use_setters_to_change_properties
  void attach({
    required FrameCacheManager cacheManager,
    required FrameLoader loader,
    required int frameCount,
    required ScrollSequenceStateAccessor accessor,
  }) {
    _cacheManager = cacheManager;
    _loader = loader;
    _frameCount = frameCount;
    _accessor = accessor;
    _loadedFrameCount = cacheManager.length;
  }

  /// Detach internal references when the widget is disposed.
  ///
  /// Called by [_ScrollSequenceState.dispose] before disposing internals.
  void detach() {
    _cacheManager = null;
    _loader = null;
    _accessor = null;
    _frameCount = 0;
    _currentFrame = 0;
    _progress = 0.0;
    _loadedFrameCount = 0;
  }

  /// Update synced state from the widget.
  ///
  /// Called by [_ScrollSequenceState._onFrameChanged] on every frame change.
  /// Skipped when [_isUpdatingFromController] is true to prevent loops.
  void updateState({
    required int currentFrame,
    required double progress,
    required int loadedCount,
  }) {
    if (_isUpdatingFromController) return;

    _currentFrame = currentFrame;
    _progress = progress;
    _loadedFrameCount = loadedCount;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _assertAttached() {
    if (!isAttached) {
      throw StateError(
        'ScrollSequenceController is not attached to a ScrollSequence widget. '
        'Ensure the controller is passed to a ScrollSequence that is in the '
        'widget tree before calling commands.',
      );
    }
  }
}
