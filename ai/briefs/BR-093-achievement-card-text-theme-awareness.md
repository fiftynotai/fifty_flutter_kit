# BR-093: Achievement Card Text Not Theme-Aware in Light Mode

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 2 hours)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's broken?**

Achievement card title and description text is nearly invisible in light mode. The `AchievementCard` widget in `fifty_achievement_engine` uses hardcoded `FiftyColors.cream` (a light/off-white color) for text, which blends into the light mode surface background. Rarity badges and header text are fine — only card body text is affected.

**Visual evidence:** `apps/tactical_grid/docs/screenshots/achievements_light.png` — all card titles ("First Blood", "Commander Slayer", etc.) and descriptions are barely readable.

**Why does it matter?**

Achievements page is completely unusable in light mode. Users cannot read any achievement names or descriptions.

---

## Goal

**What should happen after this brief is completed?**

Achievement card text is fully readable in both light and dark mode, using `colorScheme.onSurface` instead of hardcoded `FiftyColors.cream`.

---

## Context & Inputs

### Affected File
- `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart`

### Root Cause

4 hardcoded `FiftyColors.cream` references in text styles:

| Line | Location | Current Color | Fix |
|------|----------|---------------|-----|
| 184 | `_buildContent()` — achievement name | `FiftyColors.cream` | `colorScheme.onSurface` |
| 200 | `_buildContent()` — achievement description | `FiftyColors.cream.withValues(alpha: 0.7)` | `colorScheme.onSurface.withValues(alpha: 0.7)` |
| 144 | `_buildHiddenContent()` — hidden title | `FiftyColors.cream.withValues(alpha: 0.5)` | `colorScheme.onSurface.withValues(alpha: 0.5)` |
| 153 | `_buildHiddenContent()` — hidden description | `FiftyColors.cream.withValues(alpha: 0.3)` | `colorScheme.onSurface.withValues(alpha: 0.3)` |

### Pattern

Same issue that BR-091 fixed for background/border colors. BR-091 replaced `FiftyColors.surfaceDark`/`darkBurgundy`/`borderDark`/`Colors.white` with `colorScheme` tokens, but missed the `FiftyColors.cream` text color references.

---

## Constraints

- Must NOT change rarity badge colors (those are semantic, not theme-dependent)
- Must NOT change icon colors (already using `colorScheme.onSurface`)
- Must NOT change "Unlocked" text color (uses `FiftyColors.hunterGreen`, semantic)
- Constructor overrides must be preserved
- Existing tests must continue passing

---

## Tasks

### Pending
- [ ] Task 1: Replace 4 `FiftyColors.cream` text color refs with `colorScheme.onSurface` in `achievement_card.dart`
- [ ] Task 2: Run analyzer — 0 errors
- [ ] Task 3: Run tactical_grid tests — all passing
- [ ] Task 4: Smoke test on iOS simulator — verify light + dark mode text readable
- [ ] Task 5: Recapture `achievements_light.png` screenshot
- [ ] Task 6: Replace screenshot in `apps/tactical_grid/docs/screenshots/`
- [ ] Task 7: Commit

### In Progress

### Completed

---

## Acceptance Criteria

1. [ ] All 4 `FiftyColors.cream` references in `achievement_card.dart` replaced with `colorScheme.onSurface`
2. [ ] Achievement card text readable in both light and dark mode
3. [ ] Rarity badge colors unchanged
4. [ ] All tests passing
5. [ ] Updated `achievements_light.png` screenshot in README shows readable text

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Light Mode Readability
1. Launch tactical_grid on iOS simulator
2. Switch to light mode via Settings
3. Navigate to Achievements page
4. Verify all card titles and descriptions are clearly readable

#### Test Case 2: Dark Mode Unchanged
1. Switch to dark mode via Settings
2. Navigate to Achievements page
3. Verify cards look identical to pre-fix state

---

## Delivery

### Code Changes
- [ ] Modified: `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart` (4 line changes)
- [ ] Modified: `apps/tactical_grid/docs/screenshots/achievements_light.png` (recaptured)

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
