import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/snap_config.dart';

/// Controls snap-to-keyframe behavior for scroll sequences.
///
/// Listens for scroll idle events and animates the scroll position to the
/// nearest snap point. Snap animations are cancellable by resuming scrolling.
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
    _scrollPosition = null;
    _currentProgress = null;
  }

  /// Called on scroll updates. Resets idle timer and cancels active snaps.
  void onScrollUpdate() {
    _cancelTimer();
    if (_isSnapping) {
      _cancelSnap();
    }
  }

  /// Called when scrolling ends. Starts the idle debounce timer.
  void onScrollEnd() {
    _cancelTimer();
    _idleTimer = Timer(config.idleTimeout, _performSnap);
  }

  /// Cancels any active snap animation.
  void cancelSnap() {
    _cancelTimer();
    _cancelSnap();
  }

  /// Releases resources.
  void dispose() {
    _cancelTimer();
    _cancelSnap();
    _scrollPosition = null;
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
