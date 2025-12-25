import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Button variants following the Fifty Design Language.
///
/// Each variant has a distinct visual style:
/// - [primary]: Solid crimson background for main CTAs
/// - [secondary]: Outlined with crimson border
/// - [ghost]: Text-only, no background or border
/// - [danger]: Error/destructive action styling
enum FiftyButtonVariant {
  /// Primary button with solid crimson background.
  primary,

  /// Secondary button with crimson outline.
  secondary,

  /// Ghost button with no background or border.
  ghost,

  /// Danger button for destructive actions.
  danger,
}

/// Button sizes for different contexts.
enum FiftyButtonSize {
  /// Small button (height: 32px).
  small,

  /// Medium button (height: 40px).
  medium,

  /// Large button (height: 48px).
  large,
}

/// A styled button following the Fifty Design Language.
///
/// Features:
/// - Four variants: primary, secondary, ghost, danger
/// - Three sizes: small, medium, large
/// - Crimson glow on focus/hover
/// - Loading state with indicator
/// - Optional leading icon
///
/// Example:
/// ```dart
/// FiftyButton(
///   label: 'DEPLOY',
///   onPressed: () => handleDeploy(),
///   variant: FiftyButtonVariant.primary,
///   icon: Icons.rocket_launch,
/// )
/// ```
class FiftyButton extends StatefulWidget {
  /// Creates a Fifty-styled button.
  const FiftyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = FiftyButtonVariant.primary,
    this.size = FiftyButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.expanded = false,
  });

  /// The button label text.
  ///
  /// Displayed in uppercase following FDL conventions.
  final String label;

  /// Callback when the button is pressed.
  ///
  /// If null or [disabled] is true, the button is disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// The visual variant of the button.
  final FiftyButtonVariant variant;

  /// The size of the button.
  final FiftyButtonSize size;

  /// Whether the button shows a loading indicator.
  ///
  /// When true, the button is disabled and shows a spinner.
  final bool loading;

  /// Whether the button is disabled.
  final bool disabled;

  /// Whether the button expands to fill available width.
  final bool expanded;

  @override
  State<FiftyButton> createState() => _FiftyButtonState();
}

class _FiftyButtonState extends State<FiftyButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isDisabled => widget.disabled || widget.loading || widget.onPressed == null;
  bool get _showGlow => (_isHovered || _isFocused) && !_isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final height = _getHeight();
    final padding = _getPadding();
    final fontSize = _getFontSize();

    final backgroundColor = _getBackgroundColor(colorScheme);
    final foregroundColor = _getForegroundColor(colorScheme);
    final borderColor = _getBorderColor(colorScheme);

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: fifty.fast,
          curve: fifty.standardCurve,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: FiftyRadii.standardRadius,
            border: borderColor != null
                ? Border.all(
                    color: borderColor,
                    width: _showGlow ? 2 : 1,
                  )
                : null,
            boxShadow: _showGlow ? fifty.focusGlow : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isDisabled ? null : widget.onPressed,
              borderRadius: FiftyRadii.standardRadius,
              splashColor: colorScheme.primary.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              child: Container(
                width: widget.expanded ? double.infinity : null,
                padding: padding,
                alignment: Alignment.center,
                child: _buildContent(foregroundColor, fontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor, double fontSize) {
    if (widget.loading) {
      return SizedBox(
        width: fontSize,
        height: fontSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(foregroundColor),
        ),
      );
    }

    final textWidget = Text(
      widget.label.toUpperCase(),
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: fontSize,
        fontWeight: FiftyTypography.medium,
        color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
        letterSpacing: FiftyTypography.tight * fontSize,
      ),
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: fontSize + 4,
            color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
          ),
          const SizedBox(width: FiftySpacing.sm),
          textWidget,
        ],
      );
    }

    return textWidget;
  }

  double _getHeight() {
    switch (widget.size) {
      case FiftyButtonSize.small:
        return 32;
      case FiftyButtonSize.medium:
        return 40;
      case FiftyButtonSize.large:
        return 48;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case FiftyButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: FiftySpacing.md);
      case FiftyButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: FiftySpacing.lg);
      case FiftyButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: FiftySpacing.xl);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case FiftyButtonSize.small:
        return 12;
      case FiftyButtonSize.medium:
        return 14;
      case FiftyButtonSize.large:
        return 16;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (_isDisabled) {
      switch (widget.variant) {
        case FiftyButtonVariant.primary:
        case FiftyButtonVariant.danger:
          return colorScheme.primary.withValues(alpha: 0.3);
        case FiftyButtonVariant.secondary:
        case FiftyButtonVariant.ghost:
          return Colors.transparent;
      }
    }

    switch (widget.variant) {
      case FiftyButtonVariant.primary:
        return colorScheme.primary;
      case FiftyButtonVariant.secondary:
      case FiftyButtonVariant.ghost:
        return Colors.transparent;
      case FiftyButtonVariant.danger:
        return colorScheme.error;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case FiftyButtonVariant.primary:
        return colorScheme.onPrimary;
      case FiftyButtonVariant.secondary:
        return colorScheme.primary;
      case FiftyButtonVariant.ghost:
        return colorScheme.onSurface;
      case FiftyButtonVariant.danger:
        return colorScheme.onError;
    }
  }

  Color? _getBorderColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case FiftyButtonVariant.primary:
      case FiftyButtonVariant.danger:
        return null;
      case FiftyButtonVariant.secondary:
        return colorScheme.primary;
      case FiftyButtonVariant.ghost:
        return null;
    }
  }
}
