# Implementation Plan: AC-002 (fifty_tokens Configuration System)

**Complexity:** L (Large)
**Estimated Duration:** 3-5 days
**Risk Level:** Medium

## Summary

Refactor all 8 token files in `fifty_tokens` from hardcoded `static const` values to a configurable system backed by per-category config singletons and `static get` accessors. Add `FiftyTokens.configure()` as the single entry point, a `FontSource` enum + `FiftyFontResolver` for font flexibility, and fix gradients/shadows to reference color getters instead of duplicated hex literals. All deprecated members remain `static const` unchanged.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `lib/src/config/fifty_tokens_config.dart` | CREATE | Centralized `FiftyTokens` class with `configure()` and `reset()` |
| `lib/src/config/color_config.dart` | CREATE | `FiftyColorConfig` immutable data class |
| `lib/src/config/typography_config.dart` | CREATE | `FiftyTypographyConfig` + `FontSource` enum |
| `lib/src/config/spacing_config.dart` | CREATE | `FiftySpacingConfig` immutable data class |
| `lib/src/config/radii_config.dart` | CREATE | `FiftyRadiiConfig` immutable data class |
| `lib/src/config/motion_config.dart` | CREATE | `FiftyMotionConfig` immutable data class |
| `lib/src/config/breakpoints_config.dart` | CREATE | `FiftyBreakpointsConfig` immutable data class |
| `lib/src/config/font_resolver.dart` | CREATE | `FiftyFontResolver` resolves font by source |
| `lib/src/colors.dart` | MODIFY | `static const` -> `static get` backed by `_config`, keep deprecated as `static const` |
| `lib/src/typography.dart` | MODIFY | `static const` -> `static get` for fontFamily, sizes, weights, spacings, line heights; deprecated stay const |
| `lib/src/spacing.dart` | MODIFY | `static const` -> `static get` backed by `_config` |
| `lib/src/radii.dart` | MODIFY | `static const` -> `static get`, `static final BorderRadius` -> `static get`; deprecated stay const/final |
| `lib/src/motion.dart` | MODIFY | `static const` -> `static get` for durations and curves |
| `lib/src/shadows.dart` | MODIFY | `primary` and `glow` already dynamic; `sm/md/lg/none` become getters for consistency if shadows config added -- BUT keep as const since shadow geometry rarely overridden. Only ensure color refs go through FiftyColors getters. |
| `lib/src/gradients.dart` | MODIFY | `static const` -> `static get`, reference `FiftyColors` getters instead of duplicate hex |
| `lib/src/breakpoints.dart` | MODIFY | `static const` -> `static get` backed by `_config` |
| `lib/fifty_tokens.dart` | MODIFY | Add exports for config classes, font resolver, font source |
| `test/config/fifty_tokens_config_test.dart` | CREATE | Tests for configure/reset/defaults |
| `test/config/color_config_test.dart` | CREATE | Tests for color overrides + fallbacks |
| `test/config/typography_config_test.dart` | CREATE | Tests for typography overrides + font source |
| `test/config/spacing_config_test.dart` | CREATE | Tests for spacing overrides |
| `test/config/radii_config_test.dart` | CREATE | Tests for radii overrides |
| `test/config/motion_config_test.dart` | CREATE | Tests for motion overrides |
| `test/config/breakpoints_config_test.dart` | CREATE | Tests for breakpoints overrides |
| `test/config/font_resolver_test.dart` | CREATE | Tests for GoogleFonts vs asset resolution |
| `test/colors_test.dart` | MODIFY | Remove `const` from expectations (values are now getters), add `addTearDown(FiftyTokens.reset)` |
| `test/typography_test.dart` | MODIFY | Same pattern as colors_test |
| `test/spacing_test.dart` | MODIFY | Same pattern |
| `test/radii_test.dart` | MODIFY | Same pattern for non-deprecated members |
| `test/motion_test.dart` | MODIFY | Same pattern |
| `test/gradients_test.dart` | MODIFY | Remove `const` expectations, verify colors come from FiftyColors |
| `test/breakpoints_test.dart` | MODIFY | Remove `const` expectations |
| `test/fifty_tokens_test.dart` | MODIFY | Add export assertions for new classes |

**Total files to create:** 15 (7 config + 8 test)
**Total files to modify:** 17 (8 source + 1 barrel + 8 existing tests)

---

## Implementation Steps

### Phase 1: Config Data Classes (Pure Dart, No Dependencies)

Create `lib/src/config/` directory with immutable config classes. These are pure Dart -- no Flutter imports, no `package:google_fonts`. All fields are nullable (null = use FDL default).

#### 1a. Create `lib/src/config/color_config.dart`

```dart
class FiftyColorConfig {
  const FiftyColorConfig({ ... });
}
```

**Properties (all `Color?`, all optional):**

