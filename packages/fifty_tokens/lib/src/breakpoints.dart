import 'package:meta/meta.dart';

import 'config/breakpoints_config.dart';

/// Fifty.dev breakpoint tokens - responsive design.
///
/// Defines breakpoint widths for responsive layouts following the
/// Fifty Design Language (FDL).
///
/// Breakpoints determine when layouts should adapt to different screen sizes.
/// Use with MediaQuery to detect screen width and apply appropriate styling.
///
/// **Gutter values** are defined in FiftySpacing (gutterMobile, gutterTablet,
/// gutterDesktop) and should be used in conjunction with these breakpoints.
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftyBreakpointsConfig].
class FiftyBreakpoints {
  FiftyBreakpoints._(); // Private constructor - static class

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyBreakpointsConfig? config;

  // ============================================================================
  // BREAKPOINT WIDTHS
  // ============================================================================

  static const double _defaultMobile = 768;
  static const double _defaultTablet = 768;
  static const double _defaultDesktop = 1024;

  /// Mobile breakpoint (768px) - Small screen threshold.
  ///
  /// Screens **below** this width are considered mobile.
  /// - Mobile: < 768px (use gutterMobile: 12px)
  ///
  /// Use for:
  /// - Phone layouts
  /// - Compact UI
  /// - Single-column layouts
  /// - Maximum content density
  static double get mobile => config?.mobile ?? _defaultMobile;

  /// Tablet breakpoint (768px) - Medium screen threshold.
  ///
  /// Screens **at or above** this width (and below desktop) are tablets.
  /// - Tablet: >= 768px and < 1024px (use gutterTablet: 16px)
  ///
  /// Use for:
  /// - Tablet layouts
  /// - Two-column layouts
  /// - Medium-density UI
  /// - Balanced spacing
  static double get tablet => config?.tablet ?? _defaultTablet;

  /// Desktop breakpoint (1024px) - Large screen threshold.
  ///
  /// Screens **at or above** this width are considered desktop.
  /// - Desktop: >= 1024px (use gutterDesktop: 24px)
  ///
  /// Use for:
  /// - Desktop layouts
  /// - Multi-column layouts
  /// - Generous spacing
  /// - Maximum readability
  static double get desktop => config?.desktop ?? _defaultDesktop;
}
