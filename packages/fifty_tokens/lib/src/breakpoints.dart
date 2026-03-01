import 'config/fifty_tokens_config.dart';

/// Fifty.dev breakpoint tokens -- reads from the active [FiftyPreset].
///
/// Defines breakpoint widths for responsive layouts following the
/// Fifty Design Language (FDL).
///
/// Breakpoints determine when layouts should adapt to different screen sizes.
/// Use with MediaQuery to detect screen width and apply appropriate styling.
///
/// **Gutter values** are defined in FiftySpacing (gutterMobile, gutterTablet,
/// gutterDesktop) and should be used in conjunction with these breakpoints.
class FiftyBreakpoints {
  FiftyBreakpoints._(); // Private constructor - static class

  // ============================================================================
  // BREAKPOINT WIDTHS
  // ============================================================================

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
  static double get mobile => FiftyTokens.active.breakpoints.mobile;

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
  static double get tablet => FiftyTokens.active.breakpoints.tablet;

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
  static double get desktop => FiftyTokens.active.breakpoints.desktop;
}
