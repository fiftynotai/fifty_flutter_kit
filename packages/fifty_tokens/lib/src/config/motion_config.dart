import 'package:flutter/animation.dart';

/// Configuration for motion tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.motion] as a starting
/// point and [copyWith] for partial overrides.
class FiftyMotionConfig {
  /// Creates a [FiftyMotionConfig] with all required fields.
  const FiftyMotionConfig({
    required this.instant,
    required this.fast,
    required this.compiling,
    required this.systemLoad,
    required this.standard,
    required this.enter,
    required this.exit,
  });

  /// Build a [FiftyMotionConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  ///
  /// Durations are parsed from int (milliseconds). Curves are NOT
  /// parseable from JSON and always use [fallback] values.
  factory FiftyMotionConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyMotionConfig fallback,
  }) {
    return FiftyMotionConfig(
      instant: _parseDuration(map['instant']) ?? fallback.instant,
      fast: _parseDuration(map['fast']) ?? fallback.fast,
      compiling: _parseDuration(map['compiling']) ?? fallback.compiling,
      systemLoad: _parseDuration(map['systemLoad']) ?? fallback.systemLoad,
      // Curves are not JSON-serializable; always use fallback.
      standard: fallback.standard,
      enter: fallback.enter,
      exit: fallback.exit,
    );
  }

  /// Instant duration. Default: `Duration.zero`.
  final Duration instant;

  /// Fast duration. Default: `Duration(milliseconds: 150)`.
  final Duration fast;

  /// Compiling duration. Default: `Duration(milliseconds: 300)`.
  final Duration compiling;

  /// System load duration. Default: `Duration(milliseconds: 800)`.
  final Duration systemLoad;

  /// Standard easing curve. Default: `Cubic(0.2, 0, 0, 1)`.
  final Curve standard;

  /// Enter easing curve. Default: `Cubic(0.2, 0.8, 0.2, 1)`.
  final Curve enter;

  /// Exit easing curve. Default: `Cubic(0.4, 0, 1, 1)`.
  final Curve exit;

  /// Returns a copy with the given fields replaced.
  FiftyMotionConfig copyWith({
    Duration? instant,
    Duration? fast,
    Duration? compiling,
    Duration? systemLoad,
    Curve? standard,
    Curve? enter,
    Curve? exit,
  }) {
    return FiftyMotionConfig(
      instant: instant ?? this.instant,
      fast: fast ?? this.fast,
      compiling: compiling ?? this.compiling,
      systemLoad: systemLoad ?? this.systemLoad,
      standard: standard ?? this.standard,
      enter: enter ?? this.enter,
      exit: exit ?? this.exit,
    );
  }

  static Duration? _parseDuration(dynamic value) {
    if (value == null) return null;
    if (value is int) return Duration(milliseconds: value);
    return null;
  }
}
