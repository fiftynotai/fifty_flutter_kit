import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Trend direction for stat cards.
enum FiftyStatTrend {
  /// Positive trend (arrow up, green).
  up,

  /// Negative trend (arrow down, red).
  down,

  /// No change (horizontal line, grey).
  neutral,
}

/// A metric/stat card for displaying KPIs with trend indicators.
///
/// Features:
/// - Icon in colored container
/// - Optional trend indicator (up/down arrow with percentage)
/// - Label and large value display
/// - Highlight variant with primary background
/// - Mode-aware colors
///
/// Example:
/// ```dart
/// FiftyStatCard(
///   label: 'Total Views',
///   value: '45.2k',
///   icon: Icons.visibility,
///   trend: FiftyStatTrend.up,
///   trendValue: '12%',
/// )
/// ```
class FiftyStatCard extends StatelessWidget {
  /// Creates a Fifty-styled stat card.
  const FiftyStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
    this.trendValue,
    this.iconColor,
    this.highlight = false,
  });

  /// The label text displayed below the value.
  final String label;

  /// The main value/metric to display prominently.
  final String value;

  /// The icon displayed in the colored container.
  final IconData icon;

  /// The trend direction (up, down, or neutral).
  ///
  /// When null, no trend badge is displayed.
  final FiftyStatTrend? trend;

  /// The trend value text (e.g., '12%').
  ///
  /// Only displayed when [trend] is not null.
  final String? trendValue;

  /// Custom color for the icon container.
  ///
  /// Defaults to the primary color.
  final Color? iconColor;

  /// Whether to use the highlight variant with primary background.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    // Background color
    final backgroundColor = highlight
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    // Text colors
    final labelColor = highlight
        ? colorScheme.onPrimary.withValues(alpha: 0.7)
        : colorScheme.onSurfaceVariant;
    final valueColor = highlight ? colorScheme.onPrimary : colorScheme.onSurface;

    // Icon container colors
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final iconBgColor = highlight
        ? Colors.white.withValues(alpha: 0.15)
        : effectiveIconColor.withValues(alpha: 0.15);
    final iconFgColor = highlight ? colorScheme.onPrimary : effectiveIconColor;

    // Border
    final borderColor = colorScheme.outline;

    return SizedBox(
      height: 128,
      child: AnimatedContainer(
        duration: fifty?.fast ?? const Duration(milliseconds: 150),
        curve: fifty?.standardCurve ?? Curves.easeInOut,
        padding: const EdgeInsets.all(FiftySpacing.lg),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: FiftyRadii.xlRadius,
          border: highlight ? null : Border.all(color: borderColor),
          boxShadow: fifty?.shadowSm ?? FiftyShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconContainer(iconBgColor, iconFgColor),
                if (trend != null) _buildTrendBadge(colorScheme, highlight, fifty),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FiftyTypography.medium,
                color: labelColor,
              ),
            ),
            const SizedBox(height: FiftySpacing.xs),
            Text(
              value,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.displayMedium,
                fontWeight: FiftyTypography.extraBold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(Color bgColor, Color fgColor) {
    return Container(
      padding: const EdgeInsets.all(FiftySpacing.sm),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: FiftyRadii.lgRadius,
      ),
      child: Icon(icon, size: 20, color: fgColor),
    );
  }

  Widget _buildTrendBadge(
    ColorScheme colorScheme,
    bool isHighlight,
    FiftyThemeExtension? fifty,
  ) {
    final trendColor = switch (trend!) {
      FiftyStatTrend.up => fifty?.success ?? colorScheme.tertiary,
      FiftyStatTrend.down => colorScheme.error,
      FiftyStatTrend.neutral => colorScheme.onSurfaceVariant,
    };

    final badgeBgColor = isHighlight
        ? Colors.white.withValues(alpha: 0.15)
        : trendColor.withValues(alpha: 0.15);
    final badgeFgColor = isHighlight ? Colors.white : trendColor;

    final arrowIcon = switch (trend!) {
      FiftyStatTrend.up => Icons.arrow_upward_rounded,
      FiftyStatTrend.down => Icons.arrow_downward_rounded,
      FiftyStatTrend.neutral => Icons.remove_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: FiftyRadii.fullRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(arrowIcon, size: 12, color: badgeFgColor),
          if (trendValue != null) ...[
            const SizedBox(width: 2),
            Text(
              trendValue!,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: 10,
                fontWeight: FiftyTypography.bold,
                color: badgeFgColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
