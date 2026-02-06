import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **KineticHeadline**
///
/// Animated headline with staggered letter reveal.
///
/// Features:
/// - Each word fades in and slides up
/// - Staggered delay between words
/// - Optional glitch/flicker effect
///
/// **Usage:**
/// ```dart
/// KineticHeadline(
///   text: 'STEP INTO THE FUTURE',
///   staggerDelay: Duration(milliseconds: 150),
/// )
/// ```
class KineticHeadline extends StatefulWidget {
  /// The text to display with animation.
  final String text;

  /// Text style for the headline.
  final TextStyle? style;

  /// Delay between each word animation.
  final Duration staggerDelay;

  /// Animation duration for each word.
  final Duration animationDuration;

  /// Initial delay before animation starts.
  final Duration initialDelay;

  /// Whether to enable glitch effect. Defaults to false.
  final bool enableGlitch;

  /// Whether to auto-play the animation. Defaults to true.
  final bool autoPlay;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  /// Creates a [KineticHeadline] with the specified parameters.
  const KineticHeadline({
    required this.text,
    this.style,
    this.staggerDelay = const Duration(milliseconds: 150),
    this.animationDuration = SneakerAnimations.medium,
    this.initialDelay = Duration.zero,
    this.enableGlitch = false,
    this.autoPlay = true,
    this.onComplete,
    super.key,
  });

  @override
  State<KineticHeadline> createState() => KineticHeadlineState();
}

class KineticHeadlineState extends State<KineticHeadline>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late List<String> _words;

  bool _reduceMotion = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _initAnimations();

    if (widget.autoPlay) {
      _startAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (_reduceMotion && !_hasCompleted) {
      for (final controller in _controllers) {
        controller.value = 1.0;
      }
      _hasCompleted = true;
    }
  }

  @override
  void didUpdateWidget(KineticHeadline oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _disposeControllers();
      _words = widget.text.split(' ');
      _initAnimations();
      if (widget.autoPlay) {
        _startAnimation();
      }
    }
  }

  void _initAnimations() {
    _controllers = List.generate(
      _words.length,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: SneakerAnimations.standard,
        ),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: SneakerAnimations.enter,
        ),
      );
    }).toList();
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
  }

  /// Start the animation sequence.
  Future<void> _startAnimation() async {
    if (_reduceMotion) {
      for (final controller in _controllers) {
        controller.value = 1.0;
      }
      _hasCompleted = true;
      widget.onComplete?.call();
      return;
    }

    _hasCompleted = false;

    await Future.delayed(widget.initialDelay);

    for (var i = 0; i < _controllers.length; i++) {
      if (!mounted) return;

      _controllers[i].forward();

      if (i < _controllers.length - 1) {
        await Future.delayed(widget.staggerDelay);
      }
    }

    // Wait for last animation to complete
    await _controllers.last.forward().orCancel;
    _hasCompleted = true;
    widget.onComplete?.call();
  }

  /// Replay the animation from the beginning.
  Future<void> replay() async {
    for (final controller in _controllers) {
      controller.reset();
    }
    await _startAnimation();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? SneakerTypography.heroHeadline;

    if (_reduceMotion) {
      return Text(
        widget.text,
        style: baseStyle,
        textAlign: TextAlign.center,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(_words.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: widget.enableGlitch
                    ? _GlitchText(
                        text: _words[index],
                        style: baseStyle,
                        isAnimating: _controllers[index].isAnimating,
                      )
                    : child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(
              right: index < _words.length - 1 ? 8 : 0,
            ),
            child: Text(
              _words[index],
              style: baseStyle,
            ),
          ),
        );
      }),
    );
  }
}

/// Internal glitch effect widget.
class _GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool isAnimating;

  const _GlitchText({
    required this.text,
    required this.style,
    required this.isAnimating,
  });

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _glitchController;
  final _random = math.Random();
  double _glitchOffset = 0;
  Color _glitchColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _glitchController.addListener(_updateGlitch);
  }

  @override
  void didUpdateWidget(_GlitchText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startGlitching();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _stopGlitching();
    }
  }

  void _startGlitching() {
    _glitchController.repeat();
  }

  void _stopGlitching() {
    _glitchController.stop();
    setState(() {
      _glitchOffset = 0;
      _glitchColor = Colors.transparent;
    });
  }

  void _updateGlitch() {
    if (!mounted) return;
    setState(() {
      _glitchOffset = (_random.nextDouble() - 0.5) * 4;
      _glitchColor = _random.nextBool()
          ? SneakerColors.burgundy.withValues(alpha: 0.5)
          : SneakerColors.slateGrey.withValues(alpha: 0.5);
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glitch layer
        if (widget.isAnimating)
          Transform.translate(
            offset: Offset(_glitchOffset, 0),
            child: Text(
              widget.text,
              style: widget.style.copyWith(color: _glitchColor),
            ),
          ),
        // Main text
        Padding(
          padding: EdgeInsets.only(
            right: 8,
          ),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        ),
      ],
    );
  }
}
