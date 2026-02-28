# AC-003: fifty_theme — Parameterization

**Type:** Architecture Cleanup
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-02-28
**Parent:** AC-001 (Theme Customization System)
**Blocked By:** AC-002 (fifty_tokens configuration)

---

## Architecture Issue

**What's the problem?**

- [x] Logical inconsistency (component themes receive `ColorScheme` parameter but hardcode `FiftyColors.*` instead)
- [x] Poor separation of concerns (theme builders bypass the color system they're supposed to use)

**Where is it?**

4 files in `packages/fifty_theme/lib/src/`:
- `fifty_theme_data.dart` — `FiftyTheme.dark()`/`.light()` accept zero parameters
- `color_scheme.dart` — hardcodes all 22 ColorScheme slots to `FiftyColors.*`
- `component_themes.dart` (664 lines) — 23 builders with 45+ hardcoded `FiftyColors.*` refs
- `theme_extensions.dart` — `FiftyThemeExtension.dark()`/`.light()` hardcoded

---

## Current State

```dart
// CURRENT: FiftyTheme.dark() accepts nothing
static ThemeData dark() {
  final colorScheme = FiftyColorScheme.dark(); // Hardcoded burgundy
  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: FiftyColors.darkBurgundy, // Hardcoded
    // ...
  );
}

// CURRENT: Component theme IGNORES the colorScheme it receives
static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: FiftyColors.burgundy,  // IGNORES colorScheme!
      foregroundColor: FiftyColors.cream,      // IGNORES colorScheme!
    ),
  );
}
```

100+ places where component themes hardcode `FiftyColors.*` instead of using `colorScheme.*`.

---

## Goal

After this brief:

```dart
// AFTER: FiftyTheme accepts optional overrides
static ThemeData dark({
  ColorScheme? colorScheme,
  Color? primaryColor,
  Color? secondaryColor,
  String? fontFamily,
  FontSource? fontSource,
  FiftyThemeExtension? extension,
}) {
  // Build ColorScheme from configured tokens (AC-002) or explicit override
  final scheme = colorScheme ?? FiftyColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  // ...
}

// AFTER: Component theme USES colorScheme
static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,     // USES colorScheme
      foregroundColor: colorScheme.onPrimary,    // USES colorScheme
    ),
  );
}
```

**Three levels of consumer customization:**

```dart
// Level 1: Configure tokens (AC-002) — theme auto-follows
FiftyTokens.configure(colors: FiftyColorConfig(primary: Colors.blue));
theme: FiftyTheme.dark(), // Blue theme automatically

// Level 2: Quick override at theme level
theme: FiftyTheme.dark(primaryColor: Colors.blue),

// Level 3: Full ColorScheme override
theme: FiftyTheme.dark(colorScheme: myCustomColorScheme),

// Level 4: Bring your own theme (fifty_ui still works via Theme.of)
theme: myEntirelyCustomTheme,
```

---

## Cleanup Approach

### Phase 1: ColorScheme Reads From Tokens

`FiftyColorScheme.dark()` and `.light()` should read from (potentially configured) `FiftyColors` getters, plus accept optional overrides:

```dart
static ColorScheme dark({
  Color? primary,
  Color? secondary,
  Color? tertiary,
  Color? surface,
  Color? error,
}) => ColorScheme(
  brightness: Brightness.dark,
  primary: primary ?? FiftyColors.primary,           // Reads from token getter
  secondary: secondary ?? FiftyColors.secondary,     // Reads from token getter
  tertiary: tertiary ?? FiftyColors.success,         // Reads from token getter
  surface: surface ?? FiftyColors.surfaceDark,       // Reads from token getter
  error: error ?? FiftyColors.error,                 // Reads from token getter
  // ...
);
```

### Phase 2: Component Themes Use ColorScheme

Systematic replacement across all 23 component theme builders:

| Component | Current (hardcoded) | After (colorScheme) |
|-----------|--------------------|--------------------|
| ElevatedButton bg | `FiftyColors.burgundy` | `colorScheme.primary` |
| ElevatedButton fg | `FiftyColors.cream` | `colorScheme.onPrimary` |
| TextButton fg | `FiftyColors.burgundy` | `colorScheme.primary` |
| Checkbox fill | `FiftyColors.burgundy` | `colorScheme.primary` |
| Radio fill | `FiftyColors.burgundy` | `colorScheme.primary` |
| Switch track | `FiftyColors.slateGrey` | `colorScheme.secondary` |
| TabBar indicator | `FiftyColors.burgundy` | `colorScheme.primary` |
| FAB bg | `FiftyColors.burgundy` | `colorScheme.primary` |
| FAB fg | `FiftyColors.cream` | `colorScheme.onPrimary` |
| Slider active | `FiftyColors.burgundy` | `colorScheme.primary` |
| Tooltip bg | `FiftyColors.darkBurgundy` | `colorScheme.surfaceContainerHighest` |
| SnackBar bg | `FiftyColors.darkBurgundy` | `colorScheme.surfaceContainerHighest` |
| Input focus | `FiftyColors.burgundy` | `colorScheme.primary` |
| BottomNav selected | `FiftyColors.burgundy` | `colorScheme.primary` |
| NavRail selected | `FiftyColors.burgundy` | `colorScheme.primary` |
| ProgressIndicator | `FiftyColors.burgundy` | `colorScheme.primary` |
| ListTile selected | `FiftyColors.burgundy` | `colorScheme.primary` |
| Chip selected bg | `FiftyColors.burgundy` | `colorScheme.primary` |

### Phase 3: FiftyTheme Accepts Parameters

Add optional parameters to `FiftyTheme.dark()` and `.light()` for quick overrides without needing to construct a full `ColorScheme`.

### Phase 4: FiftyThemeExtension Configuration

```dart
// Allow consumer to pass custom extension, or build from tokens
static FiftyThemeExtension dark({
  Color? accent,
  Color? success,
  Color? warning,
  Color? info,
}) => FiftyThemeExtension(
  accent: accent ?? FiftyColors.powderBlush,
  success: success ?? FiftyColors.success,
  warning: warning ?? FiftyColors.warning,
  info: info ?? FiftyColors.secondary,
  // shadows + motion read from token getters
  shadowSm: FiftyShadows.sm,
  shadowMd: FiftyShadows.md,
  // ...
);
```

### Phase 5: Text Theme Uses Font Resolver

`FiftyTextTheme` should use `FiftyFontResolver` (from AC-002) to generate TextTheme with configured font:

```dart
static TextTheme textTheme() {
  final fontFamily = FiftyTypography.fontFamily;
  final source = FiftyTypography.fontSource;

  TextStyle base(double size, FontWeight weight, double letterSpacing, double height) {
    final style = TextStyle(
      fontSize: size, fontWeight: weight,
      letterSpacing: letterSpacing, height: height,
    );
    return FiftyFontResolver.resolve(
      fontFamily: fontFamily, source: source, baseStyle: style,
    );
  }

  return TextTheme(
    displayLarge: base(FiftyTypography.displayLarge, FiftyTypography.bold, ...),
    // ...
  );
}
```

---

## Constraints

### Architecture Rules
- Component themes MUST use `colorScheme.*` for all color values
- `FiftyColors.*` references in component themes are FORBIDDEN after this brief
- Theme methods accept optional parameters with FDL defaults
- Backward compatible: `FiftyTheme.dark()` with no args still produces FDL theme

### Out of Scope
- Adding new component themes
- Redesigning the component theme builder architecture
- Theme animation/transition support

---

## Tasks

### Pending

### In Progress

### Completed
- [x] Task 1: Add optional parameters to `FiftyColorScheme.dark()` and `.light()`
- [x] Task 2: Make ColorScheme read from FiftyColors getters (configured tokens)
- [x] Task 3: Fix `elevatedButtonTheme` — use `colorScheme.primary/onPrimary`
- [x] Task 4: Fix `outlinedButtonTheme` — use `colorScheme.primary` for focus
- [x] Task 5: Fix `textButtonTheme` — use `colorScheme.primary`
- [x] Task 6: Fix `inputDecorationTheme` — use `colorScheme.primary` for focus
- [x] Task 7: Fix `checkboxTheme` — use `colorScheme.primary`
- [x] Task 8: Fix `radioTheme` — use `colorScheme.primary`
- [x] Task 9: Fix `switchTheme` — use `colorScheme.secondary`
- [x] Task 10: Fix `tabBarTheme` — use `colorScheme.primary`
- [x] Task 11: Fix `floatingActionButtonTheme` — use `colorScheme.primary/onPrimary`
- [x] Task 12: Fix `sliderTheme` — use `colorScheme.primary`
- [x] Task 13: Fix `tooltipTheme` — use `colorScheme.inverseSurface`
- [x] Task 14: Fix `snackBarTheme` — use `colorScheme.inverseSurface`
- [x] Task 15: Fix `bottomNavigationBarTheme` — use `colorScheme.primary`
- [x] Task 16: Fix `navigationRailTheme` — use `colorScheme.primary`
- [x] Task 17: Fix `progressIndicatorTheme` — use `colorScheme.primary`
- [x] Task 18: Fix `listTileTheme` — use `colorScheme.primary`
- [x] Task 19: Fix `chipTheme` — use `colorScheme.primary`
- [x] Task 20: Fix remaining component themes (scrollbar, popup, dropdown, bottomSheet, drawer, icon)
- [x] Task 21: Add optional parameters to `FiftyTheme.dark()` and `.light()`
- [x] Task 22: Parameterize `FiftyThemeExtension.dark()` and `.light()`
- [x] Task 23: Update `FiftyTextTheme` to use `FiftyFontResolver` from AC-002
- [x] Task 24: Update `fifty_theme_data.dart` — scaffold/canvas/card colors from getters
- [x] Task 25: Write tests — custom ColorScheme propagation through all component themes
- [x] Task 26: Write tests — FiftyTheme.dark(primaryColor: blue) produces blue theme
- [x] Task 27: Write tests — FiftyTheme.dark() with no args still produces FDL theme
- [x] Task 28: Run `flutter analyze` — zero issues

---

## Session State (Tactical - This Brief)

**Current State:** Done — All 28 tasks completed
**Next Steps When Resuming:** N/A — Brief complete
**Last Updated:** 2026-02-28
**Blockers:** None
**Completed:** 2026-02-28

---

## Acceptance Criteria

1. [x] Zero `FiftyColors.*` references in component_themes.dart (all use colorScheme)
2. [x] `FiftyTheme.dark()` with no args produces identical FDL theme (backward compat)
3. [x] `FiftyTheme.dark(primaryColor: Colors.blue)` produces blue-themed ThemeData
4. [x] `FiftyTheme.dark(colorScheme: custom)` uses full custom ColorScheme
5. [x] Token configuration (AC-002) cascades through to theme automatically
6. [x] Font resolver generates TextTheme with Google Fonts or asset fonts
7. [x] `FiftyThemeExtension` accepts custom semantic colors
8. [x] All 27 component themes correctly use `colorScheme` parameter
9. [x] All existing tests pass (205/205)
10. [x] `flutter analyze` passes (zero issues in fifty_theme)

---

## Affected Areas

### Files to Modify
- `packages/fifty_theme/lib/src/color_scheme.dart` — add parameters, use getters
- `packages/fifty_theme/lib/src/component_themes.dart` — 100+ refs to fix (664 lines)
- `packages/fifty_theme/lib/src/fifty_theme_data.dart` — add parameters
- `packages/fifty_theme/lib/src/theme_extensions.dart` — parameterize
- `packages/fifty_theme/lib/src/text_theme.dart` — use font resolver

**Total files affected:** 5
**Total hardcoded refs to fix:** ~100+

---

## References

**Parent Brief:** AC-001
**Depends On:** AC-002 (fifty_tokens configuration)
**Blocks:** AC-004 (fifty_ui), AC-005 (engine packages)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
