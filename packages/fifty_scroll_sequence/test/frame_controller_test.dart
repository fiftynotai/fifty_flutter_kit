import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake [TickerProvider] that exposes the created ticker for manual control.
///
/// Uses a real [Ticker] from the test binding. Call [tick] to manually
/// trigger the callback as if a vsync frame occurred.
class FakeTickerProvider implements TickerProvider {
  late TickerCallback _onTick;
  late Ticker _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _onTick = onTick;
    _ticker = Ticker(onTick);
    return _ticker;
  }

  /// Manually invoke the ticker callback to simulate one frame.
  void tick([Duration elapsed = Duration.zero]) {
    _onTick(elapsed);
  }

  /// Whether the ticker is currently active.
  bool get isActive => _ticker.isActive;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FrameController', () {
    late FakeTickerProvider vsync;
    late FrameController controller;

    setUp(() {
      vsync = FakeTickerProvider();
      controller = FrameController(
        frameCount: 10,
        vsync: vsync,
        lerpFactor: 1.0, // Instant convergence for backward-compat tests.
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state has index 0 and progress 0.0', () {
      expect(controller.currentIndex, 0);
      expect(controller.progress, 0.0);
    });

    test('updateFromProgress(0.0) maps to index 0', () {
      controller.updateFromProgress(0.0);
      vsync.tick();
      expect(controller.currentIndex, 0);
    });

    test('updateFromProgress(1.0) maps to last frame', () {
      controller.updateFromProgress(1.0);
      vsync.tick();
      expect(controller.currentIndex, 9);
    });

    test('updateFromProgress(0.5) maps to middle frame', () {
      controller.updateFromProgress(0.5);
      vsync.tick();
      // 0.5 * 9 = 4.5, rounds to 5
      expect(controller.currentIndex, 5);
    });

    test('clamps negative progress to 0', () {
      controller.updateFromProgress(-0.5);
      vsync.tick();
      expect(controller.currentIndex, 0);
    });

    test('clamps progress above 1.0 to last frame', () {
      controller.updateFromProgress(1.5);
      vsync.tick();
      expect(controller.currentIndex, 9);
    });

    test('notifies listeners when index changes', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.updateFromProgress(0.5);
      vsync.tick();
      expect(notifyCount, 1);
    });

    test('does not notify when progress changes but index stays the same', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Both map to index 0 for 10 frames
      controller.updateFromProgress(0.01);
      vsync.tick();
      controller.updateFromProgress(0.02);
      vsync.tick();
      // 0.01 * 9 = 0.09 -> round = 0
      // 0.02 * 9 = 0.18 -> round = 0
      expect(notifyCount, 0);
    });

    test('frameCount of 1 always returns index 0', () {
      final singleFrameVsync = FakeTickerProvider();
      final singleFrameController = FrameController(
        frameCount: 1,
        vsync: singleFrameVsync,
        lerpFactor: 1.0,
      );
      addTearDown(singleFrameController.dispose);

      singleFrameController.updateFromProgress(0.0);
      singleFrameVsync.tick();
      expect(singleFrameController.currentIndex, 0);

      singleFrameController.updateFromProgress(0.5);
      singleFrameVsync.tick();
      expect(singleFrameController.currentIndex, 0);

      singleFrameController.updateFromProgress(1.0);
      singleFrameVsync.tick();
      expect(singleFrameController.currentIndex, 0);
    });

    test('progress getter reflects lerped value after tick', () {
      controller.updateFromProgress(0.75);
      vsync.tick(); // lerpFactor: 1.0 converges instantly
      expect(controller.progress, closeTo(0.75, 0.01));
    });

    test('frameCount is accessible', () {
      expect(controller.frameCount, 10);
    });

    group('ticker lifecycle', () {
      test('ticker starts when target changes', () {
        controller.updateFromProgress(0.5);
        expect(vsync.isActive, isTrue);
      });

      test('ticker stops when converged (lerpFactor 1.0)', () {
        controller.updateFromProgress(0.5);
        vsync.tick(); // tick 1: lerps to target
        vsync.tick(); // tick 2: detects convergence, stops
        expect(vsync.isActive, isFalse);
      });

      test('pauseTicker stops active ticker', () {
        controller.updateFromProgress(0.5);
        expect(vsync.isActive, isTrue);
        controller.pauseTicker();
        expect(vsync.isActive, isFalse);
      });

      test('resumeTicker restarts if not converged', () {
        controller.updateFromProgress(0.5);
        controller.pauseTicker();
        expect(vsync.isActive, isFalse);

        // For lerpFactor: 1.0, after one pause without tick the controller
        // hasn't converged yet.
        controller.resumeTicker();
        expect(vsync.isActive, isTrue);
      });

      test('resumeTicker does nothing if already converged', () {
        controller.updateFromProgress(0.5);
        vsync.tick(); // tick 1: lerps to target
        vsync.tick(); // tick 2: detects convergence, stops
        expect(vsync.isActive, isFalse);

        controller.resumeTicker();
        expect(vsync.isActive, isFalse);
      });
    });

    group('isLerping', () {
      test('returns false initially', () {
        expect(controller.isLerping, isFalse);
      });

      test('returns true after setting new target', () {
        controller.updateFromProgress(0.5);
        expect(controller.isLerping, isTrue);
      });

      test('returns false after convergence', () {
        controller.updateFromProgress(0.5);
        vsync.tick();
        expect(controller.isLerping, isFalse);
      });
    });

    group('smooth lerping (lerpFactor < 1.0)', () {
      late FakeTickerProvider smoothVsync;
      late FrameController smoothController;

      setUp(() {
        smoothVsync = FakeTickerProvider();
        smoothController = FrameController(
          frameCount: 120,
          vsync: smoothVsync,
          lerpFactor: 0.15,
        );
      });

      tearDown(() {
        smoothController.dispose();
      });

      test('does not converge in a single tick', () {
        smoothController.updateFromProgress(1.0);
        smoothVsync.tick();
        expect(smoothController.isLerping, isTrue);
        expect(smoothController.progress, lessThan(1.0));
      });

      test('converges within 60 ticks', () {
        smoothController.updateFromProgress(1.0);
        for (int i = 0; i < 60; i++) {
          if (!smoothController.isLerping) break;
          smoothVsync.tick();
        }
        expect(smoothController.isLerping, isFalse);
        expect(
          smoothController.currentIndex,
          119, // last frame
        );
      });

      test('intermediate ticks produce increasing frame indices', () {
        smoothController.updateFromProgress(1.0);
        final indices = <int>[];
        for (int i = 0; i < 60; i++) {
          if (!smoothController.isLerping) break;
          smoothVsync.tick();
          indices.add(smoothController.currentIndex);
        }
        // Each index should be >= the previous one (monotonically increasing).
        for (int i = 1; i < indices.length; i++) {
          expect(
            indices[i],
            greaterThanOrEqualTo(indices[i - 1]),
            reason: 'Index at tick $i should be >= index at tick ${i - 1}',
          );
        }
      });
    });

    group('curve support', () {
      test('easeInOut curve produces different index at 0.25 than linear', () {
        // Linear controller at 0.25
        final linearVsync = FakeTickerProvider();
        final linearController = FrameController(
          frameCount: 100,
          vsync: linearVsync,
          lerpFactor: 1.0,
          curve: Curves.linear,
        );
        addTearDown(linearController.dispose);

        linearController.updateFromProgress(0.25);
        linearVsync.tick();
        final linearAt25 = linearController.currentIndex;

        // EaseInOut controller at 0.25
        final easeVsync = FakeTickerProvider();
        final easeController = FrameController(
          frameCount: 100,
          vsync: easeVsync,
          lerpFactor: 1.0,
          curve: Curves.easeInOut,
        );
        addTearDown(easeController.dispose);

        easeController.updateFromProgress(0.25);
        easeVsync.tick();
        final easeAt25 = easeController.currentIndex;

        // At 0.25 progress, easeInOut maps lower than linear.
        expect(
          easeAt25,
          lessThan(linearAt25),
          reason: 'easeInOut should produce a lower frame index at 0.25',
        );
      });

      test('linear curve maps progress 1:1', () {
        final v = FakeTickerProvider();
        final c = FrameController(
          frameCount: 10,
          vsync: v,
          lerpFactor: 1.0,
          curve: Curves.linear,
        );
        addTearDown(c.dispose);

        c.updateFromProgress(0.5);
        v.tick();
        // 0.5 * 9 = 4.5 -> rounds to 5
        expect(c.currentIndex, 5);
      });
    });

    group('curve support: easeIn', () {
      test('easeIn produces lower index at 0.25 than linear', () {
        final linearVsync = FakeTickerProvider();
        final linearController = FrameController(
          frameCount: 100,
          vsync: linearVsync,
          lerpFactor: 1.0,
          curve: Curves.linear,
        );
        addTearDown(linearController.dispose);

        linearController.updateFromProgress(0.25);
        linearVsync.tick();
        final linearAt25 = linearController.currentIndex;

        final easeInVsync = FakeTickerProvider();
        final easeInController = FrameController(
          frameCount: 100,
          vsync: easeInVsync,
          lerpFactor: 1.0,
          curve: Curves.easeIn,
        );
        addTearDown(easeInController.dispose);

        easeInController.updateFromProgress(0.25);
        easeInVsync.tick();
        final easeInAt25 = easeInController.currentIndex;

        expect(
          easeInAt25,
          lessThan(linearAt25),
          reason: 'easeIn should produce lower index at 0.25',
        );
      });
    });

    group('curve support: easeOut', () {
      test('easeOut produces higher index at 0.25 than linear', () {
        final linearVsync = FakeTickerProvider();
        final linearController = FrameController(
          frameCount: 100,
          vsync: linearVsync,
          lerpFactor: 1.0,
          curve: Curves.linear,
        );
        addTearDown(linearController.dispose);

        linearController.updateFromProgress(0.25);
        linearVsync.tick();
        final linearAt25 = linearController.currentIndex;

        final easeOutVsync = FakeTickerProvider();
        final easeOutController = FrameController(
          frameCount: 100,
          vsync: easeOutVsync,
          lerpFactor: 1.0,
          curve: Curves.easeOut,
        );
        addTearDown(easeOutController.dispose);

        easeOutController.updateFromProgress(0.25);
        easeOutVsync.tick();
        final easeOutAt25 = easeOutController.currentIndex;

        expect(
          easeOutAt25,
          greaterThan(linearAt25),
          reason: 'easeOut should produce higher index at 0.25',
        );
      });
    });

    group('boundary conditions', () {
      test('exact 0.0 progress maps to index 0', () {
        controller.updateFromProgress(0.0);
        vsync.tick();
        expect(controller.currentIndex, 0);
        expect(controller.progress, 0.0);
      });

      test('exact 1.0 progress maps to last frame', () {
        controller.updateFromProgress(1.0);
        vsync.tick();
        expect(controller.currentIndex, 9);
        expect(controller.progress, closeTo(1.0, 0.01));
      });
    });

    group('targetProgress', () {
      test('reflects the last value set by updateFromProgress', () {
        controller.updateFromProgress(0.7);
        expect(controller.targetProgress, closeTo(0.7, 1e-10));
      });

      test('is clamped to 0.0-1.0 range', () {
        controller.updateFromProgress(1.5);
        expect(controller.targetProgress, 1.0);

        controller.updateFromProgress(-0.5);
        expect(controller.targetProgress, 0.0);
      });
    });
  });
}
