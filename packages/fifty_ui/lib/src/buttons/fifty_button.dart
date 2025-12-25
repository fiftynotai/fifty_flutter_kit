import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../utils/glitch_effect.dart';

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

/// Button shape options for border radius.
///
/// - [sharp]: 4px border radius for a more angular look
/// - [pill]: 100px border radius for a fully rounded pill shape
enum FiftyButtonShape {
  /// Sharp corners with 4px border radius.
  sharp,

  /// Fully rounded pill shape with 100px border radius.
  pill,
}

/// A styled button following the Fifty Design Language.
///
/// Features:
/// - Four variants: primary, secondary, ghost, danger
/// - Three sizes: small, medium, large
/// - Two shapes: sharp (4px radius), pill (100px radius)
/// - Crimson glow on focus/hover
/// - Loading state with indicator
/// - Optional leading icon
/// - Glitch effect on hover when enabled
/// - Press animation with scale effect
///
/// Example:
/// ```dart
/// FiftyButton(
///   label: 'DEPLOY',
///   onPressed: () => handleDeploy(),
///   variant: FiftyButtonVariant.primary,
///   icon: Icons.rocket_launch,
///   isGlitch: true,
///   shape: FiftyButtonShape.sharp,
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
    this.shape = FiftyButtonShape.sharp,
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

  /// The visual variant of the button.
  final FiftyButtonVariant variant;

  /// The size of the button.
  final FiftyButtonSize size;

  /// The shape of the button.
  ///
  /// Determines the border radius:
  /// - [FiftyButtonShape.sharp]: 4px radius
  /// - [FiftyButtonShape.pill]: 100px radius (fully rounded)
  final FiftyButtonShape shape;

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

  BorderRadius get _borderRadius {
    switch (widget.shape) {
      case FiftyButtonShape.sharp:
        return BorderRadius.circular(4);
      case FiftyButtonShape.pill:
        return BorderRadius.circular(100);
    }
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
    final foregroundColor = _getForegroundColor(colorScheme);
    final borderColor = _getBorderColor(colorScheme);

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
                borderRadius: _borderRadius,
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
                  borderRadius: _borderRadius,
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
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: fontSize,
                fontWeight: FiftyTypography.medium,
                color: Colors.transparent,
                letterSpacing: FiftyTypography.tight * fontSize,
              ),
            ),
          ],
        ),
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: fontSize,
          fontWeight: FiftyTypography.medium,
          color: foregroundColor,
          letterSpacing: FiftyTypography.tight * fontSize,
        ),
      );
    }

    Widget textWidget = Text(
      widget.label.toUpperCase(),
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: fontSize,
        fontWeight: FiftyTypography.medium,
        color: _isDisabled ? foregroundColor.withValues(alpha: 0.5) : foregroundColor,
        letterSpacing: FiftyTypography.tight * fontSize,
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
