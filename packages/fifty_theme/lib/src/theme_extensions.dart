import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev theme extension for custom properties.
///
/// Provides access to Fifty-specific design tokens that don't map
/// directly to Material Design components:
/// - Igris Green (AI terminal color)
/// - Focus glow effects
/// - Motion durations and curves
///
/// Access via `Theme.of(context).extension<FiftyThemeExtension>()`.
///
/// Example:
/// ```dart
/// final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: fifty.focusGlow,
///   ),
/// );
/// ```
class FiftyThemeExtension extends ThemeExtension<FiftyThemeExtension> {
  /// Creates a Fifty theme extension with all custom properties.
  const FiftyThemeExtension({
    required this.igrisGreen,
    required this.focusGlow,
    required this.strongFocusGlow,
    required this.instant,
    required this.fast,
    required this.compiling,
    required this.systemLoad,
    required this.standardCurve,
    required this.enterCurve,
    required this.exitCurve,
    required this.success,
    required this.warning,
  });

  /// Creates the default Fifty theme extension.
  ///
  /// Uses all standard FDL tokens.
  factory FiftyThemeExtension.standard() {
    return FiftyThemeExtension(
      igrisGreen: FiftyColors.igrisGreen,
      focusGlow: FiftyElevation.focus,
      strongFocusGlow: FiftyElevation.strongFocus,
      instant: FiftyMotion.instant,
      fast: FiftyMotion.fast,
      compiling: FiftyMotion.compiling,
      systemLoad: FiftyMotion.systemLoad,
      standardCurve: FiftyMotion.standard,
      enterCurve: FiftyMotion.enter,
      exitCurve: FiftyMotion.exit,
      success: FiftyColors.success,
      warning: FiftyColors.warning,
    );
  }

  // ============================================================================
  // COLORS
  // ============================================================================

  /// Igris Green (#00FF41) - AI terminal color.
  ///
  /// Reserved for AI/terminal contexts only.
  /// Use for IGRIS terminal output and AI indicators.
  final Color igrisGreen;

  /// Success color (#00BA33).
  ///
  /// Use for positive actions and confirmations.
  final Color success;

  /// Warning color (#F7A100).
  ///
  /// Use for caution states and important notices.
  final Color warning;

  // ============================================================================
  // GLOWS
  // ============================================================================

  /// Standard focus glow effect.
  ///
  /// Crimson glow for focus states.
  /// Apply to BoxDecoration.boxShadow for interactive elements.
  final List<BoxShadow> focusGlow;

  /// Strong focus glow effect.
  ///
  /// Enhanced glow for active/selected states.
  /// Provides more visual prominence.
  final List<BoxShadow> strongFocusGlow;

  // ============================================================================
  // DURATIONS
  // ============================================================================

  /// Instant duration (0ms) - Logic changes.
  ///
  /// For immediate state changes with no animation.
  final Duration instant;

  /// Fast duration (150ms) - Hover states.
  ///
  /// For quick feedback and micro-interactions.
  final Duration fast;

  /// Compiling duration (300ms) - Panel reveals.
  ///
  /// For panel animations and modal entrances.
  final Duration compiling;

  /// System Load duration (800ms) - Staggered entry.
  ///
  /// For staggered list animations and page loads.
  final Duration systemLoad;

  // ============================================================================
  // CURVES
  // ============================================================================

  /// Standard curve - Smooth ease.
  ///
  /// For general-purpose animations.
  final Curve standardCurve;

  /// Enter curve - Springy entrance.
  ///
  /// For elements entering the viewport.
  final Curve enterCurve;

  /// Exit curve - Sharp exit.
  ///
  /// For elements leaving the viewport.
  final Curve exitCurve;

  // ============================================================================
  // THEMING
  // ============================================================================

  @override
  FiftyThemeExtension copyWith({
    Color? igrisGreen,
    List<BoxShadow>? focusGlow,
    List<BoxShadow>? strongFocusGlow,
    Duration? instant,
    Duration? fast,
    Duration? compiling,
    Duration? systemLoad,
    Curve? standardCurve,
    Curve? enterCurve,
    Curve? exitCurve,
    Color? success,
    Color? warning,
  }) {
    return FiftyThemeExtension(
      igrisGreen: igrisGreen ?? this.igrisGreen,
      focusGlow: focusGlow ?? this.focusGlow,
      strongFocusGlow: strongFocusGlow ?? this.strongFocusGlow,
      instant: instant ?? this.instant,
      fast: fast ?? this.fast,
      compiling: compiling ?? this.compiling,
      systemLoad: systemLoad ?? this.systemLoad,
      standardCurve: standardCurve ?? this.standardCurve,
      enterCurve: enterCurve ?? this.enterCurve,
      exitCurve: exitCurve ?? this.exitCurve,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  FiftyThemeExtension lerp(FiftyThemeExtension? other, double t) {
    if (other == null) return this;

    return FiftyThemeExtension(
      igrisGreen: Color.lerp(igrisGreen, other.igrisGreen, t)!,
      focusGlow: t < 0.5 ? focusGlow : other.focusGlow,
      strongFocusGlow: t < 0.5 ? strongFocusGlow : other.strongFocusGlow,
      instant: t < 0.5 ? instant : other.instant,
      fast: t < 0.5 ? fast : other.fast,
      compiling: t < 0.5 ? compiling : other.compiling,
      systemLoad: t < 0.5 ? systemLoad : other.systemLoad,
      standardCurve: t < 0.5 ? standardCurve : other.standardCurve,
      enterCurve: t < 0.5 ? enterCurve : other.enterCurve,
      exitCurve: t < 0.5 ? exitCurve : other.exitCurve,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
