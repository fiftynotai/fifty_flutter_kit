import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EagerPreloadStrategy', () {
    const strategy = EagerPreloadStrategy();

    test('framesToLoad returns all indices from 0 to totalFrames-1', () {
      final result = strategy.framesToLoad(
        currentIndex: 5,
        totalFrames: 10,
        direction: ScrollDirection.forward,
      );
      expect(result, List<int>.generate(10, (i) => i));
    });

    test('shouldEvictOutsideWindow is false', () {
      expect(strategy.shouldEvictOutsideWindow, isFalse);
    });

    test('maxCacheSize returns totalFrames', () {
      expect(strategy.maxCacheSize(200), 200);
    });
  });

  group('ChunkedPreloadStrategy', () {
    const strategy = ChunkedPreloadStrategy(
      chunkSize: 10,
      preloadAhead: 6,
      preloadBehind: 3,
    );

    test('framesToLoad with forward direction loads current first, then ahead, then behind',
        () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      // Current frame is first.
      expect(result.first, 50);

      // Ahead frames come before behind frames in the list.
      final aheadFrames = result.where((i) => i > 50).toList();
      final behindFrames = result.where((i) => i < 50).toList();

      // Ahead: 51..56 (6 frames)
      expect(aheadFrames, [51, 52, 53, 54, 55, 56]);

      // Behind: 49, 48, 47 (3 frames, descending toward start)
      expect(behindFrames, [49, 48, 47]);

      // Ahead frames appear before behind frames in full list.
      final firstAheadPos = result.indexOf(aheadFrames.first);
      final firstBehindPos = result.indexOf(behindFrames.first);
      expect(firstAheadPos, lessThan(firstBehindPos));
    });

    test('framesToLoad at index 0 has no behind frames', () {
      final result = strategy.framesToLoad(
        currentIndex: 0,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      expect(result.first, 0);
      expect(result.where((i) => i < 0), isEmpty);
    });

    test('framesToLoad at last frame has no ahead frames', () {
      final result = strategy.framesToLoad(
        currentIndex: 99,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      expect(result.first, 99);
      // No frames beyond 99.
      expect(result.where((i) => i > 99), isEmpty);
    });

    test('framesToLoad with backward direction swaps ahead and behind counts', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.backward,
      );

      expect(result.first, 50);

      // In backward: ahead = preloadBehind (3), behind = preloadAhead (6)
      final aheadFrames = result.where((i) => i > 50).toList();
      final behindFrames = result.where((i) => i < 50).toList();

      // Ahead (higher indices): only 3 frames.
      expect(aheadFrames.length, 3);

      // Behind (lower indices): 6 frames.
      expect(behindFrames.length, 6);
    });

    test('framesToLoad with idle direction uses symmetric window', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.idle,
      );

      expect(result.first, 50);

      // Idle: ahead = chunkSize~/2 = 5, behind = chunkSize~/2 = 5.
      final aheadFrames = result.where((i) => i > 50).toList();
      final behindFrames = result.where((i) => i < 50).toList();

      expect(aheadFrames.length, 5);
      expect(behindFrames.length, 5);
    });

    test('shouldEvictOutsideWindow is true', () {
      expect(strategy.shouldEvictOutsideWindow, isTrue);
    });

    test('maxCacheSize returns min(chunkSize, totalFrames)', () {
      expect(strategy.maxCacheSize(100), 10); // min(10, 100)
    });

    test('maxCacheSize with totalFrames less than chunkSize returns totalFrames', () {
      expect(strategy.maxCacheSize(5), 5); // min(10, 5)
    });

    test('result contains no duplicates', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );
      expect(result.toSet().length, result.length);
    });

    test('current frame is always first in list', () {
      for (final dir in ScrollDirection.values) {
        final result = strategy.framesToLoad(
          currentIndex: 25,
          totalFrames: 50,
          direction: dir,
        );
        expect(result.first, 25, reason: 'Failed for direction $dir');
      }
    });
  });

  group('ProgressivePreloadStrategy', () {
    const strategy = ProgressivePreloadStrategy(
      keyframeCount: 10,
      windowAhead: 5,
      windowBehind: 3,
    );

    test('framesToLoad includes evenly-spaced keyframes', () {
      final result = strategy.framesToLoad(
        currentIndex: 0,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      // step = max(1, 100 ~/ 10) = 10
      // keyframes: 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, and 99 (last)
      final keyframes = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 99];
      for (final kf in keyframes) {
        expect(result.contains(kf), isTrue, reason: 'Missing keyframe $kf');
      }
    });

    test('framesToLoad includes window around current index', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      // Window: [50-3, 50+5] = [47..55]
      for (int i = 47; i <= 55; i++) {
        expect(result.contains(i), isTrue, reason: 'Missing window frame $i');
      }
    });

    test('current frame is first in the list', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );
      expect(result.first, 50);
    });

    test('no duplicate indices in result', () {
      final result = strategy.framesToLoad(
        currentIndex: 50,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );
      expect(result.toSet().length, result.length);
    });

    test('shouldEvictOutsideWindow is true', () {
      expect(strategy.shouldEvictOutsideWindow, isTrue);
    });

    test('maxCacheSize returns keyframeCount + windowAhead + windowBehind', () {
      expect(strategy.maxCacheSize(100), 10 + 5 + 3);
    });

    test('handles keyframeCount greater than totalFrames', () {
      const edgeStrategy = ProgressivePreloadStrategy(
        keyframeCount: 50,
        windowAhead: 3,
        windowBehind: 2,
      );

      final result = edgeStrategy.framesToLoad(
        currentIndex: 0,
        totalFrames: 10,
        direction: ScrollDirection.forward,
      );

      // Should not exceed totalFrames in output.
      for (final index in result) {
        expect(index, greaterThanOrEqualTo(0));
        expect(index, lessThan(10));
      }

      // No duplicates.
      expect(result.toSet().length, result.length);

      // Current frame is first.
      expect(result.first, 0);
    });

    test('keyframeCount equal to totalFrames loads all frames', () {
      const edgeStrategy = ProgressivePreloadStrategy(
        keyframeCount: 10,
        windowAhead: 0,
        windowBehind: 0,
      );

      final result = edgeStrategy.framesToLoad(
        currentIndex: 5,
        totalFrames: 10,
        direction: ScrollDirection.forward,
      );

      // Should contain all frames since step = max(1, 10 ~/ 10) = 1.
      // Plus the last frame. All 10 frames should be present.
      final resultSet = result.toSet();
      for (int i = 0; i < 10; i++) {
        expect(resultSet.contains(i), isTrue, reason: 'Missing frame $i');
      }
    });

    test('window at boundary of totalFrames clamps correctly', () {
      final result = strategy.framesToLoad(
        currentIndex: 99,
        totalFrames: 100,
        direction: ScrollDirection.forward,
      );

      // Window ahead should not exceed 99.
      for (final index in result) {
        expect(index, greaterThanOrEqualTo(0));
        expect(index, lessThan(100));
      }

      // Current frame is first.
      expect(result.first, 99);
    });
  });
}
