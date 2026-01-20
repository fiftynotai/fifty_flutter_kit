import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev theme extension v2 for custom properties.
///
/// Provides access to Fifty-specific design tokens including:
/// - Shadow tokens (sm, md, lg, primary, glow)
/// - Accent color (mode-aware)
/// - Motion durations and curves
///
/// Access via `Theme.of(context).extension<FiftyThemeExtension>()`.
class FiftyThemeExtension extends ThemeExtension<FiftyThemeExtension> {
  const FiftyThemeExtension({
    required this.accent,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
    required this.shadowPrimary,
    required this.shadowGlow,
    required this.success,
    required this.warning,
    required this.instant,
    required this.fast,
    required this.compiling,
    required this.systemLoad,
    required this.standardCurve,
    required this.enterCurve,
    required this.exitCurve,
  });

  /// Creates the dark mode theme extension.
  factory FiftyThemeExtension.dark() {
    return FiftyThemeExtension(
      accent: FiftyColors.powderBlush,
      shadowSm: FiftyShadows.sm,
      shadowMd: FiftyShadows.md,
      shadowLg: FiftyShadows.lg,
      shadowPrimary: FiftyShadows.primary,
      shadowGlow: FiftyShadows.glow,
      success: FiftyColors.hunterGreen,
      warning: FiftyColors.warning,
      instant: FiftyMotion.instant,
      fast: FiftyMotion.fast,
      compiling: FiftyMotion.compiling,
      systemLoad: FiftyMotion.systemLoad,
      standardCurve: FiftyMotion.standard,
      enterCurve: FiftyMotion.enter,
      exitCurve: FiftyMotion.exit,
    );
  }

  /// Creates the light mode theme extension.
  factory FiftyThemeExtension.light() {
    return FiftyThemeExtension(
      accent: FiftyColors.burgundy,
      shadowSm: FiftyShadows.sm,
      shadowMd: FiftyShadows.md,
      shadowLg: FiftyShadows.lg,
      shadowPrimary: FiftyShadows.primary,
      shadowGlow: FiftyShadows.none, // No glow in light mode
      success: FiftyColors.hunterGreen,
      warning: FiftyColors.warning,
      instant: FiftyMotion.instant,
      fast: FiftyMotion.fast,
      compiling: FiftyMotion.compiling,
      systemLoad: FiftyMotion.systemLoad,
      standardCurve: FiftyMotion.standard,
      enterCurve: FiftyMotion.enter,
      exitCurve: FiftyMotion.exit,
    );
  }

  /// @deprecated Use [dark] or [light] factory constructors.
  @Deprecated('Use FiftyThemeExtension.dark() or FiftyThemeExtension.light()')
  factory FiftyThemeExtension.standard() {
    return FiftyThemeExtension.dark();
  }

  // ============================================================================
  // COLORS
  // ============================================================================

  /// Accent color (mode-aware).
  ///
  /// - Dark mode: Powder Blush (#FFC9B9)
  /// - Light mode: Burgundy (#88292F)
  final Color accent;

  /// Success color - Hunter Green (#4B644A).
  final Color success;

  /// Warning color (#F7A100).
  final Color warning;

  // ============================================================================
  // SHADOWS
  // ============================================================================

  /// Small shadow - Subtle elevation.
  final List<BoxShadow> shadowSm;

  /// Medium shadow - Cards.
  final List<BoxShadow> shadowMd;

  /// Large shadow - Modals and dropdowns.
  final List<BoxShadow> shadowLg;

  /// Primary shadow - Primary buttons.
  final List<BoxShadow> shadowPrimary;

  /// Glow shadow - Dark mode accent (empty in light mode).
  final List<BoxShadow> shadowGlow;

  // ============================================================================
  // DURATIONS
  // ============================================================================

  /// Instant duration (0ms).
  final Duration instant;

  /// Fast duration (150ms).
  final Duration fast;

  /// Compiling duration (300ms).
  final Duration compiling;

  /// System Load duration (800ms).
  final Duration systemLoad;

  // ============================================================================
  // CURVES
  // ============================================================================

  /// Standard curve.
  final Curve standardCurve;

  /// Enter curve.
  final Curve enterCurve;

  /// Exit curve.
  final Curve exitCurve;

  // ============================================================================
  // THEMING
  // ============================================================================

  @override
  FiftyThemeExtension copyWith({
    Color? accent,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
    List<BoxShadow>? shadowPrimary,
    List<BoxShadow>? shadowGlow,
    Color? success,
    Color? warning,
    Duration? instant,
    Duration? fast,
    Duration? compiling,
    Duration? systemLoad,
    Curve? standardCurve,
    Curve? enterCurve,
    Curve? exitCurve,
  }) {
    return FiftyThemeExtension(
      accent: accent ?? this.accent,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
      shadowPrimary: shadowPrimary ?? this.shadowPrimary,
      shadowGlow: shadowGlow ?? this.shadowGlow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      instant: instant ?? this.instant,
      fast: fast ?? this.fast,
      compiling: compiling ?? this.compiling,
      systemLoad: systemLoad ?? this.systemLoad,
      standardCurve: standardCurve ?? this.standardCurve,
      enterCurve: enterCurve ?? this.enterCurve,
      exitCurve: exitCurve ?? this.exitCurve,
    );
  }

  @override
  FiftyThemeExtension lerp(FiftyThemeExtension? other, double t) {
    if (other == null) return this;

    return FiftyThemeExtension(
      accent: Color.lerp(accent, other.accent, t)!,
      shadowSm: t < 0.5 ? shadowSm : other.shadowSm,
      shadowMd: t < 0.5 ? shadowMd : other.shadowMd,
      shadowLg: t < 0.5 ? shadowLg : other.shadowLg,
      shadowPrimary: t < 0.5 ? shadowPrimary : other.shadowPrimary,
      shadowGlow: t < 0.5 ? shadowGlow : other.shadowGlow,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      instant: t < 0.5 ? instant : other.instant,
      fast: t < 0.5 ? fast : other.fast,
      compiling: t < 0.5 ? compiling : other.compiling,
      systemLoad: t < 0.5 ? systemLoad : other.systemLoad,
      standardCurve: t < 0.5 ? standardCurve : other.standardCurve,
      enterCurve: t < 0.5 ? enterCurve : other.enterCurve,
      exitCurve: t < 0.5 ? exitCurve : other.exitCurve,
    );
  }
}
