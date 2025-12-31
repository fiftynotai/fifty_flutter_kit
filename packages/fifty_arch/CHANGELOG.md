# Changelog

All notable changes to this project template will be documented in this file.

The format is based on Keep a Changelog, and this project adheres loosely to Semantic Versioning for the template itself.

## [0.5.0] - 2025-12-31

### Changed

- **Extracted HTTP caching to fifty_cache package**: The caching infrastructure has been extracted to a standalone `fifty_cache` package for better modularity and reusability.
  - Moved: `CacheManager`, `CacheStore`, `CachePolicy`, `CacheKeyStrategy` contracts
  - Moved: `MemoryCacheStore`, `GetStorageCacheStore` implementations
  - Moved: `SimpleTimeToLiveCachePolicy`, `DefaultCacheKeyStrategy` implementations
  - fifty_arch now depends on fifty_cache v0.1.0

### Migration Notes

- No API changes required - imports are re-exported from fifty_arch
- If you were importing cache classes directly from `infrastructure/cache/`, update to use exports from fifty_cache or the main barrel file

## [0.4.0] - 2025-12-31

### Fixed

#### Theme-Aware App Components
All app-level components now properly support light and dark mode switching. Previously, several screens and widgets had hardcoded dark theme colors (`FiftyColors.voidBlack`, `FiftyColors.gunmetal`) that prevented proper theming.

**Scaffold and Navigation:**
- `OrbitalCommandPage` - Scaffold and AppBar backgrounds now use `colorScheme.surface`
- `SideMenuDrawer` - Drawer background and logo container now use theme-aware colors

**Authentication Screens:**
- `LoginPage` - Form field backgrounds and scaffolds now use theme-aware colors
- `RegisterPage` - Form field backgrounds and scaffolds now use theme-aware colors
- `SplashPage` - Background now uses `colorScheme.surface`

**Connectivity Module:**
- `ConnectionHandler` - Backgrounds now use theme-aware colors
- `ConnectionOverlay` - Overlay backgrounds now use theme-aware colors

**Menu Components:**
- `MenuDrawerItem` - Dialog and item backgrounds now use theme-aware colors
- `LogoutDrawerItem` - Dialog backgrounds now use theme-aware colors
- `LanguageDialog` - Dialog background now uses theme-aware colors
- `LanguageDrawerItem` - Item backgrounds now use theme-aware colors

**Example Widgets:**
- `NeoListTile` - Text and placeholder colors now use `colorScheme.onSurface`
- `ApodCard` - Placeholder and text colors now use theme-aware values
- `MarsPhotoCard` - Placeholder and text colors now use theme-aware values

### Changed
- App screens now respond to system theme changes and `ThemeMode` switching
- Light mode displays proper surface colors instead of dark-only values
- Consistent use of Material 3 color scheme tokens throughout

### Migration Notes
- No API changes required
- All screens automatically use theme-appropriate colors
- Theme switching via `ThemeViewModel` now properly affects all screens

## [0.3.0] - 2025-01-08

### Major Refactoring - Better Organization & Cleaner APIs

This release focuses on improving code organization, simplifying APIs, and enhancing developer experience through better separation of concerns.

### Added
- **Core directory structure**: Created `/src/core/` for framework-level code
  - `core/bindings/` - Dependency injection configuration
  - `core/routing/` - Route management and navigation
- **DateTime extensions**: New `date_time_extensions.dart` with fluent API
  - Extension methods: `date.isToday`, `date.format()`, `date.timeAgo()`
  - Duration extensions: `duration.format()`
- **Enhanced ResponsiveUtils**: Complete responsive design system
  - Device type detection: `isMobile()`, `isTablet()`, `isDesktop()`, `isWideDesktop()`
  - `valueByDevice<T>()` helper for responsive values
  - Helper methods: `padding()`, `margin()`, `gridColumns()`
- **RouteManager navigation helpers**:
  - Specific routes: `toAuth()`, `toRegister()`, `toMenu()`
  - Auth flows: `logout()`, `loginSuccess()`
  - Generic navigation: `to()`, `off()`, `offAll()`, `back()`, `until()`
  - Utilities: `currentRoute`, `isCurrentRoute()`, `arguments`
