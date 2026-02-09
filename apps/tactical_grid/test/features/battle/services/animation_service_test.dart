import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tactical_grid/features/battle/models/position.dart';
import 'package:tactical_grid/features/battle/services/animation_service.dart';

void main() {
  late AnimationService service;

  setUp(() {
    // GetX test setup
    Get.testMode = true;
    service = AnimationService();
  });

  tearDown(() {
    service.onClose();
    Get.reset();
  });

  group('AnimationService', () {
    group('initial state', () {
      test('activeAnimations starts empty', () {
        expect(service.activeAnimations, isEmpty);
      });

      test('isAnimating is false initially', () {
        expect(service.isAnimating, isFalse);
      });

      test('flashingUnitIds starts empty', () {
        expect(service.flashingUnitIds, isEmpty);
      });
    });

    group('playMoveAnimation', () {
      test('adds animation event to activeAnimations', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        expect(service.activeAnimations, hasLength(1));
        expect(service.activeAnimations.first.type, AnimationType.move);
        expect(service.activeAnimations.first.unitId, 'unit_1');
      });

      test('sets isAnimating to true', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        expect(service.isAnimating, isTrue);
      });

      test('stores from and to positions', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(2, 3),
          const GridPosition(4, 5),
        );
        final event = service.activeAnimations.first;
        expect(event.fromPosition, const GridPosition(2, 3));
        expect(event.toPosition, const GridPosition(4, 5));
      });

      test('duration is 300ms', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        expect(
          service.activeAnimations.first.duration,
          const Duration(milliseconds: 300),
        );
      });
    });

    group('playAttackAnimation', () {
      test('adds attack animation event', () {
        service.playAttackAnimation(
          'attacker_1',
          const GridPosition(0, 0),
          const GridPosition(1, 0),
        );
        expect(service.activeAnimations, hasLength(1));
        expect(service.activeAnimations.first.type, AnimationType.attack);
        expect(service.activeAnimations.first.unitId, 'attacker_1');
      });

      test('duration is 400ms', () {
        service.playAttackAnimation(
          'attacker_1',
          const GridPosition(0, 0),
          const GridPosition(1, 0),
        );
        expect(
          service.activeAnimations.first.duration,
          const Duration(milliseconds: 400),
        );
      });
    });

    group('playDamagePopup', () {
      test('adds damage animation event', () {
        service.playDamagePopup(const GridPosition(3, 4), 5);
        expect(service.activeAnimations, hasLength(1));
        expect(service.activeAnimations.first.type, AnimationType.damage);
        expect(service.activeAnimations.first.damageAmount, 5);
      });

      test('uses position-based unitId', () {
        service.playDamagePopup(const GridPosition(3, 4), 5);
        expect(service.activeAnimations.first.unitId, 'damage_3_4');
      });

      test('duration is 800ms', () {
        service.playDamagePopup(const GridPosition(3, 4), 5);
        expect(
          service.activeAnimations.first.duration,
          const Duration(milliseconds: 800),
        );
      });
    });

    group('playDefeatAnimation', () {
      test('adds defeat animation event', () {
        service.playDefeatAnimation('unit_1', const GridPosition(2, 2));
        expect(service.activeAnimations, hasLength(1));
        expect(service.activeAnimations.first.type, AnimationType.defeat);
        expect(service.activeAnimations.first.unitId, 'unit_1');
      });

      test('duration is 500ms', () {
        service.playDefeatAnimation('unit_1', const GridPosition(2, 2));
        expect(
          service.activeAnimations.first.duration,
          const Duration(milliseconds: 500),
        );
      });
    });

    group('completeAnimation', () {
      test('removes event from activeAnimations', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        final eventId = service.activeAnimations.first.id;
        service.completeAnimation(eventId);
        expect(service.activeAnimations, isEmpty);
      });

      test('sets isAnimating to false when last animation completes', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        final eventId = service.activeAnimations.first.id;
        service.completeAnimation(eventId);
        expect(service.isAnimating, isFalse);
      });

      test('resolves the animation future', () async {
        final future = service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        final eventId = service.activeAnimations.first.id;
        service.completeAnimation(eventId);
        // Should complete without timeout.
        await future;
      });

      test('handles unknown eventId gracefully', () {
        service.completeAnimation('nonexistent_id');
        // No exception thrown.
        expect(service.activeAnimations, isEmpty);
      });

      test('keeps other animations active', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        service.playAttackAnimation(
          'unit_2',
          const GridPosition(2, 2),
          const GridPosition(3, 3),
        );
        expect(service.activeAnimations, hasLength(2));

        final firstId = service.activeAnimations.first.id;
        service.completeAnimation(firstId);
        expect(service.activeAnimations, hasLength(1));
        expect(service.isAnimating, isTrue);
      });
    });

    group('isUnitAnimating', () {
      test('returns true for unit with active animation', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        expect(service.isUnitAnimating('unit_1'), isTrue);
      });

      test('returns false for unit without active animation', () {
        expect(service.isUnitAnimating('unit_1'), isFalse);
      });

      test('returns false after animation completes', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        final eventId = service.activeAnimations.first.id;
        service.completeAnimation(eventId);
        expect(service.isUnitAnimating('unit_1'), isFalse);
      });
    });

    group('triggerFlash', () {
      test('adds unit to flashingUnitIds', () {
        service.triggerFlash('unit_1');
        expect(service.flashingUnitIds, contains('unit_1'));
      });

      test('auto-removes after flash duration', () async {
        service.triggerFlash('unit_1');
        expect(service.flashingUnitIds, contains('unit_1'));
        // Wait longer than flash duration (150ms).
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(service.flashingUnitIds, isNot(contains('unit_1')));
      });
    });

    group('onClose', () {
      test('completes all pending futures', () async {
        final future1 = service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        final future2 = service.playAttackAnimation(
          'unit_2',
          const GridPosition(2, 2),
          const GridPosition(3, 3),
        );

        service.onClose();

        // Both futures should complete without timeout.
        await future1;
        await future2;
      });

      test('clears activeAnimations', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        service.onClose();
        expect(service.activeAnimations, isEmpty);
      });

      test('clears flashingUnitIds', () {
        service.triggerFlash('unit_1');
        service.onClose();
        expect(service.flashingUnitIds, isEmpty);
      });
    });

    group('unique event IDs', () {
      test('generates unique IDs for each animation', () {
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(0, 0),
          const GridPosition(1, 1),
        );
        service.playMoveAnimation(
          'unit_1',
          const GridPosition(1, 1),
          const GridPosition(2, 2),
        );
        final ids = service.activeAnimations.map((e) => e.id).toSet();
        expect(ids, hasLength(2));
      });
    });
  });
}
