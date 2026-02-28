# Implementation Plan: AC-004

**Complexity:** L (Large)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Full audit of 38 widget files in `packages/fifty_ui/lib/src/` reveals **10 files with direct color/shadow token violations** (FiftyColors, FiftyShadows used directly in build methods instead of through theme extension or colorScheme). Additionally, **6 files use FiftyMotion directly** in `initState`/static methods where `BuildContext` is unavailable -- these are acceptable. The FiftyTypography, FiftySpacing, and FiftyRadii references are **layout/sizing tokens** that do not belong in the theme extension and should remain as direct references.

## Scope Clarification

### What counts as a violation (MUST FIX)

Direct `FiftyColors.*` or `FiftyShadows.*` references in widget `build()` methods, `_getAccentColor()` helpers, or factory constructors that should read from `Theme.of(context)` / `FiftyThemeExtension`.

### What is acceptable (NO FIX NEEDED)

| Token Class | Rationale |
|-------------|-----------|
| `FiftySpacing.*` | Layout values (padding/margin) -- not visual theming, no theme override use case |
| `FiftyRadii.*` | Shape values (border radius) -- structural, not color-dependent |
| `FiftyTypography.*` | Font sizes, weights, letter spacing -- structural text metrics (fontFamily IS in theme via TextTheme) |
| `FiftyMotion.*` in `initState` | AnimationController duration set before context is available -- cannot use extension there |
| `FiftyMotion.*` in static/top-level | Static methods (e.g., `showGeneralDialog`) where passing extension is impractical |
| `FiftyShadows.*` as fallback AFTER extension check | Pattern `fifty?.shadowXxx ?? FiftyShadows.xxx` is the correct fallback |

### What is a gray area (NOTED but tolerated)

- `FiftyMotion` in `initState` (6 files) -- `FiftyCard`, `FiftySegmentedControl` use `FiftyMotion.compiling`/`FiftyMotion.fast` for `AnimationController.duration` where `BuildContext` is not yet available. These widgets already read motion from extension in their `build()` methods. The `initState` value is just an initial duration. **No change needed.**
- `FiftyMotion` in static dialog/snackbar methods -- `showGeneralDialog` requires `transitionDuration` before the builder is called. **No change needed.**

---

## Complete Widget Audit Results

### Category 1: ALREADY CORRECT (reads from theme/extension only)

| # | Widget | File | Status | Notes |
|---|--------|------|--------|-------|
| 1 | FiftyDivider | `display/fifty_divider.dart` | CORRECT | Uses `colorScheme.outline` |
| 2 | FiftyCursor | `utils/fifty_cursor.dart` | CORRECT | Uses `colorScheme.primary` |
| 3 | KineticEffect | `utils/kinetic_effect.dart` | CORRECT | Uses `fifty.fast`, `fifty.standardCurve` |
| 4 | GlowContainer | `utils/glow_container.dart` | CORRECT | Uses `fifty.shadowGlow`, `colorScheme.*` |
| 5 | GlitchEffect | `utils/glitch_effect.dart` | CORRECT | No color/token references (pure visual effect) |
| 6 | HalftoneOverlay | `utils/halftone_painter.dart` | CORRECT | Uses `colorScheme.onSurface` in build |
| 7 | FiftyHero | `organisms/fifty_hero.dart` | CORRECT | Uses `colorScheme.onSurface` |
| 8 | FiftyHeroSection | `organisms/fifty_hero.dart` | CORRECT | Uses `colorScheme.onSurfaceVariant` |
| 9 | FiftyLoadingIndicator | `display/fifty_loading_indicator.dart` | CORRECT | Uses `colorScheme.primary` as fallback |
| 10 | FiftyAvatar | `display/fifty_avatar.dart` | CORRECT | Uses `colorScheme.*` |
| 11 | FiftyChip | `display/fifty_chip.dart` | CORRECT | Uses `colorScheme.*` |
| 12 | FiftyProgressBar | `display/fifty_progress_bar.dart` | CORRECT | Uses `colorScheme.*` |
| 13 | FiftyStatusIndicator | `display/fifty_status_indicator.dart` | CORRECT | Uses `colorScheme.*` |
| 14 | FiftySectionHeader | `display/fifty_section_header.dart` | CORRECT | Uses `colorScheme.*` |
| 15 | FiftySettingsRow | `display/fifty_settings_row.dart` | CORRECT | Uses `colorScheme.*` |
| 16 | FiftyInfoRow | `display/fifty_info_row.dart` | CORRECT | Uses `colorScheme.*` |
| 17 | FiftyListTile | `display/fifty_list_tile.dart` | CORRECT | Uses `colorScheme.*` |
| 18 | FiftyNavPill | `controls/fifty_nav_pill.dart` | CORRECT | Uses `colorScheme.*` |
| 19 | FiftyTextField | `inputs/fifty_text_field.dart` | CORRECT | Uses `colorScheme.*` |
| 20 | FiftySwitch | `inputs/fifty_switch.dart` | CORRECT | Uses `colorScheme.*` (doc mentions FiftyColors but code uses colorScheme) |
| 21 | FiftyCheckbox | `inputs/fifty_checkbox.dart` | CORRECT | Uses `colorScheme.*` |
| 22 | FiftyRadio | `inputs/fifty_radio.dart` | CORRECT | Uses `colorScheme.*` |
| 23 | FiftyRadioCard | `inputs/fifty_radio_card.dart` | CORRECT | Uses `colorScheme.*` |
| 24 | FiftySlider | `inputs/fifty_slider.dart` | CORRECT | Uses `colorScheme.*` |
| 25 | FiftyIconButton | `buttons/fifty_icon_button.dart` | CORRECT | Uses `colorScheme.*` |
| 26 | FiftyLabeledIconButton | `buttons/fifty_labeled_icon_button.dart` | CORRECT | Uses `colorScheme.*` |
| 27 | FiftyCodeBlock | `molecules/fifty_code_block.dart` | CORRECT | Uses `colorScheme.*` |
| 28 | FiftyNavBar | `organisms/fifty_nav_bar.dart` | CORRECT | Uses `colorScheme.*` |