- **AuthViewModel state callbacks**: Support for `onAuthenticated` and `onNotAuthenticated` callbacks
- **MIGRATION_GUIDE.md**: Comprehensive migration guide for breaking changes

### Changed
- **File relocations**:
  - `utils/route_manager.dart` -> `core/routing/route_manager.dart`
  - `utils/binding.dart` -> `core/bindings/bindings.dart`
- **File renames**:
  - `utils/validator.dart` -> `utils/form_validators.dart`
  - `utils/screen_utils.dart` -> `utils/responsive_utils.dart`
  - `utils/date_time_utils.dart` -> `utils/date_time_extensions.dart`
- **Class renames**:
  - `InputsValidator` -> `FormValidators`
  - `ScreenUtils` -> `ResponsiveUtils`
  - `DateTimeUtils` -> DateTime extensions
- **API simplifications**:
  - FormValidators: Removed redundant `*Validator` methods, kept short names
    - `emailValidator()` -> `email()`
    - `phoneValidator()` -> `phone()`
    - `passwordValidator()` -> `password()`
  - ResponsiveUtils: Improved method names
    - `getFontSize()` -> `scaledFontSize()`
    - `getScreenHeight()` -> `screenHeight()`
  - DateTime: Changed from static utils to extensions
    - `DateTimeUtils.isToday(date)` -> `date.isToday`
    - `DateTimeUtils.formatDate(date)` -> `date.format()`
- **Binding architecture**:
  - `InitialBindings` now only registers core dependencies (Connections, Theme, Locale)
  - `AuthBindings` registers Menu and Posts modules via `onAuthenticated` callback
  - Feature modules loaded on-demand instead of upfront
- **Navigation consistency**: Replaced direct `Get.*` calls with `RouteManager.*` throughout codebase
- **Matrix4 deprecation fix**: Updated `custom_card.dart` to use `diagonal3Values()` instead of deprecated `scale()`

### Improved
- **Developer experience**: More intuitive APIs with better autocomplete
- **Performance**: Feature modules loaded only when needed
- **Testability**: Better separation between state management and dependency registration
- **Code organization**: Clear distinction between core framework code and utilities
- **Documentation**: Updated inline docs to reflect new patterns

### Migration Required
See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed migration steps.

Key changes:
1. Update imports: `utils/route_manager.dart` -> `core/core.dart`
2. Update validators: `FormValidators.emailValidator` -> `FormValidators.email`
3. Update responsive: `ScreenUtils` -> `ResponsiveUtils`
4. Convert DateTime utils to extensions: `DateTimeUtils.isToday(date)` -> `date.isToday`
5. Update navigation: `Get.back()` -> `RouteManager.back()`

## [0.2.0] - 2025-10-02

### Added
- Introduced clear layering split between `core/` and `infrastructure/`:
  - `src/core/` now hosts primitives and presentation-layer contracts (e.g., `core/presentation/api_response.dart`, `core/errors/app_exception.dart`).
  - `src/infrastructure/` now hosts concrete adapters: `http/ApiService`, `cache/*`, and `storage/*`.
- Strategy-based HTTP response caching:
  - `infrastructure/cache/CacheStore`, `CacheKeyStrategy`, `CachePolicy`, and `CacheManager` abstractions.
  - Default implementations: `DefaultCacheKeyStrategy`, `SimpleTimeToLiveCachePolicy`, `GetStorageCacheStorage`.
  - Global enable/disable via `ApiService.configureCache(CacheManager?)`.
  - Header-aware cache keys (whitelist): keys now include `Accept-Language` and an `Authorization`-presence fingerprint to avoid wrong cache hits.
- Unified storage facade: `infrastructure/storage/AppStorageService` providing a single entry point for preferences (GetStorage) and secure tokens (Keychain/Keystore).
- Secure token storage: `SecureTokenStorage` backed by `flutter_secure_storage` with in-memory caches and initialization.
- Preferences storage: `PreferencesStorage` backed by `GetStorage` with a centralized container name.
- `ApiResponse<E>` upgraded to an immutable, error-preserving model with `ApiStatus { idle, loading, success, error }` and a thunk-based `apiFetch` helper.
- `ApiHandler<E>` simplified UI helper for rendering loading/success/error; now placed under `src/presentation/widgets/`.
- Downloading files: `ApiService.downloadFile` reimplemented using `GetConnect.get` to fetch bytes for uniform headers, timeout, logging, and refresh+retry handling.

