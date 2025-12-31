# fifty_arch

MVVM + Actions architecture framework for Flutter applications.

Part of the [Fifty Ecosystem](https://github.com/fiftynotai/fifty_eco_system) - a comprehensive Flutter toolkit.

---

## Overview

`fifty_arch` provides a complete architecture foundation for building scalable Flutter applications using the **MVVM + Actions** pattern. Originally based on [KalvadTech's flutter-mvvm-actions-arch](https://github.com/KalvadTech/flutter-mvvm-actions-arch).

### Architecture Pattern

```
View -> Actions -> ViewModel -> Service -> Model
```

| Layer | Responsibility |
|-------|----------------|
| **View** | UI widgets, user input |
| **Actions** | UX orchestration (loading, errors, navigation) |
| **ViewModel** | Business logic, state management |
| **Service** | Data layer, API calls |
| **Model** | Domain objects, DTOs |

---

## Features

### Core Architecture
- **GetX Integration** - Reactive state management
- **ApiResponse<T>** - Type-safe API response handling
- **ActionPresenter** - Standardized action handling with loading/error states
- **RouteManager** - Centralized routing

### Pre-built Modules
- **Auth** - Authentication with token refresh and secure storage
- **Connections** - Real-time connectivity monitoring (uses [fifty_connectivity](../fifty_connectivity))
- **Locale** - Multi-language support with dynamic switching
- **Theme** - Light/dark theme management
- **Menu** - Navigation drawer and bottom navigation

### Infrastructure
- **HTTP Client** - API service with caching strategies
- **Storage** - Uses [fifty_storage](../fifty_storage) for secure tokens and preferences
- **Caching** - Uses [fifty_cache](../fifty_cache) for TTL-based HTTP response caching
- **Connectivity** - Uses [fifty_connectivity](../fifty_connectivity) for network monitoring

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_arch:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_arch
```

---

## Project Structure

```
lib/src/
|-- config/              # App configuration
|   |-- api_config.dart  # API endpoints
|   |-- colors.dart      # Color definitions
|   |-- styles.dart      # Text styles
|   +-- themes.dart      # Theme data
|
|-- core/                # Architecture core
|   |-- bindings/        # Dependency injection
|   |-- errors/          # Exception handling
|   |-- presentation/    # Actions & ApiResponse
|   +-- routing/         # Route management
|
|-- infrastructure/      # Technical services
|   |-- cache/           # Caching system (uses fifty_cache)
|   |-- http/            # API client
|   +-- storage/         # Storage services (uses fifty_storage)
|
|-- modules/             # Feature modules
|   |-- auth/            # Authentication
|   |-- connections/     # Connectivity (re-exports fifty_connectivity)
|   |-- locale/          # Internationalization
|   |-- menu/            # Navigation
|   |-- posts/           # Example module
|   +-- theme/           # Theme management
|
|-- presentation/        # Shared widgets
|   |-- custom/          # Custom components
|   +-- widgets/         # Common widgets
|
+-- utils/               # Utilities
    |-- form_validators.dart
    |-- date_time_extensions.dart
    +-- responsive_utils.dart
```

---

## Quick Start

### 1. Initialize App

```dart
import 'package:fifty_storage/fifty_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure storage with your app name
  PreferencesStorage.configure(containerName: 'my_app');

  // Initialize storage (preferences + secure tokens)
  await AppStorageService.instance.initialize();

  runApp(const App());
}
```

### 2. Create a Module

**ViewModel:**
```dart
class PostViewModel extends GetxController {
  final PostService _service;

  final posts = <PostModel>[].obs;
  final isLoading = false.obs;

  PostViewModel(this._service);

  Future<ApiResponse<List<PostModel>>> fetchPosts() async {
    isLoading.value = true;
    final response = await _service.getPosts();
    if (response.isSuccess) {
      posts.value = response.data!;
    }
    isLoading.value = false;
    return response;
  }
}
```

**Actions:**
```dart
class PostActions {
  final PostViewModel _viewModel;

  PostActions(this._viewModel);

  Future<void> loadPosts(BuildContext context) async {
    await actionHandler(
      context: context,
      action: () => _viewModel.fetchPosts(),
      onSuccess: (_) => print('Posts loaded'),
      onError: (e) => print('Error: $e'),
    );
  }
}
```

**View:**
```dart
class PostsPage extends GetView<PostViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (_, i) => PostListTile(post: controller.posts[i]),
        );
      }),
    );
  }
}
```

---

## ApiResponse Pattern

Type-safe wrapper for API responses:

```dart
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}
```

**Usage in Service:**
```dart
Future<ApiResponse<User>> getUser(String id) async {
  try {
    final response = await _client.get('/users/$id');
    return ApiResponse.success(User.fromJson(response.data));
  } catch (e) {
    return ApiResponse.error(e.toString());
  }
}
```

---

## Modules

### Authentication

```dart
// Check auth status
final authVM = Get.find<AuthViewModel>();
if (authVM.isLoggedIn) {
  // User is authenticated
}

