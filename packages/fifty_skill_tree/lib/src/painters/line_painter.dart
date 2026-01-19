import 'package:flutter/rendering.dart';

import '../models/models.dart';

/// Simple straight line painter for connections.
///
/// Draws a line from source node edge to target node edge.
/// Supports solid and dashed line styles.
///
/// **Example:**
/// ```dart
/// final painter = LinePainter(
///   from: Offset(100, 100),
///   to: Offset(200, 200),
///   color: Colors.green,
///   thickness: 2.0,
///   style: ConnectionStyle.solid,
/// );
/// ```
class LinePainter extends CustomPainter {
  /// Creates a line painter.
  ///
  /// **Parameters:**
  /// - [from]: Starting point of the line
  /// - [to]: Ending point of the line
  /// - [color]: Color of the line
  /// - [thickness]: Width of the line stroke
  /// - [style]: Visual style (solid, dashed, animated)
  const LinePainter({
    required this.from,
    required this.to,
    required this.color,
    this.thickness = 2.0,
    this.style = ConnectionStyle.solid,
  });

  /// Starting point of the line.
  final Offset from;

  /// Ending point of the line.
  final Offset to;

  /// Color of the line.
  final Color color;

  /// Width of the line stroke.
  final double thickness;

  /// Visual style for the line.
  final ConnectionStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (style) {
      case ConnectionStyle.solid:
        canvas.drawLine(from, to, paint);
      case ConnectionStyle.dashed:
        _drawDashedLine(canvas, from, to, paint);
      case ConnectionStyle.animated:
        // Animated style draws solid for now
        // Animation should be handled at a higher level
        canvas.drawLine(from, to, paint);
    }
  }

  /// Draws a dashed line between two points.
  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;

    final direction = to - from;
    final distance = direction.distance;

    if (distance == 0) return;

    final normalized = direction / distance;

    double currentDistance = 0;
    bool drawing = true;

    while (currentDistance < distance) {
      final segmentLength = drawing ? dashWidth : dashSpace;
      final remainingDistance = distance - currentDistance;
      final actualLength =
          segmentLength < remainingDistance ? segmentLength : remainingDistance;

      if (drawing) {
        final start = from + normalized * currentDistance;
        final end = from + normalized * (currentDistance + actualLength);
        canvas.drawLine(start, end, paint);
      }

      currentDistance += actualLength;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        style != oldDelegate.style;
  }
}
