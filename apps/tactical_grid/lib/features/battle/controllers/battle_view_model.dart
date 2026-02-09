/// **BattleViewModel**
///
/// Reactive ViewModel that manages the complete battle state for the
/// tactical grid game. Extends [GetxController] to provide observable
/// state that the UI layer binds to via `Obx()`.
///
/// **Architecture Role:**
/// - Holds reactive [GameState] as the single source of truth.
/// - Delegates all game logic to [GameLogicService] (pure functions).
/// - Exposes computed getters for convenient UI binding.
/// - Does NOT show UI feedback (that is the Actions layer's job).
///
/// **Data Flow:**
/// ```
/// View -> BattleActions -> BattleViewModel -> GameLogicService
///                              |
///                    gameState.obs (reactive)
///                              |
///                        View (Obx rebuild)
/// ```
///
/// **Example:**
/// ```dart
/// final vm = Get.find<BattleViewModel>();
/// vm.selectUnit('p_knight_1');
/// vm.moveSelectedUnit(GridPosition(3, 5));
/// vm.endTurn();
/// ```
library;

import 'package:get/get.dart';

import '../models/models.dart';
import '../services/game_logic_service.dart';

/// Reactive controller that manages tactical battle state.
///
/// All state mutations flow through [GameLogicService] to maintain
/// a clean separation between state ownership (ViewModel) and
/// game rules (Service). The UI observes [gameState] and rebuilds
/// automatically when it changes.
class BattleViewModel extends GetxController {
  /// Creates a [BattleViewModel] with the given [GameLogicService].
  ///
  /// The service is injected via constructor for testability.
  BattleViewModel(this._gameLogic);

  /// The game logic service that computes state transitions.
  final GameLogicService _gameLogic;

  // ---------------------------------------------------------------
  // Reactive State
  // ---------------------------------------------------------------

  /// The complete, observable game state.
  ///
  /// All UI widgets should bind to this (or to the computed getters
  /// below) using `Obx()`. Every mutation replaces the value and
  /// triggers a reactive rebuild.
  final Rx<GameState> gameState = GameState.initial().obs;

  /// Whether the UI is currently in ability targeting mode.
  ///
  /// When `true`, tile taps should be interpreted as ability target
  /// selections instead of normal move/attack interactions.
  final RxBool isAbilityTargeting = false.obs;

  // ---------------------------------------------------------------
  // Computed Getters (UI Binding)
  // ---------------------------------------------------------------

  /// Current board state containing all units.
  BoardState get board => gameState.value.board;

  /// Whether it is currently the player's turn.
  bool get isPlayerTurn => gameState.value.isPlayerTurn;

  /// The current turn number (starts at 1).
  int get turnNumber => gameState.value.turnNumber;

  /// Current phase of the game (setup, playing, gameOver).
  GamePhase get phase => gameState.value.phase;

  /// The result of the game (none while in progress).
  GameResult get result => gameState.value.result;

  /// The currently selected unit, or `null` if nothing is selected.
  Unit? get selectedUnit => gameState.value.selectedUnit;

  /// Valid move positions for the currently selected unit.
  List<GridPosition> get validMoves => gameState.value.validMoves;

  /// Enemy units that can be attacked by the selected unit.
  List<Unit> get attackTargets => gameState.value.attackTargets;

  /// Whether the game has ended.
  bool get isGameOver => gameState.value.isGameOver;

  /// Whether a unit is currently selected.
  bool get hasSelection => gameState.value.hasSelection;

  /// Valid target positions for the selected unit's ability.
  List<GridPosition> get abilityTargets => gameState.value.abilityTargets;

  /// The selected unit's ability, or `null` if no unit is selected
  /// or the unit has no ability.
  Ability? get selectedAbility => selectedUnit?.ability;

  /// Whether the selected unit can use its ability right now.
  ///
  /// Returns `false` if no unit is selected, the unit cannot act,
  /// has no ability, the ability is passive, or it is on cooldown.
  bool get canUseAbility {
    final unit = selectedUnit;
    if (unit == null || !unit.canAct) return false;
    final ability = unit.ability;
    if (ability == null || ability.isPassive) return false;
    return ability.isReady;
  }

  /// Display label for the current turn (e.g. "PLAYER 1").
  String get turnLabel => gameState.value.turnLabel;

  /// All living player units.
  List<Unit> get playerUnits => board.playerUnits;

  /// All living enemy units.
  List<Unit> get enemyUnits => board.enemyUnits;

  /// All units that are still alive on the board.
  List<Unit> get allAliveUnits =>
      board.units.where((u) => u.isAlive).toList();

  // ---------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------

  /// Initializes the controller by starting a fresh game.
  @override
  void onInit() {
    super.onInit();
    startNewGame();
  }

  // ---------------------------------------------------------------
  // Game Actions
  // ---------------------------------------------------------------

  /// Starts a new game, resetting all state to the initial configuration.
  ///
  /// Called automatically in [onInit] and can be invoked manually
  /// to restart after a game over.
  void startNewGame() {
    gameState.value = _gameLogic.startNewGame();
  }

