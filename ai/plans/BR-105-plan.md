# Implementation Plan: BR-105 — Pub.dev Release Preparation

**Brief:** BR-105
**Complexity:** XL
**Estimated Duration:** 5-7 days
**Risk Level:** Medium
**Phases:** 8
**Files Affected:** 35+ (15 pubspec.yaml, 3 LICENSE, 4-5 example apps, 1 publish order doc)
**Created:** 2026-02-18
**Status:** Awaiting Approval

---

## Codebase Verification: Corrections to Audit Brief

| Package | Audit Brief Claim | Actual State |
|---------|------------------|--------------|
| fifty_sentences_engine | Has fifty_tokens path dep | NO path deps — CLEAN |
| fifty_map_engine | Has fifty_tokens, fifty_theme, fifty_ui path deps | NO path deps — CLEAN |
| fifty_speech_engine | Listed as clean (no path deps) | HAS fifty_tokens, fifty_theme, fifty_ui path deps |
| fifty_achievement_engine | fifty_tokens, fifty_theme, fifty_ui | fifty_tokens + fifty_ui only (no fifty_theme) |
| fifty_skill_tree | fifty_tokens, fifty_theme, fifty_ui | fifty_tokens ONLY |
| fifty_utils | LICENSE: MISSING | LICENSE: EXISTS |
| fifty_achievement_engine | LICENSE: check needed | LICENSE: MISSING (confirmed) |

**Confirmed missing LICENSE files: fifty_ui, fifty_forms, fifty_achievement_engine (3 packages)**

---

## Summary

Prepares all 15 Fifty Flutter Kit packages for pub.dev publication. Work spans 8 phases
aligned with the dependency graph. Actual `dart pub publish` is OUT OF SCOPE.
Success criterion: all 15 packages pass `dart pub publish --dry-run` with zero warnings.

---

## Canonical Values (All 15 Packages)

```
GitHub org:      fiftynotai  (confirmed via git remote)
Repository:      https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/{package_name}
Homepage:        https://fifty.dev
Issue tracker:   https://github.com/fiftynotai/fifty_flutter_kit/issues
License:         MIT Copyright (c) 2025 Fifty.ai
```

---

## Path Dep Strategy

Since packages are NOT yet on pub.dev, path deps convert to git references:

```yaml
fifty_tokens:
  git:
    url: https://github.com/fiftynotai/fifty_flutter_kit
    path: packages/fifty_tokens
    ref: main
```

After Phase 1 packages are live on pub.dev, subsequent packages' git refs convert to hosted deps (e.g. `fifty_tokens: ^1.0.0`). Example subdirectory pubspecs KEEP path deps.

---

## Topics Taxonomy

| Package | Proposed Topics |
|---------|----------------|
| fifty_tokens | flutter, design-tokens, design-system, theming |
| fifty_utils | flutter, utilities, extensions, dart |
| fifty_cache | dart, cache, ttl, http |
| fifty_storage | flutter, storage, secure-storage, preferences |
| fifty_theme | flutter, theming, design-system, material |
| fifty_ui | flutter, ui, components, design-system, widgets |
| fifty_forms | flutter, forms, validation, wizard |
| fifty_connectivity | flutter, connectivity, network, monitoring |
| fifty_audio_engine | flutter, audio, game, engine |
| fifty_printing_engine | flutter, printing, bluetooth, escpos |
| fifty_sentences_engine | flutter, game, text-processing |
| fifty_speech_engine | flutter, speech, tts, stt |
| fifty_map_engine | flutter, game, tilemap, flame |
| fifty_achievement_engine | flutter, game, achievements, gamification |
| fifty_skill_tree | flutter, game, skill-tree, rpg |

---

## Complete Package State Matrix

| Package | Version | LICENSE | example/ | publish_to:none | Path Deps | repo URL correct |
|---------|---------|---------|---------|----------------|-----------|-----------------|
| fifty_tokens | 1.0.0 | YES | Dart-only | NO | none | NO (individual repo) |
| fifty_utils | 0.1.0 | YES | NO | NO | none | NO (root, no path) |
| fifty_cache | 0.1.0 | YES | NO | NO | none | NO (anthropic org) |
| fifty_storage | 0.1.0 | YES | NO | NO | none | PARTIAL (has path, wrong org) |
| fifty_theme | 1.0.0 | YES | NO | NO | fifty_tokens | NO (individual repo) |
| fifty_ui | 0.6.0 | NO | YES | YES | fifty_tokens, fifty_theme | NO (root, no path) |
| fifty_forms | 0.1.0 | NO | YES | NO | fifty_tokens, fifty_theme, fifty_ui, fifty_storage | NO (wrong homepage) |
| fifty_connectivity | 0.1.0 | YES | YES | YES | fifty_tokens, fifty_ui, fifty_utils | PARTIAL (wrong org) |
| fifty_audio_engine | 0.7.0 | YES | YES | NO | fifty_tokens, fifty_theme, fifty_ui | NO (root, no path) |
| fifty_printing_engine | 1.0.0 | YES | YES | NO | none | NO (root, no path) |
| fifty_sentences_engine | 0.1.0 | YES | YES | NO | none | PARTIAL (wrong org) |
| fifty_speech_engine | 0.1.0 | YES | YES | NO | fifty_tokens, fifty_theme, fifty_ui | PARTIAL |
| fifty_map_engine | 0.1.0 | YES | YES | NO | none | PARTIAL (wrong org) |
| fifty_achievement_engine | 0.1.1 | NO | YES | NO | fifty_tokens, fifty_ui | NO (root, no path) |
| fifty_skill_tree | 0.1.0 | YES | YES | NO | fifty_tokens | NO (root, no path) |

