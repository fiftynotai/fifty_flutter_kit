# BR-051: Theme-Aware Colors Refactoring

**Type:** Refactoring
**Priority:** P1-High
**Effort:** L-Large
**Status:** Done

---

## Problem

Colors are currently used inconsistently across the ecosystem:

1. **fifty_ui components** use `FiftyColors.*` directly (117 occurrences in 29 files)
2. **fifty_demo** mixes `FiftyColors.*` with `colorScheme.*`
3. Semantic colors (success, warning) not available in theme
4. Light/dark mode requires manual color switching in components
5. Changing a color requires finding all usages across packages

This violates DRY principle and makes theme customization difficult.

---

## Goal

Centralize all color usage through the theme system:

1. **Single source of truth** - Colors defined once in `fifty_theme`
2. **Automatic theme-awareness** - Components adapt to light/dark automatically
3. **DRY compliance** - No hardcoded colors in UI components
4. **Easy customization** - Change colors in one place, affects entire ecosystem

---

## Architecture

```
┌─────────────────┐
│  fifty_tokens   │  ← Raw color values (FiftyColors)
│                 │     Only used by fifty_theme
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  fifty_theme    │  ← Maps tokens to:
│                 │     • ColorScheme (primary, surface, etc.)
│                 │     • FiftyThemeExtension (success, warning, accent)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    fifty_ui     │  ← Components use ONLY:
│                 │     • Theme.of(context).colorScheme
│                 │     • Theme.of(context).extension<FiftyThemeExtension>()
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│      Apps       │  ← Use colorScheme + extension
│  (fifty_demo)   │     Never import FiftyColors
└─────────────────┘
```

---

## Context & Inputs

### Files to Modify

**Phase 1: Enhance FiftyThemeExtension**
- `packages/fifty_theme/lib/src/theme_extensions.dart`

**Phase 2: Update fifty_ui components (29 files)**
- `lib/src/buttons/fifty_button.dart`
- `lib/src/buttons/fifty_icon_button.dart`
- `lib/src/containers/fifty_card.dart`
- `lib/src/controls/fifty_segmented_control.dart`
- `lib/src/display/fifty_avatar.dart`
- `lib/src/display/fifty_badge.dart`
- `lib/src/display/fifty_chip.dart`
- `lib/src/display/fifty_data_slate.dart`
- `lib/src/display/fifty_divider.dart`
- `lib/src/display/fifty_list_tile.dart`
- `lib/src/display/fifty_loading_indicator.dart`
- `lib/src/display/fifty_progress_bar.dart`
- `lib/src/display/fifty_progress_card.dart`
- `lib/src/display/fifty_stat_card.dart`
- `lib/src/feedback/fifty_dialog.dart`
- `lib/src/feedback/fifty_snackbar.dart`
- `lib/src/feedback/fifty_tooltip.dart`
- `lib/src/inputs/fifty_checkbox.dart`
- `lib/src/inputs/fifty_dropdown.dart`
- `lib/src/inputs/fifty_radio.dart`
- `lib/src/inputs/fifty_radio_card.dart`
- `lib/src/inputs/fifty_slider.dart`
- `lib/src/inputs/fifty_switch.dart`
- `lib/src/inputs/fifty_text_field.dart`
- `lib/src/molecules/fifty_code_block.dart`
- `lib/src/organisms/fifty_hero.dart`
- `lib/src/organisms/fifty_nav_bar.dart`
- `lib/src/utils/glow_container.dart`
- `lib/src/utils/halftone_painter.dart`

**Phase 3: Update fifty_demo**
- Remove all `FiftyColors.*` imports and usages
- Use `colorScheme` and `extension<FiftyThemeExtension>()` only

---

## Constraints

- Maintain visual consistency - no visible changes after refactoring
- Backward compatible - existing apps should work without changes
- No breaking API changes in fifty_ui
- Test both light and dark modes thoroughly

---

## Implementation Plan

### Phase 1: Enhance FiftyThemeExtension

