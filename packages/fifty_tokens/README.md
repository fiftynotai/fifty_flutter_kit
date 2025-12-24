# fifty_tokens · fifty.dev

> Design tokens for the fifty.dev ecosystem - the foundation of visual identity in code

[![pub package](https://img.shields.io/badge/pub-v0.1.0-crimson)](https://pub.dev/packages/fifty_tokens)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?logo=flutter)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/tests-59%20passing-success)](test/)

---

## What is fifty_tokens?

`fifty_tokens` is the foundation package for the fifty.dev ecosystem. It provides **76 design tokens** as pure Dart constants with **zero external dependencies**.

These tokens implement the **Fifty Design Language (FDL)** - a dark, minimalist design system centered around a crimson identity and 8px-based grid.

**Token Categories:**
- 🎨 **Colors** - Crimson palette, surfaces, text, semantic states
- 🔤 **Typography** - Font families, type scale, weights, spacing
- 📏 **Spacing** - 8px-based grid, responsive gutters
- ⭕ **Radii** - Border radius values and convenience objects
- ⏱️ **Motion** - Animation durations and easing curves
- 🌟 **Elevation** - Shadows and crimson glow effects
- 📱 **Breakpoints** - Responsive design thresholds

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_tokens: ^0.1.0
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

// Use color tokens
Container(
  color: FiftyColors.surface1,
  child: Text(
    'Hello, fifty.dev',
    style: TextStyle(
      color: FiftyColors.textPrimary,
      fontSize: FiftyTypography.h1,
      fontFamily: FiftyTypography.fontFamilyDisplay,
    ),
  ),
)

// Use spacing and radii
Container(
  padding: EdgeInsets.all(FiftySpacing.lg),
  margin: EdgeInsets.symmetric(vertical: FiftySpacing.xxl),
  decoration: BoxDecoration(
    color: FiftyColors.surface2,
    borderRadius: FiftyRadii.mdRadius,
    boxShadow: FiftyElevation.card,
  ),
)

// Use motion tokens
AnimatedContainer(
  duration: FiftyMotion.base,
  curve: FiftyMotion.standard,
  // ... properties
)
```

---

## Token Reference

### Colors (14 tokens)

| Token | Hex | Usage |
|-------|-----|-------|
| `crimsonCore` | #960E29 | Brand identity, primary buttons |
| `techCrimson` | #B31337 | Focus rings, glow, accents |
| `surface0` | #0E0E0F | Background |
| `surface1` | #161617 | Cards, containers |
| `surface2` | #1D1D1F | Panels, modals |
| `surface3` | rgba(255,255,255,0.03) | Floating overlays |
| `border` | #2C2C2E | Outlines |
| `divider` | #3A3A3C | Separators |
| `textPrimary` | #FFFFFF | Headings |
| `textSecondary` | #E5E5E7 | Body text |
| `muted` | #9E9EA0 | Captions, metadata |
| `success` | #00BA33 | Positive states |
| `warning` | #F7A100 | Alerts, caution |
| `error` | #B31337 | Errors, destructive actions |

### Typography (21 tokens)

**Font Families:**
- `fontFamilyDisplay` - 'Space Grotesk' (headings)
- `fontFamilyBody` - 'Inter' (body text)
- `fontFamilyCode` - 'JetBrains Mono' (code)

**Font Weights:**
- `regular` (400), `medium` (500), `semiBold` (600), `bold` (700)

**Type Scale (Minor Third 1.25):**
- `displayXL` (48px), `h1` (32px), `h2` (28px), `h3` (24px)
- `bodyLarge` (20px), `bodyBase` (16px), `bodySmall` (14px), `caption` (12px)

**Letter Spacing:**
- `headingLetterSpacing` (-1%), `bodyLetterSpacing` (+0.25%)

**Line Heights:**
- `displayLineHeight` (1.1), `headingLineHeight` (1.2), `bodyLineHeight` (1.5), `codeLineHeight` (1.6)

### Spacing (13 tokens)

**Spacing Scale (8px base grid):**
- `micro` (2px), `xs` (4px), `sm` (8px), `md` (12px), `lg` (16px)
- `xl` (20px), `xxl` (24px), `xxxl` (32px), `huge` (40px), `massive` (48px)

**Responsive Gutters:**
- `gutterDesktop` (24px), `gutterTablet` (16px), `gutterMobile` (12px)

### Radii (10 tokens)

**Raw Values:**
- `xs` (4px), `sm` (6px), `md` (10px), `lg` (16px), `full` (999px)

**BorderRadius Objects:**
- `xsRadius`, `smRadius`, `mdRadius`, `lgRadius`, `fullRadius`

### Motion (8 tokens)

**Durations:**
- `fast` (120ms), `base` (180ms), `slow` (240ms), `overlay` (280ms)

**Easing Curves:**
- `emphasisEnter` - cubic-bezier(0.2, 0.8, 0.2, 1) - Springy entrance
- `emphasisExit` - cubic-bezier(0.4, 0, 1, 1) - Sharp exit
- `standard` - cubic-bezier(0.2, 0, 0, 1) - Smooth ease
- `spring` - cubic-bezier(0.16, 1, 0.3, 1) - Bouncy spring

### Elevation (10 tokens)

**Shadows:**
- `ambient` - rgba(0,0,0,0.3), blur: 12px
- `crimsonGlow` - Crimson Core @ 45%, blur: 8px
- `focusRing` - Tech Crimson @ 60%, blur: 4px

**Shadow Lists:**
- `card`, `focus`, `hoverCard`, `glowOnly`

### Breakpoints (3 tokens)

- `mobile` (768px), `tablet` (768px), `desktop` (1024px)

---

## Design Philosophy

### Why Crimson?

The crimson palette (`#960E29` and `#B31337`) is the visual signature of fifty.dev. It's not decoration - it's identity.

**Usage Philosophy:**
- Apply crimson sparingly (≤15% in UI) for maximum impact
- Use for focus states, brand moments, and emphasis
- The "crimson glow" effect is the signature visual element

### Why 8px Grid?

The spacing system follows an 8px base grid with fine-tuning options (2px, 4px).

**Benefits:**
- Ensures visual rhythm and alignment
- Easy mental math (multiples of 8)
- Accommodates standard screen densities
- Creates consistent breathing room

### Why Minor Third Typography?

The type scale uses a minor third ratio (1.25), creating clear hierarchy without extreme jumps.

**Scale:** 48 → 32 → 28 → 24 → 20 → 16 → 14 → 12

This provides 8 distinct sizes that work together harmoniously.

### Dark Mode First

All tokens are optimized for dark environments. Dark mode isn't an afterthought - it's the primary environment.

**Surface Hierarchy:**
- Surface 0 (darkest) → Surface 3 (lightest overlay)
- Creates depth through subtle value changes
- White text on dark backgrounds for maximum contrast

---

## Usage Examples

### Building a Card

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

Container(
  padding: EdgeInsets.all(FiftySpacing.lg),
  margin: EdgeInsets.only(bottom: FiftySpacing.xxl),
  decoration: BoxDecoration(
    color: FiftyColors.surface1,
    borderRadius: FiftyRadii.mdRadius,
    border: Border.all(color: FiftyColors.border),
    boxShadow: FiftyElevation.card,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Card Title',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyDisplay,
          fontSize: FiftyTypography.h2,
          fontWeight: FiftyTypography.semiBold,
          color: FiftyColors.textPrimary,
          letterSpacing: FiftyTypography.headingLetterSpacing,
        ),
      ),
      SizedBox(height: FiftySpacing.sm),
      Text(
        'Card description text using body typography.',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyBody,
          fontSize: FiftyTypography.bodyBase,
          color: FiftyColors.textSecondary,
          height: FiftyTypography.bodyLineHeight,
        ),
      ),
    ],
  ),
)
```

### Building a Button with Glow

```dart
AnimatedContainer(
  duration: FiftyMotion.fast,
  curve: FiftyMotion.emphasisEnter,
  padding: EdgeInsets.symmetric(
    horizontal: FiftySpacing.xl,
    vertical: FiftySpacing.md,
  ),
  decoration: BoxDecoration(
    color: FiftyColors.crimsonCore,
    borderRadius: FiftyRadii.smRadius,
    boxShadow: isHovered ? FiftyElevation.focus : null,
  ),
  child: Text(
    'Click Me',
    style: TextStyle(
      fontFamily: FiftyTypography.fontFamilyDisplay,
      fontSize: FiftyTypography.bodyBase,
      fontWeight: FiftyTypography.semiBold,
      color: FiftyColors.textPrimary,
    ),
  ),
)
```

### Responsive Layout

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;
    final gutter = width >= FiftyBreakpoints.desktop
        ? FiftySpacing.gutterDesktop
        : width >= FiftyBreakpoints.tablet
            ? FiftySpacing.gutterTablet
            : FiftySpacing.gutterMobile;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: // ... content
    );
  },
)
```

