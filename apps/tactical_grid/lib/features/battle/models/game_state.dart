/// Game State
///
/// Complete state of the tactical battle including board, turn, and result.
library;

import 'board_state.dart';
import 'position.dart';
import 'unit.dart';

/// Current phase of the game.
enum GamePhase {
  /// Game setup / placement phase.
  setup,

  /// Active gameplay.
  playing,

  /// Game has ended.
  gameOver,
}

/// Result of the game.
enum GameResult {
  /// Game is still in progress.
  none,

  /// Player has won.
  playerWin,

  /// Enemy has won.
  enemyWin,
}

/// Complete game state for the tactical battle.
///
/// Immutable state object. Use [copyWith] for updates.
///
/// **Example:**
/// ```dart
/// var state = GameState.initial();
/// state = state.copyWith(isPlayerTurn: false, turnNumber: 2);
/// ```
class GameState {
  /// The current board state with all units.
  final BoardState board;

  /// Whether it is the player's turn.
  final bool isPlayerTurn;

  /// Current turn number (starts at 1).
  final int turnNumber;

  /// Current game phase.
  final GamePhase phase;

  /// Game result (none while in progress).
  final GameResult result;

  /// Currently selected unit (null if none selected).
  final Unit? selectedUnit;

  /// Valid move positions for the selected unit.
  final List<GridPosition> validMoves;

  /// Units that can be attacked by the selected unit.
  final List<Unit> attackTargets;

  /// Valid target positions for the selected unit's ability.
  final List<GridPosition> abilityTargets;

  const GameState({
    required this.board,
    required this.isPlayerTurn,
    required this.turnNumber,
    required this.phase,
    required this.result,
    this.selectedUnit,
    this.validMoves = const [],
    this.attackTargets = const [],
    this.abilityTargets = const [],
  });

  /// Create initial game state with starting army positions.
  ///
  /// Player units on bottom rows (6-7), enemy units on top rows (0-1).
  /// Each side gets: 1 Commander, 2 Knights, 1 Shield, 1 Archer, 1 Mage.
  factory GameState.initial() {
    final units = <Unit>[
      // Player units (bottom of board)
      Unit.commander(
        id: 'p_commander',
        isPlayer: true,
        position: const GridPosition(3, 7),
      ),
      Unit.knight(
        id: 'p_knight_1',
        isPlayer: true,
        position: const GridPosition(1, 7),
      ),
      Unit.knight(
        id: 'p_knight_2',
        isPlayer: true,
        position: const GridPosition(5, 7),
      ),
      Unit.shield(
        id: 'p_shield_1',
        isPlayer: true,
        position: const GridPosition(2, 6),
      ),
      Unit.archer(
        id: 'p_archer_1',
        isPlayer: true,
        position: const GridPosition(4, 6),
      ),
      Unit.mage(
        id: 'p_mage_1',
        isPlayer: true,
        position: const GridPosition(6, 6),
      ),

      // Enemy units (top of board)
      Unit.commander(
        id: 'e_commander',
        isPlayer: false,
        position: const GridPosition(4, 0),
      ),
      Unit.knight(
        id: 'e_knight_1',
        isPlayer: false,
        position: const GridPosition(2, 0),
      ),
      Unit.knight(
        id: 'e_knight_2',
        isPlayer: false,
        position: const GridPosition(6, 0),
      ),
      Unit.shield(
        id: 'e_shield_1',
        isPlayer: false,
        position: const GridPosition(3, 1),
      ),
      Unit.archer(
        id: 'e_archer_1',
        isPlayer: false,
        position: const GridPosition(5, 1),
      ),
      Unit.mage(
        id: 'e_mage_1',
        isPlayer: false,
        position: const GridPosition(1, 1),
      ),
    ];

    return GameState(
      board: BoardState(units: units),
      isPlayerTurn: true,
      turnNumber: 1,
      phase: GamePhase.playing,
      result: GameResult.none,
    );
  }

  /// Check if a commander has been captured.
  GameResult checkWinCondition() {
    if (board.enemyCommander == null || (board.enemyCommander?.isDead ?? true)) {
      return GameResult.playerWin;
    }
    if (board.playerCommander == null ||
        (board.playerCommander?.isDead ?? true)) {
      return GameResult.enemyWin;
    }
    return GameResult.none;
  }

  /// Display label for the current turn.
  String get turnLabel => isPlayerTurn ? 'PLAYER 1' : 'PLAYER 2';

  /// Whether the game is over.
  bool get isGameOver => phase == GamePhase.gameOver;

  /// Whether a unit is currently selected.
  bool get hasSelection => selectedUnit != null;

  /// Create a copy with optional field overrides.
  GameState copyWith({
    BoardState? board,
    bool? isPlayerTurn,
    int? turnNumber,
    GamePhase? phase,
    GameResult? result,
    Unit? selectedUnit,
    List<GridPosition>? validMoves,
    List<Unit>? attackTargets,
    List<GridPosition>? abilityTargets,
    bool clearSelection = false,
  }) {
    return GameState(
      board: board ?? this.board,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      turnNumber: turnNumber ?? this.turnNumber,
      phase: phase ?? this.phase,
      result: result ?? this.result,
      selectedUnit: clearSelection ? null : (selectedUnit ?? this.selectedUnit),
      validMoves: clearSelection ? const [] : (validMoves ?? this.validMoves),
      attackTargets:
          clearSelection ? const [] : (attackTargets ?? this.attackTargets),
      abilityTargets:
          clearSelection ? const [] : (abilityTargets ?? this.abilityTargets),
    );
  }

  @override
  String toString() =>
      'GameState(turn: $turnNumber, ${isPlayerTurn ? "player" : "enemy"}, '
      'phase: ${phase.name}, result: ${result.name})';
}
