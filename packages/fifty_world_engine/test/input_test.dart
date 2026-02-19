import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_world_engine/src/input/input_manager.dart';
import 'package:fifty_world_engine/src/input/tap_resolver.dart';
import 'package:fifty_world_engine/src/grid/grid_position.dart';
import 'package:fifty_world_engine/src/grid/tile_grid.dart';
import 'package:fifty_world_engine/src/grid/tile_type.dart';
import 'package:fifty_world_engine/src/config/world_config.dart';

void main() {
  group('InputManager', () {
    late InputManager manager;

    setUp(() {
      manager = InputManager();
    });

    test('starts unblocked', () {
      expect(manager.isBlocked, isFalse);
    });

    test('block() sets isBlocked to true', () {
      manager.block();
      expect(manager.isBlocked, isTrue);
    });

    test('unblock() sets isBlocked to false', () {
      manager.block();
      manager.unblock();
      expect(manager.isBlocked, isFalse);
    });

    test('unblock() invokes onUnblocked callback', () {
      var called = false;
      manager.onUnblocked = () => called = true;

      manager.block();
      manager.unblock();

      expect(called, isTrue);
    });

    test('unblock() does not throw when onUnblocked is null', () {
      manager.block();
      expect(() => manager.unblock(), returnsNormally);
    });

    test('block/unblock cycle can be repeated', () {
      var callCount = 0;
      manager.onUnblocked = () => callCount++;

      manager.block();
      expect(manager.isBlocked, isTrue);
      manager.unblock();
      expect(manager.isBlocked, isFalse);
      expect(callCount, equals(1));

      manager.block();
      expect(manager.isBlocked, isTrue);
      manager.unblock();
      expect(manager.isBlocked, isFalse);
      expect(callCount, equals(2));
    });
  });

  group('TapResolver', () {
    late TileGrid grid;

    setUp(() {
      grid = TileGrid(width: 8, height: 8);
      // Fill grid so all positions are valid tiles
      grid.fill(const TileType(id: 'floor', walkable: true));
    });

    test('resolves world position to grid position at origin', () {
      final result = TapResolver.resolve(Vector2(0, 0), grid);
      expect(result, equals(const GridPosition(0, 0)));
    });

    test('resolves world position within a tile', () {
      // Middle of tile (2, 3) at default blockSize 64
      final result = TapResolver.resolve(Vector2(160, 210), grid);
      expect(result, equals(const GridPosition(2, 3)));
    });

    test('resolves position at tile boundary', () {
      // Exactly at (3 * 64, 2 * 64) = (192, 128) -> grid (3, 2)
      final result = TapResolver.resolve(Vector2(192, 128), grid);
      expect(result, equals(const GridPosition(3, 2)));
    });

    test('returns null for negative x', () {
      final result = TapResolver.resolve(Vector2(-1, 10), grid);
      expect(result, isNull);
    });

    test('returns null for negative y', () {
      final result = TapResolver.resolve(Vector2(10, -1), grid);
      expect(result, isNull);
    });

    test('returns null for position beyond grid width', () {
      // Grid is 8 wide, so x >= 8 * 64 = 512 is out of bounds
      final result = TapResolver.resolve(Vector2(512, 0), grid);
      expect(result, isNull);
    });

    test('returns null for position beyond grid height', () {
      // Grid is 8 tall, so y >= 8 * 64 = 512 is out of bounds
      final result = TapResolver.resolve(Vector2(0, 512), grid);
      expect(result, isNull);
    });

    test('resolves correctly with last valid tile', () {
      // Last valid tile is (7, 7), pixel range [448, 512) for both axes
      final result = TapResolver.resolve(Vector2(450, 450), grid);
      expect(result, equals(const GridPosition(7, 7)));
    });

    test('resolves correctly with custom tile size', () {
      final result = TapResolver.resolve(Vector2(100, 200), grid, 32.0);
      // 100 / 32 = 3.125 -> floor = 3
      // 200 / 32 = 6.25 -> floor = 6
      expect(result, equals(const GridPosition(3, 6)));
    });

    test('uses FiftyWorldConfig.blockSize as default', () {
      // Verify the default matches our constant
      final pos = Vector2(FiftyWorldConfig.blockSize * 2 + 1, FiftyWorldConfig.blockSize * 3 + 1);
      final result = TapResolver.resolve(pos, grid);
      expect(result, equals(const GridPosition(2, 3)));
    });

    test('returns null for out-of-bounds with custom tile size', () {
      // Grid is 8x8. With tileSize=32, max valid pixel is 8*32=256
      final result = TapResolver.resolve(Vector2(256, 0), grid, 32.0);
      expect(result, isNull);
    });
  });
}
