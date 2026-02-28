# Implementation Plan: AC-003

**Complexity:** L (Large)
**Estimated Duration:** 3-5 days
**Risk Level:** Medium

## Summary

Parameterize the entire `fifty_theme` package so that component themes consume `colorScheme.*` instead of hardcoded `FiftyColors.*`, theme entry points accept optional overrides, and font resolution uses `FiftyFontResolver` from AC-002. This eliminates ~160 hardcoded token references across 5 source files while maintaining full backward compatibility.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_theme/lib/src/color_scheme.dart` | MODIFY | Add optional color parameters to `dark()` and `light()`; read from semantic getters |
| `packages/fifty_theme/lib/src/component_themes.dart` | MODIFY | Replace all 91 `FiftyColors.*` refs with `colorScheme.*`; replace all 23 `GoogleFonts.manrope()` calls with `FiftyFontResolver.resolve()` |
| `packages/fifty_theme/lib/src/fifty_theme_data.dart` | MODIFY | Add optional params to `dark()`/`light()`; replace 18 inlined component themes with `FiftyComponentThemes.*` calls; use `FiftyFontResolver.resolveFamilyName()` for fontFamily |
| `packages/fifty_theme/lib/src/theme_extensions.dart` | MODIFY | Add optional semantic color params to `dark()`/`light()` factories |
| `packages/fifty_theme/lib/src/text_theme.dart` | MODIFY | Replace 15 `GoogleFonts.manrope()` calls with `FiftyFontResolver.resolve()` |
| `packages/fifty_theme/test/color_scheme_test.dart` | MODIFY | Add tests for parameterized overrides + token configuration cascading |
| `packages/fifty_theme/test/fifty_theme_test.dart` | MODIFY | Add tests for `FiftyTheme.dark(primaryColor: ...)`, `FiftyTheme.dark(colorScheme: ...)`, backward compat |
| `packages/fifty_theme/test/text_theme_test.dart` | MODIFY | Add tests for font resolver integration |
| `packages/fifty_theme/test/theme_extensions_test.dart` | MODIFY | Add tests for parameterized factories |
| `packages/fifty_theme/test/component_themes_test.dart` | CREATE | New comprehensive test: verify all 23 component themes use colorScheme correctly |

---

## Implementation Steps

### Phase 1: Parameterize FiftyColorScheme (color_scheme.dart)

**Goal:** `FiftyColorScheme.dark()` and `.light()` accept optional color overrides and read from AC-002 semantic getters.

**Changes to `dark()`:**

Add named parameters:
```dart
static ColorScheme dark({
  Color? primary,
  Color? onPrimary,
  Color? secondary,
  Color? tertiary,
  Color? surface,
  Color? error,
}) {
```

Replace hardcoded colors with fallback chain `parameter ?? FiftyColors.semantic`:

| Line | Current | After |
|------|---------|-------|
| 23 | `FiftyColors.burgundy` | `primary ?? FiftyColors.primary` |
| 24 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 25 | `FiftyColors.burgundy.withValues(alpha: 0.2)` | `(primary ?? FiftyColors.primary).withValues(alpha: 0.2)` |
| 26 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 29 | `FiftyColors.slateGrey` | `secondary ?? FiftyColors.secondary` |
| 30 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 31 | `FiftyColors.slateGrey.withValues(alpha: 0.2)` | `(secondary ?? FiftyColors.secondary).withValues(alpha: 0.2)` |
| 32 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 35 | `FiftyColors.hunterGreen` | `tertiary ?? FiftyColors.success` |
| 36 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 37 | `FiftyColors.hunterGreen.withValues(alpha: 0.2)` | `(tertiary ?? FiftyColors.success).withValues(alpha: 0.2)` |
| 38 | `FiftyColors.hunterGreen` | `tertiary ?? FiftyColors.success` |
| 41 | `FiftyColors.burgundy` | `error ?? FiftyColors.error` |
| 42 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 43 | `FiftyColors.burgundy.withValues(alpha: 0.2)` | `(error ?? FiftyColors.error).withValues(alpha: 0.2)` |
| 44 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 47 | `FiftyColors.darkBurgundy` | `surface ?? FiftyColors.darkBurgundy` |
| 48 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 49 | `FiftyColors.surfaceDark` | `FiftyColors.surfaceDark` (no override -- derived) |
| 50 | `FiftyColors.slateGrey` | `secondary ?? FiftyColors.secondary` |
| 53 | `FiftyColors.borderDark` | `FiftyColors.borderDark` (no override -- mode-specific) |
| 58 | `FiftyColors.darkBurgundy.withValues(alpha: 0.8)` | `(surface ?? FiftyColors.darkBurgundy).withValues(alpha: 0.8)` |
| 59 | `FiftyColors.cream` | `onPrimary ?? FiftyColors.cream` |
| 60 | `FiftyColors.darkBurgundy` | `surface ?? FiftyColors.darkBurgundy` |
| 61 | `FiftyColors.burgundy` | `primary ?? FiftyColors.primary` |

**Changes to `light()`:**

Same parameter signature. Replace similarly, noting light-mode inversions:

| Line | Current | After |
|------|---------|-------|
| 71 | `FiftyColors.burgundy` | `primary ?? FiftyColors.primary` |
| 72 | `FiftyColors.cream` | `FiftyColors.cream` (onPrimary stays cream in both modes) |
| 73 | `FiftyColors.burgundy.withValues(alpha: 0.15)` | `(primary ?? FiftyColors.primary).withValues(alpha: 0.15)` |
| 74 | `FiftyColors.burgundy` | `primary ?? FiftyColors.primary` |
| 77 | `FiftyColors.slateGrey` | `secondary ?? FiftyColors.secondary` |
| 78 | `FiftyColors.cream` | `FiftyColors.cream` |
| 79 | `FiftyColors.slateGrey.withValues(alpha: 0.2)` | `(secondary ?? FiftyColors.secondary).withValues(alpha: 0.2)` |
| 80 | `FiftyColors.darkBurgundy` | `FiftyColors.darkBurgundy` |
| 83 | `FiftyColors.hunterGreen` | `tertiary ?? FiftyColors.success` |
| 84 | `FiftyColors.cream` | `FiftyColors.cream` |
| 85 | `FiftyColors.hunterGreen.withValues(alpha: 0.15)` | `(tertiary ?? FiftyColors.success).withValues(alpha: 0.15)` |
| 86 | `FiftyColors.darkBurgundy` | `FiftyColors.darkBurgundy` |
| 89 | `FiftyColors.burgundy` | `error ?? FiftyColors.error` |
| 90 | `FiftyColors.cream` | `FiftyColors.cream` |
| 91 | `FiftyColors.burgundy.withValues(alpha: 0.15)` | `(error ?? FiftyColors.error).withValues(alpha: 0.15)` |
| 92 | `FiftyColors.burgundy` | `error ?? FiftyColors.error` |
| 95 | `FiftyColors.cream` | `surface ?? FiftyColors.cream` |
| 96 | `FiftyColors.darkBurgundy` | `FiftyColors.darkBurgundy` |
| 97 | `FiftyColors.surfaceLight` | `FiftyColors.surfaceLight` |
| 98 | `FiftyColors.slateGrey` | `secondary ?? FiftyColors.secondary` |
| 101 | `FiftyColors.borderLight` | `FiftyColors.borderLight` |
| 106 | `FiftyColors.darkBurgundy.withValues(alpha: 0.4)` | `FiftyColors.darkBurgundy.withValues(alpha: 0.4)` |
| 107 | `FiftyColors.darkBurgundy` | `FiftyColors.darkBurgundy` |
| 108 | `FiftyColors.cream` | `surface ?? FiftyColors.cream` |
| 109 | `FiftyColors.burgundy` | `primary ?? FiftyColors.primary` |

**Note:** `onPrimary` parameter is intentionally excluded. In FDL, `onPrimary` is always `cream` regardless of primary color override. If a consumer needs full control, they pass a complete `ColorScheme` to `FiftyTheme.dark(colorScheme: ...)`.

---

### Phase 2: Fix All Component Themes (component_themes.dart)

**Goal:** Replace every `FiftyColors.*` reference with the corresponding `colorScheme.*` property. Replace every `GoogleFonts.manrope(...)` with `FiftyFontResolver.resolve(...)`.

**Import changes (top of file):**
- REMOVE: `import 'package:google_fonts/google_fonts.dart';`
- ADD: `import 'package:fifty_tokens/fifty_tokens.dart';` (already present for FiftyColors -- keep for FiftyFontResolver, FiftyTypography)

Wait -- `FiftyFontResolver` is in `fifty_tokens`. Check the barrel: yes, `fifty_tokens` exports `config/font_resolver.dart`. So the existing import `package:fifty_tokens/fifty_tokens.dart` covers it. Only remove `google_fonts` import.

**Font resolver helper:**

Add a private helper at the top of the class to reduce repetition:

```dart
/// Resolves a TextStyle with the configured font.
static TextStyle _font({
  double? fontSize,
  FontWeight? fontWeight,
  double? letterSpacing,
  double? height,
  Color? color,
}) {
  return FiftyFontResolver.resolve(
    fontFamily: FiftyTypography.fontFamily,
    source: FiftyTypography.fontSource,
    baseStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    ),
  );
}
```

#### Component-by-Component Replacement Map

Below is every `FiftyColors.*` reference in `component_themes.dart` with its replacement. References are grouped by component method.

---

**1. elevatedButtonTheme (lines 18-47)**

| Line | Current | Replacement |
|------|---------|-------------|
| 21 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 22 | `FiftyColors.cream` | `colorScheme.onPrimary` |
| 31-34 | `GoogleFonts.manrope(...)` | `_font(fontSize: ..., fontWeight: ...)` |
| 38 | `FiftyColors.cream.withValues(alpha: 0.1)` | `colorScheme.onPrimary.withValues(alpha: 0.1)` |
| 41 | `FiftyColors.cream.withValues(alpha: 0.2)` | `colorScheme.onPrimary.withValues(alpha: 0.2)` |

**Semantic reasoning:** Elevated button is the primary CTA. Background = primary, foreground = onPrimary.

---

**2. outlinedButtonTheme (lines 52-92)**

| Line | Current | Replacement |
|------|---------|-------------|
| 54 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 55 | `isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `colorScheme.onSurface` |
| 69-72 | `GoogleFonts.manrope(...)` | `_font(fontSize: ..., fontWeight: ...)` |
| 77 | `const BorderSide(color: FiftyColors.burgundy)` | `BorderSide(color: colorScheme.primary)` (remove `const`) |
| 79 | `BorderSide(color: borderColor)` | `BorderSide(color: colorScheme.outline)` |
| 83 | `FiftyColors.burgundy.withValues(alpha: 0.1)` | `colorScheme.primary.withValues(alpha: 0.1)` |
| 86 | `FiftyColors.burgundy.withValues(alpha: 0.2)` | `colorScheme.primary.withValues(alpha: 0.2)` |

