import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// **HoverLift**
///
/// Widget wrapper that adds a lift effect on hover/touch.
/// Creates an elevated, interactive feel for product cards and buttons.
///
/// **Specs from design doc:**
/// - Duration: 150ms
/// - Curve: Curves.easeOut
/// - Scale: 1.0 -> 1.02
/// - TranslateY: 0 -> -8px
/// - Optional rotation: 0 -> 3 degrees
///
/// **Usage:**
/// ```dart
/// HoverLift(
///   child: SneakerCard(sneaker: sneaker),
///   onTap: () => navigateToDetail(sneaker),
/// )
///
/// // With rotation effect
/// HoverLift(
///   enableRotation: true,
///   child: SneakerCard(sneaker: sneaker),
///   onTap: () => navigateToDetail(sneaker),
/// )
/// ```
class HoverLift extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Callback when long pressed.
  final VoidCallback? onLongPress;

  /// Whether to enable subtle rotation on hover. Defaults to false.
  final bool enableRotation;

  /// Animation duration. Defaults to 150ms.
  final Duration duration;

  /// Scale factor when hovered. Defaults to 1.02.
  final double scale;

  /// Vertical translation when hovered. Defaults to -8px.
  final double translateY;

  /// Rotation in degrees when hovered (if enabled). Defaults to 3 degrees.
  final double rotation;

  /// Custom cursor on hover.
  final MouseCursor cursor;

  const HoverLift({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enableRotation = false,
    this.duration = SneakerAnimations.fast,
    this.scale = SneakerAnimations.hoverScale,
    this.translateY = SneakerAnimations.hoverTranslateY,
    this.rotation = SneakerAnimations.hoverRotation,
    this.cursor = SystemMouseCursors.click,
    super.key,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  late Animation<double> _rotationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SneakerAnimations.standard,
    ));

    _translateAnimation = Tween<double>(
      begin: 0,
      end: widget.translateY,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SneakerAnimations.standard,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.enableRotation ? widget.rotation : 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SneakerAnimations.standard,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  @override
  void didUpdateWidget(HoverLift oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.scale != oldWidget.scale ||
        widget.translateY != oldWidget.translateY ||
        widget.rotation != oldWidget.rotation ||
        widget.enableRotation != oldWidget.enableRotation) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scale,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: SneakerAnimations.standard,
      ));

      _translateAnimation = Tween<double>(
        begin: 0,
        end: widget.translateY,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: SneakerAnimations.standard,
      ));

      _rotationAnimation = Tween<double>(
        begin: 0,
        end: widget.enableRotation ? widget.rotation : 0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: SneakerAnimations.standard,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter(PointerEvent event) {
    if (_reduceMotion) return;
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onHoverExit(PointerEvent event) {
    if (_reduceMotion) return;
    setState(() => _isHovered = false);
    if (!_isPressed) {
      _controller.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (_reduceMotion) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    if (!_isHovered) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? widget.cursor : MouseCursor.defer,
      onEnter: _onHoverEnter,
      onExit: _onHoverExit,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_reduceMotion) {
              return child!;
            }

            final rotationRadians =
                _rotationAnimation.value * (math.pi / 180);

            return Transform.translate(
              offset: Offset(0, _translateAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: rotationRadians,
                  child: child,
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