| Property | FDL Default | Notes |
|----------|-------------|-------|
| `burgundy` | `Color(0xFF88292F)` | Core palette |
| `burgundyHover` | `Color(0xFF6E2126)` | |
| `cream` | `Color(0xFFFEFEE3)` | |
| `darkBurgundy` | `Color(0xFF1A0D0E)` | |
| `slateGrey` | `Color(0xFF335C67)` | |
| `slateGreyHover` | `Color(0xFF274750)` | |
| `hunterGreen` | `Color(0xFF4B644A)` | |
| `powderBlush` | `Color(0xFFFFC9B9)` | |
| `surfaceLight` | `Color(0xFFFAF9DE)` | |
| `surfaceDark` | `Color(0xFF2A1517)` | |
| `primary` | null (falls back to `burgundy`) | Semantic alias |
| `primaryHover` | null (falls back to `burgundyHover`) | Semantic alias |
| `secondary` | null (falls back to `slateGrey`) | Semantic alias |
| `secondaryHover` | null (falls back to `slateGreyHover`) | Semantic alias |
| `success` | null (falls back to `hunterGreen`) | Semantic |
| `warning` | `Color(0xFFF7A100)` | |
| `error` | null (falls back to `burgundy`) | Semantic |
| `focusLight` | null (falls back to `burgundy`) | Mode helper |

**Note on `import`:** This file needs `import 'package:flutter/material.dart'` for the `Color` type. This is acceptable -- Color is in `dart:ui` which Flutter re-exports. Config classes will require Flutter SDK (already a dependency).

**Design decision: core vs semantic separation.** Semantic aliases (primary, secondary, success, error, warning) resolve through the getter chain in `FiftyColors`, not in the config class itself. If a consumer sets `config.primary` it overrides the getter directly. If they set `config.burgundy` but not `config.primary`, then `FiftyColors.primary` getter falls back to `config.burgundy` (because `primary` defaults to `burgundy`). The getter resolution chain handles this.

#### 1b. Create `lib/src/config/typography_config.dart`

```dart
enum FontSource {
  /// Use google_fonts package to fetch/cache fonts at runtime.
  googleFonts,

  /// Use local font assets bundled with the app.
  asset,
}

class FiftyTypographyConfig {
  const FiftyTypographyConfig({ ... });
}
```

**Properties:**

| Property | Type | FDL Default | Notes |
|----------|------|-------------|-------|
| `fontFamily` | `String?` | `'Manrope'` | Main font |
| `fontSource` | `FontSource` | `FontSource.googleFonts` | How to load |
| `regular` | `FontWeight?` | `FontWeight.w400` | |
| `medium` | `FontWeight?` | `FontWeight.w500` | |
| `semiBold` | `FontWeight?` | `FontWeight.w600` | |
| `bold` | `FontWeight?` | `FontWeight.w700` | |
| `extraBold` | `FontWeight?` | `FontWeight.w800` | |
| `displayLarge` | `double?` | `32` | |
| `displayMedium` | `double?` | `24` | |
| `titleLarge` | `double?` | `20` | |
| `titleMedium` | `double?` | `18` | |
| `titleSmall` | `double?` | `16` | |
| `bodyLarge` | `double?` | `16` | |
| `bodyMedium` | `double?` | `14` | |
| `bodySmall` | `double?` | `12` | |
| `labelLarge` | `double?` | `14` | |
| `labelMedium` | `double?` | `12` | |
| `labelSmall` | `double?` | `10` | |
| `letterSpacingDisplay` | `double?` | `-0.5` | |
| `letterSpacingDisplayMedium` | `double?` | `-0.25` | |
| `letterSpacingBody` | `double?` | `0.5` | |
| `letterSpacingBodyMedium` | `double?` | `0.25` | |
| `letterSpacingBodySmall` | `double?` | `0.4` | |
| `letterSpacingLabel` | `double?` | `0.5` | |
| `letterSpacingLabelMedium` | `double?` | `1.5` | |
| `lineHeightDisplay` | `double?` | `1.2` | |
| `lineHeightTitle` | `double?` | `1.3` | |
| `lineHeightBody` | `double?` | `1.5` | |
| `lineHeightLabel` | `double?` | `1.2` | |

#### 1c. Create `lib/src/config/spacing_config.dart`

**Properties (all `double?`):**

| Property | FDL Default | Notes |
|----------|-------------|-------|
| `base` | `4` | Fundamental unit |
| `tight` | `8` | Primary gap |
| `standard` | `12` | Comfortable gap |
| `xs` | `4` | |
| `sm` | `8` | |
| `md` | `12` | |
| `lg` | `16` | |
| `xl` | `20` | |
| `xxl` | `24` | |
| `xxxl` | `32` | |
| `huge` | `40` | |
| `massive` | `48` | |
| `gutterDesktop` | `24` | |
| `gutterTablet` | `16` | |
| `gutterMobile` | `12` | |

