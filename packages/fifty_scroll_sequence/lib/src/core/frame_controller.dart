import 'package:flutter/foundation.dart';

/// Maps scroll progress (0.0 to 1.0) to a frame index in the sequence.
///
/// Extends [ChangeNotifier] so widgets can listen for frame index changes
/// via [AnimatedBuilder] or [ListenableBuilder].
///
/// ## Example
///
/// ```dart
/// final controller = FrameController(frameCount: 120);
///
/// controller.addListener(() {
///   print('Frame: ${controller.currentIndex}');
/// });
///
/// controller.updateFromProgress(0.5); // Maps to frame ~60
/// ```
class FrameController extends ChangeNotifier {
  /// Creates a [FrameController] for a sequence with [frameCount] frames.
  FrameController({required this.frameCount})
      : assert(frameCount > 0, 'frameCount must be positive');

  /// Total number of frames in the sequence.
  final int frameCount;

  int _currentIndex = 0;

  /// Current frame index (0-based).
  int get currentIndex => _currentIndex;

  double _progress = 0.0;

  /// Current progress value (0.0 to 1.0).
  double get progress => _progress;

  /// Update the controller from a scroll progress value (0.0 to 1.0).
  ///
  /// Clamps progress to [0.0, 1.0], maps to frame index via [round],
  /// and notifies listeners only if the index changed.
  void updateFromProgress(double progress) {
    _progress = progress.clamp(0.0, 1.0);
    final newIndex = _progressToIndex(_progress);
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
