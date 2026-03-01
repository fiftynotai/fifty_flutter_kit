# AC-007: Semantic Token Config & JSON-Driven Theming

## Metadata

- **Type:** Architecture Cleanup
- **Priority:** P1
- **Status:** Ready
- **Effort:** L
- **Created:** 2026-03-01
- **Depends On:** AC-001 (Done), TD-009 (Done)

---

## Problem

The fifty_tokens configuration system has four architectural issues that prevent the package from fulfilling its core value proposition: **easy brand customization from a single configuration**.

1. **Color config uses palette names** (`burgundy`, `cream`, `darkBurgundy`) instead of semantic/purpose names (`primary`, `background`, `backgroundDark`). A consumer configuring `cream` is meaningless — they want to configure `background`.

2. **Defaults are hardcoded inside each token class** as scattered `_defaultX` constants. Each class knows about FDL v2 specifically. Instead, FDL v2 should be a single preset defined externally, and the token classes should be agnostic readers that just consume whatever preset is active.

3. **Incomplete configurability** — Shadows (5 tokens), gradients (3 tokens), and 3 color properties (`borderLight`, `borderDark`, `focusDark`) are hardcoded with no config support.

4. **No Map parser** — No way to build a preset from a Map/JSON at runtime.

---

## Goal

A consumer can change the entire app appearance by loading a preset:

```dart
void main() {
  // From JSON
  final preset = FiftyPreset.fromMap(jsonDecode(jsonString));
  FiftyTokens.load(preset);
  runApp(MyApp());
}
```

Or by configuring individual categories:

```dart
void main() {
  // Only change colors — rest stays FDL v2
  FiftyTokens.configure(
    colors: FiftyColorConfig(primary: Color(0xFF0066FF), ...),
  );
  runApp(MyApp());
}
```

When a consumer does nothing, FDL v2 loads automatically as the default preset. Token classes don't know or care what preset is active — they just read.

---

## Architecture

### Core Principle

The package's value is the **customization system**. FDL v2 is just the default preset that ships with it. Token classes are agnostic readers. A preset is a complete set of token values — whether built-in, parsed from JSON, or constructed in code.

### Data Flow

```
┌──────────────────────────────────────────────────┐
│                   FiftyTokens                     │
│                                                   │
│  load(preset)   configure(...)   reset()          │
│       │              │              │             │
│       v              v              v             │
│  ┌───────────────────────────────────────────┐    │
│  │         _active : FiftyPreset             │    │
│  │  (default = FiftyPreset.fdlV2)            │    │
│  └───────────────────────────────────────────┘    │
└───────────────────────┬──────────────────────────-┘
                        │
        ┌───────┬───────┼───────┬───────┬───────┐
        v       v       v       v       v       v
    Colors  Spacing  Typo    Radii  Motion  Shadows ...
    (reads) (reads) (reads) (reads) (reads) (reads)
```

### Before (Current — Classes Own Defaults)

```dart
class FiftyColors {
  static const Color _defaultBurgundy = Color(0xFF88292F);
  static const Color _defaultCream = Color(0xFFFEFEE3);
  // ... 9 more scattered constants baked into this class

  static FiftyColorConfig? config;

  static Color get burgundy => config?.burgundy ?? _defaultBurgundy;
  static Color get cream => config?.cream ?? _defaultCream;
}

class FiftySpacing {
  static const double _defaultXs = 4;
  static const double _defaultSm = 8;
  // ... more scattered constants

  static FiftySpacingConfig? config;

  static double get xs => config?.xs ?? _defaultXs;
}
```

**Problems:** Each class hardcodes FDL v2 values. Defaults scattered. Config is per-class nullable overlay.

### After (New — One Preset, Agnostic Readers)

