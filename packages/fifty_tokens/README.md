# Fifty Tokens

Design tokens for Fifty Flutter Kit — the foundation layer of the Fifty Design Language (FDL), providing colors, typography, spacing, motion, radii, shadows, gradients, and breakpoints as pure Dart constants. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Features

- **Color Tokens** - Core palette, semantic aliases, and mode-specific helpers for the Sophisticated Warm design system
- **Typography Tokens** - Unified Manrope font family with a complete type scale, weights, letter spacing, and line heights
- **Spacing Tokens** - 4px base grid with named scale (xs–massive) and responsive gutters
- **Radii Tokens** - Complete border radius scale (none–full) with pre-built BorderRadius convenience objects
- **Motion Tokens** - Duration constants and easing curves for kinetic, slide-based animations
- **Shadow Tokens** - Soft, sophisticated box shadow presets (sm, md, lg, primary, glow)
- **Gradient Tokens** - LinearGradient presets for hero, progress, and surface backgrounds
- **Breakpoint Tokens** - Screen width thresholds and paired responsive gutter values
- **Zero UI, Pure Constants** - No widgets, no state — just Dart constants consumable by any Flutter package

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_tokens:
    path: ../fifty_tokens
```

Then run:

```bash
flutter pub get
```

The package requires `google_fonts` (included transitively) for Manrope font loading.

---

## Quick Start

```dart
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

// Build a card using FDL v2 tokens
Container(
  padding: EdgeInsets.all(FiftySpacing.md),
  decoration: BoxDecoration(
    color: FiftyColors.surfaceDark,
    borderRadius: FiftyRadii.xxlRadius,
    border: Border.all(color: FiftyColors.borderDark),
    boxShadow: FiftyShadows.md,
  ),
  child: Text(
    'Fifty Design Language',
    style: TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: FiftyTypography.titleLarge,
      fontWeight: FiftyTypography.bold,
      color: FiftyColors.cream,
    ),
  ),
)
```

---

## Architecture

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
│       └── breakpoints.dart   # FiftyBreakpoints
└── test/
```

Kit position — `fifty_tokens` is the foundation layer:

```
fifty_tokens  (this package — design constants)
    |
    v
fifty_theme   (Flutter ThemeData integration)
    |
    v
fifty_ui      (Component library)
```

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftyColors` | Core palette, semantic aliases, and mode-specific border/focus helpers |
| `FiftyTypography` | Manrope font family, weights, type scale, letter spacing, and line heights |
| `FiftySpacing` | 4px base grid, named scale (xs–massive), and responsive gutters |
| `FiftyRadii` | Border radius values (none–full) and paired BorderRadius objects |
| `FiftyMotion` | Duration constants (instant, fast, compiling, systemLoad) and Cubic easing curves |
| `FiftyShadows` | Box shadow presets — sm, md, lg, primary (burgundy), and glow (cream) |
| `FiftyGradients` | LinearGradient presets — primary, progress, and surface |
| `FiftyBreakpoints` | Screen width thresholds: mobile (768px), tablet (768px), desktop (1024px) |

---

## API Reference

### FiftyColors

```dart
// Core palette (v2 — Sophisticated Warm)
FiftyColors.burgundy        // #88292F — Primary brand, buttons, CTAs, active states
FiftyColors.burgundyHover   // #6E2126 — Primary hover state
FiftyColors.cream           // #FEFEE3 — Light backgrounds; dark mode primary text
FiftyColors.darkBurgundy    // #1A0D0E — Dark mode backgrounds
FiftyColors.slateGrey       // #335C67 — Secondary buttons, switch on-state
FiftyColors.slateGreyHover  // #274750 — Secondary hover state
FiftyColors.hunterGreen     // #4B644A — Success, positive indicators
FiftyColors.powderBlush     // #FFC9B9 — Dark mode accent, outline borders, focus rings
FiftyColors.surfaceLight    // #FAF9DE — Light mode cards and surfaces
FiftyColors.surfaceDark     // #2A1517 — Dark mode cards and surfaces

// Semantic aliases
FiftyColors.primary         // → burgundy
FiftyColors.primaryHover    // → burgundyHover
FiftyColors.secondary       // → slateGrey
FiftyColors.secondaryHover  // → slateGreyHover
FiftyColors.success         // → hunterGreen
FiftyColors.warning         // #F7A100
FiftyColors.error           // → burgundy

// Mode-specific helpers (getters, not const)
FiftyColors.borderLight     // black @ 5% opacity
FiftyColors.borderDark      // white @ 5% opacity
FiftyColors.focusLight      // → burgundy
FiftyColors.focusDark       // powderBlush @ 50% opacity
```

### FiftyTypography

```dart
// Font family — load via GoogleFonts.manrope()
FiftyTypography.fontFamily        // 'Manrope'

