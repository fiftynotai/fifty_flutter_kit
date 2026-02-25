import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';
import '../core/frame_controller.dart';
import '../core/scroll_progress_tracker.dart';
import '../loaders/asset_frame_loader.dart';
import 'frame_display.dart';

/// A scroll-driven image sequence widget that plays through frames
/// as the user scrolls, creating an Apple-style scrubbing effect.
///
/// Listens to [ScrollNotification] events to calculate viewport-relative
/// progress and maps that to a frame index. Frames are loaded eagerly
/// from the asset bundle and cached in an LRU cache with proper
/// [ui.Image] disposal.
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
///         height: 600,
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
