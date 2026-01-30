import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A kinetic toggle switch following FDL v2 styling.
///
/// Features:
/// - Kinetic snap animation (150ms with overshoot)
/// - SlateGrey thumb when active (NOT primary!)
/// - Theme onSurfaceVariant thumb when inactive
/// - SurfaceDark track with subtle border
/// - Optional label
///
/// **CRITICAL v2 DESIGN DECISION:**
/// The ON-state uses [FiftyColors.slateGrey], NOT the primary color!
/// This is intentional to differentiate switches from primary CTAs.
///
/// Example:
/// ```dart
/// FiftySwitch(
///   value: _isEnabled,
///   onChanged: (value) => setState(() => _isEnabled = value),
///   label: 'Enable notifications',
/// )
/// ```
class FiftySwitch extends StatefulWidget {
  /// Creates a Fifty-styled toggle switch.
  const FiftySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.size = FiftySwitchSize.medium,
  });

  /// Whether the switch is on or off.
  final bool value;

  /// Callback when the switch is toggled.
  ///
  /// If null, the switch is disabled.
  final ValueChanged<bool>? onChanged;

  /// Optional label displayed next to the switch.
  final String? label;

  /// Whether the switch is enabled.
  final bool enabled;

  /// Size variant of the switch.
  final FiftySwitchSize size;

  @override
  State<FiftySwitch> createState() => _FiftySwitchState();
}

/// Size variants for FiftySwitch.
enum FiftySwitchSize {
  /// Small switch (36x20).
  small,

  /// Medium switch (48x28).
  medium,

  /// Large switch (60x36).
  large,
}

class _FiftySwitchState extends State<FiftySwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  double get _trackWidth {
    switch (widget.size) {
      case FiftySwitchSize.small:
        return 36;
      case FiftySwitchSize.medium:
        return 48;
      case FiftySwitchSize.large:
        return 60;
    }
  }

  double get _trackHeight {
    switch (widget.size) {
      case FiftySwitchSize.small:
        return 20;
      case FiftySwitchSize.medium:
        return 28;
      case FiftySwitchSize.large:
        return 36;
    }
  }

  double get _thumbSize {
    switch (widget.size) {
      case FiftySwitchSize.small:
        return 16;
      case FiftySwitchSize.medium:
        return 24;
      case FiftySwitchSize.large:
        return 32;
    }
  }

  double get _thumbPadding => (_trackHeight - _thumbSize) / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );

    _thumbAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

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
  }

  @override
  void didUpdateWidget(FiftySwitch oldWidget) {
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
    final colorScheme = theme.colorScheme;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    // v2 color scheme - ON state uses onSurfaceVariant, NOT primary!
    final trackOnColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final trackOffColor = colorScheme.surfaceContainerHighest;
    final thumbOnColor = colorScheme.onSurfaceVariant;
    final thumbOffColor = colorScheme.onSurfaceVariant;
    final borderColor = colorScheme.outline;
    final hoverBorderColor = colorScheme.onSurfaceVariant;

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
                  final thumbPosition = _thumbAnimation.value *
                      (_trackWidth - _thumbSize - _thumbPadding * 2);

                  return AnimatedContainer(
                    duration: fifty.fast,
                    width: _trackWidth,
                    height: _trackHeight,
                    decoration: BoxDecoration(
                      color: widget.value ? trackOnColor : trackOffColor,
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                      border: Border.all(
                        color: _isHovered ? hoverBorderColor : borderColor,
                        width: 1,
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: _thumbPadding + thumbPosition,
                          top: _thumbPadding,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: _thumbSize,
                              height: _thumbSize,
                              decoration: BoxDecoration(
                                color: widget.value ? thumbOnColor : thumbOffColor,
                                shape: BoxShape.circle,
                                boxShadow: widget.value
                                    ? [
                                        BoxShadow(
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
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
