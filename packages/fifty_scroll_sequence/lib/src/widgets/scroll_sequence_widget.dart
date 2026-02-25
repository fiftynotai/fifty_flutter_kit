import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';
import '../core/frame_controller.dart';
import '../core/scroll_progress_tracker.dart';
import '../loaders/asset_frame_loader.dart';
import 'frame_display.dart';
import 'pinned_scroll_section.dart';

/// Callback signature for frame change events.
///
/// [frameIndex] is the current zero-based frame index.
/// [progress] is the interpolated progress value (0.0 to 1.0).
typedef FrameChangedCallback = void Function(int frameIndex, double progress);

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
    super.key,
  });

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
  final WidgetBuilder? loadingBuilder;

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

  @override
  State<ScrollSequence> createState() => _ScrollSequenceState();
}

class _ScrollSequenceState extends State<ScrollSequence>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AssetFrameLoader _loader;
  late FrameCacheManager _cache;
  late FrameController _controller;
  late ScrollProgressTracker _tracker;
  bool _isLoadingFrames = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loader = AssetFrameLoader(
      framePath: widget.framePath,
      frameCount: widget.frameCount,
      indexPadWidth: widget.indexPadWidth,
      indexOffset: widget.indexOffset,
    );
    _cache = FrameCacheManager(maxCacheSize: widget.maxCacheSize);
    _controller = FrameController(
      frameCount: widget.frameCount,
      vsync: this,
      lerpFactor: widget.lerpFactor,
      curve: widget.curve,
    );
    _tracker = ScrollProgressTracker(scrollExtent: widget.scrollExtent);

    _controller.addListener(_onFrameChanged);
    _eagerLoadAllFrames();
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
    if (mounted) setState(() {});
  }

  Future<void> _eagerLoadAllFrames() async {
    for (int i = 0; i < widget.frameCount; i++) {
      if (!mounted) return;
      await _cache.loadFrame(i, _loader);
      // Trigger rebuild after first frame so placeholder disappears fast.
      if (i == 0 && mounted) setState(() => _isLoadingFrames = false);
    }
    if (mounted) setState(() => _isLoadingFrames = false);
  }

  @override
  void dispose() {
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
      onProgressChanged: (progress) {
        _controller.updateFromProgress(progress);
      },
      child: _buildFrameContent(),
    );
  }

  // ---------------------------------------------------------------------------
  // Non-pinned mode (BR-123 behavior)
  // ---------------------------------------------------------------------------

  Widget _buildNonPinned() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: SizedBox(
        width: widget.width,
        height: widget.height ?? widget.scrollExtent,
        child: _buildFrameContent(),
      ),
    );
  }

  bool _handleScroll(ScrollNotification notification) {
    // Calculate widget position relative to viewport using context.
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return false;

    final viewportHeight = notification.metrics.viewportDimension;
    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    final progress = _tracker.calculateProgress(
      widgetTopInViewport: widgetTopInViewport,
      viewportHeight: viewportHeight,
    );

    _controller.updateFromProgress(progress);
    return false; // Don't absorb the notification.
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
        return widget.loadingBuilder!(context);
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
