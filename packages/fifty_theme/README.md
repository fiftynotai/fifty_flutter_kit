# fifty_theme

Flutter theming layer for the fifty.dev ecosystem.

This package converts fifty_tokens design tokens into complete Flutter ThemeData, following the Fifty Design Language (FDL) specification.

## Features

- Complete Material 3 ThemeData built from design tokens
- Dark mode as primary (OLED-optimized)
- Light mode for accessibility
- Zero elevation (no drop shadows) - uses crimson glow for focus
- Tight density (compact visual density)
- Custom theme extension for Fifty-specific properties

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_theme:
    path: ../fifty_theme  # or git/pub reference
```

## Usage

### Basic Setup

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: FiftyTheme.dark(),      // Primary theme
      darkTheme: FiftyTheme.dark(),  // Dark mode
      themeMode: ThemeMode.dark,     // FDL: Dark is primary
      home: MyApp(),
    ),
  );
}
```

### With Light Mode Support

```dart
MaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
  themeMode: ThemeMode.system,  // Respect system preference
  home: MyApp(),
);
```

### Accessing Theme Extension

The `FiftyThemeExtension` provides access to Fifty-specific design tokens:

```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

// Colors
print(fifty.igrisGreen);   // AI terminal green
print(fifty.success);      // Success green
print(fifty.warning);      // Warning amber

// Glows (for BoxDecoration.boxShadow)
Container(
  decoration: BoxDecoration(
    color: Colors.black,
    boxShadow: fifty.focusGlow,  // Crimson glow effect
  ),
);

// Durations
AnimatedContainer(
  duration: fifty.fast,      // 150ms - hover states
  // or
  duration: fifty.compiling, // 300ms - panel reveals
);

// Curves
AnimatedPositioned(
  curve: fifty.enterCurve,  // Springy entrance
  // or
  curve: fifty.exitCurve,   // Sharp exit
);
```

## Color Scheme

The color scheme follows the "Mecha Cockpit" aesthetic:

| Role | Dark Mode | Light Mode |
|------|-----------|------------|
| Primary | Crimson Pulse | Crimson Pulse |
| Surface | Void Black | Terminal White |
| Container | Gunmetal | White |
| On Surface | Terminal White | Void Black |
| Tertiary | Igris Green | Igris Green |

## Typography

Binary type system:

- **Hype (Monument Extended)**: Headlines, display text, ALL CAPS
- **Logic (JetBrains Mono)**: Body, code, UI elements

| Style | Font | Size | Weight |
|-------|------|------|--------|
| displayLarge | Monument Extended | 64px | Ultrabold |
| displayMedium | Monument Extended | 48px | Ultrabold |
| displaySmall | Monument Extended | 32px | Regular |
| bodyLarge | JetBrains Mono | 16px | Regular |
| bodySmall | JetBrains Mono | 12px | Regular |

## Component Themes

All components follow FDL principles:

- **Buttons**: Crimson Pulse primary, zero elevation
- **Cards**: Gunmetal surface, border outline (no shadow)
- **Inputs**: Gunmetal fill, crimson focus border
- **Navigation**: Crimson Pulse selected states
- **Dialogs**: Gunmetal surface, smooth 24px radius

## FDL Design Principles

1. **Dark mode is PRIMARY** - optimized for OLED
2. **No drop shadows** - use crimson glow instead
3. **Zero elevation** - depth through surface colors
4. **Tight density** - compact visual spacing
5. **Material 3 enabled** - modern design system
6. **Border outlines** - instead of shadows for depth

## API Reference

### FiftyTheme

```dart
static ThemeData dark()   // Primary dark theme
static ThemeData light()  // Secondary light theme
```

### FiftyColorScheme

```dart
static ColorScheme dark()   // Dark color scheme
static ColorScheme light()  // Light color scheme
```

### FiftyTextTheme

```dart
static TextTheme textTheme()  // Complete text theme
```

### FiftyComponentThemes

Individual component theme methods that accept a ColorScheme:

- `elevatedButtonTheme()`
- `outlinedButtonTheme()`
- `textButtonTheme()`
- `cardTheme()`
- `inputDecorationTheme()`
- `appBarTheme()`
- `dialogTheme()`
- And many more...

### FiftyThemeExtension

Custom theme extension with:

- `igrisGreen` - AI terminal color
- `success` - Success state color
- `warning` - Warning state color
- `focusGlow` - Crimson glow shadow list
- `strongFocusGlow` - Enhanced glow shadow list
- `instant` - 0ms duration
- `fast` - 150ms duration
- `compiling` - 300ms duration
- `systemLoad` - 800ms duration
- `standardCurve` - Smooth ease curve
- `enterCurve` - Springy entrance curve
- `exitCurve` - Sharp exit curve

## Dependencies

- `flutter` (SDK)
- `fifty_tokens` - Design tokens (colors, typography, spacing, etc.)

## License

MIT License - see LICENSE file
