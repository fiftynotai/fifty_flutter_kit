import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_map_engine/fifty_map_engine.dart';

void main() {
  group('FiftyMapEntity', () {
    test('creates entity with required fields', () {
      final entity = FiftyMapEntity(
        id: 'test-entity',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(4, 3),
      );

      expect(entity.id, equals('test-entity'));
      expect(entity.type, equals('room'));
      expect(entity.asset, equals('rooms/test.png'));
      expect(entity.gridPosition.x, equals(0));
      expect(entity.gridPosition.y, equals(0));
      expect(entity.blockSize.width, equals(4));
      expect(entity.blockSize.height, equals(3));
    });

    test('calculates position from grid position', () {
      final entity = FiftyMapEntity(
        id: 'test-entity',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(2, 3),
        blockSize: FiftyBlockSize(1, 1),
      );

      // Position: x = gridX * blockSize, y = (gridY + blockHeight) * blockSize
      // (bottomLeft anchor requires height offset so entity aligns with tile)
      expect(entity.x, equals(2 * 64.0));
      expect(entity.y, equals((3 + 1) * 64.0));
    });

    test('calculates size from block size', () {
      final entity = FiftyMapEntity(
        id: 'test-entity',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(4, 3),
      );

      // Size should be blockSize * 64.0
      expect(entity.size.x, equals(4 * 64.0));
      expect(entity.size.y, equals(3 * 64.0));
    });

    test('serializes to JSON and deserializes back', () {
      final entity = FiftyMapEntity(
        id: 'test-entity',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(2, 3),
        blockSize: FiftyBlockSize(4, 3),
        zIndex: 5,
        quarterTurns: 1,
        text: 'Test Room',
      );

      final json = entity.toJson();
      final restored = FiftyMapEntity.fromJson(json);

      expect(restored.id, equals(entity.id));
      expect(restored.type, equals(entity.type));
      expect(restored.asset, equals(entity.asset));
      expect(restored.gridPosition.x, equals(entity.gridPosition.x));
      expect(restored.gridPosition.y, equals(entity.gridPosition.y));
      expect(restored.blockSize.width, equals(entity.blockSize.width));
      expect(restored.blockSize.height, equals(entity.blockSize.height));
      expect(restored.zIndex, equals(entity.zIndex));
      expect(restored.quarterTurns, equals(entity.quarterTurns));
      expect(restored.text, equals(entity.text));
    });
  });

  group('FiftyBlockSize', () {
    test('creates from constructor', () {
      final size = FiftyBlockSize(4, 3);
      expect(size.width, equals(4));
      expect(size.height, equals(3));
    });

    test('creates from JSON', () {
      final json = {'width': 4.0, 'height': 3.0};
      final size = FiftyBlockSize.fromJson(json);
      expect(size.width, equals(4));
      expect(size.height, equals(3));
    });

    test('converts to JSON', () {
      final size = FiftyBlockSize(4, 3);
      final json = size.toJson();
      expect(json['width'], equals(4));
      expect(json['height'], equals(3));
    });
  });

  group('FiftyMapEvent', () {
    test('creates event with required fields', () {
      final event = FiftyMapEvent(
        text: 'Quest',
        type: FiftyEventType.npc,
      );

      expect(event.text, equals('Quest'));
      expect(event.type, equals(FiftyEventType.npc));
      expect(event.alignment, equals(FiftyEventAlignment.topLeft));
      expect(event.clicked, isFalse);
    });

    test('serializes to JSON and deserializes back', () {
      final event = FiftyMapEvent(
        text: 'Quest',
        type: FiftyEventType.npc,
        alignment: FiftyEventAlignment.center,
        clicked: true,
      );

      final json = event.toJson();
      final restored = FiftyMapEvent.fromJson(json);

      expect(restored.text, equals(event.text));
      expect(restored.type, equals(event.type));
      expect(restored.alignment, equals(event.alignment));
      expect(restored.clicked, equals(event.clicked));
    });
  });

  group('FiftyEntityType', () {
    test('parses from string', () {
      expect(FiftyEntityType.fromString('room'), equals(FiftyEntityType.room));
      expect(
          FiftyEntityType.fromString('monster'), equals(FiftyEntityType.monster));
      expect(FiftyEntityType.fromString('character'),
          equals(FiftyEntityType.character));
      expect(FiftyEntityType.fromString('door'), equals(FiftyEntityType.door));
      expect(FiftyEntityType.fromString('furniture'),
          equals(FiftyEntityType.furniture));
      expect(FiftyEntityType.fromString('event'), equals(FiftyEntityType.event));
      expect(
          FiftyEntityType.fromString('unknown'), equals(FiftyEntityType.unknown));
    });

    test('returns unknown for invalid string', () {
      expect(FiftyEntityType.fromString('invalid'),
          equals(FiftyEntityType.unknown));
    });

    test('value returns string representation', () {
      expect(FiftyEntityType.room.value, equals('room'));
      expect(FiftyEntityType.monster.value, equals('monster'));
    });
  });

  group('FiftyMapEntityExtension', () {
    test('copyWith creates new instance with overrides', () {
      final original = FiftyMapEntity(
        id: 'original',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(4, 3),
      );

      final copy = original.copyWith(id: 'copy', zIndex: 10);

      expect(copy.id, equals('copy'));
      expect(copy.zIndex, equals(10));
      expect(copy.type, equals(original.type));
      expect(copy.asset, equals(original.asset));
    });

    test('changePosition updates grid and pixel position', () {
      final entity = FiftyMapEntity(
        id: 'test',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      final moved = entity.changePosition(gridPosition: Vector2(5, 3));

      expect(moved.gridPosition.x, equals(5));
      expect(moved.gridPosition.y, equals(3));
      expect(moved.x, equals(5 * 64.0));
      expect(moved.y, equals((3 + 1) * 64.0));
    });

    test('entityType returns correct type', () {
      final room = FiftyMapEntity(
        id: 'test',
        type: 'room',
        asset: 'rooms/test.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      expect(room.entityType, equals(FiftyEntityType.room));
      expect(room.isRoom, isTrue);
      expect(room.isMonster, isFalse);
    });

    test('isMovable returns true for characters and monsters', () {
      final character = FiftyMapEntity(
        id: 'char',
        type: 'character',
        asset: 'chars/hero.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      final monster = FiftyMapEntity(
        id: 'mon',
        type: 'monster',
        asset: 'monsters/goblin.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      final furniture = FiftyMapEntity(
        id: 'furn',
        type: 'furniture',
        asset: 'furniture/chair.png',
        gridPosition: Vector2(0, 0),
        blockSize: FiftyBlockSize(1, 1),
      );

      expect(character.isMovable, isTrue);
      expect(monster.isMovable, isTrue);
      expect(furniture.isMovable, isFalse);
    });
  });

  group('FiftyRenderPriority', () {
    test('has correct priority values', () {
      expect(FiftyRenderPriority.background, equals(0));
      expect(FiftyRenderPriority.furniture, equals(10));
      expect(FiftyRenderPriority.door, equals(20));
      expect(FiftyRenderPriority.monster, equals(30));
      expect(FiftyRenderPriority.character, equals(40));
      expect(FiftyRenderPriority.event, equals(50));
      expect(FiftyRenderPriority.uiOverlay, equals(100));
    });
  });

  group('FiftyMapConfig', () {
    test('has correct block size', () {
      expect(FiftyMapConfig.blockSize, equals(64.0));
    });
  });

  group('FiftyAssetLoader', () {
    setUp(() {
      FiftyAssetLoader.reset();
    });

    test('registers assets', () {
      FiftyAssetLoader.registerAssets(['test1.png', 'test2.png']);
      expect(FiftyAssetLoader.registeredAssets, contains('test1.png'));
      expect(FiftyAssetLoader.registeredAssets, contains('test2.png'));
    });

    test('does not duplicate assets', () {
      FiftyAssetLoader.registerAssets(['test.png']);
      FiftyAssetLoader.registerAssets(['test.png']);
      expect(FiftyAssetLoader.registeredAssets.length, equals(1));
    });

    test('reset clears registry', () {
      FiftyAssetLoader.registerAssets(['test.png']);
      FiftyAssetLoader.reset();
      expect(FiftyAssetLoader.registeredAssets, isEmpty);
    });
  });

  group('FiftyMapLoader', () {
    test('loads from JSON string', () {
      final json = '''
      [
        {
          "id": "room1",
          "type": "room",
          "asset": "rooms/test.png",
          "grid_position": {"x": 0, "y": 0},
          "size": {"width": 4, "height": 3}
        }
      ]
      ''';

      final entities = FiftyMapLoader.loadFromJsonString(json);
      expect(entities.length, equals(1));
      expect(entities[0].id, equals('room1'));
      expect(entities[0].type, equals('room'));
    });

    test('serializes entities to JSON string', () {
      final entities = [
        FiftyMapEntity(
          id: 'room1',
          type: 'room',
          asset: 'rooms/test.png',
          gridPosition: Vector2(0, 0),
          blockSize: FiftyBlockSize(4, 3),
        ),
      ];

      final json = FiftyMapLoader.toJsonString(entities);
      expect(json, contains('room1'));
      expect(json, contains('room'));
    });

    test('throws FormatException for invalid JSON', () {
      expect(
        () => FiftyMapLoader.loadFromJsonString('not json'),
        throwsFormatException,
      );
    });

    test('throws FormatException for non-list JSON', () {
      expect(
        () => FiftyMapLoader.loadFromJsonString('{"key": "value"}'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('FiftyMapUtils', () {
    test('getPositionAfterRotation returns correct offsets', () {
      final size = Vector2(100, 50);

      expect(FiftyMapUtils.getPositionAfterRotation(0, size), isNull);
      expect(FiftyMapUtils.getPositionAfterRotation(1, size), equals(Vector2(0, -100)));
      expect(FiftyMapUtils.getPositionAfterRotation(2, size), equals(Vector2(100, -50)));
      expect(FiftyMapUtils.getPositionAfterRotation(3, size), equals(Vector2(50, 0)));
      expect(FiftyMapUtils.getPositionAfterRotation(4, size), isNull); // Same as 0
    });

    test('getAlignedPosition returns correct position', () {
      final base = Vector2(100, 100);
      final parentSize = Vector2(200, 150);

      // Center alignment, no rotation
      final centerPos = FiftyMapUtils.getAlignedPosition(
        base: base,
        parentSize: parentSize,
        alignment: FiftyEventAlignment.center,
        quarterTurns: 0,
      );
      expect(centerPos.x, equals(200)); // 100 + 200/2
      expect(centerPos.y, equals(175)); // 100 + 150/2

      // Top left alignment, no rotation
      final topLeftPos = FiftyMapUtils.getAlignedPosition(
        base: base,
        parentSize: parentSize,
        alignment: FiftyEventAlignment.topLeft,
        quarterTurns: 0,
      );
      expect(topLeftPos.x, equals(100)); // 100 + 0
      expect(topLeftPos.y, equals(250)); // 100 + 150
    });
  });

  group('FiftyMapController', () {
    test('starts unbound', () {
      final controller = FiftyMapController();
      expect(controller.isBound, isFalse);
    });

    test('currentEntities returns empty list when unbound', () {
      final controller = FiftyMapController();
      expect(controller.currentEntities, isEmpty);
    });

    test('getComponentById returns null when unbound', () {
      final controller = FiftyMapController();
      expect(controller.getComponentById('test'), isNull);
    });

    test('getEntityById returns null when unbound', () {
      final controller = FiftyMapController();
      expect(controller.getEntityById('test'), isNull);
    });
  });
}