### Changed
- `ApiService` hardening:
  - Authorization header formatting fixed and only included when a token exists.
  - One-shot retry of the original request after a successful 401 refresh.
  - Robust error mapping without secondary decode errors; sensitive logs are redacted and gated via `assert`.
  - Central cache helpers `_decodeCachedPayload`, `_tryServeFromCache`, `_tryWriteCache` to remove duplication across verbs.
  - Header handling: when a per-request `headers` map is provided, it is used as-is; otherwise, defaults (authorized headers) are applied. No merging.
- Caching defaults: GET uses cache by default; POST/PUT/DELETE do not cache unless explicitly opted in. Error responses are never cached.
- Moved shared UI utilities:
  - `api_handler.dart` -> `src/presentation/widgets/api_handler.dart`.
  - `api_response.dart` -> `src/core/presentation/api_response.dart`.
- README and coding guidelines updated to reflect the new structure and APIs.

- Auth module hardening:
  - AuthViewModel.checkSession now ends in `authenticated` or `notAuthenticated` and never stays in `checking` after completion.
  - AuthViewModel.logout now awaits `signOut()` before setting `notAuthenticated`.
  - AuthService.signIn validates response shape (`access`/`refresh`) and throws `APIException` on malformed bodies.
  - ActionPresenter guards loader overlay show/hide (no crash if overlay not mounted) and provides clearer user feedback for auth errors.

### Deprecated
- `MemoryService` is deprecated in favor of the unified `AppStorageService` facade and the split `PreferencesStorage` + `SecureTokenStorage`.

### Removed
- Legacy `essentials/` usage for infra concerns has been replaced by `infrastructure/`. Remove old imports and use the new paths.

### Fixed
- Incorrect `Authorization` header formatting (removed leading space and conditional inclusion).
- Avoid caching writes by default and prevent caching of error responses.
- Safer error logging: redacted `Authorization` header, truncated response previews, and `assert`-gated logs to avoid leaking in release builds.
- `downloadFile` now benefits from the same auth/timeout/logging behavior as other requests and writes bytes reliably to disk.

### Migration Notes
- Imports:
  - Replace `src/essentials/services/api_service.dart` with `src/infrastructure/http/api_service.dart`.
  - Replace `src/essentials/cache/*` with `src/infrastructure/cache/*`.
  - Replace `src/essentials/config/api_response.dart` with `src/core/presentation/api_response.dart`.
  - Use `src/presentation/widgets/api_handler.dart` instead of any legacy `views/custom/api_handler.dart` path.
- Storage:
  - Replace `MemoryService` usage with `AppStorageService`. Initialize once in `main()`:
    Example: await AppStorageService.instance.initialize();
  - For direct token operations, prefer the facade:
    Example: read via `AppStorageService.instance.accessToken` and write via `AppStorageService.instance.setAccessToken('...')`.
- Caching:
  - Enable globally in `main()` by creating a `GetStorage`-backed cache store, composing a `CacheManager` with a key strategy and policy, then calling `ApiService.configureCache(manager)`.
  - To disable globally, call `ApiService.configureCache(null)`.
  - To disable globally: `ApiService.configureCache(null);`
- ApiService header behavior:
  - When you pass `headers`, you must include `Authorization` and `content-type` yourself. If you pass `null`, defaults are applied.
- UI state helpers:
  - `ApiStatus.fail` -> `ApiStatus.error`.
  - `ApiHandler` takes `successBuilder` (data-aware) and optional `loadingWidget`/`errorBuilder`; handle empty states in your success builder or parent widget.

### Security
- Tokens are now stored in platform secure storage by default; legacy migration kept in a separate method that can be removed in new projects.

---

## [0.1.0] - 2025-08-15
- Initial public template with GetX modules (auth, connections, locale, theme), basic theming, and `ActionPresenter`.

