# BR-087: AI Difficulty "MEDIUM" Label Wraps to Two Lines

**Type:** Bug Fix
**Priority:** P3-Low
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-17
**Completed:** 2026-02-17

---

## Problem

**What's broken or missing?**

In the AI difficulty selection bottom sheet (`_GameModeSheet` in `menu_page.dart`), the three difficulty buttons (EASY, MEDIUM, HARD) are laid out in a `Row` with `Expanded` children. The "MEDIUM" label is too long for the available width and wraps to two lines, breaking the visual alignment of the button row.

**Why does it matter?**

The wrapped label looks visually broken and inconsistent with the other two buttons (EASY and HARD) which fit on a single line.

---

## Goal

**What should happen after this brief is completed?**

1. The "MEDIUM" label should display on a single line
2. All three difficulty buttons should be visually aligned and consistent

---

## Context & Inputs

### Affected Modules
- [ ] Other: `apps/tactical_grid` (menu page UI)

### Layers Touched
- [x] View (UI widgets) — `_GameModeSheet` in menu_page.dart

### API Changes
- [x] No API changes

### Related Files
- `apps/tactical_grid/lib/features/menu/menu_page.dart` — difficulty button row (lines 326-354), buttons use `FiftyButtonSize.medium` with `Expanded` in a `Row` constrained to `maxWidth: 280`

---

## Constraints

### Architecture Rules
- Must not change game logic or difficulty levels
- Must follow FDL component usage

### Out of Scope
- Changing difficulty level names or gameplay

---

## Tasks

### Pending
- [ ] Task 1: Fix "MEDIUM" label so it displays on a single line (options: reduce font size, use `FiftyButtonSize.small`, abbreviate to "MED", increase `maxWidth`, or add `overflow`/`maxLines` to button label)
- [ ] Task 2: Verify all three buttons look consistent
- [ ] Task 3: Run `flutter test` on tactical_grid

### In Progress

### Completed

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] "MEDIUM" label displays on a single line
2. [ ] All three difficulty buttons are visually aligned
3. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Difficulty Selection UI
**Preconditions:** App running, main menu visible
**Steps:**
1. Tap "NEW GAME"
2. Tap "VS AI"
3. Verify EASY, MEDIUM, HARD buttons all display on single lines

**Expected Result:** All labels on one line, consistent sizing
**Status:** [ ] Pass / [ ] Fail

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** M
