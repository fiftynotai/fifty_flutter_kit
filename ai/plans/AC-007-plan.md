# Implementation Plan: AC-007

**Complexity:** L
**Estimated Duration:** 4-5 hours across 7 phases
**Risk Level:** Medium

## Summary

Restructure fifty_tokens from scattered per-class defaults with nullable config overlays into a unified FiftyPreset architecture where FDL v2 is a single static const preset, token classes become agnostic readers, all config fields are non-nullable and required, color fields use semantic names, and every config class gets `fromMap()` + `copyWith()`. Then update fifty_theme to use the new semantic color names.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_tokens/lib/src/preset.dart` | CREATE | FiftyPreset class with fdlV2 const, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/color_config.dart` | MODIFY | Semantic field names, non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/spacing_config.dart` | MODIFY | Non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/typography_config.dart` | MODIFY | Non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/radii_config.dart` | MODIFY | Non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/motion_config.dart` | MODIFY | Non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/breakpoints_config.dart` | MODIFY | Non-nullable required, fromMap(), copyWith() |
| `packages/fifty_tokens/lib/src/config/shadows_config.dart` | CREATE | New FiftyShadowsConfig class |
| `packages/fifty_tokens/lib/src/config/gradients_config.dart` | CREATE | New FiftyGradientsConfig class |
| `packages/fifty_tokens/lib/src/config/fifty_tokens_config.dart` | MODIFY | Rewrite to preset-based architecture (load/configure/reset/active) |
| `packages/fifty_tokens/lib/src/colors.dart` | MODIFY | Agnostic reader + deprecation aliases |
| `packages/fifty_tokens/lib/src/spacing.dart` | MODIFY | Agnostic reader (remove defaults + config?) |
| `packages/fifty_tokens/lib/src/typography.dart` | MODIFY | Agnostic reader (remove defaults + config?) |
| `packages/fifty_tokens/lib/src/radii.dart` | MODIFY | Agnostic reader (remove defaults + config?) |
| `packages/fifty_tokens/lib/src/motion.dart` | MODIFY | Agnostic reader (remove defaults + config?) |
| `packages/fifty_tokens/lib/src/breakpoints.dart` | MODIFY | Agnostic reader (remove defaults + config?) |
| `packages/fifty_tokens/lib/src/shadows.dart` | MODIFY | Agnostic reader (sm/md/lg from config, primary/glow computed) |
| `packages/fifty_tokens/lib/src/gradients.dart` | MODIFY | Agnostic reader (primaryEnd from config) |
| `packages/fifty_tokens/lib/fifty_tokens.dart` | MODIFY | Add preset.dart, shadows_config.dart, gradients_config.dart exports |
| `packages/fifty_tokens/test/config/color_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/spacing_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/typography_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/radii_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/motion_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/breakpoints_config_test.dart` | MODIFY | Update to non-nullable API |
| `packages/fifty_tokens/test/config/fifty_tokens_config_test.dart` | MODIFY | Rewrite for load/configure/reset/active API |
| `packages/fifty_tokens/test/colors_test.dart` | MODIFY | Semantic names, deprecation aliases, new fields |
| `packages/fifty_tokens/test/shadows_test.dart` | MODIFY | Configurable shadows |
| `packages/fifty_tokens/test/gradients_test.dart` | MODIFY | Configurable gradients, semantic names |
| `packages/fifty_tokens/test/fifty_tokens_test.dart` | MODIFY | Update barrel export checks |
| `packages/fifty_tokens/test/preset_test.dart` | CREATE | FiftyPreset tests (fdlV2, fromMap, copyWith) |
| `packages/fifty_tokens/test/config/shadows_config_test.dart` | CREATE | FiftyShadowsConfig tests |
| `packages/fifty_tokens/test/config/gradients_config_test.dart` | CREATE | FiftyGradientsConfig tests |
| `packages/fifty_theme/lib/src/color_scheme.dart` | MODIFY | Replace palette names with semantic names |
| `packages/fifty_theme/lib/src/theme_extensions.dart` | MODIFY | Replace powderBlush with accent |
| `packages/fifty_theme/test/color_scheme_test.dart` | MODIFY | Update palette-name assertions |
| `packages/fifty_theme/test/theme_extensions_test.dart` | MODIFY | Update palette-name assertions |
| `packages/fifty_theme/test/fifty_theme_test.dart` | MODIFY | Update palette-name assertions |

## Implementation Steps

---

### Phase 1: Create New Config Classes (Shadows + Gradients) and Make All Config Classes Non-Nullable with fromMap/copyWith

**Goal:** All 8 category config classes exist, all fields are non-nullable and required, each has `fromMap()` and `copyWith()`. This phase does NOT change how they are consumed yet -- the token classes and FiftyTokens still use the old nullable pattern. This ensures the analyzer passes at each step.

**IMPORTANT CONSTRAINT:** During this phase, the existing system still works because nothing consumes the new non-nullable configs yet. The old config classes CANNOT simply be converted in-place because they are currently constructed with `const FiftyColorConfig(burgundy: someColor)` (partial, nullable fields) throughout tests and FiftyTokens.configure. So this phase must create new classes with different names or restructure carefully.

**RESOLUTION:** The cleanest approach is to build the new config classes under the SAME file paths but as **replacements** -- meaning the field names change (palette->semantic for colors) and all fields become required. The existing FiftyTokens.configure(), token class getters, and tests all break at compile-time, which we fix in subsequent phases. The key insight is: we do Phase 1 + Phase 2 + Phase 3 + Phase 4 together as one atomic unit that must all compile together. But to keep FORGER phases manageable, we structure it differently.

**REVISED APPROACH:** We build the entire new layer (preset + configs + token rewrites) in one integrated pass per-category, then flip the barrel export at the end. However, for practical FORGER delegation, the phases are structured so each one results in a compilable state.

**FILES:**

1. Create `packages/fifty_tokens/lib/src/config/shadows_config.dart` -- NEW
   - `FiftyShadowsConfig` with required fields: `sm`, `md`, `lg`, `primaryOpacity`, `glowOpacity`
   - `fromMap()` factory with required `fallback` parameter
   - `copyWith()` method
   - Note: `sm`, `md`, `lg` are `List<BoxShadow>` -- cannot be const. Use final fields, not const constructor.
   - `primaryOpacity` and `glowOpacity` are `double`

2. Create `packages/fifty_tokens/lib/src/config/gradients_config.dart` -- NEW
   - `FiftyGradientsConfig` with required field: `primaryEnd` (Color)
   - `fromMap()` factory with required `fallback` parameter
   - `copyWith()` method

3. Add `fromMap()` and `copyWith()` to existing config classes (DO NOT change nullability yet):
   - `color_config.dart` -- add `copyWith()` and `fromMap()` (still nullable fields, palette names for now)
   - `spacing_config.dart` -- add `copyWith()` and `fromMap()`
   - `typography_config.dart` -- add `copyWith()` and `fromMap()`
   - `radii_config.dart` -- add `copyWith()` and `fromMap()`
   - `motion_config.dart` -- add `copyWith()` and `fromMap()`
   - `breakpoints_config.dart` -- add `copyWith()` and `fromMap()`

4. Update barrel `packages/fifty_tokens/lib/fifty_tokens.dart`:
   - Add `export 'src/config/shadows_config.dart';`
   - Add `export 'src/config/gradients_config.dart';`

5. Create tests:
   - `packages/fifty_tokens/test/config/shadows_config_test.dart`
   - `packages/fifty_tokens/test/config/gradients_config_test.dart`

**ANALYZER CHECK:** Passes -- new files are additive, existing files gain methods but don't break.

**fromMap() design notes:**
- Colors: parse hex strings `'#RRGGBB'` or `'0xAARRGGBB'` or int `0xFF...`
- Durations: parse int (milliseconds)
- Curves: NOT parseable from JSON -- skip in fromMap, use fallback
- FontWeight: parse int (400, 500, 600...)
- FontSource: parse string `'googleFonts'` or `'asset'`
- BoxShadow lists: parse list of maps `{offset: {dx, dy}, blurRadius, color}`
- All fromMap methods take `{required T fallback}` for missing keys

---

### Phase 2: Create FiftyPreset and Rewrite FiftyTokens Manager

**Goal:** Create `FiftyPreset` class with `fdlV2` static const and rewrite `FiftyTokens` to use preset-based architecture. Token classes still use old pattern (config? ?? default) but FiftyTokens now bridges to them.

**FILES:**

1. Create `packages/fifty_tokens/lib/src/preset.dart` -- NEW
   - `FiftyPreset` class with 8 required config fields
   - `static const fdlV2` -- all FDL v2 default values in one place
   - `factory FiftyPreset.fromMap(Map<String, dynamic> map, {FiftyPreset fallback = fdlV2})`
   - `copyWith()` method
   - Note: Cannot be `const` constructor because `FiftyShadowsConfig` contains `List<BoxShadow>` which is not const-compatible (BoxShadow uses Color which is not a const literal with all values). Actually -- BoxShadow IS const. `const BoxShadow(...)` works. And `const [BoxShadow(...)]` works. So `FiftyPreset` CAN be `const` if all sub-configs are const. Let me verify: Color(0xFF...) is const, Offset is const, BoxShadow is const, List literal is const. Duration is const. Cubic is const. Yes -- FiftyPreset.fdlV2 CAN be `static const`.
   - WAIT: `FiftyShadowsConfig` has `List<BoxShadow>` fields. A const constructor with List fields works if the list is provided as a const literal. The config class constructor can be `const` and the fields `final List<BoxShadow>`. Yes this works.

2. Rewrite `packages/fifty_tokens/lib/src/config/fifty_tokens_config.dart`:
   - Import preset.dart
   - `FiftyTokens` now holds `static FiftyPreset _active = FiftyPreset.fdlV2;`
   - `static FiftyPreset get active => _active;`
   - `static void load(FiftyPreset preset) { _active = preset; }`
   - `static void configure({...8 optional categories...})` -- builds preset using FiftyPreset.fdlV2 fallback
   - `static void reset()` -- sets `_active = FiftyPreset.fdlV2;`
   - `static bool get isConfigured => !identical(_active, FiftyPreset.fdlV2);`
   - ALSO: still sets the old per-class `config` fields during transition so existing token getters work. This is the bridge.
   - The bridge: `configure()` creates the preset AND sets `FiftyColors.config = colors`, `FiftySpacing.config = spacing`, etc. This keeps everything working during the transition.
   - `reset()` clears both `_active` and per-class configs.

3. Update barrel `packages/fifty_tokens/lib/fifty_tokens.dart`:
   - Add `export 'src/preset.dart';`

4. Create `packages/fifty_tokens/test/preset_test.dart` -- NEW
   - Test `FiftyPreset.fdlV2` has all fields populated with correct values
   - Test `FiftyPreset.fromMap()` with empty map returns fdlV2 values
   - Test `FiftyPreset.fromMap()` with partial data uses fallback
   - Test `FiftyPreset.copyWith()` replaces individual categories

5. Update `packages/fifty_tokens/test/config/fifty_tokens_config_test.dart`:
   - Add tests for `load()`, `active` getter, `isConfigured` with identical check
   - Existing `configure()` tests should still pass (bridge behavior)

**ANALYZER CHECK:** Passes -- FiftyTokens bridge keeps old token class getters working.

**TRICKY NOTES:**
- `FiftyPreset.fdlV2` needs to reference all the FDL default values. For colors, use palette names internally in the const (they're just Color values). The semantic NAMING of config fields is separate from the const values.
- At this point `FiftyColorConfig` still uses palette-name fields (burgundy, cream, etc.) because we haven't renamed yet. That's fine -- the preset just holds it.
- The `configure()` bridge is temporary -- removed in Phase 4 when token classes become agnostic readers.

---

### Phase 3: Rename Color Config Fields to Semantic Names

**Goal:** Transform `FiftyColorConfig` from palette names (burgundy, cream, darkBurgundy) to semantic names (primary, background, backgroundDark). Add new fields (onPrimary, onBackground, borderOpacity, focusOpacity). Update `FiftyPreset.fdlV2` to match.

**FILES:**

1. Rewrite `packages/fifty_tokens/lib/src/config/color_config.dart`:
   - All fields become required and non-nullable
   - Field renames: burgundy->primary, burgundyHover->primaryHover, cream->background, darkBurgundy->backgroundDark, slateGrey->secondary, slateGreyHover->secondaryHover, hunterGreen->success, powderBlush->accent, surfaceLight->surface
   - Keep: surfaceDark, warning, error (unchanged names)
   - Remove: focusLight (computed from primary), old palette-only duplicate fields
   - Add: onPrimary (Color), onBackground (Color), borderOpacity (double), focusOpacity (double)
   - Update `fromMap()` to use semantic key names
   - Update `copyWith()` to use semantic field names
   - Remove old palette-name fields entirely from config class

2. Update `packages/fifty_tokens/lib/src/preset.dart`:
   - Update `FiftyPreset.fdlV2.colors` to use new semantic field names
   - Values stay the same (0xFF88292F is primary, 0xFFFEFEE3 is background, etc.)
   - Add: `onPrimary: Color(0xFFFEFEE3)`, `onBackground: Color(0xFF1A0D0E)`, `borderOpacity: 0.05`, `focusOpacity: 0.5`

3. Update `packages/fifty_tokens/lib/src/colors.dart`:
   - Rewrite as agnostic reader: `static Color get primary => FiftyTokens.active.colors.primary;`
   - Remove ALL `_defaultX` constants
   - Remove `@internal static FiftyColorConfig? config;`
   - Remove all `config?.field ?? _defaultField` patterns
   - Add semantic getters: `background`, `backgroundDark`, `secondary`, `accent`, `surface`, `onPrimary`, `onBackground`
   - Computed getters: `borderLight` = `Colors.black.withValues(alpha: FiftyTokens.active.colors.borderOpacity)`, etc.
   - `focusLight` = `primary` (still derived, not from config)
   - `focusDark` = `accent.withValues(alpha: FiftyTokens.active.colors.focusOpacity)`
   - Add `@Deprecated` aliases for ALL old palette names:
     - `burgundy` -> `primary`
     - `burgundyHover` -> `primaryHover`
     - `cream` -> `background`
     - `darkBurgundy` -> `backgroundDark`
     - `slateGrey` -> `secondary`
     - `slateGreyHover` -> `secondaryHover`
     - `hunterGreen` -> `success`
     - `powderBlush` -> `accent`
     - `surfaceLight` -> `surface`
   - Keep existing v1 deprecated consts (voidBlack, crimsonPulse, etc.)

4. Update `packages/fifty_tokens/lib/src/config/fifty_tokens_config.dart`:
   - Remove bridge code that set `FiftyColors.config = ...`
   - `configure()` only builds preset now (colors config uses semantic names)
   - Since FiftyColors no longer has `.config`, the bridge is gone

5. Update `packages/fifty_tokens/test/colors_test.dart`:
   - Tests now use semantic names: `FiftyColors.primary`, `FiftyColors.background`, etc.
   - Old palette names tested via deprecated aliases
   - Test new fields: onPrimary, onBackground
   - Test computed fields: borderLight uses borderOpacity, focusDark uses focusOpacity
   - Test configuring borderOpacity/focusOpacity changes borderLight/borderDark/focusDark

6. Update `packages/fifty_tokens/test/config/color_config_test.dart`:
   - All config construction uses semantic, required, non-nullable fields
   - Test fromMap() with hex strings
   - Test copyWith() replacing individual fields
   - Remove fallback-chain tests (palette->semantic chain no longer exists -- all fields required)

7. Update `packages/fifty_tokens/test/config/fifty_tokens_config_test.dart`:
   - `configure(colors: ...)` now uses semantic FiftyColorConfig constructor
   - Remove `FiftyColors.burgundy` references, use `FiftyColors.primary`

8. Update `packages/fifty_tokens/test/fifty_tokens_test.dart`:
   - `FiftyColors.burgundy` -> `FiftyColors.primary` (or use deprecated getter)

9. Update `packages/fifty_tokens/test/shadows_test.dart`:
   - `FiftyColors.burgundy` -> `FiftyColors.primary`
   - `FiftyColors.cream` -> `FiftyColors.background`

10. Update `packages/fifty_tokens/test/gradients_test.dart`:
    - `FiftyColors.burgundy` -> `FiftyColors.primary`
    - `FiftyColors.powderBlush` -> `FiftyColors.accent`
    - `FiftyColors.darkBurgundy` -> `FiftyColors.backgroundDark`

**ANALYZER CHECK:** Must pass. The deprecated aliases ensure nothing breaks at compile-time for downstream consumers.

**TRICKY NOTES:**
- The old `FiftyColorConfig` constructor was `const FiftyColorConfig({this.burgundy, this.cream, ...})` with all optional. Now it's `const FiftyColorConfig({required this.primary, required this.background, ...})`. This breaks ALL existing call sites (tests, FiftyPreset.fdlV2). All must be updated in this phase.
- The old semantic fields (`primary`, `secondary`, `success`, `error`, `warning`) that existed ALONGSIDE palette fields are now the ONLY fields. The palette fields are gone from the config class.
- `FiftyTokens.configure(colors: ...)` still works but now requires a full FiftyColorConfig (all fields required). For partial overrides, consumer should use `FiftyPreset.fdlV2.colors.copyWith(primary: newColor)`.
- Wait -- the brief says `configure()` accepts individual categories where skipped = FDL v2. So `configure(colors: someColorConfig)` should work. But within the color config itself, ALL fields must be provided since they're non-nullable. Consumer constructs a full config OR uses `FiftyPreset.fdlV2.colors.copyWith(...)` for partial color changes. The `configure()` method's partiality is at the CATEGORY level, not the field level.

---

### Phase 4: Convert Remaining Token Classes to Agnostic Readers

**Goal:** Convert FiftySpacing, FiftyTypography, FiftyRadii, FiftyMotion, FiftyBreakpoints, FiftyShadows, FiftyGradients from `config? ?? _default` pattern to `FiftyTokens.active.category.field` pattern. Make their config classes non-nullable.

**FILES:**

1. Convert config classes to non-nullable required fields + fromMap + copyWith:
   - `packages/fifty_tokens/lib/src/config/spacing_config.dart`
   - `packages/fifty_tokens/lib/src/config/typography_config.dart`
   - `packages/fifty_tokens/lib/src/config/radii_config.dart`
   - `packages/fifty_tokens/lib/src/config/motion_config.dart`
   - `packages/fifty_tokens/lib/src/config/breakpoints_config.dart`
   - Each: change all `Type? field` to `required Type field`, add `fromMap()` + `copyWith()`
   - typography_config.dart: `fontSource` changes from optional with default to required

2. Convert token classes to agnostic readers:
   - `packages/fifty_tokens/lib/src/spacing.dart`: remove `config?` + `_default` pattern, read from `FiftyTokens.active.spacing.field`
   - `packages/fifty_tokens/lib/src/typography.dart`: same pattern
   - `packages/fifty_tokens/lib/src/radii.dart`: same pattern
   - `packages/fifty_tokens/lib/src/motion.dart`: same pattern
   - `packages/fifty_tokens/lib/src/breakpoints.dart`: same pattern
   - `packages/fifty_tokens/lib/src/shadows.dart`: sm/md/lg read from config; primary/glow remain computed from FiftyColors + config opacity
   - `packages/fifty_tokens/lib/src/gradients.dart`: primaryEnd reads from config; gradients still compute from FiftyColors getters
   - Each: remove `@internal static XConfig? config;`, remove all `_defaultX` constants, remove `import 'package:meta/meta.dart';` where no longer needed

3. Update `packages/fifty_tokens/lib/src/config/fifty_tokens_config.dart`:
   - Remove remaining bridge code (FiftySpacing.config = ..., etc.)
   - Clean `reset()` to only set `_active = FiftyPreset.fdlV2`
   - Remove imports of individual token classes (no longer needed)

4. Update `packages/fifty_tokens/lib/src/preset.dart`:
   - Verify `FiftyPreset.fdlV2` has correct values for ALL categories:
     - spacing: base=4, tight=8, standard=12, xs=4, sm=8, md=12, lg=16, xl=20, xxl=24, xxxl=32, huge=40, massive=48, gutterDesktop=24, gutterTablet=16, gutterMobile=12
     - typography: fontFamily='Manrope', fontSource=FontSource.googleFonts, regular=w400, medium=w500, semiBold=w600, bold=w700, extraBold=w800, all sizes and letter spacings and line heights
     - radii: none=0, sm=4, md=8, lg=12, xl=16, xxl=24, xxxl=32, full=9999
     - motion: instant=Duration.zero, fast=150ms, compiling=300ms, systemLoad=800ms, standard=Cubic(0.2,0,0,1), enter=Cubic(0.2,0.8,0.2,1), exit=Cubic(0.4,0,1,1)
     - breakpoints: mobile=768, tablet=768, desktop=1024
     - shadows: sm=[BoxShadow(0,1,2,0x0D000000)], md=[BoxShadow(0,4,6,0x12000000)], lg=[BoxShadow(0,10,15,0x1A000000)], primaryOpacity=0.2, glowOpacity=0.1
     - gradients: primaryEnd=Color(0xFF5A1B1F)

5. Update ALL remaining config tests:
   - `packages/fifty_tokens/test/config/spacing_config_test.dart`: required fields, fromMap, copyWith
   - `packages/fifty_tokens/test/config/typography_config_test.dart`: required fields, fromMap, copyWith
   - `packages/fifty_tokens/test/config/radii_config_test.dart`: required fields, fromMap, copyWith
   - `packages/fifty_tokens/test/config/motion_config_test.dart`: required fields, fromMap, copyWith
   - `packages/fifty_tokens/test/config/breakpoints_config_test.dart`: required fields, fromMap, copyWith

6. Update token class tests:
   - `packages/fifty_tokens/test/spacing_test.dart`: remove config override pattern, test via FiftyTokens.load/configure
   - `packages/fifty_tokens/test/typography_test.dart`: same
   - `packages/fifty_tokens/test/radii_test.dart`: same
   - `packages/fifty_tokens/test/motion_test.dart`: same
   - `packages/fifty_tokens/test/breakpoints_test.dart`: same
   - `packages/fifty_tokens/test/shadows_test.dart`: test shadow overrides via preset
   - `packages/fifty_tokens/test/gradients_test.dart`: test gradient overrides via preset

**ANALYZER CHECK:** Must pass. All fifty_tokens source + test files now use the new architecture.

**TRICKY NOTES:**
- `const FiftySpacingConfig()` no longer works (all fields required). Every test that used `const FiftySpacingConfig(base: 8)` must now provide ALL fields. Tests should use `FiftyPreset.fdlV2.spacing.copyWith(base: 8)` for partial overrides.
- FiftyShadows.primary and .glow are computed (color from FiftyColors + opacity from config). They remain `get` properties, not stored lists.
- FiftyShadows.sm/md/lg become getters reading from `FiftyTokens.active.shadows.sm`. They lose `const` -- they are already non-const in the `static const` declaration but accessed via `FiftyShadows.sm`. Wait -- currently they ARE `static const`. Changing to getters means `FiftyShadows.sm` is no longer const-eligible. Check: are there const-context usages of `FiftyShadows.sm`? From AC-006 notes, shadows have zero const-context usages. Safe.
- FiftyGradients already use `get` for all three (not const). No const-context issue.
- `FiftyTypographyConfig.fontSource` currently has a default value (`= FontSource.googleFonts`) and is not nullable. Making it `required` means call sites that omitted it must now specify it. In FiftyPreset.fdlV2 this is explicit. In tests, they'll need to provide it.

---

### Phase 5: Update fifty_theme to Use Semantic Names

**Goal:** Replace all palette-name references (`FiftyColors.cream`, `FiftyColors.darkBurgundy`, `FiftyColors.powderBlush`, `FiftyColors.burgundy`, `FiftyColors.surfaceLight`) in fifty_theme source files with semantic names.

**FILES:**

1. `packages/fifty_theme/lib/src/color_scheme.dart` (24 occurrences):
   - `FiftyColors.cream` -> `FiftyColors.background` (11 uses)
   - `FiftyColors.darkBurgundy` -> `FiftyColors.backgroundDark` (8 uses)
   - `FiftyColors.surfaceLight` -> `FiftyColors.surface` (1 use)
   - `FiftyColors.primary` stays (already semantic)
   - `FiftyColors.secondary` stays
   - `FiftyColors.success` stays

2. `packages/fifty_theme/lib/src/theme_extensions.dart` (1 occurrence):
   - `FiftyColors.powderBlush` -> `FiftyColors.accent`

3. `packages/fifty_theme/lib/src/component_themes.dart`: VERIFY -- currently uses only `colorScheme.*` and `FiftySpacing/FiftyRadii/FiftyTypography` (layout tokens). No palette-name color references. No changes needed.

4. `packages/fifty_theme/lib/src/text_theme.dart`: VERIFY -- uses only `FiftyTypography.*` and `FiftyFontResolver`. No color references. No changes needed.

5. `packages/fifty_theme/lib/src/fifty_theme_data.dart`: VERIFY -- uses `FiftyTypography`, `FiftyFontResolver`, delegates to FiftyColorScheme/FiftyComponentThemes. No direct FiftyColors references. No changes needed.

**ANALYZER CHECK:** Must pass. The deprecated aliases in FiftyColors ensure this is a clean rename -- same values.

**NOTE:** We do NOT use `// ignore: deprecated_member_use` because the source file references are intentional -- they go through the new semantic names, not the deprecated aliases. The whole point is to STOP using the deprecated names.

