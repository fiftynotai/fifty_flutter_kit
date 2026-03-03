# Fifty Theme

[![pub package](https://img.shields.io/pub/v/fifty_theme.svg)](https://pub.dev/packages/fifty_theme)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Generates Material ThemeData from your fifty_tokens configuration -- configure your brand once, theme everywhere.**

A complete Flutter theming layer that reads from `fifty_tokens` and produces fully wired `ThemeData` with 25+ component themes, a custom `ThemeExtension` for semantic colors, shadows, and motion, and zero-config dark/light mode support. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## The Pipeline

```
FiftyTokens.configure(colors: yourBrand)
         |
         v
FiftyTheme.light() / .dark()       <-- reads from FiftyTokens.active
         |
         v
Complete Material ThemeData         <-- colorScheme, textTheme, 25+ component themes
         |
         v
Your entire app themed
```

Set your brand in `fifty_tokens`, call `FiftyTheme.light()` or `FiftyTheme.dark()`, and every Material widget in your app inherits your design decisions.

---

## Quick Start

### Installation

```yaml
dependencies:
  fifty_theme: ^3.0.0
```

For contributors using the monorepo:

```yaml
dependencies:
  fifty_theme:
    path: ../fifty_theme
```

**Dependency:** `fifty_tokens`

### Use

```dart
import 'package:fifty_theme/fifty_theme.dart';

GetMaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
);
```

That is it. Zero config gives you the FDL v2 "Sophisticated Warm" palette in both modes.

---

## Brand Configuration

The power of this package is that you never touch `FiftyTheme` directly to change your brand. You configure `fifty_tokens` and the theme follows.

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';

// 1. Configure your brand
FiftyTokens.configure(
  colors: FiftyPreset.fdlV2.colors.copyWith(
    primary: Color(0xFF586994),     // your brand color
    onPrimary: Color(0xFFFFFFFF),
  ),
);

// 2. Theme auto-generates from your tokens
// FiftyTheme.light() reads FiftyColors.primary -> colorScheme.primary
// FiftyTheme.dark()  reads FiftyColors.backgroundDark -> scaffold background
GetMaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
);
```

Change the tokens, the theme changes. No manual color wiring needed.

---

## Preset Switching

Swap the entire visual identity of your app at runtime with a single call:

```dart
// Switch to Baltic Blue preset
FiftyTokens.load(FiftyPreset.balticBlue);
Get.forceAppUpdate();  // entire app re-themes instantly

// Back to default
FiftyTokens.reset();
Get.forceAppUpdate();
```

Or load from JSON:

```dart
final preset = FiftyPreset.fromMap(jsonDecode(jsonString));
FiftyTokens.load(preset);
Get.forceAppUpdate();
```

---

## What Gets Generated

`FiftyTheme.dark()` and `FiftyTheme.light()` produce a complete `ThemeData` with every slot wired to your tokens.

### ColorScheme Mapping

| Material Role | Token Source | Purpose |
|---------------|-------------|---------|
| `primary` | `FiftyColors.primary` | Brand, buttons, CTAs, focus |
| `secondary` | `FiftyColors.secondary` | Secondary actions |
| `tertiary` | `FiftyColors.success` | Success states |
| `surface` | `backgroundDark` / `background` | Scaffold, app bar |
| `surfaceContainerHighest` | `surfaceDark` / `surface` | Cards, dialogs, panels |
| `error` | `FiftyColors.error` | Destructive actions |
| `outline` | `borderDark` / `borderLight` | Borders and dividers |

### TextTheme

Built from `FiftyTypography` tokens via `FiftyFontResolver`. Defaults to Manrope via `google_fonts`. Override with:

```dart
FiftyTheme.dark(fontFamily: 'Inter', fontSource: FontSource.asset);
```

### Component Themes (25+)

All derived from the `ColorScheme` -- no hardcoded colors anywhere:

- **Buttons:** elevated, outlined, text, FAB
- **Surfaces:** card, dialog, bottom sheet, drawer
- **Inputs:** text field, checkbox, radio, switch, slider, chip
- **Navigation:** app bar, bottom nav, navigation rail, tab bar
- **Feedback:** snack bar, tooltip, progress indicator
- **Menus:** popup, dropdown
- **Other:** divider, list tile, icon, scrollbar

### FiftyThemeExtension

Exposes tokens that have no Material equivalent:

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Semantic colors
fifty.accent;      // mode-aware accent (dark: FiftyColors.accent, light: primary)
fifty.success;     // FiftyColors.success
fifty.warning;     // FiftyColors.warning
fifty.info;        // FiftyColors.secondary

// Shadows
fifty.shadowSm;    // subtle elevation
fifty.shadowMd;    // cards
fifty.shadowLg;    // modals
fifty.shadowPrimary; // primary buttons
fifty.shadowGlow;  // dark mode accent glow (none in light)

// Motion
fifty.fast;        // 150ms -- hover, micro-interactions
fifty.compiling;   // 300ms -- panel reveals
fifty.systemLoad;  // 800ms -- staggered entry
fifty.standardCurve;
fifty.enterCurve;
fifty.exitCurve;
```

---

## Customization Levels

### Level 1: Zero Config

FDL v2 defaults:

```dart
GetMaterialApp(theme: FiftyTheme.dark());
```

### Level 2: Token-Level

Override tokens globally -- theme follows automatically:

```dart
FiftyTokens.configure(
  colors: FiftyPreset.fdlV2.colors.copyWith(primary: Color(0xFF1A73E8)),
);
GetMaterialApp(theme: FiftyTheme.dark());
```

### Level 3: Theme-Level

Pass overrides directly to `FiftyTheme`:

```dart
FiftyTheme.dark(
  primaryColor: Color(0xFF1A73E8),
  secondaryColor: Color(0xFF34A853),
  fontFamily: 'Inter',
  fontSource: FontSource.asset,
);
```

Or a full `ColorScheme`:

```dart
FiftyTheme.dark(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF1A73E8),
    secondary: Color(0xFF34A853),
  ),
);
```

### Level 4: Widget-Level

Override individual component themes after generation:

```dart
final theme = FiftyTheme.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  ),
);
```

### FiftyThemeExtension Override

```dart
FiftyTheme.dark(
  extension: FiftyThemeExtension.dark(
    accent: Color(0xFFFF6B6B),
    success: Color(0xFF00C853),
  ),
);
```

---

## Core Components

| Component | Description |
|-----------|-------------|
| `FiftyTheme` | Main entry point. `dark()` and `light()` assemble complete `ThemeData`. |
| `FiftyColorScheme` | Maps `FiftyColors` tokens to Material `ColorScheme` for both modes. |
| `FiftyTextTheme` | Builds `TextTheme` from `FiftyTypography` tokens via `FiftyFontResolver`. |
| `FiftyComponentThemes` | 25+ static methods returning configured component theme objects. |
| `FiftyThemeExtension` | Custom `ThemeExtension` with semantic colors, shadows, and motion tokens. |

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     | OLED optimization benefits AMOLED screens |
| iOS      | Yes     | |
| macOS    | Yes     | |
| Linux    | Yes     | |
| Windows  | Yes     | |
| Web      | Yes     | Manrope loaded via Google Fonts CDN |

---

## Ecosystem

```
fifty_tokens  (design tokens -- foundation)
    |
    v
fifty_theme   (this package -- Flutter ThemeData)
    |
    v
fifty_ui      (component library)
```

`fifty_theme` sits between the raw tokens and the widget layer. It reads whatever `fifty_tokens` has configured and translates it into Material's theming system. Consuming packages and widgets never need to reference token values directly for standard Material properties.

---

## Version

**Current:** 3.0.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
