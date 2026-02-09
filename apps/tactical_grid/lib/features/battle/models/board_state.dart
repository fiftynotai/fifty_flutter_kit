/// Board State
///
/// Represents the state of the 8x8 game board including all units.
library;

import 'ability.dart';
import 'position.dart';
import 'unit.dart';

/// State of the 8x8 game board.
///
/// Provides queries for unit positions, valid moves, and attack targets.
///
/// **Example:**
/// ```dart
/// final board = BoardState(units: initialUnits);
/// final moves = board.getValidMoves(selectedUnit);
/// final targets = board.getAttackTargets(selectedUnit);
/// ```
class BoardState {
  /// All units on the board (alive and dead).
  final List<Unit> units;

  /// Board size constant (8x8 grid).
  static const int boardSize = 8;

  const BoardState({required this.units});

  /// Get unit at position, or null if empty.
  Unit? getUnitAt(GridPosition position) {
    for (final unit in units) {
      if (unit.isAlive && unit.position == position) return unit;
    }
    return null;
  }

  /// Get all valid move positions for a unit.
  List<GridPosition> getValidMoves(Unit unit) {
    if (!unit.canMove) return [];
    return unit.getValidMovePositions(units);
  }

  /// Get all units that can be attacked by the given unit.
  List<Unit> getAttackTargets(Unit unit) {
    if (!unit.canAct) return [];
    return unit.getAttackableUnits(units);
  }

  /// Check if position is valid and unoccupied.
  bool isValidMoveTarget(GridPosition position) {
    return position.isValid && getUnitAt(position) == null;
  }

  /// All living player units.
  List<Unit> get playerUnits =>
      units.where((u) => u.isPlayer && u.isAlive).toList();

  /// All living enemy units.
  List<Unit> get enemyUnits =>
      units.where((u) => !u.isPlayer && u.isAlive).toList();

  /// The player's Commander (null if captured).
  Unit? get playerCommander => playerUnits
      .where((u) => u.type == UnitType.commander)
      .firstOrNull;

  /// The enemy's Commander (null if captured).
  Unit? get enemyCommander => enemyUnits
      .where((u) => u.type == UnitType.commander)
      .firstOrNull;

  /// Total number of living units.
  int get aliveUnitCount => units.where((u) => u.isAlive).length;

  /// Get valid target positions for a unit's ability.
  ///
  /// Returns empty list if the unit cannot act, has no ability, or the ability
  /// is not ready or is passive. Targeting rules depend on the ability type.
  List<GridPosition> getAbilityTargets(Unit unit) {
    if (!unit.canAct) return [];

    final ability = unit.ability;
    if (ability == null || !ability.isReady || ability.isPassive) return [];

    switch (ability.type) {
      case AbilityType.rally:
        // Adjacent allied units that are alive.
        return unit.position
            .getAdjacentPositions()
            .where((pos) {
              final target = getUnitAt(pos);
              return target != null &&
                  target.isAlive &&
                  target.isPlayer == unit.isPlayer;
            })
            .toList();

      case AbilityType.charge:
        // Passive ability -- no board targeting needed.
        return [];

      case AbilityType.block:
        // Self-target -- no board targeting needed.
        return [];

      case AbilityType.shoot:
        // Enemy units within Chebyshev distance 2-3 (ranged only, not adjacent).
        return units
            .where((target) =>
                target.isAlive &&
                target.isPlayer != unit.isPlayer &&
                _chebyshevDistance(unit.position, target.position) >= 2 &&
                _chebyshevDistance(unit.position, target.position) <= 3)
            .map((target) => target.position)
            .toList();

      case AbilityType.fireball:
        // All valid board positions within Chebyshev distance 3 of the unit.
        return unit.position.getPositionsInRadius(3);

      case AbilityType.reveal:
        // Positions within Chebyshev distance 2 (placeholder).
        return unit.position.getPositionsInRadius(2);
    }
  }

  /// Computes the Chebyshev distance between two positions.
  static int _chebyshevDistance(GridPosition a, GridPosition b) {
    final dx = (a.x - b.x).abs();
    final dy = (a.y - b.y).abs();
    return dx > dy ? dx : dy;
  }

  /// Create a deep copy of the board state.
  BoardState copyWith({List<Unit>? units}) {
    return BoardState(
      units: units ??
          this.units.map((u) => u.copyWith()).toList(),
    );
  }

  @override
  String toString() =>
      'BoardState(${playerUnits.length} player, ${enemyUnits.length} enemy)';
}