---

### Phase 6: Update fifty_theme Tests

**Goal:** Replace all palette-name assertions in fifty_theme tests with semantic names.

**FILES:**

1. `packages/fifty_theme/test/color_scheme_test.dart` (17 palette references):
   - `FiftyColors.burgundy` -> `FiftyColors.primary`
   - `FiftyColors.cream` -> `FiftyColors.background`
   - `FiftyColors.darkBurgundy` -> `FiftyColors.backgroundDark`
   - `FiftyColors.slateGrey` -> `FiftyColors.secondary`
   - `FiftyColors.hunterGreen` -> `FiftyColors.success`

2. `packages/fifty_theme/test/theme_extensions_test.dart` (10 palette references):
   - `FiftyColors.powderBlush` -> `FiftyColors.accent`
   - `FiftyColors.hunterGreen` -> `FiftyColors.success`
   - `FiftyColors.slateGrey` -> `FiftyColors.secondary`
   - `FiftyColors.burgundy` -> `FiftyColors.primary`
   - Update test descriptions to use semantic names

3. `packages/fifty_theme/test/fifty_theme_test.dart` (10 palette references):
   - `FiftyColors.darkBurgundy` -> `FiftyColors.backgroundDark`
   - `FiftyColors.cream` -> `FiftyColors.background`
   - `FiftyColors.burgundy` -> `FiftyColors.primary`