#### 1d. Create `lib/src/config/radii_config.dart`

**Properties (all `double?`):**

| Property | FDL Default |
|----------|-------------|
| `none` | `0` |
| `sm` | `4` |
| `md` | `8` |
| `lg` | `12` |
| `xl` | `16` |
| `xxl` | `24` |
| `xxxl` | `32` |
| `full` | `9999` |

**Note:** The `BorderRadius` convenience getters (`smRadius`, `mdRadius`, etc.) are derived from the `double` values. They do NOT have separate config entries. They are computed in the getter: `static BorderRadius get smRadius => BorderRadius.circular(sm);`

#### 1e. Create `lib/src/config/motion_config.dart`

**Properties:**

| Property | Type | FDL Default |
|----------|------|-------------|
| `instant` | `Duration?` | `Duration.zero` |
| `fast` | `Duration?` | `Duration(milliseconds: 150)` |
| `compiling` | `Duration?` | `Duration(milliseconds: 300)` |
| `systemLoad` | `Duration?` | `Duration(milliseconds: 800)` |
| `standard` | `Curve?` | `Cubic(0.2, 0, 0, 1)` |
| `enter` | `Curve?` | `Cubic(0.2, 0.8, 0.2, 1)` |
| `exit` | `Curve?` | `Cubic(0.4, 0, 1, 1)` |

**Note:** `Curve` type requires `import 'package:flutter/animation.dart'`. This is acceptable.

#### 1f. Create `lib/src/config/breakpoints_config.dart`

**Properties (all `double?`):**

| Property | FDL Default |
|----------|-------------|
| `mobile` | `768` |
| `tablet` | `768` |
| `desktop` | `1024` |

#### 1g. Create `lib/src/config/fifty_tokens_config.dart`

The centralized entry point. This file imports all config classes and provides `configure()` and `reset()`.

```dart
class FiftyTokens {
  FiftyTokens._();

  static void configure({
    FiftyColorConfig? colors,
    FiftyTypographyConfig? typography,
    FiftySpacingConfig? spacing,
    FiftyRadiiConfig? radii,
    FiftyMotionConfig? motion,
    FiftyBreakpointsConfig? breakpoints,
  }) { ... }

  static void reset() { ... }

  /// Whether any configuration has been applied.
  static bool get isConfigured => ...;
}
```

**Implementation detail:** `configure()` sets static `_config` fields on each token class. This requires the token classes to expose internal setters. Two approaches:

**Approach A -- Friend access via `part`/`part of`:** Not idiomatic Dart.

**Approach B -- Package-private setter convention (chosen):** Each token class has a `static set config(X? value)` that is annotated with `@internal` (from `package:meta`). The `FiftyTokens.configure()` calls these setters. Since all files are in the same package, this works. Consumers cannot set `_config` directly because they import via barrel.

Actually, the simpler pattern: `FiftyTokens.configure()` lives in the same package so it has direct access to the static field if we use the `@internal` annotation or simply a `static` setter with a leading underscore convention. But `_config` is truly private to the file in Dart.

**Resolution: Use a package-internal static setter.**

Each token class exposes:
```dart
// In colors.dart
class FiftyColors {
  static FiftyColorConfig? _config;

  /// @internal -- do not use outside fifty_tokens package.
  @internal
  static void setConfig(FiftyColorConfig? config) => _config = config;
}
```

`FiftyTokens.configure()` calls `FiftyColors.setConfig(colors)`.

This is visible to consumers but annotated `@internal` which generates a lint warning if used externally. This is the standard Dart pattern for package-internal APIs.

**Alternative simpler approach (chosen):** Put `_config` as a top-level private variable in each token file. The class getter reads from it. The config setter is a top-level function or the `FiftyTokens` class directly sets a top-level variable. But top-level privates are file-scoped in Dart.

**Final resolution: Use a shared internal file.**

Create `lib/src/config/_internal.dart` (not exported in barrel) that holds mutable state:

NO -- this gets complicated. The cleanest pattern is:

**Each token class has a public static `_config` exposed via a conventionally-named method:**

```dart
// colors.dart
class FiftyColors {
  FiftyColors._();

  static FiftyColorConfig? _config;

  // ... getters ...
}
```

And `FiftyTokens` in `fifty_tokens_config.dart` cannot access `FiftyColors._config` because it's library-private.

**ACTUAL SOLUTION (simplest, idiomatic Dart):**

Make the config variable a non-underscore-prefixed `static` field on each class, but annotated `@visibleForTesting` or `@internal`:

```dart
class FiftyColors {
  FiftyColors._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyColorConfig? config;

  static Color get primary => config?.primary ?? config?.burgundy ?? _defaultBurgundy;
}
```

