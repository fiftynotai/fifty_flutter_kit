/// Game Logic Service
///
/// Stateless service that implements the core game rules for the tactical
/// battle system: movement validation, combat resolution, turn management,
/// and win condition checks.
///
/// This service receives state, applies rules, and returns new state.
/// It does NOT hold reactive state -- that responsibility belongs to the
/// ViewModel layer.
///
/// **Usage:**
/// ```dart
/// final service = GameLogicService();
/// var state = service.startNewGame();
/// state = service.selectUnit(state, 'p_knight_1');
/// state = service.executeMove(state, GridPosition(3, 5));
/// ```
library;

import '../models/models.dart';

/// Result container for attack operations.
///
/// Bundles the [ActionResult] (damage dealt, success/failure) together
/// with the updated [GameState] after applying combat effects.
class AttackOutcome {
  /// The result details of the attack action.
  final ActionResult result;

  /// The updated game state after the attack was applied.
  final GameState state;

  /// Creates an [AttackOutcome] with the given [result] and [state].
  const AttackOutcome({required this.result, required this.state});
}

/// Stateless game logic service for the tactical battle system.
///
/// Implements all game rules as pure functions that take a [GameState]
/// and return a new [GameState]. This design makes the service easy
/// to test and reason about.
///
/// **Responsibilities:**
/// - Game initialization
/// - Unit selection and deselection
/// - Movement validation and execution
/// - Combat resolution (damage, defeat, win condition)
/// - Turn management (end turn, wait)
///
/// **Architecture Note:**
/// This is a SERVICE layer component. It is stateless and deterministic.
/// The ViewModel holds reactive state and delegates rule application here.
class GameLogicService {
  /// Creates a new [GameLogicService] instance.
  const GameLogicService();

  // ---------------------------------------------------------------------------
  // Game Initialization
  // ---------------------------------------------------------------------------

  /// Starts a new game with the default initial board layout.
  ///
  /// Creates a fresh [GameState] using [GameState.initial], which places
  /// player units on the bottom rows (6-7) and enemy units on the top
  /// rows (0-1). The player always moves first.
  ///
  /// **Returns:**
  /// A new [GameState] in the [GamePhase.playing] phase with turn 1.
  ///
  /// **Example:**
  /// ```dart
  /// final state = service.startNewGame();
  /// print(state.turnNumber); // 1
  /// print(state.isPlayerTurn); // true
  /// ```
  GameState startNewGame() {
    return GameState.initial();
  }

  // ---------------------------------------------------------------------------
  // Unit Selection
  // ---------------------------------------------------------------------------

  /// Selects a unit and calculates its valid moves and attack targets.
  ///
  /// Validates that the unit exists, is alive, and belongs to the current
  /// turn's player. On success, returns updated state with [selectedUnit],
  /// [validMoves], and [attackTargets] populated.
  ///
  /// **Parameters:**
  /// - [state]: The current game state.
  /// - [unitId]: The unique identifier of the unit to select.
  ///
  /// **Returns:**
  /// Updated [GameState] with selection data, or the original state
  /// unchanged if the selection is invalid.
  ///
  /// **Example:**
  /// ```dart
  /// state = service.selectUnit(state, 'p_knight_1');
  /// print(state.selectedUnit?.displayName); // "Knight"
  /// print(state.validMoves.length); // available move positions
  /// ```
  GameState selectUnit(GameState state, String unitId) {
    if (state.isGameOver) return state;

    final unit = _findUnit(state, unitId);
    if (unit == null || unit.isDead) return state;

    // Validate the unit belongs to the current turn's player.
    if (unit.isPlayer != state.isPlayerTurn) return state;

    final validMoves = state.board.getValidMoves(unit);
    final attackTargets = state.board.getAttackTargets(unit);

    return state.copyWith(
      selectedUnit: unit,
      validMoves: validMoves,
      attackTargets: attackTargets,
    );
  }

