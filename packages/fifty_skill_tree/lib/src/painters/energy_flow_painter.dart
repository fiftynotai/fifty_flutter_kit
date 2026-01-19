import 'package:flutter/rendering.dart';

/// A custom painter that draws animated particles flowing along a connection.
///
/// Creates an effect of energy or data flowing between connected nodes,
/// useful for indicating active connections or data transfer.
///
/// **Example:**
/// ```dart
/// // In a StatefulWidget with AnimationController
/// CustomPaint(
///   painter: EnergyFlowPainter(
///     from: Offset(0, 0),
///     to: Offset(100, 100),
///     progress: animationController.value,
///     color: Colors.cyan,
///     particleCount: 5,
///   ),
/// )
/// ```
class EnergyFlowPainter extends CustomPainter {
  /// Creates an energy flow painter.
  ///
  /// **Parameters:**
  /// - [from]: Starting point of the flow
  /// - [to]: Ending point of the flow
  /// - [progress]: Animation progress from 0.0 to 1.0 (loops)
  /// - [color]: Color of the particles
  /// - [particleCount]: Number of particles in the flow
  /// - [particleSize]: Size of each particle
  /// - [trailLength]: Length of the particle trails
  /// - [showGlow]: Whether to show glow effect on particles
  EnergyFlowPainter({
    required this.from,
    required this.to,
    required this.progress,
    required this.color,
    this.particleCount = 5,
    this.particleSize = 3.0,
    this.trailLength = 0.15,
    this.showGlow = true,
  });

  /// Starting point of the flow.
  final Offset from;

  /// Ending point of the flow.
  final Offset to;

  /// Animation progress from 0.0 to 1.0.
  final double progress;

  /// Color of the particles.
  final Color color;

  /// Number of particles in the flow.
  final int particleCount;

  /// Size of each particle.
  final double particleSize;

  /// Length of the particle trails (0.0 to 1.0 of total path).
  final double trailLength;

  /// Whether to show glow effect on particles.
  final bool showGlow;

  @override
  void paint(Canvas canvas, Size size) {
    if (particleCount <= 0) return;

    final direction = to - from;
    final distance = direction.distance;

    if (distance == 0) return;

    final normalized = direction / distance;

    // Draw each particle
    for (int i = 0; i < particleCount; i++) {
      // Calculate particle position based on progress and offset
      final particleOffset = i / particleCount;
      final particleProgress = (progress + particleOffset) % 1.0;

      // Calculate position along the line
      final position = from + normalized * (distance * particleProgress);

      // Calculate trail
      final trailStart = (particleProgress - trailLength).clamp(0.0, 1.0);
      final trailStartPos = from + normalized * (distance * trailStart);

      // Draw trail
      if (particleProgress > trailLength) {
        _drawTrail(canvas, trailStartPos, position);
      } else if (particleProgress > 0) {
        // Trail wraps around
        _drawTrail(canvas, from, position);
      }

      // Draw particle
      _drawParticle(canvas, position);
    }
  }

  /// Draws a trail from start to end with gradient opacity.
  void _drawTrail(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withAlpha(0),
          color.withAlpha(128),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromPoints(start, end))
      ..style = PaintingStyle.stroke
      ..strokeWidth = particleSize * 0.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);
  }

  /// Draws a single particle at the given position.
  void _drawParticle(Canvas canvas, Offset position) {
    // Glow effect
    if (showGlow) {
      final glowPaint = Paint()
        ..color = color.withAlpha(64)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize * 2);

      canvas.drawCircle(position, particleSize * 2, glowPaint);
    }

    // Main particle
    final particlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, particleSize, particlePaint);

    // Core highlight
    final highlightPaint = Paint()
      ..color = color.withAlpha(255)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, particleSize * 0.5, highlightPaint);
  }

  @override
  bool shouldRepaint(EnergyFlowPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        particleCount != oldDelegate.particleCount;
  }
}

