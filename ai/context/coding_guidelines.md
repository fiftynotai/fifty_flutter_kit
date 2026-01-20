# Coding Guidelines - Fifty Ecosystem

**Generated:** 2026-01-01
**Source:** Base Architecture Template Analysis (Mode A)
**Platform:** Flutter (Dart)
**Base Architecture:** `/templates/mvvm_actions/`
**Version:** 1.0.0

---

## Overview

The Fifty Ecosystem follows the **MVVM + Actions** architecture pattern, originally based on [KalvadTech's flutter-mvvm-actions-arch](https://github.com/KalvadTech/flutter-mvvm-actions-arch). This architecture provides clean separation of concerns with dedicated layers for UI, business logic, data access, and UX orchestration.

**Key Principles:**
- **Layer Isolation:** Each layer has a single responsibility
- **Reactive State:** GetX observables for UI reactivity
- **Type-Safe API Handling:** `ApiResponse<T>` wrapper for all async operations
- **UX Orchestration:** Actions layer handles loading, errors, and navigation
- **Dependency Injection:** GetX bindings for testable, decoupled code

---

## Architecture Pattern

### MVVM + Actions Flow

```
View -> Actions -> ViewModel -> Service -> Model
```

**Data flows down, events flow up:**

```
                          USER INTERACTION
                                |
                                v
+------------------+    +------------------+    +------------------+
|      VIEW        | -> |     ACTIONS      | -> |   VIEWMODEL      |
|  (Presentation)  |    |  (UX Orchestra)  |    | (Business Logic) |
+------------------+    +------------------+    +------------------+
        ^                                               |
        |                                               v
        |                                       +------------------+
        |                                       |    SERVICE       |
        |                                       |  (Data Layer)    |
        |                                       +------------------+
        |                                               |
        |    Rx<ApiResponse<T>> / Obx()                 v
        +<------------------------------------------+------------------+
                                                    |     MODEL        |
                                                    |  (Domain Data)   |
                                                    +------------------+
```

### Layer Responsibilities

| Layer | Responsibility | Files | Pattern |
|-------|----------------|-------|---------|
| **View** | UI widgets, user input, form validation | `*_page.dart`, `*_widget.dart` | `GetView<VM>`, `GetWidget<VM>` |
| **Actions** | UX orchestration (loader, snackbar, navigation) | `*_actions.dart` | Extends `ActionPresenter` |
| **ViewModel** | Business logic, state management | `*_view_model.dart` | Extends `GetxController` |
| **Service** | API calls, data transformation | `*_service.dart` | Extends `ApiService` |
| **Model** | Domain objects, DTOs | `*_model.dart` | Immutable data classes |

### Golden Rules

1. **Views NEVER call Services directly** - Always go through ViewModel
2. **ViewModels NEVER show UI feedback** - Actions handle loading/errors
3. **Services NEVER hold state** - ViewModels own reactive state
4. **Actions NEVER contain business logic** - Delegate to ViewModel

---

## Project Structure

### Canonical Module Structure

```
lib/src/modules/{module}/
|-- {module}.dart                    # Barrel export file
|-- {module}_bindings.dart           # DI registration
|
|-- actions/
|   +-- {module}_actions.dart        # UX orchestration
|
|-- controllers/
|   +-- {module}_view_model.dart     # Business logic
|
|-- data/
|   |-- models/
|   |   +-- {entity}_model.dart      # Domain models
|   +-- services/
|       +-- {module}_service.dart    # API/data layer
|
+-- views/
    |-- {module}_page.dart           # Main page
    +-- widgets/
        +-- {widget_name}.dart       # Module-specific widgets
```

### Full Project Structure

```
lib/src/
|-- app.dart                         # App root widget
|-- main.dart                        # Entry point
|
|-- config/                          # App configuration
|   |-- api_config.dart              # API endpoints
|   |-- assets.dart                  # Asset paths
|   |-- colors.dart                  # Color definitions
|   |-- styles.dart                  # Text styles
|   |-- themes.dart                  # Theme data
|   +-- config.dart                  # Barrel export
|
|-- core/                            # Architecture core
|   |-- bindings/
|   |   +-- bindings.dart            # InitialBindings
|   |-- errors/
|   |   +-- app_exception.dart       # Exception types
|   |-- presentation/
|   |   +-- actions/
|   |       +-- action_presenter.dart # Base action handler
|   +-- routing/
|       +-- route_manager.dart       # Centralized routing
|
|-- infrastructure/                  # Technical services
|   +-- http/
|       +-- api_service.dart         # Base HTTP client
|
|-- modules/                         # Feature modules
|   |-- auth/                        # Authentication
|   |-- locale/                      # Internationalization
|   |-- menu/                        # Navigation
|   |-- space/                       # Example feature module
|   +-- theme/                       # Theme management
|
|-- presentation/                    # Shared widgets
|   |-- custom/                      # Custom components
|   |   |-- custom_button.dart
|   |   |-- custom_card.dart
|   |   +-- customs.dart             # Barrel export
|   +-- widgets/
|       +-- api_handler.dart         # API state handler
|
+-- utils/                           # Utilities
    |-- form_validators.dart
    +-- utils.dart                   # Barrel export
```

---

## Naming Conventions

### Files

| Type | Pattern | Example |
|------|---------|---------|
| Pages | `{name}_page.dart` | `login_page.dart` |
| ViewModels | `{name}_view_model.dart` | `auth_view_model.dart` |
| Actions | `{name}_actions.dart` | `auth_actions.dart` |
| Services | `{name}_service.dart` | `auth_service.dart` |
| Models | `{name}_model.dart` | `user_model.dart` |
| Bindings | `{name}_bindings.dart` | `auth_bindings.dart` |
| Widgets | `{name}.dart` or `{name}_widget.dart` | `apod_card.dart` |
| Barrel exports | `{module}.dart` | `auth.dart` |

### Classes

| Type | Pattern | Example |
|------|---------|---------|
| Pages | `{Name}Page` | `LoginPage` |
| ViewModels | `{Name}ViewModel` | `AuthViewModel` |
| Actions | `{Name}Actions` | `AuthActions` |
| Services | `{Name}Service` | `AuthService` |
| Models | `{Name}Model` | `UserModel` |
| Bindings | `{Name}Bindings` | `AuthBindings` |
| Widgets | `{Name}` or `{Name}Widget` | `ApodCard` |

### Variables & Functions

| Type | Pattern | Example |
|------|---------|---------|
| Private fields | `_camelCase` | `_authService` |
| Public fields | `camelCase` | `isLoading` |
| Methods | `camelCase` | `fetchUser()` |
| Boolean getters | `is{State}` | `isAuthenticated` |
| Observable | `Rx{Type}` or `{name}.obs` | `isLoading.obs` |
| Constants | `UPPER_SNAKE_CASE` or `camelCase` | `API_BASE_URL`, `tkError` |

---

## State Management

### GetX Observables

Use reactive state with GetX's `Rx` types:

```dart
// In ViewModel
class SpaceViewModel extends GetxController {
  // Simple observable
  final RxBool isLoading = false.obs;

  // Complex observable with ApiResponse
  final Rx<ApiResponse<ApodModel>> apod = ApiResponse<ApodModel>.idle().obs;

  // Observable list
  final RxList<NeoModel> neos = <NeoModel>[].obs;

  // Observable string
  final RxString selectedRover = 'curiosity'.obs;
}
```

### ApiResponse Pattern

All async operations MUST use `ApiResponse<T>` for type-safe state handling:

```dart
/// ApiResponse wraps API call results with loading/success/error states.
enum ApiStatus { idle, loading, success, error }

class ApiResponse<E> {
  final E? data;
  final Object? error;
  final StackTrace? stackTrace;
  final ApiStatus status;

  bool get isLoading => status == ApiStatus.loading;
  bool get hasData => data != null;
  bool get hasError => error != null;
  bool get isIdle => status == ApiStatus.idle;
  bool get isSuccess => status == ApiStatus.success;
}
```

### apiFetch Helper

Use `apiFetch()` to wrap service calls with automatic loading/error handling:

```dart
// In ViewModel
void fetchApod({String? date}) {
  apiFetch(() => _nasaService.fetchApod(apiKey: _apiKey, date: date))
      .listen((value) => apod.value = value);
}
```

`apiFetch()` automatically:
1. Emits `loading` state
2. Executes the async function
3. Emits `success` with data or `error` with exception
4. Logs errors in debug mode

### ApiHandler Widget

Use `ApiHandler<T>` in views to render based on `ApiResponse<T>` state:

```dart
Obx(() => ApiHandler<ApodModel>(
  response: controller.apod.value,
  loadingWidget: const Center(child: CircularProgressIndicator()),
  successBuilder: (apod) => ApodCard(
    title: apod.title,
    imageUrl: apod.url,
  ),
  errorBuilder: (err, retry) => ErrorView(
    error: err,
    onRetry: retry,
  ),
  tryAgain: controller.refreshApod,
));
```

---

## Dependency Injection

### GetX Bindings Pattern

Each module has a dedicated `Bindings` class for DI registration:

```dart
class SpaceBindings implements Bindings {
  @override
  void dependencies() {
    // 1. Register Service (if not already registered)
    if (!Get.isRegistered<NasaService>()) {
      Get.lazyPut<NasaService>(() => NasaService(), fenix: true);
    }

    // 2. Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SpaceViewModel>()) {
      Get.put<SpaceViewModel>(
        SpaceViewModel(Get.find()),
        permanent: true,
      );
    }

    // 3. Register Actions
    if (!Get.isRegistered<SpaceActions>()) {
      Get.lazyPut<SpaceActions>(
        () => SpaceActions(Get.find(), ActionPresenter()),
        fenix: true,
      );
    }
  }

  // Cleanup method for logout/state reset
  static void destroy() {
    if (Get.isRegistered<SpaceActions>()) {
      Get.delete<SpaceActions>(force: true);
    }
    if (Get.isRegistered<SpaceViewModel>()) {
      Get.delete<SpaceViewModel>(force: true);
    }
    if (Get.isRegistered<NasaService>()) {
      Get.delete<NasaService>(force: true);
    }
  }
}
```

### Registration Order

**MUST follow dependency order:**
1. **Services** (no dependencies) - `Get.lazyPut`
2. **ViewModels** (depend on Services) - `Get.put` or `Get.lazyPut`
3. **Actions** (depend on ViewModels) - `Get.lazyPut`

**Cleanup order is REVERSE:**
1. Actions first
2. ViewModels second
3. Services last

### Registration Types

| Type | Use When | Example |
|------|----------|---------|
| `Get.put()` | Immediate initialization, permanent | ViewModels |
| `Get.lazyPut()` | Lazy initialization | Services, Actions |
| `Get.lazyPut(fenix: true)` | Auto-recreate after deletion | Services, Actions |
| `permanent: true` | Persist across navigation | ViewModels |

---

## Actions Layer

### ActionPresenter Base Class

All Actions classes extend `ActionPresenter` for consistent UX handling:

```dart
class AuthActions extends ActionPresenter {
  late AuthViewModel _authViewModel;

  AuthActions._() {
    _authViewModel = Get.find();
  }

  /// Sign in with loading overlay and error handling.
  Future signIn(BuildContext context) async {
    actionHandler(context, () async {
      await _authViewModel.signIn();
      showSuccessSnackBar(tkLoginBtn, tkSignInSuccess);
    });
  }
}
```

### Action Methods

Actions provide two handler variants:

```dart
/// With loading overlay (default)
await actionHandler(
  context,
  () async {
    await _viewModel.doWork();
  },
  onSuccess: () => showSuccess(),
  onFailure: () => handleFailure(),
);

/// Without loading overlay
await actionHandlerWithoutLoading(
  () async {
    await _viewModel.doQuickWork();
  },
);
```

### What Actions Handle

- **Loading Overlay:** `context.loaderOverlay.show()` / `.hide()`
- **Error Snackbars:** `showErrorSnackBar(title, message)`
- **Success Feedback:** `showSuccessSnackBar(title, message)`
- **Confirmation Dialogs:** `showConfirmationDialog(context, message)`
- **Navigation:** `RouteManager.to()`, `back()`

---

## Service Layer

### ApiService Base Class

All HTTP services extend `ApiService` for consistent networking:

```dart
class NasaService extends ApiService {
  Future<ApodModel> fetchApod({
    required String apiKey,
    String? date,
  }) async {
    final response = await get<Map<String, dynamic>>(
      'https://api.nasa.gov/planetary/apod',
      query: {
        'api_key': apiKey,
        if (date != null) 'date': date,
      },
      useCache: true,
    );
    return ApodModel.fromJson(response.body!);
  }
}
```

### ApiService Features

- **Authorization:** Auto-injects Bearer token from `AppStorageService`
- **401 Retry:** Automatic token refresh and request retry
- **Caching:** Optional response caching via `fifty_cache`
- **Error Mapping:** Converts HTTP errors to typed exceptions
- **Debug Logging:** Request/response logging in debug mode

### HTTP Methods

```dart
// GET with optional caching
await get<T>(url, {query, useCache: true, forceRefresh: false});

// POST (no caching by default)
await post<T>(url, body, {useCache: false});

// PUT
await put<T>(url, body);

// DELETE
await delete<T>(url);

// File download
await downloadFile(url, fileName, {onReceiveProgress});
```

---

## View Layer

### GetView vs GetWidget

| Type | Use When | Rebuilds |
|------|----------|----------|
| `GetView<VM>` | Stateless, single controller | On Obx changes only |
| `GetWidget<VM>` | Need GlobalKey, local state | On Obx changes only |
| `StatelessWidget` | No controller needed | On parent rebuild |

### View Pattern

```dart
class LoginPage extends GetWidget<AuthViewModel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Form fields...

            // Submit button
            FiftyButton(
              label: 'ESTABLISH UPLINK',
              onPressed: () => _login(context),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Save form values to ViewModel
      controller.username = _usernameController.text;
      controller.password = _passwordController.text;
      // Trigger action (handles loading/errors)
      AuthActions.instance.signIn(context);
    }
  }
}
```

### Reactive Updates

Use `Obx()` for reactive UI updates:

```dart
// Simple observable
Obx(() => Text(controller.isLoading.value ? 'Loading...' : 'Ready'));

// ApiResponse with ApiHandler
Obx(() => ApiHandler<ApodModel>(
  response: controller.apod.value,
  successBuilder: (data) => ApodCard(data: data),
));

// Conditional visibility
Obx(() => Visibility(
  visible: controller.hasData,
  child: DataWidget(),
));
```

---

## Routing

### RouteManager

Centralized routing via singleton:

```dart
class RouteManager {
  // Route constants
  static const String initialRoute = '/';
  static const String authRoute = '/auth';
  static const String registerRoute = '/auth/register';
  static const String menuRoute = '/menu';

  // Navigation helpers
  static Future<T?>? to<T>(String route, {dynamic arguments});
  static Future<T?>? off<T>(String route, {dynamic arguments});
  static Future<T?>? offAll<T>(String route, {dynamic arguments});
  static void back<T>({T? result});

  // Specific helpers
  static Future<dynamic>? toAuth() => to(authRoute);
  static Future<dynamic>? logout() => offAll(authRoute);
  static Future<dynamic>? loginSuccess() => offAll(menuRoute);
}
```

### Route Registration

```dart
void initialize() {
  _pages.addAll([
    GetPage(
      name: authRoute,
      page: () => const AuthPage(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: menuRoute,
      page: () => const MenuPageWithDrawer(),
      binding: MenuBindings(),
      middlewares: [AuthMiddleware()],
    ),
  ]);
}
```

---

## FDL Compliance (Fifty Design Language)

### Required Packages

All UI MUST use the FDL packages:

```yaml
dependencies:
  fifty_tokens: ^0.2.0    # Design tokens
  fifty_theme: ^0.1.0     # Theme system
  fifty_ui: ^0.5.0        # UI components
```

### Design Tokens

Use `FiftyTokens` for all visual values:

```dart
// Colors
FiftyColors.crimsonPulse      // Primary accent
FiftyColors.voidBlack         // Background
FiftyColors.hyperChrome       // Secondary text
FiftyColors.igrisGreen        // Success/online
FiftyColors.border            // Border color
FiftyColors.error             // Error state

// Spacing
FiftySpacing.xs   // 4
FiftySpacing.sm   // 8
FiftySpacing.md   // 12
FiftySpacing.lg   // 16
FiftySpacing.xl   // 24
FiftySpacing.xxl  // 32
FiftySpacing.xxxl // 48

// Typography
FiftyTypography.fontFamilyHeadline  // Monument Extended
FiftyTypography.fontFamilyMono      // JetBrains Mono
FiftyTypography.display  // 32
FiftyTypography.heading  // 24
FiftyTypography.title    // 20
FiftyTypography.body     // 16
FiftyTypography.mono     // 12

// Radii
FiftyRadii.standardRadius  // BorderRadius.circular(8)
FiftyRadii.smallRadius     // BorderRadius.circular(4)
FiftyRadii.largeRadius     // BorderRadius.circular(12)
```

### FDL Components

Use FDL components instead of raw Flutter widgets:

```dart
// Buttons
FiftyButton(
  label: 'ESTABLISH UPLINK',
  onPressed: () {},
  variant: FiftyButtonVariant.primary,
  size: FiftyButtonSize.large,
  expanded: true,
);

// Cards
FiftyCard(
  padding: EdgeInsets.all(FiftySpacing.xxl),
  scanlineOnHover: false,
  child: content,
);

// Data display
FiftyDataSlate(
  title: 'TOTAL',
  data: {'Objects': '14', 'Today': '6'},
);

// Status indicators
StatusIndicator(
  status: ApiConnectionStatus.connected,
  label: 'NASA',
);
```

### Kinetic Brutalism Aesthetic

- **Headlines:** Monument Extended, UPPERCASE, tight letter-spacing
- **Body/Mono:** JetBrains Mono, terminal-style
- **Colors:** High contrast, crimson accents on void black
- **Borders:** 1-2px solid borders, no shadows
- **Animation:** Subtle, purposeful (scanlines, pulse effects)

---

## Error Handling

### Exception Types

```dart
// Base exception
class AppException implements Exception {
  final String message;
  final String prefix;
  AppException([this.message = '', this.prefix = 'Error']);
}

// Auth-specific
class AuthException extends AppException {
  AuthException([String message = '']) : super(message, 'Auth Error');
}

// API-specific
class APIException extends AppException {
  APIException([String message = '']) : super(message, 'API Error');
}
```

### Error Handling in Services

```dart
void handleError(Response response) {
  if (!response.hasError) return;
  final status = response.statusCode ?? 0;

  switch (status) {
    case 401:
      throw AuthException('Unauthorized');
    case 404:
      throw APIException('Not found');
    case 408:
      throw APIException('Request timeout');
    default:
      throw APIException('Unexpected error ($status)');
  }
}
```

### Error Handling in Actions

The `ActionPresenter` catches exceptions and shows appropriate feedback:

```dart
try {
  await action();
  onSuccess?.call();
} on AppException catch (e, stackTrace) {
  _handleException(e, stackTrace, e.prefix, e.message);
  onFailure?.call();
} catch (e, stackTrace) {
  _handleException(e, stackTrace, tkError, tkSomethingWentWrongMsg);
  onFailure?.call();
}
```

---

## Documentation Requirements

### Required Documentation

All public APIs MUST have doc comments:

```dart
/// **SpaceViewModel**
///
/// GetX controller responsible for managing space data state and
/// orchestrating data fetching via [NasaService].
///
/// **Why**
/// - Encapsulates space data business logic separate from UI.
/// - Provides reactive [ApiResponse] state for loading/success/error rendering.
///
/// **Key Features**
/// - Reactive observables wrapped in [ApiResponse] for each data type.
/// - Automatic APOD and NEO fetch on initialization.
///
/// **Example Usage**
/// ```dart
/// final spaceVM = Get.find<SpaceViewModel>();
/// spaceVM.refreshApod();
/// ```
class SpaceViewModel extends GetxController {
```

### Method Documentation Format

```dart
/// **fetchApod**
///
/// Fetches the Astronomy Picture of the Day from NASA.
///
/// **Parameters**
/// - [date]: Optional date in YYYY-MM-DD format.
///
/// **Returns**
/// - Updates [apod] observable with result.
///
/// **Example**:
/// ```dart
/// viewModel.fetchApod(date: '2023-12-25');
/// ```
void fetchApod({String? date}) {
```

---

## Testing Standards

### Required Tests

| Component | Test Type | Minimum Coverage |
|-----------|-----------|------------------|
| ViewModels | Unit tests | 80% |
| Services | Unit tests | 80% |
| Actions | Unit tests | 70% |
| Models | Unit tests | 90% |
| Widgets | Widget tests | 50% |
| Critical flows | Integration tests | Key paths |

### Test File Location

```
test/
|-- modules/
|   |-- auth/
|   |   |-- controllers/
|   |   |   +-- auth_view_model_test.dart
|   |   |-- services/
|   |   |   +-- auth_service_test.dart
|   |   +-- actions/
|   |       +-- auth_actions_test.dart
|   +-- space/
|       +-- ...
|-- widgets/
|   +-- api_handler_test.dart
+-- utils/
    +-- form_validators_test.dart
```

### Mocking Pattern

```dart
class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthViewModel viewModel;
  late MockAuthService mockService;

  setUp(() {
    mockService = MockAuthService();
    viewModel = AuthViewModel(mockService);
  });

  test('checkSession returns true when logged in', () async {
    when(() => mockService.isLoggedIn()).thenAnswer((_) async => true);
    when(() => mockService.isAccessTokenExpired()).thenAnswer((_) async => false);

    final result = await viewModel.checkSession();

    expect(result, true);
    expect(viewModel.authState, AuthState.authenticated);
  });
}
```

---

## Best Practices

### DO

- Follow layer boundaries (View -> Actions -> ViewModel -> Service)
- Use `ApiResponse<T>` for all async operations
- Register dependencies in proper order via Bindings
- Use FDL components for all UI elements
- Write doc comments for public APIs
- Keep functions under 50 lines
- Use const constructors where possible
- Handle all error cases with typed exceptions
- Clean up dependencies on logout via `destroy()` methods

### DON'T

- Skip architecture layers (View -> Service directly)
- Put UI logic (snackbars, dialogs) in ViewModels
- Put business logic in Actions
- Hardcode colors, spacing, or typography values
- Leave empty catch blocks
- Create god classes (split into focused modules)
- Use raw Flutter widgets when FDL alternatives exist
- Forget to update Bindings when adding dependencies

---

## Code Review Checklist

- [ ] Follows MVVM + Actions architecture
- [ ] Proper layer separation (no layer skipping)
- [ ] Uses `ApiResponse<T>` and `apiFetch()` for async
- [ ] Uses `ApiHandler` for rendering API states
- [ ] Bindings register dependencies in correct order
- [ ] FDL components and tokens used for all UI
- [ ] Documentation present for public APIs
- [ ] Unit tests included for business logic
- [ ] Linter passes (zero issues)
- [ ] No hardcoded strings in UI (use localization keys)
- [ ] Error handling covers all edge cases

---

## Module Barrel Export Template

Every module MUST have a barrel export file:

```dart
/// **{Module} Module**
///
/// {Brief description of module purpose}.
///
/// **Usage**:
/// ```dart
/// import 'package:mvvm_actions/src/modules/{module}/{module}.dart';
/// ```
library;

// Bindings
export '{module}_bindings.dart';

// Actions
export 'actions/{module}_actions.dart';

// Controllers
export 'controllers/{module}_view_model.dart';

// Data - Models
export 'data/models/{entity}_model.dart';

// Data - Services
export 'data/services/{module}_service.dart';

// Views
export 'views/{module}_page.dart';
export 'views/widgets/{widget}.dart';
```

---

## Ecosystem Package Integration

### Core Infrastructure Packages

| Package | Import | Purpose |
|---------|--------|---------|
| fifty_tokens | `package:fifty_tokens/fifty_tokens.dart` | Design tokens |
| fifty_theme | `package:fifty_theme/fifty_theme.dart` | Theme system |
| fifty_ui | `package:fifty_ui/fifty_ui.dart` | UI components |
| fifty_cache | `package:fifty_cache/fifty_cache.dart` | HTTP caching |
| fifty_storage | `package:fifty_storage/fifty_storage.dart` | Secure storage |
| fifty_utils | `package:fifty_utils/fifty_utils.dart` | Utilities, ApiResponse |
| fifty_connectivity | `package:fifty_connectivity/fifty_connectivity.dart` | Network monitoring |

### Storage Usage

```dart
import 'package:fifty_storage/fifty_storage.dart';

// Configure at app start
PreferencesStorage.configure(containerName: 'my_app');
await AppStorageService.instance.initialize();

// Access tokens
final token = AppStorageService.instance.accessToken;
await AppStorageService.instance.setAccessToken('jwt_token');

// Preferences
AppStorageService.instance.themeMode = 'dark';
AppStorageService.instance.languageCode = 'en';
```

### Cache Configuration

```dart
import 'package:fifty_cache/fifty_cache.dart';

// Configure cache globally
ApiService.configureCache(cacheManager);

// Use in requests
await get(url, useCache: true, forceRefresh: false);
```

### Connectivity Monitoring

```dart
import 'package:fifty_connectivity/fifty_connectivity.dart';

// In app.dart
ConnectionOverlay(
  child: GetMaterialApp(...),
);

// Check status
final connVM = Get.find<ConnectionViewModel>();
if (connVM.isOnline.value) {
  // Proceed with network request
}
```

---

## Engine Package Architecture

### Golden Rule: Consume, Don't Define

Engine packages (skill_tree, achievement, inventory, dialogue, forms, etc.) **MUST consume** theming from FDL packages. They **MUST NOT** define their own theming systems.

```
┌─────────────────────────────────────────────────────────────────┐
│                     FDL Foundation Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ fifty_tokens│  │ fifty_theme │  │  fifty_ui   │              │
│  │ (colors,    │  │ (dark/light │  │ (components)│              │
│  │  spacing,   │  │  modes)     │  │             │              │
│  │  typography)│  │             │  │             │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
│         │                │                │                      │
│         └────────────────┼────────────────┘                      │
│                          │                                       │
│                          ▼                                       │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                   Engine Packages                          │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │  │
│  │  │ skill_tree   │ │ achievement  │ │  inventory   │  ...  │  │
│  │  │ (consumes)   │ │ (consumes)   │ │ (consumes)   │       │  │
│  │  └──────────────┘ └──────────────┘ └──────────────┘       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Anti-Pattern: Self-Contained Theming

**NEVER do this:**

```dart
// ❌ WRONG - Package defines its own theme system
class SkillTreeTheme {
  final Color lockedNodeColor;
  final Color unlockedNodeColor;
  final Color connectionColor;
  // ... 20+ custom properties

  factory SkillTreeTheme.dark() => SkillTreeTheme(
    lockedNodeColor: Color(0xFF333333),  // hardcoded!
    unlockedNodeColor: Color(0xFF00FF00), // hardcoded!
  );
}

class SkillTreeThemePresets {
  static SkillTreeTheme rpg() => ...  // more hardcoded values
  static SkillTreeTheme sciFi() => ...
}
```

**Problems:**
- FDL changes don't propagate automatically
- Inconsistent look with rest of ecosystem
- Duplicate maintenance effort
- Anti-pattern spreads to other packages

### Correct Pattern: FDL Consumption

**ALWAYS do this:**

```dart
// ✅ CORRECT - Package consumes from FDL
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';

class SkillNodeWidget extends StatelessWidget {
  // Optional overrides (not a separate theme class)
  final Color? nodeColor;
  final Color? borderColor;

  const SkillNodeWidget({
    this.nodeColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use FDL tokens with optional override
      color: nodeColor ?? FiftyColors.surface,
      padding: FiftySpacing.insets.md,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? FiftyColors.border,
        ),
        borderRadius: FiftyRadii.standardRadius,
      ),
      child: Text(
        node.name,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.body,
          color: FiftyColors.textPrimary,
        ),
      ),
    );
  }
}
```

### Engine Package Checklist

When creating or reviewing an engine package:

- [ ] **Dependencies:** Includes `fifty_tokens` and `fifty_ui` in pubspec.yaml
- [ ] **No Theme Class:** Does NOT define a custom `*Theme` class with color properties
- [ ] **No Presets:** Does NOT define `*ThemePresets` with hardcoded variants
- [ ] **FDL Colors:** Uses `FiftyColors.*` for all color values
- [ ] **FDL Spacing:** Uses `FiftySpacing.*` for all padding/margins
- [ ] **FDL Typography:** Uses `FiftyTypography.*` for all text styles
- [ ] **FDL Radii:** Uses `FiftyRadii.*` for all border radius values
- [ ] **FDL Components:** Uses `FiftyCard`, `FiftyButton`, etc. where applicable
- [ ] **Optional Overrides:** Provides override parameters on widgets (not a theme object)
- [ ] **Controller Clean:** Controller does NOT have a `theme` property

### Override Pattern

When customization is needed, use **widget-level optional parameters**, not a theme class:

```dart
// ✅ CORRECT - Optional overrides on widget
SkillTreeView<void>(
  controller: controller,
  layout: const VerticalTreeLayout(),
  // Optional overrides for specific use cases
  lockedNodeColor: Colors.grey,
  unlockedNodeColor: FiftyColors.igrisGreen,
  connectionColor: FiftyColors.border,
)

// ❌ WRONG - Separate theme object
SkillTreeView<void>(
  controller: controller,
  theme: SkillTreeTheme(
    lockedNodeColor: Colors.grey,
    // ... duplicates FDL
  ),
)
```

### State-Based Styling

For widgets with multiple states (locked, unlocked, available, etc.), define semantic color getters:

```dart
class SkillNodeWidget extends StatelessWidget {
  Color get _nodeColor {
    switch (state) {
      case SkillState.locked:
        return FiftyColors.surfaceVariant;
      case SkillState.available:
        return FiftyColors.surface;
      case SkillState.unlocked:
        return FiftyColors.successBackground;
      case SkillState.maxed:
        return FiftyColors.primaryBackground;
    }
  }

  Color get _borderColor {
    switch (state) {
      case SkillState.locked:
        return FiftyColors.border;
      case SkillState.available:
        return FiftyColors.primary;
      case SkillState.unlocked:
        return FiftyColors.success;
      case SkillState.maxed:
        return FiftyColors.primaryAccent;
    }
  }
}
```

### Package Dependencies Template

Every engine package pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # FDL Foundation (REQUIRED)
  fifty_tokens: ^0.2.0
  fifty_ui: ^0.5.0

  # Optional ecosystem packages
  fifty_storage: ^0.1.0      # if persistence needed
  fifty_audio_engine: ^0.8.0 # if sounds needed
```

### The Promotion Pattern

Not everything belongs in FDL. Use this decision tree:

```
┌─────────────────────────────────────────────────────────────┐
│  When building something new, ask:                          │
│                                                             │
│  1. Is it a primitive? (color, spacing, typography)         │
│     YES → Must go in fifty_tokens                           │
│                                                             │
│  2. Is it a generic component? (button, card, modal)        │
│     YES → Must go in fifty_ui                               │
│                                                             │
│  3. Is it domain-specific? (skill node, inventory slot)     │
│     YES → Can stay in engine package                        │
│           BUT must consume FDL primitives                   │
│                                                             │
│  4. Is it used by 2+ packages?                              │
│     YES → PROMOTE to fifty_ui                               │
└─────────────────────────────────────────────────────────────┘
```

**Layer Classification:**

| Layer | Location | Examples |
|-------|----------|----------|
| Primitives | fifty_tokens | Colors, spacing, typography, radii, motion |
| Generic Components | fifty_ui | Button, Card, TextField, Modal, Toast, ProgressBar |
| Domain Widgets | Engine package | SkillNodeWidget, AchievementCard, InventorySlot |
| Domain Painters | Engine package | SkillConnectionPainter, DialogueBoxPainter |

**Promotion Workflow:**

When something is needed by multiple packages:

```
1. Package A creates GlowAnimation (lives in package A)
2. Package B needs same animation
3. STOP - Don't copy to Package B
4. Create brief: "Promote GlowAnimation to fifty_ui"
5. Move to fifty_ui with proper API
6. Both packages consume from fifty_ui
```

**Examples:**

| Component | Where | Why |
|-----------|-------|-----|
| `FiftyColors.success` | fifty_tokens | Primitive |
| `FiftyButton` | fifty_ui | Generic component |
| `FiftyProgressBar` | fifty_ui | Generic component |
| `SkillNodeWidget` | fifty_skill_tree | Domain-specific |
| `AchievementCard` | fifty_achievement | Domain-specific |
| `GlowAnimation` | **Promote** | Used by 2+ packages |
| `RarityBorder` | **Promote** | Used by inventory + achievement |

**Domain Widget Pattern:**

```dart
// ✅ CORRECT - Domain widget consuming FDL primitives
class SkillNodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: FiftyColors.surface,           // ← FDL primitive
      padding: FiftySpacing.insets.md,      // ← FDL primitive
      child: FiftyCard(                     // ← FDL component
        child: _buildSkillContent(),        // ← Domain-specific logic
      ),
    );
  }
}

