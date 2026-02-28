import 'package:flutter/animation.dart';

/// Configuration for [FiftyMotion] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyMotionConfig {
  /// Creates a [FiftyMotionConfig] with optional overrides.
  const FiftyMotionConfig({
    this.instant,
    this.fast,
    this.compiling,
    this.systemLoad,
    this.standard,
    this.enter,
    this.exit,
  });

  /// Override for [FiftyMotion.instant]. Default: `Duration.zero`.
  final Duration? instant;

  /// Override for [FiftyMotion.fast]. Default: `Duration(milliseconds: 150)`.
  final Duration? fast;

  /// Override for [FiftyMotion.compiling]. Default: `Duration(milliseconds: 300)`.
  final Duration? compiling;

  /// Override for [FiftyMotion.systemLoad]. Default: `Duration(milliseconds: 800)`.
  final Duration? systemLoad;

  /// Override for [FiftyMotion.standard]. Default: `Cubic(0.2, 0, 0, 1)`.
  final Curve? standard;

  /// Override for [FiftyMotion.enter]. Default: `Cubic(0.2, 0.8, 0.2, 1)`.
  final Curve? enter;

  /// Override for [FiftyMotion.exit]. Default: `Cubic(0.4, 0, 1, 1)`.
  final Curve? exit;
}
