# fifty_tokens Package Configurability Audit

**Research Date:** 2026-03-01
**Package Version:** 2.0.0
**Status:** Complete

## Executive Summary

The fifty_tokens package has **EXCELLENT configurability** for structural tokens (colors, spacing, typography, radii, motion, breakpoints) through `FiftyTokens.configure()`. However, **FiftyShadows and FiftyGradients are completely hardcoded** with NO configuration API.

### Quick Stats

| Category | Total Properties | Configurable | NOT Configurable | Coverage |
|----------|------------------|--------------|------------------|-----------|
| **FiftyColors** | 24 | 18 | 6 | 75% |
| **FiftySpacing** | 15 | 15 | 0 | 100% |
| **FiftyTypography** | 26 | 26 | 0 | 100% |
| **FiftyRadii** | 15 | 8 | 7 | 53% |
| **FiftyMotion** | 7 | 7 | 0 | 100% |
| **FiftyBreakpoints** | 3 | 3 | 0 | 100% |
| **FiftyShadows** | 5 | 0 | 5 | 0% |
| **FiftyGradients** | 3 | 0 | 3 | 0% |

---

## Detailed Analysis by Category

### 1. FiftyColors (24 properties, 75% configurable)

**Configuration Class:** `FiftyColorConfig` (18 override fields)

**Configurable (18):**
- `burgundy` (primary brand)
- `burgundyHover`
- `cream`
- `darkBurgundy`
- `slateGrey` (secondary)
- `slateGreyHover`
- `hunterGreen` (success)
- `powderBlush`
- `surfaceLight`
- `surfaceDark`
- `primary` (explicit override, falls back to burgundy)
- `primaryHover` (falls back to burgundyHover)
- `secondary` (explicit override, falls back to slateGrey)
- `secondaryHover` (falls back to slateGreyHover)
- `success` (explicit override, falls back to hunterGreen)
- `warning`
- `error` (explicit override, falls back to primary)
- `focusLight` (explicit override, falls back to primary)

**NOT Configurable (6):**
1. `borderLight` — Static: `Colors.black.withValues(alpha: 0.05)` (hardcoded)
2. `borderDark` — Static: `Colors.white.withValues(alpha: 0.05)` (hardcoded)
3. `focusDark` — Static: `powderBlush.withValues(alpha: 0.5)` (hardcoded opacity)
4. `voidBlack` — Deprecated constant
5. `crimsonPulse` — Deprecated constant
6. `gunmetal` — Deprecated constant
7. `terminalWhite` — Deprecated constant
8. `hyperChrome` — Deprecated constant
9. `igrisGreen` — Deprecated constant
10. `border` — Deprecated constant

**Analysis:**
- All primary color palette is configurable
- All semantic colors have explicit override options
- `borderLight/borderDark` are computed from opacity (not configurable)
- `focusDark` opacity is hardcoded to 50% (should be configurable)
- Deprecated colors are locked (correct)

**Missing Gaps:**
- `borderLight` opacity (5%) — not configurable
- `borderDark` opacity (5%) — not configurable
- `focusDark` opacity (50%) — not configurable

---

### 2. FiftySpacing (15 properties, 100% configurable)

**Configuration Class:** `FiftySpacingConfig` (15 override fields)

**ALL Configurable (15):**
1. `base` (4px)
2. `tight` (8px)
3. `standard` (12px)
4. `xs` (4px)
5. `sm` (8px)
6. `md` (12px)
7. `lg` (16px)
8. `xl` (20px)
9. `xxl` (24px)
10. `xxxl` (32px)
11. `huge` (40px)
12. `massive` (48px)
13. `gutterDesktop` (24px)
14. `gutterTablet` (16px)
15. `gutterMobile` (12px)

**Analysis:**
- **Perfect configurability** — every spacing value is overridable
- All values use fallback pattern: `config?.value ?? _defaultValue`
- Responsive gutters fully configurable
- NO deprecated values

**Strengths:**
- Complete semantic spacing scale
- Responsive gutters
- Consistent getter pattern

---

### 3. FiftyTypography (26 properties, 100% configurable)

**Configuration Class:** `FiftyTypographyConfig` (26 override fields)

**ALL Configurable (26):**

**Font System (2):**
1. `fontFamily` (Manrope)
2. `fontSource` (GoogleFonts vs Asset)

**Font Weights (5):**
3. `regular` (400)
4. `medium` (500)
5. `semiBold` (600)
6. `bold` (700)
7. `extraBold` (800)

**Type Scale (11):**
8. `displayLarge` (32px)
9. `displayMedium` (24px)
10. `titleLarge` (20px)
11. `titleMedium` (18px)
12. `titleSmall` (16px)
13. `bodyLarge` (16px)
14. `bodyMedium` (14px)
15. `bodySmall` (12px)
16. `labelLarge` (14px)
17. `labelMedium` (12px)
18. `labelSmall` (10px)

