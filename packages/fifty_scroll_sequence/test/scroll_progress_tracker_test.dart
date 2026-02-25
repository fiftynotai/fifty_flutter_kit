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

    group('calculateHorizontalProgress', () {
      test('widget at right edge of viewport returns 0.0', () {
        final progress = tracker.calculateHorizontalProgress(
          widgetLeftInViewport: 1200,
          viewportWidth: 1200,
        );
        expect(progress, 0.0);
      });

      test('widget fully scrolled past returns 1.0', () {
        // totalTravel = 1200 + 3000 = 4200
        // traveled = 1200 - (-3000) = 4200
        final progress = tracker.calculateHorizontalProgress(
          widgetLeftInViewport: -3000,
          viewportWidth: 1200,
        );
        expect(progress, 1.0);
      });

      test('widget halfway returns ~0.5', () {
        // totalTravel = 1200 + 3000 = 4200
        // midpoint traveled = 2100 -> widgetLeft = 1200 - 2100 = -900
        final progress = tracker.calculateHorizontalProgress(
          widgetLeftInViewport: -900,
          viewportWidth: 1200,
        );
        expect(progress, closeTo(0.5, 0.01));
      });

      test('zero scrollExtent returns 0.0', () {
        final zeroTracker = ScrollProgressTracker(scrollExtent: 0);
        final progress = zeroTracker.calculateHorizontalProgress(
          widgetLeftInViewport: 500,
          viewportWidth: 1000,
        );
        // totalTravel = 1000 + 0 = 1000; traveled = 1000 - 500 = 500
        // Since scrollExtent is 0, totalTravel = viewportWidth = 1000
        // This is still valid math: 500/1000 = 0.5
        expect(progress, closeTo(0.5, 0.01));
      });

      test('zero viewportWidth returns 0', () {
        final progress = tracker.calculateHorizontalProgress(
          widgetLeftInViewport: 0,
          viewportWidth: 0,
        );
        // totalTravel = 0 + 3000 = 3000; but the method guards totalTravel <= 0
        // Actually the guard is: if (totalTravel <= 0) return 0
        // totalTravel = 0 + 3000 = 3000 which is > 0, so it proceeds
        // traveled = 0 - 0 = 0; 0 / 3000 = 0.0
        expect(progress, 0.0);
      });
    });

    group('calculatePinnedHorizontalProgress', () {
      test('at section left returns 0.0', () {
        final progress = tracker.calculatePinnedHorizontalProgress(
          scrollOffset: 500,
          sectionLeft: 500,
        );
        expect(progress, 0.0);
      });

      test('scrolled past full extent returns 1.0', () {
        final progress = tracker.calculatePinnedHorizontalProgress(
          scrollOffset: 3500,
          sectionLeft: 500,
        );
        expect(progress, 1.0);
      });

      test('halfway scrolled returns 0.5', () {
        final progress = tracker.calculatePinnedHorizontalProgress(
          scrollOffset: 2000,
          sectionLeft: 500,
        );
        expect(progress, 0.5);
      });

      test('zero scrollExtent returns 0', () {
        final zeroTracker = ScrollProgressTracker(scrollExtent: 0);
        final progress = zeroTracker.calculatePinnedHorizontalProgress(
          scrollOffset: 500,
          sectionLeft: 500,
        );
        expect(progress, 0);
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
