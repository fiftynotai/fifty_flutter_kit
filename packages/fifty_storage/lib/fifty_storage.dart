/// Secure token storage and preferences management for Flutter apps.
///
/// This library provides:
/// - [TokenStorage] - Abstract contract for secure credential storage
/// - [SecureTokenStorage] - Implementation using flutter_secure_storage
/// - [PreferencesStorage] - Lightweight preferences using get_storage
/// - [AppStorageService] - Unified facade combining both storage types
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_storage/fifty_storage.dart';
///
/// // Configure container name (optional, call before initialize)
/// PreferencesStorage.configure(containerName: 'my_app');
///
/// // Initialize all storage
/// await AppStorageService.instance.initialize();
///
/// // Use preferences
/// AppStorageService.instance.languageCode = 'en';
/// AppStorageService.instance.themeMode = 'dark';
///
/// // Use secure token storage
/// await AppStorageService.instance.setAccessToken('jwt_token');
/// final token = AppStorageService.instance.accessToken;
/// ```
// ignore_for_file: unnecessary_library_name
library fifty_storage;

export 'src/contracts/token_storage.dart';
export 'src/secure_token_storage.dart';
export 'src/preferences_storage.dart';
export 'src/app_storage_service.dart';
