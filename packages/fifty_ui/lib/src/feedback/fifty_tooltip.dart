import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that adds a FDL-styled tooltip on hover.
///
/// Features:
/// - Dark background with light text
/// - Matches FDL design language
/// - Configurable wait duration
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
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: waitDuration,
      decoration: BoxDecoration(
        color: FiftyColors.voidBlack,
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: FiftyColors.border),
      ),
      textStyle: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.terminalWhite,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      child: child,
    );
  }
}
