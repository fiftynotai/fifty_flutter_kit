import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Icon button variants following FDL v2.
enum FiftyIconButtonVariant {
  /// Primary icon button with solid background.
  primary,

  /// Secondary icon button with outline.
  secondary,

  /// Ghost icon button with no background.
  ghost,
}

/// Icon button sizes.
enum FiftyIconButtonSize {
  /// Small icon button (32x32).
  small,

  /// Medium icon button (40x40).
  medium,

  /// Large icon button (48x48).
  large,
}

/// A circular icon button with FDL v2 styling.
///
/// Features:
/// - Circular shape with glow on focus/hover
/// - Required tooltip for accessibility
/// - Three variants: primary, secondary, ghost
/// - Three sizes: small, medium, large
/// - Mode-aware colors
///
/// Example:
/// ```dart
/// FiftyIconButton(
///   icon: Icons.settings,
///   tooltip: 'Open settings',
///   onPressed: () => openSettings(),
/// )
/// ```
class FiftyIconButton extends StatefulWidget {
  /// Creates a Fifty-styled icon button.
  ///
  /// The [icon] and [tooltip] are required for accessibility.
  const FiftyIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.variant = FiftyIconButtonVariant.ghost,
    this.size = FiftyIconButtonSize.medium,
    this.disabled = false,
  });

  /// The icon to display.
  final IconData icon;

  /// Tooltip text for accessibility.
  ///
  /// This is required to ensure all icon buttons are accessible.
  final String tooltip;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The visual variant of the button.
  final FiftyIconButtonVariant variant;

  /// The size of the button.
  final FiftyIconButtonSize size;

  /// Whether the button is disabled.
  final bool disabled;

  @override
  State<FiftyIconButton> createState() => _FiftyIconButtonState();
}

class _FiftyIconButtonState extends State<FiftyIconButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isDisabled => widget.disabled || widget.onPressed == null;
  bool get _showGlow => (_isHovered || _isFocused) && !_isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final dimension = _getDimension();
    final iconSize = _getIconSize();

    final backgroundColor = _getBackgroundColor(colorScheme);
    final foregroundColor = _getForegroundColor(colorScheme, isDark);
    final borderColor = _getBorderColor(colorScheme);

    return Tooltip(
      message: widget.tooltip,
      decoration: BoxDecoration(
        color: isDark ? FiftyColors.surfaceDark : FiftyColors.darkBurgundy,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(
          color: isDark ? FiftyColors.borderDark : FiftyColors.borderLight,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.cream,
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: fifty.fast,
            curve: fifty.standardCurve,
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: borderColor != null
                  ? Border.all(
                      color: borderColor,
                      width: _showGlow ? 2 : 1,
                    )
                  : null,
              boxShadow: _showGlow ? fifty.shadowGlow : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isDisabled ? null : widget.onPressed,
                customBorder: const CircleBorder(),
                splashColor: colorScheme.primary.withValues(alpha: 0.2),
                highlightColor: Colors.transparent,
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: iconSize,
                    color: _isDisabled
                        ? foregroundColor.withValues(alpha: 0.5)
                        : foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getDimension() {
    switch (widget.size) {
      case FiftyIconButtonSize.small:
        return 32;
      case FiftyIconButtonSize.medium:
        return 40;
      case FiftyIconButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case FiftyIconButtonSize.small:
        return 16;
      case FiftyIconButtonSize.medium:
        return 20;
      case FiftyIconButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (_isDisabled) {
      switch (widget.variant) {
        case FiftyIconButtonVariant.primary:
          return colorScheme.primary.withValues(alpha: 0.3);
        case FiftyIconButtonVariant.secondary:
        case FiftyIconButtonVariant.ghost:
          return Colors.transparent;
      }
    }

    switch (widget.variant) {
      case FiftyIconButtonVariant.primary:
        return colorScheme.primary;
      case FiftyIconButtonVariant.secondary:
      case FiftyIconButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme, bool isDark) {
    switch (widget.variant) {
      case FiftyIconButtonVariant.primary:
        return colorScheme.onPrimary;
      case FiftyIconButtonVariant.secondary:
        return colorScheme.primary;
      case FiftyIconButtonVariant.ghost:
        return isDark ? FiftyColors.slateGrey : Colors.grey[600]!;
    }
  }

  Color? _getBorderColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case FiftyIconButtonVariant.primary:
      case FiftyIconButtonVariant.ghost:
        return null;
      case FiftyIconButtonVariant.secondary:
        return colorScheme.primary;
    }
  }
}
