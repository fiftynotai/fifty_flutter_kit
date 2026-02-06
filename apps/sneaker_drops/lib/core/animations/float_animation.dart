import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// **FloatAnimationMixin**
///
/// Mixin providing floating animation for sneaker images and hero elements.
/// Creates a subtle ambient motion effect for visual interest.
///
/// **Specs from design doc:**
/// - Duration: 3000ms loop
/// - Curve: Curves.easeInOut
/// - Vertical oscillation: 3px amplitude
/// - Subtle rotation: 0.5 degrees at peak
///
/// **Usage:**
/// ```dart
/// class _FloatingSneakerState extends State<FloatingSneaker>
///     with TickerProviderStateMixin, FloatAnimationMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     initFloatAnimation();
///   }
///
///   @override
///   void dispose() {
///     disposeFloatAnimation();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return AnimatedBuilder(
///       animation: floatAnimation,
///       builder: (context, child) {
///         return Transform.translate(
///           offset: Offset(0, floatOffset),
///           child: Transform.rotate(
///             angle: floatRotationRadians,
///             child: child,
///           ),
///         );
///       },
///       child: SneakerImage(...),
///     );
///   }
/// }
/// ```
mixin FloatAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotationAnimation;

  /// Whether animations should be disabled for accessibility.
  bool _reduceMotion = false;

  /// Initialize the float animation. Call in initState().
  @protected
  void initFloatAnimation() {
    _floatController = AnimationController(
      duration: SneakerAnimations.float,
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: SneakerAnimations.floatCurve,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: SneakerAnimations.floatCurve,
    ));

    // Start looping animation
    _floatController.repeat(reverse: true);
  }

  /// Check for reduced motion preference. Call in didChangeDependencies().
  @protected
  void checkReducedMotion() {
    _reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (_reduceMotion) {
      _floatController.stop();
    } else if (!_floatController.isAnimating) {
      _floatController.repeat(reverse: true);
    }
  }

  /// Dispose the float animation. Call in dispose().
  @protected
  void disposeFloatAnimation() {
    _floatController.dispose();
  }

  /// The main float animation for listening/building.
  Animation<double> get floatAnimation => _floatAnimation;

  /// The rotation animation for listening/building.
  Animation<double> get rotationAnimation => _rotationAnimation;

  /// Current vertical offset in pixels (0 to amplitude).
  double get floatOffset {
    if (_reduceMotion) return 0;
    // Sine wave for smooth oscillation
    return math.sin(_floatAnimation.value * math.pi) *
        SneakerAnimations.floatAmplitude;
  }

  /// Current rotation in radians.
  double get floatRotationRadians {
    if (_reduceMotion) return 0;
    // Convert degrees to radians, apply sine wave
    final degrees = math.sin(_rotationAnimation.value * math.pi) *
        SneakerAnimations.floatRotation;
    return degrees * (math.pi / 180);
  }

  /// Whether reduce motion is active.
  bool get isReduceMotion => _reduceMotion;
}

/// **FloatingWidget**
///
/// Convenience widget that applies float animation to its child.
/// Use this when you don't need custom animation control.
///
/// **Usage:**
/// ```dart
/// FloatingWidget(
///   child: Image.network(sneaker.imageUrl),
/// )
/// ```
class FloatingWidget extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Whether to enable the animation. Defaults to true.
  final bool enabled;

  /// Custom amplitude in pixels. Defaults to design spec (3px).
  final double? amplitude;

  /// Custom rotation in degrees. Defaults to design spec (0.5 degrees).
  final double? rotation;

  const FloatingWidget({
    required this.child,
    this.enabled = true,
    this.amplitude,
    this.rotation,
    super.key,
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with TickerProviderStateMixin, FloatAnimationMixin {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      initFloatAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.enabled) {
      checkReducedMotion();
    }
  }

  @override
  void didUpdateWidget(FloatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        initFloatAnimation();
        checkReducedMotion();
      } else {
        disposeFloatAnimation();
      }
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      disposeFloatAnimation();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || isReduceMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        final amp = widget.amplitude ?? SneakerAnimations.floatAmplitude;
        final rot = widget.rotation ?? SneakerAnimations.floatRotation;

        final offset = math.sin(floatAnimation.value * math.pi) * amp;
        final rotation =
            math.sin(rotationAnimation.value * math.pi) * rot * (math.pi / 180);

        return Transform.translate(
          offset: Offset(0, offset),
          child: Transform.rotate(
            angle: rotation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
