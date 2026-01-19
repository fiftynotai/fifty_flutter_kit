import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated widget that shakes its child horizontally.
///
/// Used to indicate a failed action, such as attempting to unlock
/// a skill without meeting prerequisites or having insufficient points.
///
/// **Example:**
/// ```dart
/// ShakeAnimationWidget(
///   onComplete: () => print('Shake finished'),
///   child: SkillNodeWidget(...),
/// )
/// ```
class ShakeAnimationWidget extends StatefulWidget {
  /// Creates a shake animation widget.
  ///
  /// **Parameters:**
  /// - [child]: The widget to shake
  /// - [onComplete]: Callback when animation completes
  /// - [duration]: Total animation duration (default 400ms)
  /// - [intensity]: Maximum horizontal offset (default 6)
  /// - [shakeCount]: Number of shake cycles (default 4)
  const ShakeAnimationWidget({
    super.key,
    required this.child,
    this.onComplete,
    this.duration = const Duration(milliseconds: 400),
    this.intensity = 6.0,
    this.shakeCount = 4,
  });

  /// The widget to shake.
  final Widget child;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  /// Total animation duration.
  final Duration duration;

  /// Maximum horizontal offset in pixels.
  final double intensity;

  /// Number of shake cycles.
  final int shakeCount;

  @override
  State<ShakeAnimationWidget> createState() => _ShakeAnimationWidgetState();
}

class _ShakeAnimationWidgetState extends State<ShakeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _decayAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Shake oscillation
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: widget.shakeCount * 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // Decay envelope (starts at 1, decays to 0)
    _decayAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start animation and notify on complete
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate horizontal offset
        final offset = math.sin(_shakeAnimation.value) *
            widget.intensity *
            _decayAnimation.value;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// A wrapper that can trigger shake animation on demand.
///
/// Unlike [ShakeAnimationWidget] which starts immediately, this widget
/// can be triggered programmatically via its controller.
///
/// **Example:**
/// ```dart
/// final shakeController = ShakeController();
///
/// ShakeOnDemandWidget(
///   controller: shakeController,
///   child: SkillNodeWidget(...),
/// )
///
/// // Later, trigger shake
/// shakeController.shake();
/// ```
class ShakeOnDemandWidget extends StatefulWidget {
  /// Creates a shake on demand widget.
  const ShakeOnDemandWidget({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 400),
    this.intensity = 6.0,
    this.shakeCount = 4,
  });

  /// The widget to shake.
  final Widget child;

  /// Controller to trigger shakes.
  final ShakeController controller;

  /// Total animation duration.
  final Duration duration;

  /// Maximum horizontal offset in pixels.
  final double intensity;

  /// Number of shake cycles.
  final int shakeCount;

  @override
  State<ShakeOnDemandWidget> createState() => _ShakeOnDemandWidgetState();
}

class _ShakeOnDemandWidgetState extends State<ShakeOnDemandWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    widget.controller._attach(_controller);
  }

  @override
  void dispose() {
    widget.controller._detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.isAnimating && _controller.value == 0) {
          return widget.child;
        }

        // Calculate shake offset
        final progress = _controller.value;
        final oscillation =
            math.sin(progress * widget.shakeCount * 2 * math.pi);
        final decay = 1.0 - progress;
        final offset = oscillation * widget.intensity * decay;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// Controller for [ShakeOnDemandWidget].
///
/// Use [shake] to trigger the shake animation.
class ShakeController {
  AnimationController? _animationController;

  void _attach(AnimationController controller) {
    _animationController = controller;
  }

  void _detach() {
    _animationController = null;
  }

  /// Triggers the shake animation.
  ///
  /// Returns a Future that completes when the animation finishes.
  Future<void> shake() async {
    final controller = _animationController;
    if (controller == null) return;

    controller.reset();
    await controller.forward();
  }

  /// Whether the shake animation is currently running.
  bool get isShaking => _animationController?.isAnimating ?? false;
}