## [Unreleased]

### Added
- **Posts example module**: Replaced project-specific grades module with a universal example using JSONPlaceholder public API
  - Complete API pattern demonstration: `apiFetch() -> ApiResponse<T> -> ApiHandler<T>`
  - PostModel, PostService, PostViewModel, PostBindings, PostsPage, and view widgets
  - Fetches 100 blog posts from https://jsonplaceholder.typicode.com/posts
  - Pull-to-refresh support with RefreshIndicator
  - Material Design card-based UI with user badges
  - Documentation: docs/examples/api_pattern_example.md covering:
    - Architecture flow diagram
    - Step-by-step implementation guide
    - ApiResponse states and ApiHandler rendering logic
    - Complete code examples for all layers
    - POST request examples and error handling
    - Migration guide for adapting to custom APIs
- **Auth module tests**: 31 comprehensive tests for authentication
  - AuthViewModel (23 tests): initialization, state transitions, sign-in/sign-up/logout flows, token refresh, error handling, reactivity
  - AuthService (8 tests): mock sign-up, service instantiation, UserModel validation
  - All tests passing, bringing total test count from 171 to 202
- **Auth architecture documentation**: docs/architecture/auth_module.md covering:
  - Authentication states and transitions
  - Token lifecycle and refresh strategy
  - Mock authentication guide
  - Error handling patterns
  - Testing guidelines
  - Migration from mock to real API
- **Menu module refactoring**: Complete MVVM restructure with dual navigation patterns
  - MenuItem model for configurable menu items
  - MenuPageWithDrawer and MenuPageWithBottomNav ready to use
  - Sample pages (Dashboard, Settings, Profile) with clear mock warnings
  - LanguageDrawerItem and LogoutDrawerItem components
  - Menu module tests (10 tests) covering navigation and state
  - Documentation: docs/menu/README.md and docs/menu/NAVIGATION_TYPES.md
- **Theme module tests**: 92 comprehensive tests for theme management
  - ThemeViewModel tests covering initialization, theme switching, persistence
  - Widget tests for theme switcher UI components
- **Locale module tests**: 57 comprehensive tests for localization
  - LocalizationViewModel tests covering language selection and persistence
  - Language picker dialog widget tests
- PR3 (connections): Unit and widget tests for the connectivity module
  - ConnectionOverlay: renders connecting bar, offline card, and hides when connected
  - ConnectionHandler: shows connected content only when connected; retry tap triggers callback once
  - ConnectionViewModel: basic `isConnected` truth table
- Documentation: docs/architecture/connectivity_module.md covering states, ReachabilityService config, debounce, lifecycle re-check, theming (M3 tokens), and telemetry callbacks

### Changed
- Note: `connecting` is NOT treated as connected by `ConnectionViewModel.isConnected()` (landed in PR1; reiterated here for clarity in tests/docs)
- **Renamed MenuPage to MenuPageWithDrawer** for naming consistency with MenuPageWithBottomNav
- **Removed MenuPageWithBottomNavComplete** duplicate class; kept only MenuPageWithBottomNav

### Removed
- **Grades module**: Removed project-specific grades module (education domain) in favor of the universal posts example module
  - Deleted lib/src/modules/grades/ directory and all associated files
  - Removed `gradesUrl` configuration from api_config.dart
  - Updated InitialBindings to use PostBindings instead of GradeBindings

### Fixed
- **Color extension deprecation warnings**: Updated to use new Flutter Color API (a, r, g, b) instead of deprecated properties (alpha, red, green, blue)
  - Fixed withOpacity() deprecation in posts module using withValues(alpha: value)
- **Menu initialization bug**: Fixed MenuBindings to properly configure menu items on initialization

### Internal / Testability
- ConnectionViewModel: added optional `autoInit` constructor flag (default true) to skip platform connectivity initialization in tests. Does not affect production behavior
- MockAuthService created for testing AuthViewModel in isolation

### Migration Notes
- If you were using the grades module, replace it with your own custom module or adapt the posts example
- The posts module demonstrates the same API patterns (apiFetch -> ApiResponse -> ApiHandler)
- See docs/examples/api_pattern_example.md for a complete implementation guide