```dart
/// A complete set of token values. The single data type for all theming.
class FiftyPreset {
  const FiftyPreset({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.motion,
    required this.shadows,
    required this.gradients,
    required this.breakpoints,
  });

  final FiftyColorConfig colors;
  final FiftyTypographyConfig typography;
  final FiftySpacingConfig spacing;
  final FiftyRadiiConfig radii;
  final FiftyMotionConfig motion;
  final FiftyShadowsConfig shadows;
  final FiftyGradientsConfig gradients;
  final FiftyBreakpointsConfig breakpoints;

  /// The built-in default — FDL v2 Sophisticated Warm.
  static const fdlV2 = FiftyPreset(
    colors: FiftyColorConfig(
      primary: Color(0xFF88292F),
      primaryHover: Color(0xFF6E2126),
      background: Color(0xFFFEFEE3),
      backgroundDark: Color(0xFF1A0D0E),
      secondary: Color(0xFF335C67),
      secondaryHover: Color(0xFF274750),
      success: Color(0xFF4B644A),
      accent: Color(0xFFFFC9B9),
      surface: Color(0xFFFAF9DE),
      surfaceDark: Color(0xFF2A1517),
      warning: Color(0xFFF7A100),
      error: Color(0xFF88292F),
      onPrimary: Color(0xFFFEFEE3),
      onBackground: Color(0xFF1A0D0E),
      borderOpacity: 0.05,
      focusOpacity: 0.5,
    ),
    typography: FiftyTypographyConfig(
      fontFamily: 'Manrope',
      fontSource: FontSource.googleFonts,
      displayLarge: 57,
      displayMedium: 45,
      titleLarge: 22,
      titleMedium: 16,
      titleSmall: 14,
      bodyLarge: 16,
      bodyMedium: 14,
      bodySmall: 12,
      // ... all typography values
    ),
    spacing: FiftySpacingConfig(
      base: 4, xs: 4, sm: 8, md: 12, lg: 16,
      xl: 24, xxl: 32, xxxl: 48,
      // ... all spacing values
    ),
    radii: FiftyRadiiConfig(
      sm: 4, md: 8, lg: 12, xl: 16, xxl: 24, full: 9999,
    ),
    motion: FiftyMotionConfig(
      instant: Duration.zero,
      fast: Duration(milliseconds: 150),
      compiling: Duration(milliseconds: 300),
      systemLoad: Duration(milliseconds: 800),
      // ... curves
    ),
    shadows: FiftyShadowsConfig(
      sm: [BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0D000000))],
      md: [BoxShadow(offset: Offset(0, 4), blurRadius: 6, color: Color(0x12000000))],
      lg: [BoxShadow(offset: Offset(0, 10), blurRadius: 15, color: Color(0x1A000000))],
      primaryOpacity: 0.2,
      glowOpacity: 0.1,
    ),
    gradients: FiftyGradientsConfig(
      primaryEnd: Color(0xFF5A1B1F),
    ),
    breakpoints: FiftyBreakpointsConfig(
      mobile: 768, tablet: 768, desktop: 1024,
    ),
  );

  /// Build a preset from a Map. Missing keys fall back to [fallback].
  factory FiftyPreset.fromMap(
    Map<String, dynamic> map, {
    FiftyPreset fallback = fdlV2,
  }) { ... }

  FiftyPreset copyWith({ ... });
}

/// Central token manager.
class FiftyTokens {
  static FiftyPreset _active = FiftyPreset.fdlV2;

  /// Load a complete preset.
  ///
  /// ```dart
  /// FiftyTokens.load(FiftyPreset.fromMap(jsonDecode(json)));
  /// FiftyTokens.load(myCustomPreset);
  /// ```
  static void load(FiftyPreset preset) {
    _active = preset;
  }

  /// Configure individual categories. Skipped categories stay FDL v2.
  ///
  /// ```dart
  /// FiftyTokens.configure(
  ///   colors: FiftyColorConfig(primary: Color(0xFF0066FF), ...),
  ///   // typography, spacing, etc. → FDL v2
  /// );
  /// ```
  static void configure({
    FiftyColorConfig? colors,
    FiftyTypographyConfig? typography,
    FiftySpacingConfig? spacing,
    FiftyRadiiConfig? radii,
    FiftyMotionConfig? motion,
    FiftyShadowsConfig? shadows,
    FiftyGradientsConfig? gradients,
    FiftyBreakpointsConfig? breakpoints,
  }) {
    _active = FiftyPreset(
      colors: colors ?? FiftyPreset.fdlV2.colors,
      typography: typography ?? FiftyPreset.fdlV2.typography,
      spacing: spacing ?? FiftyPreset.fdlV2.spacing,
      radii: radii ?? FiftyPreset.fdlV2.radii,
      motion: motion ?? FiftyPreset.fdlV2.motion,
      shadows: shadows ?? FiftyPreset.fdlV2.shadows,
      gradients: gradients ?? FiftyPreset.fdlV2.gradients,
      breakpoints: breakpoints ?? FiftyPreset.fdlV2.breakpoints,
    );
  }

  /// Reset to FDL v2 defaults.
  static void reset() {
    _active = FiftyPreset.fdlV2;
  }

  /// Whether a custom preset has been applied.
  static bool get isConfigured => !identical(_active, FiftyPreset.fdlV2);

  /// Read-only access to active preset (for token classes).
  static FiftyPreset get active => _active;
}

