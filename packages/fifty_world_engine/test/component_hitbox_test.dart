import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_world_engine/fifty_world_engine.dart';

void main() {
  group('FiftyBaseComponent.containsLocalPoint', () {
    /// Helper to create a [FiftyStaticComponent] with the given [blockSize].
    ///
    /// Uses [FiftyStaticComponent] as a concrete, minimal subclass of
    /// [FiftyBaseComponent] so we can test the override directly without
    /// needing to mount the component in a Flame game.
    FiftyStaticComponent createComponent(FiftyBlockSize blockSize) {
      final model = FiftyWorldEntity(
        id: 'test-entity',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: blockSize,
      );
      return FiftyStaticComponent(model: model);
    }

    group('1x1 tile entity (64x64 pixel footprint)', () {
      late FiftyStaticComponent component;

      setUp(() {
        component = createComponent(FiftyBlockSize(1, 1));
      });

      test('point at center of tile returns true', () {
        expect(component.containsLocalPoint(Vector2(32, 32)), isTrue);
      });

      test('point at tile origin (0, 0) returns true', () {
        expect(component.containsLocalPoint(Vector2(0, 0)), isTrue);
      });

      test('point at tile edge (63.9, 63.9) returns true', () {
        expect(component.containsLocalPoint(Vector2(63.9, 63.9)), isTrue);
      });

      test('point at y=64 (below tile) returns false', () {
        expect(component.containsLocalPoint(Vector2(32, 64)), isFalse);
      });

      test('point at y=-1 (above tile) returns false', () {
        expect(component.containsLocalPoint(Vector2(32, -1)), isFalse);
      });

      test('point at x=64 (right of tile) returns false', () {
        expect(component.containsLocalPoint(Vector2(64, 32)), isFalse);
      });

      test('point at x=-1 (left of tile) returns false', () {
        expect(component.containsLocalPoint(Vector2(-1, 32)), isFalse);
      });
    });

    group('2x2 tile entity (128x128 pixel footprint)', () {
      late FiftyStaticComponent component;

      setUp(() {
        component = createComponent(FiftyBlockSize(2, 2));
      });

      test('point at center of footprint returns true', () {
        expect(component.containsLocalPoint(Vector2(64, 64)), isTrue);
      });

      test('point at origin returns true', () {
        expect(component.containsLocalPoint(Vector2(0, 0)), isTrue);
      });

      test('point at far edge (127.9, 127.9) returns true', () {
        expect(component.containsLocalPoint(Vector2(127.9, 127.9)), isTrue);
      });

      test('point outside footprint (128, 64) returns false', () {
        expect(component.containsLocalPoint(Vector2(128, 64)), isFalse);
      });

      test('point outside footprint (64, 128) returns false', () {
        expect(component.containsLocalPoint(Vector2(64, 128)), isFalse);
      });

      test('point at negative coordinate returns false', () {
        expect(component.containsLocalPoint(Vector2(-0.1, 64)), isFalse);
      });
    });

    group('non-square entity (3x1 tiles)', () {
      late FiftyStaticComponent component;

      setUp(() {
        component = createComponent(FiftyBlockSize(3, 1));
      });

      test('point within wide footprint returns true', () {
        // 3 tiles wide = 192px, 1 tile tall = 64px
        expect(component.containsLocalPoint(Vector2(100, 32)), isTrue);
      });

      test('point beyond width returns false', () {
        expect(component.containsLocalPoint(Vector2(192, 32)), isFalse);
      });

      test('point beyond height returns false', () {
        expect(component.containsLocalPoint(Vector2(100, 64)), isFalse);
      });
    });

    test('blockSize uses FiftyWorldConfig.blockSize (64.0)', () {
      // Verify the constant is what the tests assume
      expect(FiftyWorldConfig.blockSize, equals(64.0));
    });
  });
}
