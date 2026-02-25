# Quick Start Guide

Complete quick start examples for all Fifty Flutter Kit domains. For a minimal overview, see the [root README](../README.md#quick-start).

---

## Design System

The design system is a three-package pipeline: **tokens** define the raw values, **theme** converts them into Flutter `ThemeData`, and **ui** provides ready-made components styled by the theme.

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
```

### Using Design Tokens

Access colors, typography, spacing, and motion constants directly:

```dart
// Colors
final primary = FiftyColors.primary;
final surface = FiftyColors.surface;

// Typography
final heading = FiftyTypography.heading1;
final body = FiftyTypography.body;

// Spacing (4px base grid)
final padding = FiftySpacing.md;   // 16.0
final gap = FiftySpacing.sm;       // 8.0

// Motion
final duration = FiftyMotion.normal;
final curve = FiftyMotion.easeOut;
```

### Applying the Theme

Wrap your app in the Fifty theme for automatic light/dark mode support:

```dart
MaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
  home: MyHomePage(),
);
```

### Using UI Components

Components are styled by the active theme -- no manual styling needed:

```dart
FiftyButton(
  label: 'Submit',
  onPressed: () {},
);
```

Learn more: [fifty_tokens](../packages/fifty_tokens/) | [fifty_theme](../packages/fifty_theme/) | [fifty_ui](../packages/fifty_ui/)

---

## Forms

`fifty_forms` provides a form building system with built-in validation, multi-step wizards, dynamic field arrays, and draft auto-save. All fields are FDL v2 styled.

```dart
import 'package:fifty_forms/fifty_forms.dart';
```

### Building a Form

```dart
// Create form controller
final controller = FiftyFormController();

// Build form with validation
FiftyForm(
  controller: controller,
  child: Column(
    children: [
      FiftyTextField(
        name: 'email',
        validators: [Validators.required(), Validators.email()],
      ),
      FiftyButton(
        label: 'Submit',
        onPressed: () => controller.submit(),
      ),
    ],
  ),
);
```

The controller manages field state, validation, and submission. Validators compose -- stack as many as needed on any field.

Learn more: [fifty_forms](../packages/fifty_forms/)

---

## Utilities

`fifty_utils` is a collection of pure Dart/Flutter extensions and helpers. No UI dependencies -- works anywhere Dart runs.

```dart
import 'package:fifty_utils/fifty_utils.dart';
```

### DateTime Extensions

```dart
final date = DateTime.now();
print(date.timeAgo());             // "2 hours ago"
print(date.format('yyyy-MM-dd'));  // "2024-10-28"
```

### Responsive Design

```dart
if (ResponsiveUtils.isMobile(context)) {
  // Mobile layout
}
```

### API State Management

`ApiResponse` is an immutable state container for async operations. `apiFetch()` emits a loading/data/error stream:

```dart
apiFetch(() => api.getUser()).listen((state) {
  if (state.isLoading) showSpinner();
  if (state.hasData) showUser(state.data!);
  if (state.hasError) showError(state.error);
});
```

Learn more: [fifty_utils](../packages/fifty_utils/)

---

## Connectivity

`fifty_connectivity` monitors network state with DNS and HTTP reachability probes. It provides both a reactive ViewModel and a ready-made overlay widget.

```dart
import 'package:fifty_connectivity/fifty_connectivity.dart';
```

### Setup

```dart
ConnectivityConfig.initialize(
  dnsLookupHost: 'google.com',
  httpCheckUrl: 'https://www.google.com',
);
```

### Automatic UI Feedback

Wrap your app to show an overlay when the device goes offline:

```dart
ConnectionOverlay(
  child: YourApp(),
);
```

### Programmatic Access

```dart
final connVM = Get.find<ConnectionViewModel>();
if (connVM.isOnline.value) {
  // Network available
}
```

Learn more: [fifty_connectivity](../packages/fifty_connectivity/)

---

## Printing

`fifty_printing_engine` handles ESC/POS thermal printing over Bluetooth and WiFi. Discover printers, connect, build receipts, and print.

```dart
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
```

### Discover and Print

```dart
// Discover printers
final bluetoothPrinters = await PrinterDiscovery.discoverBluetooth();
final wifiPrinters = await PrinterDiscovery.discoverWifi();

// Connect and print
final printer = PrinterConnection(device: selectedPrinter);
await printer.connect();
await printer.printReceipt(receiptData);
await printer.disconnect();
```

Learn more: [fifty_printing_engine](../packages/fifty_printing_engine/)

---

## Architecture (MVVM + Actions)

The recommended pattern for apps built with the Fifty Flutter Kit. The `mvvm_actions` template provides a complete scaffold -- fork it as your starting point.

```dart
import 'package:fifty_utils/fifty_utils.dart';
```

### ViewModel with Reactive State

```dart
class UserViewModel extends GetxController {
  final usersState = ApiResponse<List<User>>.idle().obs;

  void loadUsers() {
    apiFetch(() => userService.getUsers())
      .listen((state) => usersState.value = state);
  }
}
```

### View with Reactive Binding

```dart
class UserListView extends GetView<UserViewModel> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.usersState.value;
      if (state.isLoading) return CircularProgressIndicator();
      if (state.hasData) return UserList(users: state.data!);
      return ErrorWidget(state.error);
    });
  }
}
```

The **Actions** layer sits between View and ViewModel, orchestrating UX flows (navigation, dialogs, error handling) so ViewModels stay pure state containers.

Learn more: [mvvm_actions template](../templates/mvvm_actions/)
