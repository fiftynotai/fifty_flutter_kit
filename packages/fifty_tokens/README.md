# fifty_tokens

> Design tokens for the fifty.dev ecosystem - the DNA of Kinetic Brutalism

[![pub package](https://img.shields.io/badge/pub-v0.2.0-crimson)](https://pub.dev/packages/fifty_tokens)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?logo=flutter)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/tests-73%20passing-success)](test/)

---

## Overview

`fifty_tokens` is the foundation package for the fifty.dev ecosystem. It provides design tokens as pure Dart constants implementing the **Fifty Design Language (FDL)** - a dark, kinetic design system with a crimson signature.

**Visual Philosophy:** Mecha Cockpit / Server Room

The palette evokes the environment of a command center - OLED blacks, crimson accents, and terminal-grade typography. Dark mode is not an afterthought; it is the primary environment.

**Zero Dependencies.** Flutter SDK only. No bloat.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_tokens: ^0.2.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

// Build a "Data Slate" card
Container(
  padding: EdgeInsets.all(FiftySpacing.md),
  decoration: BoxDecoration(
    color: FiftyColors.gunmetal,
    borderRadius: FiftyRadii.standardRadius,
    border: Border.all(color: FiftyColors.border),
  ),
  child: Text(
    'SYSTEM ONLINE',
    style: TextStyle(
      fontFamily: FiftyTypography.fontFamilyMono,
      fontSize: FiftyTypography.body,
      color: FiftyColors.terminalWhite,
    ),
  ),
)
```

---

## Token Reference

### Colors

The FDL color system uses 6 core constants plus derived semantic colors.

| Token | Hex | Usage |
|-------|-----|-------|
| `voidBlack` | #050505 | The infinite canvas. Primary backgrounds. OLED-optimized. |
| `crimsonPulse` | #960E29 | The heartbeat. Buttons, active states, errors. |
| `gunmetal` | #1A1A1A | Surfaces. Cards, panels, code blocks. |
| `terminalWhite` | #EAEAEA | Primary text. High legibility, reduced eye strain. |
| `hyperChrome` | #888888 | Hardware/metadata. Borders, inactive icons, secondary text. |
| `igrisGreen` | #00FF41 | AI Agent. IGRIS terminal output exclusively. |

**Derived Colors:**

| Token | Value | Usage |
|-------|-------|-------|
| `border` | hyperChrome @ 10% | Card outlines, input borders, subtle separators |

**Semantic Colors:**

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | #00BA33 | Positive states, confirmations |
| `warning` | #F7A100 | Caution states, alerts |
| `error` | #960E29 | Errors, destructive actions (uses crimsonPulse) |

```dart
// Usage
Container(color: FiftyColors.voidBlack)
Text('Error', style: TextStyle(color: FiftyColors.crimsonPulse))
```

---

### Typography

Binary type system: **Hype (Monument Extended)** vs **Logic (JetBrains Mono)**.

**Font Families:**

| Token | Font | Usage |
|-------|------|-------|
| `fontFamilyHeadline` | Monument Extended | Headlines, display text (ALL CAPS) |
| `fontFamilyMono` | JetBrains Mono | Body, code, UI elements |

**Font Weights:**

| Token | Weight | Usage |
|-------|--------|-------|
| `regular` | 400 | Sub-heads, body text |
| `medium` | 500 | UI elements, emphasis |
| `ultrabold` | 800 | Headlines (Monument Extended) |

**Type Scale:**

| Token | Size | Usage |
|-------|------|-------|
| `hero` | 64px | Landing page heroes, major announcements |
| `display` | 48px | Page titles, section intros |
| `section` | 32px | Section headings, card titles |
| `body` | 16px | Paragraphs, descriptions (1.5 line height) |
| `mono` | 12px | Code, terminal output, metadata |

**Letter Spacing:**

| Token | Value | Usage |
|-------|-------|-------|
| `tight` | -2% | Headlines (dense, impactful) |
| `standard` | 0% | Body text |

**Line Heights:**

| Token | Value | Usage |
|-------|-------|-------|
| `displayLineHeight` | 1.1 | Tight for impact |
| `headingLineHeight` | 1.2 | Slightly tight |
| `bodyLineHeight` | 1.5 | Comfortable reading |
| `codeLineHeight` | 1.6 | Monospace spacing |

```dart
// Headline usage
Text(
  'SYSTEM PROTOCOL',
  style: TextStyle(
    fontFamily: FiftyTypography.fontFamilyHeadline,
    fontSize: FiftyTypography.section,
    fontWeight: FiftyTypography.ultrabold,
    letterSpacing: FiftyTypography.tight * FiftyTypography.section,
  ),
)
```

---

### Spacing

4px base grid with tight density. Content is contained in modular bento units.

**Base Unit:**

| Token | Value |
|-------|-------|
| `base` | 4px |

**Primary Gaps (FDL standard):**

| Token | Value | Usage |
|-------|-------|-------|
| `tight` | 8px | Compact element spacing, bento grid gaps |
| `standard` | 12px | Card padding, form field spacing |

**Spacing Scale:**

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | 1x base - Minimal spacing |
| `sm` | 8px | 2x base - Tight spacing |
| `md` | 12px | 3x base - Standard spacing |
| `lg` | 16px | 4x base - Comfortable spacing |
| `xl` | 20px | 5x base - Generous spacing |
| `xxl` | 24px | 6x base - Section spacing |
| `xxxl` | 32px | 8x base - Major section spacing |
| `huge` | 40px | 10x base - Hero spacing |
| `massive` | 48px | 12x base - Page-level spacing |

**Responsive Gutters:**

| Token | Value | Screen |
|-------|-------|--------|
| `gutterDesktop` | 24px | >= 1024px |
| `gutterTablet` | 16px | >= 768px, < 1024px |
| `gutterMobile` | 12px | < 768px |

```dart
// Bento grid usage
Wrap(
  spacing: FiftySpacing.tight,
  runSpacing: FiftySpacing.tight,
  children: [...],
)
```

---

### Radii

Simplified to two primary radii per FDL specification.

| Token | Value | Usage |
|-------|-------|-------|
| `standard` | 12px | Default for all elements (cards, buttons, inputs) |
| `smooth` | 24px | Hero cards, feature panels, softer appearance |
| `full` | 999px | Pills, circular avatars, badges |

**BorderRadius Objects:**

| Token | Value |
|-------|-------|
| `standardRadius` | BorderRadius.circular(12) |
| `smoothRadius` | BorderRadius.circular(24) |
| `fullRadius` | BorderRadius.circular(999) |

```dart
// Card with standard radius
Container(
  decoration: BoxDecoration(
    borderRadius: FiftyRadii.standardRadius,
    color: FiftyColors.gunmetal,
  ),
)
```

---

### Motion

**Philosophy:** Kinetic. Heavy but fast. **NO FADES.**

Use slides, wipes, and reveals. Think shutter closing, manga page turning, blast door opening.

**Durations:**

| Token | Duration | Usage |
|-------|----------|-------|
| `instant` | 0ms | Logic changes, immediate state updates |
| `fast` | 150ms | Hover states, micro-interactions |
| `compiling` | 300ms | Panel reveals, modal entrances |
| `systemLoad` | 800ms | Staggered entry, page load sequences |

**Easing Curves:**

| Token | Cubic Bezier | Usage |
|-------|--------------|-------|
| `standard` | (0.2, 0, 0, 1) | General-purpose, smooth ease |
| `enter` | (0.2, 0.8, 0.2, 1) | Springy entrance, slight overshoot |
| `exit` | (0.4, 0, 1, 1) | Sharp exit, quick and decisive |

```dart
// Panel reveal animation
AnimatedContainer(
  duration: FiftyMotion.compiling,
  curve: FiftyMotion.enter,
  // ... slide transform, NOT opacity fade
)
```

**Loading States:**

Never use spinners. Use text sequences:

```
> INITIALIZING...
> LOADING ASSETS...
> DONE.
```

---

### Elevation

**Philosophy:** No drop shadows. Use outlines and overlays.

Depth is created through surface colors (voidBlack -> gunmetal), not shadow projections. The only exception is the crimson glow - the brand signature.

**Glow Effects:**

| Token | Effect | Usage |
|-------|--------|-------|
| `crimsonGlow` | crimsonPulse @ 45%, blur 8px | Focus/hover states, CMD prompt glow |
| `focusRing` | crimsonPulse @ 60%, blur 4px | Keyboard accessibility indicator |

**Glow Lists:**

| Token | Shadows | Usage |
|-------|---------|-------|
| `focus` | [crimsonGlow] | Standard focus state |
| `strongFocus` | [focusRing, crimsonGlow] | Enhanced emphasis |

```dart
// Focus state with crimson glow
Container(
  decoration: BoxDecoration(
    color: FiftyColors.gunmetal,
    borderRadius: FiftyRadii.standardRadius,
    boxShadow: isFocused ? FiftyElevation.focus : null,
  ),
)
```

**Creating Depth Without Shadows:**

Instead of drop shadows, use:
- Surface colors: voidBlack -> gunmetal hierarchy
- Borders: 1px solid hyperChrome @ 10% opacity
- Overlays: Glassmorphism with blur (20px)
- Textures: Halftone overlays at 5% opacity

---

### Breakpoints

| Token | Width | Usage |
|-------|-------|-------|
| `mobile` | 768px | Screens below this are mobile |
| `tablet` | 768px | Screens at or above, below desktop |
| `desktop` | 1024px | Screens at or above are desktop |

```dart
// Responsive gutter selection
final gutter = MediaQuery.of(context).size.width >= FiftyBreakpoints.desktop
    ? FiftySpacing.gutterDesktop
    : MediaQuery.of(context).size.width >= FiftyBreakpoints.tablet
        ? FiftySpacing.gutterTablet
        : FiftySpacing.gutterMobile;
```

---

## Design Philosophy

### Kinetic Brutalism

The FDL is classified as **Kinetic Brutalism** - a design approach that combines:

- **Aggressive Structure:** High density bento-grid layouts
- **Dark Mode Native:** OLED-optimized, terminal-inspired
- **Kinetic Motion:** Nothing fades in; it slides, wipes, or compiles
- **Dual Persona:** The Engineer (Logic) + The Otaku (Chaos)

### The Crimson Pulse

`#960E29` is not decoration - it is the system's heartbeat.

**Usage Rules:**
- Apply sparingly for maximum impact
- Reserve for: Primary actions, focus states, errors, brand moments
- The crimson glow effect is the signature visual element

### Surface Hierarchy

Depth is created through value changes, not shadows:

| Level | Color | Purpose |
|-------|-------|---------|
| Base | voidBlack (#050505) | The infinite canvas |
| Surface | gunmetal (#1A1A1A) | Cards, panels, containers |

### NO FADES

Motion uses physical metaphors:
- Slides (lateral movement)
- Wipes (directional reveals)
- Reveals (shutter/blast door opening)

Opacity fades feel digital and lifeless. FDL motion feels mechanical and alive.

---

## Font Requirements

The FDL typography system requires two font families:

### Monument Extended

A bold extended sans-serif for headlines and display text.

**License:** Commercial license required for production use.
**Source:** [Monument Extended](https://pangrampangram.com/products/monument-extended)

**Fallback:** If Monument Extended is unavailable, use a similar extended sans-serif or configure a custom fallback in your theme.

### JetBrains Mono

An open-source monospace font for body, code, and UI elements.

**License:** Open Font License (free for all use)
**Source:** [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

**Flutter Setup:**

1. Add fonts to your `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Monument Extended
      fonts:
        - asset: fonts/MonumentExtended-Regular.otf
          weight: 400
        - asset: fonts/MonumentExtended-Ultrabold.otf
          weight: 800
    - family: JetBrains Mono
      fonts:
        - asset: fonts/JetBrainsMono-Regular.ttf
          weight: 400
        - asset: fonts/JetBrainsMono-Medium.ttf
          weight: 500
```

2. Place font files in your `fonts/` directory.

---

## Examples

### Building a "Data Slate" Card

The Data Slate is the primary content container in FDL.

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

class DataSlate extends StatelessWidget {
  final String title;
  final String content;

  const DataSlate({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: FiftyColors.border),
        // No shadow - depth through surface color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyHeadline,
              fontSize: FiftyTypography.section,
              fontWeight: FiftyTypography.ultrabold,
              color: FiftyColors.terminalWhite,
              letterSpacing: FiftyTypography.tight * FiftyTypography.section,
              height: FiftyTypography.headingLineHeight,
            ),
          ),
          SizedBox(height: FiftySpacing.sm),
          Text(
            content,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              color: FiftyColors.terminalWhite,
              height: FiftyTypography.bodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Focus State with Crimson Glow

```dart
class FocusableCard extends StatefulWidget {
  @override
  _FocusableCardState createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: FiftyMotion.fast,
        curve: FiftyMotion.standard,
        decoration: BoxDecoration(
          color: FiftyColors.gunmetal,
          borderRadius: FiftyRadii.standardRadius,
          border: Border.all(
            color: _isFocused ? FiftyColors.crimsonPulse : FiftyColors.border,
          ),
          boxShadow: _isFocused ? FiftyElevation.focus : null,
        ),
        child: // ... content
      ),
    );
  }
}
```

### Terminal Text Style

```dart
// IGRIS terminal output style
Text(
  '> SYSTEM INITIALIZED',
  style: TextStyle(
    fontFamily: FiftyTypography.fontFamilyMono,
    fontSize: FiftyTypography.mono,
    color: FiftyColors.igrisGreen,
    height: FiftyTypography.codeLineHeight,
  ),
)

// Standard terminal output
Text(
  '> Loading assets...',
  style: TextStyle(
    fontFamily: FiftyTypography.fontFamilyMono,
    fontSize: FiftyTypography.mono,
    color: FiftyColors.terminalWhite.withOpacity(0.7),
    height: FiftyTypography.codeLineHeight,
  ),
)
```

### Kinetic Panel Reveal

```dart
class RevealPanel extends StatefulWidget {
  @override
  _RevealPanelState createState() => _RevealPanelState();
}

class _RevealPanelState extends State<RevealPanel> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: FiftyMotion.compiling,
      curve: FiftyMotion.enter,
      offset: _isVisible ? Offset.zero : Offset(0, 1), // Slide from bottom
      child: Container(
        color: FiftyColors.gunmetal,
        // ... panel content
      ),
    );
  }
}
```

---

## Architecture

### Package Structure

```
fifty_tokens/
├── lib/
│   ├── fifty_tokens.dart          # Main export
│   └── src/
│       ├── colors.dart            # FiftyColors (10 tokens)
│       ├── typography.dart        # FiftyTypography (14 tokens)
│       ├── spacing.dart           # FiftySpacing (15 tokens)
│       ├── radii.dart             # FiftyRadii (6 tokens)
│       ├── motion.dart            # FiftyMotion (7 tokens)
│       ├── shadows.dart           # FiftyElevation (4 tokens)
│       └── breakpoints.dart       # FiftyBreakpoints (3 tokens)
└── test/                          # 73 passing tests
```

### Ecosystem Position

`fifty_tokens` is the **foundation layer** (Pilot 1) of the fifty.dev ecosystem.

```
fifty_tokens (this package)
    |
    v
fifty_theme (Flutter theming layer)
    |
    v
fifty_ui (Component library)
    |
    v
fifty_docs (Documentation viewer)
```

All fifty.dev packages reference these tokens for visual consistency.

---

## Related Packages

| Package | Version | Description |
|---------|---------|-------------|
| `fifty_tokens` | v0.2.0 | Design tokens (you are here) |
| [fifty_theme](../fifty_theme) | v0.1.0 | Flutter ThemeData integration |
| `fifty_ui` | Coming soon | Component library |

---

## Testing

```bash
flutter test
```

**Results:** 73 passing tests, 100% token coverage.

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 fifty.dev (Mohamed Elamin)

---

**Part of the [fifty.dev ecosystem](https://fifty.dev) | Pilot 1: Foundation Layer**

*The interface is the machine. Make it feel alive.*
