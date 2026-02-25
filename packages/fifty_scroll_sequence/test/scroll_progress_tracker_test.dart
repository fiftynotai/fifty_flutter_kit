import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScrollProgressTracker', () {
    late ScrollProgressTracker tracker;

    setUp(() {
      tracker = ScrollProgressTracker(scrollExtent: 3000);
    });

    group('calculateProgress (non-pinned)', () {
      test('returns 0.0 when widget top is at viewport bottom', () {
        final progress = tracker.calculateProgress(
          widgetTopInViewport: 800,
          viewportHeight: 800,
        );
        expect(progress, 0.0);
      });

      test('returns 1.0 when fully scrolled through', () {
        // totalTravel = 800 + 3000 = 3800
        // traveled = 800 - (-3000) = 3800
        final progress = tracker.calculateProgress(
          widgetTopInViewport: -3000,
          viewportHeight: 800,
        );
        expect(progress, 1.0);
      });

      test('returns midpoint progress correctly', () {
        // totalTravel = 800 + 3000 = 3800
        // At midpoint: traveled = 3800 / 2 = 1900
        // widgetTopInViewport = 800 - 1900 = -1100
        final progress = tracker.calculateProgress(
          widgetTopInViewport: -1100,
          viewportHeight: 800,
        );
        expect(progress, closeTo(0.5, 0.01));
      });

      test('clamps negative values to 0.0', () {
        final progress = tracker.calculateProgress(
          widgetTopInViewport: 1000, // below viewport bottom
          viewportHeight: 800,
        );
        expect(progress, 0.0);
      });

      test('clamps values above 1.0', () {
        final progress = tracker.calculateProgress(
          widgetTopInViewport: -5000, // way past
          viewportHeight: 800,
        );
        expect(progress, 1.0);
      });
    });

    group('calculatePinnedProgress', () {
      test('returns 0.0 when scrollOffset equals sectionTop', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 500,
          sectionTop: 500,
        );
        expect(progress, 0.0);
      });

      test('returns 1.0 when scrollOffset is sectionTop + scrollExtent', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 3500,
          sectionTop: 500,
        );
        expect(progress, 1.0);
      });

      test('returns 0.5 at midpoint', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 2000,
          sectionTop: 500,
        );
        expect(progress, 0.5);
      });

      test('clamps to 0.0 when scroll is before section', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 100,
          sectionTop: 500,
        );
        expect(progress, 0.0);
      });

      test('clamps to 1.0 when scroll is past section', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 5000,
          sectionTop: 500,
        );
        expect(progress, 1.0);
      });

      test('works with zero sectionTop', () {
        final progress = tracker.calculatePinnedProgress(
          scrollOffset: 1500,
          sectionTop: 0,
        );
        expect(progress, 0.5);
      });
    });

    group('direction detection', () {
      test('initial direction is idle', () {
        expect(tracker.direction, ScrollDirection.idle);
      });

      test('increasing progress sets direction to forward', () {
        tracker.updateDirection(0.1);
        expect(tracker.direction, ScrollDirection.forward);
      });

      test('decreasing progress sets direction to backward', () {
        // First move forward to establish a baseline.
        tracker.updateDirection(0.5);
        expect(tracker.direction, ScrollDirection.forward);

        // Now decrease to go backward.
        tracker.updateDirection(0.3);
        expect(tracker.direction, ScrollDirection.backward);
      });

      test('tiny delta below threshold keeps previous direction', () {
        // Move forward past threshold.
        tracker.updateDirection(0.1);
        expect(tracker.direction, ScrollDirection.forward);

        // Tiny delta (0.0005 < 0.001 threshold) should keep forward.
        tracker.updateDirection(0.1005);
        expect(tracker.direction, ScrollDirection.forward);
      });

      test('direction persists across multiple same-direction updates', () {
        tracker.updateDirection(0.1);
        tracker.updateDirection(0.2);
        tracker.updateDirection(0.3);
        expect(tracker.direction, ScrollDirection.forward);

        tracker.updateDirection(0.2);
        tracker.updateDirection(0.1);
        expect(tracker.direction, ScrollDirection.backward);
      });
    });
  });
}
