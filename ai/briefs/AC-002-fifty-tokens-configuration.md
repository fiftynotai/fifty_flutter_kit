# AC-002: fifty_tokens — Configuration System

**Type:** Architecture Cleanup
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-02-28
**Parent:** AC-001 (Theme Customization System)

---

## Architecture Issue

**What's the problem?**

- [x] Logical inconsistency (all token values are `static const` — zero configuration possible)

**Where is it?**

All 8 files in `packages/fifty_tokens/lib/src/`:
- `colors.dart` — 30+ `static const Color` with hardcoded hex
- `typography.dart` — 31 `static const` (font family, sizes, weights, spacing, line heights)
- `spacing.dart` — 15 `static const double` with hardcoded px values
- `radii.dart` — 8 `static const double` + 8 `static final BorderRadius`
- `motion.dart` — 4 `static const Duration` + 3 `static const Curve`
- `shadows.dart` — 4 `static const` + 2 `static final` shadow presets
- `gradients.dart` — 3 `static const LinearGradient` (duplicates hex instead of referencing FiftyColors)
- `breakpoints.dart` — 3 `static const double`

---

## Current State

```dart
// CURRENT: Locked, immutable, no override
class FiftyColors {
  FiftyColors._(); // Private constructor
  static const Color burgundy = Color(0xFF88292F);
  static const Color primary = burgundy; // Alias, still const
}

class FiftyTypography {
  FiftyTypography._();
  static const String fontFamily = "Manrope"; // Locked to Manrope
}
```

Consumer cannot change primary color from burgundy to blue. Consumer cannot change font from Manrope to Inter. Only option is forking the package.

---

## Goal

After this brief:

```dart
// AFTER: Configurable with FDL defaults
void main() {
  FiftyTokens.configure(
    colors: FiftyColorConfig(
      primary: Color(0xFF1E88E5),
      primaryHover: Color(0xFF1565C0),
      secondary: Color(0xFF43A047),
      // Everything else falls back to FDL defaults
    ),
    typography: FiftyTypographyConfig(
      fontFamily: 'Inter',
      source: FontSource.googleFonts, // Uses google_fonts package
    ),
    // Or local asset fonts:
    typography: FiftyTypographyConfig(
      fontFamily: 'CustomBrand',
      source: FontSource.asset, // Uses local font assets
    ),
    spacing: FiftySpacingConfig(
      base: 8, // 8px grid instead of 4px
    ),
  );
  runApp(MyApp());
}

// Access works identically:
FiftyColors.primary  // Returns configured blue (or FDL burgundy if unconfigured)
FiftyTypography.fontFamily // Returns 'Inter' (or 'Manrope' if unconfigured)
```

---

## Design Decisions

### 1. Configuration Pattern: Singleton with Getters

Replace `static const` with `static` getters backed by a private configuration singleton. Keep FDL defaults as const fallbacks.

```dart
class FiftyColors {
  FiftyColors._();

  // Private config singleton
  static FiftyColorConfig? _config;

  // FDL defaults (const, tree-shakeable)
  static const Color _defaultPrimary = Color(0xFF88292F);
  static const Color _defaultSecondary = Color(0xFF335C67);

  // Public getters — check config first, fallback to default
  static Color get primary => _config?.primary ?? _defaultPrimary;
  static Color get secondary => _config?.secondary ?? _defaultSecondary;

  // Semantic aliases resolve through getters
  static Color get error => _config?.error ?? primary;
  static Color get success => _config?.success ?? _defaultSuccess;
}
```

### 2. Font Source Abstraction

Support both Google Fonts and local asset fonts through a `FontSource` enum and `FiftyFontResolver`:

```dart
enum FontSource {
  googleFonts,  // Uses google_fonts package (current behavior)
  asset,        // Uses local font files from assets
}

class FiftyTypographyConfig {
  final String? fontFamily;
  final FontSource source;
  final String? fontFamilyFallback; // CSS/Flutter fallback

  const FiftyTypographyConfig({
    this.fontFamily,
    this.source = FontSource.googleFonts,
    this.fontFamilyFallback,
  });
}

/// Resolves font family based on source
class FiftyFontResolver {
  static TextStyle resolve({
    required String fontFamily,
    required FontSource source,
    required TextStyle baseStyle,
  }) {
    switch (source) {
      case FontSource.googleFonts:
        return GoogleFonts.getFont(fontFamily, textStyle: baseStyle);
      case FontSource.asset:
        return baseStyle.copyWith(fontFamily: fontFamily);
    }
  }
}
```

### 3. Configuration Classes (one per token category)

```dart
class FiftyColorConfig {
  final Color? primary;
  final Color? primaryHover;
  final Color? secondary;
  final Color? secondaryHover;
  final Color? success;
  final Color? error;
  final Color? warning;
  final Color? surface;
  final Color? surfaceDark;
  final Color? surfaceLight;
  // ... all overridable colors

  const FiftyColorConfig({ ... });
}

class FiftySpacingConfig {
  final double? base;    // If set, scales all spacing proportionally
  final double? xs;      // Or override individual values
  final double? sm;
  // ...

  const FiftySpacingConfig({ ... });
}

class FiftyRadiiConfig { ... }
class FiftyMotionConfig { ... }
```

### 4. Centralized Entry Point

```dart
class FiftyTokens {
  FiftyTokens._();

  /// Configure all token categories at once. Call before runApp().
  static void configure({
    FiftyColorConfig? colors,
    FiftyTypographyConfig? typography,
    FiftySpacingConfig? spacing,
    FiftyRadiiConfig? radii,
    FiftyMotionConfig? motion,
  }) {
    if (colors != null) FiftyColors._config = colors;
    if (typography != null) FiftyTypography._config = typography;
    if (spacing != null) FiftySpacing._config = spacing;
    if (radii != null) FiftyRadii._config = radii;
    if (motion != null) FiftyMotion._config = motion;
  }

  /// Reset all tokens to FDL defaults.
  static void reset() {
    FiftyColors._config = null;
    FiftyTypography._config = null;
    FiftySpacing._config = null;
    FiftyRadii._config = null;
    FiftyMotion._config = null;
  }
}
```

### 5. Gradients Must Reference FiftyColors

Current gradients duplicate hex values. Fix to reference getters:

```dart
// BEFORE (broken):
static const LinearGradient primary = LinearGradient(
  colors: [Color(0xFF88292F), Color(0xFF5A1B1F)], // Hardcoded!
);

// AFTER (dynamic):
static LinearGradient get primary => LinearGradient(
  colors: [FiftyColors.primary, FiftyColors.primaryHover],
);
```

---

## Constraints

### Architecture Rules
- Public API surface must be backward compatible where possible
- `FiftyColors.primary` syntax stays the same (getter, not method call)
- Zero-config still works (FDL defaults apply when configure() not called)
- No Flutter dependency in core tokens (keep pure Dart for font config model, resolver can depend on Flutter)

### Breaking Changes (Intentional)
- `static const` → `static get` means tokens can no longer be used in `const` widget constructors
- This is acceptable — most real usage is in `build()` methods, not const contexts
- Document this in migration guide (AC-006)

### Out of Scope
- Runtime theme switching (consumer responsibility)
- Token validation (no range checks on spacing values)
- Preset themes beyond FDL (e.g., "Material Blue" preset)

---

## Tasks

### Pending

### In Progress