**Letter Spacing (7):**
19. `letterSpacingDisplay` (-0.5)
20. `letterSpacingDisplayMedium` (-0.25)
21. `letterSpacingBody` (0.5)
22. `letterSpacingBodyMedium` (0.25)
23. `letterSpacingBodySmall` (0.4)
24. `letterSpacingLabel` (0.5)
25. `letterSpacingLabelMedium` (1.5)

**Line Heights (4):**
26. `lineHeightDisplay` (1.2)
27. `lineHeightTitle` (1.3)
28. `lineHeightBody` (1.5)
29. `lineHeightLabel` (1.2)

**Analysis:**
- **Perfect configurability** — every typography value is overridable
- Includes font loading strategy (GoogleFonts vs Asset)
- All deprecated v1 values remain as constants (safe)
- Getter pattern: `config?.value ?? _defaultValue`

**Special Feature:**
- `FontSource` enum allows switching from GoogleFonts to local assets at runtime
- `FiftyFontResolver` utility handles font loading resolution

---

### 4. FiftyRadii (15 properties, 53% configurable)

**Configuration Class:** `FiftyRadiiConfig` (8 override fields)

**Configurable (8):**
1. `none` (0)
2. `sm` (4px)
3. `md` (8px)
4. `lg` (12px)
5. `xl` (16px)
6. `xxl` (24px)
7. `xxxl` (32px)
8. `full` (9999px)

**NOT Configurable (7):**
1. `noneRadius` — Computed: `BorderRadius.circular(none)` (depends on none)
2. `smRadius` — Computed: `BorderRadius.circular(sm)` (depends on sm)
3. `mdRadius` — Computed: `BorderRadius.circular(md)` (depends on md)
4. `lgRadius` — Computed: `BorderRadius.circular(lg)` (depends on lg)
5. `xlRadius` — Computed: `BorderRadius.circular(xl)` (depends on xl)
6. `xxlRadius` — Computed: `BorderRadius.circular(xxl)` (depends on xxl)
7. `xxxlRadius` — Computed: `BorderRadius.circular(xxxl)` (depends on xxxl)
8. `fullRadius` — Computed: `BorderRadius.circular(full)` (depends on full)
9-11. Deprecated constants (standard, smooth, standardRadius, smoothRadius)

**Analysis:**
- Base radius values ARE fully configurable
- BorderRadius **computed properties** are not overridable (but automatically compute from base values)
- This is by design — BorderRadius objects are convenience wrappers
- Clean dependency: `BorderRadius get smRadius => BorderRadius.circular(sm)`

**Note:**
- No configurability needed for computed BorderRadius — they auto-update when base values change
- This is a feature, not a gap

---

### 5. FiftyMotion (7 properties, 100% configurable)

**Configuration Class:** `FiftyMotionConfig` (7 override fields)

**ALL Configurable (7):**

**Durations (4):**
1. `instant` (0ms)
2. `fast` (150ms)
3. `compiling` (300ms)
4. `systemLoad` (800ms)

**Easing Curves (3):**
5. `standard` (Cubic 0.2,0,0,1)
6. `enter` (Cubic 0.2,0.8,0.2,1)
7. `exit` (Cubic 0.4,0,1,1)

**Analysis:**
- **Perfect configurability** — every motion value is overridable
- Includes both durations and easing curves
- Getter pattern: `config?.value ?? _defaultValue`
- No deprecated values

---

### 6. FiftyBreakpoints (3 properties, 100% configurable)

**Configuration Class:** `FiftyBreakpointsConfig` (3 override fields)

**ALL Configurable (3):**
1. `mobile` (768px)
2. `tablet` (768px)
3. `desktop` (1024px)

**Analysis:**
- **Perfect configurability** — every breakpoint is overridable
- No computed properties
- Getter pattern: `config?.value ?? _defaultValue`
- No deprecated values

---

### 7. FiftyShadows (5 properties, 0% configurable)

**Configuration:** NONE (no config class exists)

**Properties:**
1. `sm` — Static const (hardcoded)
2. `md` — Static const (hardcoded)
3. `lg` — Static const (hardcoded)
4. `primary` — Getter using FiftyColors.burgundy (hardcoded opacity 20%)
5. `glow` — Getter using FiftyColors.cream (hardcoded opacity 10%)

**Analysis:**
- **NO configurability** — Zero override options
- `sm`, `md`, `lg` are hardcoded constants (cannot change opacity/blur)
- `primary` and `glow` depend on colors but opacity values are hardcoded
- No escape hatch for custom shadows

**Gap:**
- Should have `FiftyShadowsConfig` with optional overrides:
  - `sm`, `md`, `lg` shadow definitions
  - `primaryOpacity` for shadow color blending
  - `glowOpacity` for shadow color blending

