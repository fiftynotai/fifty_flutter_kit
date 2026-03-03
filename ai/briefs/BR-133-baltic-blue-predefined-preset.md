# BR-133: Baltic Blue Predefined Preset + Multi-Theme README

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-03-03
**Completed:** 2026-03-03

---

## Problem

Baltic Blue exists only as hardcoded colors in the demo app's Actions class. It should be a predefined preset in the fifty_tokens package itself — ready-to-use out of the box. Additionally, the README doesn't highlight that the package supports multiple presets/themes, which is a major selling point.

---

## Goal

1. Add `FiftyPreset.balticBlue` as a second built-in preset in fifty_tokens
2. Add a `baltic_blue_preset.json` reference file alongside `fdl_v2_preset.json`
3. Update the README to feature multi-preset theming as a selling point
4. Update the demo app to use `FiftyPreset.balticBlue` instead of hardcoded colors

---

## Context

### Current Architecture

- `FiftyPreset.fdlV2` is a `static const` on `FiftyPreset` in `packages/fifty_tokens/lib/src/preset.dart`
- `FiftyTokens.load(preset)` loads a complete preset
- `FiftyTokens.configure(colors: ...)` does partial overrides
- JSON presets load via `FiftyPreset.fromMap(jsonDecode(json))`

### Baltic Blue Colors (confirmed working in BR-132)

| Name | Hex | Role |
|------|-----|------|
| Baltic Blue | `#586994` | primary |
| `#47567A` | primaryHover |
| Lavender Grey | `#7d869c` | secondary |
| `#656D80` | secondaryHover |
| Ash Grey | `#b4c4ae` | success |
| Cool Steel | `#a2abab` | accent |
| Cream | `#e5e8b6` | background |
| `#1A1D2B` | backgroundDark |
| `#D5D8A8` | surface |
| `#2A2D3B` | surfaceDark |
| `#e5e8b6` | onPrimary |
| `#1A1D2B` | onBackground |

---

## Implementation Plan

### 1. Add `FiftyPreset.balticBlue` to preset.dart

Add a second `static const` alongside `fdlV2` in `packages/fifty_tokens/lib/src/preset.dart`. Use the same structure — all 8 config categories. For non-color categories (typography, spacing, radii, motion, shadows, gradients, breakpoints), reuse FDL v2 values.

### 2. Create `baltic_blue_preset.json`

Copy `fdl_v2_preset.json`, update the colors section with Baltic Blue values. Place alongside it in the package root.

### 3. Update README

Add a section showcasing:
- Multiple built-in presets (`FiftyPreset.fdlV2`, `FiftyPreset.balticBlue`)
- How to switch presets at runtime (`FiftyTokens.load()`)
- How to create your own preset (JSON or Dart)
- Position as a selling point: "Ship multiple themes with zero boilerplate"

### 4. Update demo app

In `apps/fifty_demo/lib/features/tokens_demo/actions/tokens_demo_actions.dart`:
- Replace the hardcoded `balticBlueColors` with `FiftyPreset.balticBlue.colors`
- Use `FiftyTokens.load(FiftyPreset.balticBlue)` instead of `FiftyTokens.configure(colors: ...)`

### 5. Update demo app test

Update `apps/fifty_demo/test/features/tokens_demo/tokens_demo_view_model_test.dart` if any assertions depend on the configuration method.

---

## Acceptance Criteria

1. [ ] `FiftyPreset.balticBlue` is available as a static const in the package
2. [ ] `baltic_blue_preset.json` exists as a reference file
3. [ ] README features multi-preset theming with examples
4. [ ] Demo app uses the predefined preset instead of hardcoded colors
5. [ ] All existing fifty_tokens tests pass (317+)
6. [ ] Demo app tokens_demo tests still pass
7. [ ] `flutter analyze` passes with zero errors

---

## Constraints

- Baltic Blue only changes colors — reuse FDL v2 for all other categories
- Keep the preset const-constructible
- No new dependencies
- README should be concise — selling point, not a tutorial

---

## Dependencies

- BR-132 (Done) — Runtime palette switcher demo page

---

**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Brief Owner:** Fifty.ai
