import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../utils/glitch_effect.dart';

/// Button variants following the Fifty Design Language v2.
///
/// Each variant has a distinct visual style:
/// - [primary]: Solid burgundy background for main CTAs
/// - [secondary]: Solid slate-grey background for secondary actions
/// - [outline]: Burgundy border with transparent background
/// - [ghost]: Text-only, no background or border
/// - [danger]: Error/destructive action styling
enum FiftyButtonVariant {
  /// Primary button with solid burgundy background.
  primary,

  /// Secondary button with solid slate-grey background.
  secondary,

  /// Outline button with burgundy border and transparent background.
  outline,

  /// Ghost button with no background or border.
  ghost,

  /// Danger button for destructive actions.
  danger,
}

/// Button sizes for different contexts.
enum FiftyButtonSize {
  /// Small button (height: 36px).
  small,

  /// Medium button (height: 48px).
  medium,

  /// Large button (height: 56px).
  large,
}

/// A styled button following the Fifty Design Language v2.
///
/// Features:
/// - Five variants: primary, secondary, outline, ghost, danger
/// - Three sizes: small (36px), medium (48px), large (56px)
/// - Consistent xl border radius (16px)
/// - Primary shadow on primary variant
/// - Loading state with indicator
/// - Optional leading icon
/// - Optional trailing icon (for CTAs with arrows)
/// - Glitch effect on hover when enabled
/// - Press animation with scale effect
///
/// Example:
/// ```dart
/// FiftyButton(
///   label: 'GET STARTED',
///   onPressed: () => handleStart(),
///   variant: FiftyButtonVariant.primary,
///   trailingIcon: Icons.arrow_forward,
/// )
/// ```
class FiftyButton extends StatefulWidget {
  /// Creates a Fifty-styled button.
  const FiftyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = FiftyButtonVariant.primary,
    this.size = FiftyButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.expanded = false,
    this.isGlitch = false,
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

  /// Optional trailing icon.
  ///
  /// Displayed on the right side of the label text.
  /// Commonly used with [Icons.arrow_forward] for CTAs.
  final IconData? trailingIcon;

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

  /// Whether to apply glitch effect on hover.
  ///
  /// When true, the button text will show RGB chromatic aberration
  /// on hover. Respects reduced-motion accessibility settings.
  final bool isGlitch;

  @override
  State<FiftyButton> createState() => _FiftyButtonState();
}