4. `packages/fifty_theme/test/component_themes_test.dart` (1 comment reference):
   - Update comment `// AppBar bg should be customScheme.surface, NOT FiftyColors.darkBurgundy` to use semantic name

**ANALYZER CHECK:** Must pass. All fifty_theme tests should pass (same underlying values).

---

### Phase 7: Version Bumps, Documentation, and Final Verification

**Goal:** Bump versions, update docs, run full test suite.

**FILES:**

1. `packages/fifty_tokens/pubspec.yaml`: version 2.0.0 -> 3.0.0
2. `packages/fifty_theme/pubspec.yaml`: version 2.0.0 -> 3.0.0
3. `packages/fifty_tokens/CHANGELOG.md`: Add v3.0.0 entry
4. `packages/fifty_theme/CHANGELOG.md`: Add v3.0.0 entry
5. `packages/fifty_tokens/README.md`: Update examples to show preset API
6. `docs/MIGRATION_GUIDE.md`: Add v2 -> v3 migration section
7. `ai/context/coding_guidelines.md`: Update token usage patterns if needed

**VERIFICATION:**
- `cd packages/fifty_tokens && flutter analyze` -> zero errors
- `cd packages/fifty_tokens && flutter test` -> all pass
- `cd packages/fifty_theme && flutter analyze` -> zero errors
- `cd packages/fifty_theme && flutter test` -> all pass

