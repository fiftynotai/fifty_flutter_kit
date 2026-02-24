# BR-115: Standardize All Package READMEs to FDL Template v2

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** In Progress
**Created:** 2026-02-24
**Completed:**

---

## Problem

**What's broken or missing?**

Fifty Flutter Kit's 16 published packages have inconsistent README documentation. A SEEKER audit revealed:

- **0/16 packages** have pub.dev badges (only fifty_socket has them post-review fix)
- **2/16 packages** (fifty_cache, fifty_storage) lack screenshots entirely
- **1/16 packages** (fifty_socket) has the newer superior format but deviates from ecosystem ordering
- **Installation sections** show path/git refs instead of pub.dev version constraints (all packages are now published)
- **Platform Support** missing from fifty_socket; inconsistent depth across others
- **No Configuration sections** on packages that need them (audio_engine, forms, connectivity)
- **No Error Handling sections** on packages that have typed error systems
- **State machine diagrams** missing from stateful packages (audio_engine, connectivity)
- **Quick Start length** varies wildly (5 lines to 40+ lines) with no consistent standard

The FDL README Template has been upgraded to **v2** (`ai/context/readme_template.md`) incorporating the best patterns from fifty_socket and the ecosystem. All packages now need to be brought into compliance.

**Why does it matter?**

Fifty Flutter Kit is a superior toolkit and deserves superior documentation. Consistent, high-quality READMEs across all 16 packages:
- Increase pub.dev scores (documentation is a scoring factor)
- Reduce developer onboarding friction
- Establish professional brand consistency
- Make the ecosystem feel like one cohesive product, not 16 disconnected packages

---

## Goal

**What should happen after this brief is completed?**

All 16 package READMEs follow FDL README Template v2 exactly. Every README passes the Compliance Checklist in `ai/context/readme_template.md`. The ecosystem documentation is best-in-class on pub.dev.

---

## Context & Inputs

### Affected Packages

All 16 published packages:

| # | Package | Current State | Key Gaps |
|---|---------|--------------|----------|
| 1 | fifty_tokens | v1 template | No badges, path-only install |
| 2 | fifty_theme | v1 template | No badges, path-only install |
| 3 | fifty_ui | v1 template | No badges, path-only install |
| 4 | fifty_forms | v1 template | No badges, path-only install, needs Configuration section |
| 5 | fifty_utils | v1 template | No badges, path-only install |
| 6 | fifty_cache | v1 template | No badges, no screenshots, path-only install |
| 7 | fifty_storage | v1 template | No badges, no screenshots, path-only install |
| 8 | fifty_connectivity | v1 template | No badges, path-only install |
| 9 | fifty_audio_engine | v1 template | No badges, path-only install, needs Configuration section |
| 10 | fifty_speech_engine | v1 template | No badges, path-only install |
| 11 | fifty_narrative_engine | v1 template | No badges, path-only install |
| 12 | fifty_world_engine | v1 template | No badges, path-only install |
| 13 | fifty_printing_engine | v1 template | No badges, path-only install |
| 14 | fifty_skill_tree | v1 template | No badges, path-only install |
| 15 | fifty_achievement_engine | v1 template | No badges, path-only install |
| 16 | fifty_socket | v2 (partial) | Missing Platform Support, state machine should be in Architecture |

### Layers Touched
- [ ] View (UI widgets)
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)
- [x] Other: Documentation only (README.md files)

### API Changes
- [x] No API changes

### Dependencies
- No new dependencies

### Related Files
- `ai/context/readme_template.md` — the v2 standard (already updated)
- `packages/*/README.md` — all 16 package READMEs
- `packages/*/pubspec.yaml` — verify version numbers, add `screenshots:` fields where missing

---

## Constraints

### Architecture Rules
- Must follow FDL README Template v2 exactly
- All 10 mandatory sections in correct order
- Optional sections only where inclusion criteria are met
- Preserve all existing technical content and code examples

### Technical Constraints
- README changes only — no code changes
- pubspec.yaml changes limited to `screenshots:` field additions
- All code examples must remain syntactically valid
- No hardcoded IPs, API keys, or credentials

### Timeline
- **Deadline:** N/A (quality over speed)
- **Milestones:** Process in batches of 4 packages

