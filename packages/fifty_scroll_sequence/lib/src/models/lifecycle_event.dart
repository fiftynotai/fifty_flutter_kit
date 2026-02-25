/// Lifecycle events for scroll sequence viewport transitions.
///
/// Used by [ViewportObserver] to track state transitions. The widget surface
/// uses individual [VoidCallback] parameters instead of this enum.
enum ScrollSequenceLifecycleEvent {
  /// Sequence entered viewport (forward scroll).
  enter,

  /// Sequence exited viewport (forward scroll).
  leave,

  /// Sequence re-entered viewport (backward scroll).
  enterBack,

  /// Sequence exited viewport backward (scrolled past start).
  leaveBack,
}
