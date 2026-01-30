import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A reusable container that handles focus/hover glow animation.
///
/// This is the foundation for all interactive FDL components that need
/// the signature crimson glow effect on focus or hover states.
///
/// The glow animation is controlled by [showGlow] and animates using
/// the [FiftyMotion.fast] duration for responsive feedback.
///
/// Example:
/// ```dart
/// GlowContainer(
///   showGlow: _isFocused || _isHovered,
///   borderRadius: FiftyRadii.lgRadius,
///   child: MyContent(),
/// )
/// ```
class GlowContainer extends StatelessWidget {
  /// Creates a glow container.
  ///
  /// The [child] is required and will be wrapped with the glow effect.
  const GlowContainer({
    super.key,
    required this.child,
    this.showGlow = false,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.padding,
    this.useStrongGlow = false,
  });

  /// The widget to wrap with the glow effect.
  final Widget child;

  /// Whether to show the glow effect.
  ///
  /// When true, the crimson glow will be visible.
  /// Animate this value for smooth transitions.
  final bool showGlow;

  /// The border radius for the container.
  ///
  /// Defaults to [FiftyRadii.lgRadius] if not specified.
  final BorderRadius? borderRadius;

  /// The background color of the container.
  ///
  /// Defaults to transparent if not specified.
  final Color? backgroundColor;

  /// The border color of the container.
  ///
  /// When [showGlow] is true, this changes to the primary color.
  final Color? borderColor;

  /// The width of the border.
  ///
  /// Increases to 2px when [showGlow] is true.
  final double borderWidth;

  /// Padding inside the container.
  final EdgeInsetsGeometry? padding;

  /// Whether to use the stronger glow effect.
  ///
  /// Use for active/selected states requiring more prominence.
  final bool useStrongGlow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final effectiveBorderRadius = borderRadius ?? FiftyRadii.lgRadius;
    final effectiveBorderColor = showGlow
        ? colorScheme.primary
        : (borderColor ?? colorScheme.outline);
    final effectiveBorderWidth = showGlow ? 2.0 : borderWidth;
    final glowShadows = fifty.shadowGlow;

    return AnimatedContainer(
      duration: fifty.fast,
      curve: fifty.standardCurve,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        boxShadow: showGlow ? glowShadows : null,
      ),
      child: child,
    );
  }
}
