/// Animated Unit Sprite
///
/// A [StatefulWidget] that wraps a [UnitSpriteWidget] with animation
/// transforms driven by an [AnimationEvent]. Supports three animation
/// types:
///
/// - **Move** (300ms): Slides the sprite from one tile to another using
///   [Curves.easeInOutCubic].
/// - **Attack** (400ms): Lunges 30% of [tileSize] toward the target and
///   returns, using a two-phase ease-out / ease-in curve.
/// - **Defeat** (500ms): Fades out, scales down to 50%, and rotates
///   slightly using [Curves.easeInBack].
///
/// The widget is positioned at (0, 0) in the animation overlay and uses
/// [Transform.translate] with the animated offset to position itself.
/// When the animation completes, [onComplete] is invoked so the
/// [AnimationService] can mark the event as finished.
///
/// **Usage:**
/// ```dart
/// AnimatedUnitSprite(
///   event: moveEvent,
///   unit: movingUnit,
///   tileSize: 48.0,
///   onComplete: () => animService.completeAnimation(moveEvent.id),
/// )
/// ```
library;

import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/unit.dart';
import '../../services/animation_service.dart';
import 'unit_sprite_widget.dart';

/// Animated sprite wrapper that applies move, attack, or defeat
/// transforms to a [UnitSpriteWidget] based on the given [event] type.
///
/// Uses a single [AnimationController] with [SingleTickerProviderStateMixin].
/// The controller auto-plays on mount and calls [onComplete] when finished.
class AnimatedUnitSprite extends StatefulWidget {
  /// The animation event describing the type, positions, and duration.
  final AnimationEvent event;

  /// The unit being animated.
  final Unit unit;

  /// Tile size in logical pixels (used for position calculations).
  final double tileSize;

  /// Called when the animation finishes playback.
  final VoidCallback onComplete;

  /// Creates an [AnimatedUnitSprite].
  const AnimatedUnitSprite({
    required this.event,
    required this.unit,
    required this.tileSize,
    required this.onComplete,
    super.key,
  });

  @override
  State<AnimatedUnitSprite> createState() => _AnimatedUnitSpriteState();
}

class _AnimatedUnitSpriteState extends State<AnimatedUnitSprite>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.event.duration,
      vsync: this,
    );
    _controller.forward().then((_) => widget.onComplete());
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
        return switch (widget.event.type) {
          AnimationType.move => _buildMoveAnimation(child!),
          AnimationType.attack => _buildAttackAnimation(child!),
          AnimationType.defeat => _buildDefeatAnimation(child!),
          AnimationType.damage => child!,
        };
      },
      child: UnitSpriteWidget(
        unit: widget.unit,
        tileSize: widget.tileSize,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Move Animation
  // ---------------------------------------------------------------------------

  /// Slides the sprite from [event.fromPosition] to [event.toPosition].
  ///
  /// Pixel offset is computed as the grid-cell delta multiplied by
  /// [tileSize], then interpolated with [Curves.easeInOutCubic].
  Widget _buildMoveAnimation(Widget child) {
    final from = widget.event.fromPosition!;
    final to = widget.event.toPosition!;
    final dx = (to.x - from.x) * widget.tileSize;
    final dy = (to.y - from.y) * widget.tileSize;

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    final offset = Offset(dx * curved.value, dy * curved.value);

    return Transform.translate(
      offset: offset,
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Attack Animation
  // ---------------------------------------------------------------------------

  /// Lunges the sprite 30% of [tileSize] toward the target, then returns.
  ///
  /// Phase 1 (0.0 - 0.5): Ease-out lunge toward the normalized direction
  /// of (fromPosition -> toPosition).
  /// Phase 2 (0.5 - 1.0): Ease-in return to the original position.
  Widget _buildAttackAnimation(Widget child) {
    final from = widget.event.fromPosition!;
    final to = widget.event.toPosition!;

    // Normalized direction toward target.
    final rawDx = (to.x - from.x).toDouble();
    final rawDy = (to.y - from.y).toDouble();
    final magnitude = sqrt(rawDx * rawDx + rawDy * rawDy);
    final dirX = magnitude > 0 ? rawDx / magnitude : 0.0;
    final dirY = magnitude > 0 ? rawDy / magnitude : 0.0;

    final lungeDistance = widget.tileSize * 0.3;

    // Two-phase progress: lunge forward then return.
    double progress;
    if (_controller.value <= 0.5) {
      progress = Curves.easeOut.transform(_controller.value * 2);
    } else {
      progress = Curves.easeIn.transform(1.0 - (_controller.value - 0.5) * 2);
    }

    final offset = Offset(
      dirX * lungeDistance * progress,
      dirY * lungeDistance * progress,
    );

    return Transform.translate(
      offset: offset,
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Defeat Animation
  // ---------------------------------------------------------------------------

  /// Fades out, scales down, and rotates the sprite slightly.
  ///
  /// - Opacity: 1.0 -> 0.0
  /// - Scale: 1.0 -> 0.5
  /// - Rotation: 0 -> 0.1 radians
  Widget _buildDefeatAnimation(Widget child) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInBack,
    );

    final opacity = (1.0 - curved.value).clamp(0.0, 1.0);
    final scale = 1.0 - (curved.value * 0.5);
    final rotation = curved.value * 0.1;

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: rotation,
          child: child,
        ),
      ),
    );
  }
}
