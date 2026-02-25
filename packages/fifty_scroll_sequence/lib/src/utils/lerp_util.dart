/// Stateless interpolation utilities for smooth frame transitions.
///
/// Provides pure-function linear interpolation with snap-to-target
/// convergence to prevent infinite asymptotic approach.
///
/// All methods operate on normalized progress values (0.0 to 1.0).
class LerpUtil {
  const LerpUtil._();

  /// Minimum distance before snapping directly to [target].
  ///
  /// For a 120-frame sequence, one frame equals approximately 0.0083
  /// progress units. A threshold of 0.001 is well within sub-frame
  /// territory, preventing visible oscillation while ensuring the
  /// ticker stops promptly.
  static const double snapThreshold = 0.001;

  /// Interpolate [current] toward [target] by [factor].
  ///
  /// Each tick moves [factor] fraction of the remaining distance.
  /// For example, `factor = 0.15` moves 15% of the gap per tick.
  ///
  /// When the remaining distance is less than [snapThreshold], snaps
  /// directly to [target] to prevent infinite asymptotic approach.
  ///
  /// ```dart
  /// LerpUtil.lerp(0.0, 1.0, 0.15); // 0.15
  /// LerpUtil.lerp(0.5, 1.0, 0.15); // 0.575
  /// LerpUtil.lerp(0.999, 1.0, 0.15); // 1.0 (snapped)
  /// ```
  static double lerp(double current, double target, double factor) {
    final delta = target - current;
    if (delta.abs() < snapThreshold) return target;
    return current + delta * factor;
  }

  /// Whether [current] has converged to [target].
  ///
  /// Returns `true` when the absolute difference is less than
  /// [snapThreshold], meaning no further interpolation is needed.
  static bool hasConverged(double current, double target) {
    return (current - target).abs() < snapThreshold;
  }
}