// Weights
FiftyTypography.regular           // FontWeight.w400
FiftyTypography.medium            // FontWeight.w500
FiftyTypography.semiBold          // FontWeight.w600
FiftyTypography.bold              // FontWeight.w700
FiftyTypography.extraBold         // FontWeight.w800

// Type scale (px)
FiftyTypography.displayLarge      // 32 — Hero headlines
FiftyTypography.displayMedium     // 24 — Section headlines
FiftyTypography.titleLarge        // 20 — Card titles
FiftyTypography.titleMedium       // 18 — App bar titles
FiftyTypography.titleSmall        // 16 — List item titles
FiftyTypography.bodyLarge         // 16 — Primary body text
FiftyTypography.bodyMedium        // 14 — Secondary body text
FiftyTypography.bodySmall         // 12 — Captions, hints
FiftyTypography.labelLarge        // 14 — Button labels
FiftyTypography.labelMedium       // 12 — Input labels (UPPERCASE)
FiftyTypography.labelSmall        // 10 — Bottom nav, badges

// Letter spacing
FiftyTypography.letterSpacingDisplay        // -0.5 — Headlines
FiftyTypography.letterSpacingDisplayMedium  // -0.25
FiftyTypography.letterSpacingBody           // 0.5
FiftyTypography.letterSpacingBodyMedium     // 0.25
FiftyTypography.letterSpacingBodySmall      // 0.4
FiftyTypography.letterSpacingLabel          // 0.5
FiftyTypography.letterSpacingLabelMedium    // 1.5 — UPPERCASE labels

// Line heights
FiftyTypography.lineHeightDisplay   // 1.2 — Headlines
FiftyTypography.lineHeightTitle     // 1.3 — Titles
FiftyTypography.lineHeightBody      // 1.5 — Body text
FiftyTypography.lineHeightLabel     // 1.2 — Compact labels
```

### FiftySpacing

```dart
FiftySpacing.base           // 4px — Fundamental unit
FiftySpacing.tight          // 8px  — Compact element spacing
FiftySpacing.standard       // 12px — Card padding, field spacing
FiftySpacing.xs             // 4px
FiftySpacing.sm             // 8px
FiftySpacing.md             // 12px
FiftySpacing.lg             // 16px
FiftySpacing.xl             // 20px
FiftySpacing.xxl            // 24px
FiftySpacing.xxxl           // 32px
FiftySpacing.huge           // 40px
FiftySpacing.massive        // 48px
FiftySpacing.gutterMobile   // 12px
FiftySpacing.gutterTablet   // 16px
FiftySpacing.gutterDesktop  // 24px
```

### FiftyRadii

```dart
// Values (double)
FiftyRadii.none    // 0 — No radius
FiftyRadii.sm      // 4px — Checkboxes, small badges
FiftyRadii.md      // 8px — Chips, tags
FiftyRadii.lg      // 12px — Standard cards (legacy)
FiftyRadii.xl      // 16px — Buttons, text fields
FiftyRadii.xxl     // 24px — Standard cards
FiftyRadii.xxxl    // 32px — Hero cards, modals
FiftyRadii.full    // 9999px — Pills, avatars

// Convenience BorderRadius objects
FiftyRadii.noneRadius   // BorderRadius.zero
FiftyRadii.smRadius     // BorderRadius.circular(4)
FiftyRadii.mdRadius     // BorderRadius.circular(8)
FiftyRadii.lgRadius     // BorderRadius.circular(12)
FiftyRadii.xlRadius     // BorderRadius.circular(16)
FiftyRadii.xxlRadius    // BorderRadius.circular(24)
FiftyRadii.xxxlRadius   // BorderRadius.circular(32)
FiftyRadii.fullRadius   // BorderRadius.circular(9999)
```

### FiftyMotion

```dart
// Durations
FiftyMotion.instant      // 0ms  — Logic changes, immediate state updates
FiftyMotion.fast         // 150ms — Hover states, micro-interactions
FiftyMotion.compiling    // 300ms — Panel reveals, modal entrances
FiftyMotion.systemLoad   // 800ms — Staggered entry, page load sequences

