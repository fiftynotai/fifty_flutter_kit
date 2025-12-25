# fifty_theme v0.1.0

**Release Date:** 2025-12-25

Transform design tokens into production-ready Flutter themes.

---

## Highlights

**fifty_theme** is the theming layer of the Fifty Design Language (FDL) ecosystem. It converts `fifty_tokens` into complete Material 3 `ThemeData`, ready for use in any Flutter application.

### Key Features

- **Complete Material 3 Theme** - Dark and light modes with full component coverage
- **25+ Component Themes** - Buttons, cards, inputs, navigation, and more
- **Zero Elevation Design** - No drop shadows; uses crimson glow for focus states
- **Binary Typography** - Monument Extended (Hype) + JetBrains Mono (Logic)
- **Custom Theme Extension** - Access Fifty-specific colors, glows, and motion tokens
- **OLED Optimized** - True black backgrounds for power efficiency

---

## Quick Start

```dart
import 'package:fifty_theme/fifty_theme.dart';

MaterialApp(
  theme: FiftyTheme.dark(),  // Dark mode is PRIMARY
  home: MyApp(),
);
```

---

## What's Included

### Core Classes

| Class | Purpose |
|-------|---------|
| `FiftyTheme` | Main entry point - `dark()` and `light()` factory methods |
| `FiftyColorScheme` | Maps fifty_tokens colors to Material ColorScheme |
| `FiftyTextTheme` | Binary type system with Hype and Logic fonts |
| `FiftyComponentThemes` | 25+ pre-configured component themes |
| `FiftyThemeExtension` | Custom properties (igrisGreen, glows, motion) |

### Theme Extension Properties

Access via `Theme.of(context).extension<FiftyThemeExtension>()`:

- **Colors:** `igrisGreen`, `success`, `warning`
- **Glows:** `focusGlow`, `strongFocusGlow`
- **Durations:** `instant`, `fast`, `compiling`, `systemLoad`
- **Curves:** `standardCurve`, `enterCurve`, `exitCurve`

---

## Design Philosophy

The theme follows **Fifty Design Language (FDL)** principles:

1. **Dark mode is PRIMARY** - Not an afterthought, the canonical experience
2. **No shadows, only glow** - Crimson glow replaces drop shadows
3. **Compact density** - Information-dense bento-grid layouts
4. **Zero elevation** - Flat surfaces with border outlines
5. **Kinetic typography** - Bold headlines, functional body text

---

## Test Coverage

- **109 tests passing**
- All components verified
- Both dark and light modes tested
- Theme extension interpolation tested

---

## Dependencies

- `flutter` SDK >=3.0.0
- `fifty_tokens` ^0.2.0

### Font Requirements

Ensure these fonts are configured in your `pubspec.yaml`:
- Monument Extended (for headlines)
- JetBrains Mono (for body text)

---

## Installation Note

This package currently uses a **path dependency** for `fifty_tokens` (monorepo development). For standalone use:

```yaml
# Option 1: Git dependency
dependencies:
  fifty_theme:
    git:
      url: https://github.com/fifty-dev/fifty_eco_system.git
      path: packages/fifty_theme

# Option 2: After pub.dev publishing
dependencies:
  fifty_theme: ^0.1.0
```

---

## Related Packages

| Package | Status | Description |
|---------|--------|-------------|
| fifty_tokens | v0.2.0 | Design tokens (foundation) |
| **fifty_theme** | **v0.1.0** | **Flutter theming (this release)** |
| fifty_ui | Coming soon | Component library |

---

## Full Changelog

See [CHANGELOG.md](CHANGELOG.md) for complete details.

---

**Part of the fifty.dev ecosystem**

*The interface is the machine. Make it feel alive.*
