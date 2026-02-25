import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart'
    hide ScrollDirection;
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewportObserver', () {
    group('non-pinned mode', () {
      test('outside to visible+forward fires onEnter once', () {
        int enterCount = 0;
        final observer = ViewportObserver(
          onEnter: () => enterCount++,
        );

        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );

        expect(enterCount, 1);

        // Same state again should not fire.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );

        expect(enterCount, 1);
      });

      test('inside to not-visible+forward fires onLeave once', () {
        int leaveCount = 0;
        final observer = ViewportObserver(
          onEnter: () {},
          onLeave: () => leaveCount++,
        );

        // Enter first.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );

        // Now leave forward.
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.forward,
        );

        expect(leaveCount, 1);

        // Same state again should not fire.
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.forward,
        );

        expect(leaveCount, 1);
      });

      test('outside to visible+reverse fires onEnterBack once', () {
        int enterBackCount = 0;
        final observer = ViewportObserver(
          onEnterBack: () => enterBackCount++,
        );

        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.reverse,
        );

        expect(enterBackCount, 1);

        // Same state again should not fire.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.reverse,
        );

        expect(enterBackCount, 1);
      });

      test('inside to not-visible+reverse fires onLeaveBack once', () {
        int leaveBackCount = 0;
        final observer = ViewportObserver(
          onEnterBack: () {},
          onLeaveBack: () => leaveBackCount++,
        );

        // Enter (backward).
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.reverse,
        );

        // Leave backward.
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.reverse,
        );

        expect(leaveBackCount, 1);
      });

      test('correct sequence: onEnter -> onLeave -> onEnterBack -> onLeaveBack',
          () {
        final events = <String>[];
        final observer = ViewportObserver(
          onEnter: () => events.add('enter'),
          onLeave: () => events.add('leave'),
          onEnterBack: () => events.add('enterBack'),
          onLeaveBack: () => events.add('leaveBack'),
        );

        // Forward enter.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        // Forward leave.
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.forward,
        );
        // Backward enter.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.reverse,
        );
        // Backward leave.
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.reverse,
        );

        expect(events, ['enter', 'leave', 'enterBack', 'leaveBack']);
      });

      test('same state repeated does not fire callback (no double-fire)', () {
        int enterCount = 0;
        final observer = ViewportObserver(
          onEnter: () => enterCount++,
        );

        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );

        expect(enterCount, 1);
      });
    });

    group('pinned mode', () {
      test('progress crosses threshold upward fires onEnter', () {
        int enterCount = 0;
        final observer = ViewportObserver(
          onEnter: () => enterCount++,
        );

        observer.updatePinnedState(
          progress: 0.1,
          direction: ScrollDirection.forward,
        );

        expect(enterCount, 1);
      });

      test('progress reaches 1.0 forward fires onLeave', () {
        int leaveCount = 0;
        final observer = ViewportObserver(
          onEnter: () {},
          onLeave: () => leaveCount++,
        );

        // Enter first.
        observer.updatePinnedState(
          progress: 0.1,
          direction: ScrollDirection.forward,
        );

        // Reach the end.
        observer.updatePinnedState(
          progress: 1.0,
          direction: ScrollDirection.forward,
        );

        expect(leaveCount, 1);
      });

      test('progress drops below 1.0 backward fires onEnterBack', () {
        int enterBackCount = 0;
        final observer = ViewportObserver(
          onEnter: () {},
          onLeave: () {},
          onEnterBack: () => enterBackCount++,
        );

        // Enter.
        observer.updatePinnedState(
          progress: 0.1,
          direction: ScrollDirection.forward,
        );

        // Leave forward.
        observer.updatePinnedState(
          progress: 1.0,
          direction: ScrollDirection.forward,
        );

        // Come back.
        observer.updatePinnedState(
          progress: 0.8,
          direction: ScrollDirection.reverse,
        );

        expect(enterBackCount, 1);
      });

      test('progress drops to 0.0 backward fires onLeaveBack', () {
        int leaveBackCount = 0;
        final observer = ViewportObserver(
          onEnter: () {},
          onLeaveBack: () => leaveBackCount++,
        );

        // Enter.
        observer.updatePinnedState(
          progress: 0.1,
          direction: ScrollDirection.forward,
        );

        // Go back to 0.
        observer.updatePinnedState(
          progress: 0.0,
          direction: ScrollDirection.reverse,
        );

        expect(leaveBackCount, 1);
      });

      test('no double-fire on same phase', () {
        int enterCount = 0;
        final observer = ViewportObserver(
          onEnter: () => enterCount++,
        );

        observer.updatePinnedState(
          progress: 0.1,
          direction: ScrollDirection.forward,
        );
        observer.updatePinnedState(
          progress: 0.2,
          direction: ScrollDirection.forward,
        );
        observer.updatePinnedState(
          progress: 0.5,
          direction: ScrollDirection.forward,
        );

        expect(enterCount, 1);
      });
    });

    group('reset', () {
      test('after reset, callbacks fire again on next transition', () {
        int enterCount = 0;
        final observer = ViewportObserver(
          onEnter: () => enterCount++,
        );

        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        expect(enterCount, 1);

        observer.reset();

        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        expect(enterCount, 2);
      });
    });

    group('no callbacks registered', () {
      test('operations are no-ops when all callbacks are null', () {
        final observer = ViewportObserver();

        // None of these should throw.
        observer.updateVisibility(
          isVisible: true,
          direction: ScrollDirection.forward,
        );
        observer.updateVisibility(
          isVisible: false,
          direction: ScrollDirection.forward,
        );
        observer.updatePinnedState(
          progress: 0.5,
          direction: ScrollDirection.forward,
        );
        observer.reset();
        observer.dispose();
      });
    });
  });
}
