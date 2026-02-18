# Fifty Storage

Secure token storage and preferences management for Flutter apps. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Features

- **TokenStorage contract** - Abstract interface for secure credential storage, enabling custom backends and easy testing
- **SecureTokenStorage** - Platform-native secure storage implementation backed by `flutter_secure_storage`
- **PreferencesStorage** - Lightweight key-value storage for app settings backed by `get_storage`
- **AppStorageService** - Unified facade combining both storage types behind a single entry point
- **Configurable container** - Per-app container names prevent conflicts between multiple apps using the package
- **Synchronous reads** - In-memory caching after initialization enables fast, synchronous token access in hot paths

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_storage:
    path: ../fifty_storage
```

For external projects using a git dependency:

```yaml
dependencies:
  fifty_storage:
    git:
      url: https://github.com/fiftynotai/fifty_flutter_kit.git
      path: packages/fifty_storage
```

---

## Quick Start

```dart
import 'package:fifty_storage/fifty_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: configure container name before initialization
  PreferencesStorage.configure(containerName: 'my_app');

  // Initialize both preferences and secure token storage
  await AppStorageService.instance.initialize();

  // Set preferences
  AppStorageService.instance.themeMode = 'dark';
  AppStorageService.instance.languageCode = 'en';

  // Set tokens (async — writes to secure storage)
  await AppStorageService.instance.setAccessToken('jwt_access_token');
  await AppStorageService.instance.setRefreshToken('jwt_refresh_token');

  // Read tokens synchronously (from in-memory cache)
  final token = AppStorageService.instance.accessToken;

  runApp(MyApp());
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

### Core Components

| Component | Description |
|-----------|-------------|
| `TokenStorage` | Abstract contract for secure credential storage; implement to create custom backends |
| `SecureTokenStorage` | Singleton implementation backed by platform-native secure storage with in-memory caching |
| `PreferencesStorage` | Singleton wrapper around `get_storage` for lightweight app preferences |
| `AppStorageService` | Unified facade exposing both preferences and token storage from a single access point |

---

## API Reference

### TokenStorage

```dart
abstract class TokenStorage {
  /// Prepare storage for use (hydrate in-memory caches).
  Future<void> initialize();

  /// Cached access token; available synchronously after initialize().
  String? get readAccessTokenSync;

  /// Cached refresh token; available synchronously after initialize().
  String? get readRefreshTokenSync;

  /// Persist access token. Pass null or empty to delete.
  Future<void> writeAccessToken(String? value);

  /// Persist refresh token. Pass null or empty to delete.
  Future<void> writeRefreshToken(String? value);

  /// Remove both tokens atomically.
  Future<void> clearTokens();
}
```

### SecureTokenStorage

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `SecureTokenStorage` | Singleton accessor |
| `initialize()` | `Future<void>` | Hydrates in-memory caches from secure storage |
| `readAccessTokenSync` | `String?` | Cached access token (synchronous) |
| `readRefreshTokenSync` | `String?` | Cached refresh token (synchronous) |
| `writeAccessToken(value)` | `Future<void>` | Persist or delete access token |
| `writeRefreshToken(value)` | `Future<void>` | Persist or delete refresh token |
| `clearTokens()` | `Future<void>` | Remove both tokens from storage and cache |

### PreferencesStorage

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `PreferencesStorage` | Singleton accessor |
| `containerName` | `String` | Current GetStorage container name |
| `configure(containerName:)` | `static void` | Set container name before `initialize()` |
| `initialize()` | `Future<void>` | Opens or creates the GetStorage container |
| `themeMode` | `String?` | Theme preference (`'light'`, `'dark'`, `'system'`) |
| `languageCode` | `String?` | ISO 639-1 language preference |
| `userId` | `String?` | Current user identifier |
| `clearAll()` | `Future<void>` | Erase all preferences in the container |

### AppStorageService

| Member | Type | Description |
|--------|------|-------------|
| `instance` | `AppStorageService` | Singleton accessor |
| `containerName` | `String` | Preferences container name |
| `initialize()` | `Future<void>` | Initialize both preferences and secure token storage |
| `themeMode` | `String?` | Theme preference (get/set) |
| `languageCode` | `String?` | Language preference (get/set) |
| `userId` | `String?` | User identifier (get/set) |
| `accessToken` | `String?` | Access token (synchronous, from cache) |
| `refreshToken` | `String?` | Refresh token (synchronous, from cache) |
| `setAccessToken(value)` | `Future<void>` | Persist or clear access token |
| `setRefreshToken(value)` | `Future<void>` | Persist or clear refresh token |
| `clearTokens()` | `Future<void>` | Remove both tokens from secure storage |
| `clearAllPreferences()` | `Future<void>` | Erase all preferences |

---

## Usage Patterns

### Initialize Early

Configure and initialize before `runApp` so all storage is ready before the widget tree builds.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PreferencesStorage.configure(containerName: 'my_app_storage');
  await AppStorageService.instance.initialize();

  runApp(MyApp());
}
```

### Synchronous Reads in Hot Paths

After initialization the access and refresh tokens are cached in memory, making synchronous reads safe and efficient.

```dart
String? getAuthHeader() {
  final token = AppStorageService.instance.accessToken;
  return token != null ? 'Bearer $token' : null;
}
```

### Clear Tokens on Logout

```dart
Future<void> logout() async {
  await AppStorageService.instance.clearTokens();

  // Optionally clear user preferences too
  // await AppStorageService.instance.clearAllPreferences();

  Get.offAllNamed('/login');
}
```

### Handle Token Refresh

```dart
Future<void> refreshTokens() async {
  final refreshToken = AppStorageService.instance.refreshToken;
  if (refreshToken == null) return; // No token — force login

  final response = await api.refreshAuth(refreshToken);
  if (response.isSuccess) {
    await AppStorageService.instance.setAccessToken(response.accessToken);
    await AppStorageService.instance.setRefreshToken(response.refreshToken);
  } else {
    await AppStorageService.instance.clearTokens();
  }
}
```

### Testing with Mocks

The `TokenStorage` contract makes it straightforward to substitute a mock implementation in tests.

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

  test('reads access token from secure storage on initialize', () async {
    when(() => mockSecure.read(key: 'accessToken'))
        .thenAnswer((_) async => 'stored_token');
    when(() => mockSecure.read(key: 'refreshToken'))
        .thenAnswer((_) async => null);

    // Pass mock to testable wrapper — see test files for full implementation
  });
}
```

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     | Tokens stored in Android Keystore (EncryptedSharedPreferences) |
| iOS      | Yes     | Tokens stored in Keychain |
| macOS    | Yes     | Tokens stored in Keychain |
| Linux    | Yes     | Tokens stored via libsecret |
| Windows  | Yes     | Tokens stored in Windows Credentials |
| Web      | No      | `flutter_secure_storage` does not support Web |

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **Storage foundation for FDL apps** - `AppStorageService` is the standard storage entry point used across Fifty Flutter Kit packages that require credential or preference persistence
- **Compatible with `fifty_arch`** - Originally extracted from `fifty_arch` to enable standalone use; integrates cleanly with the MVVM architecture pattern used throughout the kit

---

## Version

**Current:** 0.1.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
