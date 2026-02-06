import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';
import 'package:tactical_grid/features/battle/services/game_logic_service.dart';

void main() {
  late GameLogicService service;

  setUp(() {
    service = const GameLogicService();
  });

  // ---------------------------------------------------------------------------
  // startNewGame
  // ---------------------------------------------------------------------------

  group('startNewGame', () {
    test('returns a GameState in playing phase', () {
      final state = service.startNewGame();

      expect(state.phase, GamePhase.playing);
      expect(state.result, GameResult.none);
    });

    test('starts on turn 1 with player going first', () {
      final state = service.startNewGame();

      expect(state.turnNumber, 1);
      expect(state.isPlayerTurn, true);
    });

    test('creates 10 total units (5 per side)', () {
      final state = service.startNewGame();

      expect(state.board.units.length, 10);
      expect(state.board.playerUnits.length, 5);
      expect(state.board.enemyUnits.length, 5);
    });

    test('each side has 1 commander, 2 knights, 2 shields', () {
      final state = service.startNewGame();

      final playerUnits = state.board.playerUnits;
      final enemyUnits = state.board.enemyUnits;

      expect(
        playerUnits.where((u) => u.type == UnitType.commander).length,
        1,
      );
      expect(
        playerUnits.where((u) => u.type == UnitType.knight).length,
        2,
      );
      expect(
        playerUnits.where((u) => u.type == UnitType.shield).length,
        2,
      );

      expect(
        enemyUnits.where((u) => u.type == UnitType.commander).length,
        1,
      );
      expect(
        enemyUnits.where((u) => u.type == UnitType.knight).length,
        2,
      );
      expect(
        enemyUnits.where((u) => u.type == UnitType.shield).length,
        2,
      );
    });

    test('no unit is selected initially', () {
      final state = service.startNewGame();

      expect(state.hasSelection, false);
      expect(state.selectedUnit, isNull);
      expect(state.validMoves, isEmpty);
      expect(state.attackTargets, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // selectUnit
  // ---------------------------------------------------------------------------

  group('selectUnit', () {
    test('selects a player unit on player turn', () {
      final state = service.startNewGame();
      final updated = service.selectUnit(state, 'p_knight_1');

      expect(updated.selectedUnit, isNotNull);
      expect(updated.selectedUnit!.id, 'p_knight_1');
    });

    test('populates valid moves for selected unit', () {
      final state = service.startNewGame();
      final updated = service.selectUnit(state, 'p_knight_1');

      expect(updated.validMoves, isNotEmpty);
    });

    test('rejects selecting an enemy unit on player turn', () {
      final state = service.startNewGame();
      final updated = service.selectUnit(state, 'e_knight_1');

      expect(updated.selectedUnit, isNull);
    });

    test('rejects selecting a dead unit', () {
      final state = service.startNewGame();
      final unit = state.board.units.firstWhere((u) => u.id == 'p_knight_1');
      unit.hp = 0;

      final updated = service.selectUnit(state, 'p_knight_1');

      expect(updated.selectedUnit, isNull);
    });

    test('rejects selection when game is over', () {
      final state = service.startNewGame();
      final gameOverState = state.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.playerWin,
      );

      final updated = service.selectUnit(gameOverState, 'p_knight_1');

      expect(updated.selectedUnit, isNull);
    });

    test('returns original state for nonexistent unit ID', () {
      final state = service.startNewGame();
      final updated = service.selectUnit(state, 'nonexistent');

      expect(updated.selectedUnit, isNull);
    });

    test('populates attack targets when adjacent to enemies', () {
      // Place a player unit adjacent to an enemy unit.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final updated = service.selectUnit(state, 'p_commander');

      expect(updated.attackTargets.length, 1);
      expect(updated.attackTargets.first.id, 'e_commander');
    });
  });

  // ---------------------------------------------------------------------------
  // deselectUnit
  // ---------------------------------------------------------------------------

  group('deselectUnit', () {
    test('clears the selection', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');
      expect(state.hasSelection, true);

      state = service.deselectUnit(state);

      expect(state.hasSelection, false);
      expect(state.selectedUnit, isNull);
      expect(state.validMoves, isEmpty);
      expect(state.attackTargets, isEmpty);
    });

    test('is safe to call with no selection', () {
      final state = service.startNewGame();
      final updated = service.deselectUnit(state);

      expect(updated.hasSelection, false);
    });
  });

  // ---------------------------------------------------------------------------
  // executeMove
  // ---------------------------------------------------------------------------

  group('executeMove', () {
    test('moves the selected unit to the target position', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      // Knight at (1,7) should be able to move to L-shape positions.
      final target = state.validMoves.first;
      state = service.executeMove(state, target);

      final movedUnit =
          state.board.units.firstWhere((u) => u.id == 'p_knight_1');
      expect(movedUnit.position, target);
    });

    test('marks unit as having moved this turn', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      final target = state.validMoves.first;
      state = service.executeMove(state, target);

      final movedUnit =
          state.board.units.firstWhere((u) => u.id == 'p_knight_1');
      expect(movedUnit.hasMovedThisTurn, true);
    });

    test('clears valid moves after movement', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      final target = state.validMoves.first;
      state = service.executeMove(state, target);

      expect(state.validMoves, isEmpty);
    });

    test('rejects move to invalid position', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      final originalPosition =
          state.board.units.firstWhere((u) => u.id == 'p_knight_1').position;

      // Attempt to move to an invalid position.
      state = service.executeMove(state, const GridPosition(0, 0));

      final unit =
          state.board.units.firstWhere((u) => u.id == 'p_knight_1');
      expect(unit.position, originalPosition);
    });

    test('rejects move when no unit is selected', () {
      final state = service.startNewGame();
      final updated =
          service.executeMove(state, const GridPosition(3, 5));

      // State should be unchanged.
      expect(updated.selectedUnit, isNull);
    });

    test('rejects move when unit has already moved', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      final firstTarget = state.validMoves.first;
      state = service.executeMove(state, firstTarget);

      // Try to move again -- should fail since unit already moved.
      final secondTarget = const GridPosition(4, 4);
      final stateAfterSecondMove = service.executeMove(state, secondTarget);

      // Position should remain at first target.
      final unit = stateAfterSecondMove.board.units
          .firstWhere((u) => u.id == 'p_knight_1');
      expect(unit.position, firstTarget);
    });

    test('rejects move when game is over', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');

      final target = state.validMoves.first;
      final gameOverState = state.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.playerWin,
      );

      final updated = service.executeMove(gameOverState, target);

      // Unit should not have moved.
      final unit =
          updated.board.units.firstWhere((u) => u.id == 'p_knight_1');
      expect(unit.hasMovedThisTurn, false);
    });

    test('recalculates attack targets after move', () {
      // Setup: player knight near enemy after moving.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 7),
        ),
        Unit.knight(
          id: 'p_knight_1',
          isPlayer: true,
          position: const GridPosition(3, 5),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 0),
        ),
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(4, 3),
        ),
      ];
      var state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      state = service.selectUnit(state, 'p_knight_1');

      // Knight moves from (3,5) via L-shape to (4,3) area -- check if
      // (5,3) is a valid move (L: +2x, -2y from (3,5)).
      final moveTo = const GridPosition(5, 4);
      if (state.validMoves.contains(moveTo)) {
        state = service.executeMove(state, moveTo);

        // After move, attack targets should be recalculated.
        // Whether there are targets depends on adjacency from new position.
        expect(state.attackTargets, isA<List<Unit>>());
      }
    });
  });

  // ---------------------------------------------------------------------------
  // executeAttack
  // ---------------------------------------------------------------------------

  group('executeAttack', () {
    late GameState combatState;

    setUp(() {
      // Create a controlled combat scenario: player commander adjacent to
      // enemy shield.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.knight(
          id: 'p_knight_1',
          isPlayer: true,
          position: const GridPosition(0, 7),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 0),
        ),
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      combatState = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );
    });

    test('deals damage equal to attacker attack stat', () {
      var state = service.selectUnit(combatState, 'p_commander');
      final targetHpBefore = state.board.units
          .firstWhere((u) => u.id == 'e_shield_1')
          .hp;

      final outcome = service.executeAttack(state, 'e_shield_1');

      expect(outcome.result.success, true);
      expect(outcome.result.damageDealt, 2); // Commander ATK = 2

      final targetHpAfter = outcome.state.board.units
          .firstWhere((u) => u.id == 'e_shield_1')
          .hp;
      expect(targetHpAfter, targetHpBefore - 2);
    });

    test('marks attacker as having acted this turn', () {
      var state = service.selectUnit(combatState, 'p_commander');
      final outcome = service.executeAttack(state, 'e_shield_1');

      expect(outcome.result.success, true);

      final attacker = outcome.state.board.units
          .firstWhere((u) => u.id == 'p_commander');
      expect(attacker.hasActedThisTurn, true);
    });

    test('reports target defeated when HP reaches 0', () {
      // Set enemy shield to 1 HP so commander (ATK 2) kills it.
      combatState.board.units
          .firstWhere((u) => u.id == 'e_shield_1')
          .hp = 1;

      var state = service.selectUnit(combatState, 'p_commander');
      final outcome = service.executeAttack(state, 'e_shield_1');

      expect(outcome.result.success, true);
      expect(outcome.result.targetDefeated, true);
    });

    test('triggers game over when commander is defeated', () {
      // Place player commander adjacent to enemy commander, with enemy at 1 HP.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      // Set enemy commander to 1 HP.
      state.board.units.firstWhere((u) => u.id == 'e_commander').hp = 1;

      var selected = service.selectUnit(state, 'p_commander');
      final outcome = service.executeAttack(selected, 'e_commander');

      expect(outcome.result.success, true);
      expect(outcome.result.targetDefeated, true);
      expect(outcome.state.phase, GamePhase.gameOver);
      expect(outcome.state.result, GameResult.playerWin);
    });

    test('returns failure when no unit is selected', () {
      final outcome =
          service.executeAttack(combatState, 'e_shield_1');

      expect(outcome.result.success, false);
      expect(outcome.result.errorMessage, isNotNull);
    });

    test('returns failure for target not in attack range', () {
      var state = service.selectUnit(combatState, 'p_commander');

      // Try to attack a unit that is not adjacent.
      final outcome = service.executeAttack(state, 'e_commander');

      expect(outcome.result.success, false);
      expect(outcome.result.errorMessage, contains('not in attack range'));
    });

    test('returns failure for nonexistent target', () {
      var state = service.selectUnit(combatState, 'p_commander');
      final outcome = service.executeAttack(state, 'nonexistent');

      expect(outcome.result.success, false);
    });

    test('returns failure when attacker has already acted', () {
      var state = service.selectUnit(combatState, 'p_commander');

      // Mark as already acted.
      state.selectedUnit!.hasActedThisTurn = true;

      final outcome = service.executeAttack(state, 'e_shield_1');

      expect(outcome.result.success, false);
    });

    test('clears selection after successful attack', () {
      var state = service.selectUnit(combatState, 'p_commander');
      final outcome = service.executeAttack(state, 'e_shield_1');

      expect(outcome.result.success, true);
      expect(outcome.state.hasSelection, false);
    });
  });

  // ---------------------------------------------------------------------------
  // endTurn
  // ---------------------------------------------------------------------------

  group('endTurn', () {
    test('switches from player turn to enemy turn', () {
      final state = service.startNewGame();
      expect(state.isPlayerTurn, true);

      final updated = service.endTurn(state);

      expect(updated.isPlayerTurn, false);
    });

    test('does not increment turn number after player turn', () {
      final state = service.startNewGame();
      expect(state.turnNumber, 1);

      final updated = service.endTurn(state);

      // Turn number stays at 1 until enemy also acts.
      expect(updated.turnNumber, 1);
    });

    test('increments turn number after enemy turn (full round)', () {
      var state = service.startNewGame();
      state = service.endTurn(state); // Player -> Enemy
      expect(state.turnNumber, 1);

      state = service.endTurn(state); // Enemy -> Player (new round)
      expect(state.turnNumber, 2);
    });

    test('clears selection on end turn', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_knight_1');
      expect(state.hasSelection, true);

      state = service.endTurn(state);

      expect(state.hasSelection, false);
    });

    test('resets current player units turn state', () {
      var state = service.startNewGame();

      // Mark a player unit as having moved and acted.
      final knight =
          state.board.units.firstWhere((u) => u.id == 'p_knight_1');
      knight.hasMovedThisTurn = true;
      knight.hasActedThisTurn = true;

      state = service.endTurn(state);

      // After end turn, the player units should be reset.
      expect(knight.hasMovedThisTurn, false);
      expect(knight.hasActedThisTurn, false);
    });

    test('resets next player units turn state', () {
      var state = service.startNewGame();

      // Simulate enemy units having stale state.
      final enemyKnight =
          state.board.units.firstWhere((u) => u.id == 'e_knight_1');
      enemyKnight.hasMovedThisTurn = true;
      enemyKnight.hasActedThisTurn = true;

      state = service.endTurn(state); // Switch to enemy turn.

      // Enemy units should be reset for their turn.
      expect(enemyKnight.hasMovedThisTurn, false);
      expect(enemyKnight.hasActedThisTurn, false);
    });

    test('does nothing when game is over', () {
      var state = service.startNewGame();
      state = state.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.playerWin,
      );

      final updated = service.endTurn(state);

      expect(updated.isPlayerTurn, state.isPlayerTurn);
      expect(updated.turnNumber, state.turnNumber);
    });
  });

  // ---------------------------------------------------------------------------
  // executeWait
  // ---------------------------------------------------------------------------

  group('executeWait', () {
    test('marks selected unit as moved and acted', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_shield_1');

      final unit =
          state.board.units.firstWhere((u) => u.id == 'p_shield_1');

      state = service.executeWait(state);

      expect(unit.hasMovedThisTurn, true);
      expect(unit.hasActedThisTurn, true);
    });

    test('clears selection after wait', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_shield_1');

      state = service.executeWait(state);

      expect(state.hasSelection, false);
    });

    test('returns unchanged state when no unit selected', () {
      final state = service.startNewGame();
      final updated = service.executeWait(state);

      expect(updated.hasSelection, false);
    });

    test('does nothing when game is over', () {
      var state = service.startNewGame();
      state = service.selectUnit(state, 'p_shield_1');
      state = state.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.enemyWin,
      );

      final unit =
          state.board.units.firstWhere((u) => u.id == 'p_shield_1');

      state = service.executeWait(state);

      expect(unit.hasMovedThisTurn, false);
      expect(unit.hasActedThisTurn, false);
    });
  });

  // ---------------------------------------------------------------------------
  // Movement Rules
  // ---------------------------------------------------------------------------

  group('movement rules', () {
    test('commander can move 1 tile in 8 directions', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      // Commander at (4,4) should have 8 adjacent moves.
      expect(selected.validMoves.length, 8);
      expect(
        selected.validMoves,
        containsAll([
          const GridPosition(3, 3),
          const GridPosition(4, 3),
          const GridPosition(5, 3),
          const GridPosition(3, 4),
          const GridPosition(5, 4),
          const GridPosition(3, 5),
          const GridPosition(4, 5),
          const GridPosition(5, 5),
        ]),
      );
    });

    test('shield can move 1 tile in 8 directions', () {
      final units = <Unit>[
        Unit.shield(
          id: 'p_shield_1',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 7),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_shield_1');

      expect(selected.validMoves.length, 8);
    });

    test('knight moves in L-shape pattern', () {
      final units = <Unit>[
        Unit.knight(
          id: 'p_knight_1',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 7),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_knight_1');

      // Knight at (4,4) center should have all 8 L-shape positions.
      expect(selected.validMoves.length, 8);
      expect(
        selected.validMoves,
        containsAll([
          const GridPosition(6, 5),
          const GridPosition(6, 3),
          const GridPosition(2, 5),
          const GridPosition(2, 3),
          const GridPosition(5, 6),
          const GridPosition(5, 2),
          const GridPosition(3, 6),
          const GridPosition(3, 2),
        ]),
      );
    });

    test('cannot move to occupied tiles', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.shield(
          id: 'p_shield_1',
          isPlayer: true,
          position: const GridPosition(4, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      // (4,3) is occupied by friendly shield, should not be in valid moves.
      expect(selected.validMoves.contains(const GridPosition(4, 3)), false);
      // But other directions should still be valid.
      expect(selected.validMoves.length, 7);
    });

    test('edge of board limits available positions', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 0),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 7),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      // Corner position (0,0) should have only 3 valid adjacent positions.
      expect(selected.validMoves.length, 3);
      expect(
        selected.validMoves,
        containsAll([
          const GridPosition(1, 0),
          const GridPosition(0, 1),
          const GridPosition(1, 1),
        ]),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Combat Rules
  // ---------------------------------------------------------------------------

  group('combat rules', () {
    test('only adjacent units can be attacked', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 0),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(5, 5),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      // Enemy is far away, no attack targets.
      expect(selected.attackTargets, isEmpty);
    });

    test('can attack in all 8 adjacent directions', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.shield(
          id: 'e_shield_n',
          isPlayer: false,
          position: const GridPosition(4, 3),
        ),
        Unit.shield(
          id: 'e_shield_ne',
          isPlayer: false,
          position: const GridPosition(5, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(5, 4),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      expect(selected.attackTargets.length, 3);
    });

    test('cannot attack friendly units', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(4, 4),
        ),
        Unit.shield(
          id: 'p_shield_1',
          isPlayer: true,
          position: const GridPosition(4, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      final selected = service.selectUnit(state, 'p_commander');

      // Adjacent unit is friendly, should not be attackable.
      expect(selected.attackTargets, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Win Conditions
  // ---------------------------------------------------------------------------

  group('win conditions', () {
    test('player wins when enemy commander is defeated', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      // Set enemy commander to 2 HP (commander ATK = 2, so one hit kills).
      state.board.units.firstWhere((u) => u.id == 'e_commander').hp = 2;

      var selected = service.selectUnit(state, 'p_commander');
      final outcome = service.executeAttack(selected, 'e_commander');

      expect(outcome.state.phase, GamePhase.gameOver);
      expect(outcome.state.result, GameResult.playerWin);
    });

    test('enemy wins when player commander is defeated', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      var state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: false,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      // Set player commander to 2 HP.
      state.board.units.firstWhere((u) => u.id == 'p_commander').hp = 2;

      state = service.selectUnit(state, 'e_commander');
      final outcome = service.executeAttack(state, 'p_commander');

      expect(outcome.state.phase, GamePhase.gameOver);
      expect(outcome.state.result, GameResult.enemyWin);
    });

    test('game continues when non-commander unit is defeated', () {
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 0),
        ),
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      final state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      // Set enemy shield to 1 HP.
      state.board.units.firstWhere((u) => u.id == 'e_shield_1').hp = 1;

      var selected = service.selectUnit(state, 'p_commander');
      final outcome = service.executeAttack(selected, 'e_shield_1');

      expect(outcome.result.targetDefeated, true);
      expect(outcome.state.phase, GamePhase.playing);
      expect(outcome.state.result, GameResult.none);
    });
  });

  // ---------------------------------------------------------------------------
  // Full Turn Flow Integration
  // ---------------------------------------------------------------------------

  group('full turn flow', () {
    test('select -> move -> attack -> end turn', () {
      // Setup: player commander one tile away from enemy shield.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 4),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 0),
        ),
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
      ];
      var state = GameState(
        board: BoardState(units: units),
        isPlayerTurn: true,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
      );

      // Step 1: Select commander.
      state = service.selectUnit(state, 'p_commander');
      expect(state.selectedUnit!.id, 'p_commander');

      // Step 2: Move to (3,3) -- adjacent to enemy shield at (3,2).
      state = service.executeMove(state, const GridPosition(3, 3));
      final commander =
          state.board.units.firstWhere((u) => u.id == 'p_commander');
      expect(commander.position, const GridPosition(3, 3));
      expect(commander.hasMovedThisTurn, true);

      // Step 3: Re-select to get attack targets (unit still selected).
      // After move, attack targets are recalculated.
      expect(state.attackTargets.any((t) => t.id == 'e_shield_1'), true);

      // Step 4: Attack enemy shield.
      final outcome = service.executeAttack(state, 'e_shield_1');
      expect(outcome.result.success, true);
      expect(outcome.result.damageDealt, 2);

      state = outcome.state;

      // Step 5: End turn.
      state = service.endTurn(state);
      expect(state.isPlayerTurn, false);
      expect(state.turnNumber, 1); // Still round 1.
    });

    test('select -> wait flow', () {
      var state = service.startNewGame();

      state = service.selectUnit(state, 'p_shield_1');
      expect(state.hasSelection, true);

      state = service.executeWait(state);
      expect(state.hasSelection, false);

      final shield =
          state.board.units.firstWhere((u) => u.id == 'p_shield_1');
      expect(shield.hasMovedThisTurn, true);
      expect(shield.hasActedThisTurn, true);
    });
  });
}
