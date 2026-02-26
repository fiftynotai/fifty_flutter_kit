import 'package:flutter/rendering.dart' show Axis, ScrollDirection;
import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';
import '../core/frame_controller.dart';
import '../core/scroll_progress_tracker.dart';
import '../core/snap_controller.dart';
import '../core/viewport_observer.dart';
import '../loaders/asset_frame_loader.dart';
import '../loaders/frame_loader.dart';
import '../loaders/network_frame_loader.dart';
import '../loaders/sprite_sheet_loader.dart';
import '../models/snap_config.dart';
import '../strategies/preload_strategy.dart' as preload_strategy;
import '../strategies/preload_strategy.dart' show PreloadStrategy;
import 'frame_display.dart';
import 'pinned_scroll_section.dart';
import 'scroll_sequence_controller.dart';

/// Callback signature for frame change events.
///
/// [frameIndex] is the current zero-based frame index.
/// [progress] is the interpolated progress value (0.0 to 1.0).
typedef FrameChangedCallback = void Function(int frameIndex, double progress);

/// Builder for loading state with normalized progress (0.0 to 1.0).
///
/// Use this to build custom loading indicators that reflect preload progress.
typedef LoadingWidgetBuilder = Widget Function(
  BuildContext context,
  double progress,
);

/// A scroll-driven image sequence widget that plays through frames
/// as the user scrolls, creating an Apple-style scrubbing effect.
///
/// Supports two modes:
///
/// - **Pinned mode** ([pin] = `true`, default): The widget sticks to the
///   viewport top while [scrollExtent] pixels of scroll distance are consumed.
///   Frames play smoothly during the pinned phase.
///
/// - **Non-pinned mode** ([pin] = `false`): The widget scrolls normally
///   and frames change based on viewport-relative position. Equivalent to
///   the original BR-123 behavior.
///
/// Frames are loaded eagerly from the asset bundle and cached in an LRU
/// cache with proper [ui.Image] disposal.
///
/// ## Example
///
/// ```dart
/// SingleChildScrollView(
///   child: Column(
///     children: [
///       const SizedBox(height: 500),
///       ScrollSequence(
///         frameCount: 120,
///         framePath: 'assets/hero/frame_{index}.webp',
///         scrollExtent: 3000,
///         fit: BoxFit.cover,
///         lerpFactor: 0.15,
///         curve: Curves.easeInOut,
///         builder: (context, frameIndex, progress, child) {
///           return Stack(
///             children: [
///               child,
///               Positioned(
///                 bottom: 16,
///                 left: 16,
///                 child: Text('Frame $frameIndex'),
///               ),
///             ],
///           );
///         },
///       ),
///       const SizedBox(height: 500),
///     ],
///   ),
/// )
/// ```
class ScrollSequence extends StatefulWidget {
  /// Creates a [ScrollSequence] widget.
  ///
  /// By default, uses [AssetFrameLoader] and [PreloadStrategy.eager()].
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
    this.pin = true,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    this.loader,
    this.strategy,
    this.controller,
    this.snapConfig,
    this.onEnter,
    this.onLeave,
    this.onEnterBack,
    this.onLeaveBack,
    this.scrollDirection = Axis.vertical,
    super.key,
  });

  /// Creates a [ScrollSequence] that loads frames from network URLs.
  ///
  /// Downloaded frames are cached to [cacheDirectory] for offline access.
  /// Obtain the directory via `(await getTemporaryDirectory()).path` from
  /// the `path_provider` package.
  ///
  /// Defaults to [PreloadStrategy.chunked()] which is optimal for network
  /// loading since it avoids downloading all frames upfront.
  ///
  /// ## Example
  ///
  /// ```dart
  /// ScrollSequence.network(
  ///   frameCount: 200,
  ///   frameUrl: 'https://cdn.example.com/hero/frame_{index}.webp',
  ///   cacheDirectory: tempDir.path,
  ///   scrollExtent: 4000,
  /// )
  /// ```
  ScrollSequence.network({
    required this.frameCount,
    required String frameUrl,
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
    this.controller,
    this.snapConfig,
    this.onEnter,
    this.onLeave,
    this.onEnterBack,
    this.onLeaveBack,
    this.scrollDirection = Axis.vertical,
    super.key,
  })  : framePath = frameUrl,
        strategy = strategy ?? const PreloadStrategy.chunked(),
        loader = NetworkFrameLoader(
          frameUrlPattern: frameUrl,
          frameCount: frameCount,
          cacheDirectory: cacheDirectory,
          headers: headers,
          indexPadWidth: indexPadWidth,
          indexOffset: indexOffset,
          onDownloadProgress: onDownloadProgress,
        );

  /// Creates a [ScrollSequence] from sprite sheet grid images.
  ///
  /// Each [SpriteSheetConfig] describes one sprite sheet image containing
  /// a grid of frames. Multiple sheets can be used for large sequences.
  ///
  /// Defaults to [PreloadStrategy.chunked()] since sprite sheets often
  /// contain many frames.
  ///
  /// ## Example
  ///
  /// ```dart
  /// ScrollSequence.spriteSheet(
  ///   frameCount: 100,
  ///   sheets: [
  ///     SpriteSheetConfig(
  ///       assetPath: 'assets/sprites/sheet_01.webp',
  ///       columns: 10,
  ///       rows: 10,
  ///       frameWidth: 320,
  ///       frameHeight: 180,
  ///     ),
  ///   ],
  ///   scrollExtent: 3000,
  /// )
  /// ```
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
    this.controller,
    this.snapConfig,
    this.onEnter,
    this.onLeave,
    this.onEnterBack,
    this.onLeaveBack,
    this.scrollDirection = Axis.vertical,
    super.key,
  })  : framePath = '',
        indexPadWidth = null,
        indexOffset = 0,
        strategy = strategy ?? const PreloadStrategy.chunked(),
        loader = SpriteSheetLoader(sheets: sheets, totalFrames: frameCount);

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Path pattern with `{index}` placeholder.
  ///
  /// Example: `'assets/hero/frame_{index}.webp'`
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
  ///
  /// Receives a normalized progress value (0.0 to 1.0) reflecting how many
  /// frames from the initial load have been cached so far.
  final LoadingWidgetBuilder? loadingBuilder;

  /// Called when the displayed frame index or progress changes.
  final FrameChangedCallback? onFrameChanged;

  /// Override for zero-pad width of frame indices.
  final int? indexPadWidth;

  /// Frame index offset (0 or 1 typically).
  final int indexOffset;

  /// Maximum frames to keep in memory cache.
  final int maxCacheSize;

  /// Whether to pin (stick) the sequence while [scrollExtent] is consumed.
  ///
  /// When `true` (default), the widget stays fixed at the viewport top
  /// while the scroll runway is consumed. When `false`, the widget scrolls
  /// normally and frames change based on viewport-relative position.
  final bool pin;

  /// Builder for overlay content that reacts to frame index and progress.
  ///
  /// The [child] parameter is the frame display widget. Wrap it or stack
  /// overlays on top.
  ///
  /// ```dart
  /// builder: (context, frameIndex, progress, child) {
  ///   return Stack(children: [child, MyOverlay(progress: progress)]);
  /// },
  /// ```
  final Widget Function(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  )? builder;

  /// Lerp smoothing factor (greater than 0.0, up to 1.0).
  ///
  /// Lower values produce smoother but slower catch-up.
  /// `1.0` disables smoothing (instant updates, BR-123 behavior).
  final double lerpFactor;

  /// Curve applied to the progress-to-frame mapping.
  ///
  /// For example, [Curves.easeInOut] causes frames to change slowly
  /// at the start and end of the scroll range and faster in the middle.
  final Curve curve;

  /// Optional custom frame loader.
  ///
  /// When null, [AssetFrameLoader] is used with [framePath].
  final FrameLoader? loader;

  /// Preload strategy controlling when frames are loaded/evicted.
  ///
  /// Defaults to [PreloadStrategy.eager()] for the default constructor
  /// and [PreloadStrategy.chunked()] for network/sprite sheet constructors.
  final PreloadStrategy? strategy;

  /// Optional controller for programmatic interaction with the sequence.
  ///
  /// Provides read-only access to current frame, progress, and loading state
  /// plus commands like [ScrollSequenceController.jumpToFrame] and
  /// [ScrollSequenceController.preloadAll].
  ///
  /// The controller is attached in `initState` and detached in `dispose`.
  /// Passing `null` disables programmatic control (backward-compatible).
  final ScrollSequenceController? controller;

  /// Optional snap-to-keyframe configuration.
  ///
  /// When non-null, the scroll position auto-settles to the nearest snap
  /// point when the user stops scrolling. See [SnapConfig] for details.
  final SnapConfig? snapConfig;

  /// Called when the sequence enters the viewport (forward scroll).
  final VoidCallback? onEnter;

  /// Called when the sequence exits the viewport (forward scroll).
  final VoidCallback? onLeave;

  /// Called when the sequence re-enters the viewport (backward scroll).
  final VoidCallback? onEnterBack;

  /// Called when the sequence exits the viewport backward.
  final VoidCallback? onLeaveBack;

  /// The scroll axis for the sequence.
  ///
  /// Defaults to [Axis.vertical]. When set to [Axis.horizontal], the widget
  /// uses width-based layout and horizontal progress calculations.
  final Axis scrollDirection;

  @override
  State<ScrollSequence> createState() => _ScrollSequenceState();
}

