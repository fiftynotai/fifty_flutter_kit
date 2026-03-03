# Fifty Tokens

[![pub package](https://img.shields.io/pub/v/fifty_tokens.svg)](https://pub.dev/packages/fifty_tokens)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Configurable design tokens for Flutter. Ship your brand, not ours.**

A complete design token system -- colors, typography, spacing, radii, motion, shadows, gradients, and breakpoints -- with multiple built-in presets you can swap at runtime or override from JSON. Defaults to FDL v2 "Sophisticated Warm" out of the box. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Why fifty_tokens

- **Fully configurable** -- Override any token category with `FiftyTokens.configure()`, or load an entire theme from a JSON map with `FiftyPreset.fromMap()`. No forking, no rebuilding.
- **Multiple built-in presets** -- Ship multiple themes with zero boilerplate. Swap between `FiftyPreset.fdlV2` and `FiftyPreset.balticBlue` at runtime with a single call.
- **Complete token system** -- 8 categories (colors, typography, spacing, radii, motion, shadows, gradients, breakpoints) covering every design decision your app needs.
- **Zero widgets, pure tokens** -- No UI opinions, no state management. Just design values consumable by any Flutter package or widget tree.
- **Works with any Flutter app** -- Pure Dart with no platform channels. Runs on Android, iOS, macOS, Linux, Windows, and Web.

---

## Quick Start

### Installation

```yaml
dependencies:
  fifty_tokens: ^3.0.0
```

For contributors using the monorepo:

```yaml
dependencies:
  fifty_tokens:
    path: ../fifty_tokens
```

**Dependencies:** `google_fonts`

### Use and Configure

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

// 1. Configure your brand (optional -- defaults to FDL v2)
FiftyTokens.configure(
  colors: FiftyPreset.fdlV2.colors.copyWith(
    primary: Color(0xFF1A73E8),
    onPrimary: Color(0xFFFFFFFF),
  ),
  typography: FiftyPreset.fdlV2.typography.copyWith(
    fontFamily: 'Inter',
    fontSource: FontSource.googleFonts,
  ),
);

// 2. Use tokens everywhere
Container(
  padding: EdgeInsets.all(FiftySpacing.md),
  decoration: BoxDecoration(
    color: FiftyColors.surfaceDark,
    borderRadius: FiftyRadii.xxlRadius,
    border: Border.all(color: FiftyColors.borderDark),
    boxShadow: FiftyShadows.md,
  ),
  child: Text(
    'Your Brand, Your Tokens',
    style: TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: FiftyTypography.titleLarge,
      fontWeight: FiftyTypography.bold,
      color: FiftyColors.background,
    ),
  ),
)
```

---

## Built-in Presets

Ship multiple themes with zero boilerplate. Every preset is a complete, const-constructible `FiftyPreset` -- swap the entire look of your app in one line.

| Preset | Style | Call |
|--------|-------|------|
| `FiftyPreset.fdlV2` | Sophisticated Warm -- burgundy and cream | `FiftyTokens.load(FiftyPreset.fdlV2)` |
| `FiftyPreset.balticBlue` | Cool Coastal -- steel-blue and muted earth tones | `FiftyTokens.load(FiftyPreset.balticBlue)` |

### Runtime Theme Switching

```dart
// Switch to Baltic Blue -- every FiftyColors.*, FiftyShadows.*, etc.
// reflects the new palette immediately.
FiftyTokens.load(FiftyPreset.balticBlue);

// Back to the default
FiftyTokens.load(FiftyPreset.fdlV2);
// -- or --
FiftyTokens.reset();
```

### Create Your Own Preset

Start from an existing preset and override only what you need:

```dart
final myPreset = FiftyPreset.fdlV2.copyWith(
  colors: FiftyPreset.fdlV2.colors.copyWith(
    primary: Color(0xFF1A73E8),
    onPrimary: Color(0xFFFFFFFF),
  ),
);
FiftyTokens.load(myPreset);
```

Or load a complete preset from JSON (missing keys fall back to FDL v2):

```dart
final preset = FiftyPreset.fromMap(jsonDecode(jsonString));
FiftyTokens.load(preset);
```

See [`fdl_v2_preset.json`](fdl_v2_preset.json) and [`baltic_blue_preset.json`](baltic_blue_preset.json) for full JSON reference files.

---

## Configuration

If `FiftyTokens.configure()` is never called, all tokens use FDL v2 defaults. You can override as little or as much as you want.

### Override a Few Values

Use `copyWith` on any config from `FiftyPreset.fdlV2` to change specific values while keeping the rest:

```dart
FiftyTokens.configure(
  colors: FiftyPreset.fdlV2.colors.copyWith(
    primary: Color(0xFF1A73E8),
    secondary: Color(0xFF34A853),
  ),
);
```

### Build a Full Config from Scratch

Pass config objects directly when you want full control over every value:

```dart
FiftyTokens.configure(
  colors: FiftyColorConfig(
    primary: Color(0xFF1A73E8),
    primaryHover: Color(0xFF1557B0),
    background: Color(0xFFFFFFFF),
    backgroundDark: Color(0xFF121212),
    secondary: Color(0xFF34A853),
    secondaryHover: Color(0xFF2D8E47),
    success: Color(0xFF34A853),
    accent: Color(0xFFFBBC04),
    surface: Color(0xFFF8F9FA),
    surfaceDark: Color(0xFF1E1E1E),
    warning: Color(0xFFFBBC04),
    error: Color(0xFFEA4335),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF202124),
    borderOpacity: 0.12,
    focusOpacity: 0.4,
  ),
);
```

### Load a Complete Preset from JSON

Parse a JSON map into a full preset. Missing keys fall back to FDL v2 defaults:

```dart
import 'dart:convert';

