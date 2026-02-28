# Implementation Plan: AC-005 -- Engine Packages Theme Alignment

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Low

---

## Summary

Audit and fix all engine packages that hardcode `FiftyColors.*` in widget build methods so they read from `Theme.of(context).colorScheme` (or accept optional color parameters). Three packages have known violations -- connectivity, achievement engine, and skill tree -- but a full audit reveals **four** packages need work (fifty_forms was incorrectly listed as "clean"). Additionally, the skill_tree violations are far more extensive than the brief assumed: the entire FDL fallback layer in `SkillNodeWidget`, `SkillTooltip`, and `ConnectionPainter` uses direct FiftyColors references.

---

## Full Audit Results

### VIOLATIONS FOUND (4 packages)

#### 1. fifty_connectivity -- 10 violations across 2 files

| File | Line(s) | Violation | Mapping |
|------|---------|-----------|---------|
| `connection_handler.dart` | 97 | `FiftyColors.slateGrey` (loading indicator color) | `colorScheme.onSurfaceVariant` |
| `connection_handler.dart` | 126 | `FiftyColors.burgundy` (offline icon color) | `colorScheme.error` |
| `connection_handler.dart` | 137 | `FiftyColors.burgundy` (title text color) | `colorScheme.error` |
| `connection_handler.dart` | 150 | `FiftyColors.slateGrey` (subtitle text color) | `colorScheme.onSurfaceVariant` |
| `connection_overlay.dart` | 115 | `FiftyColors.slateGrey` (badge customColor) | `colorScheme.onSurfaceVariant` |
| `connection_overlay.dart` | 205 | `FiftyColors.burgundy` (wifi_off icon color) | `colorScheme.error` |
| `connection_overlay.dart` | 221 | `FiftyColors.burgundy` (title text color) | `colorScheme.error` |
| `connection_overlay.dart` | 234 | `FiftyColors.slateGrey` (subtitle text color) | `colorScheme.onSurfaceVariant` |
| `connection_overlay.dart` | 248 | `FiftyColors.slateGrey.withValues(alpha: 0.7)` (timer text) | `colorScheme.onSurfaceVariant.withValues(alpha: 0.7)` |
| `connection_overlay.dart` | 258 | `FiftyColors.slateGrey` (loading indicator color) | `colorScheme.onSurfaceVariant` |

Note: `connectivity_checker_splash.dart` is already clean -- uses `colorScheme`.

#### 2. fifty_achievement_engine -- 6 violations across 3 files (duplicated rarity color map)

| File | Line(s) | Violation | Resolution |
|------|---------|-----------|------------|
| `achievement_card.dart` | 67 | `FiftyColors.slateGrey` (common rarity) | `colorScheme.onSurfaceVariant` |
| `achievement_card.dart` | 69 | `FiftyColors.hunterGreen` (uncommon rarity) | `colorScheme.tertiary` |
| `achievement_popup.dart` | 127 | `FiftyColors.slateGrey` (common rarity) | `colorScheme.onSurfaceVariant` |
| `achievement_popup.dart` | 129 | `FiftyColors.hunterGreen` (uncommon rarity) | `colorScheme.tertiary` |
| `achievement_summary.dart` | 357 | `FiftyColors.slateGrey` (common rarity) | `colorScheme.onSurfaceVariant` |
| `achievement_summary.dart` | 359 | `FiftyColors.hunterGreen` (uncommon rarity) | `colorScheme.tertiary` |

Note: `achievement_progress_bar.dart` and `achievement_list.dart` are already clean.

#### 3. fifty_skill_tree -- 35 violations across 3 files

| File | Count | Key Violations |
|------|-------|----------------|
| `skill_node_widget.dart` | 13 | FDL fallback methods `_getFdlBackgroundColor`, `_getFdlBorderColor`, `_getFdlIconColor` use surfaceDark, borderDark, hunterGreen, slateGrey, powderBlush, primary, success, warning, cream |
| `skill_tooltip.dart` | 18 | FDL defaults: surfaceDark, borderDark, cream, warning, burgundy, slateGrey, success, primary |
| `connection_painter.dart` | 3 | FDL defaults: borderDark, success, primary |

Full mapping for skill_tree:

