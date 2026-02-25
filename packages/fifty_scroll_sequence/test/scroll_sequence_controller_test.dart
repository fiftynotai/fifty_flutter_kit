import 'dart:ui' as ui;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a 1x1 test image using PictureRecorder.
Future<ui.Image> _createTestImage() async {
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
class _FakeFrameLoader implements FrameLoader {
  int loadCount = 0;

  @override
  Future<ui.Image> loadFrame(int index) async {
    loadCount++;
    return _createTestImage();
  }

  @override
  String resolveFramePath(int index) => 'test_frame_$index.png';

  @override
  void dispose() {}
}

/// Mock accessor for testing controller attachment.
class _MockAccessor implements ScrollSequenceStateAccessor {
  @override
  ScrollPosition? get scrollPosition => null;

  @override
  double get scrollExtent => 3000.0;

  @override
  bool get isPinned => true;

  @override
  Axis get scrollDirection => Axis.vertical;

  @override
  double get widgetTopOffset => 0.0;
}

void main() {
  group('ScrollSequenceController', () {
    late ScrollSequenceController controller;

    setUp(() {
      controller = ScrollSequenceController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('initial state', () {
      test('currentFrame is 0', () {
        expect(controller.currentFrame, 0);
      });

      test('progress is 0.0', () {
        expect(controller.progress, 0.0);
      });

      test('loadedFrameCount is 0', () {
        expect(controller.loadedFrameCount, 0);
      });

      test('isFullyLoaded is false', () {
        expect(controller.isFullyLoaded, isFalse);
      });

      test('loadingProgress is 0.0', () {
        expect(controller.loadingProgress, 0.0);
      });

      test('isAttached is false', () {
        expect(controller.isAttached, isFalse);
      });

      test('frameCount is 0', () {
        expect(controller.frameCount, 0);
      });
    });

    group('attach / detach', () {
      test('throws StateError when calling jumpToFrame without attach', () {
        expect(
          () => controller.jumpToFrame(5),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError when calling jumpToProgress without attach', () {
        expect(
          () => controller.jumpToProgress(0.5),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError when calling preloadAll without attach', () {
        expect(
          () => controller.preloadAll(),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError when calling clearCache without attach', () {
        expect(
          () => controller.clearCache(),
          throwsA(isA<StateError>()),
        );
      });

      test('after attach, isAttached is true', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        expect(controller.isAttached, isTrue);
        expect(controller.frameCount, 60);

        cache.clearAll();
      });

      test('after detach, isAttached is false', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );
        expect(controller.isAttached, isTrue);

        controller.detach();
        expect(controller.isAttached, isFalse);

        cache.clearAll();
      });

      test('after detach, state is reset', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        controller.updateState(
          currentFrame: 30,
          progress: 0.5,
          loadedCount: 10,
        );
        expect(controller.currentFrame, 30);

        controller.detach();
        expect(controller.currentFrame, 0);
        expect(controller.progress, 0.0);
        expect(controller.loadedFrameCount, 0);
        expect(controller.frameCount, 0);

        cache.clearAll();
      });

      test('throws StateError after detach when calling jumpToFrame', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );
        controller.detach();

        expect(
          () => controller.jumpToFrame(5),
          throwsA(isA<StateError>()),
        );

        cache.clearAll();
      });

      test('attach reflects cache length as loadedFrameCount', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        // Pre-load some frames into the cache.
        await cache.loadFrame(0, loader);
        await cache.loadFrame(1, loader);

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        expect(controller.loadedFrameCount, 2);

        cache.clearAll();
      });
    });

    group('state sync (widget -> controller)', () {
      test('updateState reflects new values', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 120,
          accessor: accessor,
        );

        controller.updateState(
          currentFrame: 42,
          progress: 0.35,
          loadedCount: 15,
        );

        expect(controller.currentFrame, 42);
        expect(controller.progress, closeTo(0.35, 0.001));
        expect(controller.loadedFrameCount, 15);

        cache.clearAll();
      });

      test('updateState triggers notifyListeners', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 120,
          accessor: accessor,
        );

        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.updateState(
          currentFrame: 10,
          progress: 0.1,
          loadedCount: 5,
        );

        expect(notifyCount, 1);

        cache.clearAll();
      });

      test('multiple updateState calls accumulate notifications', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 120,
          accessor: accessor,
        );

        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.updateState(
          currentFrame: 10,
          progress: 0.1,
          loadedCount: 5,
        );
        controller.updateState(
          currentFrame: 20,
          progress: 0.2,
          loadedCount: 10,
        );

        expect(notifyCount, 2);
        expect(controller.currentFrame, 20);

        cache.clearAll();
      });
    });

    group('jumpToFrame', () {
      test('clamps negative frame to 0', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        // jumpToProgress is called internally; since scrollPosition is null
        // it silently returns. We just verify no exception is thrown.
        controller.jumpToFrame(-5);

        cache.clearAll();
      });

      test('clamps frame above frameCount-1', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        // Should not throw even with out-of-range frame.
        controller.jumpToFrame(200);

        cache.clearAll();
      });

      test('handles frameCount of 1', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 1,
          accessor: accessor,
        );

        // Should not throw.
        controller.jumpToFrame(0);

        cache.clearAll();
      });
    });

    group('jumpToProgress', () {
      test('clamps progress below 0.0', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        // scrollPosition is null, so animateTo is skipped, but no exception.
        controller.jumpToProgress(-0.5);

        cache.clearAll();
      });

      test('clamps progress above 1.0', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 60,
          accessor: accessor,
        );

        controller.jumpToProgress(1.5);

        cache.clearAll();
      });
    });

    group('preloadAll', () {
      test('loads all frames and updates loadedFrameCount', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 5,
          accessor: accessor,
        );

        await controller.preloadAll();

        expect(controller.loadedFrameCount, 5);
        expect(loader.loadCount, 5);

        cache.clearAll();
      });

      test('isFullyLoaded returns true after preloadAll', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 3,
          accessor: accessor,
        );

        expect(controller.isFullyLoaded, isFalse);

        await controller.preloadAll();

        expect(controller.isFullyLoaded, isTrue);

        cache.clearAll();
      });

      test('preloadAll notifies listeners', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 2,
          accessor: accessor,
        );

        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        await controller.preloadAll();

        // At least one notification at the end.
        expect(notifyCount, greaterThanOrEqualTo(1));

        cache.clearAll();
      });

      test('loadingProgress is 1.0 after preloadAll', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 4,
          accessor: accessor,
        );

        await controller.preloadAll();

        expect(controller.loadingProgress, 1.0);

        cache.clearAll();
      });
    });

    group('clearCache', () {
      test('loadedFrameCount returns 0 after clearCache', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 5,
          accessor: accessor,
        );

        await controller.preloadAll();
        expect(controller.loadedFrameCount, 5);

        controller.clearCache();
        expect(controller.loadedFrameCount, 0);
      });

      test('isFullyLoaded returns false after clearCache', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 3,
          accessor: accessor,
        );

        await controller.preloadAll();
        expect(controller.isFullyLoaded, isTrue);

        controller.clearCache();
        expect(controller.isFullyLoaded, isFalse);
      });

      test('clearCache notifies listeners', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 3,
          accessor: accessor,
        );

        await controller.preloadAll();

        int notifyCount = 0;
        controller.addListener(() => notifyCount++);

        controller.clearCache();

        expect(notifyCount, 1);
      });
    });

    group('loadingProgress', () {
      test('returns 0.0 when frameCount is 0 (not attached)', () {
        expect(controller.loadingProgress, 0.0);
      });

      test('returns partial progress after partial load', () async {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 10,
          accessor: accessor,
        );

        // Manually update state to simulate partial load.
        controller.updateState(
          currentFrame: 0,
          progress: 0.0,
          loadedCount: 5,
        );

        expect(controller.loadingProgress, 0.5);

        cache.clearAll();
      });
    });

    group('isFullyLoaded edge cases', () {
      test('returns false when frameCount is 0', () {
        // Not attached, frameCount == 0.
        expect(controller.isFullyLoaded, isFalse);
      });

      test('returns true when loadedFrameCount >= frameCount', () {
        final loader = _FakeFrameLoader();
        final cache = FrameCacheManager(maxCacheSize: 10);
        final accessor = _MockAccessor();

        controller.attach(
          cacheManager: cache,
          loader: loader,
          frameCount: 3,
          accessor: accessor,
        );

        controller.updateState(
          currentFrame: 0,
          progress: 0.0,
          loadedCount: 3,
        );

        expect(controller.isFullyLoaded, isTrue);

        cache.clearAll();
      });
    });
  });
}
