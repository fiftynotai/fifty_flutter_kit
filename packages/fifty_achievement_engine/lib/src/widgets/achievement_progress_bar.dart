import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A progress bar widget for displaying achievement completion progress.
///
/// Consumes FDL tokens directly for consistent styling.
/// Provides optional color overrides for customization.
///
/// **Example:**
/// ```dart
/// AchievementProgressBar(
///   progress: 0.75,
///   height: 8,
/// )
/// ```
class AchievementProgressBar extends StatelessWidget {
  /// Creates an achievement progress bar.
  const AchievementProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.showLabel = false,
    this.labelStyle,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Background color of the progress track.
  ///
  /// Defaults to FDL surfaceDark with opacity.
  final Color? backgroundColor;

  /// Foreground color of the progress indicator.
  ///
  /// Defaults to FDL burgundy.
  final Color? foregroundColor;

  /// Border radius of the progress bar.
  ///
  /// Defaults to FDL smRadius.
  final BorderRadius? borderRadius;

  /// Whether to show a percentage label.
  final bool showLabel;

  /// Style for the percentage label.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final radius = borderRadius ?? FiftyRadii.smRadius;
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final fgColor = foregroundColor ?? FiftyColors.burgundy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: FiftyMotion.compiling,
                      curve: FiftyMotion.standard,
                      width: constraints.maxWidth * clampedProgress,
                      height: height,
                      decoration: BoxDecoration(
                        color: fgColor,
                        borderRadius: radius,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: FiftySpacing.xs),
          Text(
            '${(clampedProgress * 100).toStringAsFixed(0)}%',
            style: labelStyle ??
                TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.medium,
                  color: FiftyColors.cream.withValues(alpha: 0.7),
                ),
          ),
        ],
      ],
    );
  }
}
