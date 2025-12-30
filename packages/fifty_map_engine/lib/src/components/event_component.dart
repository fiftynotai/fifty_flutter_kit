import 'dart:math' as math;
import 'package:flame/image_composition.dart' as image;

import 'package:fifty_map_engine/src/components/base/component.dart';
import 'package:fifty_map_engine/src/components/base/extension.dart';
import 'package:fifty_map_engine/src/components/base/priority.dart';
import 'package:fifty_map_engine/src/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import 'base/model.dart';

/// **Component for displaying event markers above map entities**
///
/// Renders an icon and text for various events (NPCs, quest points, boss alerts),
/// positioned relative to its parent or at absolute coordinates for standalone events.
///
/// **Key Features:**
/// - Icon selection based on [model.event.eventType]
/// - Optional size adjustment for `basic` events
/// - Text overlay using [TextComponent]
/// - Rotation via [model.quarterTurns]
/// - Positioning via [FiftyEventAlignment] or absolute coords
/// - Tap handling that forwards a cloned [FiftyMapEntity]
/// - `moveWithParent` to stay in sync when parent moves
///
/// **Usage:** Automatically added by [FiftyBaseComponent] when `model.event != null`.
class FiftyEventComponent extends FiftyBaseComponent {
  /// **Creates an event marker component.**
  ///
  /// - [model]: must have a non-null `model.event`.
  FiftyEventComponent({required super.model});

  @override
  Future<void> onLoad() async {
    // Anchor & draw order
    anchor = Anchor.center;
    priority = FiftyRenderPriority.event;

    // Icon selection & optional sizing
    image.Image iconImage;
    if (model.event!.type == FiftyEventType.basic) {
      // half-size for basic events
      size = Vector2(size.x * 0.5, size.y);
      iconImage = game.images.fromCache('events/basic.png');
    } else if (model.event!.type == FiftyEventType.npc) {
      iconImage = game.images.fromCache('events/npc.png');
    } else {
      iconImage = game.images.fromCache('events/master_of_shadow.png');
    }
    sprite = Sprite(iconImage);

    // Text overlay
    add(
      TextComponent(
        text: model.event!.text,
        anchor: Anchor.center,
        position: Vector2(size.x * 0.5, size.y * 0.55),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    // Rotation
    if (model.quarterTurns > 0) {
      angle = model.quarterTurns * (math.pi / 2);
    }

    // Positioning
    if (model.isEvent) {
      // absolute event
      position = Vector2(model.x, game.size.y - model.y);
      anchor = Anchor.bottomLeft;
      // Apply rotation if needed
      if (model.quarterTurns > 0) {
        angle = model.quarterTurns * (math.pi / 2);
        final offset =
            FiftyMapUtils.getPositionAfterRotation(model.quarterTurns, model.size);
        if (offset != null) {
          position.add(offset);
        }
      }
    } else {
      // anchored to parent entity
      final aligned = FiftyMapUtils.getAlignedPosition(
        base: model.position,
        parentSize: model.size,
        alignment: model.event!.alignment,
        quarterTurns: model.quarterTurns,
      );
      position = Vector2(aligned.x, game.size.y - aligned.y);
    }

    // Hitbox for taps/collisions
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Forward a fresh clone to avoid mutating original
    final cloned = FiftyMapEntity.fromJson(model.toJson());
    cloned.event!.clicked = true;
    game.onEntityTap.call(cloned);
  }

  /// **Synchronizes this marker's position when its parent moves.**
  ///
  /// - [newModel]: the parent's updated model.
  void moveWithParent(FiftyMapEntity newModel) {
    final aligned = FiftyMapUtils.getAlignedPosition(
      base: newModel.position,
      parentSize: model.size,
      alignment: model.event!.alignment,
      quarterTurns: model.quarterTurns,
    );
    position = Vector2(aligned.x, game.size.y - aligned.y);
  }
}
