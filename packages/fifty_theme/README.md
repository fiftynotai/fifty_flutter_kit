# fifty_theme

> Flutter theming layer for the fifty.dev ecosystem - Transform design tokens into production-ready themes

[![pub package](https://img.shields.io/badge/pub-v0.1.0-crimson)](https://pub.dev/packages/fifty_theme)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?logo=flutter)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/tests-109%20passing-success)](test/)

---

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Theme Configuration](#theme-configuration)
  - [Basic Setup](#basic-setup)
  - [Dark/Light Mode](#darklight-mode)
  - [System Preference](#system-preference)
- [Accessing Theme Extension](#accessing-theme-extension)
  - [Colors](#extension-colors)
  - [Glows](#extension-glows)
  - [Motion](#extension-motion)
- [API Reference](#api-reference)
  - [FiftyTheme](#fiftytheme)
  - [FiftyThemeExtension](#fiftythemeextension)
  - [FiftyColorScheme](#fiftycolorscheme)
  - [FiftyTextTheme](#fiftytexttheme)
  - [FiftyComponentThemes](#fiftycomponentthemes)
- [Color Scheme](#color-scheme)
- [Typography](#typography)
- [Component Themes](#component-themes)
- [FDL Design Philosophy](#fdl-design-philosophy)
- [Using with fifty_tokens](#using-with-fifty_tokens)
- [Theme Customization](#theme-customization)
- [Examples](#examples)
- [Testing](#testing)
- [Related Packages](#related-packages)
- [License](#license)

---

## Overview

`fifty_theme` converts `fifty_tokens` design tokens into complete Flutter `ThemeData`, following the **Fifty Design Language (FDL)** specification. It provides ready-to-use Material 3 themes optimized for dark mode with a kinetic brutalism aesthetic.

**Key Features:**

- Complete Material 3 ThemeData built from design tokens
- Dark mode as primary (OLED-optimized)
- Light mode for accessibility
- Zero elevation (no drop shadows) - uses crimson glow for focus
- Compact visual density for tight layouts
- Custom theme extension for Fifty-specific properties
- 25+ pre-configured component themes

**Visual Philosophy:** Mecha Cockpit / Server Room

The theme evokes the environment of a command center - OLED blacks, crimson accents, and terminal-grade typography. Dark mode is not an afterthought; it is the primary environment.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_theme:
    path: ../fifty_theme  # Local path during development
    # Or use git:
    # git:
    #   url: https://github.com/fifty-dev/fifty_flutter_kit.git
    #   path: packages/fifty_theme
```

Then run:

```bash
flutter pub get
```

**Note:** This package depends on `fifty_tokens`. Ensure you have the required fonts (Monument Extended and JetBrains Mono) configured in your project.

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

That's it. Your app now uses the complete Fifty Design Language.

---

## Theme Configuration

### Basic Setup

For a pure FDL experience (dark mode only):

```dart
MaterialApp(
  theme: FiftyTheme.dark(),
  home: MyApp(),
);
```

### Dark/Light Mode

To support both modes with user preference:

```dart
MaterialApp(
  theme: FiftyTheme.light(),     // Light theme
  darkTheme: FiftyTheme.dark(),  // Dark theme
  themeMode: ThemeMode.system,   // Respect system setting
  home: MyApp(),
);
```

### System Preference

Handle theme mode dynamically:

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // FDL default

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FiftyTheme.light(),
      darkTheme: FiftyTheme.dark(),
      themeMode: _themeMode,
      home: HomePage(onThemeModeChanged: setThemeMode),
    );
  }
}
```

**Important:** FDL specifies dark mode as the primary theme. Use light mode only when necessary for accessibility or explicit user preference.

---

## Accessing Theme Extension

The `FiftyThemeExtension` provides access to Fifty-specific design tokens that don't map directly to Material Design components.

### Accessing the Extension

```dart
// Get the extension (non-null assertion - always available in Fifty themes)
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
```

### Extension Colors

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// AI terminal color - use for IGRIS/AI contexts only
Container(color: fifty.igrisGreen);

// Semantic colors
Container(color: fifty.success);  // Positive states (#00BA33)
Container(color: fifty.warning);  // Caution states (#F7A100)
```

### Extension Glows

Crimson glow effects replace traditional drop shadows:

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Standard focus glow
Container(
  decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(12),
    boxShadow: fifty.focusGlow,  // Crimson glow effect
  ),
);

// Strong focus glow (more prominent)
Container(
  decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(12),
    boxShadow: fifty.strongFocusGlow,  // Enhanced glow
  ),
);
```

### Extension Motion

Motion tokens for kinetic animations:

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Durations
AnimatedContainer(
  duration: fifty.instant,     // 0ms - immediate state changes
  duration: fifty.fast,        // 150ms - hover states
  duration: fifty.compiling,   // 300ms - panel reveals
  duration: fifty.systemLoad,  // 800ms - staggered entry
);

// Curves
AnimatedPositioned(
  curve: fifty.standardCurve,  // Smooth ease
  curve: fifty.enterCurve,     // Springy entrance
  curve: fifty.exitCurve,      // Sharp exit
);
```

### Complete Extension Example

```dart
class GlowingCard extends StatefulWidget {
  final Widget child;
  const GlowingCard({required this.child});

  @override
  State<GlowingCard> createState() => _GlowingCardState();
}

class _GlowingCardState extends State<GlowingCard> {
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? colors.primary : colors.outline,
          ),
          boxShadow: _isHovered ? fifty.focusGlow : null,
        ),
        child: widget.child,
      ),
    );
  }
}
```

---

## API Reference

### FiftyTheme

The main entry point for creating themed applications.

```dart
/// Creates the dark ThemeData - PRIMARY theme.
/// Optimized for OLED displays and reduced eye strain.
static ThemeData FiftyTheme.dark()

/// Creates the light ThemeData - SECONDARY theme.
/// Provided for accessibility and user preference.
static ThemeData FiftyTheme.light()
```

**Features of both themes:**
- Material 3 enabled
- Compact visual density
- Zero elevation (no drop shadows)
- 25+ component themes pre-configured
- FiftyThemeExtension included

### FiftyThemeExtension

Custom theme extension with Fifty-specific properties.

| Property | Type | Description |
|----------|------|-------------|
| `igrisGreen` | `Color` | AI terminal color (#00FF41). Reserved for IGRIS/AI contexts. |
| `success` | `Color` | Success state color (#00BA33). Positive actions and confirmations. |
| `warning` | `Color` | Warning state color (#F7A100). Caution states and alerts. |
| `focusGlow` | `List<BoxShadow>` | Standard crimson glow for focus states. |
| `strongFocusGlow` | `List<BoxShadow>` | Enhanced glow for active/selected states. |
| `instant` | `Duration` | 0ms - Immediate state changes. |
| `fast` | `Duration` | 150ms - Hover states, micro-interactions. |
| `compiling` | `Duration` | 300ms - Panel reveals, modal entrances. |
| `systemLoad` | `Duration` | 800ms - Staggered entry, page loads. |
| `standardCurve` | `Curve` | Smooth ease for general animations. |
| `enterCurve` | `Curve` | Springy entrance with slight overshoot. |
| `exitCurve` | `Curve` | Sharp, decisive exit. |

**Methods:**

```dart
/// Creates the default extension with standard FDL tokens.
factory FiftyThemeExtension.standard()

/// Creates a copy with modified properties.
FiftyThemeExtension copyWith({...})

/// Linearly interpolates between two extensions.
FiftyThemeExtension lerp(FiftyThemeExtension? other, double t)
```

### FiftyColorScheme

Maps FiftyColors tokens to Flutter's ColorScheme.

```dart
/// Creates a dark ColorScheme - PRIMARY color scheme.
/// Uses "Mecha Cockpit" aesthetic.
static ColorScheme FiftyColorScheme.dark()

/// Creates a light ColorScheme - SECONDARY color scheme.
/// Inverts the dark palette while maintaining brand identity.
static ColorScheme FiftyColorScheme.light()
```

**Color Mappings (Dark Mode):**

| Material Role | Fifty Token | Usage |
|---------------|-------------|-------|
| `primary` | Crimson Pulse | Brand signature, CTAs |
| `secondary` | Hyper Chrome | Metallic accents |
| `tertiary` | Igris Green | AI/terminal contexts |
| `surface` | Void Black | Primary backgrounds |
| `surfaceContainerHighest` | Gunmetal | Cards, panels |
| `error` | Error (Crimson) | Destructive actions |

### FiftyTextTheme

Creates the text theme using FiftyTypography tokens.

```dart
/// Creates the complete text theme.
/// Implements binary type system: Hype (Monument Extended) + Logic (JetBrains Mono).
static TextTheme FiftyTextTheme.textTheme()
```

**Text Style Mappings:**

| Style | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| `displayLarge` | Monument Extended | 64px | Ultrabold | Hero text |
| `displayMedium` | Monument Extended | 48px | Ultrabold | Page titles |
| `displaySmall` | Monument Extended | 32px | Regular | Section headings |
| `headlineLarge` | Monument Extended | 32px | Ultrabold | Major headings |
| `headlineMedium` | Monument Extended | 24px | Ultrabold | Sub-headings |
| `bodyLarge` | JetBrains Mono | 16px | Regular | Body text |
| `bodySmall` | JetBrains Mono | 12px | Regular | Captions, metadata |
| `labelLarge` | JetBrains Mono | 14px | Medium | Button labels |

### FiftyComponentThemes

Individual component theme methods. All accept a `ColorScheme` parameter.

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
- `chipTheme(ColorScheme)` - Chips/tags

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

## Color Scheme

The color scheme follows the "Mecha Cockpit" aesthetic:

| Role | Dark Mode | Light Mode | Usage |
|------|-----------|------------|-------|
| Primary | Crimson Pulse (#960E29) | Crimson Pulse | Brand signature, CTAs, focus |
| Surface | Void Black (#050505) | Terminal White (#EAEAEA) | Primary backgrounds |
| Container | Gunmetal (#1A1A1A) | White | Cards, panels |
| On Surface | Terminal White | Void Black | Primary text |
| Secondary | Hyper Chrome (#888888) | Hyper Chrome | Metallic accents |
| Tertiary | Igris Green (#00FF41) | Igris Green | AI/terminal contexts |
| Error | Crimson Pulse | Crimson Pulse | Errors carry brand identity |

---

## Typography

Binary type system for visual hierarchy:

### Hype (Monument Extended)

Bold extended sans-serif for impact:
- Headlines and display text
- ALL CAPS convention
- Tight letter spacing (-2%)

### Logic (JetBrains Mono)

Monospace font for functionality:
- Body text and paragraphs
- Code and terminal output
- UI elements and labels

**Type Scale:**

| Token | Size | Font | Usage |
|-------|------|------|-------|
| Hero | 64px | Monument Extended | Landing heroes |
| Display | 48px | Monument Extended | Page titles |
| Section | 32px | Monument Extended | Section headings |
| Body | 16px | JetBrains Mono | Paragraphs |
| Mono | 12px | JetBrains Mono | Code, metadata |

---

## Component Themes

All components follow FDL principles:

**Buttons:**
- Crimson Pulse primary background
- Zero elevation (no shadows)
- Glow effect on hover/focus

**Cards & Surfaces:**
- Gunmetal surface color
- Border outline for depth (no shadow)
- Standard 12px radius

**Inputs:**
- Gunmetal fill color
- Crimson focus border (2px)
- Hyper Chrome hint text

**Navigation:**
- Crimson Pulse selected states
- Hyper Chrome unselected states
- Zero elevation

**Dialogs & Modals:**
- Gunmetal surface
- Smooth 24px radius
- Border outline

---

## FDL Design Philosophy

### 1. Dark Mode is PRIMARY

Dark mode is not an afterthought - it is the primary environment. The theme is optimized for OLED displays with true black backgrounds.

```dart
// Correct: Dark mode first
MaterialApp(
  theme: FiftyTheme.dark(),       // Primary
  darkTheme: FiftyTheme.dark(),
  themeMode: ThemeMode.dark,      // Default to dark
);
```

### 2. No Drop Shadows

FDL eliminates drop shadows entirely. Depth is created through:
- Surface color hierarchy (voidBlack to gunmetal)
- Border outlines
- The signature crimson glow for focus states

```dart
// Instead of elevation, use the glow effect
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

Container(
  decoration: BoxDecoration(
    boxShadow: isFocused ? fifty.focusGlow : null,  // Crimson glow
  ),
);
```

### 3. Zero Elevation

All components are configured with zero elevation:
- Cards, dialogs, buttons: `elevation: 0`
- Shadow colors set to transparent
- AppBar scroll-under elevation disabled

### 4. Tight Density

Compact visual density for information-dense interfaces:
- `VisualDensity.compact` applied globally
- Smaller padding and margins
- Bento-grid layout optimization

### 5. Material 3 Enabled

Modern Material Design with FDL aesthetic:
- `useMaterial3: true`
- ColorScheme-driven theming
- Updated component styling

### 6. Border Outlines for Depth

Instead of shadows, use subtle borders:
- Cards: 1px border with `hyperChrome @ 10%`
- Inputs: Border transitions to crimson on focus
- Dialogs: Border outline with smooth radius

---

## Using with fifty_tokens

For direct token access alongside the theme:

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

Widget build(BuildContext context) {
  // Use theme for standard widgets
  final colors = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

  // Use tokens directly for custom styling
  return Container(
    padding: EdgeInsets.all(FiftySpacing.md),
    decoration: BoxDecoration(
      color: FiftyColors.gunmetal,
      borderRadius: FiftyRadii.standardRadius,
      border: Border.all(color: FiftyColors.border),
    ),
    child: Text(
      'SYSTEM ONLINE',
      style: text.headlineMedium?.copyWith(
        color: colors.onSurface,
      ),
    ),
  );
}
```

---

## Theme Customization

### Extending the Theme

```dart
final customTheme = FiftyTheme.dark().copyWith(
  // Override specific properties
  scaffoldBackgroundColor: Colors.black,

  // Extend with additional properties
  extensions: [
    FiftyThemeExtension.standard().copyWith(
      success: Colors.green,
    ),
    // Add your own extensions
    MyCustomExtension(),
  ],
);
```

### Custom Component Theme

```dart
final customTheme = FiftyTheme.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,  // Override primary button color
      // ... other customizations
    ),
  ),
);
```

### Using Individual Component Themes

```dart
// Access individual component theme for custom widgets
final colorScheme = FiftyColorScheme.dark();
final cardTheme = FiftyComponentThemes.cardTheme(colorScheme);

// Apply to a custom card implementation
Container(
  decoration: BoxDecoration(
    color: cardTheme.color,
    borderRadius: (cardTheme.shape as RoundedRectangleBorder).borderRadius,
  ),
);
```

---

## Examples

### Theme-Aware Button

```dart
class FiftyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FiftyButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label.toUpperCase()),
    );
  }
}
```

### Focus-Glow Card

```dart
class FocusGlowCard extends StatefulWidget {
  final Widget child;
  const FocusGlowCard({required this.child});

  @override
  State<FocusGlowCard> createState() => _FocusGlowCardState();
}

class _FocusGlowCardState extends State<FocusGlowCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
    final colors = Theme.of(context).colorScheme;

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: fifty.fast,
        curve: fifty.standardCurve,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? colors.primary : colors.outline,
            width: _isFocused ? 2 : 1,
          ),
          boxShadow: _isFocused ? fifty.focusGlow : null,
        ),
        child: widget.child,
      ),
    );
  }
}
```

### Animated Panel Reveal

```dart
class RevealPanel extends StatefulWidget {
  final Widget child;
  final bool isVisible;

  const RevealPanel({required this.child, required this.isVisible});

  @override
  State<RevealPanel> createState() => _RevealPanelState();
}

class _RevealPanelState extends State<RevealPanel> {
  @override
  Widget build(BuildContext context) {
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
    final colors = Theme.of(context).colorScheme;

    return AnimatedSlide(
      duration: fifty.compiling,
      curve: widget.isVisible ? fifty.enterCurve : fifty.exitCurve,
      offset: widget.isVisible ? Offset.zero : Offset(0, 1),
      child: Container(
        color: colors.surfaceContainerHighest,
        child: widget.child,
      ),
    );
  }
}
```

### Theme Mode Toggle

```dart
class ThemeModeSwitch extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeModeSwitch({
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.dark, label: Text('DARK')),
        ButtonSegment(value: ThemeMode.light, label: Text('LIGHT')),
        ButtonSegment(value: ThemeMode.system, label: Text('SYSTEM')),
      ],
      selected: {currentMode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
```

---

## Testing

```bash
cd packages/fifty_theme
flutter test
```

**Results:** 109 passing tests covering all theme components.

---

## Related Packages

| Package | Version | Description |
|---------|---------|-------------|
| [fifty_tokens](../fifty_tokens) | v0.2.0 | Design tokens (foundation layer) |
| **fifty_theme** | **v0.1.0** | **Flutter theming (you are here)** |
| fifty_ui | Coming soon | Component library |
| fifty_docs | Coming soon | Documentation viewer |

### Ecosystem Architecture

```
fifty_tokens (Design Tokens)
    |
    v
fifty_theme (Flutter ThemeData) <-- You are here
    |
    v
fifty_ui (Component Library)
    |
    v
fifty_docs (Documentation)
```

---

## Dependencies

- `flutter` (SDK)
- `fifty_tokens` (Design tokens)

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 fifty.dev (Mohamed Elamin)

---

**Part of the [fifty.dev ecosystem](https://fifty.dev) | Pilot 2: Theming Layer**

*The interface is the machine. Make it feel alive.*
