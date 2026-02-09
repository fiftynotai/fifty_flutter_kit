import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/services/turn_timer_service.dart';

void main() {
  late TurnTimerService timer;

  setUp(() {
    timer = TurnTimerService();
  });

  tearDown(() {
    timer.dispose();
  });

  // ---------------------------------------------------------------------------
  // Initial state
  // ---------------------------------------------------------------------------

  group('initial state', () {
    test('remainingSeconds starts at 0', () {
      expect(timer.remainingSeconds.value, 0);
    });

    test('isRunning starts as false', () {
      expect(timer.isRunning.value, false);
    });

    test('progress starts at 0.0', () {
      expect(timer.progress, 0.0);
    });

    test('isWarning is false initially', () {
      expect(timer.isWarning, false);
    });

    test('isCritical is false initially', () {
      expect(timer.isCritical, false);
    });

    test('default turn duration is 60', () {
      expect(timer.turnDuration, TurnTimerService.defaultTurnDuration);
      expect(timer.turnDuration, 60);
    });
  });

  // ---------------------------------------------------------------------------
  // configure
  // ---------------------------------------------------------------------------

  group('configure', () {
    test('sets custom turn duration', () {
      timer.configure(turnDuration: 30);
      expect(timer.turnDuration, 30);
    });

    test('default parameter uses defaultTurnDuration', () {
      timer.configure();
      expect(timer.turnDuration, TurnTimerService.defaultTurnDuration);
    });
  });

  // ---------------------------------------------------------------------------
  // startTurn
  // ---------------------------------------------------------------------------

  group('startTurn', () {
    test('sets remainingSeconds to turn duration', () {
      timer.configure(turnDuration: 45);
      timer.startTurn();

      expect(timer.remainingSeconds.value, 45);
      expect(timer.isRunning.value, true);
    });

    test('sets isRunning to true', () {
      timer.startTurn();
      expect(timer.isRunning.value, true);
    });

    test('uses default duration when not configured', () {
      timer.startTurn();
      expect(timer.remainingSeconds.value, TurnTimerService.defaultTurnDuration);
    });

    test('counts down each second', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        expect(timer.remainingSeconds.value, 10);

        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 9);

        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 8);

        async.elapse(const Duration(seconds: 3));
        expect(timer.remainingSeconds.value, 5);
      });
    });

    test('fires onTimerExpired when reaching 0', () {
      fakeAsync((async) {
        var expired = false;
        timer.configure(turnDuration: 3);
        timer.onTimerExpired = () => expired = true;
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));

        expect(expired, true);
        expect(timer.remainingSeconds.value, 0);
        expect(timer.isRunning.value, false);
      });
    });

    test('cancels previous timer when called again', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        expect(timer.remainingSeconds.value, 7);

        // Start a new turn -- should reset.
        timer.startTurn();
        expect(timer.remainingSeconds.value, 10);

        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 9);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // pause / resume
  // ---------------------------------------------------------------------------

  group('pause and resume', () {
    test('pause stops the countdown', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        expect(timer.remainingSeconds.value, 7);

        timer.pause();
        expect(timer.isRunning.value, false);

        async.elapse(const Duration(seconds: 5));
        // Should not have changed while paused.
        expect(timer.remainingSeconds.value, 7);
      });
    });

    test('resume continues countdown from paused value', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        timer.pause();

        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 7);

        timer.resume();
        expect(timer.isRunning.value, true);

        async.elapse(const Duration(seconds: 2));
        expect(timer.remainingSeconds.value, 5);
      });
    });

    test('resume does nothing when remainingSeconds is 0', () {
      timer.resume();
      expect(timer.isRunning.value, false);
    });
  });

  // ---------------------------------------------------------------------------
  // cancel
  // ---------------------------------------------------------------------------

  group('cancel', () {
    test('resets state completely', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        timer.cancel();

        expect(timer.remainingSeconds.value, 0);
        expect(timer.isRunning.value, false);

        // Should not count further.
        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 0);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // progress
  // ---------------------------------------------------------------------------

  group('progress', () {
    test('returns 1.0 at start of turn', () {
      timer.configure(turnDuration: 10);
      timer.startTurn();
      expect(timer.progress, 1.0);
    });

    test('returns 0.5 at halfway', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(timer.progress, 0.5);
      });
    });

    test('returns 0.0 when expired', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 5);
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(timer.progress, 0.0);
      });
    });

    test('returns 0.0 when turnDuration is 0', () {
      timer.configure(turnDuration: 0);
      expect(timer.progress, 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // isWarning / isCritical
  // ---------------------------------------------------------------------------

  group('isWarning', () {
    test('returns true when seconds <= 10 and > 5', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 15);
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 10);
        expect(timer.isWarning, true);

        async.elapse(const Duration(seconds: 2));
        expect(timer.remainingSeconds.value, 8);
        expect(timer.isWarning, true);
      });
    });

    test('returns false when seconds > 10', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 20);
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 15);
        expect(timer.isWarning, false);
      });
    });

    test('returns false when seconds <= 5', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 5);
        expect(timer.isWarning, false);
      });
    });
  });

  group('isCritical', () {
    test('returns true when seconds <= 5 and > 0', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 6));
        expect(timer.remainingSeconds.value, 4);
        expect(timer.isCritical, true);
      });
    });

    test('returns false when seconds > 5', () {
      fakeAsync((async) {
        timer.configure(turnDuration: 10);
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        expect(timer.remainingSeconds.value, 7);
        expect(timer.isCritical, false);
      });
    });

    test('returns false when seconds is 0', () {
      expect(timer.isCritical, false);
    });
  });

  // ---------------------------------------------------------------------------
  // Callbacks
  // ---------------------------------------------------------------------------

  group('onWarning callback', () {
    test('fires once when entering warning zone', () {
      fakeAsync((async) {
        var warningCount = 0;
        timer.configure(turnDuration: 15);
        timer.onWarning = () => warningCount++;
        timer.startTurn();

        // Tick to 10s remaining (enters warning zone).
        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 10);
        expect(warningCount, 1);

        // Tick further within warning zone -- should not fire again.
        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 9);
        expect(warningCount, 1);

        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 8);
        expect(warningCount, 1);
      });
    });

    test('fires again on a new turn', () {
      fakeAsync((async) {
        var warningCount = 0;
        timer.configure(turnDuration: 12);
        timer.onWarning = () => warningCount++;
        timer.startTurn();

        async.elapse(const Duration(seconds: 2));
        expect(warningCount, 1);

        // Start a new turn -- callback flags should reset.
        timer.startTurn();
        async.elapse(const Duration(seconds: 2));
        expect(warningCount, 2);
      });
    });
  });

  group('onCritical callback', () {
    test('fires once when entering critical zone', () {
      fakeAsync((async) {
        var criticalCount = 0;
        timer.configure(turnDuration: 10);
        timer.onCritical = () => criticalCount++;
        timer.startTurn();

        // Tick to 5s remaining (enters critical zone).
        async.elapse(const Duration(seconds: 5));
        expect(timer.remainingSeconds.value, 5);
        expect(criticalCount, 1);

        // Tick further -- should not fire again.
        async.elapse(const Duration(seconds: 1));
        expect(timer.remainingSeconds.value, 4);
        expect(criticalCount, 1);
      });
    });

    test('fires again on a new turn', () {
      fakeAsync((async) {
        var criticalCount = 0;
        timer.configure(turnDuration: 7);
        timer.onCritical = () => criticalCount++;
        timer.startTurn();

        async.elapse(const Duration(seconds: 2));
        expect(criticalCount, 1);

        timer.startTurn();
        async.elapse(const Duration(seconds: 2));
        expect(criticalCount, 2);
      });
    });
  });

  group('onTimerExpired callback', () {
    test('fires when countdown reaches 0', () {
      fakeAsync((async) {
        var expiredCount = 0;
        timer.configure(turnDuration: 3);
        timer.onTimerExpired = () => expiredCount++;
        timer.startTurn();

        async.elapse(const Duration(seconds: 3));
        expect(expiredCount, 1);
      });
    });

    test('fires only once per turn', () {
      fakeAsync((async) {
        var expiredCount = 0;
        timer.configure(turnDuration: 2);
        timer.onTimerExpired = () => expiredCount++;
        timer.startTurn();

        async.elapse(const Duration(seconds: 5));
        expect(expiredCount, 1);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // dispose
  // ---------------------------------------------------------------------------

  group('dispose', () {
    test('cancels timer and clears callbacks', () {
      fakeAsync((async) {
        var expired = false;
        timer.configure(turnDuration: 5);
        timer.onTimerExpired = () => expired = true;
        timer.onWarning = () {};
        timer.onCritical = () {};
        timer.startTurn();

        timer.dispose();

        expect(timer.isRunning.value, false);
        expect(timer.remainingSeconds.value, 0);
        expect(timer.onTimerExpired, isNull);
        expect(timer.onWarning, isNull);
        expect(timer.onCritical, isNull);

        async.elapse(const Duration(seconds: 10));
        expect(expired, false);
      });
    });
  });
}
