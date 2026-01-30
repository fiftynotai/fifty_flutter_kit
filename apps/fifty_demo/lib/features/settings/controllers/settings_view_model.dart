/// Settings ViewModel
///
/// Business logic for the settings feature.
/// Manages app preferences, theme mode, and configuration.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/theme_service.dart';

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
/// Persists theme preference via [ThemeService] and applies
/// changes using [Get.changeThemeMode].
class SettingsViewModel extends GetxController {
  /// Theme persistence service.
  final ThemeService _themeService;

  /// Creates a SettingsViewModel with the given [ThemeService].
  SettingsViewModel(this._themeService);

  // ---------------------------------------------------------------------------
  // Theme Settings
  // ---------------------------------------------------------------------------

  /// Current theme mode.
  final Rx<AppThemeMode> _themeMode = AppThemeMode.dark.obs;

  /// Gets the current theme mode.
  AppThemeMode get themeMode => _themeMode.value;

  /// Sets the theme mode, applies it, and persists.
  set themeMode(AppThemeMode mode) {
    _themeMode.value = mode;
    _applyTheme(mode);
    _persistTheme(mode);
  }

  @override
  void onInit() {
    super.onInit();
    _initializeTheme();
  }

  /// Initializes theme from persisted storage.
  void _initializeTheme() {
    final savedMode = _themeService.getSavedThemeMode();
    if (savedMode != null) {
      final mode = _parseThemeMode(savedMode);
      _themeMode.value = mode;
      _applyTheme(mode);
    }
  }

  /// Applies the theme mode to the app.
  void _applyTheme(AppThemeMode mode) {
    final flutterMode = _toFlutterThemeMode(mode);
    if (!Get.testMode) {
      try {
        Get.changeThemeMode(flutterMode);
      } catch (e) {
        // Theme change may fail in test environments
      }
    }
  }

  /// Persists the theme mode to storage.
  void _persistTheme(AppThemeMode mode) {
    final flutterMode = _toFlutterThemeMode(mode);
    _themeService.saveThemeMode(flutterMode.toString());
  }

  /// Converts [AppThemeMode] to Flutter's [ThemeMode].
  ThemeMode _toFlutterThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Parses a saved theme mode string to [AppThemeMode].
  AppThemeMode _parseThemeMode(String saved) {
    if (saved == ThemeMode.light.toString()) {
      return AppThemeMode.light;
    } else if (saved == ThemeMode.system.toString()) {
      return AppThemeMode.system;
    }
    return AppThemeMode.dark;
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
