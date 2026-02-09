/// Move / Action Model
///
/// Represents a game action (move, attack, or wait) and its result.
library;

import 'ability.dart';
import 'position.dart';

/// Type of action a unit can take.
enum ActionType {
  /// Move to a new position.
  move,

  /// Attack an adjacent enemy unit.
  attack,

  /// Skip action (do nothing).
  wait,

  /// Use a special ability.
  ability,
}

/// A game action performed by a unit.
///
/// **Example:**
/// ```dart
/// final moveAction = GameAction.move('p_knight_1', GridPosition(3, 5));
/// final attackAction = GameAction.attack('p_knight_1', 'e_shield_1');
/// ```
class GameAction {
  /// ID of the unit performing the action.
  final String unitId;

  /// Type of action being performed.
  final ActionType type;

  /// Target position (for move actions).
  final GridPosition? targetPosition;

  /// Target unit ID (for attack actions).
  final String? targetUnitId;

  /// Ability type (for ability actions).
  final AbilityType? abilityType;

  const GameAction({
    required this.unitId,
    required this.type,
    this.targetPosition,
    this.targetUnitId,
    this.abilityType,
  });

  /// Create a move action.
  factory GameAction.move(String unitId, GridPosition target) {
    return GameAction(
      unitId: unitId,
      type: ActionType.move,
      targetPosition: target,
    );
  }

  /// Create an attack action.
  factory GameAction.attack(String unitId, String targetId) {
    return GameAction(
      unitId: unitId,
      type: ActionType.attack,
      targetUnitId: targetId,
    );
  }

  /// Create a wait action.
  factory GameAction.wait(String unitId) {
    return GameAction(
      unitId: unitId,
      type: ActionType.wait,
    );
  }

  /// Create an ability action.
  factory GameAction.ability(
    String unitId,
    AbilityType abilityType, {
    GridPosition? targetPosition,
  }) {
    return GameAction(
      unitId: unitId,
      type: ActionType.ability,
      abilityType: abilityType,
      targetPosition: targetPosition,
    );
  }

  /// Whether this is a move action.
  bool get isMove => type == ActionType.move;

  /// Whether this is an attack action.
  bool get isAttack => type == ActionType.attack;

  /// Whether this is a wait action.
  bool get isWait => type == ActionType.wait;

  /// Whether this is an ability action.
  bool get isAbility => type == ActionType.ability;

  @override
  String toString() => 'GameAction($unitId, ${type.name}, '
      'pos: $targetPosition, target: $targetUnitId)';
}

/// Result of executing a game action.
class ActionResult {
  /// The action that was executed.
  final GameAction action;

  /// Whether the action was successful.
  final bool success;

  /// Damage dealt (for attack actions).
  final int? damageDealt;

  /// Whether the target was defeated (for attack actions).
  final bool? targetDefeated;

  /// Error message if the action failed.
  final String? errorMessage;

  /// IDs of units affected by this action (for AoE abilities like Fireball and Rally).
  final List<String>? affectedUnitIds;

  const ActionResult({
    required this.action,
    required this.success,
    this.damageDealt,
    this.targetDefeated,
    this.errorMessage,
    this.affectedUnitIds,
  });

  /// Create a successful result.
  factory ActionResult.success(
    GameAction action, {
    int? damage,
    bool? defeated,
    List<String>? affectedUnitIds,
  }) {
    return ActionResult(
      action: action,
      success: true,
      damageDealt: damage,
      targetDefeated: defeated,
      affectedUnitIds: affectedUnitIds,
    );
  }

  /// Create a failed result.
  factory ActionResult.failure(GameAction action, String error) {
    return ActionResult(
      action: action,
      success: false,
      errorMessage: error,
    );
  }

  @override
  String toString() => 'ActionResult(${action.type.name}, '
      'success: $success, damage: $damageDealt)';
}