final json = await rootBundle.loadString('assets/brand_theme.json');
final preset = FiftyPreset.fromMap(jsonDecode(json));
FiftyTokens.load(preset);
```

For the full JSON schema with all available keys and FDL v2 default values, see [`fdl_v2_preset.json`](fdl_v2_preset.json). Copy this file, change the values you need, and load it with `FiftyPreset.fromMap()`. Any keys you omit will fall back to FDL v2 defaults.

### Config Classes

Every token category has a dedicated config class with all fields required and non-nullable. Use `copyWith` for partial overrides.

| Config Class | Key Fields |
|-------------|---------|
| `FiftyColorConfig` | `primary`, `primaryHover`, `background`, `backgroundDark`, `secondary`, `secondaryHover`, `success`, `accent`, `surface`, `surfaceDark`, `warning`, `error`, `onPrimary`, `onBackground`, `borderOpacity`, `focusOpacity` |
| `FiftyTypographyConfig` | `fontFamily`, `fontSource`, weights (`regular`..`extraBold`), type scale sizes, letter spacing, line heights |
| `FiftySpacingConfig` | `base`, `xs`--`massive`, `gutterMobile`--`gutterDesktop` |
| `FiftyRadiiConfig` | `none`--`full` |
| `FiftyMotionConfig` | `instant`--`systemLoad`, `standard`, `enter`, `exit` |
| `FiftyBreakpointsConfig` | `mobile`, `tablet`, `desktop` |
| `FiftyShadowsConfig` | `sm`, `md`, `lg`, `primaryOpacity`, `glowOpacity` |
| `FiftyGradientsConfig` | `primaryEnd` |

### Font Configuration

Control how fonts are loaded via `FontSource`:

```dart
// Google Fonts (default) -- downloads at runtime
FiftyTokens.configure(
  typography: FiftyPreset.fdlV2.typography.copyWith(
    fontFamily: 'Manrope',
    fontSource: FontSource.googleFonts,
  ),
);