### Completed
- [x] Task 1: Create `FiftyTokens` centralized configuration class with `configure()` and `reset()`
- [x] Task 2: Create `FiftyColorConfig` class with all overridable color properties
- [x] Task 3: Refactor `colors.dart` — `static const` → `static` getters with config fallback
- [x] Task 4: Create `FiftyTypographyConfig` with `FontSource` enum and font family config
- [x] Task 5: Create `FiftyFontResolver` for Google Fonts vs asset font resolution
- [x] Task 6: Refactor `typography.dart` — configurable font family, sizes, weights, letter spacing, line heights
- [x] Task 7: Create `FiftySpacingConfig` — base grid + individual overrides
- [x] Task 8: Refactor `spacing.dart` — `static const` → `static` getters
- [x] Task 9: Create `FiftyRadiiConfig` and refactor `radii.dart`
- [x] Task 10: Create `FiftyMotionConfig` and refactor `motion.dart`
- [x] Task 11: Refactor `shadows.dart` — ensure references use getters, not hardcoded hex
- [x] Task 12: Refactor `gradients.dart` — reference FiftyColors getters instead of duplicate hex
- [x] Task 13: Refactor `breakpoints.dart` — configurable breakpoint values
- [x] Task 14: Update barrel export (`fifty_tokens.dart`) to export new config classes
- [x] Task 15: Write unit tests for configuration system (configure, reset, defaults, partial override)
- [x] Task 16: Write unit tests for font resolver (Google Fonts + asset paths)
- [x] Task 17: Run `flutter analyze` — zero issues across entire mono-repo

---

## Session State (Tactical - This Brief)

**Current State:** Done — All 17 tasks completed
**Next Steps When Resuming:** N/A — Brief complete
**Last Updated:** 2026-02-28
**Blockers:** None
**Completed:** 2026-02-28

---

## Acceptance Criteria

**The cleanup is complete when:**

1. [ ] `FiftyTokens.configure()` sets custom values for all token categories
2. [ ] `FiftyTokens.reset()` restores FDL defaults
3. [ ] `FiftyColors.primary` returns configured color (or FDL default)
4. [ ] `FiftyTypography.fontFamily` returns configured font (or Manrope)
5. [ ] `FontSource.googleFonts` resolves via `google_fonts` package
6. [ ] `FontSource.asset` resolves via local font family name
7. [ ] `FiftySpacing.md` returns configured spacing (or FDL 12px)
8. [ ] Gradients reference FiftyColors getters (no duplicate hex)
9. [ ] Shadows reference FiftyColors getters (no duplicate hex)
10. [ ] Zero-config still works (unconfigured = FDL defaults)
11. [ ] All existing tests pass
12. [ ] New unit tests for config system pass
13. [ ] `flutter analyze` passes (zero issues)

---

## Affected Areas

### Files to Modify
- `packages/fifty_tokens/lib/src/colors.dart` — const → getters
- `packages/fifty_tokens/lib/src/typography.dart` — const → getters + font resolver
- `packages/fifty_tokens/lib/src/spacing.dart` — const → getters
- `packages/fifty_tokens/lib/src/radii.dart` — const → getters
- `packages/fifty_tokens/lib/src/motion.dart` — const → getters
- `packages/fifty_tokens/lib/src/shadows.dart` — fix hex refs
- `packages/fifty_tokens/lib/src/gradients.dart` — fix hex refs
- `packages/fifty_tokens/lib/src/breakpoints.dart` — const → getters
- `packages/fifty_tokens/lib/fifty_tokens.dart` — export new classes

### Files to Create
- `packages/fifty_tokens/lib/src/config/fifty_tokens_config.dart` — centralized configure()
- `packages/fifty_tokens/lib/src/config/color_config.dart`
- `packages/fifty_tokens/lib/src/config/typography_config.dart`
- `packages/fifty_tokens/lib/src/config/spacing_config.dart`
- `packages/fifty_tokens/lib/src/config/radii_config.dart`
- `packages/fifty_tokens/lib/src/config/motion_config.dart`
- `packages/fifty_tokens/lib/src/config/font_resolver.dart`
- `packages/fifty_tokens/test/config_test.dart`
- `packages/fifty_tokens/test/font_resolver_test.dart`

### Count
**Total files to modify:** 9
**Total files to create:** 9
**Total estimated lines:** ~800 new, ~200 refactored

---

## References

**Parent Brief:** AC-001
**Blocks:** AC-003 (fifty_theme), AC-004 (fifty_ui), AC-005 (engine packages)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
