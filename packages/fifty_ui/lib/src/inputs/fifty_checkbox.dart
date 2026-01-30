import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A checkbox control following FDL v2 styling.
///
/// Features:
/// - 20x20 size with 4px (sm) border radius
/// - Primary burgundy background when checked
/// - White check icon when checked
/// - Theme-aware border when unchecked
/// - Kinetic scale animation on toggle (150ms)
/// - Optional label support
///
/// **FDL v2 Design:**
/// The checked state uses [FiftyColors.primary] (burgundy) to indicate
/// selection, with a white check icon for clear visibility.
///
/// Example:
/// ```dart
/// FiftyCheckbox(
///   value: _acceptTerms,
///   onChanged: (value) => setState(() => _acceptTerms = value),
///   label: 'Accept terms and conditions',
/// )
/// ```
class FiftyCheckbox extends StatefulWidget {
  /// Creates a Fifty-styled checkbox.
  const FiftyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Callback when the checkbox is toggled.
  ///
  /// If null, the checkbox is disabled.
  final ValueChanged<bool>? onChanged;

  /// Optional label displayed next to the checkbox.
  final String? label;

  /// Whether the checkbox is enabled.
  final bool enabled;

  @override
  State<FiftyCheckbox> createState() => _FiftyCheckboxState();
}

class _FiftyCheckboxState extends State<FiftyCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  bool _isHovered = false;

  static const double _size = 20.0;
  static const double _iconSize = 14.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
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

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(FiftyCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
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
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final fiftyTheme = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    // v2 color scheme - using theme colors
    final checkedBgColor = colorScheme.primary;
    const uncheckedBgColor = Colors.transparent;
    final borderColor = colorScheme.outline;
    final hoverBorderColor = fiftyTheme?.accent ?? colorScheme.primary;
    const checkColor = Colors.white;

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
                      width: _size,
                      height: _size,
                      decoration: BoxDecoration(
                        color: widget.value ? checkedBgColor : uncheckedBgColor,
                        borderRadius: FiftyRadii.smRadius,
                        border: Border.all(
                          color: widget.value
                              ? checkedBgColor
                              : (_isHovered ? hoverBorderColor : borderColor),
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
                          opacity: _checkAnimation.value,
                          child: Transform.scale(
                            scale: _checkAnimation.value,
                            child: const Icon(
                              Icons.check,
                              size: _iconSize,
                              color: checkColor,
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
                Flexible(
                  child: Text(
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
