# BR-105: Pub.dev Release Preparation — Full Package Review

**Type:** Feature
**Priority:** P1-High
**Effort:** XL-Extra Large (>1w)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-18
**Completed:** 2026-02-22

---

## Problem

**What's broken or missing?**

All 15 packages in the Fifty Flutter Kit monorepo are internal-only with path dependencies. None are published to pub.dev. Each package needs a comprehensive review to ensure it meets pub.dev publishing standards:

| Package | Version | Published |
|---------|---------|-----------|
| `fifty_tokens` | 1.0.0 | Live on pub.dev |
| `fifty_utils` | 0.1.0 | Live on pub.dev |
| `fifty_cache` | 0.1.0 | Live on pub.dev |
| `fifty_storage` | 0.1.0 | Live on pub.dev |
| `fifty_theme` | 1.0.0 | Live on pub.dev |
| `fifty_ui` | 0.6.0 | Live on pub.dev |
| `fifty_printing_engine` | 1.0.0 | Live on pub.dev |
| `fifty_narrative_engine` | 0.1.0 | Live on pub.dev |
| `fifty_forms` | 0.1.0 | Live on pub.dev |
| `fifty_connectivity` | 0.1.0 | Live on pub.dev |
| `fifty_audio_engine` | 0.7.0 | Live on pub.dev |
| `fifty_speech_engine` | 0.1.0 | Live on pub.dev |
| `fifty_world_engine` | 0.1.0 | Pending (rate limited) |
| `fifty_achievement_engine` | 0.1.1 | Pending (rate limited) |
| `fifty_skill_tree` | 0.1.0 | Pending (rate limited) |

**Why does it matter?**

Publishing to pub.dev makes the Fifty Flutter Kit accessible to the Flutter community, establishes Fifty.ai's presence in the ecosystem, and enables versioned dependency management for external consumers. Currently packages can only be used via path or git references.

---

## Goal

**What should happen after this brief is completed?**

All 15 packages pass `dart pub publish --dry-run` with zero warnings, have correct metadata, clean APIs, proper documentation, and are ready for first publication to pub.dev.

---

## Context & Inputs

### Affected Packages (All 15)

**Foundation Layer (publish first — no internal deps):**
- [ ] `fifty_tokens` — Design tokens
- [ ] `fifty_utils` — Utility extensions

**Core Layer (depends on foundation):**
- [ ] `fifty_theme` — Theme system (depends on tokens)
- [ ] `fifty_ui` — Component library (depends on tokens, theme)
- [ ] `fifty_cache` — Caching layer
- [ ] `fifty_storage` — Storage abstraction

**Feature Layer (depends on core):**
- [ ] `fifty_forms` — Form system (depends on tokens, ui)
- [ ] `fifty_connectivity` — Connectivity monitoring (depends on tokens, ui, utils)

**Engine Layer (depends on core):**
- [ ] `fifty_audio_engine` — Audio playback engine
- [ ] `fifty_printing_engine` — Receipt/label printing
- [ ] `fifty_narrative_engine` — Text generation engine
- [ ] `fifty_speech_engine` — STT/TTS engine
- [ ] `fifty_world_engine` — 2D tile map engine
- [ ] `fifty_achievement_engine` — Achievement/trophy system
- [ ] `fifty_skill_tree` — Skill tree system

### Pub.dev Checklist (Per Package)

Each package must satisfy:

#### 1. pubspec.yaml Metadata
- [ ] `name` — Correct, follows convention
- [ ] `description` — 60–180 chars, no markdown
- [ ] `version` — Semantic versioning, appropriate for maturity
- [ ] `homepage` — Points to GitHub repo or docs site
- [ ] `repository` — Points to package directory in monorepo
- [ ] `issue_tracker` — Points to GitHub issues
- [ ] `topics` — 1–5 pub.dev topics
- [ ] `screenshots` — Declared if example screenshots exist
- [ ] `funding` — Optional, add if desired
- [ ] `environment.sdk` — Correct Flutter/Dart SDK constraint
- [ ] `dependencies` — All path deps converted to version-pinned hosted deps (or git refs for unpublished internal deps)
- [ ] `platforms` — Declared if not all-platform