---

## Architecture

### Package Structure

```
fifty_tokens/
├── lib/
│   ├── fifty_tokens.dart          # Main export
│   └── src/
│       ├── colors.dart             # FiftyColors (14 tokens)
│       ├── typography.dart         # FiftyTypography (21 tokens)
│       ├── spacing.dart            # FiftySpacing (13 tokens)
│       ├── radii.dart              # FiftyRadii (10 tokens)
│       ├── motion.dart             # FiftyMotion (8 tokens)
│       ├── shadows.dart            # FiftyElevation (7 shadows)
│       └── breakpoints.dart        # FiftyBreakpoints (3 tokens)
└── test/                           # 59 passing tests
```

### Zero Dependencies

This package has **zero external dependencies** (Flutter SDK only). No bloat, just constants.

### Ecosystem Position

`fifty_tokens` is the **foundation layer** of the fifty.dev ecosystem (Pilot 1).

**Dependency Chain:**
```
fifty_tokens (this package)
    ↓
fifty_theme (Flutter theming layer)
    ↓
fifty_ui (Component library)
    ↓
fifty_docs (Documentation viewer)
```

All fifty.dev packages reference these tokens for visual consistency.

---

## Testing

The package includes a comprehensive test suite validating all 76 tokens.

**Run tests:**