---

## Implementation Phases

### Phase 0: Pre-work

1. Verify pub.dev approved topics list against proposed taxonomy
2. Check `escpos` current version on pub.dev (fifty_printing_engine uses `escpos: any`)
3. Decide on fifty_speech_engine barrel refactor (class + exports in same file)

### Phase 1: Foundation Packages (no internal deps — parallel)

**fifty_tokens** — Fix repository, add topics/issue_tracker
**fifty_utils** — Fix repository, add homepage/topics/issue_tracker, CREATE example/
**fifty_cache** — Fix repository (anthropic→fiftynotai), add topics/issue_tracker, CREATE example/ (pure Dart)
**fifty_storage** — Fix repository org, add topics/issue_tracker, CREATE example/

**Gate:** `flutter analyze && dart pub publish --dry-run` per package

### Phase 2: Core Theme

**fifty_theme** — Fix repository, add topics/issue_tracker, convert fifty_tokens path→git dep, CREATE example/, fix CHANGELOG (says v0.1.0 but version is 1.0.0)

**Gate:** `flutter analyze && dart pub publish --dry-run`

### Phase 3: fifty_ui + Clean Engine Packages (parallel after Phase 2)

**fifty_ui** — Remove `publish_to: none`, fix repository, add topics/issue_tracker, convert 2 path deps→git, CREATE LICENSE
**fifty_printing_engine** — Fix homepage/repository, add topics/issue_tracker, fix `escpos: any`
**fifty_sentences_engine** — Fix homepage/repository org, add topics/issue_tracker

**Gate:** dry-run per package

### Phase 4: Feature Packages

**fifty_forms** — Fix homepage, add repository, add topics/issue_tracker, convert 4 path deps→git, CREATE LICENSE
**fifty_connectivity** — Remove `publish_to: none`, fix repository org, add topics/issue_tracker, convert 3 path deps→git

**Gate:** dry-run per package

### Phase 5: Engine Packages with Path Deps

**fifty_audio_engine** — Fix homepage/repository, add topics/issue_tracker, convert 3 path deps→git (plugin package — verify platform stubs)
**fifty_speech_engine** — Fix homepage/repository, add topics/issue_tracker, convert 3 path deps→git
**fifty_achievement_engine** — Fix repository, add homepage/topics/issue_tracker, convert 2 path deps→git, CREATE LICENSE
**fifty_skill_tree** — Fix repository, add homepage/topics/issue_tracker, convert 1 path dep→git

**Gate:** dry-run per package

### Phase 6: Remaining Clean Engine

**fifty_map_engine** — Fix homepage/repository org, add topics/issue_tracker

**Gate:** dry-run

### Phase 7: Code Quality Pass

1. Run `dart doc` for all 15 — fix errors
2. Scan for undocumented public APIs — add dartdoc where missing
3. Remove TODO/FIXME/HACK from public API files
4. Remove `pubspec.lock` from git tracking for library packages
5. Standardize SDK constraints (some use `^3.6.0` vs `>=3.0.0 <4.0.0`)

### Phase 8: Final Validation + Documentation

1. Final dry-run sweep — all 15 packages, 0 warnings
2. Create `ai/context/publish_order.md` (sequence, versions, post-publish dep conversion)
3. Commit in phase batches — conventional commits

---

## Commit Strategy

```
chore(fifty_tokens): prepare for pub.dev release
chore(fifty_utils): prepare for pub.dev release — add example app
chore(fifty_cache): prepare for pub.dev release — add example
chore(fifty_storage): prepare for pub.dev release — add example
chore(fifty_theme): prepare for pub.dev release — convert path deps, add example
chore(fifty_ui,fifty_printing,fifty_sentences): prepare for pub.dev release
chore(fifty_forms,fifty_connectivity): prepare for pub.dev release
chore(engines): prepare engine packages for pub.dev release
chore(pub-dev): final quality pass and publish order document
```

---

## Publish Order Reference

```
Phase 1: fifty_tokens v1.0.0, fifty_utils v0.1.0, fifty_cache v0.1.0, fifty_storage v0.1.0
Phase 2: fifty_theme v1.0.0  [← fifty_tokens]
Phase 3: fifty_ui v0.6.0 [← tokens, theme], fifty_printing_engine v1.0.0, fifty_sentences_engine v0.1.0
Phase 4: fifty_forms v0.1.0 [← tokens, theme, ui, storage], fifty_connectivity v0.1.0 [← tokens, ui, utils]
Phase 5: fifty_audio_engine v0.7.0, fifty_speech_engine v0.1.0, fifty_map_engine v0.1.0, fifty_achievement_engine v0.1.1, fifty_skill_tree v0.1.0
```

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| git dep resolution fails during dry-run | Medium | High | Test git deps in isolated env; verify repo is public |
| `escpos: any` dry-run warning | High | Low | Research and pin version in Phase 3 |
| fifty_audio_engine plugin stub issues | Medium | Medium | Review platform files before dry-run |
| pub.dev topics not in approved list | Medium | Low | Check taxonomy; invalid topics silently ignored |
| fifty_theme CHANGELOG version mismatch | High | Low | Fix in Phase 2 |
| pubspec.lock tracked in git | High | Low | Phase 7 cleanup |
| SDK constraint inconsistency | Medium | Medium | Standardize in Phase 7 |

---

*Plan created: 2026-02-18 | Brief: BR-105 | Agent: PLANNER*
