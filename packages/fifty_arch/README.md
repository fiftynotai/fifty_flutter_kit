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
- **Connections** - Real-time connectivity monitoring
- **Locale** - Multi-language support with dynamic switching
- **Theme** - Light/dark theme management
- **Menu** - Navigation drawer and bottom navigation

### Infrastructure
- **HTTP Client** - API service with caching strategies
- **Storage** - Secure token storage, preferences, in-memory cache
- **Caching** - TTL-based cache with configurable policies

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
|   |-- cache/           # Caching system
|   |-- http/            # API client
|   +-- storage/         # Storage services
|
|-- modules/             # Feature modules
|   |-- auth/            # Authentication
|   |-- connections/     # Connectivity
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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();

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

```dart
// Monitor connection
final connVM = Get.find<ConnectionViewModel>();
Obx(() => Text(connVM.isOnline.value ? 'Online' : 'Offline'));
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
```

Use `fifty_theme` for theming:
```dart
// In theme module, replace custom themes with:
import 'package:fifty_theme/fifty_theme.dart';

ThemeData get darkTheme => FiftyTheme.dark();
ThemeData get lightTheme => FiftyTheme.light();
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| get | State management |
| loader_overlay | Loading overlays |
| connectivity_plus | Network monitoring |
| get_storage | Local storage |
| flutter_secure_storage | Secure storage |
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
| [fifty_audio_engine](../fifty_audio_engine) | Audio management |
| [fifty_speech_engine](../fifty_speech_engine) | TTS/STT |
| [fifty_sentences_engine](../fifty_sentences_engine) | Dialogue system |
| [fifty_map_engine](../fifty_map_engine) | Map rendering |
| **fifty_arch** | Architecture framework |
