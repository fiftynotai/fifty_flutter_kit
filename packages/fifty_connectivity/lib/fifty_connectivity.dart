/// Fifty Connectivity - Network connectivity monitoring for Flutter
///
/// This package provides intelligent network connectivity monitoring with
/// DNS/HTTP reachability probing. Part of the Fifty ecosystem.
///
/// ## Features
///
/// - **Connectivity Monitoring**: Real-time network state tracking
/// - **Reachability Probing**: DNS lookup and HTTP health checks
/// - **Reactive State**: GetX-based reactive connection state
/// - **UI Widgets**: Ready-to-use overlay and handler widgets
/// - **Configurable**: Customizable labels, navigation, and theming
///
/// ## Quick Start
///
/// ```dart
/// void main() {
///   // Initialize bindings
///   ConnectionBindings().dependencies();
///
///   // Configure navigation (optional)
///   ConnectivityConfig.navigateOff = (route) async {
///     Get.offAllNamed(route);
///   };
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
/// ## Classes
///
/// - [ConnectivityConfig] - Global configuration for labels and navigation
/// - [ReachabilityService] - DNS/HTTP reachability probe service
/// - [ConnectionViewModel] - GetX controller for connection state
/// - [ConnectionActions] - UX orchestration singleton
/// - [ConnectionOverlay] - Overlay widget for connection status
/// - [ConnectionHandler] - Switcher widget based on connection state
/// - [ConnectivityCheckerSplash] - Splash screen with connectivity check
/// - [ConnectionBindings] - GetX bindings for dependency injection
///
/// ## Connectivity Types
///
/// - [ConnectivityType.wifi] - Connected via Wi-Fi
/// - [ConnectivityType.mobileData] - Connected via cellular data
/// - [ConnectivityType.connecting] - Probing connectivity
/// - [ConnectivityType.disconnected] - No network transport
/// - [ConnectivityType.noInternet] - Transport available but no internet
library;

// Config
export 'src/config/connectivity_config.dart';

// Services
export 'src/services/reachability_service.dart';

// Controllers
export 'src/controllers/connection_view_model.dart';

// Actions
export 'src/actions/connection_actions.dart';

// Widgets
export 'src/widgets/connection_overlay.dart';
export 'src/widgets/connection_handler.dart';
export 'src/widgets/connectivity_checker_splash.dart';

// Bindings
export 'src/bindings/connection_bindings.dart';