### Category 2: NEEDS FIX (direct color/shadow token references in build methods)

| # | Widget | File | Violation | Severity |
|---|--------|------|-----------|----------|
| 1 | FiftyButton | `buttons/fifty_button.dart` | `_getShadow()` returns `FiftyShadows.primary` and `FiftyShadows.sm` directly (lines 431, 433) | **HIGH** -- primary shadow is a key visual property |
| 2 | FiftyBadge | `display/fifty_badge.dart` | `_getAccentColor()` falls back to `FiftyColors.hunterGreen` and `FiftyColors.warning` (lines 205, 207) | **HIGH** -- prevents custom theme propagation |
| 3 | FiftyBadge factories | `display/fifty_badge.dart` | `FiftyBadge.tech()` and `FiftyBadge.ai()` use `FiftyColors.slateGrey` and `FiftyColors.hunterGreen` (lines 64, 85) | **MEDIUM** -- factory ctors run before BuildContext available |
| 4 | FiftyCard | `containers/fifty_card.dart` | `FiftyShadows.md` as default shadow (line 198) without trying extension first | **MEDIUM** |
| 5 | FiftyDataSlate | `display/fifty_data_slate.dart` | `FiftyShadows.md` as non-glow shadow (line 83) | **MEDIUM** |
| 6 | FiftyStatCard | `display/fifty_stat_card.dart` | `FiftyShadows.sm` as shadow (line 113) | **MEDIUM** |
| 7 | FiftyProgressCard | `display/fifty_progress_card.dart` | `FiftyShadows.md` as shadow (line 80) | **MEDIUM** |
| 8 | FiftyDropdown | `inputs/fifty_dropdown.dart` | `_DropdownMenu` uses `FiftyShadows.md` (line 318) | **MEDIUM** |
| 9 | FiftySnackbar | `feedback/fifty_snackbar.dart` | `showWithSlide()` uses `FiftyShadows.md` (line 168) | **MEDIUM** |
| 10 | FiftyDialog | `feedback/fifty_dialog.dart` | `FiftyShadows.lg` as non-glow shadow (line 90) | **MEDIUM** |
| 11 | FiftyTooltip | `feedback/fifty_tooltip.dart` | `FiftyShadows.sm` as shadow (line 63) | **MEDIUM** |
| 12 | HalftonePainter | `utils/halftone_painter.dart` | Constructor default `FiftyColors.cream` (line 29) | **LOW** -- CustomPainter has no BuildContext |

