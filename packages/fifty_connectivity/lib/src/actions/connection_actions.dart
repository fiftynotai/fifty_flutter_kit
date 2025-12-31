import 'package:get/get.dart';
import '../config/connectivity_config.dart';
import '../controllers/connection_view_model.dart';

/// **ConnectionActions**
///
/// Singleton class to manage connection-related actions.
///
/// This class interacts with the [ConnectionViewModel] to check and update
/// the connectivity state and handles navigation from the splash screen.
///
/// ## Why
/// - Provides a centralized UX orchestration layer for connectivity actions.
/// - Decoupled from specific navigation implementations via [ConnectivityConfig].
///
/// ## Usage
/// ```dart
/// // Check connectivity
/// await ConnectionActions.instance.checkConnectivity();
///
/// // Initialize splash and navigate
/// await ConnectionActions.instance.initSplash('/home', 2);
/// ```
///
/// ## Configuration
/// Set [ConnectivityConfig.navigateOff] to enable navigation:
/// ```dart
/// ConnectivityConfig.navigateOff = (route) async {
///   Get.offAllNamed(route);
/// };
/// ```
class ConnectionActions {
  /// Singleton instance of [ConnectionActions] to ensure it's initialized only once.
  static final ConnectionActions _mInstance = ConnectionActions._();

  /// Public getter to access the singleton instance.
  static ConnectionActions get instance => _mInstance;

  /// Reference to the [ConnectionViewModel] that manages connectivity logic.
  late final ConnectionViewModel _connectionViewModel;

  /// Whether the singleton has been initialized.
  bool _initialized = false;

  /// Private constructor to initialize the singleton.
  ConnectionActions._();

  /// Ensures the [ConnectionViewModel] is available.
  void _ensureInitialized() {
    if (!_initialized) {
      if (Get.isRegistered<ConnectionViewModel>()) {
        _connectionViewModel = Get.find<ConnectionViewModel>();
        _initialized = true;
      } else {
        throw StateError(
          'ConnectionViewModel not registered. '
          'Call ConnectionBindings().dependencies() before using ConnectionActions.',
        );
      }
    }
  }

  /// Checks and updates the connectivity state using [ConnectionViewModel].
  ///
  /// This method calls [ConnectionViewModel.getConnectivity] to refresh
  /// the current connectivity status.
  Future<void> checkConnectivity() async {
    _ensureInitialized();
    await _connectionViewModel.getConnectivity();
  }

  /// Initializes the splash screen and navigates to the next route.
  ///
  /// This method waits for the specified delay, checks the connectivity,
  /// and navigates to the [nextRouteString] if [ConnectivityConfig.navigateOff]
  /// is configured.
  ///
  /// - [nextRouteString]: The route to navigate after initialization.
  /// - [delayInSeconds]: Time in seconds to delay before navigation.
  ///
  /// **Note:** If [ConnectivityConfig.navigateOff] is null, navigation is skipped.
  Future<void> initSplash(String nextRouteString, int delayInSeconds) async {
    _ensureInitialized();

    // Wait for the specified delay
    await Future<void>.delayed(Duration(seconds: delayInSeconds));

    // Check connectivity after the delay
    await checkConnectivity();

    // Navigate to the next route if navigation is configured
    final navigateOff = ConnectivityConfig.navigateOff;
    if (navigateOff != null) {
      await navigateOff(nextRouteString);
    }
  }

  /// Refreshes data when needed.
  ///
  /// This method is a placeholder for future logic to refresh relevant data.
  /// Override or extend this class to add custom refresh logic.
  void refreshData() {
    // Placeholder for custom refresh logic
  }

  /// Handles logic when the connection is lost.
  ///
  /// This method is a placeholder for future logic when a connection is lost.
  /// Override or extend this class to add custom handling.
  void onConnectionLost() {
    // Placeholder for custom connection lost handling
  }

  /// Resets the singleton for testing purposes.
  ///
  /// This clears the initialization state so the singleton can be
  /// re-initialized with a fresh [ConnectionViewModel].
  static void resetForTesting() {
    _mInstance._initialized = false;
  }
}
