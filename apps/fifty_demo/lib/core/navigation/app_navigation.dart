/// App Navigation
///
/// Centralized navigation constants and helpers for the demo app.
library;

/// Route constants for the demo app.
abstract class AppRoutes {
  /// Home page route.
  static const String home = '/';

  /// Packages hub route.
  static const String packages = '/packages';

  /// UI showcase feature route.
  static const String uiShowcase = '/ui-showcase';

  /// Settings page route.
  static const String settings = '/settings';

  // ─────────────────────────────────────────────────────────────────────────
  // Legacy routes (accessible from Packages hub)
  // ─────────────────────────────────────────────────────────────────────────

  /// Map demo feature route.
  static const String mapDemo = '/map-demo';

  /// Dialogue demo feature route.
  static const String dialogueDemo = '/dialogue-demo';
}

/// Navigation feature indices for the bottom navigation bar.
abstract class NavIndex {
  /// Home tab index.
  static const int home = 0;

  /// Packages hub tab index.
  static const int packages = 1;

  /// UI showcase tab index.
  static const int uiKit = 2;

  /// Settings tab index.
  static const int settings = 3;

  // ─────────────────────────────────────────────────────────────────────────
  // Legacy indices (for backward compatibility)
  // ─────────────────────────────────────────────────────────────────────────

  /// @deprecated Use [packages] and navigate from hub.
  @Deprecated('Use packages and navigate from Packages hub')
  static const int mapDemo = -1;

  /// @deprecated Use [packages] and navigate from hub.
  @Deprecated('Use packages and navigate from Packages hub')
  static const int dialogueDemo = -1;

  /// @deprecated Use [uiKit] instead.
  @Deprecated('Use uiKit instead')
  static const int uiShowcase = 2;
}
