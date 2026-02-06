/// Board State
///
/// Represents the state of the 8x8 game board including all units.
library;

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
