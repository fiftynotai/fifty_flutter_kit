import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Chip variants for different semantic meanings.
enum FiftyChipVariant {
  /// Default chip with neutral styling.
  defaultVariant,

  /// Success chip with green accent.
  success,

  /// Warning chip with amber accent.
  warning,

  /// Error chip with crimson accent.
  error,
}

/// A chip/tag component with FDL styling.
///
/// Features:
/// - Four variants: default, success, warning, error
/// - Optional delete button
/// - Selected state with crimson accent
/// - Optional avatar/leading widget
///
/// Example:
/// ```dart
/// FiftyChip(
///   label: 'DEPLOYED',
///   variant: FiftyChipVariant.success,
///   onDeleted: () => removeTag(),
/// )
/// ```
class FiftyChip extends StatelessWidget {
  /// Creates a Fifty-styled chip.
  const FiftyChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.onTap,
    this.selected = false,
    this.avatar,
    this.variant = FiftyChipVariant.defaultVariant,
  });

  /// The label text.
  final String label;

  /// Callback when the delete button is pressed.
  ///
  /// If null, no delete button is shown.
  final VoidCallback? onDeleted;

  /// Callback when the chip is tapped.
  final VoidCallback? onTap;

  /// Whether the chip is selected.
  final bool selected;

  /// Optional avatar widget displayed before the label.
  final Widget? avatar;

  /// The visual variant of the chip.
  final FiftyChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final accentColor = _getAccentColor(fifty, colorScheme);
    final backgroundColor = selected
        ? accentColor.withValues(alpha: 0.2)
        : FiftyColors.gunmetal;
    final borderColor = selected ? accentColor : FiftyColors.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: FiftyRadii.fullRadius,
        child: AnimatedContainer(
          duration: fifty.fast,
          curve: fifty.standardCurve,
          padding: EdgeInsets.only(
            left: avatar != null ? FiftySpacing.xs : FiftySpacing.md,
            right: onDeleted != null ? FiftySpacing.xs : FiftySpacing.md,
            top: FiftySpacing.xs,
            bottom: FiftySpacing.xs,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: FiftyRadii.fullRadius,
            border: Border.all(
              color: borderColor,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: FiftySpacing.sm),
              ],
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.mono,
                  fontWeight: FiftyTypography.medium,
                  color: selected ? accentColor : colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: FiftySpacing.xs),
                GestureDetector(
                  onTap: onDeleted,
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAccentColor(FiftyThemeExtension fifty, ColorScheme colorScheme) {
    switch (variant) {
      case FiftyChipVariant.defaultVariant:
        return colorScheme.primary;
      case FiftyChipVariant.success:
        return fifty.success;
      case FiftyChipVariant.warning:
        return fifty.warning;
      case FiftyChipVariant.error:
        return colorScheme.error;
    }
  }
}
