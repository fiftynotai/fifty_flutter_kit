# BR-106: Remove Stale "Kinetic Brutalism" References from Documentation

**Type:** Bug (Doc Misalignment)
**Priority:** P2-Medium
**Effort:** S-Small (<1d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-20
**Completed:**

---

## Problem

**What's broken or missing?**

The FDL v2 design language originally carried the subtitle "Kinetic Brutalism" but this branding was dropped. The current FDL v2 spec is **modern sophisticated** — defined as: burgundy primary, mode-aware colors, Manrope typography, motion tokens (see `packages/fifty_ui/definition.md`).

However, 30 files across the repo still reference "Kinetic Brutalism", including published package READMEs (fifty_ui, fifty_tokens, fifty_connectivity), source code comments, briefs, plans, templates, and coding guidelines. Since 12 packages are already live on pub.dev, the published READMEs carry stale branding.

**Why does it matter?**

- Published READMEs on pub.dev describe a design philosophy that no longer applies
- Inconsistency between the actual FDL spec and documentation confuses contributors and consumers
- "Kinetic Brutalism" implies heavy/raw aesthetics which contradicts the current modern sophisticated direction

---

## Goal

**What should happen after this brief is completed?**

Zero references to "Kinetic Brutalism" remain in the codebase. All FDL v2 descriptions updated to reflect the current modern sophisticated direction.

---

## Context & Inputs

### Affected Files (30 files, ~35 references)

**Published package docs (CRITICAL — already live on pub.dev):**
- `packages/fifty_ui/README.md` (2 refs)
- `packages/fifty_ui/example/lib/main.dart` (2 refs)
- `packages/fifty_tokens/README.md` (1 ref)
- `packages/fifty_connectivity/README.md` (2 refs)
- `packages/fifty_connectivity/lib/src/widgets/connection_handler.dart` (1 ref)
- `packages/fifty_connectivity/lib/src/widgets/connection_overlay.dart` (3 refs)
- `packages/fifty_printing_engine/CHANGELOG.md` (1 ref)

**Architecture/guidelines:**
- `ai/context/coding_guidelines.md` (1 ref)

**Briefs (historical — lower priority):**
- `ai/briefs/UI-001-fdl-compliance-redesign.md` (2 refs)
- `ai/briefs/UI-002-missing-components-effects.md` (1 ref)
- `ai/briefs/UI-003-component-enhancements.md` (1 ref)
- `ai/briefs/UI-004-form-components.md` (1 ref)
- `ai/briefs/BR-009-fifty-theme-package.md` (2 refs)
- `ai/briefs/BR-010-fifty-ui-component-library.md` (4 refs)
- `ai/briefs/BR-012-fifty-audio-engine-example.md` (1 ref)
- `ai/briefs/BR-020-fifty-arch-example-redesign.md` (2 refs)
- `ai/briefs/BR-064-bgm-playlist-ui-redesign.md` (1 ref)
- `ai/briefs/MG-003-design-system-v2-migration.md` (1 ref)
- `ai/session/archive/briefs/UI-005-printing-engine-fdl-compliance.md` (1 ref)

**Plans (historical):**
- `ai/plans/BR-071-ui-design.md` (1 ref)
- `ai/plans/BR-075-sneaker-site-ui-design.md` (1 ref)
- `ai/plans/MG-003-plan.md` (1 ref)

**Templates:**
- `templates/mvvm_actions/test/modules/theme/theme_view_model_test.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/locale/views/language_drawer_item.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/locale/views/language_dialog.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/auth/views/login.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/auth/views/register.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/auth/views/splash.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/menu/views/side_menu_drawer.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/menu/views/menu_drawer_item.dart` (1 ref)
- `templates/mvvm_actions/lib/src/modules/menu/views/logout_drawer_item.dart` (1 ref)

### Current FDL v2 Description (from definition.md)

> FDL v2 specification: Burgundy primary, mode-aware colors, Manrope typography, motion tokens.

---

## Constraints

### Architecture Rules
- Replace "FDL v2 Kinetic Brutalism" with accurate FDL v2 description
- Do not change component behavior or code logic — doc changes only (except where "Kinetic Brutalism" appears in code comments)
- Published packages that get README updates will need version bumps and re-publish

### Out of Scope
- Renaming `KineticEffect` widget class — this is a code API, not branding
- Re-publishing packages (separate step after changes)

---

## Tasks

### Pending

**Priority 1 — Published packages (affects pub.dev):**
- [ ] Update `packages/fifty_ui/README.md` — replace FDL v2 Kinetic Brutalism section
- [ ] Update `packages/fifty_ui/example/lib/main.dart` — update comments
- [ ] Update `packages/fifty_tokens/README.md` — replace reference
- [ ] Update `packages/fifty_connectivity/README.md` — replace references
- [ ] Update `packages/fifty_connectivity/lib/src/widgets/connection_handler.dart` — update comment
- [ ] Update `packages/fifty_connectivity/lib/src/widgets/connection_overlay.dart` — update comments
- [ ] Update `packages/fifty_printing_engine/CHANGELOG.md` — update reference

**Priority 2 — Architecture/guidelines:**
- [ ] Update `ai/context/coding_guidelines.md` — replace reference

**Priority 3 — Templates:**
- [ ] Update all 9 `templates/mvvm_actions/` files — replace references

**Priority 4 — Historical briefs/plans (optional cleanup):**
- [ ] Update briefs and plans referencing Kinetic Brutalism (13 files)

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `grep -ri "kinetic brutalism" --include="*.md" --include="*.dart" --include="*.yaml"` returns zero results
2. [ ] All FDL v2 descriptions accurately reflect the current design direction
3. [ ] No code logic or widget behavior changed
4. [ ] `KineticEffect` class name preserved (it's an API, not branding)

---

## Test Plan

### Automated Tests
- [ ] `grep -ri "kinetic brutalism"` returns 0 matches
- [ ] `flutter analyze` passes on affected packages

### Manual Test Cases
- [ ] Review updated README sections for accuracy and coherence

---

## Notes

- The `KineticEffect` widget class name should NOT be renamed — it describes the animation behavior (scale on hover/press), not the design language branding
- Published packages (fifty_ui, fifty_tokens, fifty_connectivity, fifty_printing_engine) will need patch version bumps and re-publish to update pub.dev READMEs
- Historical briefs/plans are lower priority since they're internal-only

---

**Created:** 2026-02-20
**Last Updated:** 2026-02-20
**Brief Owner:** Igris AI