// Easing curves (Cubic)
FiftyMotion.standard     // (0.2, 0, 0, 1)   — General-purpose
FiftyMotion.enter        // (0.2, 0.8, 0.2, 1) — Springy entrance
FiftyMotion.exit         // (0.4, 0, 1, 1)   — Sharp, decisive exit
```

### FiftyShadows

```dart
// const List<BoxShadow>
FiftyShadows.sm    // 0 1px 2px rgba(0,0,0,0.05) — Subtle elevation, hover states
FiftyShadows.md    // 0 4px 6px rgba(0,0,0,0.07) — Cards, elevated containers
FiftyShadows.lg    // 0 10px 15px rgba(0,0,0,0.1) — Modals, dropdowns, dialogs
FiftyShadows.none  // [] — Explicit no shadow

// Getters (non-const, reference FiftyColors)
FiftyShadows.primary  // 0 4px 14px burgundy@20% — Primary action buttons
FiftyShadows.glow     // 0 0 15px cream@10% — Dark mode focus, accent highlights
```

### FiftyGradients

```dart
// const LinearGradient
FiftyGradients.primary   // topLeft→bottomRight: #88292F → #5A1B1F (hero sections, featured cards)
FiftyGradients.progress  // #FFC9B9 → #88292F (progress bars, loading indicators)
FiftyGradients.surface   // topCenter→bottomCenter: #1A0D0E → #2A1517 (background depth, card overlays)
```

### FiftyBreakpoints

```dart
FiftyBreakpoints.mobile   // 768.0 — Screens below are mobile (gutter: 12px)
FiftyBreakpoints.tablet   // 768.0 — Screens >= tablet, < desktop (gutter: 16px)
FiftyBreakpoints.desktop  // 1024.0 — Screens >= desktop (gutter: 24px)
```

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
        color: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
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
              color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
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
              color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
              height: FiftyTypography.lineHeightBody,
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
          color: FiftyColors.surfaceDark,
          borderRadius: FiftyRadii.xxlRadius,
          border: Border.all(
            color: _isFocused ? FiftyColors.focusDark : FiftyColors.borderDark,
          ),
          boxShadow: _isFocused ? FiftyShadows.glow : FiftyShadows.none,
        ),
        child: const SizedBox(height: 80, width: double.infinity),
      ),
    );
  }
}
```

### Kinetic Panel Reveal (No Fades)

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
      offset: _isVisible ? Offset.zero : const Offset(0, 1),
      child: Container(
        color: FiftyColors.surfaceDark,
        padding: EdgeInsets.all(FiftySpacing.lg),
        // ... panel content
      ),
    );
  }
}
```

### Hero Section with Primary Gradient

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
      color: FiftyColors.cream,
      letterSpacing: FiftyTypography.letterSpacingDisplay,
      height: FiftyTypography.lineHeightDisplay,
    ),
  ),
)
```

### Responsive Gutter Selection

```dart
final gutter = MediaQuery.of(context).size.width >= FiftyBreakpoints.desktop
    ? FiftySpacing.gutterDesktop
    : MediaQuery.of(context).size.width >= FiftyBreakpoints.tablet
        ? FiftySpacing.gutterTablet
        : FiftySpacing.gutterMobile;
```

### Motion Loading State (Text Sequence — No Spinners)

FDL loading states use text sequences, never spinners:

```
> INITIALIZING...
> LOADING ASSETS...
> DONE.
```

```dart
Text(
  '> INITIALIZING...',
  style: TextStyle(
    fontFamily: FiftyTypography.fontFamily,
    fontSize: FiftyTypography.bodySmall,
    fontWeight: FiftyTypography.medium,
    color: FiftyColors.powderBlush,
    letterSpacing: FiftyTypography.letterSpacingLabel,
  ),
)
```

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     | |
| iOS      | Yes     | |
| macOS    | Yes     | |
| Linux    | Yes     | |
| Windows  | Yes     | |
| Web      | Yes     | |

Pure Dart constants — no platform channels or native code required. The `google_fonts` dependency fetches Manrope at runtime or can be bundled as an asset font.

### Font Setup

Manrope is loaded via `google_fonts`. Add `google_fonts` to your app's `pubspec.yaml` if not already present:

```yaml
dependencies:
  google_fonts: ^6.2.1
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

- **Foundation layer** - Every other Fifty Flutter Kit package (`fifty_theme`, `fifty_ui`) imports `fifty_tokens` as its single source of design truth; no values are hardcoded in consuming packages
- **FDL v2 "Sophisticated Warm"** - The color system uses a warm burgundy-and-cream palette that supports both dark and light modes; v1 tokens remain available but are marked `@Deprecated` and will be removed in a future major version
- **Motion philosophy** - FDL enforces kinetic (slide/wipe/reveal) animation throughout the kit; `FiftyMotion` provides the timing contracts that all animated components reference

---

## Version

**Current:** 1.0.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
