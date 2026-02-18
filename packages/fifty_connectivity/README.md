# Fifty Connectivity

Network connectivity monitoring with intelligent reachability probing (DNS/HTTP). Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Features

- **Real-time Connectivity Monitoring** - Track network state changes instantly via `connectivity_plus` stream subscription
- **Intelligent Reachability Probing** - DNS lookup and HTTP HEAD/GET health checks to detect captive portals and offline routers
- **Granular Connection States** - Distinguishes transport-level disconnection from internet-level reachability failure
- **Reactive State Management** - GetX-based reactive `connectionType` observable consumed across the widget tree
- **Offline Duration Tracking** - Tracks and formats elapsed offline time as a reactive timer string
- **Telemetry Callbacks** - `onWentOffline` and `onBackOnline` hooks for analytics integration
- **App Lifecycle Awareness** - Re-checks connectivity automatically on app resume
- **Ready-to-use UI Widgets** - Overlay, handler, and splash widgets for common connection UX patterns
- **Highly Configurable** - Customizable labels, navigation callback, and splash screen builder
- **FDL Styled** - Fifty Design Language Kinetic Brutalism aesthetic in all UI widgets

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_connectivity:
    path: ../fifty_connectivity
```

---

## Quick Start

```dart
void main() {
  // 1. Register bindings before runApp
  ConnectionBindings().dependencies();

  // 2. Configure navigation
  ConnectivityConfig.navigateOff = (route) async {
    Get.offAllNamed(route);
  };

  // 3. Wrap app with ConnectionOverlay
  runApp(
    ConnectionOverlay(
      child: GetMaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    UI Layer                          │
│  ConnectionOverlay  ConnectionHandler  Connectivity  │
│                                        CheckerSplash │
└────────────────────┬────────────────────────────────┘
                     │ observes
┌────────────────────▼────────────────────────────────┐
│               ConnectionActions                      │
│         (UX orchestration singleton)                 │
└────────────────────┬────────────────────────────────┘
                     │ drives
┌────────────────────▼────────────────────────────────┐
│            ConnectionViewModel (GetxController)      │
│  connectionType: Rx<ConnectivityType>                │
│  dialogTimer: RxString                               │
└──────────┬──────────────────────┬───────────────────┘
           │ listens               │ probes
┌──────────▼──────┐    ┌──────────▼────────────────────┐
│ connectivity_   │    │       ReachabilityService       │
│ plus stream     │    │  (DNS lookup or HTTP HEAD/GET)  │
└─────────────────┘    └───────────────────────────────┘
```

### Core Components

| Component | Description |
|-----------|-------------|
| `ConnectionViewModel` | GetX controller; single source of truth for `ConnectivityType` and offline timer |
| `ReachabilityService` | Injectable probe service; performs DNS lookup or HTTP HEAD to confirm internet access |
| `ConnectionBindings` | GetX `Bindings` subclass; registers `ConnectionViewModel` as a permanent singleton |
| `ConnectionActions` | Singleton UX orchestration layer; drives connectivity checks and splash navigation |
| `ConnectivityConfig` | Static configuration class for labels, navigation callback, and splash settings |
| `ConnectionOverlay` | Widget that renders an FDL-styled status overlay on connectivity change |
| `ConnectionHandler` | Widget that swaps content based on current connection state |
| `ConnectivityCheckerSplash` | Splash screen that probes connectivity before navigating to the next route |

---

## API Reference

### ConnectivityType

High-level connectivity states consumed by all connection-aware widgets:

| Value | Description |
|-------|-------------|
| `wifi` | Connected via Wi-Fi (reachability confirmed) |
| `mobileData` | Connected via cellular data (reachability confirmed) |
| `connecting` | Transitional state while probing reachability |
| `disconnected` | No network transport reported by the OS |
| `noInternet` | Transport available but internet not reachable (DNS/route failure) |

### ConnectionViewModel

```dart
class ConnectionViewModel extends GetxController {
  /// Observable current connection type.
  Rx<ConnectivityType> connectionType;

  /// Formatted elapsed offline duration (e.g., "00:01:23").
  RxString dialogTimer;

  /// Returns true when wifi or mobileData.
  bool isConnected();

  /// Manually trigger a connectivity check.
  Future<void> getConnectivity();
}
```

### ReachabilityService

```dart
class ReachabilityService {
  ReachabilityService({
    String host = 'google.com',
    Duration timeout = const Duration(seconds: 3),
    ReachabilityStrategy strategy = ReachabilityStrategy.dnsLookup,
    Uri? healthEndpoint,
    GetConnect? http,
  });

  /// Returns true when internet appears reachable.
  /// On Web platforms, always returns true (DNS sockets unavailable).
  Future<bool> isReachable();
}

enum ReachabilityStrategy {
  dnsLookup,  // Resolve DNS host (default)
  httpHead,   // HTTP HEAD request to healthEndpoint (falls back to GET on 405)
}
```

### ConnectionBindings

```dart
class ConnectionBindings extends Bindings {
  ConnectionBindings({
    ReachabilityService? reachabilityService,
    void Function()? onWentOffline,
    void Function(Duration offlineDuration)? onBackOnline,
  });

  @override
  void dependencies();
}
```

### ConnectionActions

```dart
class ConnectionActions {
  static ConnectionActions get instance;

  /// Refresh the current connectivity state.
  Future<void> checkConnectivity();

  /// Wait [delayInSeconds], check connectivity, then navigate to [nextRouteString].
  Future<void> initSplash(String nextRouteString, int delayInSeconds);

  /// Placeholder for custom data refresh logic.
  void refreshData();

  /// Placeholder for custom connection-lost handling.
  void onConnectionLost();
}
```

### ConnectivityConfig

```dart
class ConnectivityConfig {
  // Labels (localize by assigning before use)
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

  // Splash screen
  static Widget Function(BuildContext context)? logoBuilder;
  static String defaultNextRoute;
  static int splashDelaySeconds;

  /// Reset all values to defaults (useful in tests).
  static void reset();
}
```

---

## Usage Patterns

### ConnectionOverlay

Wrap any subtree to show an FDL-styled status banner when connectivity changes:

```dart
ConnectionOverlay(
  child: YourPage(),
)
```

### ConnectionHandler

Render different widgets based on live connection state:

```dart
ConnectionHandler(
  connectedWidget: YourMainContent(),
  tryAgainAction: () => ConnectionActions.instance.checkConnectivity(),
  // Optional overrides
  onConnectingWidget: CustomLoadingWidget(),
  notConnectedWidget: CustomOfflineWidget(),
)
```

### ConnectivityCheckerSplash

Splash screen that checks connectivity before navigating:

```dart
// Basic
ConnectivityCheckerSplash()

// Custom configuration
ConnectivityCheckerSplash(
  nextRouteName: '/home',
  delayInSeconds: 2,
  logoBuilder: (context) => SvgPicture.asset('assets/logo.svg'),
)
```

### Accessing Connection State Reactively

```dart
final vm = Get.find<ConnectionViewModel>();

// Imperative check
if (vm.isConnected()) { /* online */ }

// Reactive binding
Obx(() => Text(vm.connectionType.value.name));

// Offline duration
Obx(() => Text('Offline: ${vm.dialogTimer.value}'));
```

### Custom Reachability Probe

Use an HTTP health endpoint instead of DNS:

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
    analytics.logEvent('connection_restored', {
      'offline_seconds': duration.inSeconds,
    });
  },
).dependencies();
```

### Localization

```dart
ConnectivityConfig.labelSignalLost = 'SIGNAL_LOST'.tr;
ConnectivityConfig.labelTryAgain = 'TRY_AGAIN'.tr;
ConnectivityConfig.labelEstablishingUplink = 'CONNECTING'.tr;
ConnectivityConfig.labelReconnecting = 'RECONNECTING'.tr;
```

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     | Requires `ACCESS_NETWORK_STATE` permission |
| iOS      | Yes     |       |
| macOS    | Yes     |       |
| Linux    | Yes     |       |
| Windows  | Yes     |       |
| Web      | Partial | Reachability probing returns `true` optimistically; DNS sockets unavailable |

### Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **`fifty_tokens`** - All UI widgets consume FDL design tokens for color, spacing, and typography, ensuring visual consistency with the Kinetic Brutalism aesthetic
- **`fifty_ui`** - Connection overlay and handler widgets use FDL base components and theming primitives
- **`fifty_utils`** - Duration formatting for the offline timer uses FDL utility extensions

---

## Version

**Current:** 0.1.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