/// Token class — agnostic reader, zero knowledge of FDL v2.
class FiftyColors {
  FiftyColors._();

  static Color get primary => FiftyTokens.active.colors.primary;
  static Color get primaryHover => FiftyTokens.active.colors.primaryHover;
  static Color get background => FiftyTokens.active.colors.background;
  static Color get backgroundDark => FiftyTokens.active.colors.backgroundDark;
  static Color get secondary => FiftyTokens.active.colors.secondary;
  static Color get success => FiftyTokens.active.colors.success;
  static Color get accent => FiftyTokens.active.colors.accent;
  static Color get surface => FiftyTokens.active.colors.surface;
  static Color get surfaceDark => FiftyTokens.active.colors.surfaceDark;
  static Color get warning => FiftyTokens.active.colors.warning;
  static Color get error => FiftyTokens.active.colors.error;
  static Color get onPrimary => FiftyTokens.active.colors.onPrimary;
  static Color get onBackground => FiftyTokens.active.colors.onBackground;

  // Computed from config
  static Color get borderLight =>
      Colors.black.withValues(alpha: FiftyTokens.active.colors.borderOpacity);
  static Color get borderDark =>
      Colors.white.withValues(alpha: FiftyTokens.active.colors.borderOpacity);
  static Color get focusDark =>
      accent.withValues(alpha: FiftyTokens.active.colors.focusOpacity);
  static Color get focusLight => primary;

  // Deprecated palette names
  @Deprecated('Use primary instead')
  static Color get burgundy => primary;
  @Deprecated('Use background instead')
  static Color get cream => background;
  @Deprecated('Use backgroundDark instead')
  static Color get darkBurgundy => backgroundDark;
  @Deprecated('Use secondary instead')
  static Color get slateGrey => secondary;
  @Deprecated('Use success instead')
  static Color get hunterGreen => success;
  @Deprecated('Use accent instead')
  static Color get powderBlush => accent;
  @Deprecated('Use surface instead')
  static Color get surfaceLight => surface;
}

