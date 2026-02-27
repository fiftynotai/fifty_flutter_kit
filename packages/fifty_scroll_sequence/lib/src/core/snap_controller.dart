import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/snap_config.dart';

/// Controls snap-to-keyframe behavior for scroll sequences.
///
/// Listens for scroll idle events and animates the scroll position to the
/// nearest snap point. Snap animations are cancellable by resuming scrolling.
///
/// In pinned mode, uses velocity tracking via [onPositionChanged] to detect
/// momentum deceleration and snap early instead of waiting for complete stop.
class SnapController {
  /// Creates a [SnapController] with the given [config].
  SnapController({required this.config});

  /// The snap configuration controlling snap points, timing, and curves.
  final SnapConfig config;

  ScrollPosition? _scrollPosition;
  double Function()? _currentProgress;
  double _scrollExtent = 0;
  Timer? _idleTimer;
  bool _isSnapping = false;

  // Velocity tracking for pinned mode momentum detection.
  double? _lastPixels;
  double? _prevDelta;

  /// Per-frame pixel delta below which momentum is considered dying.
  ///
  /// At 60fps (~16ms/frame), 2.0 px/frame ≈ 120 px/s — a near-crawl.
  /// Snapping at this point feels instant to the user since the remaining
  /// momentum distance is negligible.
  static const double _momentumThreshold = 2.0;

  /// Whether a snap animation is currently in progress.
  bool get isSnapping => _isSnapping;

  /// Attaches the controller to a scroll position.
  ///
  /// [scrollExtent] is the total scroll distance for the sequence.
  /// [currentProgress] returns the current normalized progress (0.0--1.0).
  void attach(
    ScrollPosition scrollPosition, {
    required double scrollExtent,
    required double Function() currentProgress,
  }) {
    _scrollPosition = scrollPosition;
    _scrollExtent = scrollExtent;
    _currentProgress = currentProgress;
  }

  /// Detaches from the current scroll position and cancels pending operations.
  void detach() {
    _cancelTimer();
    _cancelSnap();
    _resetVelocityTracking();
    _scrollPosition = null;
    _currentProgress = null;
  }

  /// Called on scroll updates (non-pinned mode).
  ///
  /// Resets idle timer, velocity tracking, and cancels active snaps.
  void onScrollUpdate() {
    _cancelTimer();
    _resetVelocityTracking();
    if (_isSnapping) {
      _cancelSnap();
    }
  }

  /// Called when scrolling ends (non-pinned mode).
  ///
  /// Starts the idle debounce timer.
  void onScrollEnd() {
    _cancelTimer();
    _idleTimer = Timer(config.idleTimeout, _performSnap);
  }

  /// Called on every scroll position change in pinned mode.
  ///
  /// Tracks per-frame pixel deltas to detect momentum deceleration.
  /// When the delta is both decelerating and below [_momentumThreshold],
  /// snaps immediately instead of waiting for momentum to fully decay.
  ///
  /// Falls back to idle timer if momentum detection doesn't trigger
  /// (e.g. user stops scrolling abruptly with no momentum).
  void onPositionChanged(double pixels) {
    if (_isSnapping) return;

    if (_lastPixels != null) {
      final delta = (pixels - _lastPixels!).abs();

      if (delta > 0) {
        // Snap when momentum is decelerating below threshold.
        // During user drag, velocity is erratic (increases/decreases).
        // During ballistic momentum, velocity strictly decreases.
        if (_prevDelta != null &&
            delta < _prevDelta! &&
            delta < _momentumThreshold) {
          _cancelTimer();
          _resetVelocityTracking();
          _performSnap();
          return;
        }
        _prevDelta = delta;
      }
    }

    _lastPixels = pixels;

    // Fallback: idle timer for cases where scroll stops without momentum
    // (e.g. trackpad lift with zero velocity).
    _cancelTimer();
    _idleTimer = Timer(config.idleTimeout, _performSnap);
  }

  /// Cancels any active snap animation.
  void cancelSnap() {
    _cancelTimer();
    _cancelSnap();
    _resetVelocityTracking();
  }

  /// Releases resources.
  void dispose() {
    _cancelTimer();
    _cancelSnap();
    _resetVelocityTracking();
    _scrollPosition = null;
  }

  void _resetVelocityTracking() {
    _lastPixels = null;
    _prevDelta = null;
  }

  void _cancelTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  void _cancelSnap() {
    if (_isSnapping) {
      if (_scrollPosition != null && _scrollPosition!.hasPixels) {
        // Halt animateTo mid-flight by jumping to current position
        _scrollPosition!.jumpTo(_scrollPosition!.pixels);
      }
      _isSnapping = false;
    }
  }

  void _performSnap() {
    if (_scrollPosition == null ||
        _currentProgress == null ||
        !_scrollPosition!.hasPixels) {
      return;
    }

    final progress = _currentProgress!();
    final target = config.nearestSnapPoint(progress);

    // Skip if already at the target (within small epsilon).
    if ((target - progress).abs() < 0.001) return;

    // Delta-based offset: from current position, move by the progress
    // difference. This works correctly in both pinned and non-pinned modes
    // regardless of lead-in spacing or widget position.
    final delta = (target - progress) * _scrollExtent;
    final targetOffset = _scrollPosition!.pixels + delta;

    _isSnapping = true;
    _scrollPosition!
        .animateTo(
          targetOffset,
          duration: config.snapDuration,
          curve: config.snapCurve,
        )
        .whenComplete(() {
      _isSnapping = false;
    });
  }
}
