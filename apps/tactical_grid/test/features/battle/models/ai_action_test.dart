import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  group('AIAction.move', () {
    test('creates a move action with correct fields', () {
      final action = AIAction.move('e_knight_1', const GridPosition(3, 2));

      expect(action.unitId, 'e_knight_1');
      expect(action.type, AIActionType.move);
      expect(action.moveTarget, const GridPosition(3, 2));
      expect(action.attackTargetId, isNull);
      expect(action.abilityType, isNull);
      expect(action.abilityTarget, isNull);
    });
  });

  group('AIAction.attack', () {
    test('creates an attack action with correct fields', () {
      final action = AIAction.attack('e_knight_1', 'p_shield_1');

      expect(action.unitId, 'e_knight_1');
      expect(action.type, AIActionType.attack);
      expect(action.attackTargetId, 'p_shield_1');
      expect(action.moveTarget, isNull);
      expect(action.abilityType, isNull);
    });
  });

  group('AIAction.ability', () {
    test('creates an ability action with type', () {
      final action = AIAction.ability('e_commander', AbilityType.rally);

      expect(action.unitId, 'e_commander');
      expect(action.type, AIActionType.ability);
      expect(action.abilityType, AbilityType.rally);
      expect(action.moveTarget, isNull);
      expect(action.attackTargetId, isNull);
    });

    test('creates an ability action with target position', () {
      final action = AIAction.ability(
        'e_archer_1',
        AbilityType.shoot,
        target: const GridPosition(4, 4),
      );

      expect(action.abilityType, AbilityType.shoot);
      expect(action.abilityTarget, const GridPosition(4, 4));
    });
  });

  group('AIAction.moveAndAttack', () {
    test('creates a combined move+attack action', () {
      final action = AIAction.moveAndAttack(
        'e_knight_1',
        const GridPosition(3, 5),
        'p_shield_1',
      );

      expect(action.unitId, 'e_knight_1');
      expect(action.type, AIActionType.moveAndAttack);
      expect(action.moveTarget, const GridPosition(3, 5));
      expect(action.attackTargetId, 'p_shield_1');
    });
  });

  group('AIAction.moveAndAbility', () {
    test('creates a combined move+ability action', () {
      final action = AIAction.moveAndAbility(
        'e_mage_1',
        const GridPosition(2, 3),
        AbilityType.fireball,
        abilityTarget: const GridPosition(4, 5),
      );

      expect(action.unitId, 'e_mage_1');
      expect(action.type, AIActionType.moveAndAbility);
      expect(action.moveTarget, const GridPosition(2, 3));
      expect(action.abilityType, AbilityType.fireball);
      expect(action.abilityTarget, const GridPosition(4, 5));
    });
  });

  group('AIAction.wait', () {
    test('creates a wait action with no targets', () {
      final action = AIAction.wait('e_shield_1');

      expect(action.unitId, 'e_shield_1');
      expect(action.type, AIActionType.wait);
      expect(action.moveTarget, isNull);
      expect(action.attackTargetId, isNull);
      expect(action.abilityType, isNull);
      expect(action.abilityTarget, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // toString
  // ---------------------------------------------------------------------------

  group('toString', () {
    test('includes unit ID and action type', () {
      final action = AIAction.move('e_knight_1', const GridPosition(3, 2));
      final str = action.toString();

      expect(str, contains('e_knight_1'));
      expect(str, contains('move'));
    });
  });
}
