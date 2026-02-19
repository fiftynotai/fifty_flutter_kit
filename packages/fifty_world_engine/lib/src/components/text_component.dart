import 'dart:math' as math;
import 'package:fifty_world_engine/src/components/base/priority.dart';
import 'package:fifty_world_engine/src/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'base/model.dart';

/// **Component for displaying text overlays above map entities**
///
/// Renders text for various entities (rooms, markers, etc.),
/// positioned relative to its parent or at absolute coordinates.
///
/// **Key Features:**
/// - Text overlay using [TextComponent]
/// - Rotation via [model.quarterTurns]
/// - Positioning via [FiftyEventAlignment.center] or absolute coords
/// - `moveWithParent` to stay in sync when parent moves
///
/// **Usage:** Automatically added by [FiftyBaseComponent] when `model.text != null`.
class FiftyTextComponent extends TextComponent {
  final FiftyWorldEntity model;

  /// **Creates a text overlay component.**
  ///
  /// - [model]: must have a non-null `model.text`.
  FiftyTextComponent({required this.model});

  @override
  Future<void> onLoad() async {
    // Anchor & draw order
    anchor = Anchor.center;
    priority = FiftyRenderPriority.uiOverlay;

    // Text overlay
    add(
      TextComponent(
        text: model.text,
        anchor: Anchor.center,
        position: Vector2(size.x * 0.5, size.y * 0.55),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF039DA3),
            shadows: [
              Shadow(
                  offset: Offset(-2, -2), blurRadius: 2, color: Colors.white),
              Shadow(offset: Offset(2, -2), blurRadius: 2, color: Colors.white),
              Shadow(offset: Offset(2, 2), blurRadius: 2, color: Colors.white),
              Shadow(offset: Offset(-2, 2), blurRadius: 2, color: Colors.white),
            ],
          ),
        ),
      ),
    );

    // Rotation
    if (model.quarterTurns > 0) {
      angle = model.quarterTurns * (math.pi / 2);
    }

    // Positioning - anchored to parent entity
    final aligned = FiftyWorldUtils.getAlignedPosition(
      base: model.position,
      parentSize: model.size,
      alignment: FiftyEventAlignment.center,
      quarterTurns: model.quarterTurns,
    );
    position = Vector2(aligned.x, findGame()!.size.y - aligned.y);

    // Hitbox for taps/collisions
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  /// **Synchronizes this marker's position when its parent moves.**
  ///
  /// - [newModel]: the parent's updated model.
  void moveWithParent(FiftyWorldEntity newModel) {
    final aligned = FiftyWorldUtils.getAlignedPosition(
      base: newModel.position,
      parentSize: model.size,
      alignment: model.event!.alignment,
      quarterTurns: model.quarterTurns,
    );
    position = Vector2(aligned.x, findGame()!.size.y - aligned.y);
  }
}
