import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A pulsing circular loading indicator with FDL styling.
///
/// Features:
/// - Crimson color matching FDL brand
/// - Respects reduce motion accessibility settings
/// - Customizable size and stroke width
///
/// Example:
/// ```dart
/// FiftyLoadingIndicator(
///   size: 32,
///   strokeWidth: 3,
/// )
/// ```
class FiftyLoadingIndicator extends StatelessWidget {
  /// Creates a Fifty-styled loading indicator.
  const FiftyLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
  });

  /// The diameter of the indicator.
  final double size;

  /// The width of the circular stroke.
  final double strokeWidth;

  /// The color of the indicator.
  ///
  /// Defaults to [FiftyColors.crimsonPulse].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? FiftyColors.crimsonPulse;

    // Check for reduced motion preference
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (reduceMotion) {
      // Static indicator for reduced motion
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _StaticIndicatorPainter(
            color: effectiveColor,
            strokeWidth: strokeWidth,
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation(effectiveColor),
      ),
    );
  }
}

class _StaticIndicatorPainter extends CustomPainter {
  _StaticIndicatorPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw a 270-degree arc for static representation
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5 * 3.14159, // Start at top
      1.5 * 3.14159, // 270 degrees
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _StaticIndicatorPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