Add semantic colors to the theme extension:

```dart
class FiftyThemeExtension extends ThemeExtension<FiftyThemeExtension> {
  // Existing
  final Color accent;

  // Add semantic colors
  final Color success;      // hunterGreen
  final Color warning;      // warning orange
  final Color info;         // slateGrey
  final Color highlight;    // powderBlush (dark) / burgundy tint (light)

  // Add component-specific colors if needed
  final Color switchTrack;
  final Color focusBorder;
}
```

### Phase 2: Update fifty_ui Components

**Color Mapping:**
| FiftyColors | ColorScheme / Extension |
|-------------|------------------------|
| `burgundy` | `colorScheme.primary` |
| `burgundyHover` | `colorScheme.primary` with opacity or extension |
| `cream` | `colorScheme.onPrimary` or `onSurface` |
| `darkBurgundy` | `colorScheme.surface` (dark) |
| `slateGrey` | `colorScheme.secondary` or `onSurfaceVariant` |
| `hunterGreen` | `extension.success` |
| `warning` | `extension.warning` |
| `powderBlush` | `extension.accent` |
| `surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `surfaceLight` | `colorScheme.surfaceContainerHighest` |
| `borderDark` | `colorScheme.outline` |
| `borderLight` | `colorScheme.outline` |

**Pattern for components:**
```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();

  // Use colorScheme.primary instead of FiftyColors.burgundy
  // Use fiftyTheme?.success instead of FiftyColors.hunterGreen
}
```

### Phase 3: Update fifty_demo

- Remove `import 'package:fifty_tokens/fifty_tokens.dart'` where only colors were used
- Replace all `FiftyColors.*` with appropriate `colorScheme.*` or `extension.*`

---

## Acceptance Criteria

- [x] FiftyThemeExtension includes success, warning, info, highlight colors
- [x] All 29 fifty_ui components use colorScheme/extension only
- [x] No `FiftyColors.*` usage in fifty_ui (except in tests for verification)
- [x] fifty_demo uses colorScheme/extension only (except color palette demo)
- [x] Light mode renders correctly with all components
- [x] Dark mode renders correctly with all components
- [x] No visual regressions from current state
- [x] flutter analyze passes with no errors

---

## Test Plan

**Automated:**
- Run `flutter analyze` on all packages
- Run existing widget tests

**Manual:**
1. Launch fifty_demo in dark mode - verify all screens
2. Switch to light mode - verify all screens adapt correctly
3. Test each fifty_ui component in both modes:
   - Buttons (primary, secondary, ghost, outline)
   - Cards, badges, chips
   - Form inputs (text field, checkbox, radio, switch, slider, dropdown)
   - Feedback (snackbar, dialog, tooltip)
   - Navigation (nav bar, segmented control)
   - Display (progress bar, stat card, list tile, avatar)

---

## Risks

- **High component count** - 29 files with 117 occurrences
- **Visual regression** - Colors might render slightly different
- **Missing extension** - Apps not using FiftyTheme won't have extension

**Mitigations:**
- Work file by file, test each component after changes
- Use side-by-side comparison in both modes
- Add null-safety fallbacks for extension access

---

## Delivery

- [ ] Phase 1: Enhance FiftyThemeExtension
- [ ] Phase 2: Update fifty_ui components (batch by category)
  - [ ] Buttons (2 files)
  - [ ] Containers (1 file)
  - [ ] Controls (1 file)
  - [ ] Display (10 files)
  - [ ] Feedback (3 files)
  - [ ] Inputs (7 files)
  - [ ] Molecules (1 file)
  - [ ] Organisms (2 files)
  - [ ] Utils (2 files)
- [ ] Phase 3: Update fifty_demo
- [ ] Final testing in both modes
- [ ] Update documentation

---

## References

- BR-050: Theme mode integration (completed)
- `packages/fifty_theme/lib/src/theme_extensions.dart`
- `packages/fifty_theme/lib/src/color_scheme.dart`