### Category 3: FiftyMotion in initState/static (ACCEPTABLE -- no fix)

| # | Widget | File | Usage | Why Acceptable |
|---|--------|------|-------|---------------|
| 1 | FiftyCard | `containers/fifty_card.dart` | `FiftyMotion.compiling` in initState (line 154) | No BuildContext in initState; build() uses `fifty.fast` |
| 2 | FiftySegmentedControl | `controls/fifty_segmented_control.dart` | `FiftyMotion.fast` in _FiftySegmentItem (line 208) | In AnimatedContainer which could use extension instead (borderline) |
| 3 | FiftyDialog | `feedback/fifty_dialog.dart` | `FiftyMotion.compiling/enter` in showGeneralDialog (lines 196, 206, 214) | transitionDuration required before builder runs |
| 4 | FiftySnackbar | `feedback/fifty_snackbar.dart` | `FiftyMotion.compiling/enter` in showWithSlide (lines 131, 140) | AnimationController created outside build |

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_ui/lib/src/buttons/fifty_button.dart` | MODIFY | `_getShadow()`: use `fifty.shadowPrimary` / `fifty.shadowSm` from extension |
| `packages/fifty_ui/lib/src/display/fifty_badge.dart` | MODIFY | `_getAccentColor()`: fallback to `colorScheme.tertiary` / `colorScheme.error` instead of FiftyColors; factory constructors: document that customColor will be overridden at build time if null, or accept null and resolve in build |
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | MODIFY | Default shadow: `fifty.shadowMd` instead of `FiftyShadows.md` |
| `packages/fifty_ui/lib/src/display/fifty_data_slate.dart` | MODIFY | Non-glow shadow: `fifty.shadowMd` instead of `FiftyShadows.md` |
| `packages/fifty_ui/lib/src/display/fifty_stat_card.dart` | MODIFY | Shadow: `fifty.shadowSm` instead of `FiftyShadows.sm` |
| `packages/fifty_ui/lib/src/display/fifty_progress_card.dart` | MODIFY | Shadow: `fifty.shadowMd` instead of `FiftyShadows.md` |
| `packages/fifty_ui/lib/src/inputs/fifty_dropdown.dart` | MODIFY | `_DropdownMenu`: use extension shadow `fifty.shadowMd` instead of `FiftyShadows.md` |
| `packages/fifty_ui/lib/src/feedback/fifty_snackbar.dart` | MODIFY | `showWithSlide()`: use `fifty.shadowMd` instead of `FiftyShadows.md` |
| `packages/fifty_ui/lib/src/feedback/fifty_dialog.dart` | MODIFY | Non-glow shadow: `fifty.shadowLg` instead of `FiftyShadows.lg` |
| `packages/fifty_ui/lib/src/feedback/fifty_tooltip.dart` | MODIFY | Shadow: `fifty.shadowSm` instead of `FiftyShadows.sm` |
| `packages/fifty_ui/lib/src/utils/halftone_painter.dart` | MODIFY | Change default color to `const Color(0xFFFFF8F0)` (cream literal) to remove FiftyColors import; update doc comment |
| `packages/fifty_ui/lib/src/display/fifty_badge.dart` (tests) | MODIFY | Update test file for new fallback behavior |
| `packages/fifty_ui/test/theme_propagation_test.dart` | CREATE | New test file verifying custom theme colors propagate to all widgets |

---

## Implementation Steps

### Phase 1: FiftyThemeExtension Enhancement (PREREQUISITE)

The current `FiftyThemeExtension` has `shadowSm`, `shadowMd`, `shadowLg`, `shadowPrimary`, `shadowGlow` -- all the shadow tiers are already available. No extension changes needed.

However, some widgets that need the extension currently use the `!` force-unwrap pattern (`theme.extension<FiftyThemeExtension>()!`). For widgets where the extension is needed but might be missing (fallback scenario), we need the safe pattern:

```dart
final fifty = theme.extension<FiftyThemeExtension>();
// Shadow fallback: extension -> FDL default
final shadow = fifty?.shadowMd ?? FiftyShadows.md;
```

This is the correct 3-tier fallback: extension (custom theme) -> FDL token (last resort).

### Phase 2: Fix FiftyButton Shadow (HIGH priority)

**File:** `packages/fifty_ui/lib/src/buttons/fifty_button.dart`

**Change `_getShadow()` (lines 426-439):**

Currently:
```dart
List<BoxShadow>? _getShadow() {
  if (_isDisabled) return null;
  switch (widget.variant) {
    case FiftyButtonVariant.primary:
      return FiftyShadows.primary;
    case FiftyButtonVariant.secondary:
      return FiftyShadows.sm;
    ...
  }
}
```

After:
```dart
List<BoxShadow>? _getShadow(FiftyThemeExtension? fifty) {
  if (_isDisabled) return null;
  switch (widget.variant) {
    case FiftyButtonVariant.primary:
      return fifty?.shadowPrimary ?? FiftyShadows.primary;
    case FiftyButtonVariant.secondary:
      return fifty?.shadowSm ?? FiftyShadows.sm;
    ...
  }
}
```

Update the call site in `build()` (line 196):
```dart
final shadow = _getShadow(fifty);
```

Note: `fifty` is already available in `build()` as `theme.extension<FiftyThemeExtension>()!` -- change to nullable: `theme.extension<FiftyThemeExtension>()` (remove `!`).

### Phase 3: Fix FiftyBadge Accent Color Fallback (HIGH priority)

**File:** `packages/fifty_ui/lib/src/display/fifty_badge.dart`

**Change `_getAccentColor()` (lines 195-213):**

Currently:
```dart
case FiftyBadgeVariant.success:
  return fifty?.success ?? FiftyColors.hunterGreen;