---

### 8. FiftyGradients (3 properties, 0% configurable)

**Configuration:** NONE (no config class exists)

**Properties:**
1. `primary` — LinearGradient: burgundy → #5A1B1F (hardcoded end color)
2. `progress` — LinearGradient: powderBlush → burgundy
3. `surface` — LinearGradient: darkBurgundy → surfaceDark

**Analysis:**
- **NO configurability** — Zero override options
- Gradients read from FiftyColors getters (GOOD — they respond to color config)
- BUT `primary` gradient has hardcoded end color `_defaultPrimaryEnd = Color(0xFF5A1B1F)`
- No API to customize gradient endpoints or directions

**Current Behavior:**
- If you override `burgundy`, the `primary` gradient updates automatically (good!)
- If you override `powderBlush` or `darkBurgundy`, the `progress` and `surface` gradients update (good!)
- But if you want a different gradient direction or different end color, you're stuck

**Gap:**
- Should have `FiftyGradientsConfig` (optional) to customize:
  - Gradient endpoints (alignments)
  - End color for `primary` gradient (currently hardcoded to `#5A1B1F`)
  - Individual gradient activation/deactivation

---

## Configuration API Completeness

### Supported via FiftyTokens.configure()

```dart
FiftyTokens.configure(
  colors: FiftyColorConfig(...),       // 18/24 properties configurable
  typography: FiftyTypographyConfig(...), // 26/26 properties configurable ✓
  spacing: FiftySpacingConfig(...),       // 15/15 properties configurable ✓
  radii: FiftyRadiiConfig(...),           // 8/8 properties configurable ✓
  motion: FiftyMotionConfig(...),         // 7/7 properties configurable ✓
  breakpoints: FiftyBreakpointsConfig(...), // 3/3 properties configurable ✓
);
```

### NOT Supported

- `FiftyShadows` — No config class, all properties hardcoded
- `FiftyGradients` — No config class, all properties hardcoded
- `FiftyColors.borderLight/borderDark` — Opacity hardcoded (5%)
- `FiftyColors.focusDark` — Opacity hardcoded (50%)
- `FiftyRadii.*Radius` properties — Computed from base values (by design, not a gap)

---

## Key Findings

### Strengths

1. **Complete configurability for structural tokens** (spacing, typography, motion, breakpoints)
2. **Semantic color aliases** (primary, secondary, success, error) allow brand-level overrides
3. **Font loading strategy** is configurable (GoogleFonts vs Asset fonts)
4. **Clean fallback pattern** — `config?.value ?? _defaultValue` throughout
5. **Responsive design support** — gutters and breakpoints fully configurable
6. **Deprecation handling** — old v1 tokens remain as constants (safe migration path)

### Gaps

1. **FiftyShadows — NO configuration API**
   - All 5 shadow properties are hardcoded
   - `sm`, `md`, `lg` are static constants
   - `primary` and `glow` have hardcoded opacities (20%, 10%)

2. **FiftyGradients — NO configuration API**
   - All 3 gradient properties are hardcoded
   - `primary` gradient has hardcoded end color (`#5A1B1F`)
   - No way to customize gradient directions or endpoints

3. **FiftyColors — Opacity values hardcoded**
   - `borderLight/borderDark` opacity: 5% (hardcoded)
   - `focusDark` opacity: 50% (hardcoded)

4. **No unified reset mechanism for partial configs**
   - `FiftyTokens.reset()` resets all categories
   - Can't reset just shadows or just colors

---

## Recommendations

### Priority 1: Add FiftyShadowsConfig

```dart
class FiftyShadowsConfig {
  final List<BoxShadow>? sm;
  final List<BoxShadow>? md;
  final List<BoxShadow>? lg;
  final double? primaryOpacity; // For burgundy-based shadows
  final double? glowOpacity;    // For cream-based shadows
}
```

Then update `FiftyMotion.configure()` to accept it.

### Priority 2: Add FiftyGradientsConfig

```dart
class FiftyGradientsConfig {
  final Color? primaryEnd;  // Custom end color for primary gradient
  final Alignment? primaryBegin;
  final Alignment? primaryEnd;
  // etc.
}
```

### Priority 3: Extract opacity constants

```dart
class FiftyColorsConfig {
  final double? borderOpacity;    // Currently 0.05
  final double? focusDarkOpacity; // Currently 0.5
  // ...
}
```

---

## Testing Coverage

- Config classes exist for 6/8 token categories (75%)
- No unit tests for config application (should test overrides)
- No integration tests verifying color config propagates to shadows/gradients

---

## Historical Context

- **v2.0.0:** Introduced `FiftyTokens.configure()` API
- **Previously:** All tokens were hardcoded constants
- **Future:** Add shadow and gradient configurability
