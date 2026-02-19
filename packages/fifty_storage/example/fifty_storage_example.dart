// ignore_for_file: avoid_print

import 'package:fifty_storage/fifty_storage.dart';

/// Example demonstrating fifty_storage usage.
///
/// Note: This example shows the API surface. In a real Flutter app,
/// call these methods after `WidgetsFlutterBinding.ensureInitialized()`.
void main() async {
  // ===========================================================================
  // FIFTY STORAGE EXAMPLE
  // Demonstrating secure token storage and preferences management
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Optional: Configure container name before initialization
  // ---------------------------------------------------------------------------

  PreferencesStorage.configure(containerName: 'my_app');

  // ---------------------------------------------------------------------------
  // Initialize all storage backends
  // ---------------------------------------------------------------------------

  // In a real app, call after WidgetsFlutterBinding.ensureInitialized()
  // await AppStorageService.instance.initialize();

  // ---------------------------------------------------------------------------
  // Preferences (lightweight, synchronous after init)
  // ---------------------------------------------------------------------------

  // Theme mode
  // AppStorageService.instance.themeMode = 'dark';
  // print('Theme: ${AppStorageService.instance.themeMode}');

  // Language code
  // AppStorageService.instance.languageCode = 'en';
  // print('Language: ${AppStorageService.instance.languageCode}');

  // ---------------------------------------------------------------------------
  // Secure Token Storage (platform keychain/keystore)
  // ---------------------------------------------------------------------------

  // Store tokens securely
  // await AppStorageService.instance.setAccessToken('eyJhbGci...');
  // await AppStorageService.instance.setRefreshToken('dGhpcyBp...');

  // Read tokens (synchronous after init, cached in memory)
  // final accessToken = AppStorageService.instance.accessToken;
  // final refreshToken = AppStorageService.instance.refreshToken;
  // print('Access token: ${accessToken != null ? "present" : "absent"}');

  // ---------------------------------------------------------------------------
  // Clear storage
  // ---------------------------------------------------------------------------

  // Clear preferences only
  // await PreferencesStorage.instance.clearAll();

  // Clear secure tokens
  // await SecureTokenStorage.instance.deleteAll();

  // ---------------------------------------------------------------------------
  // API Overview
  // ---------------------------------------------------------------------------

  print('fifty_storage API:');
  print('  AppStorageService — Unified facade for all storage');
  print('  SecureTokenStorage — Platform keychain/keystore tokens');
  print('  PreferencesStorage — Lightweight key-value preferences');
  print('  TokenStorage — Abstract contract for custom implementations');
}
