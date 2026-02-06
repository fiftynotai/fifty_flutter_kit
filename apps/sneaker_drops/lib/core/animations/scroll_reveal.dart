import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// **ScrollReveal**
///
/// Widget that fades in and slides up when it enters the viewport.
/// Creates a cascading reveal effect for grid items and lists.
///
/// **Specs from design doc:**
/// - Duration: 300ms
/// - Curve: Curves.easeOut (springy)
/// - Initial translateY: 24px
/// - Initial opacity: 0
/// - Final translateY: 0
/// - Final opacity: 1
///
/// **Usage:**
/// ```dart
/// // Single item
/// ScrollReveal(
///   child: SneakerCard(sneaker: sneaker),
/// )
///
/// // Grid with staggered delays
/// GridView.builder(
///   itemBuilder: (context, index) => ScrollReveal(
///     delay: Duration(milliseconds: 50 * index),
///     child: SneakerCard(sneaker: sneakers[index]),
///   ),
/// )
/// ```
class ScrollReveal extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Delay before starting the animation. Useful for staggered reveals.
  final Duration delay;

  /// Animation duration. Defaults to 300ms.
  final Duration duration;

  /// Animation curve. Defaults to easeOut.
  final Curve curve;

  /// Initial vertical offset. Defaults to 24px.
  final double initialOffset;

  /// Whether the animation should only play once. Defaults to true.
  final bool playOnce;

  const ScrollReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = SneakerAnimations.medium,
    this.curve = SneakerAnimations.standard,
    this.initialOffset = SneakerAnimations.scrollRevealOffset,
    this.playOnce = true,
    super.key,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  bool _hasPlayed = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _translateAnimation = Tween<double>(
      begin: widget.initialOffset,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    _startAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // If reduce motion is enabled, complete immediately
    if (_reduceMotion && !_hasPlayed) {
      _controller.value = 1.0;
      _hasPlayed = true;
    }
  }

  @override
  void didUpdateWidget(ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.initialOffset != oldWidget.initialOffset ||
        widget.curve != oldWidget.curve) {
      _opacityAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));

      _translateAnimation = Tween<double>(
        begin: widget.initialOffset,
        end: 0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
    }
  }

  Future<void> _startAnimation() async {
    if (_reduceMotion) {
      _controller.value = 1.0;
      _hasPlayed = true;
      return;
    }

    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }

    if (mounted && (!_hasPlayed || !widget.playOnce)) {
      _controller.forward();
      _hasPlayed = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// **ScrollRevealList**
///
/// Convenience widget for creating staggered scroll reveal animations
/// in a list or grid context.
///
/// **Usage:**
/// ```dart
/// ScrollRevealList(
///   staggerDelay: Duration(milliseconds: 50),
///   children: sneakers.map((s) => SneakerCard(sneaker: s)).toList(),
/// )
/// ```
class ScrollRevealList extends StatelessWidget {
  /// Children to reveal with staggered animation.
  final List<Widget> children;

  /// Delay between each child's animation start.
  final Duration staggerDelay;

  /// Animation duration for each child.
  final Duration duration;

  /// Animation curve for each child.
  final Curve curve;

  /// Initial vertical offset for each child.
  final double initialOffset;

  const ScrollRevealList({
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.duration = SneakerAnimations.medium,
    this.curve = SneakerAnimations.standard,
    this.initialOffset = SneakerAnimations.scrollRevealOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(children.length, (index) {
        return ScrollReveal(
          delay: staggerDelay * index,
          duration: duration,
          curve: curve,
          initialOffset: initialOffset,
          child: children[index],
        );
      }),
    );
  }
}
