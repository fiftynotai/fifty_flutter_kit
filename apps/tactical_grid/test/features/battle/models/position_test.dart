import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // getOrthogonalPositions
  // ---------------------------------------------------------------------------

  group('getOrthogonalPositions', () {
    test('returns positions in 4 cardinal directions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getOrthogonalPositions(2, {});

      // 2 up, 2 down, 2 left, 2 right = 8 positions
      expect(positions.length, 8);
      expect(positions, contains(GridPosition(4, 3)));
      expect(positions, contains(GridPosition(4, 2)));
      expect(positions, contains(GridPosition(4, 5)));
      expect(positions, contains(GridPosition(4, 6)));
      expect(positions, contains(GridPosition(3, 4)));
      expect(positions, contains(GridPosition(2, 4)));
      expect(positions, contains(GridPosition(5, 4)));
      expect(positions, contains(GridPosition(6, 4)));
    });

    test('stops before occupied tile', () {
      final pos = GridPosition(4, 4);
      final occupied = {GridPosition(4, 3)}; // blocked above
      final positions = pos.getOrthogonalPositions(2, occupied);

      // up: 0 (blocked at step 1), down: 2, left: 2, right: 2 = 6
      expect(positions.length, 6);
      expect(positions, isNot(contains(GridPosition(4, 3))));
      expect(positions, isNot(contains(GridPosition(4, 2))));
    });

    test('stops at board edge', () {
      final pos = GridPosition(0, 0);
      final positions = pos.getOrthogonalPositions(3, {});

      // up: 0 (out of bounds), left: 0 (out of bounds)
      // down: 3 (0,1), (0,2), (0,3)
      // right: 3 (1,0), (2,0), (3,0)
      expect(positions.length, 6);
    });

    test('does not include diagonal positions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getOrthogonalPositions(1, {});

      expect(positions, isNot(contains(GridPosition(5, 5))));
      expect(positions, isNot(contains(GridPosition(3, 3))));
    });

    test('blocked tile prevents tiles behind it', () {
      final pos = GridPosition(4, 4);
      final occupied = {GridPosition(5, 4)}; // blocked 1 right
      final positions = pos.getOrthogonalPositions(3, occupied);

      // right direction: only blocked, nothing beyond
      expect(positions, isNot(contains(GridPosition(5, 4))));
      expect(positions, isNot(contains(GridPosition(6, 4))));
      expect(positions, isNot(contains(GridPosition(7, 4))));
    });
  });

  // ---------------------------------------------------------------------------
  // getDiagonalPositions
  // ---------------------------------------------------------------------------

  group('getDiagonalPositions', () {
    test('returns positions in 4 diagonal directions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getDiagonalPositions(2, {});

      // 2 in each diagonal = 8 positions
      expect(positions.length, 8);
      expect(positions, contains(GridPosition(3, 3))); // NW
      expect(positions, contains(GridPosition(2, 2))); // NW step 2
      expect(positions, contains(GridPosition(5, 3))); // NE
      expect(positions, contains(GridPosition(6, 2))); // NE step 2
      expect(positions, contains(GridPosition(3, 5))); // SW
      expect(positions, contains(GridPosition(5, 5))); // SE
    });

    test('stops before occupied tile on diagonal', () {
      final pos = GridPosition(4, 4);
      final occupied = {GridPosition(3, 3)};
      final positions = pos.getDiagonalPositions(2, occupied);

      // NW blocked: -2, rest: 6
      expect(positions.length, 6);
      expect(positions, isNot(contains(GridPosition(3, 3))));
      expect(positions, isNot(contains(GridPosition(2, 2))));
    });

    test('does not include cardinal positions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getDiagonalPositions(2, {});

      expect(positions, isNot(contains(GridPosition(4, 3))));
      expect(positions, isNot(contains(GridPosition(5, 4))));
    });
  });

  // ---------------------------------------------------------------------------
  // getAnyDirectionPositions
  // ---------------------------------------------------------------------------

  group('getAnyDirectionPositions', () {
    test('returns positions in all 8 directions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getAnyDirectionPositions(2, {});

      // 8 directions * 2 steps = 16 positions
      expect(positions.length, 16);
    });

    test('combines cardinal and diagonal positions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getAnyDirectionPositions(1, {});

      // 8 directions * 1 step = 8 positions
      expect(positions.length, 8);
      expect(positions, contains(GridPosition(4, 3))); // N
      expect(positions, contains(GridPosition(5, 5))); // SE
      expect(positions, contains(GridPosition(3, 4))); // W
    });

    test('blocks independently per direction', () {
      final pos = GridPosition(4, 4);
      final occupied = {GridPosition(4, 3), GridPosition(5, 5)};
      final positions = pos.getAnyDirectionPositions(3, occupied);

      // N blocked at step 1: -3
      // SE blocked at step 1: -3
      // Other 6 directions: 3 each = 18
      // Total: 18
      expect(positions.length, 18);
    });
  });

  // ---------------------------------------------------------------------------
  // getPositionsInRadius
  // ---------------------------------------------------------------------------

  group('getPositionsInRadius', () {
    test('radius 1 returns up to 8 adjacent positions', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getPositionsInRadius(1);

      expect(positions.length, 8);
    });

    test('does not include the origin position', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getPositionsInRadius(1);

      expect(positions, isNot(contains(GridPosition(4, 4))));
    });

    test('radius 2 from center returns correct count', () {
      final pos = GridPosition(4, 4);
      final positions = pos.getPositionsInRadius(2);

      // 5x5 area minus center = 24 positions (all valid on center board)
      expect(positions.length, 24);
    });

    test('clips to board bounds at corner', () {
      final pos = GridPosition(0, 0);
      final positions = pos.getPositionsInRadius(1);

      // Only 3 valid positions from corner: (1,0), (0,1), (1,1)
      expect(positions.length, 3);
      expect(positions, contains(GridPosition(1, 0)));
      expect(positions, contains(GridPosition(0, 1)));
      expect(positions, contains(GridPosition(1, 1)));
    });

    test('does not check blocking (abilities see over units)', () {
      // getPositionsInRadius has no occupied parameter
      final pos = GridPosition(4, 4);
      final positions = pos.getPositionsInRadius(2);

      // All 24 positions returned regardless of any "occupied" state
      expect(positions.length, 24);
    });
  });
}