**NOTE:** fifty_ui and engine packages use deprecated palette getters. They will get deprecation WARNINGS but not errors. A separate brief (future) can clean those up. The deprecated aliases ensure zero breakage.

---

## Testing Strategy

- **Per-phase:** Run `flutter analyze` + `flutter test` in fifty_tokens after each phase 1-4
- **Phase 5-6:** Run `flutter analyze` + `flutter test` in fifty_theme
- **Phase 7:** Full cross-package verification
- **New test files:** preset_test.dart, shadows_config_test.dart, gradients_config_test.dart
- **Coverage targets:**
  - FiftyPreset.fdlV2 completeness
  - FiftyPreset.fromMap() with partial/full/empty maps
  - Each config fromMap() with hex color strings, int durations, etc.
  - Each config copyWith() replacing single fields
  - Token class getters reading from active preset
  - FiftyTokens.load() / configure() / reset() lifecycle
  - Deprecated palette aliases still resolve correctly

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| FiftyShadowsConfig List<BoxShadow> prevents const FiftyPreset | Low | High | Verified: BoxShadow constructor IS const, List literals ARE const. `static const fdlV2 = FiftyPreset(shadows: FiftyShadowsConfig(sm: [BoxShadow(...)]))` works. |
| Non-nullable config breaks partial configure pattern | Medium | Medium | `configure()` uses `FiftyPreset.fdlV2.category` as fallback for omitted categories. For partial color changes, consumer uses `FiftyPreset.fdlV2.colors.copyWith(primary: x)`. Document clearly. |
| fromMap() hex parsing edge cases | Medium | Low | Support `#RRGGBB`, `#AARRGGBB`, `0xAARRGGBB`, and raw int formats. Comprehensive tests. |
| Downstream packages break from palette name removal | Low | High | Deprecated aliases in FiftyColors ensure compile-time compatibility. Only warnings, not errors. fifty_theme is updated in Phase 5-6. fifty_ui and engines use deprecated getters safely. |
| Test files reference old FiftyColorConfig constructor (all fields now required) | High | Medium | Must update every test that constructs FiftyColorConfig. Use `FiftyPreset.fdlV2.colors.copyWith(...)` for partial overrides in tests. |
| FiftyMotionConfig curves not JSON-parseable | Low | Low | fromMap() skips curve fields (uses fallback). Document this limitation. |
| FiftyTokens.isConfigured uses `identical()` -- custom preset that equals fdlV2 values reports as configured | Low | Low | Acceptable behavior. `identical()` checks reference equality, which is the correct semantic for "has a custom preset been loaded". |
| Phase ordering dependency | Medium | Medium | Phases 1-4 must be done in order (each depends on prior). Phases 5-6 depend on 1-4. Phase 7 depends on all. No parallelism possible within fifty_tokens work. |

