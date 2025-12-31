# fifty_storage

Secure token storage and preferences management for Flutter apps.

Part of the [Fifty Ecosystem](https://github.com/fiftynotai/fifty_eco_system) - a comprehensive Flutter toolkit.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Components](#components)
  - [TokenStorage (Contract)](#tokenstorage-contract)
  - [SecureTokenStorage](#securetokenstorage)
  - [PreferencesStorage](#preferencesstorage)
  - [AppStorageService](#appstorageservice)
- [Configuration](#configuration)
- [Testing](#testing)
- [API Reference](#api-reference)
- [Best Practices](#best-practices)
- [License](#license)
- [Ecosystem](#ecosystem)

---

## Overview

`fifty_storage` provides a unified storage solution for Flutter apps, combining:
- **Secure token storage** for authentication credentials (via `flutter_secure_storage`)
- **Preferences storage** for app settings (via `get_storage`)

Originally extracted from `fifty_arch` to enable standalone use.

### Why fifty_storage?

- **Contract-based design** - Swap implementations for testing
- **Platform secure storage** - Tokens stored in Keychain (iOS) / Keystore (Android)
- **Synchronous reads** - In-memory caching for fast access after initialization
- **Unified facade** - One entry point for all storage operations
- **Configurable** - Container names can be customized per app

---

## Features

- **TokenStorage contract** - Abstract interface for secure credential storage
- **SecureTokenStorage** - Platform-native secure storage implementation
- **PreferencesStorage** - Lightweight key-value storage for settings
- **AppStorageService** - Unified facade combining both storage types
- **Configurable container** - Avoid conflicts between apps using the same package
- **Testable** - Mock-friendly architecture with clear contracts

---

## Installation

### Path Dependency (Monorepo)

For projects within the Fifty ecosystem:

```yaml
dependencies:
  fifty_storage:
    path: ../fifty_storage
```

### Git Dependency

For external projects:

```yaml
dependencies:
  fifty_storage:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_storage
```

### Pub.dev (Future)

```yaml
dependencies:
  fifty_storage: ^0.1.0
```

---

## Quick Start

```dart
import 'package:fifty_storage/fifty_storage.dart';

void main() async {
  // Optional: Configure container name before initialization
  PreferencesStorage.configure(containerName: 'my_app');

  // Initialize all storage (preferences + secure tokens)
  await AppStorageService.instance.initialize();

  // Use preferences
  AppStorageService.instance.themeMode = 'dark';
  AppStorageService.instance.languageCode = 'en';

  // Use secure token storage
  await AppStorageService.instance.setAccessToken('jwt_access_token');
  await AppStorageService.instance.setRefreshToken('jwt_refresh_token');

  // Read tokens synchronously (from cache)
  final accessToken = AppStorageService.instance.accessToken;
  final refreshToken = AppStorageService.instance.refreshToken;

  // Clear on logout
  await AppStorageService.instance.clearTokens();
  await AppStorageService.instance.clearAllPreferences();
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     AppStorageService                            │
│           Unified facade for all storage operations              │
└─────────────────────────────────────────────────────────────────┘
                    │                         │
                    ▼                         ▼
┌───────────────────────────────┐  ┌───────────────────────────────┐
│      PreferencesStorage       │  │     SecureTokenStorage        │
│         (get_storage)         │  │   (flutter_secure_storage)    │
│                               │  │                               │
│ - Theme mode                  │  │ - Access token                │
│ - Language code               │  │ - Refresh token               │
│ - User ID                     │  │ - In-memory cache             │
└───────────────────────────────┘  └───────────────────────────────┘
                                              │
                                              ▼
                                   ┌───────────────────────────────┐
                                   │     TokenStorage (Contract)   │
                                   │                               │
                                   │ - initialize()                │
                                   │ - readAccessTokenSync         │
                                   │ - readRefreshTokenSync        │
                                   │ - writeAccessToken()          │
                                   │ - writeRefreshToken()         │
                                   │ - clearTokens()               │
                                   └───────────────────────────────┘
```

---

## Components

### TokenStorage (Contract)

Abstract interface for secure credential storage. Implement this to create custom token storage backends.

```dart
abstract class TokenStorage {
  /// Prepare storage for use (hydrate caches)
  Future<void> initialize();

  /// Synchronous access token read (from cache)
  String? get readAccessTokenSync;

  /// Synchronous refresh token read (from cache)
  String? get readRefreshTokenSync;

  /// Persist access token (null/empty to delete)
  Future<void> writeAccessToken(String? value);

  /// Persist refresh token (null/empty to delete)
  Future<void> writeRefreshToken(String? value);

  /// Clear both tokens atomically
  Future<void> clearTokens();
}
```

**Use cases:**
- Custom storage backends (e.g., encrypted SQLite)
- Testing with mock implementations
- Platform-specific implementations

### SecureTokenStorage

Platform-native secure storage implementation using `flutter_secure_storage`.

```dart
// Access singleton instance
final storage = SecureTokenStorage.instance;

// Initialize (hydrates in-memory cache)
await storage.initialize();

// Write tokens
await storage.writeAccessToken('eyJhbGciOiJIUzI1NiIs...');
await storage.writeRefreshToken('eyJhbGciOiJIUzI1NiIs...');

// Read tokens synchronously (from cache)
final access = storage.readAccessTokenSync;
final refresh = storage.readRefreshTokenSync;

// Clear tokens
await storage.clearTokens();
```

**Platform storage:**
- iOS: Keychain
- Android: Android Keystore (EncryptedSharedPreferences)
- macOS: Keychain
- Linux: libsecret
- Windows: Windows Credentials

### PreferencesStorage

Lightweight preferences storage using `get_storage`.

```dart
// Configure container name (optional, before initialize)
PreferencesStorage.configure(containerName: 'my_app_prefs');

// Access singleton instance
final prefs = PreferencesStorage.instance;

// Initialize
await prefs.initialize();

// Theme mode
prefs.themeMode = 'dark';  // 'light', 'dark', 'system'
final theme = prefs.themeMode;

// Language code
prefs.languageCode = 'en';  // ISO 639-1
final lang = prefs.languageCode;

// User ID
prefs.userId = 'user_123';
final uid = prefs.userId;

// Clear all preferences
await prefs.clearAll();
```

**Built-in preferences:**
- `themeMode` - App theme preference
- `languageCode` - App language preference
- `userId` - Current user identifier

### AppStorageService

Unified facade that combines preferences and secure token storage.

```dart
// Configure before initialization
PreferencesStorage.configure(containerName: 'my_app');

// Access singleton instance
final storage = AppStorageService.instance;

// Initialize both storage types
await storage.initialize();

// Preferences
storage.themeMode = 'dark';
storage.languageCode = 'en';
storage.userId = 'user_123';

// Tokens
await storage.setAccessToken('jwt_access');
await storage.setRefreshToken('jwt_refresh');
final access = storage.accessToken;
final refresh = storage.refreshToken;

// Container name
final container = AppStorageService.containerName;

// Clear operations
await storage.clearTokens();           // Clear secure tokens only
await storage.clearAllPreferences();   // Clear preferences only
```

---

## Configuration

### Container Name

Configure the GetStorage container name before initialization to avoid conflicts:

```dart
// In your app initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure storage with your app's unique name
  PreferencesStorage.configure(containerName: 'my_app_storage');

  // Initialize
  await AppStorageService.instance.initialize();

  runApp(MyApp());
}
```

**Why configure?**
- Multiple apps using `fifty_storage` won't conflict
- Separates dev/staging/prod storage if needed
- Clear app boundaries in shared device scenarios

---

## Testing

The package is designed for easy testing with mocks:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fifty_storage/fifty_storage.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage mockSecure;

  setUp(() {
    mockSecure = MockSecureStorage();
  });

  test('token storage initializes from secure storage', () async {
    // Arrange
    when(() => mockSecure.read(key: 'accessToken'))
        .thenAnswer((_) async => 'stored_token');
    when(() => mockSecure.read(key: 'refreshToken'))
        .thenAnswer((_) async => null);

    // Create testable storage with mock
    // (See test files for full testable wrapper implementation)
  });
}
```

### Running Tests

```bash
cd packages/fifty_storage
flutter test
```

---

## API Reference

### TokenStorage

| Member | Type | Description |
|--------|------|-------------|
| `initialize()` | `Future<void>` | Prepare storage for use |
| `readAccessTokenSync` | `String?` | Cached access token |
| `readRefreshTokenSync` | `String?` | Cached refresh token |
| `writeAccessToken(value)` | `Future<void>` | Persist access token |
| `writeRefreshToken(value)` | `Future<void>` | Persist refresh token |
| `clearTokens()` | `Future<void>` | Clear both tokens |

### SecureTokenStorage

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `SecureTokenStorage` | Singleton instance |
| All `TokenStorage` members | - | Inherited from contract |

### PreferencesStorage

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `PreferencesStorage` | Singleton instance |
| `containerName` | `String` | Current container name |
| `configure(containerName:)` | `void` | Set container name |
| `initialize()` | `Future<void>` | Initialize GetStorage |
| `themeMode` | `String?` | Theme preference |
| `languageCode` | `String?` | Language preference |
| `userId` | `String?` | User identifier |
| `clearAll()` | `Future<void>` | Erase all preferences |

### AppStorageService

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `AppStorageService` | Singleton instance |
| `containerName` | `String` | Container name |
| `initialize()` | `Future<void>` | Initialize both storages |
| `themeMode` | `String?` | Theme preference |
| `languageCode` | `String?` | Language preference |
| `userId` | `String?` | User identifier |
| `accessToken` | `String?` | Access token (cached) |
| `refreshToken` | `String?` | Refresh token (cached) |
| `setAccessToken(value)` | `Future<void>` | Set access token |
| `setRefreshToken(value)` | `Future<void>` | Set refresh token |
| `clearTokens()` | `Future<void>` | Clear secure tokens |
| `clearAllPreferences()` | `Future<void>` | Clear preferences |

---

## Best Practices

### 1. Initialize Early

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure and initialize before runApp
  PreferencesStorage.configure(containerName: 'my_app');
  await AppStorageService.instance.initialize();

  runApp(MyApp());
}
```

### 2. Use Synchronous Reads for Performance

```dart
// Good: Use cached value in hot paths
String? getAuthHeader() {
  final token = AppStorageService.instance.accessToken;
  return token != null ? 'Bearer $token' : null;
}

// Avoid: Unnecessary async operations
Future<String?> getAuthHeaderSlow() async {
  // This pattern adds unnecessary latency
  return AppStorageService.instance.accessToken;
}
```

### 3. Clear Tokens on Logout

```dart
Future<void> logout() async {
  // Clear authentication tokens
  await AppStorageService.instance.clearTokens();

  // Optionally clear user preferences
  // await AppStorageService.instance.clearAllPreferences();

  // Navigate to login
  Get.offAllNamed('/login');
}
```

### 4. Handle Token Refresh

```dart
Future<void> refreshTokens() async {
  final refreshToken = AppStorageService.instance.refreshToken;
  if (refreshToken == null) {
    // No refresh token - force login
    return;
  }

  final response = await api.refreshAuth(refreshToken);
  if (response.isSuccess) {
    await AppStorageService.instance.setAccessToken(response.accessToken);
    await AppStorageService.instance.setRefreshToken(response.refreshToken);
  } else {
    // Refresh failed - clear tokens and force login
    await AppStorageService.instance.clearTokens();
  }
}
```

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Ecosystem

| Package | Description |
|---------|-------------|
| [fifty_tokens](../fifty_tokens) | Design tokens |
| [fifty_theme](../fifty_theme) | Theme system |
| [fifty_ui](../fifty_ui) | UI components |
| [mvvm_actions](../../templates/mvvm_actions) | Architecture template |
| [fifty_cache](../fifty_cache) | HTTP caching |
| **fifty_storage** | Secure storage (this package) |
| [fifty_audio_engine](../fifty_audio_engine) | Audio management |
| [fifty_speech_engine](../fifty_speech_engine) | TTS/STT |
| [fifty_sentences_engine](../fifty_sentences_engine) | Dialogue system |
| [fifty_map_engine](../fifty_map_engine) | Map rendering |