// Asset fonts -- bundled in app, no network needed
FiftyTokens.configure(
  typography: FiftyPreset.fdlV2.typography.copyWith(
    fontFamily: 'Manrope',
    fontSource: FontSource.asset,
  ),
);
```

### Reset to Defaults

Restore all tokens to FDL v2 at any time:

```dart
FiftyTokens.reset();
```

Check whether custom config is active:

```dart
if (FiftyTokens.isConfigured) {
  // Custom tokens are in effect
}
```

### Const Context Note

Token values are runtime getters (not compile-time constants) to support configurability. Expressions using token values cannot appear inside `const` constructors:

```dart
// Will not compile
const SizedBox(height: FiftySpacing.sm)

// Correct
SizedBox(height: FiftySpacing.sm)
```

---

## Token Reference

### Colors

Semantic color tokens with light/dark mode support.

| Token | Default | Purpose |
|-------|---------|---------|
| `FiftyColors.primary` | `#88292F` | Brand, buttons, CTAs, active states |
| `FiftyColors.primaryHover` | `#6E2126` | Primary hover state |
| `FiftyColors.background` | `#FEFEE3` | Light backgrounds; dark mode primary text |
| `FiftyColors.backgroundDark` | `#1A0D0E` | Dark mode backgrounds |
| `FiftyColors.secondary` | `#335C67` | Secondary buttons, switch on-state |
| `FiftyColors.secondaryHover` | `#274750` | Secondary hover state |
| `FiftyColors.success` | `#4B644A` | Positive indicators |
| `FiftyColors.accent` | `#FFC9B9` | Dark mode accent, outline borders, focus rings |
| `FiftyColors.surface` | `#FAF9DE` | Light mode cards and surfaces |
| `FiftyColors.surfaceDark` | `#2A1517` | Dark mode cards and surfaces |
| `FiftyColors.warning` | `#F7A100` | Warning indicators |
| `FiftyColors.error` | `#88292F` | Error indicators |
| `FiftyColors.onPrimary` | `#FEFEE3` | Text on primary surfaces |
| `FiftyColors.onBackground` | `#1A0D0E` | Text on background surfaces |

**Computed helpers** (derived from config values at runtime):

| Token | Value | Purpose |
|-------|-------|---------|
| `FiftyColors.borderLight` | black @ `borderOpacity` (5%) | Light mode borders |
| `FiftyColors.borderDark` | white @ `borderOpacity` (5%) | Dark mode borders |
| `FiftyColors.focusLight` | `primary` | Light mode focus ring |
| `FiftyColors.focusDark` | `accent` @ `focusOpacity` (50%) | Dark mode focus ring |

**Deprecated palette names** (still work, emit deprecation warnings):
`burgundy` -> `primary`, `burgundyHover` -> `primaryHover`, `cream` -> `background`, `darkBurgundy` -> `backgroundDark`, `slateGrey` -> `secondary`, `slateGreyHover` -> `secondaryHover`, `hunterGreen` -> `success`, `powderBlush` -> `accent`, `surfaceLight` -> `surface`.

### Typography

Unified Manrope font family with a complete type scale.

