# BR-108: Sync CHANGELOG.md with Current Versions for All Packages

**Type:** Bug (pub.dev Score)
**Priority:** P1-High
**Effort:** S-Small (<1d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-02-22
**Completed:**

---

## Problem

**What's broken or missing?**

14 of 15 packages have CHANGELOG.md files that do not reference the current pubspec version. pub.dev deducts 5 points per package for this ("Provide a valid CHANGELOG.md — CHANGELOG.md does not contain reference to the current version"). This drops each package from 160 to 155 pub points.

All CHANGELOGs were initialized with a generic `## 1.0.0` entry during BR-105 release preparation, but the actual published versions differ (many are 0.x.y). Subsequent patch bumps (BR-107) further widened the gap.

**Why does it matter?**

- 5 pub points lost per package (155/160 instead of 160/160)
- Lower pub.dev scores affect package discoverability and trust
- CHANGELOGs should accurately document version history

---

## Goal

**What should happen after this brief is completed?**

All 14 affected packages have CHANGELOG.md entries matching their current pubspec version. pub.dev awards full 160/160 points for documentation.

---

## Context & Inputs

### Affected Packages (14 — all except fifty_theme)

| Package | Current Version | CHANGELOG Latest | Status |
|---------|----------------|-----------------|--------|
| `fifty_tokens` | 1.0.1 | 1.0.0 | MISMATCH |
| `fifty_ui` | 0.6.1 | 1.0.0 | MISMATCH |
| `fifty_forms` | 0.1.1 | 1.0.0 | MISMATCH |
| `fifty_connectivity` | 0.1.1 | 1.0.0 | MISMATCH |
| `fifty_utils` | 0.1.0 | 1.0.0 | MISMATCH |
| `fifty_cache` | 0.1.0 | 1.0.0 | MISMATCH |
| `fifty_storage` | 0.1.0 | 1.0.0 | MISMATCH |
| `fifty_printing_engine` | 1.0.1 | 1.0.0 | MISMATCH |
| `fifty_narrative_engine` | 0.1.1 | 1.0.0 | MISMATCH |
| `fifty_audio_engine` | 0.7.1 | 1.0.0 | MISMATCH |
| `fifty_speech_engine` | 0.1.1 | 1.0.0 | MISMATCH |
| `fifty_achievement_engine` | 0.1.2 | 1.0.0 | MISMATCH |
| `fifty_skill_tree` | 0.1.1 | 1.0.0 | MISMATCH |
| `fifty_world_engine` | 0.1.1 | 1.0.0 | MISMATCH |

**OK (no change needed):**
| `fifty_theme` | 1.0.0 | 1.0.0 | OK |

### CHANGELOG Format

Follow [Keep a Changelog](https://keepachangelog.com/) convention:

```markdown
## x.y.z

- Description of changes

## previous.version

- Previous changes
```

### Version History Summary

Most packages went through this version sequence:
1. **Initial publish** (various versions: 0.1.0, 0.6.0, 0.7.0, 1.0.0)
2. **Patch bump** (BR-107: screenshot URLs + pubspec screenshots field)

For packages at 0.x.0 (utils, cache, storage), the CHANGELOG has `1.0.0` but the actual version is `0.1.0` — the entire CHANGELOG needs rewriting.

---

## Constraints

### Architecture Rules
- Each CHANGELOG must have an entry for the **current** pubspec version at the top
- Use Keep a Changelog format
- Include accurate descriptions of what changed per version
- Published packages need re-publish to update pub.dev score

### Out of Scope
- `fifty_theme` (already correct at 1.0.0)
- Adding CHANGELOGs to packages that don't have one

---

## Tasks

### Pending

**Task 1 — Rewrite/update CHANGELOGs (14 packages):**
- [ ] Read each CHANGELOG.md to understand current content
- [ ] Rewrite with accurate version entries matching pubspec version
- [ ] Include brief descriptions of what shipped in each version

**Task 2 — Re-publish to pub.dev (14 packages):**
- [ ] Convert path deps to hosted
- [ ] Publish all 14 packages
- [ ] Revert path deps for local dev

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] All 15 packages: CHANGELOG.md top entry matches pubspec version
2. [ ] pub.dev awards 5/5 for "Provide a valid CHANGELOG.md" on all packages
3. [ ] CHANGELOG entries have accurate, meaningful descriptions

---

## Test Plan

### Automated Tests
- [ ] For each package: top version in CHANGELOG.md == version in pubspec.yaml
- [ ] `dart pub publish --dry-run` passes for all packages

### Manual Test Cases
- [ ] Visit pub.dev package pages after re-publish, verify 160/160 score

---

## Notes

- The repo/issue_tracker URL errors (Repository URL doesn't exist / Issue tracker URL doesn't exist) should self-resolve now that the repo is public. pub.dev re-analyzes periodically. If they persist after re-publish, the URLs may need adjustment.
- Re-publishing for CHANGELOG fixes can be done without version bumps since the content at the current version is being corrected, but pub.dev only refreshes on new version upload. A micro-bump or `dart pub publish` of the same version won't work — we may need another patch bump.

---

**Created:** 2026-02-22
**Last Updated:** 2026-02-22
**Brief Owner:** Igris AI
