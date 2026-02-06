/// Unit Model
///
/// Represents a game unit with stats, position, and action state.
/// Supports three unit types: Commander, Knight, Shield.
library;

import 'position.dart';

/// Unit types available in the game.
enum UnitType {
  /// Leader unit. Capture to win. HP 5, ATK 2, moves 1 tile any direction.
  commander,

  /// Fast striker. HP 3, ATK 3, moves in L-shape (chess knight).
  knight,

  /// Tank unit. HP 4, ATK 1, moves 1 tile any direction.
  shield,
}

/// A game unit with stats and position on the tactical board.
///
/// Units are mutable for HP and turn state tracking.
/// Use factory constructors for standard stat configurations.
///
/// **Example:**
/// ```dart
/// final knight = Unit.knight(
///   id: 'player_knight_1',
///   isPlayer: true,
///   position: GridPosition(2, 7),
/// );
/// ```
class Unit {
  /// Unique identifier for this unit.
  final String id;

  /// The type of this unit.
  final UnitType type;

  /// Whether this unit belongs to the player (true) or enemy (false).
  final bool isPlayer;

  /// Current hit points.
  int hp;

  /// Maximum hit points.
  final int maxHp;

  /// Attack damage value.
  final int attack;

  /// Current position on the board.
  GridPosition position;

  /// Whether this unit has moved during the current turn.
  bool hasMovedThisTurn;

  /// Whether this unit has performed an action (attack/ability) this turn.
  bool hasActedThisTurn;

  Unit({
    required this.id,
    required this.type,
    required this.isPlayer,
    required this.hp,
    required this.maxHp,
    required this.attack,
    required this.position,
    this.hasMovedThisTurn = false,
    this.hasActedThisTurn = false,
  });

  /// Creates a Commander unit. HP 5, ATK 2, Movement 1 tile any direction.
  factory Unit.commander({
    required String id,
    required bool isPlayer,
    required GridPosition position,
  }) {
    return Unit(
      id: id,
      type: UnitType.commander,
      isPlayer: isPlayer,
      hp: 5,
      maxHp: 5,
      attack: 2,
      position: position,
    );
  }

  /// Creates a Knight unit. HP 3, ATK 3, Movement L-shape.
  factory Unit.knight({
    required String id,
    required bool isPlayer,
    required GridPosition position,
  }) {
    return Unit(
      id: id,
      type: UnitType.knight,
      isPlayer: isPlayer,
      hp: 3,
      maxHp: 3,
      attack: 3,
      position: position,
    );
  }

  /// Creates a Shield unit. HP 4, ATK 1, Movement 1 tile any direction.
  factory Unit.shield({
    required String id,
    required bool isPlayer,
    required GridPosition position,
  }) {
    return Unit(
      id: id,
      type: UnitType.shield,
      isPlayer: isPlayer,
      hp: 4,
      maxHp: 4,
      attack: 1,
      position: position,
    );
  }

  /// Whether this unit is dead (HP <= 0).
  bool get isDead => hp <= 0;

  /// Whether this unit is alive (HP > 0).
  bool get isAlive => hp > 0;

  /// Whether this unit can perform an action this turn.
  bool get canAct => !hasActedThisTurn && isAlive;

  /// Whether this unit can still move this turn.
  bool get canMove => !hasMovedThisTurn && isAlive;

  /// Movement range based on unit type.
  int get movementRange => switch (type) {
        UnitType.commander || UnitType.shield => 1,
        UnitType.knight => 3,
      };

  /// Human-readable display name.
  String get displayName => switch (type) {
        UnitType.commander => 'Commander',
        UnitType.knight => 'Knight',
        UnitType.shield => 'Shield',
      };

  /// Asset path for the unit sprite.
  String get assetPath {
    final side = isPlayer ? 'player' : 'enemy';
    return 'assets/images/units/${side}_${type.name}.png';
  }

  /// HP as a ratio (0.0 to 1.0) for progress bars.
  double get hpRatio => maxHp > 0 ? hp / maxHp : 0.0;

  /// Get valid move positions, excluding occupied tiles.
  List<GridPosition> getValidMovePositions(List<Unit> allUnits) {
    final occupied =
        allUnits.where((u) => u.isAlive).map((u) => u.position).toSet();

    final potentialMoves = switch (type) {
      UnitType.commander || UnitType.shield => position.getAdjacentPositions(),
      UnitType.knight => position.getKnightMovePositions(),
    };

    return potentialMoves.where((pos) => !occupied.contains(pos)).toList();
  }

  /// Get enemy units that can be attacked (adjacent enemies).
  List<Unit> getAttackableUnits(List<Unit> allUnits) {
    final adjacent = position.getAdjacentPositions().toSet();
    return allUnits
        .where((u) =>
            u.isAlive && u.isPlayer != isPlayer && adjacent.contains(u.position))
        .toList();
  }

  /// Apply damage to this unit. Returns actual damage dealt.
  int takeDamage(int damage) {
    final actual = damage.clamp(0, hp);
    hp -= actual;
    return actual;
  }

  /// Reset turn state for a new turn.
  void resetTurnState() {
    hasMovedThisTurn = false;
    hasActedThisTurn = false;
  }

  /// Create a copy with optional field overrides.
  Unit copyWith({
    String? id,
    UnitType? type,
    bool? isPlayer,
    int? hp,
    int? maxHp,
    int? attack,
    GridPosition? position,
    bool? hasMovedThisTurn,
    bool? hasActedThisTurn,
  }) {
    return Unit(
      id: id ?? this.id,
      type: type ?? this.type,
      isPlayer: isPlayer ?? this.isPlayer,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      attack: attack ?? this.attack,
      position: position ?? this.position,
      hasMovedThisTurn: hasMovedThisTurn ?? this.hasMovedThisTurn,
      hasActedThisTurn: hasActedThisTurn ?? this.hasActedThisTurn,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Unit && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Unit($id, $displayName, HP: $hp/$maxHp, pos: $position)';
}
