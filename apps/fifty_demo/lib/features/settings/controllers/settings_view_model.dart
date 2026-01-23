/// Settings ViewModel
///
/// Business logic for the settings feature.
/// Manages app preferences and configuration.
library;

import 'package:get/get.dart';

/// Theme mode options for the app.
enum AppThemeMode {
  /// Dark mode (default FDL theme).
  dark,

  /// Light mode.
  light,

  /// Follow system preference.
  system,
}

/// ViewModel for the settings feature.
///
/// Manages theme selection, app info, and user preferences.
class SettingsViewModel extends GetxController {
  // ---------------------------------------------------------------------------
  // Theme Settings
  // ---------------------------------------------------------------------------

  /// Current theme mode.
  final Rx<AppThemeMode> _themeMode = AppThemeMode.dark.obs;

  /// Gets the current theme mode.
  AppThemeMode get themeMode => _themeMode.value;

  /// Sets the theme mode.
  set themeMode(AppThemeMode mode) {
    _themeMode.value = mode;
    update();
  }

  // ---------------------------------------------------------------------------
  // App Information
  // ---------------------------------------------------------------------------

  /// App name.
  static const String appName = 'Fifty Demo';

  /// App version.
  static const String appVersion = '1.0.0';

  /// Build number.
  static const String buildNumber = '1';

  /// Architecture pattern used.
  static const String architecture = 'MVVM + Actions';

  /// Design system name.
  static const String designSystem = 'Fifty Design Language v2';

  /// Framework version (Flutter).
  static const String frameworkVersion = 'Flutter 3.24+';

  /// State management solution.
  static const String stateManagement = 'GetX';

  // ---------------------------------------------------------------------------
  // About Information
  // ---------------------------------------------------------------------------

  /// Copyright notice.
  static const String copyright = '2025 Fifty.ai';

  /// License type.
  static const String license = 'MIT License';

  /// Repository URL.
  static const String repositoryUrl =
      'https://github.com/fiftynotai/fifty_eco_system';

  /// Documentation URL.
  static const String docsUrl = 'https://fifty.ai/docs';

  // ---------------------------------------------------------------------------
  // Feature Flags (placeholder for future)
  // ---------------------------------------------------------------------------

  /// Whether debug mode is enabled.
  final RxBool _debugMode = false.obs;

  /// Gets debug mode status.
  bool get debugMode => _debugMode.value;

  /// Toggles debug mode.
  void toggleDebugMode() {
    _debugMode.value = !_debugMode.value;
    update();
  }
}
