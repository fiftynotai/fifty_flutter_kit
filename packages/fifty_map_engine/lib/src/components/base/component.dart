import 'dart:math' as math;
import 'package:fifty_map_engine/src/components/base/extension.dart';
import 'package:fifty_map_engine/src/components/base/priority.dart';
import 'package:fifty_map_engine/src/components/event_component.dart';
import 'package:fifty_map_engine/src/components/text_component.dart';
import 'package:fifty_map_engine/src/config/map_config.dart';
import 'package:fifty_map_engine/src/view/map_builder.dart';
import 'package:fifty_map_engine/src/utils/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'model.dart';

/// **Abstract base for all map entity components**
///
/// Manages sprite loading, positioning, rotation, hitboxes, z-index priorities,
/// tap interactions, optional event markers, and in-game text overlays.
///
/// **Key Features:**
/// - Loads sprite from [model.asset]
/// - Calculates pixel [position] (top-down coordinates) and applies [quarterTurns]
/// - Sets [priority] via [model.zIndex] or default type priorities
/// - Attaches a [RectangleHitbox] for passive collisions
/// - Spawns a [FiftyEventComponent] if [model.event] is present
/// - Renders a [FiftyTextComponent] if [model.text] is non-null
/// - Forwards taps through [TapCallbacks] to the game's tap handler
///
/// **Subclasses must implement:**
/// - [spawnChild]: hook for adding nested children (rooms, furniture, etc.)
abstract class FiftyBaseComponent extends SpriteComponent
    with HasGameReference<FiftyMapBuilder>, TapCallbacks {
  /// Underlying model describing tile, asset, and metadata
  FiftyMapEntity model;

  /// Optional event overlay component
  FiftyEventComponent? eventComponent;

  /// Optional event overlay component
  FiftyTextComponent? textComponent;

  /// **Creates a base component for a map entity.**
  ///
  /// - [model]: the data model to render and interact with.
  FiftyBaseComponent({
    required this.model,
  }) : super(
          size: model.size,
          anchor: Anchor.bottomLeft,
        );

  @override
  Future<void> onLoad() async {
    // Set render priority
    if (model.zIndex != 0) {
      priority = model.zIndex;
    } else if (model.isFurniture) {
      priority = FiftyRenderPriority.furniture;
    } else if (model.isMonster) {
      priority = FiftyRenderPriority.monster;
    } else if (model.isCharacter) {
      priority = FiftyRenderPriority.character;
    } else {
      priority = FiftyRenderPriority.event;
    }

    // Load sprite (skip if no asset registered)
    if (model.asset.isNotEmpty) {
      sprite = Sprite(game.images.fromCache(model.asset));
    }

    // Calculate position (top-down coordinates, no Y-flip)
    position = Vector2(model.x, model.y);

    // Apply rotation if needed
    if (model.quarterTurns > 0) {
      angle = model.quarterTurns * (math.pi / 2);
      final offset =
          FiftyMapUtils.getPositionAfterRotation(model.quarterTurns, model.size);
      if (offset != null) {
        position.add(offset);
      }
    }

    // Add hitbox for passive collisions
    add(RectangleHitbox(collisionType: CollisionType.passive));

    // Spawn event marker if applicable (event components don't spawn child events)
    if (model.event != null && this is! FiftyEventComponent) {
      eventComponent = FiftyEventComponent(model: model);
      game.world.add(eventComponent!);
    }

    // Spawn text marker if applicable
    if (model.text != null) {
      textComponent = FiftyTextComponent(model: model);
      game.world.add(textComponent!);
    }

    // Hook for subclasses to add nested children
    spawnChild(model);
  }

  @override
  void onRemove() {
    // Clean up event component
    if (eventComponent != null) {
      game.world.remove(eventComponent!);
    }
    // Clean up text component
    if (textComponent != null) {
      game.world.remove(textComponent!);
    }
    super.onRemove();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.onEntityTap.call(model);
  }

  /// **Hook to spawn nested child entities**
  ///
  /// Override in subclasses (e.g. room component) to add
  /// child components based on [model.components].
  void spawnChild(FiftyMapEntity child) {}
}

/// **Component for static, non-moving entities**
///
/// Renders doors, furniture, and other immovable objects.
/// Inherits all base behaviors, no additional logic.
class FiftyStaticComponent extends FiftyBaseComponent {
  /// **Creates a static entity component.**
  FiftyStaticComponent({required super.model});
}

