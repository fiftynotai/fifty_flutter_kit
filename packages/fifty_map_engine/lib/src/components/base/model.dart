import 'dart:convert';
import 'dart:developer';

import 'package:fifty_map_engine/src/animation/sprite_animation_config.dart';
import 'package:fifty_map_engine/src/components/base/extension.dart';
import 'package:fifty_map_engine/src/config/map_config.dart';
import 'package:flame/components.dart';

/// **Callback invoked when a map entity is tapped**
///
/// - [model]: the entity that was tapped.
/// - Returns void.
typedef FiftyMapTapCallback = void Function(FiftyMapEntity model);

/// **Enumerated types of in-game map events**
///
/// Used by [FiftyMapEvent] to indicate visual and logical event types
/// displayed above entities on the map.
///
/// **Types:**
/// - `basic`: Generic event with default icon
/// - `npc`: Denotes an NPC interaction
/// - `masterOfShadow`: Special boss or story event
enum FiftyEventType { basic, npc, masterOfShadow }

/// **Alignment for an event marker relative to its parent entity**
///
/// Used by [FiftyMapEvent.alignment] to determine where an event
/// icon or label should appear.
///
/// **Positioning Guide:**
/// ```
/// topLeft       topCenter       topRight
///     +--------------------+
///     |                    |
/// centerLeft   center   centerRight
///     |                    |
/// bottomLeft  bottomCenter  bottomRight
/// ```
///
/// **See also:**
/// - [FiftyEventAlignmentExtension.toShortString] for JSON serialization
/// **Default:** [FiftyEventAlignment.topLeft]
enum FiftyEventAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// **Event marker model attached to a map entity**
///
/// Represents metadata and type of an event that can be shown
/// above an entity (e.g. monster, room, object).
///
/// **Key Fields:**
/// - [text]: Text to display
/// - [type]: Icon/style type
/// - [alignment]: Anchor position
/// - [clicked]: Acknowledged state
///
/// **Used in:** [FiftyMapEntity.event]
class FiftyMapEvent {
  final String text;
  final FiftyEventType type;
  final FiftyEventAlignment alignment;
  bool clicked;

  /// **Creates an event marker for a map entity**
  ///
  /// - [text]: text shown above the entity
  /// - [type]: which icon/style to use
  /// - [alignment]: marker anchor (defaults to topLeft)
  /// - [clicked]: whether acknowledged (defaults to false)
  FiftyMapEvent({
    required this.text,
    required this.type,
    this.alignment = FiftyEventAlignment.topLeft,
    this.clicked = false,
  });

  /// **Parses an event marker from JSON.**
  ///
  /// Expects snake_case keys:
  /// `event_text`, `event_type`, `alignment`, `clicked`.
  factory FiftyMapEvent.fromJson(Map<String, dynamic> json) {
    return FiftyMapEvent(
      text: json['event_text'],
      type: FiftyEventType.values.firstWhere(
        (e) => e.toString().split('.').last == json['event_type'],
        orElse: () => FiftyEventType.basic,
      ),
      alignment: FiftyEventAlignmentExtension.fromString(json['alignment']),
      clicked: json['clicked'] as bool? ?? false,
    );
  }

  /// **Converts this event marker into JSON.**
  Map<String, dynamic> toJson() => {
        'event_text': text,
        'event_type': type.toString().split('.').last,
        'alignment': alignment.toShortString(),
        'clicked': clicked,
      };
}

/// **Model for a map entity in Fifty Map Engine**
///
/// Represents any game object on the board: rooms, characters,
/// monsters, furniture, doors, or overlays (events/text).
///
/// **Key Fields:**
/// - [id]: globally unique identifier
/// - [parentId]: optional parent id (null if root)
/// - [type]: one of [FiftyEntityType]
/// - [asset]: sprite path (e.g. 'assets/rooms/room1.png')
/// - [gridPosition]: tile coordinates (`Vector2(x, y)`)
/// - [x], [y]: pixel coords (derived or overridden)
/// - [zIndex]: render layer (higher = on top)
/// - [blockSize]: tile size (width x height)
/// - [quarterTurns]: rotation steps (0 = 0, 1 = 90, ...)
/// - [text]: optional overlay string
/// - [event]: optional [FiftyMapEvent]
/// - [components]: nested child entities
/// - [metadata]: free-form game data
///
/// **Computed:**
/// - [position]: pixel [Vector2]
/// - [size]: pixel dimensions
///
/// **Serialization:**
/// - `fromJson(...)` / `toJson()`
///
/// **Example:**
/// ```dart
/// final room = FiftyMapEntity(
///   id: 'room1',
///   type: FiftyEntityType.room.value,
///   asset: 'assets/rooms/room1.png',
///   gridPosition: Vector2(0, 0),
///   blockSize: FiftyBlockSize(4, 3),
/// );
/// ```
class FiftyMapEntity {
  final String id;
  final String? parentId;
  final String type;
  final String asset;
  final double x;
  final double y;
  final Vector2 gridPosition;
  final int zIndex;
  final FiftyBlockSize blockSize;
  final int quarterTurns;
  final String? text;
  final FiftyMapEvent? event;
  final List<FiftyMapEntity> components;
  final Map<String, dynamic>? metadata;