| FiftyColors ref | ColorScheme equivalent |
|-----------------|----------------------|
| `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `FiftyColors.borderDark` | `colorScheme.outline` |
| `FiftyColors.cream` | `colorScheme.onSurface` |
| `FiftyColors.primary` (burgundy) | `colorScheme.primary` |
| `FiftyColors.success` (hunterGreen) | `colorScheme.tertiary` |
| `FiftyColors.warning` | `extension.warning` (no colorScheme equivalent) |
| `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` |
| `FiftyColors.hunterGreen` | `colorScheme.tertiary` |
| `FiftyColors.powderBlush` | `extension.accent` |
| `FiftyColors.burgundy` | `colorScheme.error` |

#### 4. fifty_forms -- 21 violations across 3 files (BRIEF INCORRECTLY LISTED AS CLEAN)

| File | Count | Key Violations |
|------|-------|----------------|
| `time_form_field.dart` | 12 | Date/time picker theme override hardcodes FiftyColors.primary, surfaceDark/Light, darkBurgundy, slateGrey, borderLight |
| `date_form_field.dart` | 6 | Date picker theme override hardcodes same set |
| `file_form_field.dart` | 3 | borderDark/Light, surfaceDark/Light, slateGrey |

**Note:** These are NOT in widget `build()` methods directly -- they are in `showTimePicker`/`showDatePicker` builder callbacks that construct a `Theme()` wrapper. The pattern is `theme.copyWith(colorScheme: theme.colorScheme.copyWith(primary: FiftyColors.primary, ...))` which overrides the consumer's own theme. This is a VIOLATION -- the picker should inherit the consumer's colorScheme, not force FDL colors.

### CONFIRMED CLEAN (8 packages)

| Package | Files Checked | Status |
|---------|---------------|--------|
| fifty_audio_engine | All lib/src/ | CLEAN -- 0 FiftyColors/FiftyShadows refs |
| fifty_speech_engine | All lib/src/ | CLEAN -- 0 refs |
| fifty_printing_engine | All lib/src/ | CLEAN -- 0 refs |
| fifty_scroll_sequence | All lib/src/ | CLEAN -- 0 refs |
| fifty_narrative_engine | All lib/ | CLEAN -- 0 refs (pure Dart, no UI) |
| fifty_world_engine | All lib/ | CLEAN -- 0 refs (Flame engine, no Flutter theme) |
| fifty_socket | All lib/ | CLEAN -- 0 refs (pure Dart, no UI) |
| fifty_connectivity (splash) | connectivity_checker_splash.dart | CLEAN -- already uses colorScheme |

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_connectivity/lib/src/widgets/connection_handler.dart` | MODIFY | Replace 4 FiftyColors refs with colorScheme lookups |
| `packages/fifty_connectivity/lib/src/widgets/connection_overlay.dart` | MODIFY | Replace 6 FiftyColors refs with colorScheme lookups; OfflineStatusCard + UplinkStatusBar |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart` | MODIFY | Add optional `rarityColors` param; replace common/uncommon defaults with colorScheme |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_popup.dart` | MODIFY | Add optional `rarityColors` param; replace common/uncommon defaults with colorScheme |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_summary.dart` | MODIFY | Replace `_getRarityColor` common/uncommon with colorScheme |
| `packages/fifty_skill_tree/lib/src/themes/skill_tree_theme.dart` | MODIFY | Add `fromContext(BuildContext)` factory |
| `packages/fifty_skill_tree/lib/src/widgets/skill_node_widget.dart` | MODIFY | Replace 13 FDL fallback refs with colorScheme lookups via context |
| `packages/fifty_skill_tree/lib/src/widgets/skill_tooltip.dart` | MODIFY | Replace 18 FDL fallback refs with colorScheme lookups via context |
| `packages/fifty_skill_tree/lib/src/painters/connection_painter.dart` | MODIFY | Replace 3 FDL fallback refs -- NOTE: painters lack BuildContext, see design below |
| `packages/fifty_forms/lib/src/fields/time_form_field.dart` | MODIFY | Remove FiftyColors overrides from showTimePicker builder; inherit consumer theme |
| `packages/fifty_forms/lib/src/fields/date_form_field.dart` | MODIFY | Remove FiftyColors overrides from showDatePicker builder; inherit consumer theme |
| `packages/fifty_forms/lib/src/fields/file_form_field.dart` | MODIFY | Replace 3 FiftyColors refs with colorScheme lookups |
| `packages/fifty_connectivity/test/widgets/connection_handler_test.dart` | CREATE | Widget tests for theme alignment |
| `packages/fifty_connectivity/test/widgets/connection_overlay_test.dart` | CREATE | Widget tests for theme alignment |
| `packages/fifty_achievement_engine/test/widgets/achievement_card_test.dart` | CREATE | Widget tests for rarity colors and custom override |
| `packages/fifty_achievement_engine/test/widgets/achievement_popup_test.dart` | CREATE | Widget tests for rarity colors |
| `packages/fifty_skill_tree/test/themes/skill_tree_theme_test.dart` | CREATE | Unit tests for fromContext factory |
| `packages/fifty_skill_tree/test/widgets/skill_node_widget_theme_test.dart` | CREATE | Widget tests for FDL fallback and theme-based coloring |

---

## Implementation Steps

### Phase 1: fifty_connectivity (connection_handler.dart + connection_overlay.dart)

**Approach:** Straightforward find-and-replace. All violations are in widget `build()` methods that already call `Theme.of(context)`.

#### Step 1.1: connection_handler.dart (4 changes)

The file already gets `colorScheme` at line 85 and 107. Changes:

1. **Line 97** -- `_buildConnectingWidget`: Change `color: FiftyColors.slateGrey` to `color: colorScheme.onSurfaceVariant` on the FiftyLoadingIndicator.
2. **Line 126** -- `_buildOfflineWidget`: Change `color: FiftyColors.burgundy` to `color: colorScheme.error` on the cloud_off icon.
3. **Line 137** -- Change `color: FiftyColors.burgundy` to `color: colorScheme.error` on the title TextStyle. Remove `const` from TextStyle (colorScheme is runtime).
4. **Line 150** -- Change `color: FiftyColors.slateGrey` to `color: colorScheme.onSurfaceVariant` on the subtitle TextStyle. Remove `const`.

**Import change:** Remove `import 'package:fifty_tokens/fifty_tokens.dart'` if no other FiftyTokens refs remain (check FiftyTypography/FiftySpacing -- they are structural, so they stay; the import stays).

#### Step 1.2: connection_overlay.dart -- UplinkStatusBar (1 change)

5. **Line 115** -- `_buildStatusBadge()`: Change `customColor: FiftyColors.slateGrey` to a colorScheme lookup. BUT -- `UplinkStatusBar` is a StatelessWidget and `_buildStatusBadge()` does not receive context. The `build()` method at line 88 has context, but `_buildStatusBadge()` at line 100 does not pass it through. **Fix:** Pass `context` to `_buildStatusBadge(context)` and resolve there: `customColor: Theme.of(context).colorScheme.onSurfaceVariant`.

#### Step 1.3: connection_overlay.dart -- OfflineStatusCard (5 changes)

The `build()` method already gets `colorScheme` at line 180. Changes:

6. **Line 205** -- Change `color: FiftyColors.burgundy` to `color: colorScheme.error` (wifi_off icon). Remove `const` from the parent Icon widget.
7. **Line 221** -- Change `color: FiftyColors.burgundy` to `color: colorScheme.error` (title TextStyle). Remove `const`.
8. **Line 234** -- Change `color: FiftyColors.slateGrey` to `color: colorScheme.onSurfaceVariant` (subtitle TextStyle). Remove `const`.
9. **Line 248** -- Change `FiftyColors.slateGrey.withValues(alpha: 0.7)` to `colorScheme.onSurfaceVariant.withValues(alpha: 0.7)` (timer text).
10. **Line 258** -- Change `color: FiftyColors.slateGrey` to `color: colorScheme.onSurfaceVariant` (loading indicator).

### Phase 2: fifty_achievement_engine (3 widget files)

**Approach:** The rarity color map is duplicated across 3 files (achievement_card, achievement_popup, achievement_summary). The brief asks for an optional `rarityColors` parameter on `AchievementCard`. The same pattern should extend to `AchievementPopup` and `AchievementSummary` for consistency.

**Key design decision:** Rarity colors are a DOMAIN concept (game-specific), not a theme concept. `rare`/`epic`/`legendary` keep their hardcoded hex colors as defaults. Only `common` and `uncommon` map to theme because they happen to use FiftyColors (slateGrey, hunterGreen) which ARE theme-derived.

#### Step 2.1: Create shared rarity color resolver

Rather than duplicating the `rarityColors` parameter 3 times, extract a utility:

```dart
// In a new file or within existing models/
/// Resolves rarity colors, using theme-derived defaults for common/uncommon.
class RarityColorResolver {
  const RarityColorResolver({this.overrides});

