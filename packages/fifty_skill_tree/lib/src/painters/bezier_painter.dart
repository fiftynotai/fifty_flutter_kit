import 'package:flutter/rendering.dart';

import '../models/models.dart';

/// Curved bezier connection painter.
///
/// Uses quadratic bezier curves to create smooth, curved connections
/// between nodes. Control points are calculated based on the direction
/// of the connection (vertical vs horizontal dominant).
///
/// **Example:**
/// ```dart
/// final painter = BezierPainter(
///   from: Offset(100, 100),
///   to: Offset(200, 300),
///   color: Colors.green,
///   thickness: 2.0,
///   style: ConnectionStyle.solid,
/// );
/// ```
class BezierPainter extends CustomPainter {
  /// Creates a bezier painter.
  ///
  /// **Parameters:**
  /// - [from]: Starting point of the curve
  /// - [to]: Ending point of the curve
  /// - [color]: Color of the curve
  /// - [thickness]: Width of the stroke
  /// - [style]: Visual style (solid, dashed, animated)
  /// - [curveFactor]: How much the curve bends (0.0-1.0), defaults to 0.5
  const BezierPainter({
    required this.from,
    required this.to,
    required this.color,
    this.thickness = 2.0,
    this.style = ConnectionStyle.solid,
    this.curveFactor = 0.5,
  });

  /// Starting point of the curve.
  final Offset from;

  /// Ending point of the curve.
  final Offset to;

  /// Color of the curve.
  final Color color;

  /// Width of the stroke.
  final double thickness;

  /// Visual style for the curve.
  final ConnectionStyle style;

  /// How much the curve bends (0.0-1.0).
  ///
  /// 0.0 = straight line, 1.0 = maximum curve.
  final double curveFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = _createBezierPath();

    switch (style) {
      case ConnectionStyle.solid:
        canvas.drawPath(path, paint);
      case ConnectionStyle.dashed:
        _drawDashedPath(canvas, path, paint);
      case ConnectionStyle.animated:
        // Animated style draws solid for now
        // Animation should be handled at a higher level
        canvas.drawPath(path, paint);
    }
  }

  /// Creates a quadratic bezier path between from and to points.
  Path _createBezierPath() {
    final path = Path();
    path.moveTo(from.dx, from.dy);

    // Calculate control point based on direction
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;

    Offset controlPoint;

    // Determine if connection is more vertical or horizontal
    if (dy.abs() > dx.abs()) {
      // Vertical dominant - control point creates horizontal bulge
      final midY = from.dy + dy / 2;
      controlPoint = Offset(from.dx + dx * curveFactor, midY);
    } else {
      // Horizontal dominant - control point creates vertical bulge
      final midX = from.dx + dx / 2;
      controlPoint = Offset(midX, from.dy + dy * curveFactor);
    }

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      to.dx,
      to.dy,
    );

    return path;
  }

  /// Draws a dashed version of the bezier path.
  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;

    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      bool drawing = true;

      while (distance < metric.length) {
        final segmentLength = drawing ? dashWidth : dashSpace;
        final remainingLength = metric.length - distance;
        final actualLength = segmentLength < remainingLength
            ? segmentLength
            : remainingLength;

        if (drawing) {
          final segment = metric.extractPath(distance, distance + actualLength);
          canvas.drawPath(segment, paint);
        }

        distance += actualLength;
        drawing = !drawing;
      }
    }
  }

  @override
  bool shouldRepaint(BezierPainter oldDelegate) {
    return from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        style != oldDelegate.style ||
        curveFactor != oldDelegate.curveFactor;
  }
}