  /// Optional sprite sheet animation configuration.
  ///
  /// When set, the spawner uses [AnimatedEntityComponent] instead of
  /// [FiftyMovableComponent] to render this entity with frame-by-frame
  /// sprite animation.
  final SpriteAnimationConfig? spriteAnimation;

  /// **Creates a map entity.**
  ///
  /// - [id]: unique id
  /// - [parentId]: parent's id (optional)
  /// - [type]: entity type string
  /// - [asset]: sprite path
  /// - [gridPosition]: tile-based pos
  /// - [blockSize]: dims in tiles
  /// - [zIndex]: layering
  /// - [quarterTurns]: rotation steps
  /// - [text]: optional overlay text
  /// - [event]: optional marker
  /// - [components]: children
  /// - [metadata]: extra data
  /// - [x]/[y]: override pixel coords
  FiftyMapEntity({
    required this.id,
    this.parentId,
    required this.type,
    required this.asset,
    required this.gridPosition,
    this.zIndex = 0,
    required this.blockSize,
    this.quarterTurns = 0,
    this.text,
    this.event,
    this.components = const [],
    this.metadata,
    this.spriteAnimation,
    double? x,
    double? y,
  })  : x = x ?? gridPosition.x * FiftyMapConfig.blockSize,
        y = y ?? gridPosition.y * FiftyMapConfig.blockSize;

  /// Pixel position vector.
  Vector2 get position => Vector2(x, y);

  /// Pixel size vector.
  Vector2 get size => Vector2(
        blockSize.width * FiftyMapConfig.blockSize,
        blockSize.height * FiftyMapConfig.blockSize,
      );

  /// **Parses a map entity from JSON.**
  factory FiftyMapEntity.fromJson(Map<String, dynamic> json) {
    try {
      return FiftyMapEntity(
        id: json['id'] as String,
        parentId: json['parent_id'] as String?,
        type: json['type'] as String,
        asset: json['asset'] as String,
        gridPosition: Vector2(
          (json['grid_position']['x'] as num).toDouble(),
          (json['grid_position']['y'] as num).toDouble(),
        ),
        zIndex: json['z_index'] as int? ?? 0,
        blockSize:
            FiftyBlockSize.fromJson(json['size'] ?? {'width': 1.0, 'height': 1.0}),
        quarterTurns: json['quarter_turns'] ?? 0,
        text: json['text'] as String?,
        event: json['event'] != null
            ? FiftyMapEvent.fromJson(json['event'] as Map<String, dynamic>)
            : null,
        components: (json['components'] as List?)
                ?.map((e) => FiftyMapEntity.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    } catch (e) {
      log('Error parsing data: ${jsonEncode(json)}');
      rethrow;
    }
  }

  /// **Converts this entity into JSON.**
  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_id': parentId,
        'type': type,
        'asset': asset,
        'grid_position': {
          'x': gridPosition.x,
          'y': gridPosition.y,
        },
        'x': x,
        'y': y,
        'z_index': zIndex,
        'size': blockSize.toJson(),
        'quarter_turns': quarterTurns,
        'text': text,
        'event': event?.toJson(),
        'components': components.map((e) => e.toJson()).toList(),
        'metadata': metadata,
      };

  @override
  String toString() =>
      'FiftyMapEntity(id: $id, type: $type, position: $position, size: $size)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiftyMapEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          parentId == other.parentId &&
          type == other.type &&
          asset == other.asset &&
          gridPosition == other.gridPosition &&
          x == other.x &&
          y == other.y &&
          zIndex == other.zIndex &&
          size == other.size &&
          quarterTurns == other.quarterTurns;

  @override
  int get hashCode =>
      id.hashCode ^
      (parentId?.hashCode ?? 0) ^
      type.hashCode ^
      asset.hashCode ^
      gridPosition.hashCode ^
      x.hashCode ^
      y.hashCode ^
      zIndex.hashCode ^
      size.hashCode ^
      quarterTurns.hashCode;
}

/// **Recognized map entity types in Fifty Map Engine**
///
/// Safely categorizes each map entity for type-based logic.
///
/// **Supported values:**
/// - `room`
/// - `monster`
/// - `character`
/// - `door`
/// - `furniture`
/// - `event`
///
/// Use [FiftyEntityType.fromString] for parsing from raw strings (e.g., from JSON).
enum FiftyEntityType {
  room,
  monster,
  character,
  door,
  furniture,
  event,
  unknown;

  /// Returns a [FiftyEntityType] from lowercase string.
  /// Falls back to `unknown` if unknown.
  static FiftyEntityType fromString(String value) {
    return FiftyEntityType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => FiftyEntityType.unknown,
    );
  }

  /// Lowercase string representation (e.g., 'monster').
  String get value => toString().split('.').last;
}

/// **Tile-based size wrapper for map entities**
///
/// Encapsulates width and height in tile units.
///
/// **Fields:**
/// - [width]: number of horizontal tiles
/// - [height]: number of vertical tiles
///
/// **Serialization:**
/// - `fromJson(...)` / `toJson()`
class FiftyBlockSize {
  final double width;
  final double height;

  FiftyBlockSize(this.width, this.height);

  factory FiftyBlockSize.fromJson(Map<String, dynamic> json) {
    return FiftyBlockSize(
      double.parse(json['width'].toString()),
      double.parse(json['height'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height};
  }
}