// Login
await authActions.login(email, password);

// Logout
await authActions.logout();
```

### Connectivity

The connectivity module now uses [fifty_connectivity](../fifty_connectivity) and re-exports its APIs for backwards compatibility:

```dart
// Monitor connection
final connVM = Get.find<ConnectionViewModel>();
Obx(() => Text(connVM.isOnline.value ? 'Online' : 'Offline'));

// Use ConnectionOverlay for automatic UI feedback
ConnectionOverlay(
  child: YourContent(),
);
```

### Localization

```dart
// Change language
final localeVM = Get.find<LocalizationViewModel>();
localeVM.changeLanguage('ar');

// Use translations
Text(LocaleKeys.welcomeMessage.tr);
```

### Theme

```dart
// Toggle theme
final themeVM = Get.find<ThemeViewModel>();
themeVM.toggleTheme();

// Check current mode
if (themeVM.isDarkMode) {
  // Dark mode active
}
```

---

## Fifty Ecosystem Integration

`fifty_arch` integrates with other Fifty packages:

```yaml
dependencies:
  fifty_arch:
    path: ../fifty_arch
  fifty_tokens:
    path: ../fifty_tokens
  fifty_theme:
    path: ../fifty_theme
  fifty_ui:
    path: ../fifty_ui
  fifty_cache:
    path: ../fifty_cache
  fifty_storage:
    path: ../fifty_storage
  fifty_connectivity:
    path: ../fifty_connectivity
```

Use `fifty_theme` for theming:
```dart
// In theme module, replace custom themes with:
import 'package:fifty_theme/fifty_theme.dart';

ThemeData get darkTheme => FiftyTheme.dark();
ThemeData get lightTheme => FiftyTheme.light();
```

Use `fifty_storage` for secure storage:
```dart
import 'package:fifty_storage/fifty_storage.dart';

// Access tokens
final token = AppStorageService.instance.accessToken;
await AppStorageService.instance.setAccessToken('jwt_token');

// Preferences
AppStorageService.instance.themeMode = 'dark';
AppStorageService.instance.languageCode = 'en';
```

Use `fifty_cache` for HTTP caching:
```dart
import 'package:fifty_cache/fifty_cache.dart';

// Try cache before network
final cached = await cacheManager.tryRead('GET', url, query);
if (cached != null) {
  // Use cached response
}
```

Use `fifty_connectivity` for network monitoring:
```dart
import 'package:fifty_connectivity/fifty_connectivity.dart';

// Configure connectivity
ConnectivityConfig.initialize(
  dnsLookupHost: 'google.com',
  httpCheckUrl: 'https://www.google.com',
);

// Get connection state
final connVM = Get.find<ConnectionViewModel>();
if (connVM.isOnline.value) {
  // Proceed with network request
}
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| get | State management |
| loader_overlay | Loading overlays |
| fifty_storage | Secure tokens and preferences |
| fifty_cache | HTTP response caching |
| fifty_connectivity | Network connectivity monitoring |
| jwt_decoder | Token handling |

---

## Credits

Based on [flutter-mvvm-actions-arch](https://github.com/KalvadTech/flutter-mvvm-actions-arch) by KalvadTech.

Rebranded and integrated into the Fifty Ecosystem by [Fifty.ai](https://fifty.dev).

---

## License

MIT License - See LICENSE file for details.

---

## Ecosystem

| Package | Description |
|---------|-------------|
| [fifty_tokens](../fifty_tokens) | Design tokens |
| [fifty_theme](../fifty_theme) | Theme system |
| [fifty_ui](../fifty_ui) | UI components |
| [fifty_cache](../fifty_cache) | HTTP caching |
| [fifty_storage](../fifty_storage) | Secure storage |
| [fifty_connectivity](../fifty_connectivity) | Network monitoring |
| [fifty_utils](../fifty_utils) | Pure utilities |
| [fifty_audio_engine](../fifty_audio_engine) | Audio management |
| [fifty_speech_engine](../fifty_speech_engine) | TTS/STT |
| [fifty_sentences_engine](../fifty_sentences_engine) | Dialogue system |
| [fifty_map_engine](../fifty_map_engine) | Map rendering |
| **fifty_arch** | Architecture framework (this package) |
