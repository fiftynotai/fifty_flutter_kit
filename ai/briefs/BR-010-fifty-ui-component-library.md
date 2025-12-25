# BR-010: fifty_ui Package - Component Library

**Type:** Feature
**Priority:** P1-High
**Effort:** XL-Extra Large (>1w)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2025-12-25
**Completed:** —

---

## Problem

**What's broken or missing?**

The fifty.dev ecosystem has `fifty_tokens` (design tokens) and `fifty_theme` (ThemeData construction), but lacks a component library. Developers must manually create UI widgets that follow the Fifty Design Language (FDL) kinetic brutalism aesthetic. There are no pre-built components that leverage the theme system.

**Why does it matter?**

- No reusable FDL-compliant widgets exist
- Each project duplicates component implementations
- Inconsistent UI patterns across the ecosystem
- Kinetic brutalism aesthetic requires specific component behaviors (crimson glows, motion tokens, border outlines)
- Developers cannot quickly prototype FDL-styled interfaces

---

## Goal

**What should happen after this brief is completed?**

A `fifty_ui` package exists that:
1. Depends on `fifty_tokens` and `fifty_theme` for all design values
2. Exports FDL-styled widget components ready for use
3. Implements kinetic brutalism aesthetic (crimson glows, no drop shadows, border depth)
4. Supports accessibility standards (contrast ratios, semantic labels)
5. Provides both core primitives and composite components
6. Includes interactive examples and documentation

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_ui/` (new package)

### Layers Touched
- [x] View (UI widgets)
- [x] Model (component state/data models)
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)

### API Changes
- [x] No API changes (pure Flutter UI package)

### Dependencies
- [x] Existing package: `fifty_tokens` (design token source)
- [x] Existing package: `fifty_theme` (theme provider)
- [x] Flutter SDK: Material/Cupertino widgets as base

### Related Files
- `packages/fifty_tokens/lib/fifty_tokens.dart` (token source)
- `packages/fifty_theme/lib/fifty_theme.dart` (theme source)
- `packages/fifty_ui/lib/fifty_ui.dart` (new - main export)
- `packages/fifty_ui/lib/src/` (new - component implementations)

---

## Constraints

### Architecture Rules
- Must consume `fifty_theme` for ALL theming (no direct token access in widgets)
- Components access tokens via `Theme.of(context).extension<FiftyThemeExtension>()`
- No hardcoded colors, typography, or spacing values
- All animations use `FiftyMotion` tokens
- Must follow FDL principles: kinetic brutalism, zero elevation, crimson glow focus states

### Technical Constraints
- Zero external dependencies (only Flutter SDK + fifty ecosystem packages)
- Accessibility: All interactive components must meet WCAG 2.1 AA standards
- All widgets must be `const`-constructible where possible
- Must work with Flutter 3.x stable

### FDL Component Principles
- **No drop shadows** - Use border outlines and crimson glow for depth
- **Binary typography** - Hype (Monument Extended) for headers, Logic (JetBrains Mono) for data
- **Crimson focus states** - All interactive elements glow crimson on focus/hover
- **Dark-first design** - Primary theme is dark, light is accessibility variant
- **Motion tokens** - Instant (0ms), Fast (150ms), Compiling (300ms), SystemLoad (800ms)

### Out of Scope
- Platform-specific components (iOS/Android native styling)
- Complex composite screens (those would be in app-level code)
- Data fetching or state management (pure presentation layer)
- Navigation components (use Flutter's built-in)

---

## Proposed Components

### Tier 1: Core Primitives (Must Have)
| Component | Description | Priority |
|-----------|-------------|----------|
| `FiftyButton` | Primary/secondary/ghost button variants | P0 |
| `FiftyIconButton` | Icon-only button with glow states | P0 |
| `FiftyTextField` | Text input with focus glow | P0 |
| `FiftyCard` | Container with border outline (no shadow) | P0 |
| `FiftyChip` | Tag/label component | P1 |
| `FiftyDivider` | Themed horizontal/vertical dividers | P1 |

### Tier 2: Data Display (Should Have)
| Component | Description | Priority |
|-----------|-------------|----------|
| `FiftyDataSlate` | Key-value display panel (terminal style) | P1 |
| `FiftyBadge` | Status indicator with glow | P1 |
| `FiftyAvatar` | User/entity avatar with border | P2 |
| `FiftyProgressBar` | Linear progress with crimson fill | P2 |
| `FiftyLoadingIndicator` | Pulsing crimson loader | P2 |

### Tier 3: Feedback (Nice to Have)
| Component | Description | Priority |
|-----------|-------------|----------|
| `FiftySnackbar` | Toast notification | P2 |
| `FiftyDialog` | Modal dialog with border glow | P2 |
| `FiftyTooltip` | Hover tooltip | P3 |

---

## Tasks

### Pending
- [ ] Task 1: Create package structure (`packages/fifty_ui/`)
- [ ] Task 2: Set up `pubspec.yaml` with ecosystem dependencies
- [ ] Task 3: Create base widget mixin for theme access
- [ ] Task 4: Implement `FiftyButton` with all variants
- [ ] Task 5: Implement `FiftyIconButton`
- [ ] Task 6: Implement `FiftyTextField` with focus glow
- [ ] Task 7: Implement `FiftyCard` with border outline
- [ ] Task 8: Implement `FiftyChip`
- [ ] Task 9: Implement `FiftyDivider`
- [ ] Task 10: Implement `FiftyDataSlate`
- [ ] Task 11: Implement `FiftyBadge`
- [ ] Task 12: Write comprehensive tests for each component
- [ ] Task 13: Create example gallery app
- [ ] Task 14: Write README documentation with component previews

### In Progress
_(None yet)_

### Completed
_(None yet)_

---

## Session State (Tactical - This Brief)

**Current State:** COMMITTING phase - creating commit
**Next Steps When Resuming:** Verify commit, update status to Done
**Last Updated:** 2025-12-25
**Blockers:** None

### Workflow State
- **Phase:** COMMITTING
- **Active Agent:** none
- **Retry Count:** 0

### Agent Log
- [2025-12-25 INIT] Brief loaded, status updated to In Progress
- [2025-12-25 INIT] Branch created: implement/BR-010-fifty-ui
- [2025-12-25 PLANNING] Invoking planner agent...
- [2025-12-25 PLANNING] Plan received - 8 phases, 23+ files, 14 components
- [2025-12-25 APPROVAL] Awaiting Monarch approval (XL-complexity)
- [2025-12-25 APPROVAL] Monarch approved plan
- [2025-12-25 BUILDING] Invoking coder agent...
- [2025-12-25 BUILDING] Coder complete - 37 files created, 14 components, 85 tests
- [2025-12-25 TESTING] Invoking tester agent...
- [2025-12-25 TESTING] PASS - 85 tests, 0 failures, 0 analysis issues
- [2025-12-25 REVIEWING] Invoking reviewer agent...
- [2025-12-25 REVIEWING] APPROVE - Quality 9/10, 0 blockers, ready for commit
- [2025-12-25 COMMITTING] Creating commit...

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `packages/fifty_ui/` directory exists with proper structure
2. [ ] All Tier 1 (P0/P1) components implemented
3. [ ] All components consume theme via `FiftyThemeExtension`
4. [ ] Focus states use crimson glow effect
5. [ ] No hardcoded design values in any component
6. [ ] `dart analyze` passes (zero issues)
7. [ ] `flutter test` passes (all tests green)
8. [ ] Each component has widget tests
9. [ ] README with component gallery/examples exists
10. [ ] Example app demonstrates all components

---

## Test Plan

### Automated Tests
- [ ] Widget test: Each component renders without errors
- [ ] Widget test: Theme values applied correctly
- [ ] Widget test: Focus/hover states trigger glow
- [ ] Widget test: Accessibility semantics present
- [ ] Golden tests: Component appearance matches FDL spec

### Manual Test Cases

#### Test Case 1: Button Variants
**Preconditions:** Example app running with dark theme
**Steps:**
1. View button gallery section
2. Tap each button variant
3. Observe focus/tap states

**Expected Result:** Crimson glow on interaction, no drop shadows
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Text Field Focus
**Preconditions:** Example app running
**Steps:**
1. Tap text field to focus
2. Type content
3. Blur field

**Expected Result:** Crimson glow border appears on focus, disappears on blur
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [ ] New files created:
  - `packages/fifty_ui/pubspec.yaml`
  - `packages/fifty_ui/lib/fifty_ui.dart`
  - `packages/fifty_ui/lib/src/buttons/` (button components)
  - `packages/fifty_ui/lib/src/inputs/` (input components)
  - `packages/fifty_ui/lib/src/containers/` (card, etc.)
  - `packages/fifty_ui/lib/src/display/` (data display components)
  - `packages/fifty_ui/lib/src/feedback/` (snackbar, dialog)
  - `packages/fifty_ui/test/` (test files)
  - `packages/fifty_ui/example/` (example app)
  - `packages/fifty_ui/README.md`
  - `packages/fifty_ui/CHANGELOG.md`

### Documentation Updates
- [ ] README with component catalog
- [ ] API documentation (dartdoc comments)
- [ ] CHANGELOG with v0.1.0 entry
- [ ] Example app with interactive gallery

---

## Notes

**Ecosystem Architecture:**
```
fifty_tokens (v0.2.0) - Raw design values
       ↓
fifty_theme (v0.1.0) - ThemeData construction
       ↓
fifty_ui (v0.1.0) - Themed components  ← THIS PACKAGE
       ↓
Application - Your Flutter app
```

**FDL Component Aesthetic:**
- Dark surfaces with gunmetal (#2A2A2A) borders
- Crimson pulse (#DC143C) for accent and glow
- Terminal white (#F5F5F5) text on dark
- No elevation/shadows - depth via borders and glow
- Animations follow motion token durations

**References:**
- Fifty Design Language specification
- fifty_tokens color palette
- fifty_theme extension access patterns

---

**Created:** 2025-12-25
**Last Updated:** 2025-12-25
**Brief Owner:** Igris AI
