import 'package:get/get.dart';
import '/src/core/presentation/actions/action_presenter.dart';
import '/src/modules/space/actions/space_actions.dart';
import '/src/modules/space/controllers/space_view_model.dart';
import '/src/modules/space/data/services/nasa_service.dart';

/// **SpaceBindings**
///
/// Dependency injection setup for the space module using GetX bindings.
///
/// **Why**
/// - Centralizes dependency registration for the space module.
/// - Uses lazy loading for efficient memory usage.
/// - Ensures proper dependency order (Service -> ViewModel -> Actions).
///
/// **Usage**
/// ```dart
/// GetPage(
///   name: '/space',
///   page: () => SpacePage(),
///   binding: SpaceBindings(),
/// )
/// ```
///
/// **Dependencies Registered**:
/// 1. [NasaService] - API communication layer for NASA endpoints
/// 2. [SpaceViewModel] - State management with apiFetch pattern
/// 3. [SpaceActions] - User action handlers with loading/error feedback
///
/// **Configuration**:
/// - [apiKey]: NASA API key (defaults to 'DEMO_KEY')
///
/// Get a free API key at https://api.nasa.gov for higher rate limits.
// ────────────────────────────────────────────────
class SpaceBindings implements Bindings {
  /// Optional NASA API key.
  ///
  /// Defaults to 'DEMO_KEY' which is rate-limited (30 requests/hour).
  /// Register at https://api.nasa.gov for a free unlimited key.
  final String apiKey;

  /// Constructor with optional API key configuration.
  SpaceBindings({this.apiKey = 'DEMO_KEY'});

  @override
  void dependencies() {
    // Register NasaService if not already registered.
    if (!Get.isRegistered<NasaService>()) {
      Get.lazyPut<NasaService>(() => NasaService(), fenix: true);
    }

    // Register SpaceViewModel as permanent to persist across navigation.
    // This prevents the ViewModel from being disposed when navigating away
    // from the space page, preserving the data and state.
    if (!Get.isRegistered<SpaceViewModel>()) {
      Get.put<SpaceViewModel>(
        SpaceViewModel(Get.find(), apiKey: apiKey),
        permanent: true,
      );
    }

    // Register SpaceActions for user interaction handling.
    if (!Get.isRegistered<SpaceActions>()) {
      Get.lazyPut<SpaceActions>(
        () => SpaceActions(Get.find(), ActionPresenter()),
        fenix: true,
      );
    }
  }

  /// **destroy**
  ///
  /// Cleans up and removes space module dependencies from GetX.
  ///
  /// **Why**
  /// - Called when user logs out to free resources and reset state
  /// - Ensures clean slate for next authentication
  /// - Prevents memory leaks from registered dependencies
  ///
  /// **What it does:**
  /// - Removes [SpaceActions] from GetX dependency injection
  /// - Removes [SpaceViewModel] from GetX dependency injection
  /// - Removes [NasaService] from GetX dependency injection
  /// - Resets space state for next login
  ///
  /// **Order matters:**
  /// - Actions are deleted first (depends on ViewModel)
  /// - ViewModel is deleted second (depends on Service)
  /// - Service is deleted last (has no dependencies)
  ///
  /// **Usage**
  /// ```dart
  /// // Called in AuthBindings._onNotAuthenticated()
  /// SpaceBindings.destroy();
  /// ```
  ///
  /// **Side Effects**
  /// - SpaceActions, SpaceViewModel, and NasaService will be deleted
  /// - Space state and cached data will be cleared
  /// - Next access will create fresh instances
  ///
  /// **Notes**
  /// - Uses `force: true` because SpaceViewModel has `permanent: true`
  /// - Safe to call multiple times (checks if registered first)
  // ────────────────────────────────────────────────
  static void destroy() {
    // Delete Actions first (depends on ViewModel)
    if (Get.isRegistered<SpaceActions>()) {
      Get.delete<SpaceActions>(force: true);
    }

    // Delete ViewModel second (depends on Service)
    if (Get.isRegistered<SpaceViewModel>()) {
      Get.delete<SpaceViewModel>(force: true);
    }

    // Delete Service last (independent)
    if (Get.isRegistered<NasaService>()) {
      Get.delete<NasaService>(force: true);
    }
  }
}
