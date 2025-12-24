import 'package:flutter/material.dart';

/// Fifty.dev motion tokens - animation timing and easing.
///
/// Philosophy: Kinetic. Heavy but fast. NO FADES.
/// Use slides, wipes, and reveals (shutter effect).
///
/// All motion honors Reduce Motion accessibility settings.
class FiftyMotion {
  FiftyMotion._();

  // ============================================================================
  // DURATIONS (from FDL Brand Sheet)
  // ============================================================================

  /// Instant (0ms) - Logic changes.
  ///
  /// Use for:
  /// - Immediate state changes
  /// - Logic-driven updates
  /// - No animation needed
  static const Duration instant = Duration.zero;

  /// Fast (150ms) - Hover states.
  ///
  /// Use for:
  /// - Hover effects
  /// - Quick feedback
  /// - Micro-interactions
  static const Duration fast = Duration(milliseconds: 150);

  /// Compiling (300ms) - Panel reveals.
  ///
  /// Use for:
  /// - Panel animations
  /// - Modal entrances
  /// - Content reveals
  ///
  /// Named "compiling" to evoke the system processing feel.
  static const Duration compiling = Duration(milliseconds: 300);

  /// System Load (800ms) - Staggered entry.
  ///
  /// Use for:
  /// - Staggered list animations
  /// - Page load sequences
  /// - Complex orchestrated entrances
  static const Duration systemLoad = Duration(milliseconds: 800);

  // ============================================================================
  // EASING CURVES
  // ============================================================================

  /// Standard curve - Smooth ease for most transitions.
  ///
  /// Cubic Bezier: (0.2, 0, 0, 1)
  /// Use for general-purpose animations.
  static const Curve standard = Cubic(0.2, 0, 0, 1);

  /// Enter curve - Springy entrance.
  ///
  /// Cubic Bezier: (0.2, 0.8, 0.2, 1)
  /// Use for elements entering the viewport.
  /// Creates slight overshoot for energy.
  static const Curve enter = Cubic(0.2, 0.8, 0.2, 1);

  /// Exit curve - Sharp exit.
  ///
  /// Cubic Bezier: (0.4, 0, 1, 1)
  /// Use for elements leaving the viewport.
  /// Quick and decisive.
  static const Curve exit = Cubic(0.4, 0, 1, 1);

  // ============================================================================
  // PHILOSOPHY
  // ============================================================================
  // - NO FADES: Use slides, wipes, and reveals instead
  // - Kinetic: Heavy but fast, like machinery
  // - Shutter effect: Think manga page turns, blast doors
  // - Loading: Use text sequences, never spinners
  //   Example: "> INITIALIZING..." → "> LOADING..." → "> DONE."
}