Then `FiftyTokens.configure()`:
```dart
static void configure({FiftyColorConfig? colors, ...}) {
  if (colors != null) FiftyColors.config = colors;
  if (typography != null) FiftyTypography.config = typography;
  // ...
}
```

This is clean, testable, and the `@internal` annotation warns consumers not to use it directly.

---

### Phase 2: Font Resolver (Flutter Dependency)

#### 2a. Create `lib/src/config/font_resolver.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'typography_config.dart';

/// Resolves font family based on [FontSource].
///
/// For [FontSource.googleFonts], uses the google_fonts package to
/// fetch and cache the font. For [FontSource.asset], uses the
/// local font family name directly.
class FiftyFontResolver {
  FiftyFontResolver._();

  /// Resolves a [TextStyle] with the correct font family applied.
  ///
  /// Pass [fontFamily] and [source] from [FiftyTypographyConfig].
  /// The [baseStyle] is the TextStyle to apply the font to.
  static TextStyle resolve({
    required String fontFamily,
    required FontSource source,
    TextStyle? baseStyle,
  }) {
    switch (source) {
      case FontSource.googleFonts:
        return GoogleFonts.getFont(
          fontFamily,
          textStyle: baseStyle,
        );
      case FontSource.asset:
        return (baseStyle ?? const TextStyle()).copyWith(
          fontFamily: fontFamily,
        );
    }
  }

