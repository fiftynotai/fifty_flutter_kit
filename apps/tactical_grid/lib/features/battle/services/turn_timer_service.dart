/// Turn Timer Service
///
/// Reactive countdown timer for tactical battle turns. Counts down from
/// a configurable duration (default 60 seconds) and fires callbacks when
/// the timer expires or enters warning/critical zones.
///
/// Designed to run during player turns and pause during AI turns.
/// Uses [RxInt] and [RxBool] for GetX reactive binding in the UI.
///
/// **Usage:**
/// ```dart
/// final timer = TurnTimerService();
/// timer.configure(turnDuration: 60);
/// timer.onTimerExpired = () => endTurn();
/// timer.onWarning = () => playWarningSfx();
/// timer.onCritical = () => playAlarmSfx();
/// timer.startTurn();
/// ```
library;

import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

/// Reactive countdown timer service for turn-based gameplay.
///
/// Counts down each second and exposes [remainingSeconds] and [isRunning]
/// as GetX observables so the UI can bind reactively via `Obx()`.
///
/// **Callback Hooks:**
/// - [onTimerExpired]: Fires when the countdown reaches zero (auto-skip).
/// - [onWarning]: Fires once when entering the warning zone (<=10s).
/// - [onCritical]: Fires once when entering the critical zone (<=5s).
///
/// **Architecture Note:**
/// This is a SERVICE layer component. The [BattleActions] layer wires up
/// the callbacks; the UI reads reactive state via `Get.find<TurnTimerService>()`.
class TurnTimerService {
  /// Default turn duration in seconds.
  static const int defaultTurnDuration = 60;

  /// Default threshold in seconds for the warning zone.
  static const int defaultWarningThreshold = 10;

  /// Default threshold in seconds for the critical zone.
  static const int defaultCriticalThreshold = 5;

  /// Threshold in seconds for the warning zone (configurable).
  int warningThreshold = defaultWarningThreshold;

  /// Threshold in seconds for the critical zone (configurable).
  int criticalThreshold = defaultCriticalThreshold;

  /// Remaining seconds on the current turn timer.
  final RxInt remainingSeconds = 0.obs;

  /// Whether the timer is currently running.
  final RxBool isRunning = false.obs;

  /// The configured turn duration in seconds.
  int _turnDuration = defaultTurnDuration;

  /// Internal periodic timer handle.
  Timer? _timer;

  /// Whether the [onWarning] callback has already fired this turn.
  bool _warningFired = false;

  /// Whether the [onCritical] callback has already fired this turn.
  bool _criticalFired = false;

  /// Callback invoked when the timer expires (auto-skip turn).
  VoidCallback? onTimerExpired;

  /// Callback invoked once when entering the warning zone (<=10s).
  VoidCallback? onWarning;

  /// Callback invoked once when entering the critical zone (<=5s).
  VoidCallback? onCritical;

  /// Configures the turn duration and threshold values.
  ///
  /// Must be called before [startTurn] for the new values to take effect.
  ///
  /// **Parameters:**
  /// - [turnDuration]: Duration in seconds for each turn.
  /// - [warningThreshold]: Seconds remaining when warning zone starts.
  /// - [criticalThreshold]: Seconds remaining when critical zone starts.
  void configure({
    int turnDuration = defaultTurnDuration,
    int warningThreshold = defaultWarningThreshold,
    int criticalThreshold = defaultCriticalThreshold,
  }) {
    _turnDuration = turnDuration;
    this.warningThreshold = warningThreshold;
    this.criticalThreshold = criticalThreshold;
  }

  /// The configured turn duration in seconds (read-only).
  int get turnDuration => _turnDuration;

  /// Starts a new countdown for the current turn.
  ///
  /// Cancels any existing timer, resets the countdown to [_turnDuration],
  /// and begins periodic one-second ticks. Also resets the warning/critical
  /// callback flags so they fire fresh for the new turn.
  void startTurn() {
    cancel();
    _warningFired = false;
    _criticalFired = false;
    remainingSeconds.value = _turnDuration;
    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  /// Pauses the timer (e.g. during AI turn).
  ///
  /// The remaining seconds are preserved and can be resumed later
  /// with [resume].
  void pause() {
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
  }

  /// Resumes a paused timer.
  ///
  /// Does nothing if already running or if there are no remaining seconds.
  void resume() {
    if (isRunning.value || remainingSeconds.value <= 0) return;
    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  /// Cancels and resets the timer.
  ///
  /// Sets [remainingSeconds] to 0, [isRunning] to false, and disposes
  /// the internal periodic timer.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    isRunning.value = false;
    remainingSeconds.value = 0;
  }

  /// Internal tick handler called every second by [Timer.periodic].
  ///
  /// Decrements [remainingSeconds], fires warning/critical callbacks
  /// at their respective thresholds, and fires [onTimerExpired] when
  /// the countdown reaches zero.
  void _tick(Timer timer) {
    if (remainingSeconds.value <= 0) {
      cancel();
      onTimerExpired?.call();
      return;
    }

    remainingSeconds.value--;

    // Fire warning callback at the threshold (once per turn).
    if (!_warningFired &&
        remainingSeconds.value <= warningThreshold &&
        remainingSeconds.value > criticalThreshold) {
      _warningFired = true;
      onWarning?.call();
    }

    // Fire critical callback at the threshold (once per turn).
    if (!_criticalFired && remainingSeconds.value <= criticalThreshold) {
      _criticalFired = true;
      onCritical?.call();
    }

    // Timer expired.
    if (remainingSeconds.value <= 0) {
      cancel();
      onTimerExpired?.call();
    }
  }

  /// Cleans up resources.
  ///
  /// Cancels the timer and clears all callbacks.
  void dispose() {
    cancel();
    onTimerExpired = null;
    onWarning = null;
    onCritical = null;
  }

  /// Progress value from 0.0 (expired) to 1.0 (full time).
  ///
  /// Useful for binding to a [LinearProgressIndicator] or custom bar.
  double get progress =>
      _turnDuration > 0 ? remainingSeconds.value / _turnDuration : 0.0;

  /// Whether the timer is in the warning zone (<=10s and >5s).
  bool get isWarning =>
      remainingSeconds.value <= warningThreshold &&
      remainingSeconds.value > criticalThreshold;

  /// Whether the timer is in the critical zone (<=5s and >0s).
  bool get isCritical =>
      remainingSeconds.value <= criticalThreshold &&
      remainingSeconds.value > 0;
}
