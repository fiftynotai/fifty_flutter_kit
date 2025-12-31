# Fifty Ecosystem

A comprehensive Flutter/Dart package ecosystem providing design tokens, theming, UI components, architecture patterns, and utility functions.

## Packages

| Package | Version | Description |
|---------|---------|-------------|
| [fifty_tokens](packages/fifty_tokens/) | v0.2.0 | Design tokens (colors, typography, spacing) |
| [fifty_theme](packages/fifty_theme/) | v0.1.0 | Theme generation and management |
| [fifty_ui](packages/fifty_ui/) | v0.5.0 | Component library (buttons, cards, inputs) |
| [fifty_arch](packages/fifty_arch/) | v0.6.0 | MVVM + Actions architecture framework |
| [fifty_utils](packages/fifty_utils/) | v0.1.0 | Pure utilities (DateTime, responsive, state) |
| [fifty_cache](packages/fifty_cache/) | v0.1.0 | Multi-tier caching with TTL support |
| [fifty_storage](packages/fifty_storage/) | v0.1.0 | Key-value storage abstraction |
| [fifty_connectivity](packages/fifty_connectivity/) | v0.1.0 | Network connectivity monitoring |
| [fifty_audio_engine](packages/fifty_audio_engine/) | v0.7.0 | Audio playback and recording |
| [fifty_speech_engine](packages/fifty_speech_engine/) | v0.1.0 | Text-to-speech and speech-to-text |
| [fifty_sentences_engine](packages/fifty_sentences_engine/) | v0.1.0 | Sentence building and word bank |
| [fifty_map_engine](packages/fifty_map_engine/) | v0.1.0 | Cross-platform maps integration |

## Architecture

```
fifty_ecosystem/
  packages/
    fifty_tokens/      # Design foundation
    fifty_theme/       # Theme layer (depends on tokens)
    fifty_ui/          # Components (depends on theme)
    fifty_arch/        # Architecture (depends on utils, storage, cache, connectivity)
    fifty_utils/       # Pure utilities (no dependencies)
    fifty_cache/       # Caching layer
    fifty_storage/     # Storage abstraction
    fifty_connectivity/ # Network monitoring
    fifty_audio_engine/
    fifty_speech_engine/
    fifty_sentences_engine/
    fifty_map_engine/
```

### Dependency Graph

```
fifty_tokens (foundation)
     |
fifty_theme
     |
fifty_ui

fifty_utils (foundation)
     |
fifty_arch <-- fifty_storage, fifty_cache, fifty_connectivity
```

## Installation

Add packages to your `pubspec.yaml`:

### Using Git (Development)

```yaml
dependencies:
  fifty_tokens:
    git:
      url: https://github.com/aspect-build/fifty_eco_system
      path: packages/fifty_tokens

  fifty_utils:
    git:
      url: https://github.com/aspect-build/fifty_eco_system
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

```dart
import 'package:fifty_arch/fifty_arch.dart';

// ViewModel with Notifier
class UserViewModel extends FiftyViewModel {
  final usersState = ApiResponse<List<User>>.idle().notifier;

  void loadUsers() {
    apiFetch(() => userService.getUsers())
      .listen((state) => usersState.value = state);
  }
}

// View with selector
class UserListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FiftySelector<UserViewModel, ApiResponse<List<User>>>(
      selector: (vm) => vm.usersState,
      builder: (context, state) {
        if (state.isLoading) return CircularProgressIndicator();
        if (state.hasData) return UserList(users: state.data!);
        return ErrorWidget(state.error);
      },
    );
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

## Package Details

### fifty_utils

Pure Dart/Flutter utilities with zero external dependencies (except `intl`).

- **DateTime Extensions** - `isToday`, `isYesterday`, `format()`, `timeAgo()`
- **Duration Extensions** - `format()`, `formatCompact()`
- **Color Extensions** - `HexColor.fromHex()`, `toHex()`
- **ResponsiveUtils** - Device detection, breakpoints, responsive values
- **ApiResponse** - Immutable async state container
- **apiFetch()** - Stream-based API fetching

### fifty_arch

MVVM + Actions architecture framework.

- **FiftyViewModel** - Base class with lifecycle management
- **FiftySelector** - Efficient state selection widgets
- **FiftyNotifier** - Enhanced ValueNotifier with batching
- **Actions Pattern** - Reusable UI actions

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
