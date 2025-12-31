# mvvm_actions

**PROJECT TEMPLATE** - MVVM + Actions architecture scaffold for Flutter applications.

Part of the [Fifty Ecosystem](https://github.com/fiftynotai/fifty_eco_system) - a comprehensive Flutter toolkit.

---

## IMPORTANT: This is a Template

**This is a PROJECT TEMPLATE - fork/clone it, do NOT import it as a dependency.**

Unlike the packages in the `packages/` directory (which you add to your `pubspec.yaml`), this template is meant to be:

1. **Cloned/Forked** as the starting point for your new project
2. **Customized** with your app name, branding, and features
3. **NOT imported** as a package dependency

### How to Use This Template

```bash
# Option 1: Clone the ecosystem and copy the template
git clone https://github.com/fiftynotai/fifty_eco_system.git
cp -r fifty_eco_system/templates/mvvm_actions my_new_app
cd my_new_app

# Option 2: Use as a GitHub template (if available)
# Click "Use this template" on GitHub

# Then customize:
# 1. Rename package in pubspec.yaml
# 2. Update Android/iOS/Web identifiers
# 3. Replace assets and branding
# 4. Start building your features!
```

---

## Overview

`mvvm_actions` provides a complete architecture foundation for building scalable Flutter applications using the **MVVM + Actions** pattern. Originally based on [KalvadTech's flutter-mvvm-actions-arch](https://github.com/KalvadTech/flutter-mvvm-actions-arch).

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
- **Connections** - Real-time connectivity monitoring (uses [fifty_connectivity](../../packages/fifty_connectivity))
- **Locale** - Multi-language support with dynamic switching
- **Theme** - Light/dark theme management
- **Menu** - Navigation drawer and bottom navigation

### Infrastructure
- **HTTP Client** - API service with caching strategies
- **Storage** - Uses [fifty_storage](../../packages/fifty_storage) for secure tokens and preferences
- **Caching** - Uses [fifty_cache](../../packages/fifty_cache) for TTL-based HTTP response caching
- **Connectivity** - Uses [fifty_connectivity](../../packages/fifty_connectivity) for network monitoring

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

The connectivity module uses [fifty_connectivity](../../packages/fifty_connectivity) and re-exports its APIs:

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

This template uses these Fifty packages (already configured in pubspec.yaml):

| Package | Purpose |
|---------|---------|
| [fifty_tokens](../../packages/fifty_tokens) | Design tokens |
| [fifty_theme](../../packages/fifty_theme) | Theme system |
| [fifty_ui](../../packages/fifty_ui) | UI components |
| [fifty_cache](../../packages/fifty_cache) | HTTP caching |
| [fifty_storage](../../packages/fifty_storage) | Secure storage |
| [fifty_utils](../../packages/fifty_utils) | Pure utilities |
| [fifty_connectivity](../../packages/fifty_connectivity) | Network monitoring |

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
| [fifty_tokens](../../packages/fifty_tokens) | Design tokens |
| [fifty_theme](../../packages/fifty_theme) | Theme system |
| [fifty_ui](../../packages/fifty_ui) | UI components |
| [fifty_cache](../../packages/fifty_cache) | HTTP caching |
| [fifty_storage](../../packages/fifty_storage) | Secure storage |
| [fifty_connectivity](../../packages/fifty_connectivity) | Network monitoring |
| [fifty_utils](../../packages/fifty_utils) | Pure utilities |
| [fifty_audio_engine](../../packages/fifty_audio_engine) | Audio management |
| [fifty_speech_engine](../../packages/fifty_speech_engine) | TTS/STT |
| [fifty_sentences_engine](../../packages/fifty_sentences_engine) | Dialogue system |
| [fifty_map_engine](../../packages/fifty_map_engine) | Map rendering |
| **mvvm_actions** | Architecture template (this template) |