case FiftyBadgeVariant.warning:
  return fifty?.warning ?? FiftyColors.warning;
```

After:
```dart
case FiftyBadgeVariant.success:
  return fifty?.success ?? colorScheme.tertiary;
case FiftyBadgeVariant.warning:
  return fifty?.warning ?? colorScheme.errorContainer;
```

Note: `colorScheme.tertiary` maps to hunterGreen in FDL theme; `colorScheme.errorContainer` or a dedicated semantic token for warning. Check FDL color mapping: warning (#F7A100) is not in standard Material colorScheme. Best approach: `fifty?.warning ?? const Color(0xFFF7A100)` as a fallback constant, since warning has no colorScheme equivalent.

**Revised approach for warning:** Since there is no Material `colorScheme` slot for warning (Material only has error), the fallback should be a hardcoded hex constant rather than FiftyColors reference:
```dart
case FiftyBadgeVariant.warning:
  return fifty?.warning ?? const Color(0xFFF7A100);
```

This removes the import dependency while preserving the same color. Alternatively, keep `FiftyColors.warning` as the last-resort fallback since this IS the "FDL constant (last resort)" tier. **Decision: Keep `FiftyColors.warning` -- it IS the last resort.** The issue is `FiftyColors.hunterGreen` which should be `colorScheme.tertiary`.

**Final fix for _getAccentColor:**
```dart
case FiftyBadgeVariant.success:
  return fifty?.success ?? colorScheme.tertiary;
case FiftyBadgeVariant.warning:
  return fifty?.warning ?? FiftyColors.warning; // No colorScheme equivalent; FDL last resort
```

**Fix factory constructors:**

The factory constructors `FiftyBadge.tech()` and `FiftyBadge.ai()` set `customColor: FiftyColors.slateGrey` and `customColor: FiftyColors.hunterGreen`. These run before BuildContext is available. Options:

1. **Remove customColor from factories, resolve in build** -- This changes the API
2. **Keep as-is with doc comment** -- Factories provide a hardcoded brand-specific color

**Decision:** Change factories to set `customColor: null` and use the variant system instead. The `tech` factory should use `variant: FiftyBadgeVariant.neutral` (which maps to `colorScheme.onSurfaceVariant` -- already correct). The `ai` factory should use `variant: FiftyBadgeVariant.success` (which maps to extension.success -> colorScheme.tertiary).

```dart
factory FiftyBadge.tech(String label) {
  return FiftyBadge(
    label: label,
    variant: FiftyBadgeVariant.neutral,
  );
}

