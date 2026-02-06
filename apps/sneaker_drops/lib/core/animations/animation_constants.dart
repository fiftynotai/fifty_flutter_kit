import 'package:flutter/animation.dart';

/// **SneakerAnimations**
///
/// FDL motion tokens for consistent animation timing across the sneaker marketplace.
/// All animation durations and curves should reference these constants.
///
/// **Usage:**
/// ```dart
/// AnimationController(
///   duration: SneakerAnimations.medium,
///   vsync: this,
/// );
/// ```
///
/// **Categories:**
/// - Durations: Standard timing values for different animation types
/// - Curves: Easing functions for natural motion
abstract class SneakerAnimations {
  SneakerAnimations._();

  // ============================================================
  // DURATIONS
  // ============================================================

  /// Fast interactions (150ms) - hover states, micro-interactions
  static const Duration fast = Duration(milliseconds: 150);

  /// Medium transitions (300ms) - page transitions, reveals
  static const Duration medium = Duration(milliseconds: 300);

  /// Slow animations (800ms) - complex transitions, emphasis
  static const Duration slow = Duration(milliseconds: 800);

  /// Float loop (3000ms) - ambient floating animation
  static const Duration float = Duration(milliseconds: 3000);

  /// Shimmer loop (1500ms) - skeleton loading effect
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Add to cart (300ms) - flying arc animation
  static const Duration addToCart = Duration(milliseconds: 300);

  // ============================================================
  // CURVES
  // ============================================================

  /// Standard ease out - most transitions
  static const Curve standard = Curves.easeOut;

  /// Enter animation - springy feel for elements appearing
  static const Curve enter = Curves.easeOutBack;

  /// Exit animation - quick fade out
  static const Curve exit = Curves.easeIn;

  /// Float animation - smooth oscillation
  static const Curve floatCurve = Curves.easeInOut;

  /// Bounce animation - playful interactions
  static const Curve bounce = Curves.elasticOut;

  // ============================================================
  // TRANSFORM VALUES
  // ============================================================

  /// Hover lift scale factor
  static const double hoverScale = 1.02;

  /// Hover lift translation (pixels)
  static const double hoverTranslateY = -8.0;

  /// Hover rotation (degrees)
  static const double hoverRotation = 3.0;

  /// Float amplitude (pixels)
  static const double floatAmplitude = 3.0;

  /// Float rotation (degrees)
  static const double floatRotation = 0.5;

  /// Scroll reveal initial offset (pixels)
  static const double scrollRevealOffset = 24.0;

  /// Add to cart control point height (pixels)
  static const double addToCartControlHeight = 100.0;

  /// Add to cart end scale
  static const double addToCartEndScale = 0.3;
}
