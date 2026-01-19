import 'package:flutter/material.dart';

/// A custom painter that draws an animated highlight along a path.
///
/// The highlight traces along the given path points as the [progress]
/// value animates from 0.0 to 1.0.
///
/// **Example:**
/// ```dart
/// CustomPaint(
///   painter: PathHighlightPainter(
///     path: [Offset(0, 0), Offset(100, 50), Offset(200, 100)],
///     progress: animationController.value,
///     color: Colors.amber,
///     width: 4,
///   ),
/// )
/// ```
class PathHighlightPainter extends CustomPainter {
  /// Creates a path highlight painter.
  ///
  /// **Parameters:**
  /// - [path]: List of points defining the path
  /// - [progress]: Animation progress from 0.0 to 1.0
  /// - [color]: Color of the highlight
  /// - [width]: Width of the highlight stroke
  /// - [glowRadius]: Radius of the glow effect (default 8)
  /// - [showGlow]: Whether to show glow effect (default true)
  PathHighlightPainter({
    required this.path,
    required this.progress,
    required this.color,
    required this.width,
    this.glowRadius = 8.0,
    this.showGlow = true,
  });

  /// List of points defining the path.
  final List<Offset> path;

  /// Animation progress from 0.0 to 1.0.
  final double progress;

  /// Color of the highlight.
  final Color color;

  /// Width of the highlight stroke.
  final double width;

  /// Radius of the glow effect.
  final double glowRadius;

  /// Whether to show glow effect.
  final bool showGlow;

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2 || progress <= 0) return;

    // Calculate total path length
    double totalLength = 0;
    final segmentLengths = <double>[];

    for (int i = 0; i < path.length - 1; i++) {
      final length = (path[i + 1] - path[i]).distance;
      segmentLengths.add(length);
      totalLength += length;
    }

    if (totalLength == 0) return;

    // Calculate how far to draw based on progress
    final targetLength = totalLength * progress;

    // Build the path up to the target length
    final highlightPath = Path();
    highlightPath.moveTo(path[0].dx, path[0].dy);

    double accumulatedLength = 0;
    for (int i = 0; i < path.length - 1; i++) {
      final segmentLength = segmentLengths[i];
      final segmentEnd = accumulatedLength + segmentLength;

      if (targetLength >= segmentEnd) {
        // Draw full segment
        highlightPath.lineTo(path[i + 1].dx, path[i + 1].dy);
        accumulatedLength = segmentEnd;
      } else {
        // Draw partial segment
        final remainingLength = targetLength - accumulatedLength;
        final ratio = remainingLength / segmentLength;
        final partialPoint = Offset.lerp(path[i], path[i + 1], ratio)!;
        highlightPath.lineTo(partialPoint.dx, partialPoint.dy);
        break;
      }
    }

    // Draw glow effect first (behind main stroke)
    if (showGlow && glowRadius > 0) {
      final glowPaint = Paint()
        ..color = color.withAlpha(64)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + glowRadius
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius / 2);

      canvas.drawPath(highlightPath, glowPaint);
    }

    // Draw main highlight stroke
    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(highlightPath, mainPaint);

    // Draw leading dot at the current position
    if (progress > 0 && progress < 1) {
      final dotPosition = _getPositionAtProgress(progress);
      if (dotPosition != null) {
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(dotPosition, width * 1.5, dotPaint);

        // Dot glow
        if (showGlow) {
          final dotGlowPaint = Paint()
            ..color = color.withAlpha(128)
            ..style = PaintingStyle.fill
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

          canvas.drawCircle(dotPosition, width * 2, dotGlowPaint);
        }
      }
    }
  }

  /// Gets the position at a given progress value.
  Offset? _getPositionAtProgress(double progress) {
    if (path.length < 2) return null;

    double totalLength = 0;
    for (int i = 0; i < path.length - 1; i++) {
      totalLength += (path[i + 1] - path[i]).distance;
    }

    final targetLength = totalLength * progress;
    double accumulatedLength = 0;

    for (int i = 0; i < path.length - 1; i++) {
      final segmentLength = (path[i + 1] - path[i]).distance;
      final segmentEnd = accumulatedLength + segmentLength;

      if (targetLength <= segmentEnd) {
        final remainingLength = targetLength - accumulatedLength;
        final ratio = segmentLength > 0 ? remainingLength / segmentLength : 0.0;
        return Offset.lerp(path[i], path[i + 1], ratio);
      }

      accumulatedLength = segmentEnd;
    }

    return path.last;
  }

  @override
  bool shouldRepaint(PathHighlightPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        width != oldDelegate.width ||
        path != oldDelegate.path;
  }
}

/// A widget that animates a path highlight effect.
///
/// Automatically animates the [PathHighlightPainter] from 0 to 1.
///
/// **Example:**
/// ```dart
/// AnimatedPathHighlight(
///   path: [Offset(0, 0), Offset(100, 50), Offset(200, 100)],
///   color: Colors.amber,
///   width: 4,
///   duration: Duration(seconds: 1),
///   onComplete: () => print('Path animation complete'),
/// )
/// ```
class AnimatedPathHighlight extends StatefulWidget {
  /// Creates an animated path highlight widget.
  const AnimatedPathHighlight({
    super.key,
    required this.path,
    required this.color,
    required this.width,
    this.duration = const Duration(milliseconds: 800),
    this.glowRadius = 8.0,
    this.showGlow = true,
    this.onComplete,
    this.repeat = false,
  });

  /// List of points defining the path.
  final List<Offset> path;

  /// Color of the highlight.
  final Color color;

  /// Width of the highlight stroke.
  final double width;

  /// Animation duration.
  final Duration duration;

  /// Radius of the glow effect.
  final double glowRadius;

  /// Whether to show glow effect.
  final bool showGlow;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  /// Whether to repeat the animation.
  final bool repeat;

  @override
  State<AnimatedPathHighlight> createState() => _AnimatedPathHighlightState();
}

class _AnimatedPathHighlightState extends State<AnimatedPathHighlight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward().then((_) {
        widget.onComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: PathHighlightPainter(
            path: widget.path,
            progress: _controller.value,
            color: widget.color,
            width: widget.width,
            glowRadius: widget.glowRadius,
            showGlow: widget.showGlow,
          ),
        );
      },
    );
  }
}
