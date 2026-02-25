import 'package:flutter/widgets.dart';

/// Creates a scroll "runway" that pins its child to the viewport while
/// [scrollExtent] pixels of scroll distance are consumed.
///
/// The total height of this widget is `viewportHeight + scrollExtent`.
/// While the user scrolls through the runway:
///
/// - **Pre-pin:** Child scrolls into view normally.
/// - **Pinned:** Child stays fixed at viewport top, progress goes 0.0 to 1.0.
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
  /// the child is pinned. The total widget height is
  /// `viewportHeight + scrollExtent`.
  const PinnedScrollSection({
    required this.scrollExtent,
    required this.child,
    this.onProgressChanged,
    super.key,
  });

  /// Scroll distance in logical pixels consumed while pinned.
  final double scrollExtent;

  /// The child widget to pin at the viewport top.
  final Widget child;

  /// Called when the pin progress changes (0.0 to 1.0).
  final ValueChanged<double>? onProgressChanged;

  @override
  State<PinnedScrollSection> createState() => _PinnedScrollSectionState();
}

class _PinnedScrollSectionState extends State<PinnedScrollSection> {
  ScrollPosition? _scrollPosition;
  double _progress = 0.0;

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
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final totalHeight = viewportHeight + widget.scrollExtent;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          Positioned(
            top: _calculateStickyOffset(viewportHeight),
            left: 0,
            right: 0,
            height: viewportHeight,
            child: widget.child,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  double _calculateStickyOffset(double viewportHeight) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 0;

    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    if (widgetTopInViewport >= 0) {
      // Pre-pin: widget hasn't reached viewport top yet.
      // Child sits at top of SizedBox, scrolls normally.
      return 0;
    }

    // Widget top is above viewport top (negative = scrolled past).
    final scrolledPast = -widgetTopInViewport;

    if (scrolledPast >= widget.scrollExtent) {
      // Post-pin: all scrollExtent consumed.
      // Child offset = scrollExtent, so it sits at the bottom of the
      // SizedBox and scrolls away naturally.
      return widget.scrollExtent;
    }

    // Pinned phase: offset child downward by exactly the amount
    // the SizedBox has scrolled past the viewport top.
    // This keeps the child visually fixed at viewport top.
    return scrolledPast;
  }

  void _updateProgress() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    double newProgress;
    if (widgetTopInViewport >= 0) {
      newProgress = 0.0;
    } else {
      final scrolledPast = -widgetTopInViewport;
      newProgress = (scrolledPast / widget.scrollExtent).clamp(0.0, 1.0);
    }

    if (newProgress != _progress) {
      _progress = newProgress;
      widget.onProgressChanged?.call(_progress);
    }
  }
}