**Note:** Remove `isDark` variable and `borderColor`/`foregroundColor` locals -- they become unnecessary since `colorScheme.outline` and `colorScheme.onSurface` already encode brightness.

---

**3. textButtonTheme (lines 97-125)**

| Line | Current | Replacement |
|------|---------|-------------|
| 100 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 109-112 | `GoogleFonts.manrope(...)` | `_font(fontSize: ..., fontWeight: ...)` |
| 116 | `FiftyColors.burgundy.withValues(alpha: 0.1)` | `colorScheme.primary.withValues(alpha: 0.1)` |
| 119 | `FiftyColors.burgundy.withValues(alpha: 0.2)` | `colorScheme.primary.withValues(alpha: 0.2)` |

---

**4. cardTheme (lines 130-143)**

| Line | Current | Replacement |
|------|---------|-------------|
| 132 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 135 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |

**Note:** Remove `isDark` variable and `borderColor` local.

---

**5. inputDecorationTheme (lines 148-197)**

| Line | Current | Replacement |
|------|---------|-------------|
| 150 | `isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.1)` | Special: `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.1)` |
| 151 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 152 | `const hintColor = FiftyColors.slateGrey` | `final hintColor = colorScheme.onSurfaceVariant` (remove `const`) |
| 171 | `const BorderSide(color: FiftyColors.burgundy, width: 2)` | `BorderSide(color: colorScheme.primary, width: 2)` |
| 175 | `const BorderSide(color: FiftyColors.burgundy)` | `BorderSide(color: colorScheme.primary)` |
| 179 | `const BorderSide(color: FiftyColors.burgundy, width: 2)` | `BorderSide(color: colorScheme.primary, width: 2)` |
| 181-185 | `GoogleFonts.manrope(... color: hintColor)` | `_font(... color: hintColor)` |
| 186-190 | `GoogleFonts.manrope(... color: hintColor)` | `_font(... color: hintColor)` |
| 191-195 | `GoogleFonts.manrope(... color: FiftyColors.burgundy)` | `_font(... color: colorScheme.primary)` |

**Special case for fillColor (line 150):** The light mode fill uses `slateGrey` at 10% opacity, not `surfaceLight`. Map to: `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.1)`. Keep `isDark` check here because `ColorScheme` does not encode this distinction natively.