  final Map<AchievementRarity, Color>? overrides;

  Color resolve(AchievementRarity rarity, ColorScheme colorScheme) {
    if (overrides != null && overrides!.containsKey(rarity)) {
      return overrides![rarity]!;
    }
    return _defaultColor(rarity, colorScheme);
  }

  static Color _defaultColor(AchievementRarity rarity, ColorScheme colorScheme) {
    switch (rarity) {
      case AchievementRarity.common:
        return colorScheme.onSurfaceVariant;
      case AchievementRarity.uncommon:
        return colorScheme.tertiary;
      case AchievementRarity.rare:
        return const Color(0xFF5B8BD4);
      case AchievementRarity.epic:
        return const Color(0xFF9B59B6);
      case AchievementRarity.legendary:
        return const Color(0xFFE67E22);
    }
  }
}
```

**On second thought** -- adding a whole new class for this is overkill. The simpler approach: each widget gets an optional `Map<AchievementRarity, Color>? rarityColors` param, and the existing `_rarityColor` getter becomes a method that takes a `ColorScheme`. This avoids new files and keeps changes minimal.

#### Step 2.2: achievement_card.dart

1. Add `final Map<AchievementRarity, Color>? rarityColors;` parameter to constructor.
2. Convert `Color get _rarityColor` getter to a method `Color _getRarityColor(ColorScheme colorScheme)`:
   - Check `rarityColors?[rarity]` first (override)
   - Common: `colorScheme.onSurfaceVariant` (was FiftyColors.slateGrey)
   - Uncommon: `colorScheme.tertiary` (was FiftyColors.hunterGreen)
   - Rare/Epic/Legendary: keep hardcoded hex values (domain colors)
3. Update all call sites (5 usages of `_rarityColor` in build/helper methods) to pass `Theme.of(context).colorScheme`.
4. Remove `import 'package:fifty_tokens/fifty_tokens.dart'` if no FiftyTokens refs remain (check FiftyTypography/FiftySpacing/FiftyRadii/FiftyMotion -- all are structural, import likely stays).

#### Step 2.3: achievement_popup.dart

Same pattern as achievement_card:

1. Add `final Map<AchievementRarity, Color>? rarityColors;` parameter.
2. Convert `Color get _rarityColor` to `Color _getRarityColor(ColorScheme colorScheme)`.
3. Update 6 usages of `_rarityColor` in build methods.

#### Step 2.4: achievement_summary.dart

1. Add `final Map<AchievementRarity, Color>? rarityColors;` parameter.
2. Convert `Color _getRarityColor(AchievementRarity rarity)` method to accept `ColorScheme`.
3. Update 1 call site in `_buildRarityBreakdown`.

### Phase 3: fifty_skill_tree (3 source files + theme)

**Approach:** The skill_tree has an existing dual-path system: if `theme != null`, use custom theme; if `theme == null`, fall back to FDL defaults. The problem is the FDL defaults hardcode FiftyColors. The solution has two parts:

1. **Add `SkillTreeTheme.fromContext(BuildContext)`** -- new factory that reads from consumer's Theme
2. **Fix FDL fallback path** -- the widget-level FDL fallbacks in SkillNodeWidget, SkillTooltip, and ConnectionPainter need to read from context instead of hardcoding

**Critical challenge:** `ConnectionPainter` is a `CustomPainter` with no `BuildContext`. It cannot call `Theme.of(context)`. The FDL defaults (`_fdlLockedColor`, `_fdlUnlockedColor`, `_fdlHighlightColor`) must be resolved BEFORE the painter is created -- i.e., in `SkillTreeView._buildNodeWidgets()` where context IS available.

**Similarly:** `SkillNodeWidget._getFdlBackgroundColor` and friends are `static` methods that take no context. They need to become instance methods that accept `BuildContext`, OR the caller resolves the theme before passing it.

#### Step 3.1: SkillTreeTheme.fromContext factory

Add to `packages/fifty_skill_tree/lib/src/themes/skill_tree_theme.dart`:

```dart
/// Creates a theme derived from the app's [Theme.of(context)].
///
/// Maps ColorScheme roles to skill tree properties:
/// - Locked nodes: surfaceContainerHighest / outline
/// - Available nodes: primaryContainer / primary
/// - Unlocked nodes: tertiaryContainer / tertiary
/// - Maxed nodes: primary with alpha / primary
/// - Passive type: onSurfaceVariant
/// - Active type: primary
/// - Ultimate type: accent (from FiftyThemeExtension) or secondary
/// - Keystone type: warning (from FiftyThemeExtension) or error
/// - Connections: outline (locked), tertiary (unlocked), primary (highlight)
/// - Tooltip: surfaceContainerHighest, outline
/// - Text: onSurface
factory SkillTreeTheme.fromContext(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final fifty = Theme.of(context).extension<FiftyThemeExtension>();
  final warningColor = fifty?.warning ?? colorScheme.error;
  final accentColor = fifty?.accent ?? colorScheme.secondary;

  return SkillTreeTheme(
    // Node colors by state
    lockedNodeColor: colorScheme.surfaceContainerHighest,
    lockedNodeBorderColor: colorScheme.outline,
    availableNodeColor: colorScheme.primaryContainer,
    availableNodeBorderColor: colorScheme.primary,
    unlockedNodeColor: colorScheme.tertiaryContainer,
    unlockedNodeBorderColor: colorScheme.tertiary,
    maxedNodeColor: colorScheme.primary.withValues(alpha: 0.2),
    maxedNodeBorderColor: colorScheme.primary,
    // Node colors by type
    passiveColor: colorScheme.onSurfaceVariant,
    activeColor: colorScheme.primary,
    ultimateColor: accentColor,
    keystoneColor: warningColor,
    // Connection colors
    connectionLockedColor: colorScheme.outline,
    connectionUnlockedColor: colorScheme.tertiary,
    connectionHighlightColor: colorScheme.primary,
    // Sizes (unchanged defaults)
    nodeRadius: 28.0,
    nodeBorderWidth: 2.0,
    connectionWidth: 2.0,
    // Text styles
    nodeNameStyle: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    nodeLevelStyle: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
    nodeCostStyle: TextStyle(
      color: warningColor,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
    tooltipTitleStyle: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    tooltipDescriptionStyle: TextStyle(
      color: colorScheme.onSurface.withValues(alpha: 0.7),
      fontSize: 12,
    ),
    // Tooltip
    tooltipBackground: colorScheme.surfaceContainerHighest,
    tooltipBorder: colorScheme.outline,
  );
}
```

**Import needed:** `import 'package:flutter/material.dart'` (currently uses `foundation.dart` + `painting.dart`). Change to `material.dart` for BuildContext + ThemeExtension. Also need FiftyThemeExtension import: `import 'package:fifty_theme/fifty_theme.dart'` -- this adds a new dependency.

**WAIT -- dependency concern.** fifty_skill_tree's pubspec currently depends on fifty_tokens but NOT fifty_theme. Adding fifty_theme as a dependency just for the `fromContext` factory creates a coupling issue. Two options:

**Option A:** Add fifty_theme as an optional/dev dependency -- but Dart has no optional deps.

**Option B:** The `fromContext` factory does NOT reference FiftyThemeExtension. It only uses `Theme.of(context).colorScheme`, which is pure Flutter. For warning/accent, it accepts optional Color params with colorScheme fallbacks.

**Choosing Option B** -- this avoids adding a fifty_theme dependency:

```dart
factory SkillTreeTheme.fromContext(
  BuildContext context, {
  Color? warningColor,
  Color? accentColor,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final warning = warningColor ?? colorScheme.error;
  final accent = accentColor ?? colorScheme.secondary;
  // ... rest uses colorScheme only
}
```

This is cleaner: consumers who DO use fifty_theme can pass `fifty?.warning` themselves. The factory stays dependency-free.

**Import change:** Only need `import 'package:flutter/material.dart'` instead of foundation.dart + painting.dart. No new package dependency needed.

#### Step 3.2: skill_node_widget.dart -- Fix FDL fallback methods

The three static methods (`_getFdlBackgroundColor`, `_getFdlBorderColor`, `_getFdlIconColor`) hardcode FiftyColors. Since the widget ALREADY has a `theme` field, the solution is:

**Strategy:** When `theme == null`, construct one from context. The widget's `build()` method has `context`. Add a helper:

```dart
SkillTreeTheme _resolveTheme(BuildContext context) {
  return theme ?? SkillTreeTheme.fromContext(context);
}
```

Then replace the dual-path `if (theme != null) ... else _getFdl...` with a single path using `_resolveTheme(context)`. This eliminates ALL 13 FDL fallback references and simplifies the code.

Changes:
1. Remove `_getFdlBackgroundColor`, `_getFdlBorderColor`, `_getFdlIconColor` static methods entirely.
2. Add `SkillTreeTheme _resolveTheme(BuildContext context)` method.
3. Rewrite `_getBackgroundColor()` -> `_getBackgroundColor(SkillTreeTheme resolvedTheme)` (no more conditional).
4. Rewrite `_getBorderColor()` -> `_getBorderColor(SkillTreeTheme resolvedTheme)`.
5. Rewrite `_getIconColor()` -> `_getIconColor(SkillTreeTheme resolvedTheme)`.
6. Update `build()` to call `final resolvedTheme = _resolveTheme(context)` once, pass to all helpers.
7. Update `_buildShadows()` -- line 216 has `?? FiftyColors.primary` fallback, replace with `resolvedTheme.availableNodeBorderColor`.
8. Update `_buildLevelBadge()` -- line 316 has `FiftyColors.cream`, replace with `resolvedTheme.nodeLevelStyle?.color ?? colorScheme.onSurface`.

#### Step 3.3: skill_tooltip.dart -- Fix FDL defaults

Same strategy: resolve theme from context when null.

Changes:
1. Remove all 6 `static` FDL default properties (`_fdlTooltipBackground`, `_fdlTooltipBorder`, `_fdlTitleStyle`, `_fdlDescriptionStyle`, `_fdlCostStyle`, `_fdlLevelStyle`).
2. Add `SkillTreeTheme _resolveTheme(BuildContext context)` method.
3. Rewrite `build()` to use resolved theme for all properties.
4. Rewrite `_buildCostLine()`, `_buildLevelLine()`, `_buildPrerequisitesLine()`, `_buildStateIndicator()`, `_getStateInfo()`, `_getProgressColor()` -- all take `SkillTreeTheme` instead of using static fallbacks.
5. **`_getStateInfo`** (line 291-301): Uses `FiftyColors.slateGrey`/`success`/`primary`/`warning` for state badge colors. These map to theme properties:
   - Locked -> `resolvedTheme.lockedNodeBorderColor`
   - Available -> `resolvedTheme.availableNodeBorderColor`
   - Unlocked -> `resolvedTheme.unlockedNodeBorderColor`
   - Maxed -> `resolvedTheme.maxedNodeBorderColor`
6. **`_getProgressColor`** (line 305-316): Same mapping as above.
7. **`_buildCostLine`** line 184: `FiftyColors.burgundy` for insufficient funds -> `colorScheme.error`.
8. **`_buildLevelLine`** line 232: `FiftyColors.surfaceDark` for progress background -> `colorScheme.surfaceContainerHighest`.

#### Step 3.4: connection_painter.dart -- Fix FDL defaults

`ConnectionPainter` is a `CustomPainter` -- no BuildContext available. Current code:

```dart
static Color get _fdlLockedColor => FiftyColors.borderDark;
static Color get _fdlUnlockedColor => FiftyColors.success;
static Color get _fdlHighlightColor => FiftyColors.primary;
```

These are used as fallbacks when `theme == null`. The caller (`SkillTreeView`) creates the painter in `build()` and always passes `widget.controller.theme`.

**Strategy:** If `SkillTreeView` always passes a resolved theme (using `fromContext` when controller.theme is null), the painter's fallbacks become unreachable. But as defensive code, change the static defaults to constructor-injected defaults:

1. Add optional `defaultLockedColor`, `defaultUnlockedColor`, `defaultHighlightColor` constructor params.
2. In `SkillTreeView`, when constructing `ConnectionPainter`, resolve these from context if `theme` is null.
3. Remove the 3 `static Color get _fdl...` getters.

**Alternatively, simpler:** Since `SkillTreeView.build()` has context, resolve the theme there and always pass it to the painter. Then the painter's null-theme path never fires. The static FDL defaults can be replaced with reasonable Material defaults (`Colors.grey`, `Colors.green`, `Colors.blue`) for safety.

**Choosing the simpler path:** Resolve theme in SkillTreeView, pass to painter. Update the 3 static defaults to non-FiftyColors values as a safety net.

### Phase 4: fifty_forms (3 field files)

**Approach:** The date/time picker overrides are the most nuanced. The current code builds a full `Theme()` wrapper that OVERRIDES the consumer's colorScheme with FiftyColors. This defeats theme customization.

#### Step 4.1: time_form_field.dart

The `_showTimePicker()` method at line 132 does:

```dart
Theme(
  data: theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      primary: FiftyColors.primary,
      surface: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      onSurface: isDark ? Colors.white : FiftyColors.darkBurgundy,
    ),
    dialogTheme: DialogThemeData(backgroundColor: ...),
    textButtonTheme: TextButtonThemeData(style: ...),
    timePickerTheme: TimePickerThemeData(...),
  ),
  child: child!,
)
```

**Fix:** Remove the entire FiftyColors override. The consumer's theme already defines these colors. The picker should use the theme as-is. Replace with:

```dart
Theme(
  data: theme.copyWith(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontWeight: FiftyTypography.medium,
        ),
      ),
    ),
  ),
  child: MediaQuery(
    data: MediaQuery.of(context).copyWith(
      alwaysUse24HourFormat: widget.use24HourFormat,
    ),
    child: child!,
  ),
)
```

This keeps the font styling (structural token, acceptable) but removes all color overrides.

Lines affected: 140-168 (delete most of the colorScheme.copyWith, dialogTheme, timePickerTheme overrides).

Also: **Line 211** -- the suffix icon uses `FiftyColors.slateGrey` conditionally. Replace with `colorScheme.onSurfaceVariant`.

#### Step 4.2: date_form_field.dart

Same pattern as time_form_field. The `_showDatePicker()` at line 160:

**Fix:** Remove colorScheme overrides, keep font styling only.

Lines affected: 164-176. Also **line 219** -- suffix icon color.

#### Step 4.3: file_form_field.dart

Lines 63-66 use explicit `isDark ? FiftyColors.borderDark : FiftyColors.borderLight` pattern.

**Fix:** Replace with colorScheme lookups:
- `borderColor` -> `colorScheme.outline`
- `fillColor` -> `colorScheme.surfaceContainerHighest`
- `textColor` -> `colorScheme.onSurfaceVariant`

### Phase 5: Tests

#### 5.1: fifty_connectivity tests

Create `packages/fifty_connectivity/test/widgets/connection_handler_test.dart`:
- Test `_buildOfflineWidget` renders with custom theme's error color
- Test `_buildConnectingWidget` renders with custom theme's onSurfaceVariant
- Wrap widget in `MaterialApp` with custom theme, verify colors via `find.byType(Icon)` + tester

Create `packages/fifty_connectivity/test/widgets/connection_overlay_test.dart`:
- Test `OfflineStatusCard` uses colorScheme.error for icons and title
- Test `UplinkStatusBar` uses colorScheme.onSurfaceVariant for connecting state

#### 5.2: fifty_achievement_engine tests

Create `packages/fifty_achievement_engine/test/widgets/achievement_card_test.dart`:
- Test default rarity colors: common uses colorScheme.onSurfaceVariant
- Test default rarity colors: uncommon uses colorScheme.tertiary
- Test custom `rarityColors` parameter overrides defaults
- Test rare/epic/legendary retain hardcoded hex values

Create `packages/fifty_achievement_engine/test/widgets/achievement_popup_test.dart`:
- Test popup rarity colors respect theme

#### 5.3: fifty_skill_tree tests

Create `packages/fifty_skill_tree/test/themes/skill_tree_theme_test.dart`:
- Test `fromContext()` reads colorScheme.primary for availableNodeBorderColor
- Test `fromContext()` reads colorScheme.tertiary for unlockedNodeBorderColor
- Test `fromContext(warningColor: X)` uses custom warning
- Test `fromContext()` falls back to colorScheme.error when no FiftyThemeExtension

Create `packages/fifty_skill_tree/test/widgets/skill_node_widget_theme_test.dart`:
- Test widget with null theme resolves from context
- Test widget with explicit theme uses that theme

#### 5.4: fifty_forms tests

No new test files needed. The forms package has no test directory currently. The fix removes hardcoded overrides, making the pickers inherit theme -- this is inherently correct behavior. Verify via `flutter analyze` only.

### Phase 6: Verification

1. Run `flutter analyze` on all 4 affected packages:
   ```
   cd packages/fifty_connectivity && flutter analyze
   cd packages/fifty_achievement_engine && flutter analyze
   cd packages/fifty_skill_tree && flutter analyze
   cd packages/fifty_forms && flutter analyze
   ```
2. Run existing tests:
   ```
   cd packages/fifty_connectivity && flutter test
   cd packages/fifty_skill_tree && flutter test
   ```
3. Run new tests.
4. Verify no remaining FiftyColors refs in widget build methods:
   ```
   grep -r "FiftyColors\." packages/{fifty_connectivity,fifty_achievement_engine,fifty_skill_tree,fifty_forms}/lib/src/widgets/
   grep -r "FiftyColors\." packages/fifty_forms/lib/src/fields/
   ```

---

## Testing Strategy

| Package | Approach | Test Type |
|---------|----------|-----------|
| fifty_connectivity | Widget tests: wrap in MaterialApp with custom colorScheme, verify Icon/Text colors | Widget |
| fifty_achievement_engine | Widget tests: verify rarity color resolution with and without custom map | Widget |
| fifty_skill_tree | Unit test: `fromContext()` factory + Widget test: null-theme resolves from context | Unit + Widget |
| fifty_forms | Manual verification + `flutter analyze` (no test infrastructure exists) | Analyzer |

**Test helper pattern:** Each test creates a `MaterialApp` with a known `ThemeData(colorScheme: ColorScheme.dark(primary: Colors.red, ...))` and asserts widgets use those exact colors.

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| fifty_forms breaking change -- removing picker color overrides may change visual appearance for existing consumers | Medium | Low | The consumer's own theme now takes effect, which is the CORRECT behavior. Document in AC-006 migration guide. |
| skill_tree `fromContext` adds `material.dart` import, widening the dependency surface | Low | Low | `material.dart` is already transitively imported via `painting.dart` and is standard Flutter. No actual new dependency added to pubspec. |
| FiftyColors.warning has no colorScheme equivalent -- skill_tree `fromContext` defaults to colorScheme.error | Low | Medium | Accept optional `warningColor` param in `fromContext`. Consumers using fifty_theme can pass `extension.warning`. |
| `FiftyLoadingIndicator` color param in connectivity accepts a Color -- passing colorScheme value means it's no longer const | Low | Low | Non-breaking; the loading indicator was never const-constructed. |
| OfflineStatusCard's `const Icon(...)` with FiftyColors.burgundy becomes non-const when switching to colorScheme.error | Low | Low | Remove `const` keyword. No user-facing impact. |
| fifty_forms has no test directory -- changes are unverified by automated tests | Medium | Low | `flutter analyze` catches type errors. The change is mechanical (removing overrides). AC-006 can add form tests. |
| Achievement engine has no test directory -- changes are unverified | Medium | Medium | Create basic widget tests as part of this brief. The rarity color logic is testable. |
| `UplinkStatusBar._buildStatusBadge()` needs context threading | Low | Low | Simple method signature change; builder pattern already established in the codebase. |

---

## Brief Scope Expansion Note

The original brief listed **3 files to modify** and marked fifty_forms as "clean". The actual audit found:

- **12 files to modify** (10 source + new tests)
- **72 total violations** (10 connectivity + 6 achievement + 35 skill_tree + 21 forms)
- fifty_forms has **21 FiftyColors violations** across 3 files

Recommendation: Update AC-005 brief to include fifty_forms, OR create a separate AC-005b brief for forms alignment. Given the mechanical nature of the forms changes (removing Theme overrides), including them in AC-005 is efficient.

---

## ColorScheme Mapping Reference (AC-003 established)

| FiftyColors token | ColorScheme role | Notes |
|-------------------|-----------------|-------|
| `FiftyColors.primary` (burgundy) | `colorScheme.primary` | Brand color |
| `FiftyColors.burgundy` | `colorScheme.error` | Error/alert context |
| `FiftyColors.cream` | `colorScheme.onPrimary` or `onSurface` | Text on dark/light |
| `FiftyColors.darkBurgundy` | `colorScheme.surface` (dark) | Deep background |
| `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` | Secondary text |
| `FiftyColors.hunterGreen` | `colorScheme.tertiary` | Success/positive |
| `FiftyColors.success` | `colorScheme.tertiary` | Same as hunterGreen |
| `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` | Elevated surface |
| `FiftyColors.surfaceLight` | `colorScheme.surfaceContainerHighest` | Light equivalent |
| `FiftyColors.borderDark` | `colorScheme.outline` | Borders |
| `FiftyColors.borderLight` | `colorScheme.outline` | Borders (light) |
| `FiftyColors.powderBlush` | `extension.accent` | Mode-aware accent |
| `FiftyColors.warning` | `extension.warning` | No colorScheme equivalent |
| `FiftyColors.error` | `colorScheme.error` | Error states |

---

## Execution Order

The phases can be executed in any order (no inter-phase dependencies), but the recommended sequence is:

1. **Phase 1** (connectivity) -- smallest, builds confidence
2. **Phase 4** (forms) -- mechanical removal, low risk
3. **Phase 2** (achievement engine) -- moderate, adds new parameter
4. **Phase 3** (skill tree) -- largest and most complex
5. **Phase 5** (tests) -- validate all changes
6. **Phase 6** (verification) -- final check
