# Fifty Flutter Kit

A comprehensive Flutter/Dart toolkit providing design tokens, theming, UI components, forms, utilities, game engines, printing, and architecture patterns.

This toolkit is born from close to a decade of building Flutter and Dart applications professionally. It is a curated collection of the packages and patterns I reach for most often -- not everything I know, but the essentials, battle-tested across real projects and refined over the years. Rather than keeping these as scattered internal utilities and tribal knowledge, I wrote them down as properly published, reusable packages and open-sourced them for the Flutter community.

The kit spans two domains: **app development** packages (design system, forms, caching, storage, connectivity, printing, architecture templates) for production applications, and **game development** packages (audio engine, speech engine, narrative engine, world engine, skill trees, achievements) for Flutter-based games and interactive experiences. Pick what you need -- they work independently or together.

**By [Fifty.dev](https://github.com/fiftynotai)**

---

## Packages

All packages are published on [pub.dev](https://pub.dev/publishers/fifty.dev/packages) and can be installed individually.

| Package | Version | Description |
|---------|---------|-------------|
| [fifty_tokens](https://pub.dev/packages/fifty_tokens) | [![pub](https://img.shields.io/badge/pub-v1.0.2-blue)](https://pub.dev/packages/fifty_tokens) | Design tokens -- colors, typography, spacing, motion, and more |
| [fifty_theme](https://pub.dev/packages/fifty_theme) | [![pub](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev/packages/fifty_theme) | Flutter theming layer. Converts design tokens into Material ThemeData |
| [fifty_ui](https://pub.dev/packages/fifty_ui) | [![pub](https://img.shields.io/badge/pub-v0.6.2-blue)](https://pub.dev/packages/fifty_ui) | FDL v2 styled Flutter components -- buttons, cards, inputs, and more |
| [fifty_forms](https://pub.dev/packages/fifty_forms) | [![pub](https://img.shields.io/badge/pub-v0.1.2-blue)](https://pub.dev/packages/fifty_forms) | Form building with validation, multi-step wizards, and draft persistence |
| [fifty_utils](https://pub.dev/packages/fifty_utils) | [![pub](https://img.shields.io/badge/pub-v0.1.0-blue)](https://pub.dev/packages/fifty_utils) | Pure Dart/Flutter utilities -- DateTime, Duration, Color extensions, responsive breakpoints, async state containers |
| [fifty_cache](https://pub.dev/packages/fifty_cache) | [![pub](https://img.shields.io/badge/pub-v0.1.0-blue)](https://pub.dev/packages/fifty_cache) | TTL-based HTTP response caching with pluggable stores and policies |
| [fifty_storage](https://pub.dev/packages/fifty_storage) | [![pub](https://img.shields.io/badge/pub-v0.1.0-blue)](https://pub.dev/packages/fifty_storage) | Secure token storage and preferences management |
| [fifty_connectivity](https://pub.dev/packages/fifty_connectivity) | [![pub](https://img.shields.io/badge/pub-v0.1.2-blue)](https://pub.dev/packages/fifty_connectivity) | Network connectivity monitoring with intelligent reachability probing |
| [fifty_audio_engine](https://pub.dev/packages/fifty_audio_engine) | [![pub](https://img.shields.io/badge/pub-v0.7.2-blue)](https://pub.dev/packages/fifty_audio_engine) | Modular and reactive audio system for Flutter |
| [fifty_speech_engine](https://pub.dev/packages/fifty_speech_engine) | [![pub](https://img.shields.io/badge/pub-v0.1.2-blue)](https://pub.dev/packages/fifty_speech_engine) | TTS and STT for Flutter games and applications |
| [fifty_narrative_engine](https://pub.dev/packages/fifty_narrative_engine) | [![pub](https://img.shields.io/badge/pub-v0.1.1-blue)](https://pub.dev/packages/fifty_narrative_engine) | Narrative processing engine for games and interactive applications |
| [fifty_world_engine](https://pub.dev/packages/fifty_world_engine) | [![pub](https://img.shields.io/badge/pub-v0.1.2-blue)](https://pub.dev/packages/fifty_world_engine) | Flame-based interactive grid world rendering for Flutter games |
| [fifty_printing_engine](https://pub.dev/packages/fifty_printing_engine) | [![pub](https://img.shields.io/badge/pub-v1.0.2-blue)](https://pub.dev/packages/fifty_printing_engine) | Multi-printer ESC/POS printing with Bluetooth and WiFi support |
| [fifty_skill_tree](https://pub.dev/packages/fifty_skill_tree) | [![pub](https://img.shields.io/badge/pub-v0.1.2-blue)](https://pub.dev/packages/fifty_skill_tree) | Interactive skill tree widget for Flutter games |
| [fifty_achievement_engine](https://pub.dev/packages/fifty_achievement_engine) | [![pub](https://img.shields.io/badge/pub-v0.1.3-blue)](https://pub.dev/packages/fifty_achievement_engine) | Achievement system for Flutter games with condition-based unlocks |
| [fifty_socket](https://pub.dev/packages/fifty_socket) | [![pub](https://img.shields.io/badge/pub-v0.1.0-blue)](https://pub.dev/packages/fifty_socket) | Phoenix WebSocket infrastructure with auto-reconnect and channel management |

> Source code for each package is in [`packages/`](packages/).

---

## Installation

### From pub.dev (Recommended)

Install any package using `dart pub add`:

```bash
dart pub add fifty_tokens
dart pub add fifty_theme
dart pub add fifty_ui
```

Or add them directly to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_tokens: ^1.0.2
  fifty_theme: ^1.0.0
  fifty_ui: ^0.6.2
  fifty_forms: ^0.1.2
  fifty_utils: ^0.1.0
```

### For Contributors (Path)

If you are working within the monorepo or contributing to packages locally:

```yaml
dependencies:
  fifty_tokens:
    path: ../fifty_tokens

  fifty_utils:
    path: ../fifty_utils
```

---

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

---

## Architecture

```
fifty_flutter_kit/
  packages/
    fifty_tokens/               # Design foundation (colors, typography, spacing, motion)
    fifty_theme/                # Theme layer (depends on tokens)
    fifty_ui/                   # Components (depends on theme)
    fifty_forms/                # Form building system
    fifty_utils/                # Pure utilities (no dependencies)
    fifty_cache/                # TTL-based caching layer
    fifty_storage/              # Secure storage abstraction
    fifty_connectivity/         # Network monitoring
    fifty_audio_engine/         # Modular audio system
    fifty_speech_engine/        # TTS and STT services
    fifty_narrative_engine/     # Narrative processing
    fifty_world_engine/         # Flame-based grid world rendering
    fifty_printing_engine/      # ESC/POS printing
    fifty_skill_tree/           # Skill tree widget
    fifty_achievement_engine/   # Achievement system
    fifty_socket/               # Phoenix WebSocket client
  apps/
    fifty_demo/                 # Demo application
  templates/
    mvvm_actions/               # Full app template (fork, don't import)
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
fifty_socket (standalone, depends on phoenix_socket)
```

---

## Apps and Templates

### Demo App

| App | Description |
|-----|-------------|
| [fifty_demo](apps/fifty_demo/) | Demo app showcasing all packages |

### Templates

Project scaffolds for rapid development. Clone and customize.

| Template | Description | Pattern |
|----------|-------------|---------|
| [mvvm_actions](templates/mvvm_actions/) | Full-featured app scaffold | MVVM + Actions |

Templates depend on the packages above but are meant to be forked, not imported.

---

## Package Details

### fifty_tokens

Design tokens -- the foundation layer. Pure Dart constants with no widgets or state.

- **Color Tokens** - Core palette, semantic aliases, mode-specific helpers
- **Typography Tokens** - Unified font family with complete type scale
- **Spacing Tokens** - 4px base grid with named scale (xs-massive)
- **Motion Tokens** - Duration constants and easing curves
- **Shadow, Gradient, Radii, Breakpoint Tokens**

### fifty_theme

Converts design tokens into Material ThemeData.

- **Light and Dark Themes** - Generated from fifty_tokens
- **Material 3 Integration** - Full ThemeData generation

### fifty_ui

FDL v2 styled Flutter components.

- **Buttons, Cards, Inputs** - Complete component library
- **Consistent Styling** - Driven by fifty_theme

### fifty_forms

Production-ready form building system with FDL v2 compliance.

- **FiftyFormController** - Centralized form state management
- **25 Built-in Validators** - Required, email, min/max length, regex, and more
- **10 Field Types** - Text, checkbox, switch, dropdown, radio, date, time, slider, range, autocomplete
- **FiftyMultiStepForm** - Wizard-style multi-step forms with navigation
- **FiftyFormArray** - Dynamic form fields (add/remove)
- **DraftManager** - Auto-save and restore form drafts

### fifty_utils

Pure Dart/Flutter utilities with zero external dependencies (except `intl`).

- **DateTime Extensions** - `isToday`, `isYesterday`, `format()`, `timeAgo()`
- **Duration Extensions** - `format()`, `formatCompact()`
- **Color Extensions** - `HexColor.fromHex()`, `toHex()`
- **ResponsiveUtils** - Device detection, breakpoints, responsive values
- **ApiResponse** - Immutable async state container
- **apiFetch()** - Stream-based API fetching

### fifty_cache / fifty_storage

Data persistence layers.

- **TTL-based caching** - HTTP response caching with pluggable stores and policies
- **Secure storage** - Token storage and preferences management

### fifty_connectivity

Network connectivity monitoring with intelligent reachability probing.

- **ReachabilityService** - DNS and HTTP connectivity checks
- **ConnectionViewModel** - Reactive connection state management
- **ConnectionOverlay** - Automatic offline/online UI overlay
- **ConnectivityCheckerSplash** - Splash screen with connectivity check

### fifty_audio_engine

Modular and reactive audio system for Flutter games and applications.

- **Three-Channel Architecture** - BGM (crossfade, playlist, loop), SFX (low-latency pooling), Voice (BGM ducking)
- **Persistent State** - Volume and state persisted via GetStorage
- **Motion Integration** - Fade presets aligned with motion tokens

### fifty_speech_engine

TTS and STT for Flutter games and applications.

- **Text-to-Speech** - Multi-language speech synthesis
- **Speech-to-Text** - Voice input recognition

### fifty_narrative_engine

Narrative processing engine for games and interactive applications.

- **NarrativeEngine** - Core processor for in-game sentence execution
- **NarrativeInterpreter** - Instruction parsing and handler delegation
- **NarrativeQueue** - Optimized queue with order-based sorting

### fifty_world_engine

Flame-based interactive grid world rendering for Flutter games.

- **Tile Rendering** - Grid-based map with sprites for dungeon crawlers and strategy games
- **Camera Controls** - Smooth pan and pinch-to-zoom for map exploration
- **Entity Management** - Spawn, update, remove lifecycle for characters, rooms, monsters

### fifty_printing_engine

Multi-printer ESC/POS printing engine supporting Bluetooth and WiFi printers.

- **PrinterDiscovery** - Scan for Bluetooth and WiFi printers
- **PrinterConnection** - Connection management with auto-reconnect
- **ReceiptBuilder** - Fluent API for building receipts
- **ESC/POS Commands** - Full command support including images and barcodes

### fifty_skill_tree

Interactive skill tree widget for Flutter games.

- **SkillTreeController** - Manage skill nodes and progression
- **SkillTreeView** - Visual tree rendering with connections
- **Unlock Conditions** - Prerequisite-based skill unlocking

### fifty_achievement_engine

Achievement system for Flutter games with condition-based unlocks.

- **AchievementController** - Track and unlock achievements
- **Progress Tracking** - Incremental achievement progress
- **Event System** - Achievement unlock notifications

### fifty_socket

Phoenix WebSocket infrastructure for Flutter with auto-reconnect and channel management.

- **SocketService** - Abstract base class with one override (`getWebSocketUrl()`)
- **Auto-Reconnect** - Configurable exponential backoff with jitter
- **Heartbeat Monitoring** - Phoenix heartbeat with watchdog timeout
- **Channel Management** - Join/leave topics with subscription guards
- **Reactive Streams** - State, error, and message streams

### mvvm_actions (Template)

Full-featured app template using MVVM + Actions architecture. **Fork this, don't import.**

- **GetX Integration** - Reactive state management
- **Pre-built Modules** - Auth, connectivity, locale, theme
- **Actions Pattern** - Standardized UX handling
- **Infrastructure** - HTTP client, caching, storage

---

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

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following the coding guidelines
4. Run tests
5. Submit a pull request

---

## License

MIT License -- see individual packages for details.

---

Built with Fifty Design Language (FDL)