/// Same pattern for all other token classes:
class FiftySpacing {
  FiftySpacing._();
  static double get xs => FiftyTokens.active.spacing.xs;
  static double get sm => FiftyTokens.active.spacing.sm;
  // ... pure readers, zero defaults
}
```

### Key Design Decisions

1. **One data type: `FiftyPreset`** — A preset is a complete set of token values. Whether it's the built-in default, parsed from JSON, or constructed in code — same type.

2. **`FiftyPreset.fdlV2` is a static const on the class** — The default preset lives on the data type itself. No separate `FiftyPresets` class needed.

3. **Two methods for two jobs:**
   - `load(preset)` — Apply a complete preset (from JSON, from code, from anywhere)
   - `configure(...)` — Tweak individual categories, skipped ones fall back to FDL v2

4. **`fromMap()` is a builder on `FiftyPreset`** — Returns a preset object. Consumer passes the result to `load()`. Separation of building data vs applying it.

5. **All fields required (non-nullable)** — A preset is always complete. No null-checking in getters.

6. **Token classes have zero logic** — Pure pass-through getters. All intelligence is in `FiftyTokens` and `FiftyPreset`.

---

## Category Config Classes (Non-Nullable)

### FiftyColorConfig

```dart
class FiftyColorConfig {
  const FiftyColorConfig({
    required this.primary,
    required this.primaryHover,
    required this.background,
    required this.backgroundDark,
    required this.secondary,
    required this.secondaryHover,
    required this.success,
    required this.accent,
    required this.surface,
    required this.surfaceDark,
    required this.warning,
    required this.error,
    required this.onPrimary,
    required this.onBackground,
    required this.borderOpacity,
    required this.focusOpacity,
  });

  final Color primary;
  final Color primaryHover;
  final Color background;         // was: cream
  final Color backgroundDark;     // was: darkBurgundy
  final Color secondary;          // was: slateGrey
  final Color secondaryHover;     // was: slateGreyHover
  final Color success;            // was: hunterGreen
  final Color accent;             // was: powderBlush
  final Color surface;            // was: surfaceLight
  final Color surfaceDark;
  final Color warning;
  final Color error;
  final Color onPrimary;          // NEW
  final Color onBackground;      // NEW
  final double borderOpacity;     // NEW (was hardcoded 0.05)
  final double focusOpacity;      // NEW (was hardcoded 0.5)

  factory FiftyColorConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyColorConfig fallback,
  }) { ... }

  FiftyColorConfig copyWith({ ... });
}
```

### FiftyShadowsConfig (NEW)

```dart
class FiftyShadowsConfig {
  const FiftyShadowsConfig({
    required this.sm,
    required this.md,
    required this.lg,
    required this.primaryOpacity,
    required this.glowOpacity,
  });

  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final double primaryOpacity;
  final double glowOpacity;

  factory FiftyShadowsConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyShadowsConfig fallback,
  }) { ... }
}
```

### FiftyGradientsConfig (NEW)

```dart
class FiftyGradientsConfig {
  const FiftyGradientsConfig({
    required this.primaryEnd,
  });

  final Color primaryEnd;

  factory FiftyGradientsConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyGradientsConfig fallback,
  }) { ... }
}
```

### Existing Config Classes (Updated to Non-Nullable)

- `FiftySpacingConfig` — all `double?` become `double`
- `FiftyTypographyConfig` — all nullable become required
- `FiftyRadiiConfig` — all `double?` become `double`
- `FiftyMotionConfig` — all nullable become required
- `FiftyBreakpointsConfig` — all `double?` become `double`

Each gets `fromMap()` and `copyWith()`.

---

## Scope of Changes

### 1. Rename Color Fields to Semantic Names

| Current (Palette) | New (Semantic) | Purpose |
|-------------------|----------------|---------|
| `burgundy` | `primary` | Primary brand color |
| `burgundyHover` | `primaryHover` | Primary hover state |
| `cream` | `background` | Light background / dark text |
| `darkBurgundy` | `backgroundDark` | Dark mode background |
| `slateGrey` | `secondary` | Secondary actions |
| `slateGreyHover` | `secondaryHover` | Secondary hover state |
| `hunterGreen` | `success` | Success/positive |
| `powderBlush` | `accent` | Dark mode accent |
| `surfaceLight` | `surface` | Light mode card surface |
| `surfaceDark` | `surfaceDark` | (unchanged) |
| `warning` | `warning` | (unchanged) |
| `error` | `error` | (unchanged) |
| (new) | `onPrimary` | Text on primary |
| (new) | `onBackground` | Text on background |
| (new) | `borderOpacity` | Border alpha (was hardcoded 0.05) |
| (new) | `focusOpacity` | Focus alpha (was hardcoded 0.5) |

### 2. Create FiftyPreset

Single class containing:
- `FiftyPreset.fdlV2` static const — all default values in one place
- `FiftyPreset.fromMap()` factory — build from Map with fallback
- `copyWith()` — create variations

### 3. Restructure Token Classes as Agnostic Readers

Remove all `_defaultX` constants and `config?` nullable patterns from:
- FiftyColors, FiftySpacing, FiftyTypography, FiftyRadii, FiftyMotion, FiftyBreakpoints, FiftyShadows, FiftyGradients

Each becomes: `static X get y => FiftyTokens.active.category.y;`

### 4. Restructure FiftyTokens

- Single `_active` preset (default = `FiftyPreset.fdlV2`)
- `load(preset)` — apply a complete preset
- `configure(...)` — partial config with FDL v2 fallback
- `reset()` — back to FDL v2
- `active` getter — read-only access for token classes

### 5. Create New Config Classes

- `FiftyShadowsConfig` (NEW)
- `FiftyGradientsConfig` (NEW)

### 6. Make All Config Classes Non-Nullable + fromMap()

Convert all existing config classes from nullable to required fields. Add `fromMap()` and `copyWith()` to each.

### 7. Update FiftyColorScheme Mapping

```dart
// Before
surface: surface ?? FiftyColors.darkBurgundy,
onSurface: onSurface ?? FiftyColors.cream,

