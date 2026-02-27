# BR-130: fifty_scroll_sequence — v1.0.0 Release Preparation

**Type:** Release
**Priority:** P1-High
**Effort:** M-Medium (1-3d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-02-27

---

## Problem

**What's broken or missing?**

The `fifty_scroll_sequence` package is at v0.1.0 but is feature-complete and battle-tested through the coffee showcase and example app. It needs release preparation before publishing as v1.0.0.

Several issues need addressing:

1. **Version is 0.1.0** — needs bump to 1.0.0 (pubspec.yaml + README)
2. **README has inaccuracies** — mentions features that may not reflect current implementation (e.g. snap-to-keyframe, lifecycle callbacks, viewport observer, horizontal mode are not documented). Some code examples may be outdated after recent bug fixes.
3. **No code review** — package code has not been formally reviewed for quality, API consistency, and documentation completeness
4. **Example app is in wrong directory** — `apps/scroll_sequence_example/` should be at `packages/fifty_scroll_sequence/example/` per kit convention (the `/apps` directory is for actual apps built with kit packages, not package examples)
5. **README lacks screenshots** — other kit packages include screenshots from the example app; this one has a `<!-- TODO: Add demo GIF here -->` placeholder
6. **README doesn't follow kit standards** — needs to match the structure used by `fifty_audio_engine` and other packages (screenshot table, features, installation, quick start, architecture, API reference, example, version, license)

**Why does it matter?**

This is the final gate before v1.0.0 publication. The README is the first thing developers see, and inaccurate documentation erodes trust. The example in the wrong directory breaks kit conventions.

---

## Goal

**What should happen after this brief is completed?**

- Package version is 1.0.0
- README accurately reflects current implementation with screenshots
- Package code passes formal review (WARDEN)
- Example app lives at `packages/fifty_scroll_sequence/example/`
- `apps/scroll_sequence_example/` is removed
- README follows kit package standards

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_scroll_sequence/`
- [ ] Other: `apps/scroll_sequence_example/` (move to package)

### Layers Touched
- [x] Package configuration (pubspec.yaml)
- [x] Documentation (README.md, CHANGELOG.md)
- [x] Example app (directory relocation)
- [x] Source code (review findings)

### Files to Modify
- `packages/fifty_scroll_sequence/pubspec.yaml` — version bump to 1.0.0
- `packages/fifty_scroll_sequence/README.md` — full rewrite to match kit standards
- `packages/fifty_scroll_sequence/CHANGELOG.md` — v1.0.0 entry
- `packages/fifty_scroll_sequence/example/` — relocated example app
- `apps/scroll_sequence_example/` — delete after relocation

### Reference READMEs (kit standards)
- `packages/fifty_audio_engine/README.md` — gold standard with screenshot table
- `packages/fifty_world_engine/README.md` — recent package, good structure

---

## Tasks

### Task 1: Move Example App
- Move `apps/scroll_sequence_example/` to `packages/fifty_scroll_sequence/example/`
- Update path dependencies in example's `pubspec.yaml`
- Verify `flutter analyze` and `flutter run` still work
- Remove `apps/scroll_sequence_example/`

### Task 2: Code Review
- Run WARDEN on the package source code
- Address any quality, security, or API consistency findings
- Ensure all public APIs have documentation comments
- Verify no dead code or unused exports

### Task 3: README Rewrite
- Audit current README against actual implementation:
  - Verify every class in the API reference table exists
  - Verify every parameter in the ScrollSequence table is accurate
  - Verify code examples compile and reflect current API
  - Add missing features: `snapConfig`, lifecycle callbacks (`onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack`), `scrollDirection` (horizontal mode), `ViewportObserver`
  - Remove or correct anything that doesn't match the implementation
- Follow kit README structure:
  - Title + badges
  - Screenshot table (from example app)
  - Features list
  - Installation
  - Quick Start (minimal, pinned+builder, controller, snap, network, sprite sheet)
  - Architecture diagram
  - API Reference tables
  - Frame Preparation Guide
  - Performance Tips
  - Example App section (updated path)
  - Version + License

### Task 4: Screenshots
- Take screenshots from the example app on iOS simulator:
  - Menu page
  - Basic demo (non-pinned, frames scrubbing)
  - Pinned demo (pinned with overlay)
  - Snap demo (scene dots + snap behavior)
  - Multi-sequence demo
  - Lifecycle demo (event log)
- Save to `packages/fifty_scroll_sequence/screenshots/`
- Reference in README screenshot table

### Task 5: Version Bump
- Update `pubspec.yaml` version to `1.0.0`
- Update README version references
- Create/update `CHANGELOG.md` with v1.0.0 entry summarizing all features

---

## Constraints

- README must accurately reflect the ACTUAL implementation — no aspirational features
- Example must work from the new location (`packages/fifty_scroll_sequence/example/`)
- All path dependencies in example pubspec must be updated
- Screenshot format: PNG, reasonable size for README display
- Must not break any existing tests (238 tests)
- `flutter analyze` must pass with zero issues on both package and example

---

## Acceptance Criteria

1. [ ] `pubspec.yaml` version is `1.0.0`
2. [ ] Example app relocated to `packages/fifty_scroll_sequence/example/`
3. [ ] `apps/scroll_sequence_example/` removed
4. [ ] Example runs from new location (`flutter analyze` + `flutter run`)
5. [ ] README accurately documents all current features and APIs
6. [ ] README includes screenshot table with example app screenshots
7. [ ] README follows kit package standards (matches fifty_audio_engine structure)
8. [ ] No inaccurate or aspirational content in README
9. [ ] WARDEN code review passes (APPROVE)
10. [ ] `CHANGELOG.md` has v1.0.0 entry
11. [ ] All 238+ tests pass
12. [ ] `flutter analyze` passes (zero issues)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Example from New Location
**Preconditions:** Example moved to `packages/fifty_scroll_sequence/example/`
**Steps:** `cd packages/fifty_scroll_sequence/example && flutter run -d iPhone`
**Expected Result:** App launches, all 6 demos work correctly

#### Test Case 2: README Code Examples
**Preconditions:** README rewritten
**Steps:** Verify each code example against actual API signatures
**Expected Result:** All examples are valid Dart that would compile

#### Test Case 3: Screenshots Load
**Preconditions:** Screenshots saved to `screenshots/` directory
**Steps:** View README in GitHub/rendered markdown
**Expected Result:** All screenshots render correctly

---

**Created:** 2026-02-27
**Last Updated:** 2026-02-27
**Brief Owner:** Fifty.ai
