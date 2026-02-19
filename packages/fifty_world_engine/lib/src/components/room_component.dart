import 'dart:math' as math;
import 'dart:ui';
import 'package:fifty_world_engine/src/components/base/component.dart';
import 'package:fifty_world_engine/src/components/base/priority.dart';
import 'package:fifty_world_engine/src/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/foundation.dart';
import 'base/model.dart';
import 'base/spawner.dart';
import 'base/extension.dart';
import 'text_component.dart';

/// **FiftyRoomComponent**
///
/// A visual container component representing a room segment on the map.
///
/// **Key Features:**
/// - Renders the room sprite at grid-aligned pixel coordinates via [model.asset]
/// - Calculates pixel [position] (flipped vertically) and applies [model.quarterTurns]
/// - Draws an optional red debug outline when [game.debugMode] is true
/// - Spawns nested child entities (furniture, characters, events) via [spawnChild]
/// - Renders a [FiftyTextComponent] overlay if [model.text] is non-null
///
/// **See also:**
/// - [FiftyBaseComponent]
/// - [FiftyWorldEntity]
class FiftyRoomComponent extends FiftyBaseComponent {
  /// **Creates a room component.**
  ///
  /// - [model]: the [FiftyWorldEntity] defining sprite, position, rotation, and children.
  FiftyRoomComponent({
    required super.model,
  });

  @override
  Future<void> onLoad() async {
    // Render priority
    priority = FiftyRenderPriority.background;

    // Load and assign sprite
    sprite = Sprite(game.images.fromCache(model.asset));

    // Calculate pixel position (flip Y-axis)
    position = Vector2(model.x, game.size.y - model.y);

    // Apply rotation if needed
    if (model.quarterTurns > 0) {
      angle = model.quarterTurns * (math.pi / 2);
      final offset =
          FiftyWorldUtils.getPositionAfterRotation(model.quarterTurns, size);
      if (offset != null) {
        position.add(offset);
      }
    }

    // Add passive hitbox
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Optional debug outline
    if (game.debugMode) {
      add(
        RectangleComponent(
          size: size,
          paint: Paint()
            ..color = const Color(0x44FF0000)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        ),
      );
    }

    // Spawn nested child entities
    for (final child in model.components) {
      spawnChild(child);
    }

    // Spawn text marker if applicable
    if (model.text != null) {
      textComponent = FiftyTextComponent(model: model);
      game.world.add(textComponent!);
    }
  }

  @override
  void spawnChild(FiftyWorldEntity child) {
    /// **Spawns a single child entity within this room.**
    ///
    /// - Copies [child] into global coords via `copyWithParent`
    /// - Uses [FiftyEntitySpawner] to create its component
    /// - Adds it to `game.world` and registers via `game.saveEntity`
    try {
      final absoluteChild = child.copyWithParent(model.position);
      final component = FiftyEntitySpawner.spawn(absoluteChild);
      game.world.add(component);
      game.saveEntity(child, component);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[FiftyRoomComponent] Failed to spawn child: ${child.id}');
        print(e);
        print(stackTrace);
      }
    }
  }
}
