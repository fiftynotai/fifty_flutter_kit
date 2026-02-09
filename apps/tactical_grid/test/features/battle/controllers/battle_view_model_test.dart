import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tactical_grid/features/battle/controllers/battle_view_model.dart';
import 'package:tactical_grid/features/battle/models/models.dart';
import 'package:tactical_grid/features/battle/services/game_logic_service.dart';

void main() {
  late BattleViewModel viewModel;
  late GameLogicService gameLogic;

  setUp(() {
    // Reset GetX state between tests.
    Get.reset();
    gameLogic = const GameLogicService();
    viewModel = BattleViewModel(gameLogic);
  });

  // ---------------------------------------------------------------------------
  // gameMode getter
  // ---------------------------------------------------------------------------

  group('gameMode', () {
    test('defaults to localMultiplayer', () {
      viewModel.startNewGame();

      expect(viewModel.gameMode, GameMode.localMultiplayer);
    });

    test('returns vsAI when started with vsAI mode', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.medium);

      expect(viewModel.gameMode, GameMode.vsAI);
    });
  });

  // ---------------------------------------------------------------------------
  // aiDifficulty getter
  // ---------------------------------------------------------------------------

  group('aiDifficulty', () {
    test('defaults to easy', () {
      viewModel.startNewGame();

      expect(viewModel.aiDifficulty, AIDifficulty.easy);
    });

    test('returns the difficulty passed to startNewGameWithMode', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.hard);

      expect(viewModel.aiDifficulty, AIDifficulty.hard);
    });
  });

  // ---------------------------------------------------------------------------
  // isAITurn getter
  // ---------------------------------------------------------------------------

  group('isAITurn', () {
    test('is false during player turn even in vsAI mode', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);

      expect(viewModel.isPlayerTurn, true);
      expect(viewModel.isAITurn, false);
    });

    test('is true during enemy turn in vsAI mode', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);
      viewModel.endTurn(); // Switch to enemy turn.

      expect(viewModel.isPlayerTurn, false);
      expect(viewModel.isAITurn, true);
    });

    test('is false during enemy turn in localMultiplayer mode', () {
      viewModel.startNewGame();
      viewModel.endTurn(); // Switch to "player 2" turn.

      expect(viewModel.isPlayerTurn, false);
      expect(viewModel.isAITurn, false);
    });
  });

  // ---------------------------------------------------------------------------
  // startNewGameWithMode
  // ---------------------------------------------------------------------------

  group('startNewGameWithMode', () {
    test('creates a valid game state with specified mode', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.medium);

      expect(viewModel.gameMode, GameMode.vsAI);
      expect(viewModel.aiDifficulty, AIDifficulty.medium);
      expect(viewModel.phase, GamePhase.playing);
      expect(viewModel.turnNumber, 1);
      expect(viewModel.isPlayerTurn, true);
    });

    test('creates 12 units with correct army composition', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.hard);

      expect(viewModel.playerUnits.length, 6);
      expect(viewModel.enemyUnits.length, 6);
    });

    test('resets game state when called again', () {
      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.hard);
      viewModel.endTurn(); // Turn 1 enemy
      viewModel.endTurn(); // Turn 2 player

      expect(viewModel.turnNumber, 2);

      viewModel.startNewGameWithMode(GameMode.vsAI, AIDifficulty.easy);

      expect(viewModel.turnNumber, 1);
      expect(viewModel.aiDifficulty, AIDifficulty.easy);
    });
  });

  // ---------------------------------------------------------------------------
  // hasSelection getter
  // ---------------------------------------------------------------------------

  group('hasSelection', () {
    test('is false initially', () {
      viewModel.startNewGame();

      expect(viewModel.hasSelection, false);
    });

    test('is true after selecting a unit', () {
      viewModel.startNewGame();
      viewModel.selectUnit('p_commander');

      expect(viewModel.hasSelection, true);
    });

    test('is false after deselecting', () {
      viewModel.startNewGame();
      viewModel.selectUnit('p_commander');
      viewModel.deselectUnit();

      expect(viewModel.hasSelection, false);
    });
  });
}
