import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Configuration for snap-to-keyframe behavior.
///
/// When provided to a [ScrollSequence] or [SliverScrollSequence], the scroll
/// position auto-settles to the nearest snap point when the user stops scrolling.
///
/// Three constructors are available:
/// - [SnapConfig.new] -- explicit list of progress values (0.0--1.0)
/// - [SnapConfig.everyNFrames] -- generates snap points every N frames
/// - [SnapConfig.scenes] -- snap to scene boundary frames
@immutable
class SnapConfig {
  /// Creates a snap configuration with explicit progress snap points.
  ///
  /// [snapPoints] must be non-empty, each value in [0.0, 1.0]. Auto-sorted.
  SnapConfig({
    required List<double> snapPoints,
    this.snapDuration = const Duration(milliseconds: 300),
    this.snapCurve = Curves.easeOut,
    this.idleTimeout = const Duration(milliseconds: 150),
  })  : assert(snapPoints.isNotEmpty, 'snapPoints must not be empty'),
        _sortedPoints = List<double>.of(snapPoints)..sort() {
    for (final p in _sortedPoints) {
      assert(
        p >= 0.0 && p <= 1.0,
        'snapPoints must be in [0.0, 1.0], got $p',
      );
    }
  }

  /// Creates snap points every [n] frames for the given [frameCount].
  ///
  /// Example: `SnapConfig.everyNFrames(n: 50, frameCount: 150)` generates
  /// snap points at frames 0, 50, 100, 149 -> progress [0.0, 50/149, 100/149, 1.0].
  factory SnapConfig.everyNFrames({
    required int n,
    required int frameCount,
    Duration snapDuration = const Duration(milliseconds: 300),
    Curve snapCurve = Curves.easeOut,
    Duration idleTimeout = const Duration(milliseconds: 150),
  }) {
    assert(n > 0, 'n must be positive');
    assert(frameCount > 0, 'frameCount must be positive');
    final maxIndex = frameCount - 1;
    final points = <double>[];
    for (var i = 0; i <= maxIndex; i += n) {
      points.add(maxIndex > 0 ? i / maxIndex : 0.0);
    }
    // Always include 1.0 (last frame)
    if (points.last != 1.0 && maxIndex > 0) {
      points.add(1.0);
    }
    return SnapConfig(
      snapPoints: points,
      snapDuration: snapDuration,
      snapCurve: snapCurve,
      idleTimeout: idleTimeout,
    );
  }

  /// Creates snap points at scene boundary frames.
  ///
  /// Example: `SnapConfig.scenes(sceneStartFrames: [0, 50, 100], frameCount: 149)`
  /// snaps to progress [0.0, 50/148, 100/148].
  factory SnapConfig.scenes({
    required List<int> sceneStartFrames,
    required int frameCount,
    Duration snapDuration = const Duration(milliseconds: 300),
    Curve snapCurve = Curves.easeOut,
    Duration idleTimeout = const Duration(milliseconds: 150),
  }) {
    assert(sceneStartFrames.isNotEmpty, 'sceneStartFrames must not be empty');
    assert(frameCount > 0, 'frameCount must be positive');
    final maxIndex = frameCount - 1;
    final points = sceneStartFrames
        .map((f) => maxIndex > 0 ? (f.clamp(0, maxIndex) / maxIndex) : 0.0)
        .toSet()
        .toList();
    return SnapConfig(
      snapPoints: points,
      snapDuration: snapDuration,
      snapCurve: snapCurve,
      idleTimeout: idleTimeout,
    );
  }

  final List<double> _sortedPoints;

  /// Duration of the snap animation.
  final Duration snapDuration;

  /// Curve applied to the snap animation.
  final Curve snapCurve;

  /// How long the user must be idle before snapping begins.
  final Duration idleTimeout;

  /// The sorted list of snap points (progress values 0.0--1.0).
  List<double> get snapPoints => List<double>.unmodifiable(_sortedPoints);

  /// Finds the nearest snap point to [currentProgress] using binary search.
  ///
  /// For equidistant ties, returns the lower progress value.
  double nearestSnapPoint(double currentProgress) {
    if (_sortedPoints.length == 1) return _sortedPoints.first;

    // Binary search for insertion point
    var low = 0;
    var high = _sortedPoints.length;
    while (low < high) {
      final mid = (low + high) ~/ 2;
      if (_sortedPoints[mid] < currentProgress) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    // low is now the index of the first element >= currentProgress
    if (low == 0) return _sortedPoints.first;
    if (low == _sortedPoints.length) return _sortedPoints.last;

    final before = _sortedPoints[low - 1];
    final after = _sortedPoints[low];
    // For equidistant ties, prefer lower (before)
    return (currentProgress - before) <= (after - currentProgress)
        ? before
        : after;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnapConfig &&
          runtimeType == other.runtimeType &&
          _listEquals(_sortedPoints, other._sortedPoints) &&
          snapDuration == other.snapDuration &&
          snapCurve == other.snapCurve &&
          idleTimeout == other.idleTimeout;

  @override
  int get hashCode => Object.hash(
        Object.hashAll(_sortedPoints),
        snapDuration,
        snapCurve,
        idleTimeout,
      );

  @override
  String toString() =>
      'SnapConfig(points: $_sortedPoints, duration: $snapDuration, '
      'curve: $snapCurve, idle: $idleTimeout)';

  static bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