### Out of Scope
- Creating new screenshots for packages that don't have them (fifty_cache, fifty_storage)
- Code changes to any package
- Version bumps (README changes don't warrant version bumps)
- Root README changes (already up to date)

---

## Tasks

### Pending

**Batch 1: Foundation Layer (tokens, theme, ui, utils)**
- [ ] Task 1: Rewrite fifty_tokens README to v2 template
- [ ] Task 2: Rewrite fifty_theme README to v2 template
- [ ] Task 3: Rewrite fifty_ui README to v2 template
- [ ] Task 4: Rewrite fifty_utils README to v2 template

**Batch 2: Infrastructure Layer (forms, cache, storage, connectivity)**
- [ ] Task 5: Rewrite fifty_forms README to v2 template (add Configuration section)
- [ ] Task 6: Rewrite fifty_cache README to v2 template (note: no screenshots)
- [ ] Task 7: Rewrite fifty_storage README to v2 template (note: no screenshots)
- [ ] Task 8: Rewrite fifty_connectivity README to v2 template

**Batch 3: Engine Layer (audio, speech, narrative, world)**
- [ ] Task 9: Rewrite fifty_audio_engine README to v2 template (add Configuration section)
- [ ] Task 10: Rewrite fifty_speech_engine README to v2 template
- [ ] Task 11: Rewrite fifty_narrative_engine README to v2 template
- [ ] Task 12: Rewrite fifty_world_engine README to v2 template

**Batch 4: Game + Utility Layer (printing, skill_tree, achievement, socket)**
- [ ] Task 13: Rewrite fifty_printing_engine README to v2 template
- [ ] Task 14: Rewrite fifty_skill_tree README to v2 template
- [ ] Task 15: Rewrite fifty_achievement_engine README to v2 template
- [ ] Task 16: Update fifty_socket README to v2 compliance (add Platform Support, move state machine to Architecture)

**Verification**
- [ ] Task 17: Run compliance checklist on all 16 READMEs
- [ ] Task 18: Verify all pubspec.yaml `screenshots:` fields are present where applicable

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** INIT — Brief loaded, starting HUNT workflow
**Next Steps When Resuming:** Proceed to PLANNING phase
**Last Updated:** 2026-02-24 19:00
**Blockers:** None

## Workflow State

**Phase:** BUILDING
**Active Agent:** forger (x4 parallel)
**Retry Count:** 0

### Agent Log
| Time | Agent | Action | Result |
|------|-------|--------|--------|
| 2026-02-24 19:00 | — | INIT phase | Brief loaded |
| 2026-02-24 19:10 | architect | Create implementation plan | SUCCESS — 16 packages audited, 4 batches planned |
| 2026-02-24 19:15 | forger x4 | Batch 1: Foundation Layer | IN PROGRESS |

---

## Acceptance Criteria

**The refactor is complete when:**

1. [ ] All 16 package READMEs follow FDL README Template v2
2. [ ] All 16 READMEs have pub.dev + license badges
3. [ ] All 16 READMEs show pub.dev install (primary) + path install (contributor)
4. [ ] All 16 READMEs have Platform Support tables
5. [ ] All 16 READMEs have Architecture section with ASCII diagram + Core Components table
6. [ ] Packages with config objects have Configuration sections (forms, audio_engine, socket, connectivity)
7. [ ] Packages with typed errors have Error Handling sections (socket, connectivity, audio_engine)
8. [ ] All code examples are syntactically valid Dart
9. [ ] All pubspec.yaml files have `screenshots:` field (where screenshots exist)
10. [ ] No hardcoded IPs, API keys, or credentials in any README
11. [ ] Compliance checklist passes for all 16 packages

---

## Test Plan

### Automated Tests
- No automated tests (documentation-only change)

### Manual Test Cases

#### Test Case 1: Compliance Verification
**Preconditions:** All 16 READMEs rewritten
**Steps:**
1. Run compliance checklist from `ai/context/readme_template.md` on each README
2. Verify section count, order, and naming
3. Verify badges link to correct pub.dev page
4. Verify version numbers match pubspec.yaml

**Expected Result:** All 16 pass with zero deviations
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: pub.dev Rendering
**Preconditions:** Changes pushed to GitHub
**Steps:**
1. Check each package on pub.dev
2. Verify README renders correctly (tables, code blocks, images, badges)

**Expected Result:** Clean rendering on pub.dev for all packages
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [ ] Modified files: 16 README.md files across `packages/*/`
- [ ] Modified files: Up to 16 pubspec.yaml files (screenshots field)

### Documentation Updates
- [x] README template v2 updated: `ai/context/readme_template.md`
- [ ] All 16 package READMEs standardized

### Deployment Notes
- No app restart needed
- No backend changes
- README changes are non-breaking
- Consider batch-publishing updated packages to refresh pub.dev pages

---

## Notes

### Execution Strategy

This brief is ideal for **parallel FORGER execution** — each package README is independent. Can process in batches of 4 with parallel agents.

### Reference Implementations

After completion, these three packages serve as reference implementations at different complexity levels:

| Package | Complexity | Notable Patterns |
|---------|-----------|-----------------|
| `fifty_connectivity` | Medium | Clean 10-section structure, platform-specific setup |
| `fifty_audio_engine` | High | Deep API Reference with stream docs, Configuration section |
| `fifty_socket` | High | Configuration, Error Handling, state machine in Architecture |

---

**Created:** 2026-02-24
**Last Updated:** 2026-02-24
**Brief Owner:** Fifty.ai