  /// Clears the current unit selection.
  ///
  /// Removes [selectedUnit], [validMoves], and [attackTargets] from the
  /// game state. Safe to call even if no unit is selected.
  ///
  /// **Parameters:**
  /// - [state]: The current game state.
  ///
  /// **Returns:**
  /// Updated [GameState] with selection cleared.
  ///
  /// **Example:**
  /// ```dart
  /// state = service.deselectUnit(state);
  /// print(state.hasSelection); // false
  /// ```
  GameState deselectUnit(GameState state) {
    return state.copyWith(clearSelection: true);
  }

  // ---------------------------------------------------------------------------
  // Movement
  // ---------------------------------------------------------------------------

  /// Moves the selected unit to the target position.
  ///
  /// Validates that:
  /// - A unit is currently selected
  /// - The unit has not already moved this turn
  /// - The target position is in [validMoves]
  ///
  /// On success, updates the unit's position, marks it as having moved,
  /// and recalculates attack targets from the new position.
  ///
  /// **Parameters:**
  /// - [state]: The current game state (must have a selected unit).
  /// - [target]: The [GridPosition] to move to.
  ///
  /// **Returns:**
  /// Updated [GameState] with the unit at its new position, or the
  /// original state unchanged if the move is invalid.
  ///
  /// **Example:**
  /// ```dart
  /// state = service.selectUnit(state, 'p_knight_1');
  /// if (state.validMoves.contains(GridPosition(3, 5))) {
  ///   state = service.executeMove(state, GridPosition(3, 5));
  /// }
  /// ```
  GameState executeMove(GameState state, GridPosition target) {
    if (state.isGameOver) return state;

    final unit = state.selectedUnit;
    if (unit == null || !unit.canMove) return state;

    // Validate the target is in the precomputed valid moves.
    if (!state.validMoves.contains(target)) return state;

    // Apply the move: update position and mark as moved.
    unit.position = target;
    unit.hasMovedThisTurn = true;

    // Recalculate attack targets from the new position.
    final attackTargets = state.board.getAttackTargets(unit);

    return state.copyWith(
      selectedUnit: unit,
      validMoves: const [],
      attackTargets: attackTargets,
    );
  }

  // ---------------------------------------------------------------------------
  // Combat
  // ---------------------------------------------------------------------------

  /// Executes an attack against the target unit.
  ///
  /// Validates that:
  /// - A unit is currently selected
  /// - The selected unit has not already acted this turn
  /// - The target unit is in [attackTargets]
  ///
  /// Applies damage equal to the attacker's [attack] stat. If the target's
  /// HP drops to 0 or below, it is considered defeated. If the defeated unit
  /// is a Commander, the game ends.
  ///
  /// **Parameters:**
  /// - [state]: The current game state (must have a selected unit).
  /// - [targetUnitId]: The unique identifier of the unit to attack.
  ///
  /// **Returns:**
  /// An [AttackOutcome] containing the [ActionResult] (damage dealt,
  /// success, defeat status) and the updated [GameState].
  ///
  /// **Example:**
  /// ```dart
  /// final outcome = service.executeAttack(state, 'e_shield_1');
  /// if (outcome.result.success) {
  ///   state = outcome.state;
  ///   print('Dealt ${outcome.result.damageDealt} damage');
  /// }
  /// ```
  AttackOutcome executeAttack(GameState state, String targetUnitId) {
    final attacker = state.selectedUnit;

    // Validate attacker state.
    if (attacker == null || !attacker.canAct || state.isGameOver) {
      return AttackOutcome(
        result: ActionResult.failure(
          GameAction.attack(attacker?.id ?? '', targetUnitId),
          'No valid attacker selected.',
        ),
        state: state,
      );
    }

    // Validate the target is attackable.
    final targetUnit = _findUnit(state, targetUnitId);
    if (targetUnit == null || targetUnit.isDead) {
      return AttackOutcome(
        result: ActionResult.failure(
          GameAction.attack(attacker.id, targetUnitId),
          'Target unit not found or already defeated.',
        ),
        state: state,
      );
    }

    final isValidTarget =
        state.attackTargets.any((t) => t.id == targetUnitId);
    if (!isValidTarget) {
      return AttackOutcome(
        result: ActionResult.failure(
          GameAction.attack(attacker.id, targetUnitId),
          'Target is not in attack range.',
        ),
        state: state,
      );
    }

    // Apply damage.
    final damageDealt = targetUnit.takeDamage(attacker.attack);
    attacker.hasActedThisTurn = true;

    final targetDefeated = targetUnit.isDead;
    final action = GameAction.attack(attacker.id, targetUnitId);

    // Check win condition after the attack.
    final winResult = state.checkWinCondition();

    GameState updatedState;
    if (winResult != GameResult.none) {
      // Game over -- set phase and result, clear selection.
      updatedState = state.copyWith(
        phase: GamePhase.gameOver,
        result: winResult,
        clearSelection: true,
      );
    } else {
      // Game continues -- clear selection since the unit has acted.
      updatedState = state.copyWith(
        clearSelection: true,
      );
    }

    return AttackOutcome(
      result: ActionResult.success(
        action,
        damage: damageDealt,
        defeated: targetDefeated,
      ),
      state: updatedState,
    );
  }

