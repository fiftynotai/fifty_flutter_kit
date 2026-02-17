# BR-091: Achievement Engine Theme Awareness

**Type:** Bug
**Priority:** P2-Medium
**Effort:** S-Small (< 1d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's broken or missing?**

All widgets in `fifty_achievement_engine` use hardcoded dark colors (`FiftyColors.surfaceDark`, `FiftyColors.darkBurgundy`, `FiftyColors.borderDark`) instead of `Theme.of(context).colorScheme` tokens. This means achievement cards, summaries, popups, and progress bars remain dark regardless of the active theme mode.

The Tactical Grid app now supports light/dark theme switching (BR-090), but the achievement page cards stay dark in light mode because the engine package was built with only dark mode in mind.

**Why does it matter?**

Every other page in the app correctly responds to the theme toggle. The achievement page background is theme-aware (fixed in `7788862`), but the cards within it are stuck dark — broken visual consistency. As an engine package, `fifty_achievement_engine` should respect the host app's theme so any app consuming it gets correct theming out of the box.

---

## Goal

**What should happen after this brief is completed?**

All `fifty_achievement_engine` widgets use `Theme.of(context).colorScheme` tokens instead of hardcoded dark colors. Cards, summaries, popups, and progress bars automatically adapt to the host app's light/dark theme.

---

## Context & Inputs

### Affected Modules
- [x] Package: `packages/fifty_achievement_engine`

### Layers Touched
- [x] View (UI widgets — 4 widget files + 1 progress bar)

### API Changes
- [x] No API changes — existing `backgroundColor` / `borderColor` constructor overrides continue to work

### Dependencies
- [x] `fifty_tokens` (FiftyColors, FiftySpacing, FiftyRadii, FiftyMotion)
- [x] `fifty_theme` (FiftyThemeExtension — already a dependency)

### Hardcoded Colors to Replace

| File | Line | Current | Replacement |
|------|------|---------|-------------|
| `achievement_card.dart` | 107 | `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `achievement_card.dart` | 258 | `FiftyColors.darkBurgundy` | `colorScheme.surface` |
| `achievement_card.dart` | icon text (locked) | `FiftyColors.cream.withAlpha(0.5)` | `colorScheme.onSurface.withAlpha(128)` |
| `achievement_summary.dart` | 54 | `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `achievement_summary.dart` | 56 | `FiftyColors.borderDark` | `colorScheme.outline` |
| `achievement_summary.dart` | 104 | `Colors.white` | `colorScheme.onSurface` |
| `achievement_popup.dart` | 167 | `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `achievement_popup.dart` | 234 | `Colors.white` | `colorScheme.onSurface` |
| `achievement_progress_bar.dart` | 60 | `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |

---

## Constraints

### Architecture Rules
- Only change default fallback colors — preserve existing `backgroundColor`/`borderColor` constructor params
- Use `colorScheme` tokens, not FiftyColors constants, for all theme-sensitive colors
- Do not change rarity colors (these are semantic, not theme-dependent)

### Technical Constraints
- Must not break existing dark mode appearance (dark mode `surfaceContainerHighest` = `surfaceDark`)
- Must not break apps that pass explicit color overrides via constructor params
- Shadow colors (`Colors.black.withAlpha(...)`) can stay — shadows are theme-neutral

### Out of Scope
- Migrating to FiftyCard (structural change, separate brief if desired)
- Changing rarity badge colors or achievement status colors
- Adding new theme extension properties

---

## Tasks

### Pending
- [ ] Task 1: Replace hardcoded dark colors in `achievement_card.dart` (background + icon)
- [ ] Task 2: Replace hardcoded dark colors in `achievement_summary.dart` (background + border + icon)
- [ ] Task 3: Replace hardcoded dark colors in `achievement_popup.dart` (background + icon)
- [ ] Task 4: Replace hardcoded dark color in `achievement_progress_bar.dart` (track)
- [ ] Task 5: Run `fifty_achievement_engine` tests (if any)
- [ ] Task 6: Run `tactical_grid` tests (consumer validation)
- [ ] Task 7: Visual smoke test — verify light/dark mode on achievement page

### In Progress

### Completed

---

## Acceptance Criteria

**The fix is complete when:**

1. [ ] Achievement cards use `colorScheme.surfaceContainerHighest` as default background
2. [ ] Locked icon containers use `colorScheme.surface` instead of `darkBurgundy`
3. [ ] Summary, popup, and progress bar widgets are theme-aware
4. [ ] Light mode: cards appear with light surface backgrounds
5. [ ] Dark mode: cards appear identical to current (no regression)
6. [ ] Existing `backgroundColor`/`borderColor` overrides still work
7. [ ] All tests pass
8. [ ] Visual verification on iOS simulator (light + dark)

---

## Test Plan

### Automated Tests
- [ ] Existing `fifty_achievement_engine` tests pass (if any)
- [ ] `tactical_grid` 382+ tests still pass

### Manual Test Cases

#### Test Case 1: Light Mode Achievement Cards
**Steps:**
1. Open Settings, set theme to Light
2. Navigate to Achievements page
3. Verify cards have light surface backgrounds
4. Verify rarity badge colors unchanged
5. Verify text is readable (dark on light)

**Expected Result:** Cards adapt to light theme

#### Test Case 2: Dark Mode Regression
**Steps:**
1. Open Settings, set theme to Dark
2. Navigate to Achievements page
3. Verify cards look identical to pre-fix appearance

**Expected Result:** No visual regression in dark mode

---

## Delivery

### Code Changes
- [ ] Modified files: 4 widget files in `packages/fifty_achievement_engine/lib/src/widgets/`
- [ ] New files: None
- [ ] Deleted files: None

---

## Notes

- `FiftyCard` already handles this correctly via `colorScheme.surfaceContainerHighest` — this brief brings the achievement engine's custom containers in line with that pattern
- The `backgroundColor` constructor params on each widget act as escape hatches for apps that need custom colors
- Consider a follow-up brief to audit all engine packages for similar hardcoded color issues

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