  /// Returns the resolved font family name as a [String].
  ///
  /// For Google Fonts, this triggers font registration and returns
  /// the registered family name. For asset fonts, returns the name as-is.
  static String resolveFamilyName({
    required String fontFamily,
    required FontSource source,
  }) {
    switch (source) {
      case FontSource.googleFonts:
        return GoogleFonts.getFont(fontFamily).fontFamily ?? fontFamily;
      case FontSource.asset:
        return fontFamily;
    }
  }
}
```

**Consumer usage in fifty_theme (future AC-003):**
```dart
// Instead of: GoogleFonts.manrope(fontSize: 14)
// Use: FiftyFontResolver.resolve(
//   fontFamily: FiftyTypography.fontFamily,
//   source: FiftyTypography.fontSource,
//   baseStyle: TextStyle(fontSize: 14),
// )
```

---

### Phase 3: Refactor Token Files

Process each file following the same pattern:
1. Add `import` for the config class
2. Add `@internal static config` field
3. Rename current `static const` values to `_defaultXxx` (private)
4. Add `static get` that reads from `config?.xxx ?? _defaultXxx`
5. Leave deprecated members as `static const` (no config backing)

#### 3a. Refactor `colors.dart`

**Members becoming getters (20 members):**

| Current | Becomes | Getter Logic |
|---------|---------|-------------|
| `static const Color burgundy = Color(0xFF88292F)` | `static Color get burgundy => config?.burgundy ?? _defaultBurgundy` | Direct override |
| `static const Color burgundyHover = Color(0xFF6E2126)` | `static Color get burgundyHover => config?.burgundyHover ?? _defaultBurgundyHover` | Direct override |
| `static const Color cream = Color(0xFFFEFEE3)` | `static Color get cream => config?.cream ?? _defaultCream` | Direct override |
| `static const Color darkBurgundy = Color(0xFF1A0D0E)` | `static Color get darkBurgundy => config?.darkBurgundy ?? _defaultDarkBurgundy` | Direct override |
| `static const Color slateGrey = Color(0xFF335C67)` | `static Color get slateGrey => config?.slateGrey ?? _defaultSlateGrey` | Direct override |
| `static const Color slateGreyHover = Color(0xFF274750)` | `static Color get slateGreyHover => config?.slateGreyHover ?? _defaultSlateGreyHover` | Direct override |
| `static const Color hunterGreen = Color(0xFF4B644A)` | `static Color get hunterGreen => config?.hunterGreen ?? _defaultHunterGreen` | Direct override |
| `static const Color powderBlush = Color(0xFFFFC9B9)` | `static Color get powderBlush => config?.powderBlush ?? _defaultPowderBlush` | Direct override |
| `static const Color surfaceLight = Color(0xFFFAF9DE)` | `static Color get surfaceLight => config?.surfaceLight ?? _defaultSurfaceLight` | Direct override |
| `static const Color surfaceDark = Color(0xFF2A1517)` | `static Color get surfaceDark => config?.surfaceDark ?? _defaultSurfaceDark` | Direct override |
| `static const Color primary = burgundy` | `static Color get primary => config?.primary ?? burgundy` | Semantic: falls through to `burgundy` getter |
| `static const Color primaryHover = burgundyHover` | `static Color get primaryHover => config?.primaryHover ?? burgundyHover` | Semantic |
| `static const Color secondary = slateGrey` | `static Color get secondary => config?.secondary ?? slateGrey` | Semantic |
| `static const Color secondaryHover = slateGreyHover` | `static Color get secondaryHover => config?.secondaryHover ?? slateGreyHover` | Semantic |
| `static const Color success = hunterGreen` | `static Color get success => config?.success ?? hunterGreen` | Semantic |
| `static const Color warning = Color(0xFFF7A100)` | `static Color get warning => config?.warning ?? _defaultWarning` | Direct override |
| `static const Color error = burgundy` | `static Color get error => config?.error ?? primary` | Semantic: falls through to `primary` getter (not burgundy directly) |
| `static const Color focusLight = burgundy` | `static Color get focusLight => config?.focusLight ?? primary` | Mode helper: follows primary |

**Members staying as-is (already getters or deprecated):**

| Member | Stays | Reason |
|--------|-------|--------|
| `static Color get borderLight` | KEEP as getter | Already a getter. References `Colors.black` (framework color, not configurable) |
| `static Color get borderDark` | KEEP as getter | Already a getter. References `Colors.white` |
| `static Color get focusDark` | KEEP as getter | Already a getter. Now references `powderBlush` getter (automatically dynamic) |
| 7 deprecated `static const Color` | KEEP as `static const` | Deprecated, going away in v2.0.0 |

**Key semantics chain:**
- `primary` -> falls back to `burgundy` getter (so if consumer overrides burgundy but not primary, primary changes too)
- `error` -> falls back to `primary` getter (follows primary color)
- `focusLight` -> falls back to `primary` getter
- `focusDark` -> references `powderBlush` getter (already dynamic, no change needed)

#### 3b. Refactor `typography.dart`

**Members becoming getters (31 non-deprecated members):**

All current `static const` members become `static get` backed by `config?.xxx ?? _defaultXxx`.

| Category | Members | Count |
|----------|---------|-------|
| Font family | `fontFamily` | 1 |
| Weights | `regular`, `medium`, `semiBold`, `bold`, `extraBold` | 5 |
| Type scale | `displayLarge`, `displayMedium`, `titleLarge`, `titleMedium`, `titleSmall`, `bodyLarge`, `bodyMedium`, `bodySmall`, `labelLarge`, `labelMedium`, `labelSmall` | 11 |
| Letter spacing | `letterSpacingDisplay`, `letterSpacingDisplayMedium`, `letterSpacingBody`, `letterSpacingBodyMedium`, `letterSpacingBodySmall`, `letterSpacingLabel`, `letterSpacingLabelMedium` | 7 |
| Line heights | `lineHeightDisplay`, `lineHeightTitle`, `lineHeightBody`, `lineHeightLabel` | 4 |

Total: 28 getters.

**Additional getter:** `fontSource` -- exposes the configured `FontSource` (default: `FontSource.googleFonts`).

```dart
static FontSource get fontSource => config?.fontSource ?? FontSource.googleFonts;
```

This allows downstream packages (fifty_theme) to query the font source.

**Deprecated members (13):** All stay `static const`.

#### 3c. Refactor `spacing.dart`

All 15 `static const double` members become `static get` backed by config.

No deprecated members in this file.

#### 3d. Refactor `radii.dart`

**double values (8):** Become `static double get xxx => config?.xxx ?? _defaultXxx`.

**BorderRadius values (8):** Become computed getters:
```dart
// noneRadius stays const (always zero)
static const BorderRadius noneRadius = BorderRadius.zero;

// Others become getters derived from the double getter:
static BorderRadius get smRadius => BorderRadius.circular(sm);
static BorderRadius get mdRadius => BorderRadius.circular(md);
// etc.
```

**Note:** `noneRadius` can stay `const` since `none` is always 0 and `BorderRadius.zero` is a framework const. But for consistency and to support the (admittedly unlikely) case where someone configures `none` to non-zero, make it a getter too:
```dart
static BorderRadius get noneRadius => none == 0 ? BorderRadius.zero : BorderRadius.circular(none);
```

Actually, keep it simple: `static BorderRadius get noneRadius => BorderRadius.circular(none);` -- `BorderRadius.circular(0)` works fine.

**Deprecated members (4):** Stay `static const` / `static final`.

#### 3e. Refactor `motion.dart`

All 7 members (4 Duration + 3 Curve) become `static get`.

No deprecated members in this file.

#### 3f. Refactor `shadows.dart`

**Current state analysis:**
- `sm`, `md`, `lg`, `none` -- `static const List<BoxShadow>` with hardcoded ARGB colors (black at various opacities). These do NOT reference FiftyColors and arguably should not (shadow opacity on black is universal, not brand-specific). Leave as `static const`.
- `primary` -- already `static get`, references `FiftyColors.burgundy` (will automatically follow config).
- `glow` -- already `static get`, references `FiftyColors.cream` (will automatically follow config).

**Decision:** No config class for shadows. The `primary` and `glow` getters already dynamically reference FiftyColors. The base shadows (`sm`, `md`, `lg`) are universal shadow geometry and don't need brand configuration. No changes needed in this file beyond ensuring the FiftyColors imports resolve to getters (which they will after Phase 3a).

**Deprecated class `FiftyElevation`:** No changes.

#### 3g. Refactor `gradients.dart`

**Current problem:** All 3 gradients duplicate hex values instead of referencing FiftyColors.

**Fix:** Convert from `static const LinearGradient` to `static LinearGradient get`:

```dart
// primary: burgundy -> darker burgundy
// PROBLEM: "darker burgundy" (#5A1B1F) is not in FiftyColors. Need to decide:
// Option A: Add it to FiftyColors as a palette color
// Option B: Reference FiftyColors.primary and FiftyColors.primaryHover (these are close but not exact)
//   - primary = burgundy = #88292F, primaryHover = burgundyHover = #6E2126
//   - But gradient currently uses #88292F -> #5A1B1F (which is NOT burgundyHover)
// Option C: Keep gradient endpoint colors as private defaults within gradients.dart

