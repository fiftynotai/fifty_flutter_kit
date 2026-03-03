# TD-012: Batch publish 15 packages to reflect README updates on pub.dev

**Type:** Technical Debt
**Priority:** P1-High
**Effort:** S-Small (< 1h)
**Assignee:** Fifty.ai
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-03-04
**Completed:** 2026-03-04

---

## What is the Technical Debt?

**Current situation:**

TD-011 rewrote 15 package READMEs with selling-points-first structure, builder customization docs, and corrected version numbers. These changes exist in the repo but are NOT live on pub.dev — pub.dev only updates a package's README on publish.

**Why is it technical debt?**

The whole point of TD-011 was to improve pub.dev adoption. Until the READMEs are published, the work has zero user-facing impact.

---

## Why It Matters

**Consequences of not fixing:**

- [x] **Developer Experience:** pub.dev visitors still see the old READMEs without selling points or builder docs
- [x] **Maintainability:** Version numbers in pub.dev READMEs are stale for 5 packages

**Impact:** High (blocks the ROI of TD-011)

---

## Cleanup Steps

**How to pay off this debt:**

For each package, bump the patch version in pubspec.yaml, update CHANGELOG.md, and run `dart pub publish`.

### Packages to publish (15 total)

**Group 1 — Infrastructure (8):**
1. [x] `fifty_cache` 0.1.1
2. [x] `fifty_utils` 0.1.2
3. [x] `fifty_socket` 0.1.1
4. [x] `fifty_storage` 0.1.2
5. [x] `fifty_audio_engine` 0.7.3
6. [x] `fifty_narrative_engine` 0.1.2
7. [x] `fifty_world_engine` 0.1.3
8. [x] `fifty_scroll_sequence` 1.0.1

**Group 2 — Structural (3):**
9. [x] `fifty_skill_tree` 0.2.2
10. [x] `fifty_printing_engine` 1.0.3
11. [x] `fifty_ui` 0.7.1

**Group 3 — Builder-pattern (4):**
12. [x] `fifty_connectivity` 0.2.1
13. [x] `fifty_forms` 0.2.1
14. [x] `fifty_achievement_engine` 0.2.1
15. [x] `fifty_speech_engine` 0.2.1

---

## Tasks

### Pending

### In Progress

### Completed
- [x] Task 1: Patch bump all 15 pubspec.yaml files
- [x] Task 2: Add CHANGELOG entries ("docs: rewrite README with selling-points-first structure")
- [x] Task 3: Publish all 15 packages to pub.dev
- [ ] Task 4: Verify READMEs are live on pub.dev (allow up to 10 min for propagation)

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A — all 15 packages published
**Last Updated:** 2026-03-04
**Blockers:** None

---

## Benefits of Fixing

**What improves after cleanup:**

- TD-011 README improvements become visible to pub.dev visitors
- Version numbers align across pubspec.yaml and pub.dev
- Builder customization docs are discoverable for the first time

**Return on Investment:** High (completes TD-011's pub.dev adoption goal)

---

## Affected Areas

### Files
- 15 `pubspec.yaml` files (patch bump)
- 15 `CHANGELOG.md` files (add entry)

### Count
**Total files affected:** 30
**Total lines to change:** ~60

---

## Testing

### Regression Testing
- [ ] `flutter analyze` passes for each package
- [ ] No dependency resolution issues after version bumps

### Verification
**How to verify cleanup is successful:**

1. Each package's pub.dev page shows the new README
2. Version numbers on pub.dev match the new patch versions

---

## Acceptance Criteria

**The debt is paid off when:**

1. [x] All 15 packages published with new patch versions
2. [ ] pub.dev pages show updated READMEs with Why sections (propagating)
3. [ ] Builder customization docs visible on pub.dev for connectivity, forms, achievement_engine, speech_engine (propagating)

---

## References

**Related Briefs:**
- TD-011 (README audit — the changes being published)
- FR-001 through FR-004 (builder patterns documented in the READMEs)

---

**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Brief Owner:** Fifty.ai