---

**6. appBarTheme (lines 202-221)**

| Line | Current | Replacement |
|------|---------|-------------|
| 206 | `isDark ? FiftyColors.darkBurgundy : FiftyColors.cream` | `colorScheme.surface` |
| 207 | `isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `colorScheme.onSurface` |
| 211-215 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |
| 217 | `color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `color: colorScheme.onSurface` |

**Note:** Remove `isDark` variable entirely from this method.

---

**7. dialogTheme (lines 226-248)**

| Line | Current | Replacement |
|------|---------|-------------|
| 228 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 231 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |
| 237-240 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |
| 242-246 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |

---

**8. snackBarTheme (lines 253-267)**

| Line | Current | Replacement |
|------|---------|-------------|
| 255 | `FiftyColors.darkBurgundy` | `colorScheme.inverseSurface` |
| 256-260 | `GoogleFonts.manrope(... color: FiftyColors.cream)` | `_font(... color: colorScheme.onInverseSurface)` |

**Reasoning:** SnackBars appear inverted (dark surface even in light mode). `inverseSurface` / `onInverseSurface` is the correct semantic mapping. This maintains the current visual: dark burgundy bg with cream text in dark mode, and correct inversion in light mode.

---

**9. dividerTheme (lines 272-279)**

| Line | Current | Replacement |
|------|---------|-------------|
| 275 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |

**Note:** Remove `isDark` variable.

---

**10. checkboxTheme (lines 284-301)**

| Line | Current | Replacement |
|------|---------|-------------|
| 286 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 291 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 295 | `WidgetStateProperty.all(FiftyColors.cream)` | `WidgetStateProperty.all(colorScheme.onPrimary)` |
| 296 | `BorderSide(color: borderColor, width: 2)` | `BorderSide(color: colorScheme.outline, width: 2)` |

---

**11. radioTheme (lines 306-318)**

| Line | Current | Replacement |
|------|---------|-------------|
| 308 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 313 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 315 | `return borderColor` | `return colorScheme.outline` |

---

**12. switchTheme (lines 323-347)**

| Line | Current | Replacement |
|------|---------|-------------|
| 325 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 330 | `FiftyColors.cream` | `colorScheme.onPrimary` |
| 332 | `FiftyColors.slateGrey` | `colorScheme.secondary` |
| 336 | `FiftyColors.slateGrey` | `colorScheme.secondary` |
| 338 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |
| 345 | `return borderColor` | `return colorScheme.outline` |

**Design note:** Switch uses `secondary` (slateGrey) for active state per v2 spec, NOT `primary`. This is intentional.

---

**13. bottomNavigationBarTheme (lines 352-372)**

| Line | Current | Replacement |
|------|---------|-------------|
| 358 | `isDark ? FiftyColors.darkBurgundy : FiftyColors.cream` | `colorScheme.surface` |
| 359 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 360 | `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` |
| 363-367 | `GoogleFonts.manrope(...)` | `_font(...)` |
| 368-371 | `GoogleFonts.manrope(...)` | `_font(...)` |

---

**14. navigationRailTheme (lines 377-397)**

| Line | Current | Replacement |
|------|---------|-------------|
| 381 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |
| 382 | `const IconThemeData(color: FiftyColors.burgundy)` | `IconThemeData(color: colorScheme.primary)` (remove `const`) |
| 383 | `const IconThemeData(color: FiftyColors.slateGrey)` | `IconThemeData(color: colorScheme.onSurfaceVariant)` |
| 384-388 | `GoogleFonts.manrope(... color: FiftyColors.burgundy)` | `_font(... color: colorScheme.primary)` |
| 389-393 | `GoogleFonts.manrope(... color: FiftyColors.slateGrey)` | `_font(... color: colorScheme.onSurfaceVariant)` |
| 395 | `FiftyColors.burgundy.withValues(alpha: 0.15)` | `colorScheme.primary.withValues(alpha: 0.15)` |

---

**15. tabBarTheme (lines 402-419)**

| Line | Current | Replacement |
|------|---------|-------------|
| 406 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 407 | `isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `colorScheme.onSurface` |
| 408 | `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` |
| 410-413 | `GoogleFonts.manrope(...)` | `_font(...)` |
| 414-417 | `GoogleFonts.manrope(...)` | `_font(...)` |

---

**16. floatingActionButtonTheme (lines 424-438)**

| Line | Current | Replacement |
|------|---------|-------------|
| 428 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 429 | `FiftyColors.cream` | `colorScheme.onPrimary` |

---

**17. chipTheme (lines 443-470)**

| Line | Current | Replacement |
|------|---------|-------------|
| 445 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 448 | `isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.1)` | `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.1)` |
| 449 | `FiftyColors.burgundy.withValues(alpha: 0.15)` | `colorScheme.primary.withValues(alpha: 0.15)` |
| 450 | `FiftyColors.slateGrey.withValues(alpha: 0.05)` | `colorScheme.secondary.withValues(alpha: 0.05)` |
| 451-455 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |
| 456-460 | `GoogleFonts.manrope(... color: FiftyColors.slateGrey)` | `_font(... color: colorScheme.onSurfaceVariant)` |

**Note:** Keep `isDark` for chipTheme `backgroundColor` because the light-mode chip uses a tinted secondary, not `surfaceContainerHighest`.

---

**18. progressIndicatorTheme (lines 475-485)**

| Line | Current | Replacement |
|------|---------|-------------|
| 481 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 482 | `isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2)` | `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.2)` |
| 483 | `isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2)` | `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.2)` |

---

**19. sliderTheme (lines 490-505)**

| Line | Current | Replacement |
|------|---------|-------------|
| 494 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 495 | `isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2)` | `isDark ? colorScheme.surfaceContainerHighest : colorScheme.secondary.withValues(alpha: 0.2)` |
| 496 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 497 | `FiftyColors.burgundy.withValues(alpha: 0.2)` | `colorScheme.primary.withValues(alpha: 0.2)` |
| 498 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 499-503 | `GoogleFonts.manrope(... color: FiftyColors.cream)` | `_font(... color: colorScheme.onPrimary)` |

---

**20. tooltipTheme (lines 510-526)**

| Line | Current | Replacement |
|------|---------|-------------|
| 513 | `FiftyColors.darkBurgundy` | `colorScheme.inverseSurface` |
| 516-520 | `GoogleFonts.manrope(... color: FiftyColors.cream)` | `_font(... color: colorScheme.onInverseSurface)` |

**Reasoning:** Tooltips, like snackbars, appear inverted against the current surface.

---

**21. popupMenuTheme (lines 531-548)**

| Line | Current | Replacement |
|------|---------|-------------|
| 533 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 536 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |
| 542-546 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |

---

**22. dropdownMenuTheme (lines 553-572)**

| Line | Current | Replacement |
|------|---------|-------------|
| 555 | `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` | `colorScheme.outline` |
| 561 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |

**Note:** This method delegates `inputDecorationTheme(colorScheme)` internally -- that call is already correct (same method, already fixed above).

---

**23. bottomSheetTheme (lines 577-591)**

| Line | Current | Replacement |
|------|---------|-------------|
| 581 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |
| 588 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |

---

**24. drawerTheme (lines 596-604)**

| Line | Current | Replacement |
|------|---------|-------------|
| 600 | `isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` |

---

**25. listTileTheme (lines 609-636)**

| Line | Current | Replacement |
|------|---------|-------------|
| 614 | `FiftyColors.burgundy.withValues(alpha: 0.1)` | `colorScheme.primary.withValues(alpha: 0.1)` |
| 615 | `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` |
| 616 | `FiftyColors.burgundy` | `colorScheme.primary` |
| 617 | `isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `colorScheme.onSurface` |
| 625-629 | `GoogleFonts.manrope(... color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy)` | `_font(... color: colorScheme.onSurface)` |
| 630-634 | `GoogleFonts.manrope(... color: FiftyColors.slateGrey)` | `_font(... color: colorScheme.onSurfaceVariant)` |

