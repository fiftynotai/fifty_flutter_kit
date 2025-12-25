import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// RGB chromatic aberration (glitch) effect.
///
/// Creates an RGB channel split effect with configurable:
/// - Offset amount (2-4px recommended)
/// - Trigger on hover
/// - Intensity (0.0-1.0)
///
/// The effect respects reduced-motion accessibility settings.
///
/// Uses ColorFiltered for channel separation instead of shaders
/// for broader compatibility.
///
/// Example:
/// ```dart
/// GlitchEffect(
///   triggerOnHover: true,
///   intensity: 0.8,
///   child: Text('GLITCH'),
/// )
/// ```
class GlitchEffect extends StatefulWidget {
  /// Creates a glitch effect wrapper.
  const GlitchEffect({
    super.key,
    required this.child,
    this.triggerOnHover = false,
    this.triggerOnMount = false,
    this.intensity = 1.0,
    this.offset = 3.0,
    this.duration,
    this.enabled = true,
  });

  /// The widget to apply the glitch effect to.
  final Widget child;

  /// Whether to trigger the glitch effect on hover.
  final bool triggerOnHover;

  /// Whether to trigger the glitch effect when mounted.
  final bool triggerOnMount;

  /// Intensity of the glitch effect (0.0-1.0).
  ///
  /// Higher values create more visible channel separation.
  final double intensity;

  /// Pixel offset for channel separation.
  ///
  /// Recommended values: 2-4px.
  final double offset;

  /// Duration of the glitch animation cycle.
  ///
  /// Defaults to [FiftyMotion.compiling] (300ms).
  final Duration? duration;

  /// Whether the glitch effect is enabled.
  final bool enabled;

  @override
  State<GlitchEffect> createState() => _GlitchEffectState();
}

class _GlitchEffectState extends State<GlitchEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isGlitching = false;
  Timer? _glitchTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    if (widget.triggerOnMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerGlitch();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _glitchTimer?.cancel();
    super.dispose();
  }

  void _triggerGlitch() {
    if (!widget.enabled) return;

    setState(() => _isGlitching = true);

    // Random glitch pattern over the duration
    final duration = widget.duration ?? const Duration(milliseconds: 300);
    final endTime = DateTime.now().add(duration);

    void doGlitchFrame() {
      if (!mounted || DateTime.now().isAfter(endTime)) {
        setState(() => _isGlitching = false);
        return;
      }

      setState(() {});
      _glitchTimer = Timer(
        Duration(milliseconds: 30 + _random.nextInt(50)),
        doGlitchFrame,
      );
    }

    doGlitchFrame();
  }

  void _onHoverEnter() {
    if (widget.triggerOnHover) {
      _triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // If reduced motion or disabled, render without effect
    if (reduceMotion || !widget.enabled) {
      return widget.child;
    }

    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      child: _isGlitching ? _buildGlitchStack() : widget.child,
    );
  }

  Widget _buildGlitchStack() {
    final offsetAmount = widget.offset * widget.intensity;
    final redOffset = Offset(
      (_random.nextDouble() - 0.5) * offsetAmount * 2,
      (_random.nextDouble() - 0.5) * offsetAmount * 0.5,
    );
    final blueOffset = Offset(
      (_random.nextDouble() - 0.5) * offsetAmount * -2,
      (_random.nextDouble() - 0.5) * offsetAmount * 0.5,
    );

    return Stack(
      children: [
        // Red channel
        Transform.translate(
          offset: redOffset,
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              1, 0, 0, 0, 0, // Red
              0, 0, 0, 0, 0, // Green (zeroed)
              0, 0, 0, 0, 0, // Blue (zeroed)
              0, 0, 0, 0.3, 0, // Alpha
            ]),
            child: widget.child,
          ),
        ),
        // Blue channel
        Transform.translate(
          offset: blueOffset,
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0, 0, 0, 0, 0, // Red (zeroed)
              0, 0, 0, 0, 0, // Green (zeroed)
              0, 0, 1, 0, 0, // Blue
              0, 0, 0, 0.3, 0, // Alpha
            ]),
            child: widget.child,
          ),
        ),
        // Main content (full color)
        widget.child,
      ],
    );
  }
}
