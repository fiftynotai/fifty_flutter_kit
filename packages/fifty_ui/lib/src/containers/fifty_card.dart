import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A card container with FDL styling.
///
/// Features:
/// - Gunmetal background with border outline (no shadow)
/// - Optional tap interaction with ripple effect
/// - Selected state with crimson border and subtle glow
///
/// Example:
/// ```dart
/// FiftyCard(
///   onTap: () => selectItem(),
///   selected: isSelected,
///   child: CardContent(),
/// )
/// ```
class FiftyCard extends StatefulWidget {
  /// Creates a Fifty-styled card.
  const FiftyCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.selected = false,
    this.borderRadius,
    this.backgroundColor,
  });

  /// The content of the card.
  final Widget child;

  /// Padding inside the card.
  ///
  /// Defaults to [FiftySpacing.lg] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Callback when the card is tapped.
  ///
  /// If null, the card is not interactive.
  final VoidCallback? onTap;

  /// Whether the card is in a selected state.
  ///
  /// When true, shows crimson border and subtle glow.
  final bool selected;

  /// The border radius of the card.
  ///
  /// Defaults to [FiftyRadii.standardRadius].
  final BorderRadius? borderRadius;

  /// The background color of the card.
  ///
  /// Defaults to [FiftyColors.gunmetal].
  final Color? backgroundColor;

  @override
  State<FiftyCard> createState() => _FiftyCardState();
}

class _FiftyCardState extends State<FiftyCard> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get _isInteractive => widget.onTap != null;
  bool get _showGlow =>
      widget.selected || ((_isHovered || _isFocused) && _isInteractive);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final effectiveBorderRadius =
        widget.borderRadius ?? FiftyRadii.standardRadius;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? FiftyColors.gunmetal;
    final effectivePadding = widget.padding ??
        const EdgeInsets.all(FiftySpacing.lg);

    final borderColor = widget.selected || _showGlow
        ? colorScheme.primary
        : FiftyColors.border;
    final borderWidth = widget.selected || _showGlow ? 2.0 : 1.0;

    Widget cardContent = Container(
      padding: effectivePadding,
      child: widget.child,
    );

    if (_isInteractive) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: effectiveBorderRadius,
          splashColor: colorScheme.primary.withValues(alpha: 0.2),
          highlightColor: Colors.transparent,
          child: cardContent,
        ),
      );
    }

    return Focus(
      onFocusChange: _isInteractive
          ? (focused) => setState(() => _isFocused = focused)
          : null,
      child: MouseRegion(
        onEnter: _isInteractive ? (_) => setState(() => _isHovered = true) : null,
        onExit: _isInteractive ? (_) => setState(() => _isHovered = false) : null,
        child: AnimatedContainer(
          duration: fifty.fast,
          curve: fifty.standardCurve,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: _showGlow ? fifty.focusGlow : null,
          ),
          child: ClipRRect(
            borderRadius: effectiveBorderRadius,
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
