import 'package:flutter/material.dart';

/// An animated widget that applies a continuous pulse effect to its child.
///
/// Creates a subtle scaling and glow animation to draw attention to
/// available or interactive elements.
///
/// **Example:**
/// ```dart
/// PulseAnimationWidget(
///   enabled: node.state == SkillState.available,
///   color: Colors.blue,
///   child: SkillNodeWidget(...),
/// )
/// ```
class PulseAnimationWidget extends StatefulWidget {
  /// Creates a pulse animation widget.
  ///
  /// **Parameters:**
  /// - [child]: The widget to animate
  /// - [enabled]: Whether the animation is active (default true)
  /// - [color]: Color for the glow effect
  /// - [duration]: One cycle duration (default 2s)
  /// - [minScale]: Minimum scale factor (default 1.0)
  /// - [maxScale]: Maximum scale factor (default 1.05)
  const PulseAnimationWidget({
    super.key,
    required this.child,
    this.enabled = true,
    this.color = const Color(0xFF2196F3),
    this.duration = const Duration(seconds: 2),
    this.minScale = 1.0,
    this.maxScale = 1.05,
  });

  /// The widget to animate.
  final Widget child;

  /// Whether the animation is active.
  final bool enabled;

  /// Color for the glow effect.
  final Color color;

  /// One cycle duration.
  final Duration duration;

  /// Minimum scale factor.
  final double minScale;

  /// Maximum scale factor.
  final double maxScale;

  @override
  State<PulseAnimationWidget> createState() => _PulseAnimationWidgetState();
}

class _PulseAnimationWidgetState extends State<PulseAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimations();

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  void _setupAnimations() {
    // Scale animation: minScale -> maxScale -> minScale
    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Glow opacity: 0.0 -> 0.5 -> 0.0
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(PulseAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle enabled state changes
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }

    // Handle duration changes
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    // Handle scale changes
    if (widget.minScale != oldWidget.minScale ||
        widget.maxScale != oldWidget.maxScale) {
      _setupAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha((_glowAnimation.value * 128).toInt()),
                blurRadius: 12 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