class _ScrollSequenceState extends State<ScrollSequence>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver
    implements ScrollSequenceStateAccessor {
  late FrameLoader _loader;
  late FrameCacheManager _cache;
  late FrameController _controller;
  late ScrollProgressTracker _tracker;
  late PreloadStrategy _strategy;
  SnapController? _snapController;
  ViewportObserver? _viewportObserver;
  ScrollPosition? _attachedScrollPosition;
  bool _isLoadingFrames = true;
  int _loadedCount = 0;
  int _totalToLoad = 0;

  // ---------------------------------------------------------------------------
  // ScrollSequenceStateAccessor
  // ---------------------------------------------------------------------------

  @override
  ScrollPosition? get scrollPosition => Scrollable.maybeOf(context)?.position;

  @override
  double get scrollExtent => widget.scrollExtent;

  @override
  bool get isPinned => widget.pin;

  @override
  Axis get scrollDirection => widget.scrollDirection;

  @override
  double get widgetTopOffset {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 0;

    // Return the leading-edge offset in the configured scroll direction.
    // For pinned mode, this is the scroll offset at which the widget's
    // leading edge reaches the viewport's leading edge (i.e. the absolute
    // position in scroll content).
    final position = scrollPosition;
    if (position == null) return 0;

    final globalOffset = renderBox.localToGlobal(Offset.zero);
    final leadingEdgeInViewport = widget.scrollDirection == Axis.vertical
        ? globalOffset.dy
        : globalOffset.dx;
    return position.pixels + leadingEdgeInViewport;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loader = widget.loader ??
        AssetFrameLoader(
          framePath: widget.framePath,
          frameCount: widget.frameCount,
          indexPadWidth: widget.indexPadWidth,
          indexOffset: widget.indexOffset,
        );

    _strategy = widget.strategy ?? const PreloadStrategy.eager();

    _cache = FrameCacheManager(
      maxCacheSize:
          _strategy.maxCacheSize(widget.frameCount).clamp(1, widget.maxCacheSize),
    );
    _controller = FrameController(
      frameCount: widget.frameCount,
      vsync: this,
      lerpFactor: widget.lerpFactor,
      curve: widget.curve,
    );
    _tracker = ScrollProgressTracker(scrollExtent: widget.scrollExtent);

    _controller.addListener(_onFrameChanged);

    // Attach the public controller after internals are ready.
    widget.controller?.attach(
      cacheManager: _cache,
      loader: _loader,
      frameCount: widget.frameCount,
      accessor: this,
    );

    // Create snap controller if configured.
    if (widget.snapConfig != null) {
      _snapController = SnapController(config: widget.snapConfig!);
    }

    // Create viewport observer if any lifecycle callback is provided.
    if (widget.onEnter != null ||
        widget.onLeave != null ||
        widget.onEnterBack != null ||
        widget.onLeaveBack != null) {
      _viewportObserver = ViewportObserver(
        onEnter: widget.onEnter,
        onLeave: widget.onLeave,
        onEnterBack: widget.onEnterBack,
        onLeaveBack: widget.onLeaveBack,
      );
    }

    _initialLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachSnapController();
  }

  void _attachSnapController() {
    final snap = _snapController;
    if (snap == null) return;
    final position = Scrollable.maybeOf(context)?.position;
    if (position == null) return;

    // Detach from previous position if re-attaching.
    _detachScrollPositionListeners();

    snap.attach(
      position,
      scrollExtent: widget.scrollExtent,
      currentProgress: () => _controller.progress,
    );

    // In pinned mode, NotificationListener can't catch scroll notifications
    // from the ancestor scrollable (notifications bubble UP, not DOWN).
    // Listen to the ScrollPosition directly for scroll idle detection.
    //
    // We use position.addListener (fires on every pixel change) with a
    // pure debounce approach: each change resets the idle timer. When
    // position stops changing for idleTimeout ms, snap fires.
    //
    // NOTE: We do NOT use isScrollingNotifier because it toggles between
    // discrete scroll events on macOS trackpad, causing false snap triggers.
    if (widget.pin) {
      _attachedScrollPosition = position;
      position.addListener(_onScrollPositionChanged);
    }
  }

  void _detachScrollPositionListeners() {
    final position = _attachedScrollPosition;
    if (position == null) return;
    position.removeListener(_onScrollPositionChanged);
    _attachedScrollPosition = null;
  }

  /// Called when the ancestor scroll position changes (pinned mode only).
  ///
  /// Ignores position changes from the snap animation itself (isSnapping
  /// guard). When the user scrolls, resets the idle debounce timer. Snap
  /// fires when no user-driven position changes occur for idleTimeout ms.
  ///
  /// If the user grabs the scroll during a snap animation, Flutter interrupts
  /// the [DrivenScrollActivity] which completes the animateTo future, setting
  /// isSnapping = false. Subsequent position changes then process normally.
  void _onScrollPositionChanged() {
    if (_snapController == null || _snapController!.isSnapping) return;
    // Reset idle timer — snap fires when position stops changing.
    _snapController!.onScrollEnd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.pauseTicker();
    } else if (state == AppLifecycleState.resumed) {
      _controller.resumeTicker();
    }
  }

  void _onFrameChanged() {
    widget.onFrameChanged?.call(
      _controller.currentIndex,
      _controller.progress,
    );

    // Sync state to the public controller.
    widget.controller?.updateState(
      currentFrame: _controller.currentIndex,
      progress: _controller.progress,
      loadedCount: _cache.length,
    );

    // Update direction tracking.
    _tracker.updateDirection(_controller.progress);

    // Trigger strategy-driven preload for non-eager strategies.
    if (_strategy.shouldEvictOutsideWindow) {
      _preloadAroundCurrent();
    }

    if (mounted) setState(() {});
  }

  /// Strategy-aware initial load.
  Future<void> _initialLoad() async {
    final targets = _strategy.framesToLoad(
      currentIndex: 0,
      totalFrames: widget.frameCount,
      direction: preload_strategy.ScrollDirection.idle,
    );
    _totalToLoad = targets.length;
    _loadedCount = 0;

    for (final index in targets) {
      if (!mounted) return;
      await _cache.loadFrame(index, _loader);
      _loadedCount++;
      // Show content as soon as first frame is loaded.
      if (_loadedCount == 1 && mounted) {
        setState(() => _isLoadingFrames = false);
      }
      if (mounted) setState(() {}); // Update progress.
    }
    if (mounted) setState(() => _isLoadingFrames = false);
  }

  /// Preload frames around current position using strategy.
  Future<void> _preloadAroundCurrent() async {
    if (!mounted) return;
    await _cache.preloadForStrategy(
      currentIndex: _controller.currentIndex,
      totalFrames: widget.frameCount,
      strategy: _strategy,
      direction: _tracker.direction,
      loader: _loader,
    );
  }

  @override
  void dispose() {
    // Detach the public controller before disposing internals.
    widget.controller?.detach();

    _detachScrollPositionListeners();
    _snapController?.dispose();
    _viewportObserver?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onFrameChanged);
    _controller.dispose();
    _cache.clearAll();
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pin) {
      return _buildPinned();
    }
    return _buildNonPinned();
  }

  // ---------------------------------------------------------------------------
  // Pinned mode
  // ---------------------------------------------------------------------------

  Widget _buildPinned() {
    return PinnedScrollSection(
      scrollExtent: widget.scrollExtent,
      scrollDirection: widget.scrollDirection,
      onProgressChanged: (progress) {
        _tracker.updateDirection(progress);
        _controller.updateFromProgress(progress);

        // Feed pinned lifecycle events.
        _viewportObserver?.updatePinnedState(
          progress: progress,
          direction: _flutterDirection,
        );
      },
      child: _buildFrameContent(),
    );
  }

  /// Converts the local [ScrollProgressTracker] direction to Flutter's
  /// [ScrollDirection] for use with [ViewportObserver].
  ScrollDirection get _flutterDirection {
    switch (_tracker.direction) {
      case preload_strategy.ScrollDirection.forward:
        return ScrollDirection.forward;
      case preload_strategy.ScrollDirection.backward:
        return ScrollDirection.reverse;
      case preload_strategy.ScrollDirection.idle:
        return ScrollDirection.idle;
    }
  }

  // ---------------------------------------------------------------------------
  // Non-pinned mode (BR-123 behavior)
  // ---------------------------------------------------------------------------

  Widget _buildNonPinned() {
    final isHorizontal = widget.scrollDirection == Axis.horizontal;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: SizedBox(
        width: isHorizontal ? (widget.width ?? widget.scrollExtent) : widget.width,
        height: isHorizontal ? widget.height : (widget.height ?? widget.scrollExtent),
        child: _buildFrameContent(),
      ),
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    // Calculate widget position relative to viewport using context.
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;

    final viewportDimension = notification.metrics.viewportDimension;
    final globalOffset = renderBox.localToGlobal(Offset.zero);

    final double progress;
    if (widget.scrollDirection == Axis.horizontal) {
      progress = _tracker.calculateHorizontalProgress(
        widgetLeftInViewport: globalOffset.dx,
        viewportWidth: viewportDimension,
      );
    } else {
      progress = _tracker.calculateProgress(
        widgetTopInViewport: globalOffset.dy,
        viewportHeight: viewportDimension,
      );
    }

    _tracker.updateDirection(progress);
    _controller.updateFromProgress(progress);

    // Feed non-pinned lifecycle events.
    if (_viewportObserver != null) {
      final isVisible = _isWidgetInViewport(
        globalOffset: globalOffset,
        renderBox: renderBox,
        viewportDimension: viewportDimension,
      );
      _viewportObserver!.updateVisibility(
        isVisible: isVisible,
        direction: _flutterDirection,
      );
    }

    // Feed snap controller events.
    if (_snapController != null && _snapController!.isSnapping != true) {
      if (notification is ScrollUpdateNotification) {
        _snapController!.onScrollUpdate();
      } else if (notification is ScrollEndNotification) {
        _snapController!.onScrollEnd();
      }
    }

    return false; // Don't absorb the notification.
  }

  /// Checks if the widget's render box is visible within the viewport.
  bool _isWidgetInViewport({
    required Offset globalOffset,
    required RenderBox renderBox,
    required double viewportDimension,
  }) {
    if (widget.scrollDirection == Axis.horizontal) {
      final left = globalOffset.dx;
      final right = left + renderBox.size.width;
      return right > 0 && left < viewportDimension;
    } else {
      final top = globalOffset.dy;
      final bottom = top + renderBox.size.height;
      return bottom > 0 && top < viewportDimension;
    }
  }

  // ---------------------------------------------------------------------------
  // Frame content
  // ---------------------------------------------------------------------------

  Widget _buildFrameContent() {
    if (_isLoadingFrames && _cache.length == 0) {
      if (widget.placeholder != null) {
        return Image(image: widget.placeholder!, fit: widget.fit);
      }
      if (widget.loadingBuilder != null) {
        final progress = _totalToLoad > 0
            ? (_loadedCount / _totalToLoad).clamp(0.0, 1.0)
            : 0.0;
        return widget.loadingBuilder!(context, progress);
      }
      return const SizedBox.shrink();
    }

    final frameWidget = FrameDisplay(
      frameIndex: _controller.currentIndex,
      cacheManager: _cache,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
    );

    if (widget.builder != null) {
      return widget.builder!(
        context,
        _controller.currentIndex,
        _controller.progress,
        frameWidget,
      );
    }

    return frameWidget;
  }
}
