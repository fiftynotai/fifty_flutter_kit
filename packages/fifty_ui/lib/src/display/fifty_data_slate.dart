import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A terminal-style key-value display panel.
///
/// Features:
/// - Monospace typography for data display
/// - Grid layout with aligned keys and values
/// - Optional title header
/// - Optional border glow effect
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

  /// Whether to show the crimson glow effect.
  final bool showGlow;

  /// The color for keys.
  ///
  /// Defaults to [FiftyColors.hyperChrome].
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

    final effectiveKeyColor = keyColor ?? FiftyColors.hyperChrome;
    final effectiveValueColor = valueColor ?? colorScheme.onSurface;

    return AnimatedContainer(
      duration: fifty.fast,
      curve: fifty.standardCurve,
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: FiftyRadii.standardRadius,
        border: showBorder
            ? Border.all(
                color: showGlow ? colorScheme.primary : FiftyColors.border,
                width: showGlow ? 2 : 1,
              )
            : null,
        boxShadow: showGlow ? fifty.focusGlow : null,
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
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.mono,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  title!.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.mono,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.onSurface,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: FiftySpacing.md),
          ],
          ...data.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _calculateKeyWidth(data.keys),
                      child: Text(
                        '${entry.key}:',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          fontWeight: FiftyTypography.regular,
                          color: effectiveKeyColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.md),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          fontWeight: FiftyTypography.regular,
                          color: effectiveValueColor,
                        ),
                      ),
                    ),
                  ],
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
    // Approximate width per character in monospace at 12px
    return (maxLength + 1) * 7.5;
  }
}
