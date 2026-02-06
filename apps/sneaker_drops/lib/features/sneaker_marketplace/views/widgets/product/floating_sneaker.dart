import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/animations/float_animation.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import 'sneaker_image.dart';

/// **FloatingSneaker**
///
/// Animated floating sneaker image with parallax effect.
/// Creates an ambient motion effect for hero sections and product displays.
///
/// **Features:**
/// - 3px vertical oscillation over 3 seconds
/// - Subtle rotation at peak (0.5 degrees)
/// - Animated shadow that softens on rise
/// - Parallax effect based on scroll position
///
/// **Usage:**
/// ```dart
/// FloatingSneaker(
///   imageUrl: sneaker.imageUrl,
///   size: 300,
///   parallaxFactor: 0.5,
/// )
/// ```
class FloatingSneaker extends StatefulWidget {
  /// URL of the sneaker image to display.
  final String imageUrl;

  /// Parallax movement factor (0.0 = no parallax, 1.0 = full parallax).
  /// Affects how much the sneaker moves based on scroll position.
  final double parallaxFactor;

  /// Size of the sneaker image (width and height).
  final double size;

  /// Whether to show the animated shadow. Defaults to true.
  final bool showShadow;

  /// Whether to enable the float animation. Defaults to true.
  final bool enableAnimation;

  /// Optional scroll controller for parallax effect.
  final ScrollController? scrollController;

  /// Creates a [FloatingSneaker] with the specified parameters.
  const FloatingSneaker({
    required this.imageUrl,
    this.parallaxFactor = 0.3,
    this.size = 200,
    this.showShadow = true,
    this.enableAnimation = true,
    this.scrollController,
    super.key,
  });

  @override
  State<FloatingSneaker> createState() => _FloatingSneakerState();
}

class _FloatingSneakerState extends State<FloatingSneaker>
    with TickerProviderStateMixin, FloatAnimationMixin {
  double _parallaxOffset = 0.0;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      initFloatAnimation();
    }
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.enableAnimation) {
      checkReducedMotion();
    }
  }

  @override
  void didUpdateWidget(FloatingSneaker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle scroll controller changes
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }

    // Handle animation enable/disable
    if (widget.enableAnimation != oldWidget.enableAnimation) {
      if (widget.enableAnimation) {
        initFloatAnimation();
        checkReducedMotion();
      } else {
        disposeFloatAnimation();
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    if (widget.enableAnimation) {
      disposeFloatAnimation();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    final position = widget.scrollController?.position;
    if (position == null) return;

    setState(() {
      _scrollPosition = position.pixels;
      // Calculate parallax offset based on scroll position
      // Clamp to prevent excessive movement
      _parallaxOffset =
          (_scrollPosition * widget.parallaxFactor * 0.1).clamp(-50.0, 50.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation || isReduceMotion) {
      return _buildStaticSneaker();
    }

    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        // Calculate animated shadow properties
        final shadowOffset = _calculateShadowOffset();
        final shadowBlur = _calculateShadowBlur();
        final shadowOpacity = _calculateShadowOpacity();

        return Transform.translate(
          offset: Offset(_parallaxOffset, floatOffset),
          child: Transform.rotate(
            angle: floatRotationRadians,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Animated shadow
                if (widget.showShadow)
                  Positioned(
                    bottom: -shadowOffset,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: widget.size * 0.6,
                        height: widget.size * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: SneakerRadii.radiusFull,
                          boxShadow: [
                            BoxShadow(
                              color: SneakerColors.darkBurgundy
                                  .withValues(alpha: shadowOpacity),
                              blurRadius: shadowBlur,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Sneaker image
                child!,
              ],
            ),
          ),
        );
      },
      child: SneakerImage(
        imageUrl: widget.imageUrl,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildStaticSneaker() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Static shadow
        if (widget.showShadow)
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.1,
                decoration: BoxDecoration(
                  borderRadius: SneakerRadii.radiusFull,
                  boxShadow: [
                    BoxShadow(
                      color: SneakerColors.darkBurgundy.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Sneaker image
        SneakerImage(
          imageUrl: widget.imageUrl,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  /// Calculate shadow offset based on float position.
  /// Shadow moves down as sneaker rises.
  double _calculateShadowOffset() {
    // Base offset + extra offset when floating up
    return 10 + (floatOffset.abs() * 2);
  }

  /// Calculate shadow blur based on float position.
  /// Shadow becomes more diffuse (larger blur) as sneaker rises.
  double _calculateShadowBlur() {
    // Base blur + extra blur when floating up
    return 20 + (floatOffset.abs() * 5);
  }

  /// Calculate shadow opacity based on float position.
  /// Shadow becomes lighter (less opaque) as sneaker rises.
  double _calculateShadowOpacity() {
    // Sine wave normalization: floatOffset goes from 0 to floatAmplitude
    final normalizedHeight = floatOffset.abs() / SneakerAnimations.floatAmplitude;
    // Base opacity - reduction based on height
    return math.max(0.2, 0.5 - (normalizedHeight * 0.3));
  }
}

/// Helper class to expose radii without additional import in this file.
class SneakerRadii {
  static const BorderRadius radiusFull =
      BorderRadius.all(Radius.circular(9999));
}
