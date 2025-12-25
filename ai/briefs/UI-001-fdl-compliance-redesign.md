# UI-001: FDL Compliance Redesign

**Type:** Refactor
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2025-12-25
**Completed:** —

---

## Problem

**What's broken or missing?**

The fifty_ui components have several FDL (Fifty Design Language) violations discovered during design audit:

1. **Spinner Usage:** `FiftyLoadingIndicator` and `FiftyButton` loading state use `CircularProgressIndicator` - FDL explicitly bans spinners
2. **Fade Animations:** `FiftyDialog` and `FiftySnackbar` use fade transitions - FDL says "NO FADES"
3. **Missing Terminal Aesthetic:** `FiftyTextField` lacks terminal cursor (`_` blink), `FiftyCard` lacks scanline hover effect

**Why does it matter?**

- Components don't fully embody the "Kinetic Brutalism" aesthetic
- Violates core FDL principles documented in design spec
- Inconsistent with the ecosystem's design philosophy

---

## Goal

**What should happen after this brief is completed?**

All fourteen fifty_ui components fully comply with FDL specification:
1. No spinners - text-based loading (`"> LOADING..."`)
2. No fades - slides, wipes, reveals only
3. Terminal aesthetic where appropriate (cursor, scanlines)
4. Kinetic, mechanical feel in all animations

---

## Context & Inputs

### Affected Components

**P0 - Critical Violations:**
- [ ] `FiftyLoadingIndicator` - Complete rewrite (spinner → text)
- [ ] `FiftyButton` - Loading state fix

**P1 - Motion Violations:**
- [ ] `FiftyDialog` - Remove FadeTransition
- [ ] `FiftySnackbar` - Slide animation

**P2 - Missing Effects:**
- [ ] `FiftyCard` - Add scanline hover effect
- [ ] `FiftyTextField` - Terminal cursor

**P3 - Polish:**
- [ ] `FiftyBadge` - Step-based pulse
- [ ] `FiftyChip` - Scale animation
- [ ] `FiftyProgressBar` - Segmented option
- [ ] `FiftyDataSlate` - Typing animation option
- [ ] `FiftyTooltip` - Slide animation

### FDL Requirements

```
Loading: Never use a spinner. Use text sequences:
  > INITIALIZING...
  > LOADING ASSETS...
  > DONE.

NO FADES. Use slides, wipes, reveals.

Inputs: Look like terminal command lines (_blinking cursor)

Cards: Hovering triggers a scanline effect
```

### Dependencies
- fifty_tokens (design tokens)
- fifty_theme (theme extension)

---

## Constraints

### Architecture Rules
- Maintain backwards compatibility (new params optional)
- All changes must use FiftyThemeExtension tokens
- Respect reduced-motion accessibility settings

### Technical Constraints
- No external dependencies
- Performance: animations must be smooth (60fps)
- Touch targets minimum 44x44px

### Out of Scope
- New components
- API breaking changes

---

## Tasks

### Pending
- [ ] Task 1: Rewrite FiftyLoadingIndicator (text-based sequence)
- [ ] Task 2: Fix FiftyButton loading state (text instead of spinner)
- [ ] Task 3: Remove FadeTransition from FiftyDialog
- [ ] Task 4: Replace FiftySnackbar fade with slide
- [ ] Task 5: Add scanline hover effect to FiftyCard
- [ ] Task 6: Add terminal cursor to FiftyTextField
- [ ] Task 7: Enhance FiftyBadge with step-based pulse
- [ ] Task 8: Add scale animation to FiftyChip
- [ ] Task 9: Add segmented option to FiftyProgressBar
- [ ] Task 10: Update tests for all modified components
- [ ] Task 11: Update example app to showcase new effects

### In Progress
_(None yet)_

### Completed
_(None yet)_

---

## Session State (Tactical - This Brief)

**Current State:** BUILDING phase - ARTISAN agent invoked
**Next Steps When Resuming:** Await ARTISAN result, then test
**Last Updated:** 2025-12-25
**Blockers:** None

### Workflow State
- **Phase:** BUILDING
- **Active Agent:** coder (ARTISAN mode)
- **Retry Count:** 0

### Agent Log
- [2025-12-25 INIT] Brief registered: UI-001
- [2025-12-25 INIT] Branch created: implement/UI-001-fdl-redesign
- [2025-12-25 BUILDING] Invoking ARTISAN (coder in UI mode)...
- [2025-12-25 BUILDING] ARTISAN complete - 7 files modified, 92 tests passing
- [2025-12-25 TESTING] Invoking tester agent...
- [2025-12-25 TESTING] PASS - 92 tests, 0 FDL violations remaining
- [2025-12-25 REVIEWING] Invoking reviewer agent...
- [2025-12-25 REVIEWING] APPROVE - Quality 9/10, FDL compliant
- [2025-12-25 COMMITTING] Creating commit...

---

## Acceptance Criteria

**The refactor is complete when:**

1. [ ] No spinner widgets exist in any component
2. [ ] No FadeTransition used anywhere
3. [ ] FiftyLoadingIndicator shows text sequence
4. [ ] FiftyButton loading shows `"..."` or text
5. [ ] FiftyDialog uses pure slide/scale transition
6. [ ] FiftySnackbar slides in (no fade)
7. [ ] FiftyCard has scanline effect on hover
8. [ ] FiftyTextField has terminal cursor option
9. [ ] `dart analyze` passes (zero issues)
10. [ ] `flutter test` passes (all tests green)
11. [ ] Reduced-motion settings respected

---

## Test Plan

### Automated Tests
- [ ] Widget test: FiftyLoadingIndicator shows text sequence
- [ ] Widget test: FiftyButton loading shows text, not spinner
- [ ] Widget test: No CircularProgressIndicator in widget tree
- [ ] Widget test: Animations respect reduced-motion
- [ ] Widget test: Scanline effect triggers on hover

### Manual Test Cases

#### Test Case 1: Loading Indicator
**Steps:**
1. Display FiftyLoadingIndicator
2. Observe animation

**Expected Result:** Text sequence `"> LOADING..."` with dots animation, no spinner

#### Test Case 2: Dialog Animation
**Steps:**
1. Open FiftyDialog
2. Close FiftyDialog

**Expected Result:** Slide/scale only, no fade effect

---

## Delivery

### Code Changes
- [ ] Modified: `lib/src/display/fifty_loading_indicator.dart` (rewrite)
- [ ] Modified: `lib/src/buttons/fifty_button.dart`
- [ ] Modified: `lib/src/feedback/fifty_dialog.dart`
- [ ] Modified: `lib/src/feedback/fifty_snackbar.dart`
- [ ] Modified: `lib/src/containers/fifty_card.dart`
- [ ] Modified: `lib/src/inputs/fifty_text_field.dart`
- [ ] Modified: `lib/src/display/fifty_badge.dart`
- [ ] Modified: `lib/src/display/fifty_chip.dart`
- [ ] Modified: `lib/src/display/fifty_progress_bar.dart`
- [ ] Modified: Test files for above components

---

## Notes

**FDL Philosophy:**
- "Kinetic Brutalism" - mechanical, purposeful motion
- Terminal/command-line aesthetic
- Physical "data cartridge" feel
- No decorative animations - every motion has purpose

**Reference:**
- FDL Specification in docs/
- fifty_tokens for motion durations
- fifty_theme for glow effects

---

**Created:** 2025-12-25
**Last Updated:** 2025-12-25
**Brief Owner:** Igris AI
