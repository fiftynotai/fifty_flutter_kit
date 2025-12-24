# BR-009: fifty_theme Package - Theme System Foundation

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-25
**Completed:** 2025-12-25

---

## Problem

**What's broken or missing?**

The fifty.dev ecosystem has `fifty_tokens` (pure design tokens) but lacks a theme layer that converts these tokens into Flutter's `ThemeData`. Developers cannot easily apply the Fifty Design Language (FDL) to their Flutter applications without manually constructing themes from raw tokens.

**Why does it matter?**

- `fifty_tokens` provides raw values but no Flutter integration
- Each project would need to duplicate theme construction logic
- Inconsistent theme application across the ecosystem
- No dark mode support without a unified theme system

---

## Goal

**What should happen after this brief is completed?**

A `fifty_theme` package exists that:
1. Depends on `fifty_tokens` for all design values
2. Exports `FiftyTheme` class with `light()` and `dark()` factory methods
3. Provides complete `ThemeData` objects ready for `MaterialApp`
4. Follows FDL specification for kinetic brutalism aesthetic
5. Zero additional dependencies beyond Flutter SDK and fifty_tokens

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_theme/` (new package)

### Layers Touched
- [x] Model (domain objects - ThemeData construction)
- [ ] View (UI widgets)
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)

### API Changes
- [x] No API changes (pure Flutter package)

### Dependencies
- [x] Existing package: `fifty_tokens` (design token source)
- [x] Flutter SDK: `ThemeData`, `ColorScheme`, `TextTheme`

### Related Files
- `packages/fifty_tokens/lib/fifty_tokens.dart` (token source)
- `packages/fifty_theme/lib/fifty_theme.dart` (new - main export)
- `packages/fifty_theme/lib/src/fifty_theme_data.dart` (new - theme construction)

---

## Constraints

### Architecture Rules
- Must consume `fifty_tokens` for ALL color/typography/spacing values
- No hardcoded design values in fifty_theme
- Pure function approach: tokens in → ThemeData out
- Must support both light and dark themes

### Technical Constraints
- Zero external dependencies (only Flutter SDK + fifty_tokens)
- All theme values must be `const` where possible
- Must work with Flutter 3.x stable

### Out of Scope
- Custom widgets (that's `fifty_ui`)
- Component-level theming (that's `fifty_ui`)
- Platform-specific adaptations (future enhancement)

---

## Tasks

### Pending
- [ ] Task 1: Create package structure (`packages/fifty_theme/`)
- [ ] Task 2: Set up `pubspec.yaml` with fifty_tokens dependency
- [ ] Task 3: Implement `FiftyColorScheme` (light/dark from tokens)
- [ ] Task 4: Implement `FiftyTextTheme` (from typography tokens)
- [ ] Task 5: Implement `FiftyTheme` class with factory methods
- [ ] Task 6: Create barrel export file
- [ ] Task 7: Write comprehensive tests
- [ ] Task 8: Write README documentation

### In Progress
_(None yet)_

### Completed
_(None yet)_

---

## Session State (Tactical - This Brief)

**Current State:** BUILDING phase - coder agent invoked
**Next Steps When Resuming:** Await coder result, then invoke tester
**Last Updated:** 2025-12-25
**Blockers:** None

### Workflow State
- **Phase:** COMPLETE
- **Active Agent:** none
- **Retry Count:** 0

### Agent Log
- [2025-12-25 INIT] Brief loaded, status updated to In Progress
- [2025-12-25 INIT] Branch created: implement/BR-009-fifty-theme
- [2025-12-25 PLANNING] Invoking planner agent...
- [2025-12-25 PLANNING] Plan received - 10 phases, 16 files, 40+ tests
- [2025-12-25 APPROVAL] Awaiting Monarch approval (L-complexity)
- [2025-12-25 APPROVAL] Monarch approved plan
- [2025-12-25 BUILDING] Invoking coder agent...
- [2025-12-25 BUILDING] Coder complete - 11 files created
- [2025-12-25 TESTING] Invoking tester agent...
- [2025-12-25 TESTING] PASS - 109 tests, 0 failures
- [2025-12-25 REVIEWING] Invoking reviewer agent...
- [2025-12-25 REVIEWING] APPROVE - ready for commit
- [2025-12-25 COMMITTING] Creating commit...
- [2025-12-25 COMPLETE] Committed: 1dfbd15 - Brief Done

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `packages/fifty_theme/` directory exists with proper structure
2. [ ] `FiftyTheme.light()` returns valid `ThemeData` for light mode
3. [ ] `FiftyTheme.dark()` returns valid `ThemeData` for dark mode
4. [ ] All colors sourced from `FiftyColors` tokens
5. [ ] All typography sourced from `FiftyTypography` tokens
6. [ ] All spacing/radii sourced from `FiftySpacing`/`FiftyRadii` tokens
7. [ ] `flutter analyze` passes (zero issues)
8. [ ] `flutter test` passes (all tests green)
9. [ ] README with usage examples exists
10. [ ] Can be used in example app: `theme: FiftyTheme.dark()`

---

## Test Plan

### Automated Tests
- [ ] Unit test: `FiftyTheme.light()` produces valid ThemeData
- [ ] Unit test: `FiftyTheme.dark()` produces valid ThemeData
- [ ] Unit test: ColorScheme matches FiftyColors tokens
- [ ] Unit test: TextTheme matches FiftyTypography tokens
- [ ] Unit test: Theme extensions applied correctly

### Manual Test Cases

#### Test Case 1: Light Theme Application
**Preconditions:** Example Flutter app exists
**Steps:**
1. Set `theme: FiftyTheme.light()` in MaterialApp
2. Run the application
3. Verify surfaces are light, text is dark

**Expected Result:** App renders with light FDL theme
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Dark Theme Application
**Preconditions:** Example Flutter app exists
**Steps:**
1. Set `theme: FiftyTheme.dark()` in MaterialApp
2. Run the application
3. Verify surfaces are dark (void black), crimson accents visible

**Expected Result:** App renders with kinetic brutalism dark theme
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [ ] New files created:
  - `packages/fifty_theme/pubspec.yaml`
  - `packages/fifty_theme/lib/fifty_theme.dart`
  - `packages/fifty_theme/lib/src/fifty_theme_data.dart`
  - `packages/fifty_theme/lib/src/color_scheme.dart`
  - `packages/fifty_theme/lib/src/text_theme.dart`
  - `packages/fifty_theme/test/` (test files)
  - `packages/fifty_theme/README.md`
  - `packages/fifty_theme/CHANGELOG.md`

### Documentation Updates
- [ ] README with usage examples
- [ ] API documentation (dartdoc comments)
- [ ] CHANGELOG with v0.1.0 entry

---

## Notes

**Design Philosophy:**
- fifty_tokens = raw ingredients (values)
- fifty_theme = recipe (ThemeData construction)
- fifty_ui = finished dish (themed components)

**FDL Theme Characteristics:**
- Dark mode primary (void black #0A0A0A)
- Crimson pulse accents (#DC143C)
- High contrast text (terminal white #F5F5F5)
- Minimal elevation, crimson glow instead of shadows
- Monument Extended + JetBrains Mono typography

---

**Created:** 2025-12-25
**Last Updated:** 2025-12-25
**Brief Owner:** Igris AI