  /// Selects the unit with the given [unitId].
  ///
  /// The service computes valid moves and attack targets for the
  /// selected unit and returns the updated state.
  ///
  /// **Parameters:**
  /// - [unitId]: The unique identifier of the unit to select.
  void selectUnit(String unitId) {
    gameState.value = _gameLogic.selectUnit(gameState.value, unitId);
  }

  /// Clears the current unit selection.
  ///
  /// Resets selected unit, valid moves, and attack targets to empty.
  void deselectUnit() {
    gameState.value = _gameLogic.deselectUnit(gameState.value);
  }

  /// Moves the currently selected unit to the [target] position.
  ///
  /// The service validates the move, updates the unit position,
  /// and recalculates attack targets from the new location.
  ///
  /// **Parameters:**
  /// - [target]: The board position to move the selected unit to.
  void moveSelectedUnit(GridPosition target) {
    gameState.value = _gameLogic.executeMove(gameState.value, target);
  }

  /// Attacks the enemy unit with the given [targetUnitId].
  ///
  /// The service applies damage, checks win conditions, and returns
  /// both the updated state and an [ActionResult] describing what
  /// happened (damage dealt, whether the target was defeated, etc.).
  ///
  /// **Parameters:**
  /// - [targetUnitId]: The unique identifier of the unit to attack.
  ///
  /// **Returns:**
  /// An [ActionResult] with details about the attack outcome.
  /// The Actions layer uses this to show appropriate UI feedback.
  ActionResult attackUnit(String targetUnitId) {
    final outcome =
        _gameLogic.executeAttack(gameState.value, targetUnitId);
    gameState.value = outcome.state;
    return outcome.result;
  }

  /// Ends the current turn, switching control to the other player.
  ///
  /// The service resets unit turn states, increments the turn counter,
  /// and flips the active player.
  void endTurn() {
    gameState.value = _gameLogic.endTurn(gameState.value);
  }

  /// Executes the selected unit's ability, optionally targeting a position.
  ///
  /// Delegates to [GameLogicService.executeAbility] and updates reactive
  /// state. Returns the [ActionResult] so the Actions layer can provide
  /// appropriate audio/UI feedback.
  ///
  /// **Parameters:**
  /// - [targetPosition]: Grid position for targeted abilities (Shoot, Fireball).
  ///
  /// **Returns:**
  /// An [ActionResult] describing the outcome.
  ActionResult useAbility({GridPosition? targetPosition}) {
    final outcome = _gameLogic.executeAbility(
      gameState.value,
      targetPosition: targetPosition,
    );
    gameState.value = outcome.state;
    return outcome.result;
  }

  /// Skips the selected unit's remaining actions for this turn.
  ///
  /// Marks the selected unit as having moved and acted, then
  /// clears the selection.
  void waitUnit() {
    gameState.value = _gameLogic.executeWait(gameState.value);
  }

  // ---------------------------------------------------------------
  // Query Helpers
  // ---------------------------------------------------------------

  /// Checks whether the given [pos] is a valid move destination
  /// for the currently selected unit.
  ///
  /// **Parameters:**
  /// - [pos]: The board position to check.
  ///
  /// **Returns:**
  /// `true` if the position is in the current [validMoves] list.
  bool isValidMovePosition(GridPosition pos) {
    return validMoves.contains(pos);
  }

  /// Checks whether the unit with [unitId] is a valid attack target
  /// for the currently selected unit.
  ///
  /// **Parameters:**
  /// - [unitId]: The unique identifier of the unit to check.
  ///
  /// **Returns:**
  /// `true` if the unit is in the current [attackTargets] list.
  bool isAttackTarget(String unitId) {
    return attackTargets.any((target) => target.id == unitId);
  }

  /// Checks whether the unit with [unitId] belongs to the player
  /// whose turn it currently is.
  ///
  /// **Parameters:**
  /// - [unitId]: The unique identifier of the unit to check.
  ///
  /// **Returns:**
  /// `true` if the unit belongs to the current turn's player.
  bool isCurrentPlayerUnit(String unitId) {
    final unit = board.units.where((u) => u.id == unitId).firstOrNull;
    if (unit == null) return false;
    return unit.isPlayer == isPlayerTurn;
  }

  /// Checks whether the given [pos] is a valid ability target
  /// for the currently selected unit.
  ///
  /// **Parameters:**
  /// - [pos]: The board position to check.
  ///
  /// **Returns:**
  /// `true` if the position is in the current [abilityTargets] list.
  bool isAbilityTargetPosition(GridPosition pos) {
    return abilityTargets.contains(pos);
  }

  /// Cancels ability targeting mode.
  ///
  /// Sets [isAbilityTargeting] to `false`, returning tile taps to
  /// their normal move/attack behavior.
  void cancelAbilityTargeting() {
    isAbilityTargeting.value = false;
  }
}
