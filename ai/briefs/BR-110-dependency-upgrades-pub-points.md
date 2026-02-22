# BR-110: Upgrade Outdated Dependencies for pub.dev Score Recovery

**Type:** Bug (pub.dev Score)
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-22
**Completed:**

---

## Problem

**What's broken or missing?**

11 of 15 packages are losing 10-20 pub points due to outdated dependency constraints. pub.dev deducts points when a package's dependency constraints don't support the latest stable versions.

**Why does it matter?**

- 10-20 pub points lost per package (140-150/160 instead of 160/160)
- Lower scores affect discoverability and trust on pub.dev
- Outdated deps may also mean missing bug fixes and security patches

---

## Goal

**What should happen after this brief is completed?**

All packages with outdated dependency constraints are upgraded to support the latest stable versions. pub.dev awards full 40/40 for "Support up-to-date dependencies" on all packages. Packages currently at 150 move to 160, fifty_storage moves from 140 toward 160.

---

## Context & Inputs

### Packages and Their Outdated Dependencies

**Dependency upgrades (direct score impact):**

| Package | Dep | Current Constraint | Latest Stable | Points Lost |
|---------|-----|--------------------|---------------|-------------|
| `fifty_tokens` | `google_fonts` | ^6.2.1 | 8.0.2 | -10 |
| `fifty_theme` | `google_fonts` | ^6.2.1 | 8.0.2 | -10 |
| `fifty_utils` | `intl` | ^0.19.0 | 0.20.2 | -10 |
| `fifty_storage` | `flutter_secure_storage` | ^9.2.2 | 10.0.0 | -10 |
| `fifty_connectivity` | `connectivity_plus` | ^6.1.0 | 7.0.0 | -10 |

**WASM / SPM issues (platform support, not dependency):**

| Package | Issue | Points Lost |
|---------|-------|-------------|
| `fifty_forms` | WASM incompatible (`get_storage` uses `dart:html`) | -10 |
| `fifty_cache` | WASM incompatible (`get_storage` uses `dart:html`) | -10 |
| `fifty_storage` | WASM incompatible (`dart:io`) | -10 (stacks with dep issue) |
| `fifty_audio_engine` | WASM incompatible + missing SPM | -10 |
| `fifty_speech_engine` | Missing Windows/macOS + no SPM | -10 |
| `fifty_narrative_engine` | Missing SPM (iOS/macOS) | -10 |
| `fifty_world_engine` | Missing SPM (iOS/macOS) | -10 |

**Note:** WASM and SPM issues may not be fixable without upstream changes or significant refactoring. Focus on dependency upgrades first as they are straightforward.

### Upgrade Commands

```bash
# fifty_tokens & fifty_theme
dart pub upgrade --major-versions google_fonts

# fifty_utils
dart pub upgrade --major-versions intl

# fifty_storage
dart pub upgrade --major-versions flutter_secure_storage

# fifty_connectivity
dart pub upgrade --major-versions connectivity_plus
```

### Risk: Breaking API Changes

Major version upgrades may introduce breaking changes:
- `google_fonts` 6 → 8: Check for API changes in font loading
- `intl` 0.19 → 0.20: Check DateFormat and NumberFormat APIs
- `flutter_secure_storage` 9 → 10: Check storage API changes
- `connectivity_plus` 6 → 7: Check connectivity status API changes

Each upgrade needs testing to ensure no regressions.

---

## Constraints

### Architecture Rules
- Must not break existing public APIs of any package
- Must run `dart analyze` and `flutter test` after each upgrade
- Packages that depend on upgraded packages may need constraint updates too
- Re-publish required after upgrades (patch bump + publish + revert path deps)

### Out of Scope
- WASM compatibility fixes (requires upstream `get_storage` changes)
- Swift Package Manager support files (requires native plugin restructuring)
- Platform support expansion (e.g., adding Windows/macOS to speech_engine)

---

## Tasks

### Pending

- [ ] Publish to pub.dev (switch path deps → hosted, publish, revert)

### In Progress
_(None)_

### Completed

- [x] Upgrade `google_fonts` ^6.2.1 → ^8.0.0 in fifty_tokens and fifty_theme
- [x] Verify no breaking changes in google_fonts 8.x API (stable, test fix needed for async errors)
- [x] Upgrade `intl` ^0.19.0 → ^0.20.0 in fifty_utils
- [x] Verify no breaking changes in intl 0.20.x API (DateFormat unchanged)
- [x] Upgrade `flutter_secure_storage` ^9.2.2 → ^10.0.0 in fifty_storage
- [x] Verify no breaking changes in flutter_secure_storage 10.x API (read/write/delete unchanged)
- [x] Upgrade `connectivity_plus` ^6.1.0 → ^7.0.0 in fifty_connectivity
- [x] Verify no breaking changes in connectivity_plus 7.x API (existing dynamic handling covers it)
- [x] Run `dart analyze` on all affected packages (all pass)
- [x] Run tests on all affected packages (404 pass, 1 pre-existing fail in tokens)
- [x] Patch bump all 5 packages
- [x] CHANGELOG updates for all 5 packages

---

## Acceptance Criteria

1. [ ] All 5 outdated dependency constraints upgraded to support latest stable
2. [ ] `dart analyze` passes on all affected packages
3. [ ] `flutter test` passes on all affected packages
4. [ ] No breaking changes to public APIs
5. [ ] Packages re-published to pub.dev
6. [ ] pub.dev awards 40/40 for dependency support on upgraded packages

---

## Test Plan

### Automated Tests
- [ ] `dart analyze` passes for each upgraded package
- [ ] `flutter test` passes for each upgraded package
- [ ] `dart pub publish --dry-run` passes for each package

### Manual Test Cases
- [ ] Verify pub.dev scores improve after re-publish

---

## Notes

- Dependency upgrades cascade: if `fifty_tokens` upgrades `google_fonts`, packages depending on `fifty_tokens` (e.g., `fifty_theme`, `fifty_ui`) may need constraint updates too
- Major version bumps of dependencies should be done one at a time to isolate any issues
- Expected score improvements: tokens +10, theme +10, utils +10, storage +10, connectivity +10 = **+50 total points across 5 packages**

---

**Created:** 2026-02-22
**Last Updated:** 2026-02-22
**Brief Owner:** Igris AI