class _FiftyButtonState extends State<FiftyButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  late AnimationController _loadingController;
  int _dotCount = 1;

  bool get _isDisabled => widget.disabled || widget.loading || widget.onPressed == null;
  bool get _showGlow => (_isHovered || _isFocused) && !_isDisabled;
  bool get _reduceMotion => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450), // 3 dots * 150ms
    )..addListener(_updateDots);

    if (widget.loading) {
      _loadingController.repeat();
    }
  }

  void _updateDots() {
    final newDotCount = (_loadingController.value * 3).floor() + 1;
    if (newDotCount != _dotCount) {
      setState(() {
        _dotCount = newDotCount.clamp(1, 3);
      });
    }
  }

  @override
  void didUpdateWidget(FiftyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading != oldWidget.loading) {
      if (widget.loading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
        _dotCount = 1;
      }
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  double get _pressScale => _isPressed && !_reduceMotion ? 0.95 : 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final height = _getHeight();
    final padding = _getPadding();
    final fontSize = _getFontSize();

    final backgroundColor = _getBackgroundColor(colorScheme);
    final foregroundColor = _getForegroundColor(colorScheme, fifty);
    final borderColor = _getBorderColor(colorScheme, fifty);
    final shadow = _getShadow();

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _isDisabled ? null : (_) => setState(() => _isPressed = true),
          onTapUp: _isDisabled ? null : (_) => setState(() => _isPressed = false),
          onTapCancel: _isDisabled ? null : () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _pressScale,
            duration: fifty.fast,
            curve: fifty.standardCurve,
            child: AnimatedContainer(
              duration: fifty.fast,
              curve: fifty.standardCurve,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: FiftyRadii.xlRadius,
                border: borderColor != null
                    ? Border.all(
                        color: borderColor,
                        width: _showGlow ? 2 : 1,
                      )
                    : null,
                boxShadow: _showGlow ? fifty.shadowGlow : shadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isDisabled ? null : widget.onPressed,
                  borderRadius: FiftyRadii.xlRadius,
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
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor, double fontSize) {
    if (widget.loading) {
      // FDL Rule: "Loading: Never use a spinner. Use text sequences."
      // Check for reduced motion preference
      final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
      final dots = reduceMotion ? '...' : ('.' * _dotCount);
      final padding = reduceMotion ? '' : ('.' * (3 - _dotCount));

      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: dots),
            // Invisible padding to prevent layout shift
            TextSpan(
              text: padding,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: fontSize,
                fontWeight: FiftyTypography.medium,
                color: Colors.transparent,
                letterSpacing: FiftyTypography.letterSpacingLabel,
              ),
            ),
          ],
        ),
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: fontSize,
          fontWeight: FiftyTypography.medium,
          color: foregroundColor,
          letterSpacing: FiftyTypography.letterSpacingLabel,
        ),
      );
    }

    Widget textWidget = Text(
      widget.label.toUpperCase(),
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: fontSize,
        fontWeight: FiftyTypography.bold,
        color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
        letterSpacing: FiftyTypography.letterSpacingLabel,
      ),
    );

    // Wrap text in GlitchEffect if enabled and hovered
    if (widget.isGlitch && _isHovered && !_isDisabled) {
      textWidget = GlitchEffect(
        triggerOnHover: true,
        intensity: 0.8,
        child: textWidget,
      );
    }

    if (widget.icon != null || widget.trailingIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: fontSize + 4,
              color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
            ),
            const SizedBox(width: FiftySpacing.sm),
          ],
          textWidget,
          if (widget.trailingIcon != null) ...[
            const SizedBox(width: FiftySpacing.sm),
            Icon(
              widget.trailingIcon,
              size: fontSize + 4,
              color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
            ),
          ],
        ],
      );
    }

    return textWidget;
  }

  double _getHeight() {
    switch (widget.size) {
      case FiftyButtonSize.small:
        return 36;
      case FiftyButtonSize.medium:
        return 48;
      case FiftyButtonSize.large:
        return 56;
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
        return FiftyTypography.bodySmall;
      case FiftyButtonSize.medium:
        return FiftyTypography.labelLarge;
      case FiftyButtonSize.large:
        return FiftyTypography.bodyLarge;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (_isDisabled) {
      switch (widget.variant) {
        case FiftyButtonVariant.primary:
        case FiftyButtonVariant.danger:
          return colorScheme.primary.withValues(alpha: 0.3);
        case FiftyButtonVariant.secondary:
          return colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
        case FiftyButtonVariant.outline:
        case FiftyButtonVariant.ghost:
          return Colors.transparent;
      }
    }

    switch (widget.variant) {
      case FiftyButtonVariant.primary:
        return colorScheme.primary;
      case FiftyButtonVariant.secondary:
        return colorScheme.onSurfaceVariant;
      case FiftyButtonVariant.outline:
      case FiftyButtonVariant.ghost:
        return Colors.transparent;
      case FiftyButtonVariant.danger:
        return colorScheme.error;
    }
  }

  Color _getForegroundColor(
    ColorScheme colorScheme,
    FiftyThemeExtension? fiftyTheme,
  ) {
    switch (widget.variant) {
      case FiftyButtonVariant.primary:
        return colorScheme.onPrimary;
      case FiftyButtonVariant.secondary:
        return Colors.white;
      case FiftyButtonVariant.outline:
        return fiftyTheme?.accent ?? colorScheme.primary;
      case FiftyButtonVariant.ghost:
        return colorScheme.onSurface;
      case FiftyButtonVariant.danger:
        return colorScheme.onError;
    }
  }

  Color? _getBorderColor(
    ColorScheme colorScheme,
    FiftyThemeExtension? fiftyTheme,
  ) {
    switch (widget.variant) {
      case FiftyButtonVariant.primary:
      case FiftyButtonVariant.secondary:
      case FiftyButtonVariant.danger:
        return null;
      case FiftyButtonVariant.outline:
        return fiftyTheme?.accent ?? colorScheme.primary;
      case FiftyButtonVariant.ghost:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    if (_isDisabled) return null;

    switch (widget.variant) {
      case FiftyButtonVariant.primary:
        return FiftyShadows.primary;
      case FiftyButtonVariant.secondary:
        return FiftyShadows.sm;
      case FiftyButtonVariant.outline:
      case FiftyButtonVariant.ghost:
      case FiftyButtonVariant.danger:
        return null;
    }
  }
}
