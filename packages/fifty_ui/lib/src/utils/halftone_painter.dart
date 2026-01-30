import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A CustomPainter that draws a halftone dot pattern.
///
/// Creates a repeatable pattern of dots at 5% opacity, suitable for
/// adding subtle texture to surfaces without requiring image assets.
///
/// **Note:** Since this is a CustomPainter without BuildContext access,
/// consumers should pass theme-appropriate colors from their widget:
/// ```dart
/// final colorScheme = Theme.of(context).colorScheme;
/// CustomPaint(
///   painter: HalftonePainter(
///     color: colorScheme.onSurface,
///     dotRadius: 1.5,
///     spacing: 8.0,
///   ),
///   child: Container(),
/// )
/// ```
class HalftonePainter extends CustomPainter {
  /// Creates a halftone pattern painter.
  ///
  /// The [color] parameter defaults to [FiftyColors.cream] for backwards
  /// compatibility. For theme-aware usage, pass `colorScheme.onSurface`
  /// or another appropriate theme color from your widget's build method.
  const HalftonePainter({
    this.color = FiftyColors.cream,
    this.dotRadius = 1.0,
    this.spacing = 8.0,
    this.opacity = 0.05,
  });

  /// The color of the halftone dots.
  ///
  /// Defaults to [FiftyColors.cream]. For theme-aware usage, pass
  /// `colorScheme.onSurface` from your widget's build method.
  final Color color;

  /// The radius of each dot.
  ///
  /// Defaults to 1.0 pixel.
  final double dotRadius;

  /// The spacing between dots.
  ///
  /// Defaults to 8.0 pixels.
  final double spacing;

  /// The opacity of the dots.
  ///
  /// Defaults to 0.05 (5% opacity).
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Draw dots in a grid pattern
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(HalftonePainter oldDelegate) {
    return color != oldDelegate.color ||
        dotRadius != oldDelegate.dotRadius ||
        spacing != oldDelegate.spacing ||
        opacity != oldDelegate.opacity;
  }
}

/// A widget that displays a halftone texture overlay.
///
/// Convenience widget wrapping [HalftonePainter].
///
/// When [color] is not specified, it automatically uses `colorScheme.onSurface`
/// for theme-aware coloring.
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     Container(color: Colors.black),
///     HalftoneOverlay(), // Uses theme color automatically
///   ],
/// )
/// ```
class HalftoneOverlay extends StatelessWidget {
  /// Creates a halftone overlay widget.
  ///
  /// If [color] is null, uses `colorScheme.onSurface` from the current theme.
  const HalftoneOverlay({
    super.key,
    this.color,
    this.dotRadius = 1.0,
    this.spacing = 8.0,
    this.opacity = 0.05,
  });

  /// The color of the halftone dots.
  ///
  /// If null, uses `colorScheme.onSurface` from the current theme.
  final Color? color;

  /// The radius of each dot.
  final double dotRadius;

  /// The spacing between dots.
  final double spacing;

  /// The opacity of the dots.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    return CustomPaint(
      painter: HalftonePainter(
        color: effectiveColor,
        dotRadius: dotRadius,
        spacing: spacing,
        opacity: opacity,
      ),
      size: Size.infinite,
    );
  }
}
