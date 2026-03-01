import 'package:flutter/material.dart';

import 'config/fifty_tokens_config.dart';

/// Fifty.dev motion tokens -- reads from the active [FiftyPreset].
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
  static Duration get instant => FiftyTokens.active.motion.instant;

  /// Fast (150ms) - Hover states.
  ///
  /// Use for:
  /// - Hover effects
  /// - Quick feedback
  /// - Micro-interactions
  static Duration get fast => FiftyTokens.active.motion.fast;

  /// Compiling (300ms) - Panel reveals.
  ///
  /// Use for:
  /// - Panel animations
  /// - Modal entrances
  /// - Content reveals
  ///
  /// Named "compiling" to evoke the system processing feel.
  static Duration get compiling => FiftyTokens.active.motion.compiling;

  /// System Load (800ms) - Staggered entry.
  ///
  /// Use for:
  /// - Staggered list animations
  /// - Page load sequences
  /// - Complex orchestrated entrances
  static Duration get systemLoad => FiftyTokens.active.motion.systemLoad;

  // ============================================================================
  // EASING CURVES
  // ============================================================================

  /// Standard curve - Smooth ease for most transitions.
  ///
  /// Cubic Bezier: (0.2, 0, 0, 1)
  /// Use for general-purpose animations.
  static Curve get standard => FiftyTokens.active.motion.standard;

  /// Enter curve - Springy entrance.
  ///
  /// Cubic Bezier: (0.2, 0.8, 0.2, 1)
  /// Use for elements entering the viewport.
  /// Creates slight overshoot for energy.
  static Curve get enter => FiftyTokens.active.motion.enter;

  /// Exit curve - Sharp exit.
  ///
  /// Cubic Bezier: (0.4, 0, 1, 1)
  /// Use for elements leaving the viewport.
  /// Quick and decisive.
  static Curve get exit => FiftyTokens.active.motion.exit;

  // ============================================================================
  // PHILOSOPHY
  // ============================================================================
  // - NO FADES: Use slides, wipes, and reveals instead
  // - Kinetic: Heavy but fast, like machinery
  // - Shutter effect: Think manga page turns, blast doors
  // - Loading: Use text sequences, never spinners
  //   Example: "> INITIALIZING..." -> "> LOADING..." -> "> DONE."
}
