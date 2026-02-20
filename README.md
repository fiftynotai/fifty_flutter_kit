# Fifty Flutter Kit

A comprehensive Flutter/Dart toolkit providing design tokens, theming, UI components, architecture patterns, printing capabilities, and utility functions.

## Packages

| Package | Version | Description |
|---------|---------|-------------|
| [fifty_tokens](packages/fifty_tokens/) | v1.0.0 | Design tokens (colors, typography, spacing) |
| [fifty_theme](packages/fifty_theme/) | v1.0.0 | Theme generation and management |
| [fifty_ui](packages/fifty_ui/) | v1.0.0 | Component library (buttons, cards, inputs) |
| [fifty_forms](packages/fifty_forms/) | v0.1.0 | Form building with validation, multi-step wizards, and draft persistence |
| [fifty_utils](packages/fifty_utils/) | v0.1.0 | Pure utilities (DateTime, responsive, state) |
| [fifty_cache](packages/fifty_cache/) | v0.1.0 | Multi-tier caching with TTL support |
| [fifty_storage](packages/fifty_storage/) | v0.1.0 | Key-value storage abstraction |
| [fifty_connectivity](packages/fifty_connectivity/) | v0.1.0 | Network connectivity monitoring |
| [fifty_audio_engine](packages/fifty_audio_engine/) | v0.8.0 | Audio playback and recording |
| [fifty_speech_engine](packages/fifty_speech_engine/) | v0.1.0 | Text-to-speech and speech-to-text |
| [fifty_narrative_engine](packages/fifty_narrative_engine/) | v0.1.0 | Narrative processing and word bank |
| [fifty_world_engine](packages/fifty_world_engine/) | v3.0.0 | Cross-platform maps integration |
| [fifty_printing_engine](packages/fifty_printing_engine/) | v1.0.0 | Multi-printer ESC/POS printing (Bluetooth & WiFi) |
| [fifty_skill_tree](packages/fifty_skill_tree/) | v0.2.0 | Skill tree visualization and progression system |
| [fifty_achievement_engine](packages/fifty_achievement_engine/) | v0.1.1 | Achievement tracking and unlocking system |

## Apps

| App | Description |
|-----|-------------|
| [fifty_demo](apps/fifty_demo/) | Demo app showcasing all packages |

## Templates

Project scaffolds for rapid development. Clone and customize.

| Template | Description | Pattern |
|----------|-------------|---------|
| [mvvm_actions](templates/mvvm_actions/) | Full-featured app scaffold | MVVM + Actions |

Templates depend on the packages above but are meant to be forked, not imported.

## Architecture

```
fifty_flutter_kit/
  packages/
    fifty_tokens/           # Design foundation
    fifty_theme/            # Theme layer (depends on tokens)
    fifty_ui/               # Components (depends on theme)
    fifty_forms/            # Form building system
    fifty_utils/            # Pure utilities (no dependencies)
    fifty_cache/            # Caching layer
    fifty_storage/          # Storage abstraction
    fifty_connectivity/     # Network monitoring
    fifty_audio_engine/     # Audio playback
    fifty_speech_engine/    # Speech services
    fifty_narrative_engine/ # Narrative processing
    fifty_world_engine/     # Maps integration
    fifty_printing_engine/  # ESC/POS printing
    fifty_skill_tree/       # Skill tree engine
    fifty_achievement_engine/ # Achievement system
  apps/
    fifty_demo/             # Demo application
  templates/
    mvvm_actions/           # Full app template (fork, don't import)
```

### Dependency Graph

```
fifty_tokens (foundation)
     |
fifty_theme
     |
fifty_ui
     |
[fifty_forms, fifty_skill_tree, fifty_achievement_engine] <-- consume FDL
     |
fifty_utils (foundation)
     |
[mvvm_actions template] <-- fifty_storage, fifty_cache, fifty_connectivity

fifty_printing_engine (standalone)
```

## Installation

Add packages to your `pubspec.yaml`:

### Using Git (Development)

```yaml
dependencies:
  fifty_tokens:
    git:
      url: https://github.com/fiftynotai/fifty_flutter_kit
      path: packages/fifty_tokens

  fifty_utils:
    git:
      url: https://github.com/fiftynotai/fifty_flutter_kit
      path: packages/fifty_utils
```

### Using Path (Monorepo)

```yaml
dependencies:
  fifty_tokens:
    path: ../fifty_tokens

  fifty_utils:
    path: ../fifty_utils
```

## Quick Start

### Design System

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';

// Use design tokens
final primary = FiftyColors.primary;
final heading = FiftyTypography.heading1;
final padding = FiftySpacing.md;

// Apply theme
MaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
);

// Use components
FiftyButton(
  label: 'Submit',
  onPressed: () {},
);
```

### Forms

```dart
import 'package:fifty_forms/fifty_forms.dart';

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

### Utilities