---

**26. iconTheme (lines 641-648)**

| Line | Current | Replacement |
|------|---------|-------------|
| 645 | `isDark ? FiftyColors.cream : FiftyColors.darkBurgundy` | `colorScheme.onSurface` |

---

**27. scrollbarTheme (lines 653-662)**

| Line | Current | Replacement |
|------|---------|-------------|
| 656 | `FiftyColors.slateGrey.withValues(alpha: 0.5)` | `colorScheme.onSurfaceVariant.withValues(alpha: 0.5)` |

---

**Summary of `const` removals in component_themes.dart:**

Several places currently use `const` with `FiftyColors.*` (which were previously `static const`). After AC-002, `FiftyColors.*` became getters, so `const` was already removed at the tokens level. However, within component_themes.dart, references like `const BorderSide(color: FiftyColors.burgundy)` need `const` removed since `colorScheme.primary` is not a compile-time constant. Places affected:
- Line 77: `const BorderSide(color: FiftyColors.burgundy)` -- remove `const`
- Line 152: `const hintColor = FiftyColors.slateGrey` -- change to `final`
- Line 171, 175, 179: `const BorderSide(color: FiftyColors.burgundy, ...)` -- remove `const`
- Lines 382-383: `const IconThemeData(color: FiftyColors.burgundy)` / `const IconThemeData(color: FiftyColors.slateGrey)` -- remove `const`

---

### Phase 3: Consolidate Light Theme (fifty_theme_data.dart)

