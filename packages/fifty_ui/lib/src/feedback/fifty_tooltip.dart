import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that adds a FDL v2 styled tooltip on hover.
///
/// Features:
/// - Mode-aware background (dark on light, light on dark)
/// - Matches FDL design language
/// - Configurable wait duration
/// - Manrope font family
///
/// Example:
/// ```dart
/// FiftyTooltip(
///   message: 'Click to deploy',
///   child: FiftyIconButton(
///     icon: Icons.rocket_launch,
///     tooltip: 'Deploy',
///     onPressed: deploy,
///   ),
/// )
/// ```
class FiftyTooltip extends StatelessWidget {
  /// Creates a Fifty-styled tooltip wrapper.
  const FiftyTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = true,
    this.waitDuration = const Duration(milliseconds: 500),
  });

  /// The tooltip message to display.
  final String message;

  /// The widget to wrap with the tooltip.
  final Widget child;

  /// Whether to prefer showing the tooltip below the widget.
  final bool preferBelow;

  /// How long to wait before showing the tooltip.
  final Duration waitDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    // Tooltip uses inverse colors for visibility
    final backgroundColor = colorScheme.inverseSurface;
    final textColor = colorScheme.onInverseSurface;
    final borderColor = colorScheme.outline;

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: waitDuration,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: borderColor),
        boxShadow: fifty?.shadowSm ?? FiftyShadows.sm,
      ),
      textStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: textColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      child: child,
    );
  }
}