```dart
import 'package:fifty_utils/fifty_utils.dart';

// DateTime extensions
final date = DateTime.now();
print(date.timeAgo()); // "2 hours ago"
print(date.format('yyyy-MM-dd')); // "2024-10-28"

// Responsive design
if (ResponsiveUtils.isMobile(context)) {
  // Mobile layout
}

// API state management
apiFetch(() => api.getUser()).listen((state) {
  if (state.isLoading) showSpinner();
  if (state.hasData) showUser(state.data!);
  if (state.hasError) showError(state.error);
});
```

### Architecture (MVVM + Actions)

For complete architecture patterns, see the [mvvm_actions template](templates/mvvm_actions/).

```dart
// Example from mvvm_actions template
import 'package:fifty_utils/fifty_utils.dart';

// ViewModel with reactive state
class UserViewModel extends GetxController {
  final usersState = ApiResponse<List<User>>.idle().obs;

  void loadUsers() {
    apiFetch(() => userService.getUsers())
      .listen((state) => usersState.value = state);
  }
}

// View with Obx reactive binding
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

### Connectivity Monitoring

```dart
import 'package:fifty_connectivity/fifty_connectivity.dart';

// Configure connectivity monitoring
ConnectivityConfig.initialize(
  dnsLookupHost: 'google.com',
  httpCheckUrl: 'https://www.google.com',
);

// Use ConnectionOverlay for automatic UI feedback
ConnectionOverlay(
  child: YourApp(),
);

// Or check status programmatically
final connVM = Get.find<ConnectionViewModel>();
if (connVM.isOnline.value) {
  // Network available
}
```

### Printing (ESC/POS)

```dart
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

// Discover printers
final bluetoothPrinters = await PrinterDiscovery.discoverBluetooth();
final wifiPrinters = await PrinterDiscovery.discoverWifi();

// Connect and print
final printer = PrinterConnection(device: selectedPrinter);
await printer.connect();
await printer.printReceipt(receiptData);
await printer.disconnect();
```

## Package Details

### fifty_utils

Pure Dart/Flutter utilities with zero external dependencies (except `intl`).

- **DateTime Extensions** - `isToday`, `isYesterday`, `format()`, `timeAgo()`
- **Duration Extensions** - `format()`, `formatCompact()`
- **Color Extensions** - `HexColor.fromHex()`, `toHex()`
- **ResponsiveUtils** - Device detection, breakpoints, responsive values
- **ApiResponse** - Immutable async state container
- **apiFetch()** - Stream-based API fetching

### fifty_forms

Production-ready form building system with FDL v2 compliance.

- **FiftyFormController** - Centralized form state management
- **25 Built-in Validators** - Required, email, min/max length, regex, and more
- **10 Field Types** - Text, checkbox, switch, dropdown, radio, date, time, slider, range, autocomplete
- **FiftyMultiStepForm** - Wizard-style multi-step forms with navigation
- **FiftyFormArray** - Dynamic form fields (add/remove)
- **DraftManager** - Auto-save and restore form drafts

### mvvm_actions (Template)

Full-featured app template using MVVM + Actions architecture. **Fork this, don't import.**

- **GetX Integration** - Reactive state management
- **Pre-built Modules** - Auth, connectivity, locale, theme
- **Actions Pattern** - Standardized UX handling
- **Infrastructure** - HTTP client, caching, storage

### fifty_cache / fifty_storage

Data persistence layers.

- **Multi-tier caching** - Memory + disk with TTL
- **Storage abstraction** - Platform-agnostic key-value storage

### fifty_connectivity

Network connectivity monitoring with intelligent reachability probing.

- **ReachabilityService** - DNS and HTTP connectivity checks
- **ConnectionViewModel** - Reactive connection state management
- **ConnectionOverlay** - Automatic offline/online UI overlay
- **ConnectivityCheckerSplash** - Splash screen with connectivity check

### fifty_printing_engine

Multi-printer ESC/POS printing engine supporting Bluetooth and WiFi printers.

- **PrinterDiscovery** - Scan for Bluetooth and WiFi printers
- **PrinterConnection** - Connection management with auto-reconnect
- **ReceiptBuilder** - Fluent API for building receipts
- **ESC/POS Commands** - Full command support including images and barcodes

### fifty_skill_tree

Skill tree visualization and progression system for gamification.

- **SkillTreeController** - Manage skill nodes and progression
- **SkillTreeView** - Visual tree rendering with connections
- **Unlock Conditions** - Prerequisite-based skill unlocking

### fifty_achievement_engine

Achievement tracking and unlocking system for gamification.

- **AchievementController** - Track and unlock achievements
- **Progress Tracking** - Incremental achievement progress
- **Event System** - Achievement unlock notifications

## Development

### Running Tests

```bash
# All packages
flutter test packages/*/test/

# Specific package
cd packages/fifty_utils
flutter test
```

### Code Generation

```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## License

MIT License - see individual packages for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following the coding guidelines
4. Run tests
5. Submit a pull request

---

Built with Fifty Design Language (FDL)