| Token | Default | Purpose |
|-------|---------|---------|
| `fontFamily` | `'Manrope'` | Font family name |
| **Weights** | | |
| `regular` | `w400` | Body text |
| `medium` | `w500` | Emphasized body |
| `semiBold` | `w600` | Subheadings |
| `bold` | `w700` | Headings |
| `extraBold` | `w800` | Hero text |
| **Type Scale** | | |
| `displayLarge` | `32px` | Hero headlines |
| `displayMedium` | `24px` | Section headlines |
| `titleLarge` | `20px` | Card titles |
| `titleMedium` | `18px` | App bar titles |
| `titleSmall` | `16px` | List item titles |
| `bodyLarge` | `16px` | Primary body text |
| `bodyMedium` | `14px` | Secondary body text |
| `bodySmall` | `12px` | Captions, hints |
| `labelLarge` | `14px` | Button labels |
| `labelMedium` | `12px` | Input labels (uppercase) |
| `labelSmall` | `10px` | Bottom nav, badges |
| **Letter Spacing** | | |
| `letterSpacingDisplay` | `-0.5` | Headlines |
| `letterSpacingDisplayMedium` | `-0.25` | Medium headlines |
| `letterSpacingBody` | `0.5` | Body text |
| `letterSpacingBodyMedium` | `0.25` | Secondary body |
| `letterSpacingBodySmall` | `0.4` | Captions |
| `letterSpacingLabel` | `0.5` | Labels |
| `letterSpacingLabelMedium` | `1.5` | Uppercase labels |
| **Line Heights** | | |
| `lineHeightDisplay` | `1.2` | Headlines |
| `lineHeightTitle` | `1.3` | Titles |
| `lineHeightBody` | `1.5` | Body text |
| `lineHeightLabel` | `1.2` | Compact labels |

All properties accessed via `FiftyTypography.*` (e.g. `FiftyTypography.bodyLarge`).

### Spacing

4px base grid with named scale and responsive gutters.

| Token | Default | Purpose |
|-------|---------|---------|
| `base` | `4px` | Fundamental unit |
| `tight` | `8px` | Compact element spacing |
| `standard` | `12px` | Card padding, field spacing |
| `xs` | `4px` | Minimal spacing |
| `sm` | `8px` | Small spacing |
| `md` | `12px` | Medium spacing |
| `lg` | `16px` | Large spacing |
| `xl` | `20px` | Extra large spacing |
| `xxl` | `24px` | Section spacing |
| `xxxl` | `32px` | Layout spacing |
| `huge` | `40px` | Major section gaps |
| `massive` | `48px` | Hero section padding |
| `gutterMobile` | `12px` | Mobile screen gutter |
| `gutterTablet` | `16px` | Tablet screen gutter |
| `gutterDesktop` | `24px` | Desktop screen gutter |

All properties accessed via `FiftySpacing.*` (e.g. `FiftySpacing.lg`).

### Radii

Border radius scale from none to pill, with convenience `BorderRadius` objects.

| Token | Value | Convenience Object | Use Case |
|-------|-------|--------------------|----------|
| `none` | `0` | `noneRadius` | No radius |
| `sm` | `4px` | `smRadius` | Checkboxes, small badges |
| `md` | `8px` | `mdRadius` | Chips, tags |
| `lg` | `12px` | `lgRadius` | Standard cards (legacy) |
| `xl` | `16px` | `xlRadius` | Buttons, text fields |
| `xxl` | `24px` | `xxlRadius` | Standard cards |
| `xxxl` | `32px` | `xxxlRadius` | Hero cards, modals |
| `full` | `9999px` | `fullRadius` | Pills, avatars |

All properties accessed via `FiftyRadii.*` (e.g. `FiftyRadii.xxlRadius`).

### Motion

Duration constants and easing curves for kinetic, slide-based animations.

| Token | Value | Purpose |
|-------|-------|---------|
| **Durations** | | |
| `instant` | `0ms` | Logic changes, immediate state updates |
| `fast` | `150ms` | Hover states, micro-interactions |
| `compiling` | `300ms` | Panel reveals, modal entrances |
| `systemLoad` | `800ms` | Staggered entry, page load sequences |
| **Easing Curves** | | |
| `standard` | `Cubic(0.2, 0, 0, 1)` | General-purpose |
| `enter` | `Cubic(0.2, 0.8, 0.2, 1)` | Springy entrance |
| `exit` | `Cubic(0.4, 0, 1, 1)` | Sharp, decisive exit |

All properties accessed via `FiftyMotion.*` (e.g. `FiftyMotion.fast`).

### Shadows

Soft, sophisticated box shadow presets.

