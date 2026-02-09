import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // New unit types - factory constructors
  // ---------------------------------------------------------------------------

  group('archer factory', () {
    test('creates archer with correct stats', () {
      final archer = Unit.archer(
        id: 'archer_1',
        isPlayer: true,
        position: GridPosition(3, 6),
      );

      expect(archer.type, UnitType.archer);
      expect(archer.hp, 2);
      expect(archer.maxHp, 2);
      expect(archer.attack, 2);
      expect(archer.displayName, 'Archer');
    });

    test('has shoot ability', () {
      final archer = Unit.archer(
        id: 'archer_1',
        isPlayer: true,
        position: GridPosition(3, 6),
      );

      expect(archer.ability, isNotNull);
      expect(archer.ability!.type, AbilityType.shoot);
      expect(archer.ability!.range, 3);
    });
  });

  group('mage factory', () {
    test('creates mage with correct stats', () {
      final mage = Unit.mage(
        id: 'mage_1',
        isPlayer: true,
        position: GridPosition(4, 6),
      );

      expect(mage.type, UnitType.mage);
      expect(mage.hp, 2);
      expect(mage.maxHp, 2);
      expect(mage.attack, 2);
      expect(mage.displayName, 'Mage');
    });

    test('has fireball ability', () {
      final mage = Unit.mage(
        id: 'mage_1',
        isPlayer: true,
        position: GridPosition(4, 6),
      );

      expect(mage.ability, isNotNull);
      expect(mage.ability!.type, AbilityType.fireball);
    });
  });

  group('scout factory', () {
    test('creates scout with correct stats', () {
      final scout = Unit.scout(
        id: 'scout_1',
        isPlayer: true,
        position: GridPosition(5, 6),
      );

      expect(scout.type, UnitType.scout);
      expect(scout.hp, 2);
      expect(scout.maxHp, 2);
      expect(scout.attack, 1);
      expect(scout.displayName, 'Scout');
    });

    test('has reveal ability', () {
      final scout = Unit.scout(
        id: 'scout_1',
        isPlayer: true,
        position: GridPosition(5, 6),
      );

      expect(scout.ability, isNotNull);
      expect(scout.ability!.type, AbilityType.reveal);
    });
  });

  // ---------------------------------------------------------------------------
  // Existing units now have abilities
  // ---------------------------------------------------------------------------

  group('existing unit abilities', () {
    test('commander has rally ability', () {
      final commander = Unit.commander(
        id: 'cmd_1',
        isPlayer: true,
        position: GridPosition(4, 7),
      );

      expect(commander.ability, isNotNull);
      expect(commander.ability!.type, AbilityType.rally);
    });

    test('knight has charge ability (passive)', () {
      final knight = Unit.knight(
        id: 'kn_1',
        isPlayer: true,
        position: GridPosition(2, 7),
      );

      expect(knight.ability, isNotNull);
      expect(knight.ability!.type, AbilityType.charge);
      expect(knight.ability!.isPassive, true);
    });

    test('shield has block ability', () {
      final shield = Unit.shield(
        id: 'sh_1',
        isPlayer: true,
        position: GridPosition(3, 7),
      );

      expect(shield.ability, isNotNull);
      expect(shield.ability!.type, AbilityType.block);
    });
  });

  // ---------------------------------------------------------------------------
  // effectiveAttack
  // ---------------------------------------------------------------------------

  group('effectiveAttack', () {
    test('equals base attack when no bonus', () {
      final unit = Unit.knight(
        id: 'kn_1',
        isPlayer: true,
        position: GridPosition(2, 7),
      );

      expect(unit.effectiveAttack, 3);
    });

    test('includes attack bonus', () {
      final unit = Unit.knight(
        id: 'kn_1',
        isPlayer: true,
        position: GridPosition(2, 7),
      );
      unit.attackBonus = 1;

      expect(unit.effectiveAttack, 4);
    });
  });

  // ---------------------------------------------------------------------------
  // movementRange
  // ---------------------------------------------------------------------------

  group('movementRange', () {
    test('archer has range 2', () {
      final archer = Unit.archer(
        id: 'a1',
        isPlayer: true,
        position: GridPosition(0, 0),
      );
      expect(archer.movementRange, 2);
    });

    test('mage has range 2', () {
      final mage = Unit.mage(
        id: 'm1',
        isPlayer: true,
        position: GridPosition(0, 0),
      );
      expect(mage.movementRange, 2);
    });

    test('scout has range 3', () {
      final scout = Unit.scout(
        id: 's1',
        isPlayer: true,
        position: GridPosition(0, 0),
      );
      expect(scout.movementRange, 3);
    });
  });

  // ---------------------------------------------------------------------------
  // getValidMovePositions for new types
  // ---------------------------------------------------------------------------

  group('getValidMovePositions', () {
    test('archer moves orthogonally', () {
      final archer = Unit.archer(
        id: 'a1',
        isPlayer: true,
        position: GridPosition(4, 4),
      );
      final positions = archer.getValidMovePositions([archer]);

      // Should have cardinal positions only, not diagonals
      expect(positions, contains(GridPosition(4, 3)));
      expect(positions, contains(GridPosition(4, 2)));
      expect(positions, contains(GridPosition(5, 4)));
      expect(positions, isNot(contains(GridPosition(5, 5))));
      expect(positions, isNot(contains(GridPosition(3, 3))));
    });

    test('mage moves diagonally', () {
      final mage = Unit.mage(
        id: 'm1',
        isPlayer: true,
        position: GridPosition(4, 4),
      );
      final positions = mage.getValidMovePositions([mage]);

      // Should have diagonal positions only, not cardinal
      expect(positions, contains(GridPosition(3, 3)));
      expect(positions, contains(GridPosition(5, 5)));
      expect(positions, isNot(contains(GridPosition(4, 3))));
      expect(positions, isNot(contains(GridPosition(5, 4))));
    });

    test('scout moves in all 8 directions', () {
      final scout = Unit.scout(
        id: 's1',
        isPlayer: true,
        position: GridPosition(4, 4),
      );
      final positions = scout.getValidMovePositions([scout]);

      // Cardinal
      expect(positions, contains(GridPosition(4, 3)));
      expect(positions, contains(GridPosition(5, 4)));
      // Diagonal
      expect(positions, contains(GridPosition(5, 5)));
      expect(positions, contains(GridPosition(3, 3)));
      // 3 steps
      expect(positions, contains(GridPosition(4, 1)));
      expect(positions, contains(GridPosition(7, 4)));
    });

    test('archer blocked by occupied tile', () {
      final archer = Unit.archer(
        id: 'a1',
        isPlayer: true,
        position: GridPosition(4, 4),
      );
      final blocker = Unit.shield(
        id: 'sh1',
        isPlayer: false,
        position: GridPosition(4, 3),
      );
      final positions = archer.getValidMovePositions([archer, blocker]);

      // Upward direction blocked: no (4,3) or (4,2)
      expect(positions, isNot(contains(GridPosition(4, 3))));
      expect(positions, isNot(contains(GridPosition(4, 2))));
    });
  });

  // ---------------------------------------------------------------------------
  // resetTurnState
  // ---------------------------------------------------------------------------

  group('resetTurnState', () {
    test('clears attackBonus and isBlocking', () {
      final unit = Unit.commander(
        id: 'cmd_1',
        isPlayer: true,
        position: GridPosition(4, 7),
      );
      unit.attackBonus = 2;
      unit.isBlocking = true;
      unit.hasMovedThisTurn = true;
      unit.hasActedThisTurn = true;

      unit.resetTurnState();

      expect(unit.hasMovedThisTurn, false);
      expect(unit.hasActedThisTurn, false);
      expect(unit.attackBonus, 0);
      expect(unit.isBlocking, false);
    });
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  group('copyWith with new fields', () {
    test('copies ability independently', () {
      final unit = Unit.commander(
        id: 'cmd_1',
        isPlayer: true,
        position: GridPosition(4, 7),
      );
      unit.ability!.activate();

      final copy = unit.copyWith();

      expect(copy.ability, isNotNull);
      expect(copy.ability!.currentCooldown, 3);

      // Mutating copy does not affect original
      copy.ability!.tickCooldown();
      expect(copy.ability!.currentCooldown, 2);
      expect(unit.ability!.currentCooldown, 3);
    });

    test('copies isBlocking and attackBonus', () {
      final unit = Unit.shield(
        id: 'sh_1',
        isPlayer: true,
        position: GridPosition(3, 7),
      );
      unit.isBlocking = true;
      unit.attackBonus = 1;

      final copy = unit.copyWith();

      expect(copy.isBlocking, true);
      expect(copy.attackBonus, 1);
    });

    test('overrides ability when provided', () {
      final unit = Unit.commander(
        id: 'cmd_1',
        isPlayer: true,
        position: GridPosition(4, 7),
      );

      final copy = unit.copyWith(ability: Ability.block());

      expect(copy.ability!.type, AbilityType.block);
      expect(unit.ability!.type, AbilityType.rally);
    });

    test('overrides isBlocking and attackBonus when provided', () {
      final unit = Unit.shield(
        id: 'sh_1',
        isPlayer: true,
        position: GridPosition(3, 7),
      );

      final copy = unit.copyWith(isBlocking: true, attackBonus: 5);

      expect(copy.isBlocking, true);
      expect(copy.attackBonus, 5);
      expect(unit.isBlocking, false);
      expect(unit.attackBonus, 0);
    });
  });
}
