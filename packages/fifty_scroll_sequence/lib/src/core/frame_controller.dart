import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../utils/lerp_util.dart';

/// Maps scroll progress (0.0 to 1.0) to a frame index using ticker-based
/// smooth interpolation.
///
/// Scroll events set a [targetProgress] while an internal vsync-driven
/// ticker smoothly interpolates [progress] toward it each frame. A [Curve]
/// is applied to the interpolated progress before mapping to a frame index,
/// allowing non-linear frame distribution (e.g. ease-in-out).
///
/// ## Backward Compatibility
///
/// Setting [lerpFactor] to `1.0` makes the interpolation converge in a
/// single tick, which is functionally identical to instant frame updates.
///
/// ## Example
///
/// ```dart
/// // Inside a State with SingleTickerProviderStateMixin:
/// final controller = FrameController(
///   frameCount: 120,
///   vsync: this,
///   lerpFactor: 0.15,
///   curve: Curves.easeInOut,
/// );
///
/// controller.addListener(() {
///   print('Frame: ${controller.currentIndex}');
/// });
///
/// controller.updateFromProgress(0.5); // Smoothly lerps to frame ~60
/// ```
class FrameController extends ChangeNotifier {
  /// Creates a [FrameController] for a sequence with [frameCount] frames.
  ///
  /// The [vsync] provider is used to create a ticker for smooth
  /// interpolation. Typically supplied by [SingleTickerProviderStateMixin].
  ///
  /// [lerpFactor] controls interpolation speed: 0.15 means 15% of the
  /// remaining distance per tick. 1.0 means instant (no lerp).
  ///
  /// [curve] transforms the interpolated progress before frame index
  /// mapping. For example, [Curves.easeInOut] causes frames to change
  /// slowly at the start and end of the scroll range.
  FrameController({
    required this.frameCount,
    required TickerProvider vsync,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
  })  : assert(frameCount > 0, 'frameCount must be positive'),
        assert(
          lerpFactor > 0.0 && lerpFactor <= 1.0,
          'lerpFactor must be in (0.0, 1.0]',
        ) {
    _ticker = vsync.createTicker(_onTick);
  }

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Interpolation speed factor in the range (0.0, 1.0].
  ///
  /// Lower values produce smoother but slower transitions.
  /// A value of 1.0 disables lerping (instant updates).
  final double lerpFactor;

  /// Curve applied to interpolated progress before frame index mapping.
  final Curve curve;

  late final Ticker _ticker;
  double _targetProgress = 0.0;
  double _currentProgress = 0.0;
  int _currentIndex = 0;

  /// Current frame index (0-based).
  int get currentIndex => _currentIndex;

  /// Current interpolated progress value (0.0 to 1.0).
  ///
  /// This is the smoothly lerped value, not the raw scroll target.
  double get progress => _currentProgress;

  /// Target progress value set by the most recent scroll event.
  double get targetProgress => _targetProgress;

  /// Whether the interpolation is still converging toward [targetProgress].
  bool get isLerping =>
      !LerpUtil.hasConverged(_currentProgress, _targetProgress);

  /// Set the target progress from a scroll event.
  ///
  /// Does NOT directly change the displayed frame. Instead, updates the
  /// target that the ticker loop interpolates toward. The ticker starts
  /// automatically if not already running.
  void updateFromProgress(double progress) {
    _targetProgress = progress.clamp(0.0, 1.0);

    // Start ticker if not already running.
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  /// Pause the lerp ticker (e.g. when the app goes to background).
  void pauseTicker() {
    if (_ticker.isActive) _ticker.stop();
  }

  /// Resume the lerp ticker if there is unfinished interpolation.
  void resumeTicker() {
    if (isLerping && !_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  void _onTick(Duration elapsed) {
    if (LerpUtil.hasConverged(_currentProgress, _targetProgress)) {
      // Snap to exact target and stop the ticker.
      _currentProgress = _targetProgress;
      _ticker.stop();
      _updateIndex();
      return;
    }

    _currentProgress = LerpUtil.lerp(
      _currentProgress,
      _targetProgress,
      lerpFactor,
    );

    _updateIndex();
  }

  void _updateIndex() {
    // Apply curve transform to the interpolated progress.
    final curved = curve.transform(_currentProgress.clamp(0.0, 1.0));
    final newIndex = _progressToIndex(curved);
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  int _progressToIndex(double p) {
    if (frameCount <= 1) return 0;
    return (p * (frameCount - 1)).round().clamp(0, frameCount - 1);
  }
}
