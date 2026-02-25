import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpriteSheetConfig', () {
    test('maxFrames returns columns * rows', () {
      const config = SpriteSheetConfig(
        assetPath: 'assets/sheet.webp',
        columns: 10,
        rows: 8,
        frameWidth: 320,
        frameHeight: 180,
      );
      expect(config.maxFrames, 80);
    });
  });

  group('SpriteSheetLoader', () {
    late SpriteSheetLoader loader;

    setUp(() {
      loader = SpriteSheetLoader(
        sheets: [
          const SpriteSheetConfig(
            assetPath: 'assets/sheet_01.webp',
            columns: 10,
            rows: 10,
            frameWidth: 320,
            frameHeight: 180,
          ),
        ],
        totalFrames: 100,
      );
    });

    tearDown(() {
      loader.dispose();
    });

    test('resolveFramePath returns assetPath#localIndex format', () {
      final path = loader.resolveFramePath(0);
      expect(path, 'assets/sheet_01.webp#0');
    });

    test('single sheet: index 0 resolves to sheet 0, local 0', () {
      final path = loader.resolveFramePath(0);
      expect(path, 'assets/sheet_01.webp#0');
    });

    test('single sheet: index at end of first row resolves correctly', () {
      // columns = 10, so index 9 is last in first row (local index 9).
      final path = loader.resolveFramePath(9);
      expect(path, 'assets/sheet_01.webp#9');
    });

    test('multiple sheets: index spanning to second sheet resolves correctly', () {
      final multiLoader = SpriteSheetLoader(
        sheets: [
          const SpriteSheetConfig(
            assetPath: 'assets/sheet_01.webp',
            columns: 5,
            rows: 4,
            frameWidth: 320,
            frameHeight: 180,
          ),
          const SpriteSheetConfig(
            assetPath: 'assets/sheet_02.webp',
            columns: 5,
            rows: 4,
            frameWidth: 320,
            frameHeight: 180,
          ),
        ],
        totalFrames: 40,
      );

      // Sheet 1 has 5*4 = 20 frames (indices 0-19).
      // Index 20 should resolve to sheet 2, local 0.
      expect(multiLoader.resolveFramePath(19), 'assets/sheet_01.webp#19');
      expect(multiLoader.resolveFramePath(20), 'assets/sheet_02.webp#0');
      expect(multiLoader.resolveFramePath(25), 'assets/sheet_02.webp#5');

      multiLoader.dispose();
    });

    test('resolveFramePath throws RangeError for out-of-range index', () {
      expect(
        () => loader.resolveFramePath(100),
        throwsA(isA<RangeError>()),
      );
    });
  });
}
