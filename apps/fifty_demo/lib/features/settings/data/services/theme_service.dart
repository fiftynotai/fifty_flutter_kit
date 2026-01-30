/// Theme Service
///
/// Service responsible for persisting and retrieving user theme preferences.
/// Uses fifty_storage for lightweight key-value storage.
library;

import 'package:fifty_storage/fifty_storage.dart';

/// Service for theme persistence operations.
///
/// Decouples theme storage logic from ViewModels.
/// Uses [PreferencesStorage] for lightweight key-value storage.
class ThemeService {
  /// Retrieves the saved theme mode from storage.
  ///
  /// Returns the saved theme mode string or null if not set.
  String? getSavedThemeMode() {
    try {
      return PreferencesStorage.instance.themeMode;
    } catch (e) {
      // Storage read failed, return null to use fallback
      return null;
    }
  }

  /// Persists the theme mode to storage.
  ///
  /// [themeMode] - Theme mode string to save (e.g., 'ThemeMode.dark').
  void saveThemeMode(String themeMode) {
    try {
      PreferencesStorage.instance.themeMode = themeMode;
    } catch (e) {
      // Storage write failed, but theme is already updated in memory
    }
  }
}
