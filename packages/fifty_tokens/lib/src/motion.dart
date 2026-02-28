import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'config/motion_config.dart';

/// Fifty.dev motion tokens - animation timing and easing.
///
/// Philosophy: Kinetic. Heavy but fast. NO FADES.
/// Use slides, wipes, and reveals (shutter effect).
///
/// All motion honors Reduce Motion accessibility settings.
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftyMotionConfig].
class FiftyMotion {
  FiftyMotion._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyMotionConfig? config;

  // ============================================================================
  // DURATIONS (from FDL Brand Sheet)
  // ============================================================================

  static const Duration _defaultInstant = Duration.zero;
  static const Duration _defaultFast = Duration(milliseconds: 150);
  static const Duration _defaultCompiling = Duration(milliseconds: 300);
  static const Duration _defaultSystemLoad = Duration(milliseconds: 800);

  /// Instant (0ms) - Logic changes.
  ///
  /// Use for:
  /// - Immediate state changes
  /// - Logic-driven updates
  /// - No animation needed
  static Duration get instant => config?.instant ?? _defaultInstant;

  /// Fast (150ms) - Hover states.
  ///
  /// Use for:
  /// - Hover effects
  /// - Quick feedback
  /// - Micro-interactions
  static Duration get fast => config?.fast ?? _defaultFast;

  /// Compiling (300ms) - Panel reveals.
  ///
  /// Use for:
  /// - Panel animations
  /// - Modal entrances
  /// - Content reveals
  ///
  /// Named "compiling" to evoke the system processing feel.
  static Duration get compiling => config?.compiling ?? _defaultCompiling;

  /// System Load (800ms) - Staggered entry.
  ///
  /// Use for:
  /// - Staggered list animations
  /// - Page load sequences
  /// - Complex orchestrated entrances
  static Duration get systemLoad => config?.systemLoad ?? _defaultSystemLoad;

  // ============================================================================
  // EASING CURVES
  // ============================================================================

  static const Curve _defaultStandard = Cubic(0.2, 0, 0, 1);
  static const Curve _defaultEnter = Cubic(0.2, 0.8, 0.2, 1);
  static const Curve _defaultExit = Cubic(0.4, 0, 1, 1);

  /// Standard curve - Smooth ease for most transitions.
  ///
  /// Cubic Bezier: (0.2, 0, 0, 1)
  /// Use for general-purpose animations.
  static Curve get standard => config?.standard ?? _defaultStandard;

  /// Enter curve - Springy entrance.
  ///
  /// Cubic Bezier: (0.2, 0.8, 0.2, 1)
  /// Use for elements entering the viewport.
  /// Creates slight overshoot for energy.
  static Curve get enter => config?.enter ?? _defaultEnter;

  /// Exit curve - Sharp exit.
  ///
  /// Cubic Bezier: (0.4, 0, 1, 1)
  /// Use for elements leaving the viewport.
  /// Quick and decisive.
  static Curve get exit => config?.exit ?? _defaultExit;

  // ============================================================================
  // PHILOSOPHY
  // ============================================================================
  // - NO FADES: Use slides, wipes, and reveals instead
  // - Kinetic: Heavy but fast, like machinery
  // - Shutter effect: Think manga page turns, blast doors
  // - Loading: Use text sequences, never spinners
  //   Example: "> INITIALIZING..." → "> LOADING..." → "> DONE."
}