/// **Component for movable entities (characters, monsters)**
///
/// Extends [FiftyBaseComponent] with movement, attack, death, and sprite-swap
/// capabilities.
///
/// **Key Features:**
/// - Smooth movement [moveTo], [moveUp], [moveDown], [moveLeft], [moveRight]
/// - Attack bounce animation via [attack]
/// - Fade-out death and removal via [die]
/// - Dynamic sprite updates via [swapSprite]
class FiftyMovableComponent extends FiftyBaseComponent {
  /// **Creates a movable entity component.**
  FiftyMovableComponent({required super.model});

  /// **Moves the entity to [newPosition] over time.**
  ///
  /// - [newPosition]: target pixel position
  /// - [newModel]: updated model for event sync
  /// - [speed]: pixels per second (default 200)
  void moveTo(Vector2 newPosition, FiftyMapEntity newModel,
      {double speed = 200}) {
    model = newModel;
    final distance = newPosition.distanceTo(position);
    final duration = distance / speed;
    add(
      MoveToEffect(
        newPosition,
        EffectController(duration: duration, curve: Curves.easeInOut),
      ),
    );
    eventComponent?.moveWithParent(newModel);
  }

  /// **Direct movement without child sync.**
  void _directMove(Vector2 newPosition, {double speed = 200}) {
    final distance = newPosition.distanceTo(position);
    final duration = distance / speed;
    add(
      MoveToEffect(
        newPosition,
        EffectController(duration: duration, curve: Curves.easeInOut),
      ),
    );
  }

  /// **Moves the entity up by [steps] grid blocks.**
  ///
  /// - [steps]: number of tiles to move
  /// - [speed]: pixels per second
  void moveUp(double steps, {double speed = 200}) {
    model.gridPosition.y = model.gridPosition.y - steps;
    final newPosition =
        Vector2(position.x, position.y - (steps * FiftyMapConfig.blockSize));
    _directMove(newPosition, speed: speed);
  }

  /// **Moves the entity down by [steps] grid blocks.**
  void moveDown(double steps, {double speed = 200}) {
    model.gridPosition.y = model.gridPosition.y + steps;
    final newPosition =
        Vector2(position.x, position.y + (steps * FiftyMapConfig.blockSize));
    _directMove(newPosition, speed: speed);
  }

  /// **Moves the entity right by [steps] grid blocks.**
  void moveRight(double steps, {double speed = 200}) {
    model.gridPosition.x = model.gridPosition.x + steps;
    final newPosition =
        Vector2(position.x + (steps * FiftyMapConfig.blockSize), position.y);
    _directMove(newPosition, speed: speed);
  }

  /// **Moves the entity left by [steps] grid blocks.**
  void moveLeft(double steps, {double speed = 200}) {
    model.gridPosition.x = model.gridPosition.x - steps;
    final newPosition =
        Vector2(position.x - (steps * FiftyMapConfig.blockSize), position.y);
    _directMove(newPosition, speed: speed);
  }

  /// **Plays a bounce animation to simulate an attack.**
  ///
  /// - [onComplete]: called after animation finishes.
  void attack({VoidCallback? onComplete}) {
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2(1.2, 1.2),
            EffectController(duration: 0.1, curve: Curves.easeOut)),
        ScaleEffect.to(Vector2(1.0, 1.0),
            EffectController(duration: 0.1, curve: Curves.easeIn)),
      ]),
    );
    if (onComplete != null) {
      Future.delayed(const Duration(milliseconds: 200), onComplete);
    }
  }

  /// **Fades out and removes the entity (death animation).**
  ///
  /// - [onComplete]: called after removal.
  void die({VoidCallback? onComplete}) {
    add(
      SequenceEffect([
        OpacityEffect.to(
            0.0, EffectController(duration: 0.5, curve: Curves.easeIn)),
        RemoveEffect(),
      ]),
    );
    if (onComplete != null) {
      Future.delayed(const Duration(milliseconds: 500), onComplete);
    }
  }

  /// **Swaps this entity's sprite at runtime.**
  ///
  /// - [path]: asset key preloaded in Flame's image cache.
  Future<void> swapSprite(String path) async {
    sprite = Sprite(game.images.fromCache(path));
  }
}