// Let's check the mapping:
// primary gradient: #88292F (burgundy) -> #5A1B1F (not a named color)
// progress gradient: #FFC9B9 (powderBlush) -> #88292F (burgundy)
// surface gradient: #1A0D0E (darkBurgundy) -> #2A1517 (surfaceDark)
```

**Resolution:**
- `primary` gradient: Use `FiftyColors.burgundy` for start, keep `_defaultPrimaryEnd = Color(0xFF5A1B1F)` as a private fallback. Do NOT add a new named color just for gradient endpoints.
- `progress` gradient: Use `FiftyColors.powderBlush` -> `FiftyColors.burgundy`.
- `surface` gradient: Use `FiftyColors.darkBurgundy` -> `FiftyColors.surfaceDark`.

This fixes the hex duplication for known colors. The `#5A1B1F` value remains as a private default because it's a gradient endpoint, not a brand color.

**No separate config class for gradients.** Gradients dynamically reference FiftyColors getters, so they respond to color configuration automatically.

#### 3h. Refactor `breakpoints.dart`

All 3 `static const double` members become `static get` backed by config.

No deprecated members.

---

### Phase 4: Update Barrel Export

Modify `lib/fifty_tokens.dart`:

```dart
library fifty_tokens;

// Existing exports
export 'src/breakpoints.dart';
export 'src/colors.dart';
export 'src/gradients.dart';
export 'src/motion.dart';
export 'src/radii.dart';
export 'src/shadows.dart';
export 'src/spacing.dart';
export 'src/typography.dart';

// New config exports
export 'src/config/fifty_tokens_config.dart';
export 'src/config/color_config.dart';
export 'src/config/typography_config.dart' show FiftyTypographyConfig, FontSource;
export 'src/config/spacing_config.dart';
export 'src/config/radii_config.dart';
export 'src/config/motion_config.dart';
export 'src/config/breakpoints_config.dart';
export 'src/config/font_resolver.dart';
```

**Note on `@internal` visibility:** The `config` static fields on token classes are exposed in the barrel but annotated `@internal`. Consumers get a lint warning if they access them. The canonical API is `FiftyTokens.configure()`.

---

### Phase 5: Update Existing Tests

Each existing test file needs adjustments:

1. **Remove `const` from expectations** where token values were previously const:
   ```dart
   // BEFORE:
   expect(FiftyColors.burgundy, const Color(0xFF88292F));

   // AFTER:
   expect(FiftyColors.burgundy, Color(0xFF88292F));
   ```

2. **Add tearDown** to reset config between test groups:
   ```dart
   setUp(() => FiftyTokens.reset());
   // or
   addTearDown(FiftyTokens.reset);
   ```

