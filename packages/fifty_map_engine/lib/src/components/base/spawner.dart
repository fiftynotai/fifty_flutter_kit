import 'package:fifty_map_engine/src/components/event_component.dart';
import 'package:fifty_map_engine/src/components/room_component.dart';
import 'package:fifty_map_engine/src/components/sprites/animated_entity_component.dart';
import 'package:fifty_map_engine/src/utils/logger.dart';
import 'component.dart';
import 'model.dart';
import 'extension.dart';

/// **Factory for spawning map entity components**
///
/// Converts a [FiftyMapEntity] into the appropriate [FiftyBaseComponent]
/// for rendering on the game map.
///
/// **Key Features:**
/// - **Native support** for rooms, monsters, characters, furniture, doors, events
/// - **Extensible** via [register] for custom types
/// - **Enum-safe** matching using [FiftyEntityType]
///
/// **Usage Example:**
/// ```dart
/// final component = FiftyEntitySpawner.spawn(entityModel);
/// game.world.add(component);
/// ```
///
/// **Registering Custom Entities:**
/// ```dart
/// FiftyEntitySpawner.register(
///   'trap',
///   (model) => TrapComponent(model: model),
/// );
/// ```
class FiftyEntitySpawner {
  /// Registry mapping raw string types to builder functions.
  static final Map<String, FiftyBaseComponent Function(FiftyMapEntity)>
      _customSpawners = {};

  /// **Registers a custom builder for a new entity type.**
  ///
  /// - [type]: the raw string key (e.g., 'trap').
  /// - [builder]: returns a [FiftyBaseComponent] for the given model.
  static void register(
    String type,
    FiftyBaseComponent Function(FiftyMapEntity) builder,
  ) {
    _customSpawners[type] = builder;
  }

  /// **Spawns a component for the given [model].**
  ///
  /// Checks [_customSpawners] for overrides, otherwise matches
  /// [FiftyEntityType] to built-in components:
  /// - [FiftyEntityType.room] -> [FiftyRoomComponent]
  /// - [FiftyEntityType.monster], [FiftyEntityType.character] -> [FiftyMovableComponent]
  /// - [FiftyEntityType.furniture], [FiftyEntityType.door] -> [FiftyStaticComponent]
  /// - [FiftyEntityType.event] -> [FiftyEventComponent]
  ///
  /// Returns a [FiftyBaseComponent] ready to add to `game.world`.
  static FiftyBaseComponent spawn(FiftyMapEntity model) {
    // Custom override
    final customBuilder = _customSpawners[model.type];
    if (customBuilder != null) {
      return customBuilder(model);
    }

    // If sprite animation is configured, use AnimatedEntityComponent
    if (model.spriteAnimation != null) {
      return AnimatedEntityComponent(
        model: model,
        animConfig: model.spriteAnimation!,
      );
    }

    // Native type matching
    switch (model.entityType) {
      case FiftyEntityType.room:
        return FiftyRoomComponent(model: model);
      case FiftyEntityType.monster:
      case FiftyEntityType.character:
        return FiftyMovableComponent(model: model);
      case FiftyEntityType.furniture:
      case FiftyEntityType.door:
        return FiftyStaticComponent(model: model);
      case FiftyEntityType.event:
        return FiftyEventComponent(model: model);
      default:
        FiftyMapLogger.instance.warning(
          "Entity type '${model.type}' is not registered. "
          "Please register it via FiftyEntitySpawner.register() (see README), "
          "otherwise it will default to FiftyStaticComponent.",
        );
        return FiftyStaticComponent(model: model);
    }
  }
}
