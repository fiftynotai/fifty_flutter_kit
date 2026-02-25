/// Calculates normalized scroll progress (0.0 to 1.0) for non-pinned mode.
///
/// Progress is viewport-relative, meaning the animation plays while
/// the widget is in view, regardless of where it sits in the scroll list.
///
/// ## Progress Model
///
/// - **0.0** = widget top enters viewport bottom
/// - **1.0** = widget has scrolled [scrollExtent] pixels past the viewport top
///
/// ## Example
///
/// ```dart
/// final tracker = ScrollProgressTracker(scrollExtent: 3000);
///
/// final progress = tracker.calculateProgress(
///   widgetTopInViewport: 400,
///   viewportHeight: 800,
/// );
/// ```
class ScrollProgressTracker {
  /// Creates a [ScrollProgressTracker] for the given [scrollExtent].
  ScrollProgressTracker({required this.scrollExtent});

  /// Total scroll distance over which the sequence plays.
  final double scrollExtent;

  /// Calculate normalized progress (0.0 to 1.0) for non-pinned mode.
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