## Phase Dependency Graph

```
Phase 1 (config classes)
    |
    v
Phase 2 (FiftyPreset + FiftyTokens)
    |
    v
Phase 3 (color rename + FiftyColors agnostic)
    |
    v
Phase 4 (remaining token classes agnostic)
    |
    v
Phase 5 (fifty_theme source) ---> Phase 6 (fifty_theme tests)
                                        |
                                        v
                                  Phase 7 (versions + docs)
```

## Critical Implementation Details

### Color Hex Parsing Helper (for all fromMap methods)

```dart
/// Parse a color from Map value.
/// Supports: '#RRGGBB', '#AARRGGBB', '0xAARRGGBB', int
static Color _parseColor(dynamic value) {
  if (value is int) return Color(value);
  if (value is String) {
    var hex = value.replaceFirst('#', '').replaceFirst('0x', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
  throw ArgumentError('Cannot parse color from: $value');
}
```

This should be a package-private utility, not repeated in every config class. Place in `packages/fifty_tokens/lib/src/config/_parse_helpers.dart` (private convention with underscore, not exported from barrel). Or put it as a static method in a `TokenParseHelpers` class. Since it won't be exported, the underscore prefix approach works but Dart doesn't actually enforce private files -- use a separate unexported file.

### FiftyShadows Agnostic Reader Pattern

