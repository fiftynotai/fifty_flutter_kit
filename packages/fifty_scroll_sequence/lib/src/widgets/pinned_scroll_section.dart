import 'package:flutter/widgets.dart';

/// Creates a scroll "runway" that pins its child to the viewport while
/// [scrollExtent] pixels of scroll distance are consumed.
///
/// The total size of this widget along the scroll axis is
/// `viewportDimension + scrollExtent`. While the user scrolls through the
/// runway:
///
/// - **Pre-pin:** Child scrolls into view normally.
/// - **Pinned:** Child stays fixed at the viewport leading edge,
///   progress goes 0.0 to 1.0.
/// - **Post-pin:** Child scrolls away normally.
///
/// Reports progress (0.0 to 1.0) through the [onProgressChanged] callback.
///
/// ## Usage
///
/// Place inside any scrollable ancestor (e.g. [SingleChildScrollView],
/// [CustomScrollView]). The widget listens to the ancestor's scroll
/// position via [Scrollable.maybeOf].
///
/// ```dart
/// SingleChildScrollView(
///   child: Column(
///     children: [
///       const SizedBox(height: 500),
///       PinnedScrollSection(
///         scrollExtent: 3000,
///         onProgressChanged: (progress) {
///           print('Pin progress: $progress');
///         },
///         child: Container(color: Colors.blue),
///       ),
///       const SizedBox(height: 500),
///     ],
///   ),
/// )
/// ```
class PinnedScrollSection extends StatefulWidget {
  /// Creates a [PinnedScrollSection] with the given [scrollExtent].
  ///
  /// [scrollExtent] is the number of scroll pixels consumed while
  /// the child is pinned. The total size along the scroll axis is
  /// `viewportDimension + scrollExtent`.
  ///
  /// [scrollDirection] controls the pinning axis. Defaults to
  /// [Axis.vertical] (pin at top, scroll height). When [Axis.horizontal],
  /// the widget pins at the left edge and uses width-based layout.
  const PinnedScrollSection({
    required this.scrollExtent,
    required this.child,
    this.onProgressChanged,
    this.scrollDirection = Axis.vertical,
    super.key,
  });

  /// Scroll distance in logical pixels consumed while pinned.
  final double scrollExtent;

  /// The child widget to pin at the viewport leading edge.
  final Widget child;

  /// Called when the pin progress changes (0.0 to 1.0).
  final ValueChanged<double>? onProgressChanged;

  /// The scroll axis for pinning.
  ///
  /// Defaults to [Axis.vertical]. When [Axis.horizontal], the widget pins
  /// at the left edge and sizes itself using viewport width.
  final Axis scrollDirection;

  @override
  State<PinnedScrollSection> createState() => _PinnedScrollSectionState();
}

class _PinnedScrollSectionState extends State<PinnedScrollSection> {
  ScrollPosition? _scrollPosition;
  double _progress = 0.0;

  bool get _isVertical => widget.scrollDirection == Axis.vertical;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to the ancestor scrollable's position.
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = Scrollable.maybeOf(context)?.position;
    _scrollPosition?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    _updateProgress();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewportDimension = _viewportDimension(context);
    final totalSize = viewportDimension + widget.scrollExtent;
    final stickyOffset = _calculateStickyOffset(viewportDimension);

    if (_isVertical) {
      return SizedBox(
        height: totalSize,
        child: Stack(
          children: [
            Positioned(
              top: stickyOffset,
              left: 0,
              right: 0,
              height: viewportDimension,
              child: widget.child,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: totalSize,
      child: Stack(
        children: [
          Positioned(
            left: stickyOffset,
            top: 0,
            bottom: 0,
            width: viewportDimension,
            child: widget.child,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Returns the viewport dimension for the configured scroll direction.
  double _viewportDimension(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return _isVertical ? size.height : size.width;
  }

  /// Returns the leading-edge offset of this widget in the viewport.
  double _leadingEdgeInViewport() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 0;
    final globalOffset = renderBox.localToGlobal(Offset.zero);
    return _isVertical ? globalOffset.dy : globalOffset.dx;
  }

  double _calculateStickyOffset(double viewportDimension) {
    final leadingEdge = _leadingEdgeInViewport();

    if (leadingEdge >= 0) {
      // Pre-pin: widget hasn't reached the viewport leading edge yet.
      // Child sits at start of SizedBox, scrolls normally.
      return 0;
    }

    // Widget leading edge is past viewport leading edge (negative = scrolled past).
    final scrolledPast = -leadingEdge;

    if (scrolledPast >= widget.scrollExtent) {
      // Post-pin: all scrollExtent consumed.
      // Child offset = scrollExtent, so it sits at the trailing end of the
      // SizedBox and scrolls away naturally.
      return widget.scrollExtent;
    }

    // Pinned phase: offset child by exactly the amount the SizedBox has
    // scrolled past the viewport leading edge. This keeps the child visually
    // fixed at the viewport leading edge.
    return scrolledPast;
  }

  void _updateProgress() {
    final leadingEdge = _leadingEdgeInViewport();

    double newProgress;
    if (leadingEdge >= 0) {
      newProgress = 0.0;
    } else {
      final scrolledPast = -leadingEdge;
      newProgress = (scrolledPast / widget.scrollExtent).clamp(0.0, 1.0);
    }

    if (newProgress != _progress) {
      _progress = newProgress;
      widget.onProgressChanged?.call(_progress);
    }
  }
}