| Token | Spec | Purpose |
|-------|------|---------|
| `sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation, hover states |
| `md` | `0 4px 6px rgba(0,0,0,0.07)` | Cards, elevated containers |
| `lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns, dialogs |
| `none` | `[]` | Explicit no shadow |
| `primary` | `0 4px 14px primary@20%` | Primary action buttons (computed) |
| `glow` | `0 0 15px background@10%` | Dark mode focus, warm highlights (computed) |

`sm`, `md`, `lg` come from config. `primary` and `glow` are computed from `FiftyColors` at runtime. All accessed via `FiftyShadows.*`.

### Gradients

LinearGradient presets for hero, progress, and surface backgrounds.

| Token | Direction | Colors | Purpose |
|-------|-----------|--------|---------|
| `primary` | topLeft -> bottomRight | `primary` -> `#5A1B1F` | Hero sections, featured cards |
| `progress` | left -> right | `accent` -> `primary` | Progress bars, loading indicators |
| `surface` | topCenter -> bottomCenter | `backgroundDark` -> `surfaceDark` | Background depth, card overlays |

`primaryEnd` comes from config. Start colors are computed from `FiftyColors`. All accessed via `FiftyGradients.*`.

### Breakpoints

Screen width thresholds with paired responsive gutter values.

| Token | Value | Gutter |
|-------|-------|--------|
| `mobile` | `768px` | `12px` |
| `tablet` | `768px` | `16px` |
| `desktop` | `1024px` | `24px` |

All properties accessed via `FiftyBreakpoints.*`.

---

## Usage Patterns

### Themed Card with Mode-Aware Borders

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

class FiftyCard extends StatelessWidget {
  final String title;
  final String body;
  final bool isDark;

