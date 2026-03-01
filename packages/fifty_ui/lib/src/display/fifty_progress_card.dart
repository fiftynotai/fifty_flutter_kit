import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A progress card for displaying metrics with a progress bar.
///
/// Features:
/// - Slate-grey background per FDL v2
/// - Icon in subtle container
/// - Title with percentage
/// - Gradient progress bar (powder-blush to primary)
/// - Subtitle text
/// - Animated progress changes
///
/// Example:
/// ```dart
/// FiftyProgressCard(
///   icon: Icons.trending_up,
///   title: 'Weekly Goal',
///   progress: 0.75,
///   subtitle: '12 sales remaining to reach target',
/// )
/// ```
class FiftyProgressCard extends StatelessWidget {
  /// Creates a Fifty-styled progress card.
  const FiftyProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.icon,
    this.subtitle,
    this.showPercentage = true,
    this.progressGradient,
  });

  /// The title text displayed next to the icon.
  final String title;

  /// The progress value (0.0 to 1.0).
  ///
  /// Values outside this range are clamped.
  final double progress;

  /// Optional icon displayed in a subtle background container.
  final IconData? icon;

  /// Optional subtitle text displayed below the progress bar.
  final String? subtitle;

  /// Whether to show the percentage value.
  ///
  /// Defaults to true.
  final bool showPercentage;

  /// Custom gradient for the progress bar fill.
  ///
  /// Defaults to a gradient from powder-blush to primary (burgundy).
  final Gradient? progressGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    // Clamp progress to valid range
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentageText = '${(clampedProgress * 100).round()}%';

    // Default gradient: accent to primary (per design)
    final gradient = progressGradient ??
        LinearGradient(
          colors: [fifty?.accent ?? colorScheme.primary, colorScheme.primary],
        );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant,
        borderRadius: FiftyRadii.xxlRadius,
        boxShadow: fifty?.shadowMd ?? FiftyShadows.md,
      ),
      padding: EdgeInsets.all(FiftySpacing.xs),
      child: Container(
        padding: EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + title + percentage
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6), // p-1.5 = 6px
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: FiftyRadii.lgRadius,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: FiftySpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyMedium,
                      fontWeight: FiftyTypography.semiBold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (showPercentage)
                  Text(
                    percentageText,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FiftyTypography.bold,
                      color: fifty?.accent ?? colorScheme.primary,
                    ),
                  ),
              ],
            ),
            SizedBox(height: FiftySpacing.sm),

            // Progress bar
            Container(
              height: 8, // h-2 = 8px
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: FiftyRadii.fullRadius,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: fifty?.fast ?? const Duration(milliseconds: 150),
                        curve: fifty?.standardCurve ?? Curves.easeInOut,
                        width: constraints.maxWidth * clampedProgress,
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: FiftyRadii.fullRadius,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: FiftySpacing.sm),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: 10, // text-[10px]
                  fontWeight: FiftyTypography.regular,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