```bash
flutter test
```

**Test Coverage:**
- 59 passing tests
- 100% token coverage
- Critical validations: Crimson accuracy, type scale, 8px grid, motion curves

---

## Design System Reference

This package implements the **Fifty Design Language (FDL)** specification.

**Key Design Principles:**
- **Crimson Identity** - #960E29 and #B31337 are brand signatures
- **8px Grid** - Visual rhythm through consistent spacing
- **Dark Mode First** - Optimized for dark environments
- **Minor Third Scale** - Typography ratio of 1.25 for hierarchy
- **Motion with Purpose** - Consistent timing, accessible animations

Full specification: [Fifty Design System](https://github.com/fiftynotai/fifty-design-system)

---

## Roadmap

### v0.1.0 (Current)
- ✅ Complete token implementation (76 tokens)
- ✅ Comprehensive test suite (59 tests)
- ✅ Zero external dependencies
- ✅ Full API documentation

### v0.2.0 (Future)
- Light mode color variants
- Additional semantic colors
- Extended spacing scale
- JSON export for design tools

### v1.0.0 (Stable)
- API stability guarantee
- Theme extensions for Material 3
- Figma plugin integration
- Additional easing curves

---

## Contributing

This package is part of the fifty.dev ecosystem. Contributions should align with the Fifty Design Language (FDL).

**Before contributing:**
1. Read the [FDL specification](https://github.com/fiftynotai/fifty-design-system)
2. Ensure changes maintain FDL fidelity
3. Add tests for new tokens
4. Run `flutter analyze` and `flutter test`

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 fifty.dev (Mohamed Elamin)

---

## About fifty.dev

fifty.dev is a modular ecosystem of Flutter packages and AI tools built with engineering precision and creative individuality.

**Core Philosophy:**
> "Building systems that build things."

**The Ecosystem:**
- `fifty_tokens` - Design tokens (you are here)
- `fifty_theme` - Flutter theming layer
- `fifty_ui` - Component library
- `fifty_docs` - Documentation system
- `fifty_cmd` - Command palette framework
- `fifty_ai` - AI workflow layer
- ...and more (15 packages total)

**Learn More:**
- 🌐 Website: [fifty.dev](https://fifty.dev)
- 📦 Ecosystem Map: [Package Roadmap](https://github.com/fiftynotai/fifty-ecosystem)
- 🎨 Design System: [FDL Specification](https://github.com/fiftynotai/fifty-design-system)

---

**Part of the [fifty.dev ecosystem](https://fifty.dev) · Pilot 1: Foundation Layer**

*Design systems aren't about colors and buttons — they're about memory. When someone sees your crimson glow, they should know it's you.*
