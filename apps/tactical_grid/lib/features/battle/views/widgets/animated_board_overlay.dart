/// Animated Board Overlay
///
/// A [Stack]-based overlay rendered on top of the [GridView] board.
/// Observes [AnimationService.activeAnimations] and positions animated
/// unit sprites, damage popups, and defeat effects at their correct
/// pixel coordinates derived from grid positions and [tileSize].
///
/// Units that are being animated are hidden in the underlying [GridView]
/// (via [AnimationService.isUnitAnimating]) and shown here instead,
/// allowing smooth cross-tile movement without clipping artifacts.
///
/// **Supported animation types:**
/// - **Move:** Sprite slides from origin tile to destination tile.
/// - **Attack:** Sprite lunges toward the target direction and returns.
/// - **Damage:** Floating damage number rises and fades above the tile.
/// - **Defeat:** Sprite fades out with scale and rotation effects.
///
/// **Usage:**
/// ```dart
/// Stack(children: [
///   BoardGridView(...),
///   AnimatedBoardOverlay(tileSize: 48.0),
/// ])
/// ```
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/battle_view_model.dart';
import '../../services/animation_service.dart';
import 'animated_unit_sprite.dart';
import 'damage_popup.dart';

/// Overlay that renders active animation events above the board grid.
///
/// Each [AnimationEvent] in [AnimationService.activeAnimations] is
/// mapped to a positioned widget at the correct pixel offset. When an
/// animation completes, the widget calls [AnimationService.completeAnimation]
/// to remove the event and resolve its [Future].
class AnimatedBoardOverlay extends StatelessWidget {
  /// Side length of a single board tile in logical pixels.
  ///
  /// Used to convert grid coordinates to pixel positions.
  final double tileSize;

  /// Creates an [AnimatedBoardOverlay].
  const AnimatedBoardOverlay({required this.tileSize, super.key});

  @override
  Widget build(BuildContext context) {
    final animService = Get.find<AnimationService>();
    final viewModel = Get.find<BattleViewModel>();

    return Obx(() {
      final animations = animService.activeAnimations.toList();
      if (animations.isEmpty) return const SizedBox.shrink();

      return Stack(
        clipBehavior: Clip.none,
        children: [
          for (final event in animations)
            _buildAnimationWidget(event, animService, viewModel),
        ],
      );
    });
  }

  /// Builds the positioned widget for a single [AnimationEvent].
  ///
  /// Routes to the appropriate builder based on [AnimationEvent.type]:
  /// - [AnimationType.move]: Positioned at the FROM tile; the animation
  ///   translates to the TO tile.
  /// - [AnimationType.attack]: Positioned at the attacker's tile; the
  ///   animation lunges toward the target direction.
  /// - [AnimationType.damage]: Positioned at the target tile; shows a
  ///   floating damage number.
  /// - [AnimationType.defeat]: Positioned at the unit's last tile; plays
  ///   fade-out / scale-down / rotate effects.
  Widget _buildAnimationWidget(
    AnimationEvent event,
    AnimationService animService,
    BattleViewModel viewModel,
  ) {
    switch (event.type) {
      case AnimationType.move:
        final from = event.fromPosition!;
        final unit = viewModel.board.getUnitById(event.unitId);
        if (unit == null) return const SizedBox.shrink();

        return Positioned(
          left: from.x * tileSize,
          top: from.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: AnimatedUnitSprite(
              key: ValueKey(event.id),
              event: event,
              unit: unit,
              tileSize: tileSize,
              onComplete: () => animService.completeAnimation(event.id),
            ),
          ),
        );

      case AnimationType.attack:
        final from = event.fromPosition!;
        final unit = viewModel.board.getUnitById(event.unitId);
        if (unit == null) return const SizedBox.shrink();

        return Positioned(
          left: from.x * tileSize,
          top: from.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: AnimatedUnitSprite(
              key: ValueKey(event.id),
              event: event,
              unit: unit,
              tileSize: tileSize,
              onComplete: () => animService.completeAnimation(event.id),
            ),
          ),
        );

      case AnimationType.damage:
        final pos = event.toPosition!;

        return Positioned(
          left: pos.x * tileSize,
          top: pos.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: DamagePopup(
              key: ValueKey(event.id),
              damage: event.damageAmount ?? 0,
              tileSize: tileSize,
              onComplete: () => animService.completeAnimation(event.id),
            ),
          ),
        );

      case AnimationType.defeat:
        final pos = event.toPosition!;
        final unit = viewModel.board.getUnitById(event.unitId);
        if (unit == null) return const SizedBox.shrink();

        return Positioned(
          left: pos.x * tileSize,
          top: pos.y * tileSize,
          width: tileSize,
          height: tileSize,
          child: Center(
            child: AnimatedUnitSprite(
              key: ValueKey(event.id),
              event: event,
              unit: unit,
              tileSize: tileSize,
              onComplete: () => animService.completeAnimation(event.id),
            ),
          ),
        );
    }
  }
}