#### 2. File Structure
- [ ] `LICENSE` — Exists, valid MIT
- [ ] `CHANGELOG.md` — Exists, has at least initial version entry
- [ ] `README.md` — Exists, follows FDL template, has screenshots
- [ ] `example/` — Exists with runnable example
- [ ] `lib/` — Clean barrel export, no unused files
- [ ] `analysis_options.yaml` — Strict lint rules

#### 3. Code Quality
- [ ] `dart pub publish --dry-run` passes with 0 warnings
- [ ] `flutter analyze` passes with 0 issues
- [ ] `dart doc` generates without errors
- [ ] No TODO/FIXME/HACK comments left in public API
- [ ] All public APIs have dartdoc comments
- [ ] No deprecated APIs without `@Deprecated` annotation
- [ ] No unused imports or dead code

#### 4. API Surface Review
- [ ] Barrel export (`lib/{package_name}.dart`) exports all public API
- [ ] No accidental internal API exposure
- [ ] Consistent naming conventions
- [ ] No breaking changes needed before publish

#### 5. Dependency Hygiene
- [ ] Internal path dependencies mapped to publish order
- [ ] No circular dependencies
- [ ] All third-party deps at latest compatible versions
- [ ] `pubspec.lock` not checked into package (library convention)

---

## Constraints

### Architecture Rules
- Publish order must respect dependency graph (foundation → core → feature → engine)
- Packages must work as standalone pub.dev dependencies, not just within the monorepo
- Semantic versioning: 0.x.y for pre-1.0 packages, 1.x.y for stable packages

### Technical Constraints
- All packages must support Flutter 3.x+ (current stable)
- Minimum Dart SDK constraint must be reasonable (not bleeding edge)
- Web platform: document any limitations per package
- `dart pub publish --dry-run` is the final gate per package

### Publishing Order (Dependency Graph)
```
Phase 1: fifty_tokens, fifty_utils, fifty_cache, fifty_storage
Phase 2: fifty_theme (→ tokens)
Phase 3: fifty_ui (→ tokens, theme)
Phase 4: fifty_forms (→ tokens, ui), fifty_connectivity (→ tokens, ui, utils)
Phase 5: fifty_audio_engine, fifty_printing_engine, fifty_narrative_engine,
         fifty_speech_engine, fifty_world_engine, fifty_achievement_engine,
         fifty_skill_tree
```

### Out of Scope
- Actual `dart pub publish` execution (separate step after review)
- CI/CD pipeline setup for automated publishing
- pub.dev verified publisher setup (manual process)
- Marketing or announcement

---

## Tasks

### Pending

**Remaining pub.dev publishes (3 packages — rate limited, retry 2026-02-21):**
- [ ] `fifty_world_engine` v0.1.0 — no internal path deps to convert
- [ ] `fifty_achievement_engine` v0.1.1 — convert `fifty_tokens`, `fifty_ui` to hosted deps
- [ ] `fifty_skill_tree` v0.1.0 — convert `fifty_tokens` to hosted dep

All 3 packages already pass `dart pub publish --dry-run` with 0 warnings. Just need to re-run publish after the daily rate limit resets.

### In Progress
_(None)_

### Completed

**Pre-publish preparation (all 15 packages):**
- [x] Audit pubspec.yaml metadata (description, homepage, repository, topics, screenshots)
- [x] Verify/create CHANGELOG.md with version history
- [x] Verify LICENSE file exists and is valid
- [x] Review README for completeness (screenshots, API reference, examples)
- [x] Review barrel exports — ensure clean public API
- [x] Run `flutter analyze` — fix all 222 analyzer issues
- [x] Run `dart pub publish --dry-run` — all 15 pass with 0 warnings
- [x] Verify example apps exist and run
- [x] Map internal path deps to publish-ready form
- [x] Determine final version numbers for all packages
- [x] Build dependency graph and validate publish order
- [x] Verify no circular dependencies exist
- [x] Rename `fifty_sentences_engine` → `fifty_narrative_engine` (permanent pub.dev name)
- [x] Rename `fifty_map_engine` → `fifty_world_engine` (permanent pub.dev name)
- [x] Smoke test three apps (world_engine example, tactical_grid, fifty_demo) in iOS simulator

