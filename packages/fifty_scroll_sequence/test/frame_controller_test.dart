import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FrameController', () {
    late FrameController controller;

    setUp(() {
      controller = FrameController(frameCount: 10);
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
      expect(controller.currentIndex, 0);
    });

    test('updateFromProgress(1.0) maps to last frame', () {
      controller.updateFromProgress(1.0);
      expect(controller.currentIndex, 9);
    });

    test('updateFromProgress(0.5) maps to middle frame', () {
      controller.updateFromProgress(0.5);
      // 0.5 * 9 = 4.5, rounds to 5 (or 4 depending on rounding)
      expect(controller.currentIndex, 5);
    });

    test('clamps negative progress to 0', () {
      controller.updateFromProgress(-0.5);
      expect(controller.currentIndex, 0);
      expect(controller.progress, 0.0);
    });

    test('clamps progress above 1.0 to last frame', () {
      controller.updateFromProgress(1.5);
      expect(controller.currentIndex, 9);
      expect(controller.progress, 1.0);
    });

    test('notifies listeners when index changes', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.updateFromProgress(0.5);
      expect(notifyCount, 1);
    });

    test('does not notify when progress changes but index stays the same', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      // Both map to index 0 for 10 frames
      controller.updateFromProgress(0.01);
      controller.updateFromProgress(0.02);
      // 0.01 * 9 = 0.09 -> round = 0
      // 0.02 * 9 = 0.18 -> round = 0
      // Only first call should notify (from initial 0 -> still 0, no notify)
      expect(notifyCount, 0);
    });

    test('frameCount of 1 always returns index 0', () {
      final singleFrameController = FrameController(frameCount: 1);
      addTearDown(singleFrameController.dispose);

      singleFrameController.updateFromProgress(0.0);
      expect(singleFrameController.currentIndex, 0);

      singleFrameController.updateFromProgress(0.5);
      expect(singleFrameController.currentIndex, 0);

      singleFrameController.updateFromProgress(1.0);
      expect(singleFrameController.currentIndex, 0);
    });

    test('progress getter reflects last set value', () {
      controller.updateFromProgress(0.75);
      expect(controller.progress, 0.75);
    });

    test('frameCount is accessible', () {
      expect(controller.frameCount, 10);
    });
  });
}
