import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated widget that displays an unlock effect around its child.
///
/// When triggered, shows:
/// - An expanding ring effect
/// - Particle burst (8 particles outward)
/// - Scale pulse on the child
///
/// **Example:**
/// ```dart
/// UnlockAnimationWidget(
///   onComplete: () => print('Unlock animation finished'),
///   color: Colors.amber,
///   child: SkillNodeWidget(...),
/// )
/// ```
class UnlockAnimationWidget extends StatefulWidget {
  /// Creates an unlock animation widget.
  ///
  /// **Parameters:**
  /// - [child]: The widget to animate around
  /// - [onComplete]: Callback when animation completes
  /// - [color]: Color for the animation effects (default gold)
  /// - [duration]: Total animation duration (default 600ms)
  const UnlockAnimationWidget({
    super.key,
    required this.child,
    this.onComplete,
    this.color = const Color(0xFFFFD700),
    this.duration = const Duration(milliseconds: 600),
  });

  /// The widget to animate around.
  final Widget child;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  /// Color for the animation effects.
  final Color color;

  /// Total animation duration.
  final Duration duration;

  @override
  State<UnlockAnimationWidget> createState() => _UnlockAnimationWidgetState();
}

class _UnlockAnimationWidgetState extends State<UnlockAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ringAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Ring expands from 0 to 1.5x in the first 60% of animation
    _ringAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Particles animate throughout
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Scale pulses from 1.0 to 1.2 and back
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    // Opacity fades out in the last 40%
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
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
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Expanding ring
            if (_ringAnimation.value > 0)
              Positioned.fill(
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: _ringAnimation.value,
                    opacity: _opacityAnimation.value,
                    color: widget.color,
                  ),
                ),
              ),

            // Particles
            if (_particleAnimation.value > 0)
              Positioned.fill(
                child: CustomPaint(
                  painter: _ParticlePainter(
                    progress: _particleAnimation.value,
                    opacity: _opacityAnimation.value,
                    color: widget.color,
                    particleCount: 8,
                  ),
                ),
              ),

            // Scaled child
            Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}

/// Paints an expanding ring.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.opacity,
    required this.color,
  });

  final double progress;
  final double opacity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 * progress;
    final strokeWidth = 3.0 * (1 - progress * 0.5);

    final paint = Paint()
      ..color = color.withAlpha((opacity * 255).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth.clamp(0.5, 3.0);

    canvas.drawCircle(center, maxRadius, paint);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return progress != oldDelegate.progress || opacity != oldDelegate.opacity;
  }
}

/// Paints particles bursting outward.
class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.progress,
    required this.opacity,
    required this.color,
    required this.particleCount,
  });

  final double progress;
  final double opacity;
  final Color color;
  final int particleCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxDistance = size.width * 0.8 * progress;
    final particleSize = 4.0 * (1 - progress * 0.5);

    final paint = Paint()
      ..color = color.withAlpha((opacity * 255 * 0.8).toInt())
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final distance = maxDistance * (0.5 + 0.5 * math.sin(progress * math.pi));

      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance;

      canvas.drawCircle(
        Offset(x, y),
        particleSize.clamp(1.0, 4.0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return progress != oldDelegate.progress || opacity != oldDelegate.opacity;
  }
}
