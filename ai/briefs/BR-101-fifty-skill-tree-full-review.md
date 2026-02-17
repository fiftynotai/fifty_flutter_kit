# BR-101: Fifty Skill Tree — Full Review

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

The `fifty_skill_tree` package needs a comprehensive review to ensure:
- Code quality meets Fifty Flutter Kit standards
- All tests pass and provide adequate coverage
- UI components use theme-aware colors (no hardcoded `FiftyColors.*`, `Colors.*`, or hex values)
- The example app properly showcases the skill tree using real engine logic (skill nodes, dependencies, unlock progression)
- The README is clear, references "Fifty Flutter Kit" (not "eco system"), and includes example screenshots

**Why does it matter?**

The skill tree is a game-oriented UI engine that renders interactive dependency graphs. It must be visually adaptable across themes, well-tested, and have a showcase example that demonstrates its progression mechanics.

---

## Goal

**What should happen after this brief is completed?**

- All engine code passes `flutter analyze` with zero issues
- All existing tests pass, gaps identified and filled
- Every UI widget uses `Theme.of(context).colorScheme` tokens instead of hardcoded colors
- Example app demonstrates real skill tree functionality (node rendering, dependency resolution, unlock progression, interaction)
- README is clear, uses "Fifty Flutter Kit" branding, and contains example screenshots

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_skill_tree/`

### Layers Touched
- [x] View (UI widgets — skill node renderer, tree layout, connectors)
- [x] ViewModel (business logic — skill state, progression)
- [x] Service (data layer — skill data provider)
- [x] Model (domain objects — skill nodes, dependencies, tiers)

### API Changes
- [x] No API changes

### Related Files
- `packages/fifty_skill_tree/lib/` — all source files
- `packages/fifty_skill_tree/test/` — all test files
- `packages/fifty_skill_tree/example/` — example app
- `packages/fifty_skill_tree/README.md` — documentation

---

## Constraints

### Architecture Rules
- UI components must use `Theme.of(context).colorScheme` tokens
- Skill node state colors (locked/unlocked/active) may use semantic colors — but should derive from theme where possible
- Canvas-drawn connectors/lines may use explicit colors (acceptable if intentional)
- Example must use real engine APIs (SkillTree, SkillNode, progression system)

### Out of Scope
- Adding new skill tree features
- Changing the engine's public API
- Canvas rendering algorithm changes

---

## Multi-Agent Workflow

### Phase 1: EXPLORATION (explorer agent)
**Boundary:** Read-only analysis. No file modifications.
**Tasks:**
1. Scan all source files in `lib/` — catalog public API (SkillTree, SkillNode, SkillTreeController)
2. Identify all UI widget files and custom painters (node renderer, connectors)
3. Find all hardcoded color references (distinguish canvas paint from widget UI)
4. Analyze example app — does it demonstrate skill tree with real progression logic?
5. Read README — check branding, screenshots, clarity
6. Generate findings report

**Output:** Exploration report categorizing canvas colors vs widget colors

### Phase 2: TESTING (tester agent)
**Boundary:** Run tests and analyze only.
**Tasks:**
1. Run `flutter analyze` in `packages/fifty_skill_tree/`
2. Run `flutter test` in `packages/fifty_skill_tree/`
3. Identify test coverage gaps
4. Report: PASS/FAIL

**Output:** Test results report

### Phase 3: CODE FIXES (coder agent)
**Boundary:** Fix issues found in Phase 1 & 2.
**Tasks:**
1. Replace hardcoded colors in UI widgets with `colorScheme` tokens
2. Evaluate skill-state colors — make theme-derivable where possible, document intentional exceptions
3. Fix analyzer warnings/errors
4. Fix test failures
5. Add missing tests

**Output:** Implementation summary

### Phase 4: EXAMPLE REVIEW & FIX (coder agent)
**Boundary:** Example app only.
**Tasks:**
1. Ensure example uses real engine classes (SkillTree, SkillNode, progression)
2. Verify example demonstrates: tree rendering, node dependencies, unlock progression, tap interaction
3. Fix if using mock/static data
4. Ensure UI is theme-aware

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
2. Verify canvas vs widget color distinction
3. Verify progression logic in example
4. APPROVE or REJECT

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
2. [ ] Canvas/connector colors documented as intentional where applicable
3. [ ] Skill-state colors (locked/unlocked/active) derive from theme or are documented
4. [ ] `flutter analyze` passes with zero issues
5. [ ] `flutter test` passes (all existing + new tests green)
6. [ ] Example app demonstrates real skill tree functionality with progression
7. [ ] Example app works in both light and dark theme
8. [ ] README uses "Fifty Flutter Kit" (no "eco system" references)
9. [ ] README contains example screenshots
10. [ ] Code review APPROVED by reviewer agent

---

## Test Plan

### Automated Tests
- [ ] Run existing test suite
- [ ] Add tests for uncovered public APIs
- [ ] Widget tests verify theme-aware node rendering

### Manual Test Cases

#### Test Case 1: Skill Tree Rendering
**Steps:**
1. Run example app
2. Verify skill tree renders with nodes and connectors
3. Tap nodes to unlock
4. Verify dependency resolution (locked nodes can't unlock without prereqs)

**Expected Result:** Real progression logic, interactive tree

#### Test Case 2: Theme Awareness
**Steps:**
1. Switch between light/dark mode
2. Verify all UI elements adapt

**Expected Result:** Proper theming on widget UI, consistent canvas rendering

---

## Delivery

### Documentation Updates
- [ ] README: Updated with Fifty Flutter Kit branding and screenshots

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