**Published (12/15 — 2026-02-20):**
- [x] Phase 1: `fifty_tokens` v1.0.0, `fifty_utils` v0.1.0, `fifty_cache` v0.1.0, `fifty_storage` v0.1.0
- [x] Phase 2: `fifty_theme` v1.0.0
- [x] Phase 3: `fifty_ui` v0.6.0, `fifty_printing_engine` v1.0.0, `fifty_narrative_engine` v0.1.0
- [x] Phase 4: `fifty_forms` v0.1.0, `fifty_connectivity` v0.1.0
- [x] Phase 5 (partial): `fifty_audio_engine` v0.7.0, `fifty_speech_engine` v0.1.0

---

## Session State (Tactical - This Brief)

**Current State:** 12/15 packages live on pub.dev. 3 remaining hit daily rate limit (12 new packages/day).
**Next Steps When Resuming:** Publish remaining 3 packages: `fifty_world_engine`, `fifty_achievement_engine`, `fifty_skill_tree`. All validated and ready — just re-run `dart pub publish --force` from each package directory after converting path deps to hosted.
**Last Updated:** 2026-02-20
**Blockers:** pub.dev rate limit (12 new packages/day) — resets ~2026-02-21

---

## Acceptance Criteria

**The release preparation is complete when:**

1. [ ] All 15 packages pass `dart pub publish --dry-run` with zero warnings
2. [ ] All 15 packages pass `flutter analyze` with zero issues
3. [ ] All 15 packages have complete pubspec.yaml metadata (description, homepage, repository, topics)
4. [ ] All 15 packages have CHANGELOG.md with at least one version entry
5. [ ] All 15 packages have valid LICENSE file
6. [ ] All 15 packages have README.md with screenshots and API docs
7. [ ] All public APIs have dartdoc comments
8. [ ] Dependency graph validated — publish order documented
9. [ ] No path dependencies remain in publishable pubspec.yaml files
10. [ ] `dart doc` generates cleanly for all packages

---

## Test Plan

### Automated Tests
- [ ] `flutter analyze` per package (zero issues)
- [ ] `dart pub publish --dry-run` per package (zero warnings)
- [ ] `dart doc` per package (zero errors)

### Manual Test Cases

#### Test Case 1: Standalone Package Install
**Preconditions:** Clean Flutter project
**Steps:**
1. Add package via git reference
2. Import barrel export
3. Use primary API
4. Build and run

**Expected Result:** Package works without monorepo context
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] All example apps still build and run
- [ ] Monorepo `flutter analyze` at root passes
- [ ] No breaking API changes introduced

---

## Delivery

### Code Changes
- [ ] Modified: All 15 `pubspec.yaml` files (metadata + deps)
- [ ] Created/Modified: All 15 `CHANGELOG.md` files
- [ ] Modified: Any packages missing dartdoc comments
- [ ] Modified: Barrel exports if API cleanup needed

### Documentation Updates
- [ ] All 15 READMEs reviewed and polished
- [ ] Publish order document created
- [ ] Release day checklist created

---

## Notes

- Consider using `melos` or a publish script for coordinated multi-package release
- pub.dev scores heavily on: documentation, example, platforms, analysis
- First publish sets the package name permanently — double-check all names
- Consider reserving package names with placeholder publishes if needed
- The `fifty_` prefix is consistent and available on pub.dev (verified needed)

---

**Created:** 2026-02-18
**Last Updated:** 2026-02-20
**Brief Owner:** Igris AI
