import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // GameMode and AIDifficulty enums
  // ---------------------------------------------------------------------------

  group('GameMode enum', () {
    test('has localMultiplayer and vsAI values', () {
      expect(GameMode.values, contains(GameMode.localMultiplayer));
      expect(GameMode.values, contains(GameMode.vsAI));
      expect(GameMode.values.length, 2);
    });
  });

  group('AIDifficulty enum', () {
    test('has easy, medium, and hard values', () {
      expect(AIDifficulty.values, contains(AIDifficulty.easy));
      expect(AIDifficulty.values, contains(AIDifficulty.medium));
      expect(AIDifficulty.values, contains(AIDifficulty.hard));
      expect(AIDifficulty.values.length, 3);
    });
  });

  // ---------------------------------------------------------------------------
  // GameState fields
  // ---------------------------------------------------------------------------

  group('GameState.initial', () {
    test('defaults to localMultiplayer mode', () {
      final state = GameState.initial();

      expect(state.gameMode, GameMode.localMultiplayer);
    });

    test('defaults to easy AI difficulty', () {
      final state = GameState.initial();

      expect(state.aiDifficulty, AIDifficulty.easy);
    });
  });

  // ---------------------------------------------------------------------------
  // turnLabel
  // ---------------------------------------------------------------------------

  group('turnLabel', () {
    test('returns PLAYER 1 on player turn', () {
      final state = GameState.initial();

      expect(state.turnLabel, 'PLAYER 1');
    });

    test('returns PLAYER 2 on enemy turn in local multiplayer', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.localMultiplayer,
      );

      expect(state.turnLabel, 'PLAYER 2');
    });

    test('returns ENEMY AI on enemy turn in vsAI mode', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      expect(state.turnLabel, 'ENEMY AI');
    });

    test('returns PLAYER 1 on player turn even in vsAI mode', () {
      final state = GameState.initial().copyWith(
        gameMode: GameMode.vsAI,
      );

      expect(state.turnLabel, 'PLAYER 1');
    });
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  group('copyWith', () {
    test('preserves gameMode when not overridden', () {
      final state = GameState.initial().copyWith(gameMode: GameMode.vsAI);
      final copied = state.copyWith(turnNumber: 5);

      expect(copied.gameMode, GameMode.vsAI);
    });

    test('overrides gameMode when specified', () {
      final state = GameState.initial();
      final copied = state.copyWith(gameMode: GameMode.vsAI);

      expect(copied.gameMode, GameMode.vsAI);
    });

    test('preserves aiDifficulty when not overridden', () {
      final state = GameState.initial().copyWith(aiDifficulty: AIDifficulty.hard);
      final copied = state.copyWith(turnNumber: 5);

      expect(copied.aiDifficulty, AIDifficulty.hard);
    });

    test('overrides aiDifficulty when specified', () {
      final state = GameState.initial();
      final copied = state.copyWith(aiDifficulty: AIDifficulty.hard);

      expect(copied.aiDifficulty, AIDifficulty.hard);
    });
  });
}
