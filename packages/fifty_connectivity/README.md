# Fifty Connectivity

Network connectivity monitoring with intelligent reachability probing (DNS/HTTP). Part of the Fifty Flutter Kit.

## Features

- **Real-time Connectivity Monitoring** - Track network state changes instantly
- **Intelligent Reachability Probing** - DNS lookup and HTTP health checks
- **Reactive State Management** - GetX-based reactive connection state
- **Ready-to-use UI Widgets** - Overlay, handler, and splash widgets
- **Highly Configurable** - Customizable labels, navigation, and theming
- **FDL Styled** - Fifty Design Language Kinetic Brutalism aesthetic

## Installation

```yaml
dependencies:
  fifty_connectivity:
    path: ../fifty_connectivity
```

## Quick Start

### 1. Initialize Bindings

```dart
void main() {
  // Initialize connectivity bindings early
  ConnectionBindings().dependencies();

  runApp(MyApp());
}
```

### 2. Configure Navigation (Optional)

```dart
// Set up navigation callback
ConnectivityConfig.navigateOff = (route) async {
  Get.offAllNamed(route);
};
```

### 3. Wrap Your App with ConnectionOverlay

```dart
runApp(
  ConnectionOverlay(
    child: GetMaterialApp(
      home: HomePage(),
    ),
  ),
);
```

## Usage

### ConnectionOverlay

Shows a status overlay when connectivity changes:

```dart
ConnectionOverlay(
  child: YourPage(),
)
```

### ConnectionHandler

Renders different widgets based on connection state:

```dart
ConnectionHandler(
  connectedWidget: YourMainContent(),
  tryAgainAction: () => ConnectionActions.instance.checkConnectivity(),
  // Optional custom widgets
  onConnectingWidget: CustomLoadingWidget(),
  notConnectedWidget: CustomOfflineWidget(),
)
```

### ConnectivityCheckerSplash

Splash screen that checks connectivity before navigation:

```dart
// Basic usage
ConnectivityCheckerSplash()

// Custom configuration
ConnectivityCheckerSplash(
  nextRouteName: '/home',
  delayInSeconds: 2,
  logoBuilder: (context) => SvgPicture.asset('assets/logo.svg'),
)
```

### Access Connection State

```dart
// Get the ViewModel
final vm = Get.find<ConnectionViewModel>();

// Check connection status
if (vm.isConnected()) {
  // Online
}

// React to changes
Obx(() => Text(vm.connectionType.value.name));

// Get offline duration
Obx(() => Text('Offline: ${vm.dialogTimer.value}'));
```

## Configuration

### Labels (Localization)

```dart
// Configure labels for localization
ConnectivityConfig.labelSignalLost = 'SIGNAL_LOST'.tr;
ConnectivityConfig.labelTryAgain = 'TRY_AGAIN'.tr;
ConnectivityConfig.labelEstablishingUplink = 'CONNECTING'.tr;
ConnectivityConfig.labelReconnecting = 'RECONNECTING'.tr;
```

### Navigation

```dart
// Configure navigation callback
ConnectivityConfig.navigateOff = (route) async {
  Get.offAllNamed(route);
};
```

### Splash Screen

```dart
// Set default splash configuration
ConnectivityConfig.logoBuilder = (context) => Image.asset('assets/logo.png');
ConnectivityConfig.defaultNextRoute = '/home';
ConnectivityConfig.splashDelaySeconds = 2;
```

### Custom Reachability

```dart
ConnectionBindings(
  reachabilityService: ReachabilityService(
    host: 'your-api.com',
    timeout: Duration(seconds: 5),
    strategy: ReachabilityStrategy.httpHead,
    healthEndpoint: Uri.parse('https://your-api.com/health'),
  ),
).dependencies();
```

### Telemetry Callbacks

```dart
ConnectionBindings(
  onWentOffline: () {
    analytics.logEvent('connection_lost');
  },
  onBackOnline: (duration) {
    analytics.logEvent('connection_restored', {'offline_seconds': duration.inSeconds});
  },
).dependencies();
```

## Connectivity Types

| Type | Description |
|------|-------------|
| `wifi` | Connected via Wi-Fi |
| `mobileData` | Connected via cellular data |
| `connecting` | Probing connectivity |
| `disconnected` | No network transport |
| `noInternet` | Transport available but no internet reachability |

## API Reference

### ConnectivityConfig

Global configuration class:

```dart
class ConnectivityConfig {
  // Labels
  static String labelSignalLost;
  static String labelEstablishingUplink;
  static String labelReconnecting;
  static String labelRetryConnection;
  static String labelTryAgain;
  static String labelOfflineFor;
  static String labelAttemptingRestore;
  static String labelConnectionLost;
  static String labelNoInternetSemantics;
  static String labelUplinkActive;

  // Navigation
  static Future<void> Function(String route)? navigateOff;

  // Splash
  static Widget Function(BuildContext context)? logoBuilder;
  static String defaultNextRoute;
  static int splashDelaySeconds;

  // Reset all to defaults
  static void reset();
}
```

### ConnectionViewModel

GetX controller for connection state:

```dart
class ConnectionViewModel extends GetxController {
  Rx<ConnectivityType> connectionType;
  RxString dialogTimer;

  bool isConnected();
  Future<void> getConnectivity();
}
```

### ConnectionActions

Singleton for UX orchestration:

```dart
class ConnectionActions {
  static ConnectionActions get instance;

  Future<void> checkConnectivity();
  Future<void> initSplash(String nextRouteString, int delayInSeconds);
  void refreshData();
  void onConnectionLost();
}
```

## Dependencies

- `flutter`
- `connectivity_plus` - Platform connectivity detection
- `get` - State management and dependency injection
- `fifty_tokens` - Design tokens
- `fifty_ui` - UI components
- `fifty_utils` - Utility extensions

## License

MIT License - see LICENSE file for details.
