import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/widgets.dart' show VoidCallback;

/// Tracks viewport visibility and fires directional lifecycle callbacks.
///
/// Implements a state machine that guarantees exactly-once callback firing
/// per visibility transition. Supports both non-pinned (visibility-based)
/// and pinned (progress-based) modes.
class ViewportObserver {
  /// Creates a [ViewportObserver] with optional lifecycle callbacks.
  ViewportObserver({
    this.onEnter,
    this.onLeave,
    this.onEnterBack,
    this.onLeaveBack,
  });

  /// Called when the sequence enters the viewport (forward scroll).
  final VoidCallback? onEnter;

  /// Called when the sequence exits the viewport (forward scroll).
  final VoidCallback? onLeave;

  /// Called when the sequence re-enters the viewport (backward scroll).
  final VoidCallback? onEnterBack;

  /// Called when the sequence exits the viewport backward (scrolled past start).
  final VoidCallback? onLeaveBack;

  _VisibilityState _state = _VisibilityState.outside;
  _PinnedPhase _pinnedPhase = _PinnedPhase.beforePin;

  /// Whether any callback is registered.
  bool get hasCallbacks =>
      onEnter != null ||
      onLeave != null ||
      onEnterBack != null ||
      onLeaveBack != null;

  /// Updates visibility state for non-pinned mode.
  ///
  /// [isVisible] indicates whether the widget is currently in the viewport.
  /// [direction] indicates the scroll direction (forward = toward end,
  /// reverse = toward start).
  void updateVisibility({
    required bool isVisible,
    required ScrollDirection direction,
  }) {
    if (!hasCallbacks) return;

    final isForward = direction != ScrollDirection.reverse;

    switch (_state) {
      case _VisibilityState.outside:
        if (isVisible) {
          _state = _VisibilityState.inside;
          if (isForward) {
            onEnter?.call();
          } else {
            onEnterBack?.call();
          }
        }
      case _VisibilityState.inside:
        if (!isVisible) {
          _state = _VisibilityState.outside;
          if (isForward) {
            onLeave?.call();
          } else {
            onLeaveBack?.call();
          }
        }
    }
  }

  /// Updates lifecycle state for pinned mode based on pin progress.
  ///
  /// [progress] ranges from 0.0 (just pinned) to 1.0 (about to unpin).
  /// [direction] indicates the scroll direction.
  void updatePinnedState({
    required double progress,
    required ScrollDirection direction,
  }) {
    if (!hasCallbacks) return;

    const enterThreshold = 0.001;
    const leaveThreshold = 0.999;

    switch (_pinnedPhase) {
      case _PinnedPhase.beforePin:
        if (progress > enterThreshold) {
          _pinnedPhase = _PinnedPhase.pinned;
          onEnter?.call();
        }
      case _PinnedPhase.pinned:
        if (progress >= leaveThreshold &&
            direction != ScrollDirection.reverse) {
          _pinnedPhase = _PinnedPhase.afterPin;
          onLeave?.call();
        } else if (progress <= enterThreshold &&
            direction == ScrollDirection.reverse) {
          _pinnedPhase = _PinnedPhase.beforePin;
          onLeaveBack?.call();
        }
      case _PinnedPhase.afterPin:
        if (progress < leaveThreshold) {
          _pinnedPhase = _PinnedPhase.pinned;
          onEnterBack?.call();
        }
    }
  }

  /// Resets the state machine to initial state.
  void reset() {
    _state = _VisibilityState.outside;
    _pinnedPhase = _PinnedPhase.beforePin;
  }

  /// Releases resources.
  void dispose() {
    // No-op currently. For future-proofing.
  }
}

enum _VisibilityState { outside, inside }

enum _PinnedPhase { beforePin, pinned, afterPin }
