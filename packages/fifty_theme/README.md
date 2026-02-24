# Fifty Theme

[![pub package](https://img.shields.io/pub/v/fifty_theme.svg)](https://pub.dev/packages/fifty_theme)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Flutter theming layer that converts `fifty_tokens` design tokens into a complete Material 3 `ThemeData`. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Features

- **Complete Material 3 ThemeData** - Dark and light themes fully assembled from design tokens
- **Dark Mode as Primary** - OLED-optimized dark theme is the default FDL environment
- **Unified Manrope Typography** - Consistent type scale via Google Fonts across all text styles
- **Sophisticated Warm Palette** - Burgundy primary, Slate Grey secondary, Hunter Green tertiary
- **25+ Pre-Configured Component Themes** - Buttons, cards, inputs, navigation, dialogs and more
- **FiftyThemeExtension** - Custom theme extension exposing shadows, semantic colors, and motion tokens
- **Zero Elevation by Default** - Depth through surface color hierarchy and soft shadows
- **Compact Visual Density** - Optimized for information-dense bento-grid layouts

---

## Installation

```yaml
dependencies:
  fifty_theme: ^1.0.1
```

### For Contributors

```yaml
dependencies:
  fifty_theme:
    path: ../fifty_theme
```

**Dependencies:** `fifty_tokens`, `google_fonts`

---

## Quick Start

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      // Dark mode is PRIMARY in FDL
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: MyApp(),
    ),
  );
}
```

To support both modes with user preference:

```dart
MaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
  themeMode: ThemeMode.system,
  home: MyApp(),
);
```

---

## Architecture

```
fifty_tokens (Design Tokens)
    |
    v
FiftyColorScheme     FiftyTextTheme     FiftyComponentThemes     FiftyThemeExtension
    |                     |                      |                        |
    +---------------------+----------------------+------------------------+
                                    |
                                    v
                              FiftyTheme.dark()
                              FiftyTheme.light()
                                    |
                                    v
                           MaterialApp (ThemeData)
```

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftyTheme` | Main entry point. Assembles all sub-themes into complete `ThemeData`. |
| `FiftyColorScheme` | Maps `FiftyColors` tokens to `ColorScheme` for dark and light modes. |
| `FiftyTextTheme` | Builds `TextTheme` using Manrope via `google_fonts`. |
| `FiftyComponentThemes` | Static methods that return individual component theme objects. |
| `FiftyThemeExtension` | Custom `ThemeExtension` exposing shadows, semantic colors, and motion tokens. |

---

## API Reference

### FiftyTheme

The main entry point for creating themed applications.

```dart
/// Creates the dark ThemeData — PRIMARY theme.
/// Optimized for OLED displays. Dark mode is the primary FDL environment.
static ThemeData FiftyTheme.dark()

/// Creates the light ThemeData — SECONDARY theme.
/// Provided for accessibility and user preference.
static ThemeData FiftyTheme.light()
```

Both themes include: `useMaterial3: true`, `VisualDensity.compact`, 25+ component themes, and `FiftyThemeExtension`.

---

### FiftyThemeExtension

Access via `Theme.of(context).extension<FiftyThemeExtension>()!`.

**Colors:**

