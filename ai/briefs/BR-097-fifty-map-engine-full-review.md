# BR-097: Fifty Map Engine — Full Review

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

The `fifty_map_engine` package needs a comprehensive review to ensure:
- Code quality meets Fifty Flutter Kit standards
- All tests pass and provide adequate coverage
- UI components use theme-aware colors (no hardcoded `FiftyColors.*`, `Colors.*`, or hex values)
- The example app properly showcases engine capabilities using real engine logic (tile maps, camera, entities, interactions)
- The README is clear, references "Fifty Flutter Kit" (not "eco system"), and includes example screenshots

**Why does it matter?**

The map engine is the most complex engine in the kit, powering tactical grid and future map-based apps. It must be bulletproof, theme-aware, and well-documented.

---

## Goal

**What should happen after this brief is completed?**

- All engine code passes `flutter analyze` with zero issues
- All existing tests pass, gaps identified and filled
- Every UI widget uses `Theme.of(context).colorScheme` tokens instead of hardcoded colors
- Example app demonstrates real map engine functionality (tile rendering, camera pan/zoom, entity placement, interaction)
- README is clear, uses "Fifty Flutter Kit" branding, and contains example screenshots

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine/`

### Layers Touched
- [x] View (UI widgets — map renderer, overlays)
- [x] ViewModel (business logic — camera, entity management)
- [x] Service (data layer — tile loading, map data)
- [x] Model (domain objects — tiles, entities, map config)

### API Changes
- [x] No API changes

### Related Files
- `packages/fifty_map_engine/lib/` — all source files
- `packages/fifty_map_engine/test/` — all test files
- `packages/fifty_map_engine/example/` — example app
- `packages/fifty_map_engine/README.md` — documentation

---

## Constraints

### Architecture Rules
- UI components must use `Theme.of(context).colorScheme` tokens
- No hardcoded color values in renderers or overlays
- Example must use real engine APIs (MapController, TileMap, Entity system)
- Canvas-level drawing may use explicit colors for tile rendering (acceptable)

### Out of Scope
- Adding new map features
- Changing the engine's public API
- Performance optimization (unless critical)

---

## Multi-Agent Workflow

### Phase 1: EXPLORATION (explorer agent)
**Boundary:** Read-only analysis. No file modifications.
**Tasks:**
1. Scan all source files in `lib/` — catalog public API (MapController, TileMap, Entity, Camera)
2. Identify all UI widget files and custom painters
3. Find all hardcoded color references (distinguish canvas paint colors from widget colors)
4. Analyze example app — does it demonstrate tile rendering, camera control, entity management?
5. Read README — check branding, screenshots, clarity
6. Generate findings report

**Output:** Exploration report categorizing canvas colors (acceptable) vs widget colors (must fix)

### Phase 2: TESTING (tester agent)
**Boundary:** Run tests and analyze only. No code modifications.
**Tasks:**
1. Run `flutter analyze` in `packages/fifty_map_engine/`
2. Run `flutter test` in `packages/fifty_map_engine/`
3. Identify test coverage gaps
4. Report: PASS/FAIL with diagnostics

**Output:** Test results report

### Phase 3: CODE FIXES (coder agent)
**Boundary:** Fix issues found in Phase 1 & 2. Scoped to engine package only.
**Tasks:**
1. Replace hardcoded colors in UI widgets/overlays with `colorScheme` tokens
2. Keep canvas/paint colors that are part of tile rendering logic (these are data-driven, not theme)
3. Fix analyzer warnings/errors
4. Fix test failures
5. Add missing tests

**Output:** Implementation summary

### Phase 4: EXAMPLE REVIEW & FIX (coder agent)
**Boundary:** Example app only.
**Tasks:**
1. Ensure example uses real engine classes (MapController, TileMap, entities)
2. Verify example demonstrates: tile map rendering, camera pan/zoom, entity placement, tap interaction
3. Fix if using mock/static data instead of real engine logic
4. Ensure example UI is theme-aware

**Output:** Example app status report

### Phase 5: README REVIEW & FIX (documenter agent)
**Boundary:** README.md only.
**Tasks:**
1. Replace "eco system" with "Fifty Flutter Kit"
2. Ensure proper structure with features, installation, usage, screenshots
3. Verify screenshot references
4. Ensure clarity

**Output:** README update summary

### Phase 6: FINAL VALIDATION (tester agent)
**Boundary:** Full test suite after changes.
**Tasks:**
1. `flutter analyze` — zero issues
2. `flutter test` — all pass
3. No regressions

**Output:** Final PASS/FAIL

### Phase 7: REVIEW (reviewer agent)
**Boundary:** Read-only review.
**Tasks:**
1. Review all changes
2. Verify theme-awareness (widget colors vs canvas paint colors distinction)
3. Verify example uses real engine logic
4. Verify README
5. APPROVE or REJECT

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

1. [ ] All UI widgets use `Theme.of(context).colorScheme` tokens (no hardcoded colors in widgets)
2. [ ] Canvas/paint colors used for tile rendering are documented as intentional
3. [ ] `flutter analyze` passes with zero issues
4. [ ] `flutter test` passes (all existing + new tests green)
5. [ ] Example app demonstrates real map engine functionality
6. [ ] Example app works in both light and dark theme
7. [ ] README uses "Fifty Flutter Kit" (no "eco system" references)
8. [ ] README contains example screenshots
9. [ ] Code review APPROVED by reviewer agent

---

## Test Plan

### Automated Tests
- [ ] Run existing test suite
- [ ] Add tests for uncovered public APIs
- [ ] Widget tests verify theme-aware overlays

### Manual Test Cases

#### Test Case 1: Map Rendering
**Steps:**
1. Run example app
2. Verify tile map renders correctly
3. Pan and zoom the camera
4. Tap on tiles/entities

**Expected Result:** Real engine rendering, responsive camera, interactive entities

#### Test Case 2: Theme Awareness
**Steps:**
1. Switch between light/dark mode
2. Verify overlays, controls, and UI elements adapt

**Expected Result:** Proper theming on all non-canvas UI elements

---

## Delivery

### Documentation Updates
- [ ] README: Updated with Fifty Flutter Kit branding and screenshots

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