  const FiftyCard({
    required this.title,
    required this.body,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: isDark ? FiftyColors.surfaceDark : FiftyColors.surface,
        borderRadius: FiftyRadii.xxlRadius,
        border: Border.all(
          color: isDark ? FiftyColors.borderDark : FiftyColors.borderLight,
        ),
        boxShadow: FiftyShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.titleLarge,
              fontWeight: FiftyTypography.bold,
              color: isDark ? FiftyColors.background : FiftyColors.backgroundDark,
              height: FiftyTypography.lineHeightTitle,
            ),
          ),
          SizedBox(height: FiftySpacing.sm),
          Text(
            body,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              fontWeight: FiftyTypography.regular,
              color: isDark ? FiftyColors.background : FiftyColors.backgroundDark,
              height: FiftyTypography.lineHeightBody,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Hero Section with Primary Gradient

Showcases color, typography, spacing, radii, and gradient tokens together:

```dart
Container(
  decoration: BoxDecoration(
    gradient: FiftyGradients.primary,
    borderRadius: FiftyRadii.xxxlRadius,
  ),
  padding: EdgeInsets.symmetric(
    horizontal: FiftySpacing.xxl,
    vertical: FiftySpacing.huge,
  ),
  child: Text(
    'Fifty',
    style: TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: FiftyTypography.displayLarge,
      fontWeight: FiftyTypography.extraBold,
      color: FiftyColors.background,
      letterSpacing: FiftyTypography.letterSpacingDisplay,
      height: FiftyTypography.lineHeightDisplay,
    ),
  ),
)
```

### JSON Theming at Runtime

Load a brand theme from a server or local file without rebuilding:

```dart
import 'dart:convert';
import 'package:fifty_tokens/fifty_tokens.dart';

Future<void> applyRemoteTheme(String jsonString) async {
  final map = jsonDecode(jsonString) as Map<String, dynamic>;
  final preset = FiftyPreset.fromMap(map);
  FiftyTokens.load(preset);
  // All FiftyColors.*, FiftySpacing.*, etc. now reflect the new theme
}
```

---

## Architecture

Kit position -- `fifty_tokens` is the foundation layer:

```
fifty_tokens  (this package -- design tokens)
    |
    v
fifty_theme   (Flutter ThemeData integration)
    |
    v
fifty_ui      (Component library)
```

Every other Fifty Flutter Kit package imports `fifty_tokens` as its single source of design truth. No values are hardcoded in consuming packages.

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftyColors` | Core palette, semantic aliases, and mode-specific border/focus helpers |
| `FiftyTypography` | Manrope font family, weights, type scale, letter spacing, and line heights |
| `FiftySpacing` | 4px base grid, named scale (xs--massive), and responsive gutters |
| `FiftyRadii` | Border radius values (none--full) and paired BorderRadius objects |
| `FiftyMotion` | Duration constants (instant, fast, compiling, systemLoad) and Cubic easing curves |
| `FiftyShadows` | Box shadow presets -- sm, md, lg, primary, and glow |
| `FiftyGradients` | LinearGradient presets -- primary, progress, and surface |
| `FiftyBreakpoints` | Screen width thresholds: mobile (768px), tablet (768px), desktop (1024px) |
| `FiftyTokens` | Central manager -- `configure()`, `load()`, `reset()`, `isConfigured` |
| `FiftyPreset` | Complete token set -- `fdlV2` (default), `balticBlue`, `fromMap()` for JSON, `copyWith()` for overrides |

### Source Layout

```
fifty_tokens/
├── lib/
│   ├── fifty_tokens.dart      # Barrel export
│   └── src/
│       ├── colors.dart        # FiftyColors
│       ├── typography.dart    # FiftyTypography
│       ├── spacing.dart       # FiftySpacing
│       ├── radii.dart         # FiftyRadii
│       ├── motion.dart        # FiftyMotion
│       ├── shadows.dart       # FiftyShadows
│       ├── gradients.dart     # FiftyGradients
│       ├── breakpoints.dart   # FiftyBreakpoints
│       ├── preset.dart        # FiftyPreset
│       └── config/
│           ├── fifty_tokens_config.dart  # FiftyTokens (load/configure/reset)
│           ├── font_resolver.dart        # FiftyFontResolver + FontSource
│           ├── color_config.dart         # FiftyColorConfig
│           ├── typography_config.dart    # FiftyTypographyConfig
│           ├── spacing_config.dart       # FiftySpacingConfig
│           ├── radii_config.dart         # FiftyRadiiConfig
│           ├── motion_config.dart        # FiftyMotionConfig
│           ├── breakpoints_config.dart   # FiftyBreakpointsConfig
│           ├── shadows_config.dart       # FiftyShadowsConfig
│           └── gradients_config.dart     # FiftyGradientsConfig
└── test/
```

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     |       |
| iOS      | Yes     |       |
| macOS    | Yes     |       |
| Linux    | Yes     |       |
| Windows  | Yes     |       |
| Web      | Yes     |       |

Pure Dart with no platform channels or native code required. The `google_fonts` dependency fetches Manrope at runtime or can be bundled as an asset font.

### Font Setup

Manrope is loaded via `google_fonts`. Add `google_fonts` to your app's `pubspec.yaml` if not already present:

```yaml
dependencies:
  google_fonts: ^8.0.0
```

Usage:

```dart
import 'package:google_fonts/google_fonts.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

TextStyle(
  fontFamily: GoogleFonts.manrope().fontFamily,
  fontSize: FiftyTypography.bodyLarge,
  fontWeight: FiftyTypography.medium,
)
```

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **Foundation layer** -- Every other Fifty Flutter Kit package (`fifty_theme`, `fifty_ui`) imports `fifty_tokens` as its single source of design truth; no values are hardcoded in consuming packages
- **FDL v2 "Sophisticated Warm"** -- The color system uses a warm burgundy-and-cream palette that supports both dark and light modes; v1 tokens remain available but are marked `@Deprecated` and will be removed in a future major version
- **Motion philosophy** -- FDL enforces kinetic (slide/wipe/reveal) animation throughout the kit; `FiftyMotion` provides the timing contracts that all animated components reference

---

## Version

**Current:** 3.0.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
