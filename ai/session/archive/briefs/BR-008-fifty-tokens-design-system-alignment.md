# BR-008: Fifty Tokens Design System Alignment

**Type:** Refactor
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-25
**Completed:** 2025-12-25

---

## Problem

**What's broken or missing?**

The current `fifty_tokens` package implementation does not align with the updated Fifty Design Language (FDL) specification defined in:
- `design_system/fifty_brand_sheet.md`
- `design_system/fifty_design_system.md`

**Key discrepancies:**

1. **Colors:** Wrong hex values, wrong naming convention (e.g., `surface0` vs `VOID_BLACK`)
2. **Typography:** Wrong font families (`Space Grotesk`/`Inter` instead of `Monument Extended`/`JetBrains Mono`)
3. **Radii:** Incorrect values (10px/16px instead of 12px/24px)
4. **Motion:** Missing timings (instant 0ms, systemLoad 800ms), incorrect values
5. **Shadows:** Philosophical conflict - spec says "no drop shadows"
6. **Missing:** `IGRIS_GREEN` (#00FF41), Ultrabold (800) weight, 64px Display XL

**Why does it matter?**

The tokens package is the DNA of the fifty.dev ecosystem. All downstream packages (`fifty_theme`, `fifty_ui`) will inherit these values. Misalignment now cascades to every component built on this foundation.

---

## Goal

**What should happen after this brief is completed?**

The `fifty_tokens` package matches the FDL specification exactly:
- All color tokens use spec naming (`VOID_BLACK`, `CRIMSON_PULSE`, etc.) and correct hex values
- Typography uses `Monument Extended` (display) and `JetBrains Mono` (body/code)
- Radii use 12px (standard) and 24px (smooth) as specified
- Motion timings match spec (0ms, 150ms, 300ms, 800ms)
- Shadows/elevation philosophy aligned with "no drop shadows, use outlines and overlays"
- All tests updated and passing
- Documentation reflects new token names and values

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_tokens`

### Layers Touched
- [x] Model (domain objects) — Token definitions

### API Changes
- [x] No API changes (internal package restructure)

### Dependencies
- [x] No new dependencies

### Related Files
- `packages/fifty_tokens/lib/src/colors.dart`
- `packages/fifty_tokens/lib/src/typography.dart`
- `packages/fifty_tokens/lib/src/spacing.dart`
- `packages/fifty_tokens/lib/src/radii.dart`
- `packages/fifty_tokens/lib/src/motion.dart`
- `packages/fifty_tokens/lib/src/shadows.dart`
- `packages/fifty_tokens/lib/src/breakpoints.dart`
- `packages/fifty_tokens/lib/fifty_tokens.dart`
- All test files in `packages/fifty_tokens/test/`
- `packages/fifty_tokens/README.md`
- `packages/fifty_tokens/example/fifty_tokens_example.dart`

### Reference Documents
- `design_system/fifty_brand_sheet.md` — Quick reference
- `design_system/fifty_design_system.md` — Full specification

---

## Constraints

### Architecture Rules
- Maintain static class pattern (private constructor)
- Keep comprehensive documentation comments
- Follow Dart naming conventions (camelCase for members)
- Zero external dependencies (pure Dart + Flutter foundation)

### Technical Constraints
- Must pass `flutter analyze` with zero warnings
- Must pass all tests
- Backward compatibility NOT required (package unpublished)

### Out of Scope
- Migration utilities or deprecation warnings
- Adding new token categories not in spec
- Theme integration (that's `fifty_theme` scope)

---

## Tasks

### Pending
- [ ] Task 1: Rewrite `colors.dart` with FDL spec colors and naming
- [ ] Task 2: Rewrite `typography.dart` with Monument Extended + JetBrains Mono
- [ ] Task 3: Update `radii.dart` with correct values (12px/24px)
- [ ] Task 4: Update `motion.dart` with spec timings (0ms, 150ms, 300ms, 800ms)
- [ ] Task 5: Rewrite `shadows.dart` to align with "outlines and overlays" philosophy
- [ ] Task 6: Update `spacing.dart` if needed (verify 4px base unit)
- [ ] Task 7: Update main export `fifty_tokens.dart`
- [ ] Task 8: Rewrite all test files for new token structure
- [ ] Task 9: Update README.md with new token reference
- [ ] Task 10: Update example file with new token usage
- [ ] Task 11: Run `flutter analyze` and fix any issues
- [ ] Task 12: Run `flutter test` and ensure all pass

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** Planning complete, awaiting approval
**Next Steps When Resuming:** Approve plan, begin implementation with coder agent
**Last Updated:** 2025-12-25
**Blockers:** None

### Workflow State
- **Phase:** COMPLETE
- **Active Agent:** none
- **Plan Location:** `ai/plans/BR-008-plan.md`

### Agent Log
- [2025-12-25] planner: Created implementation plan (9 phases, 18 files)
- [2025-12-25] Plan approved by Monarch
- [2025-12-25] coder: Implementation complete (7 files modified, 73 tests)
- [2025-12-25] tester: PASS (73/73 tests, 0 errors, 0 warnings)
- [2025-12-25] reviewer: APPROVE (minor fix applied)
- [2025-12-25] orchestrator: Brief complete, ready for commit

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] All colors match FDL spec (VOID_BLACK #050505, CRIMSON_PULSE #960E29, etc.)
2. [ ] Typography uses Monument Extended (display) and JetBrains Mono (body/code)
3. [ ] Type scale matches spec (64px, 48px, 32px, 16px, 12px)
4. [ ] Radii values are 12px (standard) and 24px (smooth)
5. [ ] Motion timings match spec (0ms, 150ms, 300ms, 800ms)
6. [ ] IGRIS_GREEN (#00FF41) token exists
7. [ ] Ultrabold (800) font weight exists
8. [ ] Shadow system aligns with "outlines and overlays" philosophy
9. [ ] `flutter analyze` passes (zero issues)
10. [ ] `flutter test` passes (all tests green)
11. [ ] README documents all new tokens accurately
12. [ ] Example file demonstrates correct usage

---

## Test Plan

### Automated Tests
- [ ] Unit test: All color hex values match spec
- [ ] Unit test: Typography font families are correct
- [ ] Unit test: Type scale values match spec
- [ ] Unit test: Radii values are 12px and 24px
- [ ] Unit test: Motion durations match spec
- [ ] Unit test: All tokens are accessible and non-null

### Manual Test Cases

#### Test Case 1: Token Value Verification
**Preconditions:** Package compiled successfully
**Steps:**
1. Run `flutter test`
2. Verify all assertions pass

**Expected Result:** All tests green
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [ ] Modified files: All 7 token source files
- [ ] Modified files: All 7 test files
- [ ] Modified files: README.md, example file

### Documentation Updates
- [ ] README: Complete token reference tables
- [ ] Example: Updated usage demonstrations

---

## Notes

### Color Mapping (Old → New)

| Old Token | New Token | Hex |
|-----------|-----------|-----|
| `crimsonCore` | `crimsonPulse` | #960E29 |
| `surface0` | `voidBlack` | #050505 |
| `surface1` | `gunmetal` | #1A1A1A |
| `textPrimary` | `terminalWhite` | #EAEAEA |
| `muted` | `hyperChrome` | #888888 |
| — | `igrisGreen` | #00FF41 |

### Typography Changes

| Role | Old Font | New Font |
|------|----------|----------|
| Display | Space Grotesk | Monument Extended |
| Body | Inter | JetBrains Mono |
| Code | JetBrains Mono | JetBrains Mono (unchanged) |

### Motion Timing Changes

| Name | Old | New |
|------|-----|-----|
| instant | — | 0ms |
| fast | 120ms | 150ms |
| compiling | — | 300ms |
| systemLoad | — | 800ms |

---

**Created:** 2025-12-25
**Last Updated:** 2025-12-25
**Brief Owner:** Igris AI
