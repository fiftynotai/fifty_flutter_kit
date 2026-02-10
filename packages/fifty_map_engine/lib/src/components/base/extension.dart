import 'package:fifty_map_engine/src/animation/sprite_animation_config.dart';
import 'package:fifty_map_engine/src/config/map_config.dart';
import 'package:flame/components.dart';
import 'model.dart';

/// **Extensions for `FiftyMapEntity`**
///
/// Adds utility methods for cloning, coordinate adjustments, and type checks.
///
/// **Key Features:**
/// - `copyWith`: clone with selective overrides
/// - `changePosition`: update `gridPosition` and pixel `[x],[y]`
/// - `copyWithParent`: offset by a parent's position
/// - `entityType`: parse `type` string into enum
/// - Type guards: `isRoom`, `isMonster`, `isCharacter`, `isMovable`
extension FiftyMapEntityExtension on FiftyMapEntity {
  /// **Clone with selective overrides**
  ///
  /// - [id]: override entity id
  /// - [parentId]: override parent's id
  /// - [type]: override the `type` string
  /// - [asset]: override asset path
  /// - [gridPosition]: override tile coordinates
  /// - [x], [y]: override pixel coordinates
  /// - [zIndex]: override render priority
  /// - [quarterTurns]: override rotation steps
  /// - [blockSize], [blockHeight]: override grid dimensions
  /// - [event]: override attached event
  /// - [components]: override nested entities
  /// - [metadata]: override free-form data
  ///
  /// Returns a new [FiftyMapEntity] without mutating the original.
  FiftyMapEntity copyWith({
    String? id,
    String? parentId,
    String? type,
    String? asset,
    Vector2? gridPosition,
    double? x,
    double? y,
    int? zIndex,
    int? quarterTurns,
    FiftyBlockSize? blockSize,
    String? text,
    FiftyMapEvent? event,
    List<FiftyMapEntity>? components,
    Map<String, dynamic>? metadata,
    SpriteAnimationConfig? spriteAnimation,
  }) {
    return FiftyMapEntity(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      asset: asset ?? this.asset,
      gridPosition: gridPosition ?? this.gridPosition,
      x: x ?? this.x,
      y: y ?? this.y,
      zIndex: zIndex ?? this.zIndex,
      quarterTurns: quarterTurns ?? this.quarterTurns,
      blockSize: blockSize ?? this.blockSize,
      text: text ?? this.text,
      event: event ?? this.event,
      components: components ?? this.components,
      metadata: metadata ?? this.metadata,
      spriteAnimation: spriteAnimation ?? this.spriteAnimation,
    );
  }

  /// **Update grid position and pixel coordinates**
  ///
  /// - [gridPosition]: new tile coordinates
  ///
  /// Calculates `x = gridPosition.x * blockSize` and
  /// `y = gridPosition.y * blockSize`.
  ///
  /// Returns a new [FiftyMapEntity] at the new position.
  FiftyMapEntity changePosition({
    required Vector2 gridPosition,
  }) {
    return copyWith(
      gridPosition: gridPosition,
      x: gridPosition.x * FiftyMapConfig.blockSize,
      y: gridPosition.y * FiftyMapConfig.blockSize,
    );
  }

  /// **Offset by a parent's pixel position**
  ///
  /// - [parentPosition]: global pixel offset
  ///
  /// Useful when nesting child components within a parent entity.
  ///
  /// Returns a new [FiftyMapEntity] with updated `x` and `y`.
  FiftyMapEntity copyWithParent(Vector2 parentPosition) {
    return copyWith(
      x: parentPosition.x + x,
      y: parentPosition.y + y,
    );
  }

  /// **Enum-safe parsing of the `type` string**
  ///
  /// Converts [type] into [FiftyEntityType] via `FiftyEntityType.fromString`.
  FiftyEntityType get entityType => FiftyEntityType.fromString(type);

  /// **True if this entity is a room**
  bool get isRoom => entityType == FiftyEntityType.room;

  /// **True if this entity is a monster**
  bool get isMonster => entityType == FiftyEntityType.monster;

  /// **True if this entity is a furniture**
  bool get isFurniture => entityType == FiftyEntityType.furniture;

  /// **True if this entity is a event**
  bool get isEvent => entityType == FiftyEntityType.event;

  /// **True if this entity is a character**
  bool get isCharacter => entityType == FiftyEntityType.character;

  /// **True if this entity can move**
  ///
  /// Characters and monsters are movable.
  bool get isMovable => isCharacter || isMonster;
}

/// **Extension for parsing `FiftyEventType` values**
///
/// Provides conversions between raw strings and enum cases.
extension FiftyEventTypeExtension on FiftyEventType {
  /// **Create a [FiftyEventType] from a string**
  ///
  /// Case-insensitive matching:
  /// - `'basic'`
  /// - `'npc'`
  /// - `'masterofshadow'`
  ///
  /// Falls back to [FiftyEventType.basic] if no match.
  static FiftyEventType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'npc':
        return FiftyEventType.npc;
      case 'masterofshadow':
        return FiftyEventType.masterOfShadow;
      default:
        return FiftyEventType.basic;
    }
  }

  /// **Short string representation**
  ///
  /// Returns the enum name, e.g. `'npc'` or `'basic'`.
  String toShortString() => toString().split('.').last;
}

/// **Extension for parsing `FiftyEventAlignment` values**
///
/// Provides conversions between raw strings and alignment enums.
extension FiftyEventAlignmentExtension on FiftyEventAlignment {
  /// **Create a [FiftyEventAlignment] from a string**
  ///
  /// Case-insensitive; returns [FiftyEventAlignment.topLeft] if unmatched.
  static FiftyEventAlignment fromString(String? value) {
    return FiftyEventAlignment.values.firstWhere(
      (e) =>
          e.toString().split('.').last.toLowerCase().replaceAll('_', '') ==
          (value ?? '').toLowerCase(),
      orElse: () => FiftyEventAlignment.topLeft,
    );
  }

  /// **Short string representation**
  ///
  /// Returns the enum name, e.g. `'bottomCenter'`.
  String toShortString() => toString().split('.').last;
}