**Goal:** Replace 18 inlined component theme definitions in `FiftyTheme.light()` with `FiftyComponentThemes.*()` calls (matching `dark()`'s pattern).

The `dark()` method already delegates all 23 component themes to `FiftyComponentThemes.*()`. The `light()` method inlines 18 of them. After Phase 2, `FiftyComponentThemes` methods will use `colorScheme.*` instead of `FiftyColors.*`, so they will produce correct output for both light and dark `ColorScheme` instances automatically.

**Replace these inlined blocks with FiftyComponentThemes calls:**

| Component | Lines in light() | Replace With |
|-----------|------------------|--------------|
| appBarTheme | 136-151 | `FiftyComponentThemes.appBarTheme(colorScheme)` |
| cardTheme | 155-163 | `FiftyComponentThemes.cardTheme(colorScheme)` |
| inputDecorationTheme | 164-206 | `FiftyComponentThemes.inputDecorationTheme(colorScheme)` |
| dialogTheme | 207-224 | `FiftyComponentThemes.dialogTheme(colorScheme)` |
| snackBarTheme | 225-237 | `FiftyComponentThemes.snackBarTheme(colorScheme)` |
| dividerTheme | 238-242 | `FiftyComponentThemes.dividerTheme(colorScheme)` |
| bottomNavigationBarTheme | 246-260 | `FiftyComponentThemes.bottomNavigationBarTheme(colorScheme)` |
| navigationRailTheme | 261-277 | `FiftyComponentThemes.navigationRailTheme(colorScheme)` |
| chipTheme | 281-303 | `FiftyComponentThemes.chipTheme(colorScheme)` |
| progressIndicatorTheme | 304-308 | `FiftyComponentThemes.progressIndicatorTheme(colorScheme)` |
| tooltipTheme | 310-324 | `FiftyComponentThemes.tooltipTheme(colorScheme)` |
| popupMenuTheme | 325-337 | `FiftyComponentThemes.popupMenuTheme(colorScheme)` |
| dropdownMenuTheme | 338-349 | `FiftyComponentThemes.dropdownMenuTheme(colorScheme)` |
| bottomSheetTheme | 350-360 | `FiftyComponentThemes.bottomSheetTheme(colorScheme)` |
| drawerTheme | 361-365 | `FiftyComponentThemes.drawerTheme(colorScheme)` |
| listTileTheme | 366-389 | `FiftyComponentThemes.listTileTheme(colorScheme)` |
| iconTheme | 390-393 | `FiftyComponentThemes.iconTheme(colorScheme)` |
| scrollbarTheme | 394-401 | `FiftyComponentThemes.scrollbarTheme(colorScheme)` |

**After this, `light()` will mirror `dark()` structurally:** build `colorScheme`, build `textTheme`, construct `ThemeData` with all component themes delegated.

Also in this phase, update the remaining `FiftyColors.*` references in `fifty_theme_data.dart`:

| Line | Current | Replacement |
|------|---------|-------------|
| 55 (dark) | `scaffoldBackgroundColor: FiftyColors.darkBurgundy` | `scaffoldBackgroundColor: colorScheme.surface` |
| 56 (dark) | `canvasColor: FiftyColors.darkBurgundy` | `canvasColor: colorScheme.surface` |
| 57 (dark) | `cardColor: FiftyColors.surfaceDark` | `cardColor: colorScheme.surfaceContainerHighest` |
| 62 (dark) | `fontFamily: GoogleFonts.manrope().fontFamily` | `fontFamily: FiftyFontResolver.resolveFamilyName(fontFamily: FiftyTypography.fontFamily, source: FiftyTypography.fontSource)` |
| 124 (light) | `scaffoldBackgroundColor: FiftyColors.cream` | `scaffoldBackgroundColor: colorScheme.surface` |
| 125 (light) | `canvasColor: FiftyColors.cream` | `canvasColor: colorScheme.surface` |
| 126 (light) | `cardColor: FiftyColors.surfaceLight` | `cardColor: colorScheme.surfaceContainerHighest` |
| 131 (light) | `fontFamily: GoogleFonts.manrope().fontFamily` | `fontFamily: FiftyFontResolver.resolveFamilyName(fontFamily: FiftyTypography.fontFamily, source: FiftyTypography.fontSource)` |

**Import changes for fifty_theme_data.dart:**
- REMOVE: `import 'package:google_fonts/google_fonts.dart';`
- The existing `import 'package:fifty_tokens/fifty_tokens.dart';` covers `FiftyFontResolver` and `FiftyTypography`.

---

### Phase 4: Parameterize FiftyTheme.dark() and .light() (fifty_theme_data.dart)

**Goal:** Accept optional parameters for quick theme customization.

**New signature for both `dark()` and `light()`:**

```dart
static ThemeData dark({
  ColorScheme? colorScheme,
  Color? primaryColor,
  Color? secondaryColor,
  String? fontFamily,
  FontSource? fontSource,
  FiftyThemeExtension? extension,
}) {
  final scheme = colorScheme ?? FiftyColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
  );

  final resolvedFontFamily = fontFamily ?? FiftyTypography.fontFamily;
  final resolvedFontSource = fontSource ?? FiftyTypography.fontSource;

  final textTheme = FiftyTextTheme.textTheme(
    fontFamily: resolvedFontFamily,
    fontSource: resolvedFontSource,
  );

  return ThemeData(
    colorScheme: scheme,
    fontFamily: FiftyFontResolver.resolveFamilyName(
      fontFamily: resolvedFontFamily,
      source: resolvedFontSource,
    ),
    // ... component themes using scheme ...
    extensions: [
      extension ?? FiftyThemeExtension.dark(),
    ],
  );
}
```

**Priority logic:**
1. If `colorScheme` is provided, use it directly (Level 3 override). `primaryColor`/`secondaryColor` are ignored.
2. If `primaryColor`/`secondaryColor` are provided (but not `colorScheme`), pass them to `FiftyColorScheme.dark(primary: ..., secondary: ...)` (Level 2 override).
3. If nothing is provided, `FiftyColorScheme.dark()` reads from `FiftyColors.*` getters which may have been configured via `FiftyTokens.configure()` (Level 1 override).
4. If nothing is configured anywhere, FDL defaults apply (Level 0).

**Important:** When `colorScheme` is provided by the consumer, we must also pass it to the component themes. This is already handled because all `FiftyComponentThemes.*()` calls receive `scheme` as their argument.

---

### Phase 5: Parameterize FiftyThemeExtension (theme_extensions.dart)

**Goal:** `FiftyThemeExtension.dark()` and `.light()` accept optional semantic color overrides.

**New signatures:**

```dart
factory FiftyThemeExtension.dark({
  Color? accent,
  Color? success,
  Color? warning,
  Color? info,
}) {
  return FiftyThemeExtension(
    accent: accent ?? FiftyColors.powderBlush,
    success: success ?? FiftyColors.success,
    warning: warning ?? FiftyColors.warning,
    info: info ?? FiftyColors.secondary,
    // shadows and motion from token getters (unchanged)
    shadowSm: FiftyShadows.sm,
    shadowMd: FiftyShadows.md,
    shadowLg: FiftyShadows.lg,
    shadowPrimary: FiftyShadows.primary,
    shadowGlow: FiftyShadows.glow,
    instant: FiftyMotion.instant,
    fast: FiftyMotion.fast,
    compiling: FiftyMotion.compiling,
    systemLoad: FiftyMotion.systemLoad,
    standardCurve: FiftyMotion.standard,
    enterCurve: FiftyMotion.enter,
    exitCurve: FiftyMotion.exit,
  );
}
```

```dart
factory FiftyThemeExtension.light({
  Color? accent,
  Color? success,
  Color? warning,
  Color? info,
}) {
  return FiftyThemeExtension(
    accent: accent ?? FiftyColors.primary,  // Light mode accent = primary
    success: success ?? FiftyColors.success,
    warning: warning ?? FiftyColors.warning,
    info: info ?? FiftyColors.secondary,
    // shadows and motion from token getters (unchanged)
    shadowSm: FiftyShadows.sm,
    shadowMd: FiftyShadows.md,
    shadowLg: FiftyShadows.lg,
    shadowPrimary: FiftyShadows.primary,
    shadowGlow: FiftyShadows.none,
    instant: FiftyMotion.instant,
    fast: FiftyMotion.fast,
    compiling: FiftyMotion.compiling,
    systemLoad: FiftyMotion.systemLoad,
    standardCurve: FiftyMotion.standard,
    enterCurve: FiftyMotion.enter,
    exitCurve: FiftyMotion.exit,
  );
}
```

**Key changes:**
- `dark()` accent defaults to `FiftyColors.powderBlush` (unchanged behavior)
- `light()` accent changes from `FiftyColors.burgundy` to `FiftyColors.primary` (so it cascades from token config)
- `success` uses `FiftyColors.success` instead of `FiftyColors.hunterGreen` (alias, same value)
- `warning` uses `FiftyColors.warning` (already correct)
- `info` uses `FiftyColors.secondary` instead of `FiftyColors.slateGrey` (alias, same value)

---

### Phase 6: Update FiftyTextTheme (text_theme.dart)

**Goal:** Replace all 15 `GoogleFonts.manrope(...)` calls with `FiftyFontResolver.resolve(...)`.

**Add optional parameters to `textTheme()`:**

```dart
static TextTheme textTheme({
  String? fontFamily,
  FontSource? fontSource,
}) {
  final family = fontFamily ?? FiftyTypography.fontFamily;
  final source = fontSource ?? FiftyTypography.fontSource;

  TextStyle _resolve({
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return FiftyFontResolver.resolve(
      fontFamily: family,
      source: source,
      baseStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }

  return TextTheme(
    displayLarge: _resolve(
      fontSize: FiftyTypography.displayLarge,
      fontWeight: FiftyTypography.extraBold,
      letterSpacing: FiftyTypography.letterSpacingDisplay,
      height: FiftyTypography.lineHeightDisplay,
    ),
    // ... 14 more styles ...
  );
}
```

**All 15 replacements:**

| Style | Current | After |
|-------|---------|-------|
| displayLarge | `GoogleFonts.manrope(fontSize: ..., fontWeight: ..., letterSpacing: ..., height: ...)` | `_resolve(fontSize: ..., fontWeight: ..., letterSpacing: ..., height: ...)` |
| displayMedium | same pattern | same replacement |
| displaySmall | same pattern | same replacement |
| headlineLarge | same pattern | same replacement |
| headlineMedium | same pattern | same replacement |
| headlineSmall | same pattern | same replacement |
| titleLarge | same pattern | same replacement |
| titleMedium | same pattern | same replacement |
| titleSmall | same pattern | same replacement |
| bodyLarge | same pattern | same replacement |
| bodyMedium | same pattern | same replacement |
| bodySmall | same pattern | same replacement |
| labelLarge | same pattern | same replacement |
| labelMedium | same pattern | same replacement |
| labelSmall | same pattern | same replacement |

**Import changes:**
- REMOVE: `import 'package:google_fonts/google_fonts.dart';`
- ADD: nothing (already imports `package:fifty_tokens/fifty_tokens.dart` which exports `FiftyFontResolver` and `FontSource`)

Wait -- check the current imports. Line 1: `import 'package:fifty_tokens/fifty_tokens.dart';` -- yes, already present. Line 3: `import 'package:google_fonts/google_fonts.dart';` -- remove this.

---

### Phase 7: Update and Write Tests

#### 7.1 Update existing tests

**color_scheme_test.dart:**
- Add group: `dark() with overrides` -- test that `FiftyColorScheme.dark(primary: Colors.blue)` produces `colorScheme.primary == Colors.blue`
- Add group: `dark() with token configuration` -- configure `FiftyTokens.configure(colors: FiftyColorConfig(primary: Colors.blue))`, verify `FiftyColorScheme.dark().primary == Colors.blue`, then `FiftyTokens.reset()` in tearDown
- Add test: verify backward compat -- `FiftyColorScheme.dark()` with no args still produces FDL defaults
- Same pattern for `light()` group

**fifty_theme_test.dart:**
- Add test: `FiftyTheme.dark(primaryColor: Colors.blue)` -- verify `theme.colorScheme.primary == Colors.blue`
- Add test: `FiftyTheme.dark(colorScheme: customScheme)` -- verify full scheme is used
- Add test: `FiftyTheme.dark()` backward compat -- existing tests already cover this but verify scaffoldBackgroundColor, etc.
- Add test: `FiftyTheme.dark(fontFamily: 'Inter', fontSource: FontSource.asset)` -- verify fontFamily is 'Inter'
- Add test: `FiftyTheme.dark(extension: customExtension)` -- verify extension is attached

**theme_extensions_test.dart:**
- Add test: `FiftyThemeExtension.dark(accent: Colors.blue)` -- verify accent == Colors.blue
- Add test: `FiftyThemeExtension.dark(success: Colors.green, warning: Colors.yellow)` -- verify overrides
- Add test: `FiftyThemeExtension.dark()` -- backward compat, verify defaults unchanged

**text_theme_test.dart:**
- Add test: `FiftyTextTheme.textTheme(fontFamily: 'Inter', fontSource: FontSource.asset)` -- verify fontFamily is 'Inter' on each style
- Existing tests should continue to pass with default args

#### 7.2 Create new test file

**component_themes_test.dart** (NEW):

This is the critical new test file. It verifies that all 23 component themes correctly use `colorScheme.*` instead of hardcoded values.

**Test strategy:** Create a custom `ColorScheme` with distinctly different colors (e.g., `primary: Colors.purple`, `secondary: Colors.teal`, etc.) and verify that each component theme produces output using those colors, not FDL defaults.

```dart
group('FiftyComponentThemes with custom ColorScheme', () {
  late ColorScheme customScheme;

  setUp(() {
    customScheme = const ColorScheme.dark(
      primary: Colors.purple,
      onPrimary: Colors.white,
      secondary: Colors.teal,
      onSecondary: Colors.white,
      surface: Colors.grey,
      onSurface: Colors.white,
      // ... etc
    );
  });

  test('elevatedButtonTheme uses colorScheme.primary', () {
    final theme = FiftyComponentThemes.elevatedButtonTheme(customScheme);
    final style = theme.style!;
    // Verify backgroundColor resolves to Colors.purple
  });

  // ... one test per component ...
});
```

**Tests to write (one per component):**
1. elevatedButtonTheme -- bg is primary, fg is onPrimary
2. outlinedButtonTheme -- hover border is primary, fg is onSurface
3. textButtonTheme -- fg is primary
4. cardTheme -- color is surfaceContainerHighest, border is outline
5. inputDecorationTheme -- focus border is primary, hint is onSurfaceVariant
6. appBarTheme -- bg is surface, fg is onSurface
7. dialogTheme -- bg is surfaceContainerHighest, text is onSurface
8. snackBarTheme -- bg is inverseSurface, text is onInverseSurface
9. dividerTheme -- color is outline
10. checkboxTheme -- selected fill is primary, check is onPrimary
11. radioTheme -- selected fill is primary
12. switchTheme -- selected track is secondary, thumb is onPrimary
13. bottomNavigationBarTheme -- bg is surface, selected is primary
14. navigationRailTheme -- bg is surfaceContainerHighest, selected is primary
15. tabBarTheme -- indicator is primary, label is onSurface
16. floatingActionButtonTheme -- bg is primary, fg is onPrimary
17. chipTheme -- selected is primary at 0.15 alpha
18. progressIndicatorTheme -- color is primary
19. sliderTheme -- active is primary, thumb is primary
20. tooltipTheme -- bg is inverseSurface
21. popupMenuTheme -- color is surfaceContainerHighest
22. dropdownMenuTheme -- menu bg is surfaceContainerHighest
23. bottomSheetTheme -- bg is surfaceContainerHighest
24. drawerTheme -- bg is surfaceContainerHighest
25. listTileTheme -- selected is primary, text is onSurface
26. iconTheme -- color is onSurface
27. scrollbarTheme -- thumb is onSurfaceVariant at alpha

---

### Phase 8: Analyze and Verify

1. Run `flutter analyze` in `packages/fifty_theme/` -- zero issues
2. Run `flutter test` in `packages/fifty_theme/` -- all tests pass
3. Verify no `FiftyColors.*` references remain in `component_themes.dart` (grep)
4. Verify no `GoogleFonts.manrope` references remain in any source file (grep)
5. Verify no `FiftyColors.*` references remain in `fifty_theme_data.dart` (grep)
6. Run downstream package analysis (fifty_ui, fifty_forms, etc.) to verify no compile errors

---

## Mapping Summary: colorScheme Role Assignments

For reference, here is the complete semantic mapping from FDL tokens to Material ColorScheme roles:

| FDL Token | ColorScheme Property | Used For |
|-----------|---------------------|----------|
| `FiftyColors.burgundy` / `.primary` | `colorScheme.primary` | Primary CTAs, active states, focus borders, selected items |
| `FiftyColors.cream` | `colorScheme.onPrimary` | Text/icons on primary surfaces |
| `FiftyColors.darkBurgundy` | `colorScheme.surface` (dark) | Background, scaffold, canvas |
| `FiftyColors.cream` | `colorScheme.surface` (light) | Background, scaffold, canvas |
| `FiftyColors.cream` (dark on) / `.darkBurgundy` (light on) | `colorScheme.onSurface` | Primary text, icons |
| `FiftyColors.slateGrey` / `.secondary` | `colorScheme.secondary` | Switch active, disabled chip tint |
| `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` | Hint text, unselected nav items, subtitle text, scrollbar |
| `FiftyColors.hunterGreen` / `.success` | `colorScheme.tertiary` | Success states |
| `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` (dark) | Cards, dialogs, menus, nav rail, drawers |
| `FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` (light) | Cards, dialogs, menus, nav rail, drawers |
| `FiftyColors.borderDark` / `.borderLight` | `colorScheme.outline` | Borders, dividers, checkbox/radio unselected |
| `FiftyColors.darkBurgundy` | `colorScheme.inverseSurface` | SnackBar bg, tooltip bg |
| `FiftyColors.cream` | `colorScheme.onInverseSurface` | SnackBar text, tooltip text |
| `FiftyColors.burgundy` / `.error` | `colorScheme.error` | Error states |
| `FiftyColors.powderBlush` | via `FiftyThemeExtension.accent` | Dark mode accent (not in ColorScheme) |

---

## `isDark` Check Elimination Summary

After this refactoring, most `isDark` checks in component themes become unnecessary because `colorScheme.*` already encodes brightness. However, a few components retain `isDark` because the light-mode style uses a derived value that is not directly in `ColorScheme`:

| Component | Retains `isDark`? | Reason |
|-----------|-------------------|--------|
| inputDecorationTheme | YES | Light fill = `secondary.withValues(alpha: 0.1)`, dark fill = `surfaceContainerHighest` |
| chipTheme | YES | Light bg = `secondary.withValues(alpha: 0.1)`, dark bg = `surfaceContainerHighest` |
| progressIndicatorTheme | YES | Light track = `secondary.withValues(alpha: 0.2)`, dark track = `surfaceContainerHighest` |
| sliderTheme | YES | Light inactive = `secondary.withValues(alpha: 0.2)`, dark inactive = `surfaceContainerHighest` |
| All others | NO | `colorScheme.*` encodes the correct value for both modes |

---

## Testing Strategy

1. **Backward Compatibility Tests:** Call all factory methods with no arguments. Verify output matches current FDL defaults exactly. This is the MOST important test category.

2. **Override Propagation Tests:** Pass custom colors at each level:
   - Level 1: `FiftyTokens.configure()` then call `FiftyTheme.dark()` -- verify token cascades
   - Level 2: `FiftyTheme.dark(primaryColor: ...)` -- verify quick override
   - Level 3: `FiftyTheme.dark(colorScheme: ...)` -- verify full override

3. **Component Theme Isolation Tests:** For each of the 23 component themes, pass a custom ColorScheme with distinctive colors and verify the output uses those colors instead of FDL defaults.

4. **Font Resolver Tests:** Verify that `FiftyTextTheme.textTheme(fontFamily: 'Inter', fontSource: FontSource.asset)` produces TextStyles with `fontFamily == 'Inter'`.

5. **Token Reset Tests:** After calling `FiftyTokens.configure()`, verify themes reflect config. After `FiftyTokens.reset()`, verify themes return to FDL defaults.

6. **GoogleFonts Absence Verification:** Run `grep -r "GoogleFonts" packages/fifty_theme/lib/` -- expect zero matches in source files.

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Visual regression in component themes | Medium | High | Phase 7 backward compat tests verify every component produces identical output with no-arg calls |
| `const` removal cascade in downstream packages | Low | Medium | After AC-002, `FiftyColors.*` are already getters, so downstream `const` references were already fixed. Component themes are method return values, never `const` contexts. |
| `isDark` check removal introduces subtle color differences | Medium | Medium | Verify mapping table against actual FiftyColorScheme.dark()/light() output. The 4 components that retain `isDark` are the edge cases. |
| SnackBar/Tooltip `inverseSurface` mapping differs from current visual | Low | High | Current `FiftyColors.darkBurgundy` maps to `colorScheme.inverseSurface` (which is `FiftyColors.cream` in dark mode, `FiftyColors.darkBurgundy` in light mode). In dark mode, `inverseSurface` = cream, but current snackbar bg = darkBurgundy. **CORRECTION NEEDED:** Use `colorScheme.surface` for dark mode and keep separate. OR better: in `dark()` the `inverseSurface` is cream -- but snackbar should be dark. **REVISED MAPPING**: SnackBar bg should be `colorScheme.surfaceContainerHighest` (surfaceDark in dark mode, surfaceLight in light mode) NOT `inverseSurface`. Similarly for tooltip. See revised mapping below. |
| `google_fonts` import removal breaks if `FiftyFontResolver` is not exported from `fifty_tokens` barrel | Low | High | Verify `fifty_tokens` barrel exports `config/font_resolver.dart` before implementation |
| Test google_fonts errors in CI | Low | Low | Existing `_withSilencedFontErrors` pattern handles this; new tests that use `FontSource.asset` bypass GoogleFonts entirely |
| Downstream compile errors (fifty_ui, fifty_forms) | Low | Medium | These packages use `FiftyTheme.dark()` with no args -- backward compatible. They don't construct component themes directly. |

### Risk Correction: SnackBar and Tooltip Mapping

After reviewing the risk above more carefully:

In the **dark** ColorScheme:
- `inverseSurface` = `FiftyColors.cream` (light surface)
- `onInverseSurface` = `FiftyColors.darkBurgundy`

Current snackbar: `backgroundColor: FiftyColors.darkBurgundy`, `color: FiftyColors.cream`

Using `inverseSurface` would flip this (cream bg, dark text) -- **WRONG**.

**Corrected mapping for SnackBar:**
- `backgroundColor` -> `colorScheme.surfaceContainerHighest` (surfaceDark in dark, surfaceLight in light)
- `contentTextStyle.color` -> `colorScheme.onSurface`

Wait, but current SnackBar uses `darkBurgundy` (the main background color) not `surfaceDark` (the elevated surface). Let me reconsider.

In dark mode: `surface` = `darkBurgundy`, `surfaceContainerHighest` = `surfaceDark`.

Current snackbar bg = `darkBurgundy` = `colorScheme.surface`. But the snackbar should stand out from the background. Using `colorScheme.surface` would make it the same as the scaffold bg.

**BEST mapping:** Keep brightness-independent behavior. SnackBar always shows as "inverse" surface. But `inverseSurface` maps incorrectly.

**FINAL DECISION:** Use `colorScheme.onSurface` for snackbar background (in dark mode: cream; in light mode: darkBurgundy). Wait, that also doesn't match.

Let me re-examine. Current behavior:
- Dark mode snackbar: bg = darkBurgundy (#1A0D0E), text = cream
- Light mode snackbar: bg = darkBurgundy (#1A0D0E), text = cream

SnackBar uses the SAME colors in both modes -- always dark bg with light text. This is a design choice: snackbars are always "dark style" regardless of theme.

**CORRECT mapping:** Since SnackBar is always dark-styled:
- bg -> `colorScheme.inverseSurface` -- In dark mode, `inverseSurface` = cream (WRONG!)

Actually, let me look at this differently. The snackbar is always dark. In dark mode, the bg is the same as scaffold. In light mode, it contrasts.

**REVISED FINAL DECISION for SnackBar:**
- The snackbar bg should just be the `surface` color from a **dark** scheme regardless of current mode. Since we can't know which mode we're in from `colorScheme` alone... Actually we CAN: `colorScheme.brightness`.
- Best approach: keep the snackbar mapping as `isDark ? colorScheme.surface : colorScheme.inverseSurface` with text `isDark ? colorScheme.onSurface : colorScheme.onInverseSurface`.

BUT the whole point is to REMOVE `isDark` checks. The truth is Material Design's snackbar convention IS `inverseSurface`/`onInverseSurface`. The FDL deviates from this in dark mode by making the snackbar match the background.

**PRAGMATIC DECISION:** Map snackbar to:
- bg: `colorScheme.surfaceContainerHighest` -- this is `surfaceDark` (#2A1517) in dark mode (slightly lighter than bg, so it stands out) and `surfaceLight` (#FAF9DE) in light mode. But the current light-mode snackbar uses darkBurgundy, not surfaceLight.

This is getting circular. Let me just make the **simplest correct choice** that preserves visual parity:

For **SnackBar** -- retain explicit mapping:
```dart
static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
  return SnackBarThemeData(
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: _font(
      fontSize: FiftyTypography.bodyMedium,
      fontWeight: FiftyTypography.regular,
      color: colorScheme.onInverseSurface,
    ),
    ...
  );
}
```

In dark mode: `inverseSurface` = cream, `onInverseSurface` = darkBurgundy. This flips the current colors (currently: dark bg + cream text). This IS a visual change.

**RESOLUTION:** Since the current SnackBar intentionally uses the same dark styling in both modes (a deliberate FDL design choice), and `ColorScheme` doesn't have a clean way to encode "always dark", we have two options:

1. **Accept the visual change** -- use `inverseSurface`/`onInverseSurface`, which follows Material convention
2. **Keep hardcoded** -- but this contradicts AC-003's goal

**Recommendation: Option 1** -- use `inverseSurface`/`onInverseSurface`. This is the Material standard. The dark-mode snackbar will now be cream-background with dark text, which is actually better UX (snackbar CONTRASTS with background). If the user overrides colors, the snackbar automatically adapts. Mark this as a deliberate design improvement in the PR description.

**SAME applies to Tooltip** -- use `inverseSurface`/`onInverseSurface`.

**UPDATE to Phase 2 snackbar/tooltip entries:** The mappings in the component-by-component section above are already correct (`inverseSurface`/`onInverseSurface`). The risk is acknowledged and accepted as a design improvement.

---

## Execution Order

```
Phase 1 (color_scheme.dart)       -- Foundation: parameterize ColorScheme builders
    |
Phase 2 (component_themes.dart)   -- Bulk work: fix all 91 FiftyColors refs + 23 GoogleFonts refs
    |
Phase 3 (fifty_theme_data.dart)   -- Consolidate: remove 18 inlined blocks, fix scaffold/canvas/card colors
    |
Phase 4 (fifty_theme_data.dart)   -- Parameterize: add optional params to dark()/light()
    |
Phase 5 (theme_extensions.dart)   -- Parameterize: add optional params to extension factories
    |
Phase 6 (text_theme.dart)         -- Font resolver: replace 15 GoogleFonts calls
    |
Phase 7 (test files)              -- Tests: backward compat + override propagation + component isolation
    |
Phase 8 (verification)            -- Analyze + grep verification + downstream check
```

Phases 1-6 can potentially be done in 2-3 sessions. Phase 7 is the largest test effort. Phase 8 is verification.

---

## Reference Counts

| File | FiftyColors.* refs | GoogleFonts.manrope refs | Total changes |
|------|-------------------|------------------------|---------------|
| component_themes.dart | 91 | 23 | 114 |
| fifty_theme_data.dart | 64 | 19 | 83 |
| color_scheme.dart | 30 | 0 | 30 |
| theme_extensions.dart | 6 | 0 | 6 |
| text_theme.dart | 0 | 15 | 15 |
| **Total** | **191** | **57** | **248** |

After this brief, `fifty_theme/lib/src/` will have:
- **ZERO** `FiftyColors.*` references (all via `colorScheme.*` or parameter fallback)
- **ZERO** `GoogleFonts.manrope` references (all via `FiftyFontResolver`)
- **ZERO** `import 'package:google_fonts/google_fonts.dart'` in source files

Note: `google_fonts` remains a dependency in `pubspec.yaml` because `FiftyFontResolver.resolve()` calls `GoogleFonts.getFont()` internally (the dependency is now transitive via `fifty_tokens`). However, `fifty_theme` source files no longer import it directly.

Wait -- actually `FiftyFontResolver` is in `fifty_tokens` which depends on `google_fonts`. So `fifty_theme` imports `FiftyFontResolver` via `fifty_tokens`, and `fifty_tokens` depends on `google_fonts`. But `fifty_theme` also has `google_fonts: ^8.0.0` in its own `pubspec.yaml`. After this change, `fifty_theme` no longer directly imports `google_fonts` in its source files, but it still needs the `google_fonts` dependency because `FiftyFontResolver` (from `fifty_tokens`) uses it at runtime. The dependency is transitively pulled in via `fifty_tokens`, so `fifty_theme` could potentially REMOVE `google_fonts` from its own `pubspec.yaml` and rely on the transitive dependency. However, this is a separate cleanup and out of scope for AC-003. Leave the dependency for now.
