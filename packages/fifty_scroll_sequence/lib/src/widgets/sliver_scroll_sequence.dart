import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';
import '../core/frame_controller.dart';
import '../loaders/asset_frame_loader.dart';
import '../loaders/frame_loader.dart';
import '../strategies/preload_strategy.dart';
import 'frame_display.dart';
import 'scroll_sequence_controller.dart';
import 'scroll_sequence_widget.dart' show FrameChangedCallback, LoadingWidgetBuilder;

/// A scroll-driven image sequence for use inside [CustomScrollView].
///
/// Wraps the frame sequence logic in a [SliverPersistentHeader] so it
/// can be placed alongside other slivers. The delegate maps its
/// `shrinkOffset` to a normalized progress (0.0 to 1.0) which drives
/// the frame sequence.
///
/// By default, the header is [pinned] so the sequence sticks to the
/// viewport top while [scrollExtent] pixels are consumed.
///
/// ## Example
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverScrollSequence(
///       frameCount: 120,
///       framePath: 'assets/hero/frame_{index}.webp',
///       scrollExtent: 3000,
///       fit: BoxFit.cover,
///     ),
///     SliverList(
///       delegate: SliverChildBuilderDelegate(
///         (context, index) => ListTile(title: Text('Item $index')),
///         childCount: 50,
///       ),
///     ),
///   ],
/// )
/// ```
class SliverScrollSequence extends StatelessWidget {
  /// Creates a [SliverScrollSequence] widget.
  ///
  /// Most parameters mirror [ScrollSequence]. The [pinned] parameter
  /// controls whether the sliver header pins to the viewport top.
  const SliverScrollSequence({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    this.loader,
    this.strategy,
    this.controller,
    this.pinned = true,
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

  /// Builder for overlay content that reacts to frame index and progress.
  ///
  /// The [child] parameter is the frame display widget. Wrap it or stack
  /// overlays on top.
  final Widget Function(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  )? builder;

  /// Lerp smoothing factor (greater than 0.0, up to 1.0).
  ///
  /// Lower values produce smoother but slower catch-up.
  /// `1.0` disables smoothing (instant updates).
  final double lerpFactor;

  /// Curve applied to the progress-to-frame mapping.
  final Curve curve;

  /// Optional custom frame loader.
  ///
  /// When null, [AssetFrameLoader] is used with [framePath].
  final FrameLoader? loader;

  /// Preload strategy controlling when frames are loaded/evicted.
  ///
  /// Defaults to [PreloadStrategy.eager()].
  final PreloadStrategy? strategy;

  /// Optional controller for programmatic interaction with the sequence.
  final ScrollSequenceController? controller;

  /// Whether the sliver header stays pinned at the viewport top.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _ScrollSequencePersistentDelegate(
        maxExtent: viewportHeight + scrollExtent,
        minExtent: pinned ? viewportHeight : 0,
        scrollExtent: scrollExtent,
        frameCount: frameCount,
        framePath: framePath,
        fit: fit,
        placeholder: placeholder,
        loadingBuilder: loadingBuilder,
        onFrameChanged: onFrameChanged,
        indexPadWidth: indexPadWidth,
        indexOffset: indexOffset,
        maxCacheSize: maxCacheSize,
        builder: builder,
        lerpFactor: lerpFactor,
        curve: curve,
        loader: loader,
        strategy: strategy,
        controller: controller,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Persistent header delegate
// ---------------------------------------------------------------------------

class _ScrollSequencePersistentDelegate
    extends SliverPersistentHeaderDelegate {
  _ScrollSequencePersistentDelegate({
    required double maxExtent,
    required double minExtent,
    required this.scrollExtent,
    required this.frameCount,
    required this.framePath,
    required this.fit,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    this.loader,
    this.strategy,
    this.controller,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  final double _maxExtent;
  final double _minExtent;
  final double scrollExtent;
  final int frameCount;
  final String framePath;
  final BoxFit fit;
  final ImageProvider? placeholder;
  final LoadingWidgetBuilder? loadingBuilder;
  final FrameChangedCallback? onFrameChanged;
  final int? indexPadWidth;
  final int indexOffset;
  final int maxCacheSize;
  final Widget Function(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  )? builder;
  final double lerpFactor;
  final Curve curve;
  final FrameLoader? loader;
  final PreloadStrategy? strategy;
  final ScrollSequenceController? controller;

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant _ScrollSequencePersistentDelegate oldDelegate) {
    return oldDelegate.frameCount != frameCount ||
        oldDelegate.framePath != framePath ||
        oldDelegate.scrollExtent != scrollExtent ||
        oldDelegate.fit != fit ||
        oldDelegate.lerpFactor != lerpFactor ||
        oldDelegate.curve != curve ||
        oldDelegate.loader != loader ||
        oldDelegate.strategy != strategy ||
        oldDelegate.controller != controller;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / scrollExtent).clamp(0.0, 1.0);

    return _SliverScrollSequenceContent(
      progress: progress,
      scrollExtent: scrollExtent,
      frameCount: frameCount,
      framePath: framePath,
      fit: fit,
      placeholder: placeholder,
      loadingBuilder: loadingBuilder,
      onFrameChanged: onFrameChanged,
      indexPadWidth: indexPadWidth,
      indexOffset: indexOffset,
      maxCacheSize: maxCacheSize,
      builder: builder,
      lerpFactor: lerpFactor,
      curve: curve,
      loader: loader,
      strategy: strategy,
      controller: controller,
    );
  }
}

// ---------------------------------------------------------------------------
// Stateful content widget (holds cache, ticker, controller lifecycle)
// ---------------------------------------------------------------------------

class _SliverScrollSequenceContent extends StatefulWidget {
  const _SliverScrollSequenceContent({
    required this.progress,
    required this.scrollExtent,
    required this.frameCount,
    required this.framePath,
    required this.fit,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    this.loader,
    this.strategy,
    this.controller,
  });

  final double progress;
  final double scrollExtent;
  final int frameCount;
  final String framePath;
  final BoxFit fit;
  final ImageProvider? placeholder;
  final LoadingWidgetBuilder? loadingBuilder;
  final FrameChangedCallback? onFrameChanged;
  final int? indexPadWidth;
  final int indexOffset;
  final int maxCacheSize;
  final Widget Function(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  )? builder;
  final double lerpFactor;
  final Curve curve;
  final FrameLoader? loader;
  final PreloadStrategy? strategy;
  final ScrollSequenceController? controller;

  @override
  State<_SliverScrollSequenceContent> createState() =>
      _SliverScrollSequenceContentState();
}

class _SliverScrollSequenceContentState
    extends State<_SliverScrollSequenceContent>
    with SingleTickerProviderStateMixin
    implements ScrollSequenceStateAccessor {
  late FrameLoader _loader;
  late FrameCacheManager _cache;
  late FrameController _frameController;
  late PreloadStrategy _strategy;
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
  bool get isPinned => true;

  /// Not applicable for sliver usage — the sliver header manages its own
  /// scroll offset via [shrinkOffset]. Jump commands on
  /// [ScrollSequenceController] are not supported for [SliverScrollSequence].
  @override
  double get widgetTopOffset => 0;

  @override
  void initState() {
    super.initState();

    _loader = widget.loader ??
        AssetFrameLoader(
          framePath: widget.framePath,
          frameCount: widget.frameCount,
          indexPadWidth: widget.indexPadWidth,
          indexOffset: widget.indexOffset,
        );

    _strategy = widget.strategy ?? const PreloadStrategy.eager();

    _cache = FrameCacheManager(
      maxCacheSize: _strategy
          .maxCacheSize(widget.frameCount)
          .clamp(1, widget.maxCacheSize),
    );
    _frameController = FrameController(
      frameCount: widget.frameCount,
      vsync: this,
      lerpFactor: widget.lerpFactor,
      curve: widget.curve,
    );

    _frameController.addListener(_onFrameChanged);

    // Attach the public controller.
    widget.controller?.attach(
      cacheManager: _cache,
      loader: _loader,
      frameCount: widget.frameCount,
      accessor: this,
    );

    _initialLoad();
  }

  @override
  void didUpdateWidget(covariant _SliverScrollSequenceContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Feed new progress from delegate into the frame controller.
    if (widget.progress != oldWidget.progress) {
      _frameController.updateFromProgress(widget.progress);
    }
  }

  void _onFrameChanged() {
    widget.onFrameChanged?.call(
      _frameController.currentIndex,
      _frameController.progress,
    );

    // Sync state to the public controller.
    widget.controller?.updateState(
      currentFrame: _frameController.currentIndex,
      progress: _frameController.progress,
      loadedCount: _cache.length,
    );

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
      direction: ScrollDirection.idle,
    );
    _totalToLoad = targets.length;
    _loadedCount = 0;

    for (final index in targets) {
      if (!mounted) return;
      await _cache.loadFrame(index, _loader);
      _loadedCount++;
      if (_loadedCount == 1 && mounted) {
        setState(() => _isLoadingFrames = false);
      }
      if (mounted) setState(() {});
    }
    if (mounted) setState(() => _isLoadingFrames = false);

    // Feed initial progress after frames are ready.
    _frameController.updateFromProgress(widget.progress);
  }

  /// Preload frames around current position using strategy.
  Future<void> _preloadAroundCurrent() async {
    if (!mounted) return;
    await _cache.preloadForStrategy(
      currentIndex: _frameController.currentIndex,
      totalFrames: widget.frameCount,
      strategy: _strategy,
      direction: ScrollDirection.idle,
      loader: _loader,
    );
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _frameController.removeListener(_onFrameChanged);
    _frameController.dispose();
    _cache.clearAll();
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      return const SizedBox.expand();
    }

    final frameWidget = FrameDisplay(
      frameIndex: _frameController.currentIndex,
      cacheManager: _cache,
      fit: widget.fit,
    );

    if (widget.builder != null) {
      return widget.builder!(
        context,
        _frameController.currentIndex,
        _frameController.progress,
        frameWidget,
      );
    }

    return frameWidget;
  }
}
