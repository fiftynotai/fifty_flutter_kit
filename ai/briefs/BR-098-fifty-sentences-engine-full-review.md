# BR-098: Fifty Narrative Engine — Full Review

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-02-17

---

## Problem

**What's broken or missing?**

The `fifty_narrative_engine` package needs a comprehensive review to ensure:
- Code quality meets Fifty Flutter Kit standards
- All tests pass and provide adequate coverage
- UI components use theme-aware colors (no hardcoded `FiftyColors.*`, `Colors.*`, or hex values)
- The example app properly showcases engine capabilities using real engine logic (sentence construction, word selection, grammar rules)
- The README is clear, references "Fifty Flutter Kit" (not "eco system"), and includes example screenshots

**Why does it matter?**

The sentences engine provides language/sentence-building functionality. It must be well-tested, theme-aware in its UI components, and have a clear example demonstrating its API.

---

## Goal

**What should happen after this brief is completed?**

- All engine code passes `flutter analyze` with zero issues
- All existing tests pass, gaps identified and filled
- Every UI widget uses `Theme.of(context).colorScheme` tokens
- Example app demonstrates real sentence engine functionality
- README is clear, uses "Fifty Flutter Kit" branding, and contains example screenshots

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_narrative_engine/`

### Layers Touched
- [x] View (UI widgets)
- [x] ViewModel (business logic)
- [x] Service (data layer)
- [x] Model (domain objects)

### API Changes
- [x] No API changes

### Related Files
- `packages/fifty_narrative_engine/lib/` — all source files
- `packages/fifty_narrative_engine/test/` — all test files
- `packages/fifty_narrative_engine/example/` — example app
- `packages/fifty_narrative_engine/README.md` — documentation

---

## Constraints

### Architecture Rules
- UI components must use `Theme.of(context).colorScheme` tokens
- Example must use real engine APIs
- No changes to public API

### Out of Scope
- Adding new sentence features
- Changing the engine's public API

---

## Multi-Agent Workflow

### Phase 1: EXPLORATION (explorer agent)
**Boundary:** Read-only analysis. No file modifications.
**Tasks:**
1. Scan all source files in `lib/` — catalog public API surface
2. Identify all UI widget files
3. Find all hardcoded color references
4. Analyze example app — does it use real sentence construction logic?
5. Read README — check branding, screenshots, clarity
6. Generate findings report

**Output:** Exploration report with categorized findings

### Phase 2: TESTING (tester agent)
**Boundary:** Run tests and analyze only. No code modifications.
**Tasks:**
1. Run `flutter analyze` in `packages/fifty_narrative_engine/`
2. Run `flutter test` in `packages/fifty_narrative_engine/`
3. Identify test coverage gaps
4. Report: PASS/FAIL with diagnostics

**Output:** Test results report

### Phase 3: CODE FIXES (coder agent)
**Boundary:** Fix issues found in Phase 1 & 2.
**Tasks:**
1. Replace hardcoded colors with `colorScheme` tokens
2. Fix analyzer warnings/errors
3. Fix test failures
4. Add missing tests

**Output:** Implementation summary

### Phase 4: EXAMPLE REVIEW & FIX (coder agent)
**Boundary:** Example app only.
**Tasks:**
1. Ensure example uses real engine classes
2. Verify example demonstrates core sentence engine features
3. Fix if using mock/static data
4. Ensure theme-awareness

**Output:** Example app status report

### Phase 5: README REVIEW & FIX (documenter agent)
**Boundary:** README.md only.
**Tasks:**
1. Replace "eco system" with "Fifty Flutter Kit"
2. Ensure proper structure with screenshots
3. Ensure clarity

**Output:** README update summary

### Phase 6: FINAL VALIDATION (tester agent)
**Boundary:** Full test suite after changes.
**Tasks:**
1. `flutter analyze` — zero issues
2. `flutter test` — all pass

**Output:** Final PASS/FAIL

### Phase 7: REVIEW (reviewer agent)
**Boundary:** Read-only review.
**Tasks:**
1. Review all changes
2. Verify completeness
3. APPROVE or REJECT

**Output:** APPROVE/REJECT

---

## Tasks

### Pending
- [ ] Phase 1: Explorer scans engine code, example, and README
- [ ] Phase 2: Tester runs analyze + test suite
- [ ] Phase 3: Coder fixes hardcoded colors and test issues
- [ ] Phase 4: Coder reviews and fixes example app
- [ ] Phase 5: Documenter reviews and fixes README
- [ ] Phase 6: Tester runs final validation
- [ ] Phase 7: Reviewer approves or rejects changes

### In Progress
_(None)_

### Completed
_(None)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin Phase 1 — explorer scan
**Last Updated:** 2026-02-17
**Blockers:** None

---

## Acceptance Criteria

1. [ ] All UI widgets use `Theme.of(context).colorScheme` tokens
2. [ ] `flutter analyze` passes with zero issues
3. [ ] `flutter test` passes (all existing + new tests green)
4. [ ] Example app demonstrates real sentence engine functionality
5. [ ] Example app works in both light and dark theme
6. [ ] README uses "Fifty Flutter Kit" (no "eco system" references)
7. [ ] README contains example screenshots
8. [ ] Code review APPROVED by reviewer agent

---

## Test Plan

### Automated Tests
- [ ] Run existing test suite
- [ ] Add tests for uncovered public APIs
- [ ] Widget tests verify theme-aware rendering

### Manual Test Cases

#### Test Case 1: Theme Awareness
**Steps:**
1. Run example app in light and dark mode
2. Verify all sentence UI components render correctly

**Expected Result:** Proper contrast, no hardcoded colors

#### Test Case 2: Sentence Engine Integration
**Steps:**
1. Run example app
2. Interact with sentence construction features
3. Verify real engine logic is driving the UI

**Expected Result:** Real engine managing sentence construction

---

## Delivery

### Documentation Updates
- [ ] README: Updated with Fifty Flutter Kit branding and screenshots

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
