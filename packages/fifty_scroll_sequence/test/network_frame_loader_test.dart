import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkFrameLoader', () {
    test('resolveFramePath applies index padding correctly', () {
      final loader = NetworkFrameLoader(
        frameUrlPattern: 'https://cdn.example.com/frame_{index}.webp',
        frameCount: 200,
        cacheDirectory: '/tmp/cache',
      );

      // frameCount = 200, indexOffset = 0, auto padWidth = '200'.length = 3
      expect(
        loader.resolveFramePath(0),
        'https://cdn.example.com/frame_000.webp',
      );
      expect(
        loader.resolveFramePath(5),
        'https://cdn.example.com/frame_005.webp',
      );
      expect(
        loader.resolveFramePath(99),
        'https://cdn.example.com/frame_099.webp',
      );

      loader.dispose();
    });

    test('resolveFramePath applies indexOffset', () {
      final loader = NetworkFrameLoader(
        frameUrlPattern: 'https://cdn.example.com/frame_{index}.webp',
        frameCount: 100,
        cacheDirectory: '/tmp/cache',
        indexOffset: 1,
      );

      // adjusted = index + 1, padWidth = (100 + 1).toString().length = 3
      expect(
        loader.resolveFramePath(0),
        'https://cdn.example.com/frame_001.webp',
      );
      expect(
        loader.resolveFramePath(99),
        'https://cdn.example.com/frame_100.webp',
      );

      loader.dispose();
    });

    test('resolveFramePath with explicit indexPadWidth overrides auto-calculation', () {
      final loader = NetworkFrameLoader(
        frameUrlPattern: 'https://cdn.example.com/frame_{index}.webp',
        frameCount: 10,
        cacheDirectory: '/tmp/cache',
        indexPadWidth: 5,
      );

      // Auto would be '10'.length = 2, but explicit is 5.
      expect(
        loader.resolveFramePath(3),
        'https://cdn.example.com/frame_00003.webp',
      );

      loader.dispose();
    });

    test('resolveFramePath replaces {index} in URL pattern', () {
      final loader = NetworkFrameLoader(
        frameUrlPattern: 'https://cdn.example.com/seq/{index}/image.webp',
        frameCount: 50,
        cacheDirectory: '/tmp/cache',
      );

      // padWidth = '50'.length = 2
      expect(
        loader.resolveFramePath(7),
        'https://cdn.example.com/seq/07/image.webp',
      );

      loader.dispose();
    });

    test('constructor stores headers', () {
      final loader = NetworkFrameLoader(
        frameUrlPattern: 'https://cdn.example.com/frame_{index}.webp',
        frameCount: 10,
        cacheDirectory: '/tmp/cache',
        headers: {'Authorization': 'Bearer token123'},
      );

      expect(loader.headers, {'Authorization': 'Bearer token123'});

      loader.dispose();
    });
  });
}
