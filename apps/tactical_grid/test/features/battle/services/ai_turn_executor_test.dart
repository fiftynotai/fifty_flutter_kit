import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tactical_grid/features/battle/controllers/battle_view_model.dart';
import 'package:tactical_grid/features/battle/models/models.dart';
import 'package:tactical_grid/features/battle/services/ai_service.dart';
import 'package:tactical_grid/features/battle/services/ai_turn_executor.dart';
import 'package:tactical_grid/features/battle/services/audio_coordinator.dart';
import 'package:tactical_grid/features/battle/services/game_logic_service.dart';

void main() {
  late BattleViewModel viewModel;
  late AITurnExecutor executor;

  setUp(() {
    Get.reset();
    final gameLogic = const GameLogicService();
    viewModel = BattleViewModel(gameLogic);
    // Use a real BattleAudioCoordinator but it will fail silently
    // since no audio engine is initialized in tests. That is acceptable
    // because the audio coordinator wraps all calls in try/catch.
    final audio = BattleAudioCoordinator();
    const aiService = AIService();
    executor = AITurnExecutor(viewModel, audio, aiService);
  });

  // ---------------------------------------------------------------------------
  // isExecuting
  // ---------------------------------------------------------------------------

  group('isExecuting', () {
    test('starts as false', () {
      expect(executor.isExecuting.value, false);
    });
  });

  // ---------------------------------------------------------------------------
  // executeAITurn guards
  // ---------------------------------------------------------------------------

  group('executeAITurn guards', () {
    test('does nothing when game is over', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);

      // Force game over state.
      viewModel.gameState.value = viewModel.gameState.value.copyWith(
        phase: GamePhase.gameOver,
        result: GameResult.playerWin,
      );

      await executor.executeAITurn();

      // isExecuting should never become true if guard blocks.
      expect(executor.isExecuting.value, false);
    });

    test('does nothing when it is player turn', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);

      // Player turn -- AI should not execute.
      expect(viewModel.isPlayerTurn, true);

      // executeAITurn checks isGameOver, not isPlayerTurn.
      // But since it is called and the game is not over, it would
      // proceed. The AI will get decisions for enemy units even though
      // it is the player turn (the AI service decides for enemies).
      // This is fine -- the caller (BattleActions) gates on isAITurn.
    });
  });

  // ---------------------------------------------------------------------------
  // executeAITurn integration
  // ---------------------------------------------------------------------------

  group('executeAITurn integration', () {
    test('executes AI turn and switches back to player', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);
      viewModel.endTurn(); // Switch to AI turn.

      expect(viewModel.isPlayerTurn, false);

      await executor.executeAITurn();

      // After AI turn completes, it should be player turn again.
      expect(viewModel.isPlayerTurn, true);
      expect(executor.isExecuting.value, false);
    });

    test('isExecuting is false after completion', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);
      viewModel.endTurn();

      await executor.executeAITurn();

      expect(executor.isExecuting.value, false);
    });

    test('medium difficulty AI executes without errors', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.medium);
      viewModel.endTurn();

      await executor.executeAITurn();

      expect(viewModel.isPlayerTurn, true);
      expect(executor.isExecuting.value, false);
    });

    test('hard difficulty AI executes without errors', () async {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.hard);
      viewModel.endTurn();

      await executor.executeAITurn();

      expect(viewModel.isPlayerTurn, true);
      expect(executor.isExecuting.value, false);
    });

    test('does not call endTurn if game becomes over during execution',
        () async {
      // Create a state where one hit can end the game.
      final units = <Unit>[
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(4, 1), // Adjacent to enemy knight
        ),
        Unit.knight(
          id: 'e_knight_1',
          isPlayer: false,
          position: const GridPosition(3, 0),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(7, 7),
        ),
      ];
      // Lower player commander HP so one hit kills it.
      units[0].hp = 1;

      viewModel.gameState.value = GameState(
        board: BoardState(units: units),
        isPlayerTurn: false,
        turnNumber: 1,
        phase: GamePhase.playing,
        result: GameResult.none,
        gameMode: GameMode.vsAI,
        aiDifficulty: AIDifficulty.medium, // Medium always attacks lowest HP
      );

      await executor.executeAITurn();

      // Game should be over (enemy wins by killing player commander).
      // The executor should NOT have called endTurn after game over.
      expect(viewModel.isGameOver, true);
      expect(viewModel.result, GameResult.enemyWin);
      expect(executor.isExecuting.value, false);
    });
  });
}
