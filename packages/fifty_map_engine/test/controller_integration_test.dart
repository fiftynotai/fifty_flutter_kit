import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_map_engine/fifty_map_engine.dart';

void main() {
  group('FiftyMapController v2 integration', () {
    group('overlay methods (unbound)', () {
      test('highlightTiles is a no-op when unbound', () {
        final controller = FiftyMapController();
        // Should not throw
        controller.highlightTiles(
          [const GridPosition(0, 0)],
          HighlightStyle.validMove,
        );
      });

      test('clearHighlights is a no-op when overlayManager is null', () {
        final controller = FiftyMapController();
        // Should not throw
        controller.clearHighlights();
        controller.clearHighlights(group: 'validMoves');
      });

      test('setSelection is a no-op when unbound', () {
        final controller = FiftyMapController();
        // Should not throw
        controller.setSelection(const GridPosition(3, 3));
        controller.setSelection(null);
      });
    });

    group('decorator methods (unbound)', () {
      test('updateHP is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.updateHP('entity-1', 0.5);
      });

      test('setSelected is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.setSelected('entity-1');
        controller.setSelected('entity-1', selected: false);
      });

      test('setTeamColor is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.setTeamColor('entity-1', const Color(0xFFFF0000));
      });

      test('addStatusIcon is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.addStatusIcon('entity-1', 'P');
      });

      test('removeDecorators is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.removeDecorators('entity-1');
      });
    });

    group('animation methods', () {
      test('isAnimating defaults to false', () {
        final controller = FiftyMapController();
        expect(controller.isAnimating, isFalse);
      });

      test('inputManager is lazily created', () {
        final controller = FiftyMapController();
        final im = controller.inputManager;
        expect(im, isNotNull);
        expect(im.isBlocked, isFalse);
        // Same instance on repeated access
        expect(controller.inputManager, same(im));
      });

      test('queueAnimation creates queue with input blocking', () async {
        final controller = FiftyMapController();
        var executed = false;

        controller.queueAnimation(AnimationEntry(
          execute: () async {
            executed = true;
          },
        ));

        // Allow async queue to process
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(executed, isTrue);
      });

      test('queueAnimations enqueues multiple entries', () async {
        final controller = FiftyMapController();
        final order = <int>[];

        controller.queueAnimations([
          AnimationEntry(execute: () async => order.add(1)),
          AnimationEntry(execute: () async => order.add(2)),
          AnimationEntry(execute: () async => order.add(3)),
        ]);

        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(order, equals([1, 2, 3]));
      });

      test('cancelAnimations does not throw when no queue exists', () {
        final controller = FiftyMapController();
        controller.cancelAnimations();
      });

      test('showFloatingText is a no-op when unbound', () {
        final controller = FiftyMapController();
        controller.showFloatingText(
          const GridPosition(0, 0),
          '-12',
        );
      });
    });

    group('pathfinding methods', () {
      late TileGrid grid;

      setUp(() {
        grid = TileGrid(width: 5, height: 5);
        grid.fill(const TileType(id: 'grass', walkable: true));
      });

      test('findPath returns path in open grid', () {
        final controller = FiftyMapController();
        final path = controller.findPath(
          const GridPosition(0, 0),
          const GridPosition(4, 0),
          grid: grid,
        );
        expect(path, isNotNull);
        expect(path!.first, equals(const GridPosition(0, 0)));
        expect(path.last, equals(const GridPosition(4, 0)));
        expect(path.length, equals(5));
      });

      test('findPath returns null when blocked', () {
        final controller = FiftyMapController();
        // Block the entire row 2 making passage impossible
        grid.setTile(
          const GridPosition(0, 2),
          const TileType(id: 'wall', walkable: false),
        );
        grid.setTile(
          const GridPosition(1, 2),
          const TileType(id: 'wall', walkable: false),
        );
        grid.setTile(
          const GridPosition(2, 2),
          const TileType(id: 'wall', walkable: false),
        );
        grid.setTile(
          const GridPosition(3, 2),
          const TileType(id: 'wall', walkable: false),
        );
        grid.setTile(
          const GridPosition(4, 2),
          const TileType(id: 'wall', walkable: false),
        );

        final path = controller.findPath(
          const GridPosition(0, 0),
          const GridPosition(0, 4),
          grid: grid,
        );
        expect(path, isNull);
      });

      test('findPath with blocked positions set', () {
        final controller = FiftyMapController();
        final path = controller.findPath(
          const GridPosition(0, 0),
          const GridPosition(2, 0),
          grid: grid,
          blocked: {const GridPosition(1, 0)},
        );
        // Must go around the blocked position
        expect(path, isNotNull);
        expect(path!.contains(const GridPosition(1, 0)), isFalse);
      });

      test('findPath with diagonal movement', () {
        final controller = FiftyMapController();
        final path = controller.findPath(
          const GridPosition(0, 0),
          const GridPosition(2, 2),
          grid: grid,
          diagonal: true,
        );
        expect(path, isNotNull);
        // Diagonal path should be shorter than cardinal-only
        expect(path!.length, lessThanOrEqualTo(3));
      });

      test('getMovementRange returns reachable positions', () {
        final controller = FiftyMapController();
        final range = controller.getMovementRange(
          const GridPosition(2, 2),
          budget: 2.0,
          grid: grid,
        );
        // Center + 4 adjacent + 4 at distance 2 (cross shape)
        expect(range, contains(const GridPosition(2, 2)));
        expect(range, contains(const GridPosition(2, 1)));
        expect(range, contains(const GridPosition(2, 3)));
        expect(range, contains(const GridPosition(1, 2)));
        expect(range, contains(const GridPosition(3, 2)));
        // Distance 2 positions
        expect(range, contains(const GridPosition(2, 0)));
        expect(range, contains(const GridPosition(0, 2)));
        expect(range, contains(const GridPosition(4, 2)));
        expect(range, contains(const GridPosition(2, 4)));
      });

      test('getMovementRange with blocked positions', () {
        final controller = FiftyMapController();
        final range = controller.getMovementRange(
          const GridPosition(2, 2),
          budget: 1.0,
          grid: grid,
          blocked: {const GridPosition(2, 1)},
        );
        expect(range, contains(const GridPosition(2, 2)));
        expect(range.contains(const GridPosition(2, 1)), isFalse);
      });

      test('getMovementRange with diagonal movement', () {
        final controller = FiftyMapController();
        final range = controller.getMovementRange(
          const GridPosition(2, 2),
          budget: 2.0,
          grid: grid,
          diagonal: true,
        );
        // Diagonal allows more positions at same budget
        expect(range, contains(const GridPosition(1, 1)));
        expect(range, contains(const GridPosition(3, 3)));
      });
    });

    group('FiftyTileTapCallback typedef', () {
      test('can be used as a function type', () {
        GridPosition? tapped;
        void callback(GridPosition pos) => tapped = pos;
        callback(const GridPosition(3, 4));
        expect(tapped, equals(const GridPosition(3, 4)));
      });
    });
  });
}
