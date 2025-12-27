import 'package:flutter/animation.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

/// **Fade Preset**
///
/// Defines reusable fade durations and curves for consistent audio transitions
/// throughout the application.
///
/// Integrates with [FiftyMotion] tokens for consistent timing across the
/// Fifty Design Language ecosystem.
///
/// Use in conjunction with [BaseAudioChannel.withFade] for scene transitions,
/// character voice ducking, and ambiance changes.
///
/// Part of the Fifty Audio Engine package.
class FadePreset {
  final Duration duration;
  final Curve curve;

  const FadePreset({
    required this.duration,
    required this.curve,
  });

  /// Fast transitions (e.g., UI sounds)
  ///
  /// Uses [FiftyMotion.fast] (150ms) for quick audio feedback.
  static const FadePreset fast = FadePreset(
    duration: FiftyMotion.fast,
    curve: Curves.linear,
  );

  /// Standard scene transitions
  ///
  /// Uses [FiftyMotion.systemLoad] (800ms) for dramatic audio transitions.
  static const FadePreset normal = FadePreset(
    duration: FiftyMotion.systemLoad,
    curve: Curves.easeInOut,
  );

  /// Panel reveals and UI feedback
  ///
  /// Uses [FiftyMotion.compiling] (300ms) with [FiftyMotion.standard] curve
  /// for consistent UI audio feedback.
  static const FadePreset panel = FadePreset(
    duration: FiftyMotion.compiling,
    curve: FiftyMotion.standard,
  );

  /// Cinematic or dramatic fades
  ///
  /// Extended duration for theatrical effect.
  static const FadePreset cinematic = FadePreset(
    duration: Duration(seconds: 2),
    curve: Curves.easeInOutCubic,
  );

  /// Slow ambient fades (e.g., credits, weather shifts)
  static const FadePreset ambient = FadePreset(
    duration: Duration(seconds: 3),
    curve: Curves.decelerate,
  );

  /// Builds tension (e.g., entering boss fight)
  static const FadePreset buildTension = FadePreset(
    duration: Duration(milliseconds: 1200),
    curve: Curves.easeIn,
  );

  /// Smooth exit (e.g., scene fade out)
  static const FadePreset smoothExit = FadePreset(
    duration: Duration(milliseconds: 1000),
    curve: Curves.easeOut,
  );
}