// After
surface: surface ?? FiftyColors.backgroundDark,
onSurface: onSurface ?? FiftyColors.background,
```

### 8. Update FiftyThemeExtension

Reference semantic names instead of palette names.

### 9. Deprecation Layer

Old palette-name getters kept as `@Deprecated` aliases for one version cycle.

---

## Files to Modify

### fifty_tokens (core)
- `lib/src/preset.dart` — NEW (FiftyPreset class with fdlV2 const)
- `lib/src/config/fifty_tokens_config.dart` — Becomes FiftyTokens manager only
- `lib/src/config/color_config.dart` — Semantic fields, non-nullable, fromMap()
- `lib/src/config/spacing_config.dart` — Non-nullable, fromMap()
- `lib/src/config/typography_config.dart` — Non-nullable, fromMap()
- `lib/src/config/radii_config.dart` — Non-nullable, fromMap()
- `lib/src/config/motion_config.dart` — Non-nullable, fromMap()
- `lib/src/config/breakpoints_config.dart` — Non-nullable, fromMap()
- `lib/src/config/shadows_config.dart` — NEW
- `lib/src/config/gradients_config.dart` — NEW
- `lib/src/colors.dart` — Agnostic reader + deprecation aliases
- `lib/src/spacing.dart` — Agnostic reader
- `lib/src/typography.dart` — Agnostic reader
- `lib/src/radii.dart` — Agnostic reader
- `lib/src/motion.dart` — Agnostic reader
- `lib/src/breakpoints.dart` — Agnostic reader
- `lib/src/shadows.dart` — Agnostic reader
- `lib/src/gradients.dart` — Agnostic reader
- `lib/fifty_tokens.dart` — Update barrel exports
- `test/` — Update all tests

### fifty_theme (mapping updates)
- `lib/src/color_scheme.dart` — Use semantic names
- `lib/src/theme_extensions.dart` — Use semantic names
- `lib/src/component_themes.dart` — Verify references
- `lib/src/text_theme.dart` — Verify references
- `test/` — Update affected tests

### fifty_ui (verify only)
- Verify no direct `FiftyColors.burgundy` etc. references remain

### Docs
- `packages/fifty_tokens/README.md`
- `packages/fifty_theme/README.md`
- `ai/context/coding_guidelines.md`
- `docs/MIGRATION_GUIDE.md` — Add v2 -> v3 section

---

## Consumer Examples (End State)

### Default (no configuration — FDL v2 automatically)

```dart
void main() {
  // Nothing needed — FDL v2 is active by default
  runApp(MyApp());
}
```

### Load a preset from JSON

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final json = await rootBundle.loadString('assets/brand_theme.json');
  FiftyTokens.load(FiftyPreset.fromMap(jsonDecode(json)));
  runApp(MyApp());
}
```