3. **Deprecated member tests stay unchanged** (they're still `static const`).

4. **`gradients_test.dart`** -- update color expectations to verify they match FiftyColors getters, not hardcoded hex.

5. **`fifty_tokens_test.dart`** -- add assertions for new exported classes:
   ```dart
   test('exports FiftyTokens config', () {
     expect(FiftyTokens.isConfigured, isFalse);
   });
   test('exports FontSource enum', () {
     expect(FontSource.googleFonts, isNotNull);
     expect(FontSource.asset, isNotNull);
   });
   ```

---

### Phase 6: New Config Tests

#### 6a. `test/config/fifty_tokens_config_test.dart`

Test groups:
- `configure()` with all categories
- `configure()` with partial categories
- `reset()` clears all config
- `isConfigured` state tracking
- Multiple `configure()` calls (last wins)
- `configure()` then `reset()` then `configure()` again

#### 6b. `test/config/color_config_test.dart`

Test groups:
- **Default values:** All getters return FDL defaults when unconfigured
- **Full override:** All colors overridden, getters return custom values
- **Partial override:** Only `primary` overridden, others stay default
- **Semantic fallback chain:** Override `burgundy` but not `primary` -- `primary` should return overridden burgundy
- **Reset:** After reset, all return FDL defaults
- **Mode helpers:** `borderLight`, `borderDark`, `focusDark` still work

#### 6c. `test/config/typography_config_test.dart`

Test groups:
- Default font family is 'Manrope'
- Override font family
- Default font source is `FontSource.googleFonts`
- Override font source to `FontSource.asset`
- Override individual sizes
- Partial override (only displayLarge)
- Reset restores defaults

#### 6d. `test/config/spacing_config_test.dart`

- Default values match FDL
- Override base unit
- Override individual values
- Partial override
- Reset

#### 6e. `test/config/radii_config_test.dart`

- Default values match FDL
- Override radius values
- BorderRadius getters recompute from overridden doubles
- Reset

#### 6f. `test/config/motion_config_test.dart`

- Default durations and curves
- Override durations
- Override curves
- Reset

#### 6g. `test/config/breakpoints_config_test.dart`

- Default values match FDL
- Override breakpoints
- Reset

#### 6h. `test/config/font_resolver_test.dart`

Test groups:
- **GoogleFonts source:** `resolve()` returns a TextStyle (verify fontFamily contains expected name)
- **Asset source:** `resolve()` returns TextStyle with fontFamily set to input string
- **resolveFamilyName()** with both sources
- **Null baseStyle:** Works with null (uses empty TextStyle)

**Note:** Google Fonts tests may need `TestWidgetsFlutterBinding.ensureInitialized()` and potentially mock HTTP. Consider marking Google Fonts integration tests as integration tests or using `GoogleFonts.config.allowRuntimeFetching = false` in tests.

---

### Phase 7: Analyze and Verify

1. Run `flutter analyze` in `packages/fifty_tokens/` -- zero issues
2. Run `flutter test` in `packages/fifty_tokens/` -- all tests pass
3. Run `flutter analyze` across full mono-repo -- identify `const` breakage in downstream packages
4. Document the `const` -> non-const breaking changes for AC-006 migration guide

---

## Dependency Graph (Implementation Order)

```
Phase 1: Config classes (no dependencies between them)
  1a. color_config.dart
  1b. typography_config.dart (includes FontSource enum)
  1c. spacing_config.dart
  1d. radii_config.dart
  1e. motion_config.dart
  1f. breakpoints_config.dart
  1g. fifty_tokens_config.dart (depends on all above)

Phase 2: Font resolver
  2a. font_resolver.dart (depends on 1b for FontSource)

Phase 3: Refactor token files (depends on Phase 1)
  3a. colors.dart (depends on 1a)
  3b. typography.dart (depends on 1b)
  3c. spacing.dart (depends on 1c)
  3d. radii.dart (depends on 1d)
  3e. motion.dart (depends on 1e)
  3f. shadows.dart (depends on 3a for FiftyColors getters -- already done)
  3g. gradients.dart (depends on 3a for FiftyColors getters)
  3h. breakpoints.dart (depends on 1f)

Phase 4: Barrel export (depends on all above)
Phase 5: Update existing tests (depends on Phase 3-4)
Phase 6: New config tests (depends on Phase 3-4)
Phase 7: Analyze and verify (depends on all)
```

**Parallelizable work:**
- All config classes (1a-1f) are independent
- All token file refactors (3a-3e, 3h) are independent (3f and 3g depend on 3a)
- All new test files (6a-6h) are independent

---

## Testing Strategy

### Unit Tests (Phase 5-6)

| Test File | Coverage Target |
|-----------|----------------|
| `test/config/fifty_tokens_config_test.dart` | `configure()`, `reset()`, `isConfigured` |
| `test/config/color_config_test.dart` | All 18 configurable colors + semantic fallback chains |
| `test/config/typography_config_test.dart` | All 28 configurable typography tokens + fontSource |
| `test/config/spacing_config_test.dart` | All 15 spacing values |
| `test/config/radii_config_test.dart` | 8 double values + 8 BorderRadius computed getters |
| `test/config/motion_config_test.dart` | 4 durations + 3 curves |
| `test/config/breakpoints_config_test.dart` | 3 breakpoint values |
| `test/config/font_resolver_test.dart` | GoogleFonts path + asset path |

### Regression Tests (Phase 5)

All 9 existing test files updated to work with getter-based API. Key change: `const Color(...)` expectations become `Color(...)` (non-const). Deprecated member tests unchanged.

### Integration Verification (Phase 7)

- `flutter analyze` across mono-repo to find all `const` context breakages
- Document breakages for AC-006 migration brief

### Test Isolation Pattern

Every test group that calls `FiftyTokens.configure()` must call `FiftyTokens.reset()` in `tearDown`:

```dart
group('with custom config', () {
  setUp(() {
    FiftyTokens.configure(colors: FiftyColorConfig(primary: Color(0xFF0000FF)));
  });

  tearDown(() => FiftyTokens.reset());

  test('primary returns custom color', () {
    expect(FiftyColors.primary, Color(0xFF0000FF));
  });
});
```

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `const` context breakage in 100+ downstream files (651 occurrences) | **Certain** | **High** -- all downstream packages break at analyze time | This is intentional. AC-003 through AC-005 will fix downstream. Document in AC-006 migration guide. Do NOT fix downstream in this brief. |
| Semantic alias getter chains create unexpected behavior | Medium | Medium -- consumer overrides burgundy, expects primary to change | Document the fallback chain clearly. Test it explicitly. |
| `@internal` annotation not respected by consumers | Low | Low -- consumers bypass `FiftyTokens.configure()` and set `config` directly | Lint warning generated. Document canonical API. |
| Font resolver requires network access for Google Fonts in tests | Medium | Low -- test failures in CI without network | Use `GoogleFonts.config.allowRuntimeFetching = false` in test setUp. |
| `static get` has minor performance cost vs `static const` | Low | Low -- getter lookup is negligible | No mitigation needed. Dart inlines simple getters. |
| `FiftyRadii` BorderRadius getters create new objects on every access | Medium | Low -- allocations on each `build()` call | `BorderRadius.circular()` returns lightweight objects. Can add caching if profiling shows issues. |
| Gradients partially fixed -- `_defaultPrimaryEnd` hex still duplicated | Low | Low -- only one gradient endpoint remains as private hex | Acceptable. Not a brand color, just a gradient stop. |

---

## Notes for FORGER

### @internal Import

Use `import 'package:meta/meta.dart'` for `@internal`. Check that `meta` is a transitive dependency via Flutter SDK (it is -- `flutter/foundation.dart` re-exports it). No need to add `meta` to pubspec.

### Naming Convention for Defaults

Private default constants use `_default` prefix with PascalCase field name:
```dart
static const Color _defaultBurgundy = Color(0xFF88292F);
static const Color _defaultBurgundyHover = Color(0xFF6E2126);
```

### Config Class Pattern

All config classes follow the same template:
```dart
import 'package:flutter/material.dart';

/// Configuration for [FiftyXxx] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyXxxConfig {
  /// Creates a [FiftyXxxConfig] with optional overrides.
  const FiftyXxxConfig({
    this.fieldA,
    this.fieldB,
    // ...
  });

  /// Override for [FiftyXxx.fieldA]. Default: `<FDL value>`.
  final Type? fieldA;

  /// Override for [FiftyXxx.fieldB]. Default: `<FDL value>`.
  final Type? fieldB;
}
```

### No Shadows Config

`FiftyShadows` does NOT get a config class. Its `primary` and `glow` getters already dynamically reference FiftyColors. The base shadows (`sm`, `md`, `lg`) stay `static const` because shadow geometry (offsets, blur, opacity on black) is not brand-specific.

### Gradients: No Config Class

`FiftyGradients` does NOT get a config class. Gradients become getters that reference FiftyColors getters, so they respond to color configuration automatically. The gradient structure (alignment, stop count) stays fixed.

### Breakpoints: Config Class Added

Even though breakpoints have zero `const` downstream usage, they should be configurable for completeness. A responsive system consumer may have different breakpoint thresholds.

---

## Downstream Impact Summary

| Package | const Breakages | Fix Brief |
|---------|----------------|-----------|
| `fifty_theme` | ~12 occurrences | AC-003 |
| `fifty_ui` | ~50+ occurrences | AC-004 |
| `fifty_forms` | ~20+ occurrences | AC-005 |
| `fifty_connectivity` | ~20+ occurrences | AC-005 |
| `fifty_achievement_engine` | ~30+ occurrences | AC-005 |
| `fifty_printing_engine` (example) | ~30+ occurrences | AC-005 |
| `fifty_audio_engine` (example) | ~15+ occurrences | AC-005 |
| `fifty_speech_engine` | ~10+ occurrences | AC-005 |
| `fifty_skill_tree` (example) | ~15+ occurrences | AC-005 |
| `fifty_scroll_sequence` (example) | ~10+ occurrences | AC-005 |
| `fifty_socket` (example) | ~5+ occurrences | AC-005 |

**Total downstream breakages:** ~650 `const` context removals across ~100 files in ~11 packages. All are mechanical: remove `const` keyword from widget constructors that reference token values.
