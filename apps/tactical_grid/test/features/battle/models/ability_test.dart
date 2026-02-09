import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Factory constructors
  // ---------------------------------------------------------------------------

  group('factory constructors', () {
    test('rally has correct defaults', () {
      final ability = Ability.rally();

      expect(ability.type, AbilityType.rally);
      expect(ability.name, 'Rally');
      expect(ability.description, '+1 ATK to adjacent allies');
      expect(ability.cooldownMax, 3);
      expect(ability.currentCooldown, 0);
      expect(ability.isPassive, false);
      expect(ability.range, 1);
    });

    test('charge is passive with zero cooldown', () {
      final ability = Ability.charge();

      expect(ability.type, AbilityType.charge);
      expect(ability.name, 'Charge');
      expect(ability.cooldownMax, 0);
      expect(ability.isPassive, true);
      expect(ability.range, 0);
    });

    test('block targets self with cooldown 2', () {
      final ability = Ability.block();

      expect(ability.type, AbilityType.block);
      expect(ability.name, 'Block');
      expect(ability.cooldownMax, 2);
      expect(ability.isPassive, false);
      expect(ability.range, 0);
    });

    test('shoot has range 3 and cooldown 2', () {
      final ability = Ability.shoot();

      expect(ability.type, AbilityType.shoot);
      expect(ability.name, 'Shoot');
      expect(ability.cooldownMax, 2);
      expect(ability.range, 3);
    });

    test('fireball has range 3 and cooldown 3', () {
      final ability = Ability.fireball();

      expect(ability.type, AbilityType.fireball);
      expect(ability.name, 'Fireball');
      expect(ability.cooldownMax, 3);
      expect(ability.range, 3);
    });

    test('reveal has range 2 and cooldown 2', () {
      final ability = Ability.reveal();

      expect(ability.type, AbilityType.reveal);
      expect(ability.name, 'Reveal');
      expect(ability.cooldownMax, 2);
      expect(ability.range, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // isReady
  // ---------------------------------------------------------------------------

  group('isReady', () {
    test('returns true when cooldown is 0 and not passive', () {
      final ability = Ability.rally();

      expect(ability.isReady, true);
    });

    test('returns false when on cooldown', () {
      final ability = Ability.rally();
      ability.activate();

      expect(ability.isReady, false);
    });

    test('returns false for passive abilities even at cooldown 0', () {
      final ability = Ability.charge();

      expect(ability.currentCooldown, 0);
      expect(ability.isReady, false);
    });
  });

  // ---------------------------------------------------------------------------
  // activate
  // ---------------------------------------------------------------------------

  group('activate', () {
    test('sets currentCooldown to cooldownMax', () {
      final ability = Ability.rally();
      ability.activate();

      expect(ability.currentCooldown, 3);
    });

    test('resets cooldown when called multiple times', () {
      final ability = Ability.block();
      ability.activate();
      ability.tickCooldown();
      expect(ability.currentCooldown, 1);

      ability.activate();
      expect(ability.currentCooldown, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // tickCooldown
  // ---------------------------------------------------------------------------

  group('tickCooldown', () {
    test('decrements cooldown by 1', () {
      final ability = Ability.fireball();
      ability.activate();
      expect(ability.currentCooldown, 3);

      ability.tickCooldown();
      expect(ability.currentCooldown, 2);

      ability.tickCooldown();
      expect(ability.currentCooldown, 1);

      ability.tickCooldown();
      expect(ability.currentCooldown, 0);
    });

    test('does not go below 0', () {
      final ability = Ability.rally();
      expect(ability.currentCooldown, 0);

      ability.tickCooldown();
      expect(ability.currentCooldown, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  group('copyWith', () {
    test('creates independent copy with same values', () {
      final original = Ability.rally();
      original.activate();
      final copy = original.copyWith();

      expect(copy.type, original.type);
      expect(copy.name, original.name);
      expect(copy.currentCooldown, original.currentCooldown);

      copy.tickCooldown();
      expect(copy.currentCooldown, 2);
      expect(original.currentCooldown, 3);
    });

    test('overrides specified fields', () {
      final original = Ability.rally();
      final copy = original.copyWith(currentCooldown: 2, range: 5);

      expect(copy.currentCooldown, 2);
      expect(copy.range, 5);
      expect(copy.name, 'Rally');
    });
  });
}