/// A custom painter that draws energy flow along a bezier curve.
///
/// Similar to [EnergyFlowPainter] but follows a curved path.
class EnergyFlowBezierPainter extends CustomPainter {
  /// Creates an energy flow bezier painter.
  EnergyFlowBezierPainter({
    required this.from,
    required this.to,
    required this.progress,
    required this.color,
    this.particleCount = 5,
    this.particleSize = 3.0,
    this.trailLength = 0.15,
    this.showGlow = true,
    this.curvature = 0.5,
  });

  /// Starting point of the flow.
  final Offset from;

  /// Ending point of the flow.
  final Offset to;

  /// Animation progress from 0.0 to 1.0.
  final double progress;

  /// Color of the particles.
  final Color color;

  /// Number of particles in the flow.
  final int particleCount;

  /// Size of each particle.
  final double particleSize;

  /// Length of the particle trails.
  final double trailLength;

  /// Whether to show glow effect on particles.
  final bool showGlow;

  /// How curved the bezier is.
  final double curvature;

  @override
  void paint(Canvas canvas, Size size) {
    if (particleCount <= 0) return;

    // Calculate control points for bezier
    final midX = (from.dx + to.dx) / 2;
    final controlOffset = curvature * 0.5 * ((to.dx - from.dx).abs() + (to.dy - from.dy).abs());

    final control1 = Offset(midX, from.dy + controlOffset * 0.5);
    final control2 = Offset(midX, to.dy - controlOffset * 0.5);

    // Draw each particle
    for (int i = 0; i < particleCount; i++) {
      final particleOffset = i / particleCount;
      final particleProgress = (progress + particleOffset) % 1.0;

      // Get position on bezier curve
      final position = _getPointOnBezier(
        from,
        control1,
        control2,
        to,
        particleProgress,
      );

      // Draw trail
      if (trailLength > 0) {
        final trailPoints = <Offset>[];
        const steps = 8;
        for (int j = 0; j <= steps; j++) {
          final t = particleProgress - (trailLength * j / steps);
          if (t >= 0) {
            trailPoints.add(_getPointOnBezier(from, control1, control2, to, t));
          }
        }
        if (trailPoints.length > 1) {
          _drawTrail(canvas, trailPoints);
        }
      }

      // Draw particle
      _drawParticle(canvas, position);
    }
  }

  /// Gets a point on a cubic bezier curve at parameter t.
  Offset _getPointOnBezier(
    Offset p0,
    Offset p1,
    Offset p2,
    Offset p3,
    double t,
  ) {
    final t2 = t * t;
    final t3 = t2 * t;
    final mt = 1 - t;
    final mt2 = mt * mt;
    final mt3 = mt2 * mt;

    return Offset(
      mt3 * p0.dx + 3 * mt2 * t * p1.dx + 3 * mt * t2 * p2.dx + t3 * p3.dx,
      mt3 * p0.dy + 3 * mt2 * t * p1.dy + 3 * mt * t2 * p2.dy + t3 * p3.dy,
    );
  }

  /// Draws a trail from a list of points.
  void _drawTrail(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color,
          color.withAlpha(0),
        ],
      ).createShader(Rect.fromPoints(points.first, points.last))
      ..style = PaintingStyle.stroke
      ..strokeWidth = particleSize * 0.8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  /// Draws a single particle at the given position.
  void _drawParticle(Canvas canvas, Offset position) {
    if (showGlow) {
      final glowPaint = Paint()
        ..color = color.withAlpha(64)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particleSize * 2);

      canvas.drawCircle(position, particleSize * 2, glowPaint);
    }

    final particlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, particleSize, particlePaint);

    final highlightPaint = Paint()
      ..color = color.withAlpha(255)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, particleSize * 0.5, highlightPaint);
  }

  @override
  bool shouldRepaint(EnergyFlowBezierPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        from != oldDelegate.from ||
        to != oldDelegate.to ||
        color != oldDelegate.color ||
        particleCount != oldDelegate.particleCount;
  }
}
