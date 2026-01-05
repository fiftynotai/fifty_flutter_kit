/// App Navigation
///
/// Centralized navigation constants and helpers for the demo app.
library;

/// Route constants for the demo app.
abstract class AppRoutes {
  /// Home page route.
  static const String home = '/';

  /// Map demo feature route.
  static const String mapDemo = '/map-demo';

  /// Dialogue demo feature route.
  static const String dialogueDemo = '/dialogue-demo';

  /// UI showcase feature route.
  static const String uiShowcase = '/ui-showcase';
}

/// Navigation feature indices for the bottom nav.
abstract class NavIndex {
  /// Home tab index.
  static const int home = 0;

  /// Map demo tab index.
  static const int mapDemo = 1;

  /// Dialogue demo tab index.
  static const int dialogueDemo = 2;

  /// UI showcase tab index.
  static const int uiShowcase = 3;
}
