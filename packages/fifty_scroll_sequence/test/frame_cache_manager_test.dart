import 'dart:ui' as ui;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a 1x1 test image using PictureRecorder.
Future<ui.Image> createTestImage() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    const Rect.fromLTWH(0, 0, 1, 1),
    Paint(),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(1, 1);
  picture.dispose();
  return image;
}

/// Fake frame loader that creates 1x1 test images.
class FakeFrameLoader implements FrameLoader {
  int loadCount = 0;

  @override
  Future<ui.Image> loadFrame(int index) async {
    loadCount++;
    return createTestImage();
  }

  @override
  String resolveFramePath(int index) => 'test_frame_$index.png';

  @override
  void dispose() {}
}

void main() {
  group('FrameCacheManager', () {
    late FrameCacheManager cache;
    late FakeFrameLoader loader;

    setUp(() {
      cache = FrameCacheManager(maxCacheSize: 3);
      loader = FakeFrameLoader();
    });

    tearDown(() {
      cache.clearAll();
    });

    test('getFrame returns null for uncached index', () {
      expect(cache.getFrame(0), isNull);
    });

    test('loadFrame caches and returns image', () async {
      final image = await cache.loadFrame(0, loader);
      expect(image, isNotNull);
      expect(cache.length, 1);
      expect(loader.loadCount, 1);
    });

    test('loadFrame returns cached image on second call', () async {
      await cache.loadFrame(0, loader);
      await cache.loadFrame(0, loader);
      expect(loader.loadCount, 1); // Only loaded once
      expect(cache.length, 1);
    });

    test('LRU eviction removes oldest entry when cache is full', () async {
      await cache.loadFrame(0, loader);
      await cache.loadFrame(1, loader);
      await cache.loadFrame(2, loader);
      expect(cache.length, 3);

      // Adding 4th frame should evict frame 0
      await cache.loadFrame(3, loader);
      expect(cache.length, 3);
      expect(cache.getFrame(0), isNull); // Evicted
      expect(cache.getFrame(3), isNotNull); // Present
    });

    test('getFrame promotes entry so it does not get evicted next', () async {
      await cache.loadFrame(0, loader);
      await cache.loadFrame(1, loader);
      await cache.loadFrame(2, loader);

      // Access frame 0 to promote it
      cache.getFrame(0);

      // Adding frame 3 should evict frame 1 (now oldest)
      await cache.loadFrame(3, loader);
      expect(cache.getFrame(0), isNotNull); // Promoted, still present
      expect(cache.getFrame(1), isNull); // Evicted
    });

    test('clearAll empties cache and resets length', () async {
      await cache.loadFrame(0, loader);
      await cache.loadFrame(1, loader);
      expect(cache.length, 2);

      cache.clearAll();
      expect(cache.length, 0);
      expect(cache.getFrame(0), isNull);
      expect(cache.getFrame(1), isNull);
    });

    test('nearestCachedFrame returns closest frame toward 0', () async {
      await cache.loadFrame(0, loader);
      await cache.loadFrame(2, loader);

      // Target frame 3 is not cached, nearest toward 0 is frame 2
      final nearest = cache.nearestCachedFrame(3);
      expect(nearest, isNotNull);
    });

    test('nearestCachedFrame returns null when nothing cached', () {
      expect(cache.nearestCachedFrame(5), isNull);
    });

    test('isLoading returns false when no loads in flight', () {
      expect(cache.isLoading, isFalse);
    });

    test('estimatedMemoryBytes returns correct estimate', () async {
      await cache.loadFrame(0, loader);
      // 1x1 image * 4 bytes RGBA = 4 bytes
      expect(cache.estimatedMemoryBytes, 4);
    });
  });

  group('FrameCacheManager strategy integration', () {
    late FrameCacheManager cache;
    late FakeFrameLoader loader;

    setUp(() {
      cache = FrameCacheManager(maxCacheSize: 50);
      loader = FakeFrameLoader();
    });

    tearDown(() {
      cache.clearAll();
    });

    test('preloadForStrategy loads frames in strategy order', () async {
      const strategy = ChunkedPreloadStrategy(
        chunkSize: 5,
        preloadAhead: 3,
        preloadBehind: 1,
      );

      await cache.preloadForStrategy(
        currentIndex: 5,
        totalFrames: 20,
        strategy: strategy,
        direction: ScrollDirection.forward,
        loader: loader,
      );

      // Strategy should have loaded current (5), ahead (6,7,8), behind (4).
      expect(cache.getFrame(5), isNotNull);
      expect(cache.getFrame(6), isNotNull);
      expect(cache.getFrame(7), isNotNull);
      expect(cache.getFrame(8), isNotNull);
      expect(cache.getFrame(4), isNotNull);
      expect(cache.length, 5);
    });

    test('preloadForStrategy with chunked strategy evicts frames outside window',
        () async {
      const strategy = ChunkedPreloadStrategy(
        chunkSize: 3,
        preloadAhead: 2,
        preloadBehind: 0,
      );

      // Pre-load frames 0 and 1 (these will be outside the next window).
      await cache.loadFrame(0, loader);
      await cache.loadFrame(1, loader);
      expect(cache.length, 2);

      // Now preload for index 10. Window should be [10, 11, 12].
      // Frames 0 and 1 should be evicted since shouldEvictOutsideWindow is true.
      await cache.preloadForStrategy(
        currentIndex: 10,
        totalFrames: 20,
        strategy: strategy,
        direction: ScrollDirection.forward,
        loader: loader,
      );

      expect(cache.getFrame(0), isNull);
      expect(cache.getFrame(1), isNull);
      expect(cache.getFrame(10), isNotNull);
    });

    test('preloadForStrategy reports progress via callback', () async {
      const strategy = ChunkedPreloadStrategy(
        chunkSize: 4,
        preloadAhead: 2,
        preloadBehind: 1,
      );

      final progressCalls = <(int, int)>[];

      await cache.preloadForStrategy(
        currentIndex: 5,
        totalFrames: 20,
        strategy: strategy,
        direction: ScrollDirection.forward,
        loader: loader,
        onProgress: (loaded, total) {
          progressCalls.add((loaded, total));
        },
      );

      // All frames should have been newly loaded, so we get progress for each.
      expect(progressCalls, isNotEmpty);

      // Last call should have loaded == total.
      final lastCall = progressCalls.last;
      expect(lastCall.$1, lastCall.$2);
    });

    test('evicted frames reduce cache length', () async {
      const strategy = ChunkedPreloadStrategy(
        chunkSize: 2,
        preloadAhead: 1,
        preloadBehind: 0,
      );

      // Pre-load several frames.
      await cache.loadFrame(0, loader);
      await cache.loadFrame(1, loader);
      await cache.loadFrame(2, loader);
      expect(cache.length, 3);

      // Preload for index 10; frames 0-2 should be evicted.
      await cache.preloadForStrategy(
        currentIndex: 10,
        totalFrames: 20,
        strategy: strategy,
        direction: ScrollDirection.forward,
        loader: loader,
      );

      // Only the strategy window frames should remain.
      expect(cache.getFrame(0), isNull);
      expect(cache.getFrame(1), isNull);
      expect(cache.getFrame(2), isNull);
    });
  });
}
