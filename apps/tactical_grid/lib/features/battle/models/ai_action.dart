/// AI Action Model
///
/// Represents a single AI decision for one unit during the AI's turn.
/// Used by the AIService to communicate planned actions back to the
/// game controller for execution.
library;

import 'package:tactical_grid/features/battle/models/models.dart';

/// Types of actions the AI can take for a single unit.
enum AIActionType {
  /// Move unit to a new position.
  move,

  /// Attack an adjacent enemy unit.
  attack,

  /// Use the unit's ability.
  ability,

  /// Move first, then attack in the same turn.
  moveAndAttack,

  /// Move first, then use ability in the same turn.
  moveAndAbility,

  /// Do nothing (skip).
  wait,
}

/// Represents a single AI decision for one unit during the AI's turn.
///
/// Each action encodes what a unit should do, including optional movement,
/// attack targets, and ability usage. Factory constructors provide
/// convenient creation for each action type.
///
/// **Example:**
/// ```dart
/// final action = AIAction.move('e_knight_1', GridPosition(3, 2));
/// final combo = AIAction.moveAndAttack(
///   'e_knight_1', GridPosition(3, 5), 'p_shield_1',
/// );
/// ```
class AIAction {
  /// The unit performing this action.
  final String unitId;

  /// What type of action to take.
  final AIActionType type;

  /// Target position for movement (required for move, moveAndAttack, moveAndAbility).
  final GridPosition? moveTarget;

  /// Target unit ID for attack (required for attack, moveAndAttack).
  final String? attackTargetId;

  /// Target position for ability (required for position-targeting abilities).
  final GridPosition? abilityTarget;

  /// Type of ability being used (required for ability, moveAndAbility).
  final AbilityType? abilityType;

  const AIAction({
    required this.unitId,
    required this.type,
    this.moveTarget,
    this.attackTargetId,
    this.abilityTarget,
    this.abilityType,
  });

  /// Factory for a simple move action.
  factory AIAction.move(String unitId, GridPosition target) => AIAction(
        unitId: unitId,
        type: AIActionType.move,
        moveTarget: target,
      );

  /// Factory for a simple attack action.
  factory AIAction.attack(String unitId, String targetId) => AIAction(
        unitId: unitId,
        type: AIActionType.attack,
        attackTargetId: targetId,
      );

  /// Factory for an ability action.
  factory AIAction.ability(
    String unitId,
    AbilityType abilityType, {
    GridPosition? target,
  }) =>
      AIAction(
        unitId: unitId,
        type: AIActionType.ability,
        abilityType: abilityType,
        abilityTarget: target,
      );

  /// Factory for a move-then-attack combo.
  factory AIAction.moveAndAttack(
    String unitId,
    GridPosition moveTarget,
    String attackTargetId,
  ) =>
      AIAction(
        unitId: unitId,
        type: AIActionType.moveAndAttack,
        moveTarget: moveTarget,
        attackTargetId: attackTargetId,
      );

  /// Factory for a move-then-ability combo.
  factory AIAction.moveAndAbility(
    String unitId,
    GridPosition moveTarget,
    AbilityType abilityType, {
    GridPosition? abilityTarget,
  }) =>
      AIAction(
        unitId: unitId,
        type: AIActionType.moveAndAbility,
        moveTarget: moveTarget,
        abilityType: abilityType,
        abilityTarget: abilityTarget,
      );

  /// Factory for a wait action.
  factory AIAction.wait(String unitId) => AIAction(
        unitId: unitId,
        type: AIActionType.wait,
      );

  @override
  String toString() =>
      'AIAction($unitId, ${type.name}, move: $moveTarget, '
      'attack: $attackTargetId, ability: $abilityType)';
}