```dart
class FiftyShadows {
  FiftyShadows._();

  static List<BoxShadow> get sm => FiftyTokens.active.shadows.sm;
  static List<BoxShadow> get md => FiftyTokens.active.shadows.md;
  static List<BoxShadow> get lg => FiftyTokens.active.shadows.lg;

  // Computed from colors + shadow config opacity
  static List<BoxShadow> get primary => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 14,
      color: FiftyColors.primary.withValues(
        alpha: FiftyTokens.active.shadows.primaryOpacity,
      ),
    ),
  ];

  static List<BoxShadow> get glow => [
    BoxShadow(
      blurRadius: 15,
      color: FiftyColors.background.withValues(
        alpha: FiftyTokens.active.shadows.glowOpacity,
      ),
    ),
  ];

  static const List<BoxShadow> none = [];
}
```

### FiftyGradients Agnostic Reader Pattern

```dart
class FiftyGradients {
  FiftyGradients._();

  static LinearGradient get primary => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [FiftyColors.primary, FiftyTokens.active.gradients.primaryEnd],
  );

  static LinearGradient get progress => LinearGradient(
    colors: [FiftyColors.accent, FiftyColors.primary],
  );

  static LinearGradient get surface => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [FiftyColors.backgroundDark, FiftyColors.surfaceDark],
  );
}
```
