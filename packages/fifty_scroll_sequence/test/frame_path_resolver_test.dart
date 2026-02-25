import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FramePathResolver', () {
    group('resolve()', () {
      test('resolves basic pattern with auto pad width', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 10,
        );

        expect(resolver.resolve(3), 'assets/frame_03.webp');
      });

      test('auto pad width from frameCount of 200', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 200,
        );

        expect(resolver.effectivePadWidth, 3);
        expect(resolver.resolve(1), 'assets/frame_001.webp');
        expect(resolver.resolve(199), 'assets/frame_199.webp');
      });

      test('custom padWidth override', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 10,
          indexPadWidth: 5,
        );

        expect(resolver.effectivePadWidth, 5);
        expect(resolver.resolve(7), 'assets/frame_00007.webp');
      });

      test('indexOffset shifts frame numbers', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 10,
          indexOffset: 1,
        );

        expect(resolver.resolve(0), 'assets/frame_01.webp');
        expect(resolver.resolve(9), 'assets/frame_10.webp');
      });

      test('frameCount of 1 uses pad width of 1', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 1,
        );

        expect(resolver.effectivePadWidth, 1);
        expect(resolver.resolve(0), 'assets/frame_0.webp');
      });

      test('replaces all occurrences of {index} in pattern', () {
        final resolver = FramePathResolver(
          framePath: 'assets/{index}/frame_{index}.webp',
          frameCount: 10,
        );

        expect(resolver.resolve(3), 'assets/03/frame_03.webp');
      });
    });

    group('resolveAll()', () {
      test('returns correct length', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 5,
        );

        final frames = resolver.resolveAll();
        expect(frames.length, 5);
      });

      test('returns correct paths and indices', () {
        final resolver = FramePathResolver(
          framePath: 'assets/frame_{index}.webp',
          frameCount: 3,
        );

        final frames = resolver.resolveAll();
        expect(frames[0].index, 0);
        expect(frames[0].path, 'assets/frame_0.webp');
        expect(frames[1].index, 1);
        expect(frames[1].path, 'assets/frame_1.webp');
        expect(frames[2].index, 2);
        expect(frames[2].path, 'assets/frame_2.webp');
      });
    });

    group('error handling', () {
      test('throws ArgumentError when framePath has no {index}', () {
        expect(
          () => FramePathResolver(
            framePath: 'assets/frame.webp',
            frameCount: 10,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
