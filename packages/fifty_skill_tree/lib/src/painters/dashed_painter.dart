import 'package:flutter/rendering.dart';

/// A custom painter that draws a dashed line between two points.
///
/// Used for drawing connections between locked nodes or indicating
/// optional/conditional relationships.
///
/// **Example:**
/// ```dart
/// CustomPaint(
///   painter: DashedLinePainter(
///     from: Offset(0, 0),
///     to: Offset(100, 100),
///     color: Colors.grey,
///     thickness: 2,
///     dashLength: 8,
///     gapLength: 4,
///   ),
/// )
/// ```
class DashedLinePainter extends CustomPainter {
  /// Creates a dashed line painter.
  ///
  /// **Parameters:**
  /// - [from]: Starting point of the line
  /// - [to]: Ending point of the line
  /// - [color]: Color of the dashes
  /// - [thickness]: Width of the line stroke
  /// - [dashLength]: Length of each dash in pixels
  /// - [gapLength]: Length of each gap in pixels
  /// - [strokeCap]: Style of the dash ends (default round)
  DashedLinePainter({
    required this.from,
    required this.to,
    required this.color,
    this.thickness = 2.0,
    this.dashLength = 8.0,
    this.gapLength = 4.0,
    this.strokeCap = StrokeCap.round,
  });

  /// Starting point of the line.
  final Offset from;

  /// Ending point of the line.
  final Offset to;

  /// Color of the dashes.
  final Color color;

  /// Width of the line stroke.
  final double thickness;

  /// Length of each dash in pixels.
  final double dashLength;

  /// Length of each gap in pixels.
  final double gapLength;

  /// Style of the dash ends.
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = strokeCap;

    final direction = to - from;
    final distance = direction.distance;

    if (distance == 0) return;

    final normalized = direction / distance;
    final dashWithGap = dashLength + gapLength;

    double currentDistance = 0;

    while (currentDistance < distance) {
      final dashEnd = (currentDistance + dashLength).clamp(0.0, distance);

      final startPoint = from + normalized * currentDistance;
      final endPoint = from + normalized * dashEnd;

      canvas.drawLine(startPoint, endPoint, paint);

      currentDistance += dashWithGap;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength;
  }
}

/// A custom painter that draws a dashed bezier curve between two points.
///
/// Similar to [DashedLinePainter] but with a curved path.
///
/// **Example:**
/// ```dart
/// CustomPaint(
///   painter: DashedBezierPainter(
///     from: Offset(0, 0),
///     to: Offset(100, 100),
///     color: Colors.grey,
///     thickness: 2,
///   ),
/// )
/// ```
class DashedBezierPainter extends CustomPainter {
  /// Creates a dashed bezier painter.
  DashedBezierPainter({
    required this.from,
    required this.to,
    required this.color,
    this.thickness = 2.0,
    this.dashLength = 8.0,
    this.gapLength = 4.0,
    this.curvature = 0.5,
  });

  /// Starting point of the curve.
  final Offset from;

  /// Ending point of the curve.
  final Offset to;

  /// Color of the dashes.
  final Color color;

  /// Width of the line stroke.
  final double thickness;

  /// Length of each dash in pixels.
  final double dashLength;

  /// Length of each gap in pixels.
  final double gapLength;

  /// How curved the bezier is (0.0 = straight, 1.0 = very curved).
  final double curvature;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    // Calculate control points for bezier
    final midX = (from.dx + to.dx) / 2;

    // Offset control point perpendicular to the line
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final controlOffset = curvature * 0.5 * (dx.abs() + dy.abs());

    // Control point offset in y direction for vertical-ish curves
    final control1 = Offset(midX, from.dy + controlOffset * 0.5);
    final control2 = Offset(midX, to.dy - controlOffset * 0.5);

    // Create the bezier path
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        to.dx,
        to.dy,
      );

    // Calculate path metrics for dashing
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      final pathLength = metric.length;
      double distance = 0;

      while (distance < pathLength) {
        final dashEnd = (distance + dashLength).clamp(0.0, pathLength);
        final extractedPath = metric.extractPath(distance, dashEnd);

        canvas.drawPath(extractedPath, paint);

        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBezierPainter oldDelegate) {
    return from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        dashLength != oldDelegate.dashLength ||
        gapLength != oldDelegate.gapLength ||
        curvature != oldDelegate.curvature;
  }
}
