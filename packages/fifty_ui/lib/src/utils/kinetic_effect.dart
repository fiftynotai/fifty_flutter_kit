import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

/// A reusable hover/press animation wrapper that provides kinetic feedback.
///
/// This effect creates the FDL "heavy but fast" motion by applying:
/// - Scale up on hover (default 1.02)
/// - Scale down on press (default 0.95)
/// - Configurable durations using [FiftyMotion] tokens
///
/// The effect respects reduced-motion accessibility settings and disables
/// animations when [MediaQuery.disableAnimations] is true.
///
/// Example:
/// ```dart
/// KineticEffect(
///   onTap: () => handleTap(),
///   child: MyCard(),
/// )
/// ```
class KineticEffect extends StatefulWidget {
  /// Creates a kinetic effect wrapper.
  const KineticEffect({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.02,
    this.pressScale = 0.95,
    this.duration,
    this.enabled = true,
  });

  /// The widget to wrap with kinetic effects.
  final Widget child;

  /// Callback when the widget is tapped.
  final VoidCallback? onTap;

  /// Scale factor when hovered.
  ///
  /// Defaults to 1.02 (2% larger).
  final double hoverScale;

  /// Scale factor when pressed.
  ///
  /// Defaults to 0.95 (5% smaller).
  final double pressScale;

  /// Duration of the scale animation.
  ///
  /// Defaults to [FiftyMotion.fast] (150ms).
  final Duration? duration;

  /// Whether the kinetic effect is enabled.
  ///
  /// When disabled, the child is rendered without animation.
  final bool enabled;

  @override
  State<KineticEffect> createState() => _KineticEffectState();
}

class _KineticEffectState extends State<KineticEffect> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _currentScale {
    if (_isPressed) return widget.pressScale;
    if (_isHovered) return widget.hoverScale;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final animationDuration = widget.duration ?? fifty.fast;

    // If reduced motion or disabled, render without animation
    if (reduceMotion || !widget.enabled) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.child,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _currentScale,
          duration: animationDuration,
          curve: fifty.standardCurve,
          child: widget.child,
        ),
      ),
    );
  }
}
