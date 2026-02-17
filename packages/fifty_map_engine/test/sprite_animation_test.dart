import 'package:flame/components.dart' show Vector2;
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:fifty_map_engine/src/components/sprites/animated_entity_component.dart';

void main() {
  group('SpriteAnimationConfig', () {
    test('creates config with required fields', () {
      final config = SpriteAnimationConfig(
        spriteSheetAsset: 'characters/hero_sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': const SpriteAnimationStateConfig(row: 0, frameCount: 4),
          'walk': const SpriteAnimationStateConfig(row: 1, frameCount: 6),
        },
      );

      expect(config.spriteSheetAsset, equals('characters/hero_sheet.png'));
      expect(config.frameWidth, equals(32));
      expect(config.frameHeight, equals(32));
      expect(config.states.length, equals(2));
      expect(config.defaultState, equals('idle'));
    });

    test('uses custom defaultState', () {
      final config = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 16,
        frameHeight: 16,
        states: {
          'idle': const SpriteAnimationStateConfig(row: 0, frameCount: 2),
          'patrol': const SpriteAnimationStateConfig(row: 1, frameCount: 4),
        },
        defaultState: 'patrol',
      );

      expect(config.defaultState, equals('patrol'));
    });
  });

  group('SpriteAnimationStateConfig', () {
    test('creates state config with required fields', () {
      const stateConfig = SpriteAnimationStateConfig(
        row: 2,
        frameCount: 8,
      );

      expect(stateConfig.row, equals(2));
      expect(stateConfig.frameCount, equals(8));
      expect(stateConfig.stepTime, equals(0.1));
      expect(stateConfig.loop, isTrue);
    });

    test('accepts custom stepTime and loop', () {
      const stateConfig = SpriteAnimationStateConfig(
        row: 3,
        frameCount: 4,
        stepTime: 0.2,
        loop: false,
      );

      expect(stateConfig.row, equals(3));
      expect(stateConfig.frameCount, equals(4));
      expect(stateConfig.stepTime, equals(0.2));
      expect(stateConfig.loop, isFalse);
    });
  });

  group('FiftyMapEntity with spriteAnimation', () {
    test('entity defaults spriteAnimation to null', () {
      final entity = FiftyMapEntity(
        id: 'test',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      expect(entity.spriteAnimation, isNull);
    });

    test('entity accepts spriteAnimation config', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'chars/hero_sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
          'walk': SpriteAnimationStateConfig(row: 1, frameCount: 6),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(2, 3),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig,
      );

      expect(entity.spriteAnimation, isNotNull);
      expect(entity.spriteAnimation!.spriteSheetAsset,
          equals('chars/hero_sheet.png'));
      expect(entity.spriteAnimation!.frameWidth, equals(32));
      expect(entity.spriteAnimation!.frameHeight, equals(32));
      expect(entity.spriteAnimation!.states.length, equals(2));
      expect(entity.spriteAnimation!.states.containsKey('idle'), isTrue);
      expect(entity.spriteAnimation!.states.containsKey('walk'), isTrue);
    });

    test('copyWith preserves spriteAnimation when not overridden', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig,
      );

      final copy = entity.copyWith(id: 'hero-copy');

      expect(copy.id, equals('hero-copy'));
      expect(copy.spriteAnimation, isNotNull);
      expect(copy.spriteAnimation!.spriteSheetAsset, equals('sheet.png'));
    });

    test('copyWith can override spriteAnimation', () {
      const animConfig1 = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet1.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      const animConfig2 = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet2.png',
        frameWidth: 64,
        frameHeight: 64,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 8),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig1,
      );

      final copy = entity.copyWith(spriteAnimation: animConfig2);

      expect(copy.spriteAnimation!.spriteSheetAsset, equals('sheet2.png'));
      expect(copy.spriteAnimation!.frameWidth, equals(64));
    });

    test('changePosition preserves spriteAnimation', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig,
      );

      final moved = entity.changePosition(gridPosition: Vector2(5, 3));

      expect(moved.spriteAnimation, isNotNull);
      expect(moved.spriteAnimation!.spriteSheetAsset, equals('sheet.png'));
      expect(moved.gridPosition.x, equals(5));
      expect(moved.gridPosition.y, equals(3));
    });

    test('serialization ignores spriteAnimation (not yet serializable)', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig,
      );

      final json = entity.toJson();
      // spriteAnimation is not included in toJson
      expect(json.containsKey('spriteAnimation'), isFalse);
      expect(json.containsKey('sprite_animation'), isFalse);

      // Deserialized entity will have null spriteAnimation
      final restored = FiftyMapEntity.fromJson(json);
      expect(restored.spriteAnimation, isNull);
    });
  });

  group('AnimatedEntityComponent', () {
    test('extends FiftyMovableComponent', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      final entity = FiftyMapEntity(
        id: 'hero',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
        spriteAnimation: animConfig,
      );

      final component = AnimatedEntityComponent(
        model: entity,
        animConfig: animConfig,
      );

      expect(component, isA<FiftyMovableComponent>());
      expect(component, isA<FiftyBaseComponent>());
      expect(component.currentState, equals('idle'));
    });

    test('initializes with custom default state', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
          'patrol': SpriteAnimationStateConfig(row: 1, frameCount: 6),
        },
        defaultState: 'patrol',
      );

      final entity = FiftyMapEntity(
        id: 'guard',
        type: 'character',
        asset: 'chars/guard.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      final component = AnimatedEntityComponent(
        model: entity,
        animConfig: animConfig,
      );

      expect(component.currentState, equals('patrol'));
    });

    test('stores model and animConfig', () {
      const animConfig = SpriteAnimationConfig(
        spriteSheetAsset: 'sheet.png',
        frameWidth: 32,
        frameHeight: 32,
        states: {
          'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
        },
      );

      final entity = FiftyMapEntity(
        id: 'mob',
        type: 'monster',
        asset: 'monsters/goblin.png',
        gridPosition: Vector2(3, 4),
        blockSize: FiftyBlockSize(1, 1),
      );

      final component = AnimatedEntityComponent(
        model: entity,
        animConfig: animConfig,
      );

      expect(component.model.id, equals('mob'));
      expect(component.animConfig.spriteSheetAsset, equals('sheet.png'));
      expect(component.animConfig.frameWidth, equals(32));
    });
  });
}
