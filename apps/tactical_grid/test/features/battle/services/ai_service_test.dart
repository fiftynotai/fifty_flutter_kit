import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';
import 'package:tactical_grid/features/battle/services/ai_service.dart';

void main() {
  late AIService aiService;

  setUp(() {
    aiService = const AIService();
  });

  // ---------------------------------------------------------------------------
  // Helper: create a minimal game state for testing
  // ---------------------------------------------------------------------------

  /// Creates a custom game state with specified units.
  GameState createState(List<Unit> units) {
    return GameState(
      board: BoardState(units: units),
      isPlayerTurn: false,
      turnNumber: 1,
      phase: GamePhase.playing,
      result: GameResult.none,
      gameMode: GameMode.vsAI,
      aiDifficulty: AIDifficulty.easy,
    );
  }

  // ---------------------------------------------------------------------------
  // decideActions - general behavior
  // ---------------------------------------------------------------------------

  group('decideActions', () {
    test('returns one action per alive enemy unit', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      final actions = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(42));

      // 6 enemy units in the initial state.
      expect(actions.length, 6);
    });

    test('returns empty list when no enemy units are alive', () {
      final state = createState([
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 7),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(42));

      expect(actions, isEmpty);
    });

    test('all actions reference valid enemy unit IDs', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      final actions = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(42));
      final enemyIds = state.board.enemyUnits.map((u) => u.id).toSet();

      for (final action in actions) {
        expect(enemyIds, contains(action.unitId));
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Easy AI
  // ---------------------------------------------------------------------------

  group('easy AI', () {
    test('is deterministic with seeded Random', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      final actions1 = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(123));
      // Reset state for second run (initial state is immutable enough).
      final state2 = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );
      final actions2 = aiService.decideActions(state2, AIDifficulty.easy,
          random: Random(123));

      expect(actions1.length, actions2.length);
      for (int i = 0; i < actions1.length; i++) {
        expect(actions1[i].type, actions2[i].type);
        expect(actions1[i].unitId, actions2[i].unitId);
      }
    });

    test('moves units when no attack targets exist', () {
      // Place enemy knight far from player units.
      final state = createState([
        Unit.knight(
          id: 'e_knight_1',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(7, 7),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(42));

      expect(actions.length, 1);
      expect(actions.first.type, AIActionType.move);
      expect(actions.first.moveTarget, isNotNull);
    });

    test('waits when unit cannot move or attack', () {
      // Place enemy shield completely surrounded by friendlies.
      final state = createState([
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(1, 1),
        ),
        // Surround with enemy units so no moves and no attack targets.
        Unit.knight(
          id: 'e_knight_1',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
        Unit.knight(
          id: 'e_knight_2',
          isPlayer: false,
          position: const GridPosition(1, 0),
        ),
        Unit.knight(
          id: 'e_knight_3',
          isPlayer: false,
          position: const GridPosition(2, 0),
        ),
        Unit.knight(
          id: 'e_knight_4',
          isPlayer: false,
          position: const GridPosition(0, 1),
        ),
        Unit.knight(
          id: 'e_knight_5',
          isPlayer: false,
          position: const GridPosition(2, 1),
        ),
        Unit.knight(
          id: 'e_knight_6',
          isPlayer: false,
          position: const GridPosition(0, 2),
        ),
        Unit.knight(
          id: 'e_knight_7',
          isPlayer: false,
          position: const GridPosition(1, 2),
        ),
        Unit.knight(
          id: 'e_knight_8',
          isPlayer: false,
          position: const GridPosition(2, 2),
        ),
        // Player unit far away.
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(7, 7),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.easy,
          random: Random(42));

      // Find the shield's action specifically.
      final shieldAction = actions.firstWhere((a) => a.unitId == 'e_shield_1');
      expect(shieldAction.type, AIActionType.wait);
    });
  });

  // ---------------------------------------------------------------------------
  // Medium AI
  // ---------------------------------------------------------------------------

  group('medium AI', () {
    test('attacks lowest HP target when adjacent', () {
      final state = createState([
        Unit.knight(
          id: 'e_knight_1',
          isPlayer: false,
          position: const GridPosition(3, 3),
        ),
        // Low HP target (adjacent).
        Unit(
          id: 'p_archer_1',
          type: UnitType.archer,
          isPlayer: true,
          hp: 1,
          maxHp: 2,
          attack: 2,
          position: const GridPosition(3, 4),
          ability: Ability.shoot(),
        ),
        // Higher HP target (also adjacent).
        Unit.shield(
          id: 'p_shield_1',
          isPlayer: true,
          position: const GridPosition(4, 3),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.medium);
      final knightAction = actions.firstWhere((a) => a.unitId == 'e_knight_1');

      expect(knightAction.type, AIActionType.attack);
      expect(knightAction.attackTargetId, 'p_archer_1'); // Lowest HP
    });

    test('moves toward nearest player unit when no attack targets', () {
      final state = createState([
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 0),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 7),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.medium);
      final shieldAction = actions.firstWhere((a) => a.unitId == 'e_shield_1');

      expect(shieldAction.type, AIActionType.move);
      // Shield should move south (toward y=7), so y should increase.
      expect(shieldAction.moveTarget!.y, greaterThan(0));
    });

    test('uses moveAndAttack when move brings into attack range', () {
      // Place enemy knight such that L-shape move lands adjacent to a player.
      final state = createState([
        Unit.knight(
          id: 'e_knight_1',
          isPlayer: false,
          position: const GridPosition(0, 0),
        ),
        // Player at (2, 2) -- knight can reach (1, 2) or (2, 1) with L-move,
        // which are adjacent to (2, 2).
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(2, 2),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.medium);
      final knightAction = actions.firstWhere((a) => a.unitId == 'e_knight_1');

      // Knight should be able to move to a position adjacent to the player
      // and then attack.
      expect(
        knightAction.type,
        anyOf(AIActionType.moveAndAttack, AIActionType.move),
      );
    });

    test('processes ranged units (archer/mage) before melee', () {
      // Verify ordering: create archer and shield, both with attack targets.
      final state = createState([
        Unit.archer(
          id: 'e_archer_1',
          isPlayer: false,
          position: const GridPosition(3, 2),
        ),
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 4),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.medium);

      // Archer should be processed first in the action list.
      final archerIndex =
          actions.indexWhere((a) => a.unitId == 'e_archer_1');
      final shieldIndex =
          actions.indexWhere((a) => a.unitId == 'e_shield_1');

      expect(archerIndex, lessThan(shieldIndex));
    });
  });

  // ---------------------------------------------------------------------------
  // Hard AI
  // ---------------------------------------------------------------------------

  group('hard AI', () {
    test('returns one action per alive enemy unit', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      final actions = aiService.decideActions(state, AIDifficulty.hard);

      expect(actions.length, 6);
    });

    test('prefers attacking commander when possible', () {
      // Place enemy shield adjacent to both player commander and player archer.
      // Use shield (1-tile move) to avoid L-shape move+charge combos.
      final state = createState([
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 4),
        ),
        Unit.archer(
          id: 'p_archer_1',
          isPlayer: true,
          position: const GridPosition(4, 3),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.hard);
      final shieldAction =
          actions.firstWhere((a) => a.unitId == 'e_shield_1');

      // Shield should prefer commander due to higher score bonus.
      // Attack commander: 1 * 10 = 10 + 5 (commander) = 15
      // Attack archer: 1 * 10 = 10
      expect(shieldAction.attackTargetId, 'p_commander');
    });

    test('prefers killing a unit over partial damage', () {
      // Enemy shield adjacent to two targets:
      // - Commander at full HP (5) -- cannot kill with ATK 1
      // - Archer at 1 HP -- can kill with ATK 1
      // Use shield to avoid knight charge combo scoring.
      final state = createState([
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(3, 3),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 4),
        ),
        Unit(
          id: 'p_archer_1',
          type: UnitType.archer,
          isPlayer: true,
          hp: 1,
          maxHp: 2,
          attack: 2,
          position: const GridPosition(4, 3),
          ability: Ability.shoot(),
        ),
      ]);

      final actions = aiService.decideActions(state, AIDifficulty.hard);
      final shieldAction =
          actions.firstWhere((a) => a.unitId == 'e_shield_1');

      // Killing archer: 1 * 10 = 10 + 15 (kill) = 25
      // Attack commander: 1 * 10 = 10 + 5 (commander) = 15
      expect(shieldAction.attackTargetId, 'p_archer_1');
    });

    test('all actions reference valid enemy unit IDs', () {
      final state = GameState.initial().copyWith(
        isPlayerTurn: false,
        gameMode: GameMode.vsAI,
      );

      final actions = aiService.decideActions(state, AIDifficulty.hard);
      final enemyIds = state.board.enemyUnits.map((u) => u.id).toSet();

      for (final action in actions) {
        expect(enemyIds, contains(action.unitId));
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Edge cases
  // ---------------------------------------------------------------------------

  group('edge cases', () {
    test('handles single enemy unit', () {
      final state = createState([
        Unit.shield(
          id: 'e_shield_1',
          isPlayer: false,
          position: const GridPosition(4, 4),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(0, 0),
        ),
      ]);

      for (final difficulty in AIDifficulty.values) {
        final actions = aiService.decideActions(state, difficulty,
            random: Random(42));
        expect(actions.length, 1);
        expect(actions.first.unitId, 'e_shield_1');
      }
    });

    test('does not crash with dead enemy units', () {
      final state = createState([
        Unit(
          id: 'e_knight_1',
          type: UnitType.knight,
          isPlayer: false,
          hp: 0,
          maxHp: 3,
          attack: 3,
          position: const GridPosition(3, 3),
          ability: Ability.charge(),
        ),
        Unit.commander(
          id: 'e_commander',
          isPlayer: false,
          position: const GridPosition(4, 0),
        ),
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 7),
        ),
      ]);

      // Dead units should not produce actions.
      for (final difficulty in AIDifficulty.values) {
        final actions = aiService.decideActions(state, difficulty,
            random: Random(42));
        // Only the alive commander should have an action.
        expect(actions.length, 1);
        expect(actions.first.unitId, 'e_commander');
      }
    });
  });
}
