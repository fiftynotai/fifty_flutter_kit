# BR-107: Fix Screenshots Not Loading on pub.dev Package Pages

**Type:** Bug
**Priority:** P1-High
**Effort:** M-Medium (2-3d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-02-20
**Completed:**

---

## Problem

**What's broken or missing?**

Screenshots display correctly on GitHub but fail to load on pub.dev package pages. This affects all 12 published packages that include screenshots in their READMEs.

**Root Cause:** All READMEs use relative image paths (`<img src="screenshots/home_dark.png">`). GitHub resolves these relative to the file's location in the repository, so they render correctly. pub.dev cannot resolve relative paths — it needs absolute URLs pointing to the raw image content on GitHub.

**Secondary Issue:** None of the 15 `pubspec.yaml` files declare the `screenshots:` field. pub.dev supports a native screenshot gallery in the package sidebar via this field, which is separate from README images.

**Why does it matter?**

- 12 packages are live on pub.dev with broken screenshots — this is the first thing users see
- pub.dev scores factor in documentation quality including screenshots
- Broken images make packages appear unmaintained or incomplete

---

## Goal

**What should happen after this brief is completed?**

All package screenshots render correctly on both GitHub and pub.dev. The `screenshots:` field is declared in pubspec.yaml for packages that have screenshots.

---

## Context & Inputs

### Affected Packages (12 with screenshots)

| Package | Screenshot Location | Count | Published |
|---------|-------------------|-------|-----------|
| `fifty_ui` | `screenshots/` | 4 | Live |
| `fifty_printing_engine` | `screenshots/` | 4 | Live |
| `fifty_forms` | `screenshots/` | 4 | Live |
| `fifty_connectivity` | `example/screenshots/` | 4 | Live |
| `fifty_narrative_engine` | `screenshots/` | 3 | Live |
| `fifty_audio_engine` | `screenshots/` | 4 | Live |
| `fifty_speech_engine` | `screenshots/` | 2 | Live |
| `fifty_achievement_engine` | `screenshots/` | 4 | Pending |
| `fifty_skill_tree` | `screenshots/` | 4 | Pending |
| `fifty_world_engine` | `screenshots/` | 2 | Pending |
| `fifty_tokens` | _(no screenshots)_ | 0 | Live |
| `fifty_theme` | _(no screenshots)_ | 0 | Live |
| `fifty_cache` | _(no screenshots)_ | 0 | Live |
| `fifty_storage` | _(no screenshots)_ | 0 | Live |
| `fifty_utils` | _(no screenshots)_ | 0 | Live |

### Current (Broken) Pattern

```html
<img src="screenshots/gallery_dark.png" width="200">
```

### Required Fix Pattern

```html
<img src="https://raw.githubusercontent.com/fiftynotai/fifty_flutter_kit/main/packages/fifty_ui/screenshots/gallery_dark.png" width="200">
```

Base URL pattern:
```
https://raw.githubusercontent.com/fiftynotai/fifty_flutter_kit/main/packages/{package_name}/{screenshot_path}
```

### pubspec.yaml screenshots field

pub.dev also supports a native `screenshots:` section in pubspec.yaml for the package sidebar gallery:

```yaml
screenshots:
  - description: 'Gallery overview in dark mode'
    path: screenshots/gallery_dark.png
```

---

## Constraints

### Architecture Rules
- URLs must work on both GitHub and pub.dev simultaneously
- Use `raw.githubusercontent.com` URLs (not GitHub blob URLs)
- Pin to `main` branch in URLs (not commit SHAs — screenshots update rarely)
- The `screenshots:` pubspec field uses local relative paths (pub.dev uploads them from the package archive)

### Technical Constraints
- Published packages need patch version bumps and re-publish to update pub.dev
- 3 unpublished packages (world_engine, achievement_engine, skill_tree) can be fixed before first publish
- `fifty_connectivity` screenshots are in `example/screenshots/` — different path depth

### Out of Scope
- Taking new screenshots or changing existing images
- Adding screenshots to packages that don't have them (tokens, theme, cache, storage, utils)

---

## Tasks

### Pending

**Task 1 — Convert README image paths to absolute URLs (12 packages):**
- [ ] `fifty_ui/README.md` — 4 images
- [ ] `fifty_printing_engine/README.md` — 4 images
- [ ] `fifty_forms/README.md` — 4 images
- [ ] `fifty_connectivity/README.md` — 4 images (note: `example/screenshots/` path)
- [ ] `fifty_narrative_engine/README.md` — 3 images
- [ ] `fifty_audio_engine/README.md` — 4 images
- [ ] `fifty_speech_engine/README.md` — 2 images
- [ ] `fifty_achievement_engine/README.md` — 4 images
- [ ] `fifty_skill_tree/README.md` — 4 images
- [ ] `fifty_world_engine/README.md` — 2 images

**Task 2 — Add `screenshots:` field to pubspec.yaml (10 packages with screenshots):**
- [ ] `fifty_ui/pubspec.yaml`
- [ ] `fifty_printing_engine/pubspec.yaml`
- [ ] `fifty_forms/pubspec.yaml`
- [ ] `fifty_connectivity/pubspec.yaml`
- [ ] `fifty_narrative_engine/pubspec.yaml`
- [ ] `fifty_audio_engine/pubspec.yaml`
- [ ] `fifty_speech_engine/pubspec.yaml`
- [ ] `fifty_achievement_engine/pubspec.yaml`
- [ ] `fifty_skill_tree/pubspec.yaml`
- [ ] `fifty_world_engine/pubspec.yaml`

**Task 3 — Version bump and re-publish (10 already-published packages):**
- [ ] Bump patch versions for packages with README/pubspec changes
- [ ] Convert path deps → hosted deps
- [ ] Publish updated versions
- [ ] Revert path deps back for local dev

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] All README screenshots render correctly on pub.dev package pages
2. [ ] All README screenshots still render correctly on GitHub
3. [ ] `screenshots:` field declared in pubspec.yaml for all packages with screenshots
4. [ ] Updated packages re-published to pub.dev with new versions

---

## Test Plan

### Manual Test Cases

#### Test Case 1: pub.dev Screenshot Rendering
**Steps:**
1. Visit each package page on pub.dev
2. Verify all screenshots load in the README tab
3. Verify screenshots appear in the sidebar gallery (from pubspec `screenshots:` field)

**Expected Result:** All images load correctly
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: GitHub Screenshot Rendering
**Steps:**
1. Visit each package README on GitHub
2. Verify all screenshots still load correctly with absolute URLs

**Expected Result:** All images load correctly (no regression)
**Status:** [ ] Pass / [ ] Fail

---

## Notes

- This can be combined with BR-106 (stale branding removal) into a single publish cycle to minimize version bumps
- The 3 unpublished packages (world_engine, achievement_engine, skill_tree) can be fixed before their first publish — no extra version bump needed
- pub.dev caches README content at publish time, so re-publishing is required for already-published packages

---

**Created:** 2026-02-20
**Last Updated:** 2026-02-20
**Brief Owner:** Igris AI