// ✅ CORRECT - Domain-specific painter consuming FDL
class SkillConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FiftyColors.border          // ← Consumes FDL
      ..strokeWidth = 2;
    // Domain-specific drawing logic stays here
  }
}
```

**Benefits of This Approach:**

- **Speed:** Engine packages can build domain widgets without waiting for FDL updates
- **Consistency:** All primitives come from FDL - no hardcoded values
- **Scalability:** Common patterns get promoted to FDL over time
- **Clean FDL:** Foundation doesn't bloat with domain-specific niche components

### Why This Matters

When the design system changes (new colors, new spacing scale, new typography):

**With Self-Contained Theming (Wrong):**
- Update fifty_tokens ✓
- Update fifty_theme ✓
- Update fifty_ui ✓
- Update fifty_skill_tree manually ✗
- Update fifty_achievement_engine manually ✗
- Update fifty_inventory_engine manually ✗
- Update fifty_dialogue_engine manually ✗
- Update fifty_forms manually ✗
- **5+ packages to update manually**

**With FDL Consumption (Correct):**
- Update fifty_tokens ✓
- Update fifty_theme ✓
- Update fifty_ui ✓
- **All engine packages automatically updated**

---

**Last Updated:** 2026-01-20
**Architecture Version:** MVVM + Actions 1.0
**Maintained By:** Fifty.ai