factory FiftyBadge.ai(String label) {
  return FiftyBadge(
    label: label,
    variant: FiftyBadgeVariant.success,
    showGlow: true,
  );
}
```

### Phase 4: Fix Shadow Token References (8 files, MEDIUM priority)

All of these follow the same pattern: replace `FiftyShadows.xxx` with `fifty?.shadowXxx ?? FiftyShadows.xxx`.

**4a. FiftyCard** (`containers/fifty_card.dart`, line 198):
```dart
// Before:
effectiveShadow = FiftyShadows.md;
// After:
effectiveShadow = fifty.shadowMd;
```
Note: FiftyCard already uses `fifty` (non-null via `!`). Change to nullable and add fallback:
```dart
final fifty = theme.extension<FiftyThemeExtension>();
// ...
effectiveShadow = fifty?.shadowMd ?? FiftyShadows.md;
```

Also fix initState `FiftyMotion.compiling` (line 154) -- this is acceptable as noted, but ideally could use a constant `const Duration(milliseconds: 300)` to remove the FiftyMotion import if the only remaining import. **Low priority -- leave as-is since FiftyMotion is a structural token.**

**4b. FiftyDataSlate** (`display/fifty_data_slate.dart`, line 83):
```dart
// Before:
boxShadow: showGlow ? fifty.shadowGlow : FiftyShadows.md,
// After:
boxShadow: showGlow ? fifty.shadowGlow : (fifty?.shadowMd ?? FiftyShadows.md),
```
Note: Already uses `fifty!` -- needs null safety adjustment if we want graceful fallback.

**4c. FiftyStatCard** (`display/fifty_stat_card.dart`, line 113):
```dart
// Before:
boxShadow: FiftyShadows.sm,
// After:
boxShadow: fifty?.shadowSm ?? FiftyShadows.sm,
```
Note: Already has `fifty` in scope.

**4d. FiftyProgressCard** (`display/fifty_progress_card.dart`, line 80):
```dart
// Before:
boxShadow: FiftyShadows.md,
// After:
boxShadow: fifty?.shadowMd ?? FiftyShadows.md,
```
Note: Already has `fifty!` in scope.

**4e. FiftyDropdown** (`inputs/fifty_dropdown.dart`, line 318):
The `_DropdownMenu` is a separate widget class. It needs to access the theme extension in its build method.
```dart
// In _DropdownMenu.build():
final fifty = Theme.of(context).extension<FiftyThemeExtension>();
// ...
boxShadow: fifty?.shadowMd ?? FiftyShadows.md,
```

**4f. FiftySnackbar** (`feedback/fifty_snackbar.dart`, line 168):
```dart
// Before:
boxShadow: FiftyShadows.md,
// After:
boxShadow: fifty.shadowMd,
```
Note: `fifty` is already non-null here (line 53: `fifty!`). Can use directly. But for graceful fallback, prefer nullable pattern.

**4g. FiftyDialog** (`feedback/fifty_dialog.dart`, line 90):
```dart
// Before:
boxShadow: showGlow ? fifty.shadowGlow : FiftyShadows.lg,
// After:
boxShadow: showGlow ? fifty.shadowGlow : fifty.shadowLg,
```
Note: `fifty` already non-null here.

**4h. FiftyTooltip** (`feedback/fifty_tooltip.dart`, line 63):
```dart
// Before:
boxShadow: FiftyShadows.sm,
// After:
```
FiftyTooltip needs to access the extension. Check if it already does.

Looking at the tooltip code: it receives `backgroundColor`, `borderColor`, `textColor` as resolved values from the outer builder. The `boxShadow` is the only remaining direct reference. Need to add extension access in the build method:
```dart
final fifty = Theme.of(context).extension<FiftyThemeExtension>();
boxShadow: fifty?.shadowSm ?? FiftyShadows.sm,
```

### Phase 5: Fix HalftonePainter Default (LOW priority)

**File:** `packages/fifty_ui/lib/src/utils/halftone_painter.dart`

The `HalftonePainter` is a `CustomPainter` -- no `BuildContext`. Its default `color = FiftyColors.cream` is the only reasonable approach for a CustomPainter constructor default. The `HalftoneOverlay` widget wrapper already resolves from theme.

**Decision:** This is acceptable as-is. The `HalftonePainter` is a low-level painting primitive, and its default is only used when consumers don't pass a color. The `HalftoneOverlay` widget (the recommended API) already uses `colorScheme.onSurface`.

However, to satisfy the "zero FiftyColors in build methods" acceptance criteria, we can change the default to a hex literal:
```dart
this.color = const Color(0xFFFFF8F0), // cream
```
This removes the semantic dependency while keeping the same visual default.

### Phase 6: Graceful Extension Fallback Pattern

Several widgets currently use `theme.extension<FiftyThemeExtension>()!` (force unwrap). To satisfy AC-004 acceptance criterion #4 ("widgets gracefully handle missing FiftyThemeExtension"), we should change these to nullable access with fallback.

**Files to update from `!` to `?` with fallback:**

| File | Current | After |
|------|---------|-------|
| `fifty_button.dart` | `extension()!` | `extension()` + null-safe access |
| `fifty_card.dart` | `extension()!` | `extension()` + null-safe access |
| `fifty_data_slate.dart` | `extension()!` | `extension()` + null-safe access |
| `fifty_progress_card.dart` | `extension()!` | `extension()` + null-safe access |
| `fifty_stat_card.dart` | `extension()!` | `extension()` + null-safe access |
| `fifty_dropdown.dart` | `extension()!` | `extension()` + null-safe access |
| `glow_container.dart` | `extension()!` | `extension()` + null-safe access |
| `kinetic_effect.dart` | `extension()!` | `extension()` + null-safe access |

For motion values, the fallback is:
```dart
final duration = fifty?.fast ?? const Duration(milliseconds: 150);
final curve = fifty?.standardCurve ?? Curves.easeInOut;
```

### Phase 7: FiftySegmentedControl FiftyMotion Fix

**File:** `packages/fifty_ui/lib/src/controls/fifty_segmented_control.dart`

Line 208 uses `FiftyMotion.fast` directly in an `AnimatedContainer`. Since this IS inside a build method where `BuildContext` is available, it should use the extension:

```dart
// Before:
duration: FiftyMotion.fast,
// After:
duration: fifty?.fast ?? const Duration(milliseconds: 150),
```

The `_FiftySegmentItem` needs access to the extension. Check if it already has it from parent -- it does not, it accesses `Theme.of(context)` but not the extension. Add extension access.

---

## Testing Strategy

### Existing Tests (27 test files)
All existing tests must continue passing. No behavioral changes -- only source of color/shadow values changes.

### New Test File: Theme Propagation Tests

**File:** `packages/fifty_ui/test/theme_propagation_test.dart`

Create a test helper that wraps widgets in a custom theme with NON-FDL colors to verify propagation:

```dart
Widget buildWithCustomTheme(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Colors.purple,        // NOT burgundy
        onPrimary: Colors.white,
        secondary: Colors.teal,
        tertiary: Colors.lime,         // NOT hunterGreen
        error: Colors.orange,
        surface: Colors.grey,
        onSurface: Colors.white,
        outline: Colors.blueGrey,
        // ... etc
      ),
      extensions: [
        FiftyThemeExtension(
          accent: Colors.purple,
          success: Colors.lime,
          warning: Colors.amber,
          info: Colors.cyan,
          shadowSm: [const BoxShadow(color: Colors.purple, blurRadius: 2)],
          shadowMd: [const BoxShadow(color: Colors.purple, blurRadius: 4)],
          shadowLg: [const BoxShadow(color: Colors.purple, blurRadius: 8)],
          shadowPrimary: [const BoxShadow(color: Colors.purple, blurRadius: 6)],
          shadowGlow: [const BoxShadow(color: Colors.purple, blurRadius: 12)],
          instant: Duration.zero,
          fast: const Duration(milliseconds: 100),
          compiling: const Duration(milliseconds: 200),
          systemLoad: const Duration(milliseconds: 500),
          standardCurve: Curves.linear,
          enterCurve: Curves.linear,
          exitCurve: Curves.linear,
        ),
      ],
    ),
    home: Scaffold(body: child),
  );
}
```

**Test scenarios:**

1. **FiftyButton primary shadow uses custom shadowPrimary** -- verify the shadow in the BoxDecoration matches the custom extension value
2. **FiftyBadge.success uses custom success color** -- verify the badge border color matches the custom extension success color (lime, not hunterGreen)
3. **FiftyBadge.warning uses custom warning color** -- verify amber, not FDL orange
4. **FiftyBadge.tech() uses colorScheme.onSurfaceVariant** -- not FiftyColors.slateGrey
5. **FiftyBadge.ai() uses extension success color** -- not FiftyColors.hunterGreen
6. **FiftyCard shadow uses custom shadowMd** -- verify custom shadow propagation
7. **FiftyDialog shadow uses custom shadowLg** -- verify custom shadow propagation
8. **FiftyTooltip shadow uses custom shadowSm** -- verify custom shadow propagation

### New Test File: No Extension Fallback Tests

**File:** `packages/fifty_ui/test/graceful_fallback_test.dart`

Wrap widgets in `MaterialApp` WITHOUT `FiftyThemeExtension` to verify they still render:

```dart
Widget buildWithoutExtension(Widget child) {
  return MaterialApp(
    theme: ThemeData(colorScheme: const ColorScheme.dark()),
    home: Scaffold(body: child),
  );
}
```

**Test scenarios:**

1. **FiftyButton renders without FiftyThemeExtension** -- no crash, uses FDL defaults
2. **FiftyBadge renders without FiftyThemeExtension** -- no crash, uses colorScheme
3. **FiftyCard renders without FiftyThemeExtension** -- no crash, uses FDL shadow defaults
4. **FiftyDataSlate renders without FiftyThemeExtension** -- no crash
5. **GlowContainer renders without FiftyThemeExtension** -- no crash

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Force-unwrap removal causes null errors in widgets that depend on extension methods | Low | High | Test every widget with AND without extension; ensure fallback values work |
| FiftyBadge factory constructor API change breaks downstream | Medium | Medium | Factory constructors now use variant enum instead of customColor -- check downstream for `FiftyBadge.tech()`, `.ai()`, `.status()` callers |
| Shadow appearance change (extension shadows vs FDL constants differ) | Low | Low | Extension factories already set shadows from FiftyShadows tokens -- values are identical |
| FiftySegmentedControl animation behavior change from FiftyMotion to extension | Low | Low | Same duration value, just different source |
| `FiftyDropdown._DropdownMenu` is a separate widget class, needs own extension access | Low | Low | Standard pattern -- add `Theme.of(context).extension<FiftyThemeExtension>()` in its build |
| Downstream apps using `FiftyBadge(customColor: FiftyColors.hunterGreen)` directly | Medium | Low | `customColor` parameter still works -- only factory constructors change |
| Warning color has no Material colorScheme equivalent | Low | Low | Keep FiftyColors.warning as last-resort fallback (it IS the FDL constant) |

---

## Downstream Impact

### Widgets with API Changes
- `FiftyBadge.tech()` -- no longer sets `customColor`, uses variant system. Visual output may differ slightly if consumer's `colorScheme.onSurfaceVariant` differs from FiftyColors.slateGrey. In FDL theme, they are the same.
- `FiftyBadge.ai()` -- no longer sets `customColor: FiftyColors.hunterGreen`, uses `variant: FiftyBadgeVariant.success`. Visual output identical in FDL theme (success = hunterGreen).

### No API Changes
All other fixes are internal implementation changes. Public API remains identical.

---

## Implementation Order

1. Phase 2: FiftyButton shadow fix (highest visibility)
2. Phase 3: FiftyBadge accent + factory fix (highest risk of downstream impact)
3. Phase 4: Shadow token fixes (8 files, mechanical)
4. Phase 6: Force-unwrap to nullable pattern (defensive)
5. Phase 7: FiftySegmentedControl motion fix (minor)
6. Phase 5: HalftonePainter default (cosmetic)
7. Testing: theme propagation + graceful fallback tests
8. Run `flutter analyze` -- zero issues
9. Run full test suite -- all green

---

## File Change Summary

| Action | Count | Details |
|--------|-------|---------|
| MODIFY | 12 | 10 widget files + 2 existing test files |
| CREATE | 2 | theme_propagation_test.dart + graceful_fallback_test.dart |
| DELETE | 0 | -- |
| **Total** | **14** | |

## Estimated Line Changes

- Widget fixes: ~80-120 lines changed (mostly single-line shadow/color replacements)
- Force-unwrap fixes: ~40 lines changed
- New tests: ~200-300 lines
- **Total: ~320-460 lines**
