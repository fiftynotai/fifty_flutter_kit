import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A terminal-style key-value display panel with FDL v2 styling.
///
/// Features:
/// - Manrope typography for data display
/// - Grid layout with aligned keys and values
/// - Optional title header
/// - Optional border glow effect
/// - Mode-aware colors
///
/// Example:
/// ```dart
/// FiftyDataSlate(
///   title: 'SYSTEM STATUS',
///   data: {
///     'CPU': '45%',
///     'Memory': '8.2 GB',
///     'Uptime': '72h 14m',
///   },
///   showBorder: true,
/// )
/// ```
class FiftyDataSlate extends StatelessWidget {
  /// Creates a Fifty-styled data slate.
  const FiftyDataSlate({
    super.key,
    required this.data,
    this.title,
    this.showBorder = true,
    this.showGlow = false,
    this.keyColor,
    this.valueColor,
  });

  /// The key-value pairs to display.
  final Map<String, String> data;

  /// Optional title displayed at the top.
  final String? title;

  /// Whether to show the border outline.
  final bool showBorder;

  /// Whether to show the primary glow effect.
  final bool showGlow;

  /// The color for keys.
  ///
  /// Defaults to mode-aware secondary color.
  final Color? keyColor;

  /// The color for values.
  ///
  /// Defaults to the surface text color.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final effectiveKeyColor = keyColor ?? colorScheme.onSurfaceVariant;
    final effectiveValueColor = valueColor ?? colorScheme.onSurface;
    final borderColor = colorScheme.outline;

    return AnimatedContainer(
      duration: fifty.fast,
      curve: fifty.standardCurve,
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: FiftyRadii.xxlRadius,
        border: showBorder
            ? Border.all(
                color: showGlow ? colorScheme.primary : borderColor,
                width: showGlow ? 2 : 1,
              )
            : null,
        boxShadow: showGlow ? fifty.shadowGlow : FiftyShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Text(
                  '> ',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    title!.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FiftyTypography.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: FiftySpacing.md),
          ],
          ...data.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate key width but cap it at 40% of available space
                    final calculatedWidth = _calculateKeyWidth(data.keys);
                    final maxKeyWidth = constraints.maxWidth * 0.4;
                    final effectiveKeyWidth = calculatedWidth.clamp(0.0, maxKeyWidth);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: effectiveKeyWidth,
                          ),
                          child: Text(
                            '${entry.key}:',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.regular,
                              color: effectiveKeyColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: FiftySpacing.sm),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.regular,
                              color: effectiveValueColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  double _calculateKeyWidth(Iterable<String> keys) {
    final maxLength = keys.fold<int>(
      0,
      (max, key) => key.length > max ? key.length : max,
    );
    // Approximate width per character at 12px
    return (maxLength + 1) * 7.5;
  }
}