| Property | Type | Description |
|----------|------|-------------|
| `accent` | `Color` | Mode-aware accent. Dark: Powder Blush (#FFC9B9). Light: Burgundy (#88292F). |
| `success` | `Color` | Hunter Green (#4B644A). Positive states and confirmations. |
| `warning` | `Color` | Warning amber (#F7A100). Caution states and alerts. |
| `info` | `Color` | Slate Grey (#6D7B8D). Informational and neutral states. |

**Shadows:**

| Property | Type | Description |
|----------|------|-------------|
| `shadowSm` | `List<BoxShadow>` | Small shadow — subtle elevation. |
| `shadowMd` | `List<BoxShadow>` | Medium shadow — cards. |
| `shadowLg` | `List<BoxShadow>` | Large shadow — modals and dropdowns. |
| `shadowPrimary` | `List<BoxShadow>` | Primary button shadow. |
| `shadowGlow` | `List<BoxShadow>` | Dark mode glow accent (empty list in light mode). |

**Motion durations:**

| Property | Type | Description |
|----------|------|-------------|
| `instant` | `Duration` | 0ms — immediate state changes. |
| `fast` | `Duration` | 150ms — hover states and micro-interactions. |
| `compiling` | `Duration` | 300ms — panel reveals and modal entrances. |
| `systemLoad` | `Duration` | 800ms — staggered entry and page loads. |

**Motion curves:**

| Property | Type | Description |
|----------|------|-------------|
| `standardCurve` | `Curve` | Smooth ease for general animations. |
| `enterCurve` | `Curve` | Springy entrance with slight overshoot. |
| `exitCurve` | `Curve` | Sharp, decisive exit. |

**Methods:**

```dart
/// Creates the dark mode extension (used by FiftyTheme.dark()).
factory FiftyThemeExtension.dark()

/// Creates the light mode extension (used by FiftyTheme.light()).
factory FiftyThemeExtension.light()

/// Creates a copy with modified properties.
FiftyThemeExtension copyWith({...})

/// Linearly interpolates between two extensions (used for theme animation).
FiftyThemeExtension lerp(FiftyThemeExtension? other, double t)
```

---

### FiftyColorScheme

Maps `FiftyColors` tokens to Flutter's `ColorScheme`.

```dart
static ColorScheme FiftyColorScheme.dark()   // Primary color scheme
static ColorScheme FiftyColorScheme.light()  // Secondary color scheme
```

**Color Mappings (Dark Mode):**

| Material Role | Fifty Token | Usage |
|---------------|-------------|-------|
| `primary` | Burgundy (#88292F) | Brand signature, CTAs, focus |
| `secondary` | Slate Grey (#6D7B8D) | Secondary actions and accents |
| `tertiary` | Hunter Green (#4B644A) | Success states |
| `surface` | Dark Burgundy | Primary backgrounds (OLED-optimized) |
| `surfaceContainerHighest` | Surface Dark | Cards and panels |
| `error` | Burgundy | Destructive actions carry brand identity |

**Color Mappings (Light Mode):**

| Material Role | Fifty Token | Usage |
|---------------|-------------|-------|
| `primary` | Burgundy (#88292F) | Brand signature maintained |
| `surface` | Cream (#EAEAEA) | Warm background |
| `surfaceContainerHighest` | Surface Light | Cards and panels |
| `onSurface` | Dark Burgundy | Primary text |

---

### FiftyTextTheme

Creates the text theme using Manrope via `google_fonts`.

```dart
static TextTheme FiftyTextTheme.textTheme()
```

**Type Scale:**

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `displayLarge` | 32px | ExtraBold (800) | Hero text |
| `displayMedium` | 24px | ExtraBold (800) | Page titles |
| `displaySmall` | 20px | Bold (700) | Section headings |
| `headlineLarge` | 20px | Bold | Major headings |
| `headlineMedium` | 18px | Bold | Sub-headings |
| `headlineSmall` | 16px | Bold | Minor headings |
| `titleLarge` | 20px | Bold | Screen titles |
| `titleMedium` | 18px | Bold | Dialog titles |
| `titleSmall` | 16px | Bold | Section labels |
| `bodyLarge` | 16px | Medium (500) | Primary body text |
| `bodyMedium` | 14px | Regular (400) | Secondary body text |
| `bodySmall` | 12px | Regular | Captions and metadata |
| `labelLarge` | 14px | Bold | Button labels |
| `labelMedium` | 12px | Bold | Uppercase tags (letter-spacing 1.5) |
| `labelSmall` | 10px | SemiBold (600) | Small UI labels |

---

### FiftyComponentThemes

Static methods that return individual component theme objects. All accept a `ColorScheme` parameter.

**Button Themes:**
- `elevatedButtonTheme(ColorScheme)` - Primary CTA style
- `outlinedButtonTheme(ColorScheme)` - Secondary action style
- `textButtonTheme(ColorScheme)` - Tertiary action style
- `floatingActionButtonTheme(ColorScheme)` - FAB style

**Surface Themes:**
- `cardTheme(ColorScheme)` - Card containers
- `dialogTheme(ColorScheme)` - Modal dialogs
- `bottomSheetTheme(ColorScheme)` - Bottom sheets
- `drawerTheme(ColorScheme)` - Navigation drawers

**Input Themes:**
- `inputDecorationTheme(ColorScheme)` - Text fields
- `checkboxTheme(ColorScheme)` - Checkboxes
- `radioTheme(ColorScheme)` - Radio buttons
- `switchTheme(ColorScheme)` - Toggle switches
- `sliderTheme(ColorScheme)` - Sliders
- `chipTheme(ColorScheme)` - Chips and tags

**Navigation Themes:**
- `appBarTheme(ColorScheme)` - App bars
- `bottomNavigationBarTheme(ColorScheme)` - Bottom navigation
- `navigationRailTheme(ColorScheme)` - Side navigation
- `tabBarTheme(ColorScheme)` - Tab bars

**Other Themes:**
- `snackBarTheme(ColorScheme)` - Snack bars
- `tooltipTheme(ColorScheme)` - Tooltips
- `popupMenuTheme(ColorScheme)` - Popup menus
- `dropdownMenuTheme(ColorScheme)` - Dropdown menus
- `dividerTheme(ColorScheme)` - Dividers
- `listTileTheme(ColorScheme)` - List tiles
- `iconTheme(ColorScheme)` - Icons
- `scrollbarTheme(ColorScheme)` - Scrollbars
- `progressIndicatorTheme(ColorScheme)` - Progress indicators

---

## Usage Patterns

### Accessing the Theme Extension

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Semantic colors
Container(color: fifty.success);  // Positive states
Container(color: fifty.warning);  // Caution states
Container(color: fifty.info);     // Informational states
Container(color: fifty.accent);   // Mode-aware brand accent
```

### Applying Shadows

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Card with medium shadow
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(16),
    boxShadow: fifty.shadowMd,
  ),
);

// Primary button with glow (dark mode)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shadowColor: Colors.transparent,
  ).copyWith(
    // Override to add glow via decoration on parent if needed
  ),
  onPressed: () {},
  child: const Text('SUBMIT'),
);
```

### Animated Card with Motion Tokens

```dart
class AnimatedCard extends StatefulWidget {
  final Widget child;
  const AnimatedCard({required this.child});

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: fifty.fast,
        curve: fifty.standardCurve,
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? colors.primary : colors.outline,
          ),
          boxShadow: _isHovered ? fifty.shadowMd : fifty.shadowSm,
        ),
        child: widget.child,
      ),
    );
  }
}
```

### Panel Reveal Animation

```dart
class RevealPanel extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const RevealPanel({required this.child, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
    final colors = Theme.of(context).colorScheme;

    return AnimatedSlide(
      duration: fifty.compiling,
      curve: isVisible ? fifty.enterCurve : fifty.exitCurve,
      offset: isVisible ? Offset.zero : const Offset(0, 1),
      child: Container(
        color: colors.surfaceContainerHighest,
        child: child,
      ),
    );
  }
}
```

### Theme Customization

Extend the base theme for app-specific overrides:

```dart
final customTheme = FiftyTheme.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  extensions: [
    FiftyThemeExtension.dark().copyWith(
      success: Colors.green,
    ),
  ],
);
```

Use individual color scheme components directly:

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

  return Container(
    padding: const EdgeInsets.all(FiftySpacing.md),
    decoration: BoxDecoration(
      color: FiftyColors.surfaceDark,
      borderRadius: FiftyRadii.xxlRadius,
      border: Border.all(color: FiftyColors.borderDark),
    ),
    child: Text(
      'System Online',
      style: text.headlineMedium?.copyWith(color: colors.onSurface),
    ),
  );
}
```

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

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **Foundation Layer** - `fifty_tokens` is the required dependency. All colors, typography sizes, spacing, radii, shadow tokens, and motion values originate from `fifty_tokens` and flow through this package into Flutter's theming system.
- **Dark Mode as Primary** - FDL specifies dark mode as the primary environment. `FiftyTheme.dark()` is the canonical theme. Light mode is provided for accessibility and explicit user preference.
- **Sophisticated Warm Palette** - The v2 aesthetic uses Burgundy as the primary brand color, Cream as the light surface, and Dark Burgundy as the deep background. This replaces earlier versions that used a higher-contrast monochrome palette.
- **Unified Typography** - Manrope via `google_fonts` is the single typeface for all text roles. The type scale covers display through label sizes with consistent line heights and letter spacing from `FiftyTypography` tokens.
- **Component Theme Consistency** - All 25+ component themes consume the same `ColorScheme`, ensuring visual coherence across buttons, navigation, inputs, dialogs, and surfaces without manual color wiring.

---

## Version

**Current:** 1.0.1

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
