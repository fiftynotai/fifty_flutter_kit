import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A linear progress bar with FDL v2 styling.
///
/// Features:
/// - Primary fill color matching FDL brand
/// - Animated value transitions
/// - Optional label and percentage display
/// - Mode-aware track background
/// - Manrope font family
///
/// Example:
/// ```dart
/// FiftyProgressBar(
///   value: 0.65,
///   label: 'UPLOADING',
///   showPercentage: true,
/// )
/// ```
class FiftyProgressBar extends StatelessWidget {
  /// Creates a Fifty-styled progress bar.
  const FiftyProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercentage = false,
    this.height = 8,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The progress value between 0.0 and 1.0.
  final double value;

  /// Optional label displayed above the progress bar.
  final String? label;

  /// Whether to display the percentage value.
  final bool showPercentage;

  /// The height of the progress bar.
  final double height;

  /// The background (track) color.
  ///
  /// Defaults to mode-aware surface color.
  final Color? backgroundColor;

  /// The foreground (fill) color.
  ///
  /// Defaults to the primary color (burgundy).
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight);
    final effectiveForegroundColor = foregroundColor ?? colorScheme.primary;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    final labelColor = isDark ? FiftyColors.slateGrey : Colors.grey[600];
    final clampedValue = value.clamp(0.0, 1.0);
    final percentage = (clampedValue * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FiftyTypography.medium,
                    color: labelColor,
                    letterSpacing: FiftyTypography.letterSpacingLabel,
                  ),
                ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.onSurface,
                  ),
                ),
            ],
          ),
          const SizedBox(height: FiftySpacing.sm),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: borderColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: fifty.fast,
                    curve: fifty.standardCurve,
                    width: constraints.maxWidth * clampedValue,
                    height: height,
                    decoration: BoxDecoration(
                      color: effectiveForegroundColor,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
