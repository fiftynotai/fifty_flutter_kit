import 'dart:ui' show VoidCallback;

/// Manages input blocking state (internal).
///
/// When input is blocked (e.g., during animations), tap events should be
/// ignored. The [AnimationQueue] owns blocking lifecycle.
class InputManager {
  bool _isBlocked = false;

  /// Whether input is currently blocked.
  bool get isBlocked => _isBlocked;

  /// Callback invoked when input is unblocked.
  VoidCallback? onUnblocked;

  /// Blocks all input. Called when animations start.
  void block() {
    _isBlocked = true;
  }

  /// Unblocks input. Called when animations complete.
  void unblock() {
    _isBlocked = false;
    onUnblocked?.call();
  }
}