### Load a preset from a hardcoded Map

```dart
void main() {
  FiftyTokens.load(FiftyPreset.fromMap({
    'colors': {
      'primary': '#0066FF',
      'background': '#FFFFFF',
      'backgroundDark': '#111827',
    },
    'typography': {
      'fontFamily': 'Inter',
    },
  }));
  runApp(MyApp());
}
```

### Configure individual categories (rest = FDL v2)

```dart
void main() {
  FiftyTokens.configure(
    colors: FiftyColorConfig(
      primary: Color(0xFF0066FF),
      primaryHover: Color(0xFF0052CC),
      background: Color(0xFFFFFFFF),
      backgroundDark: Color(0xFF111827),
      secondary: Color(0xFF6B7280),
      secondaryHover: Color(0xFF4B5563),
      success: Color(0xFF22C55E),
      accent: Color(0xFFA78BFA),
      surface: Color(0xFFF3F4F6),
      surfaceDark: Color(0xFF1F2937),
      warning: Color(0xFFF59E0B),
      error: Color(0xFFEF4444),
      onPrimary: Color(0xFFFFFFFF),
      onBackground: Color(0xFF111827),
      borderOpacity: 0.08,
      focusOpacity: 0.4,
    ),
    // typography, spacing, radii, etc. → FDL v2 defaults
  );
  runApp(MyApp());
}
```

### Reset to default

```dart
FiftyTokens.reset(); // Back to FDL v2
```

---

## Acceptance Criteria

- [ ] `FiftyPreset` class exists with `fdlV2` static const containing ALL default values
- [ ] `FiftyPreset.fromMap()` builds a preset from Map with fallback for missing keys
- [ ] All token classes are agnostic readers (zero knowledge of FDL v2)
- [ ] `FiftyTokens.load()` applies a complete preset
- [ ] `FiftyTokens.configure()` accepts individual categories with FDL v2 fallback
- [ ] `FiftyTokens.reset()` restores FDL v2
- [ ] All category config classes have non-nullable required fields
- [ ] All color config fields use semantic names
- [ ] `FiftyShadowsConfig` exists and shadows are configurable
- [ ] `FiftyGradientsConfig` exists and gradients are configurable
- [ ] `borderLight`/`borderDark`/`focusDark` opacity is configurable
- [ ] Each category config class has `.fromMap()` and `.copyWith()`
- [ ] Old palette names deprecated with clear migration messages
- [ ] `FiftyColorScheme` uses semantic names
- [ ] `FiftyThemeExtension` uses semantic names
- [ ] All existing tests updated and passing
- [ ] New tests for `FiftyPreset.fromMap()` parsing
- [ ] flutter analyze passes (zero errors)
- [ ] README and coding_guidelines updated

---

## Test Plan

- All existing fifty_tokens tests pass with new architecture
- All existing fifty_theme tests pass with semantic references
- New tests: `FiftyPreset.fromMap()` end-to-end (partial Map + fallback)
- New tests: Each category config `fromMap()` with partial data + fallback
- New tests: `FiftyPreset.fdlV2` has all fields populated
- New tests: Token class getters read from active preset
- New tests: `FiftyTokens.load()` applies preset correctly
- New tests: `FiftyTokens.configure()` with partial categories
- New tests: `FiftyTokens.reset()` restores FDL v2
- New tests: `FiftyShadowsConfig` overrides
- New tests: `FiftyGradientsConfig` overrides
- New tests: Deprecated palette getters still resolve correctly
- flutter analyze: zero errors across fifty_tokens, fifty_theme, fifty_ui

---

## Version Impact

- **fifty_tokens:** 3.0.0 (breaking: preset architecture, semantic color names)
- **fifty_theme:** 3.0.0 (breaking: depends on fifty_tokens 3.0.0)
- **fifty_ui:** patch bump (no API changes, transitive dependency update)
- **Engine packages:** patch bumps (transitive dependency update)
