import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A radio button control following FDL v2 styling.
///
/// Features:
/// - 20x20 outer circle size
/// - Primary burgundy border and filled inner dot when selected
/// - Theme-aware border when unselected
/// - Kinetic scale animation on toggle (150ms)
/// - Optional label support
/// - Generic type for flexible value handling
///
/// **FDL v2 Design:**
/// The selected state uses [FiftyColors.primary] (burgundy) for the border
/// and a filled inner dot (~10px) for clear selection indication.
///
/// Example:
/// ```dart
/// FiftyRadio<String>(
///   value: 'option1',
///   groupValue: _selectedOption,
///   onChanged: (value) => setState(() => _selectedOption = value),
///   label: 'Option 1',
/// )
/// ```
///
/// Example with enum:
/// ```dart
/// enum PaymentMethod { card, cash, transfer }
///
/// FiftyRadio<PaymentMethod>(
///   value: PaymentMethod.card,
///   groupValue: _selectedMethod,
///   onChanged: (value) => setState(() => _selectedMethod = value),
///   label: 'Credit Card',
/// )
/// ```
class FiftyRadio<T> extends StatefulWidget {
  /// Creates a Fifty-styled radio button.
  const FiftyRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for the group.
  ///
  /// This radio is considered selected if [value] == [groupValue].
  final T? groupValue;

  /// Callback when this radio button is selected.
  ///
  /// If null, the radio button is disabled.
  final ValueChanged<T?>? onChanged;

  /// Optional label displayed next to the radio button.
  final String? label;

  /// Whether the radio button is enabled.
  final bool enabled;

  @override
  State<FiftyRadio<T>> createState() => _FiftyRadioState<T>();
}

class _FiftyRadioState<T> extends State<FiftyRadio<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _dotAnimation;

  bool _isHovered = false;

  static const double _outerSize = 20.0;
  static const double _innerDotSize = 10.0;

  bool get _isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: _isSelected ? 1.0 : 0.0,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.9),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _dotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(FiftyRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasSelected = oldWidget.value == oldWidget.groupValue;
    if (wasSelected != _isSelected) {
      if (_isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    // v2 color scheme
    const selectedBorderColor = FiftyColors.primary;
    final unselectedBorderColor =
        isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    final hoverBorderColor = isDark ? FiftyColors.powderBlush : FiftyColors.primary;
    const dotColor = FiftyColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: _handleTap,
        child: Opacity(
          opacity: opacity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedContainer(
                      duration: fifty.fast,
                      width: _outerSize,
                      height: _outerSize,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isSelected
                              ? selectedBorderColor
                              : (_isHovered
                                  ? hoverBorderColor
                                  : unselectedBorderColor),
                          width: 1.5,
                        ),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: hoverBorderColor.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Opacity(
                          opacity: _dotAnimation.value,
                          child: Transform.scale(
                            scale: _dotAnimation.value,
                            child: Container(
                              width: _innerDotSize,
                              height: _innerDotSize,
                              decoration: const BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (widget.label != null) ...[
                const SizedBox(width: FiftySpacing.md),
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FiftyTypography.regular,
                    color: isEnabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
