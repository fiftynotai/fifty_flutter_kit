import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/models.dart';

void main() {
  // ---------------------------------------------------------------------------
  // getUnitById
  // ---------------------------------------------------------------------------

  group('getUnitById', () {
    test('returns the unit when it exists and is alive', () {
      final unit = Unit.knight(
        id: 'p_knight_1',
        isPlayer: true,
        position: const GridPosition(2, 7),
      );
      final board = BoardState(units: [unit]);

      expect(board.getUnitById('p_knight_1'), unit);
    });

    test('returns the unit even when it is dead', () {
      final unit = Unit.knight(
        id: 'p_knight_1',
        isPlayer: true,
        position: const GridPosition(2, 7),
      );
      unit.takeDamage(unit.hp); // Kill the unit
      expect(unit.isDead, true);

      final board = BoardState(units: [unit]);

      // getUnitById should still find dead units (unlike getUnitAt).
      expect(board.getUnitById('p_knight_1'), unit);
    });

    test('returns null when no unit with the given ID exists', () {
      final board = BoardState(units: [
        Unit.commander(
          id: 'p_commander',
          isPlayer: true,
          position: const GridPosition(3, 7),
        ),
      ]);

      expect(board.getUnitById('nonexistent'), isNull);
    });

    test('returns null on empty board', () {
      const board = BoardState(units: []);

      expect(board.getUnitById('any_id'), isNull);
    });

    test('returns correct unit when multiple units exist', () {
      final knight = Unit.knight(
        id: 'p_knight_1',
        isPlayer: true,
        position: const GridPosition(2, 7),
      );
      final commander = Unit.commander(
        id: 'p_commander',
        isPlayer: true,
        position: const GridPosition(3, 7),
      );
      final board = BoardState(units: [knight, commander]);

      expect(board.getUnitById('p_commander'), commander);
      expect(board.getUnitById('p_knight_1'), knight);
    });
  });
}
