import 'package:get/get.dart';
import '../controllers/connection_view_model.dart';
import '../services/reachability_service.dart';

/// **ConnectionBindings**
///
/// GetX bindings for connectivity-related dependencies.
///
/// Ensures [ConnectionViewModel] is available before any widgets that depend
/// on it (e.g., [ConnectionOverlay]) are built. Use this binding early in
/// app startup (e.g., in main() before runApp) since [ConnectionOverlay] is
/// wrapped outside GetMaterialApp where initialBinding would not yet run.
///
/// ## Usage
/// ```dart
/// void main() {
///   // Initialize connectivity bindings early
///   ConnectionBindings().dependencies();
///
///   runApp(
///     ConnectionOverlay(
///       child: GetMaterialApp(
///         home: HomePage(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// ## Custom Configuration
/// For custom reachability configuration:
/// ```dart
/// ConnectionBindings(
///   reachabilityService: ReachabilityService(
///     host: 'your-health-check.com',
///     timeout: Duration(seconds: 5),
///   ),
/// ).dependencies();
/// ```
class ConnectionBindings extends Bindings {
  /// Custom reachability service (optional).
  final ReachabilityService? reachabilityService;

  /// Callback when device goes offline (optional).
  final void Function()? onWentOffline;

  /// Callback when device comes back online with offline duration (optional).
  final void Function(Duration offlineDuration)? onBackOnline;

  /// Creates a new [ConnectionBindings] instance.
  ///
  /// - [reachabilityService]: Custom reachability probe service.
  /// - [onWentOffline]: Called when device loses connectivity.
  /// - [onBackOnline]: Called when device regains connectivity.
  ConnectionBindings({
    this.reachabilityService,
    this.onWentOffline,
    this.onBackOnline,
  });

  @override
  void dependencies() {
    if (!Get.isRegistered<ConnectionViewModel>()) {
      Get.put(
        ConnectionViewModel(
          reachability: reachabilityService,
          onWentOfflineCallback: onWentOffline,
          onBackOnlineCallback: onBackOnline,
        ),
        permanent: true,
      );
    }
  }
}