  // ---------------------------------------------------------------------------
  // Turn Management
  // ---------------------------------------------------------------------------

  /// Ends the current player's turn and switches to the other player.
  ///
  /// Performs the following in order:
  /// 1. Clears the current selection.
  /// 2. Resets all current player's units' turn state (moved/acted flags).
  /// 3. Switches [isPlayerTurn] to the other player.
  /// 4. Increments [turnNumber] every full round (after both players act).
  /// 5. Resets the next player's units' turn state.
  ///
  /// **Parameters:**
  /// - [state]: The current game state.
  ///
  /// **Returns:**
  /// Updated [GameState] with the turn switched.
  ///
  /// **Example:**
  /// ```dart
  /// state = service.endTurn(state);
  /// print(state.isPlayerTurn); // opposite of before
  /// ```
  GameState endTurn(GameState state) {
    if (state.isGameOver) return state;

    // Reset current player's units.
    final currentPlayerUnits = state.board.units
        .where((u) => u.isPlayer == state.isPlayerTurn && u.isAlive);
    for (final unit in currentPlayerUnits) {
      unit.resetTurnState();
    }

    // Switch turn.
    final nextIsPlayerTurn = !state.isPlayerTurn;

    // Increment turn number after the enemy finishes (i.e., when it becomes
    // the player's turn again). A full "round" = both players acted.
    final nextTurnNumber = nextIsPlayerTurn
        ? state.turnNumber + 1
        : state.turnNumber;

    // Reset next player's units for their upcoming turn.
    final nextPlayerUnits = state.board.units
        .where((u) => u.isPlayer == nextIsPlayerTurn && u.isAlive);
    for (final unit in nextPlayerUnits) {
      unit.resetTurnState();
    }

    return state.copyWith(
      isPlayerTurn: nextIsPlayerTurn,
      turnNumber: nextTurnNumber,
      clearSelection: true,
    );
  }

  /// Ends the selected unit's turn without performing an action.
  ///
  /// Marks the selected unit as having both moved and acted this turn,
  /// effectively skipping any remaining actions. Clears the selection
  /// afterward.
  ///
  /// **Parameters:**
  /// - [state]: The current game state (must have a selected unit).
  ///
  /// **Returns:**
  /// Updated [GameState] with the unit's turn exhausted and selection
  /// cleared, or the original state if no unit is selected.
  ///
  /// **Example:**
  /// ```dart
  /// state = service.selectUnit(state, 'p_shield_1');
  /// state = service.executeWait(state);
  /// print(state.hasSelection); // false
  /// ```
  GameState executeWait(GameState state) {
    if (state.isGameOver) return state;

    final unit = state.selectedUnit;
    if (unit == null) return state;

    unit.hasMovedThisTurn = true;
    unit.hasActedThisTurn = true;

    return state.copyWith(clearSelection: true);
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  /// Finds a unit by its [unitId] in the current board state.
  ///
  /// Returns `null` if no unit with the given ID exists.
  Unit? _findUnit(GameState state, String unitId) {
    final units = state.board.units;
    for (final unit in units) {
      if (unit.id == unitId) return unit;
    }
    return null;
  }
}
