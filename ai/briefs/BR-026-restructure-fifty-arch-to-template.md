# BR-026: Restructure fifty_arch as Template

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready

---

## Problem

**What's broken or missing?**

`fifty_arch` is located in `packages/` alongside true packages, but it's fundamentally different:
- It has a `main.dart` entry point (runnable app)
- It contains example modules meant to be modified (auth, menu, space)
- It has asset folders
- It's meant to be cloned/forked, not imported as a dependency

This creates confusion about how to use it properly.

**Why does it matter?**

- New users may try to `import` it like other packages instead of forking it
- The name `fifty_arch` doesn't describe the pattern (MVVM + Actions)
- Mixing templates with packages in the same folder obscures the ecosystem structure
- Future templates (clean_arch, bloc_pattern) would have no logical home

---

## Goal

**What should happen after this brief is completed?**

1. `fifty_arch` moved from `packages/` to new `templates/` directory
2. Renamed to `mvvm_actions` to describe the architectural pattern
3. All internal references updated
4. Documentation updated to explain packages vs templates distinction
5. Clear migration guide for existing users

---

## Context & Inputs

### Current Structure
```
packages/
├── fifty_tokens/          # Package (import)
├── fifty_theme/           # Package (import)
├── fifty_ui/              # Package (import)
├── fifty_cache/           # Package (import)
├── fifty_storage/         # Package (import)
├── fifty_utils/           # Package (import)
├── fifty_connectivity/    # Package (import)
├── fifty_arch/            # Template (fork) <- MISPLACED
├── fifty_audio_engine/    # Package (import)
├── fifty_speech_engine/   # Package (import)
├── fifty_sentences_engine/# Package (import)
└── fifty_map_engine/      # Package (import)
```

### Target Structure
```
packages/                  # True packages (import and use)
├── fifty_tokens/
├── fifty_theme/
├── fifty_ui/
├── fifty_cache/
├── fifty_storage/
├── fifty_utils/
├── fifty_connectivity/
├── fifty_audio_engine/
├── fifty_speech_engine/
├── fifty_sentences_engine/
└── fifty_map_engine/

templates/                 # Scaffolds (clone and customize)
└── mvvm_actions/          # Renamed from fifty_arch
    ├── lib/
    │   └── src/
    │       ├── core/
    │       ├── config/
    │       ├── infrastructure/
    │       ├── modules/
    │       ├── presentation/
    │       └── utils/
    ├── test/
    ├── assets/
    ├── pubspec.yaml
    ├── README.md
    ├── CHANGELOG.md
    └── MIGRATION_GUIDE.md
```

### Files Requiring Updates

| File | Change |
|------|--------|
| `packages/fifty_arch/` | Move to `templates/mvvm_actions/` |
| `pubspec.yaml` (template) | Update name to `mvvm_actions` |
| `README.md` (root) | Update structure docs, add templates section |
| `README.md` (template) | Update to reflect template nature |
| Path dependencies | Update all `../fifty_arch` to `../../templates/mvvm_actions` |
| Session docs | Update package count and structure |
| GitHub releases | Document the rename in release notes |

### Breaking Changes

1. **Package name change**: `fifty_arch` → `mvvm_actions`
2. **Location change**: `packages/` → `templates/`
3. **Import paths**: Any direct imports need updating
4. **Git history**: File moves may affect blame/history

---

## Tasks

### Pending
- [ ] Create `templates/` directory
- [ ] Move `packages/fifty_arch/` to `templates/mvvm_actions/`
- [ ] Update `pubspec.yaml` name to `mvvm_actions`
- [ ] Update internal path dependencies (tokens, theme, ui, etc.)
- [ ] Update root README.md with new structure
- [ ] Update template README.md to explain it's a template
- [ ] Add "How to Use This Template" section
- [ ] Update CHANGELOG.md with rename
- [ ] Update ai/session/CURRENT_SESSION.md
- [ ] Run `flutter pub get` to verify dependencies
- [ ] Run `dart analyze` to verify no issues
- [ ] Run `flutter test` to verify tests pass
- [ ] Commit with detailed migration notes
- [ ] Tag as `mvvm_actions-v0.8.0` (or v1.0.0?)
- [ ] Create GitHub release with migration guide

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `templates/mvvm_actions/` exists with all content from fifty_arch
2. [ ] `packages/fifty_arch/` no longer exists
3. [ ] `flutter pub get` succeeds in template
4. [ ] `dart analyze` passes (zero errors)
5. [ ] `flutter test` passes (all tests green)
6. [ ] Root README documents packages vs templates distinction
7. [ ] Template README explains how to use (fork, not import)
8. [ ] CHANGELOG documents the restructure
9. [ ] Git commit includes migration notes

---

## Delivery

### New Template Structure
```
templates/mvvm_actions/
├── lib/
│   └── src/
│       ├── app.dart
│       ├── main.dart
│       ├── core/
│       │   ├── bindings/
│       │   ├── errors/
│       │   ├── presentation/
│       │   └── routing/
│       ├── config/
│       ├── infrastructure/
│       │   └── http/
│       ├── modules/
│       │   ├── auth/
│       │   ├── locale/
│       │   ├── menu/
│       │   ├── space/
│       │   └── theme/
│       ├── presentation/
│       └── utils/
├── test/
├── assets/
│   ├── images/
│   ├── animations/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── MIGRATION_GUIDE.md
└── LICENSE
```

### Version Strategy

Option A: Continue versioning (v0.8.0)
- Pros: Continuity with existing releases
- Cons: Name change mid-version is confusing

Option B: Reset to v1.0.0
- Pros: Clean slate for new identity
- Cons: Breaks semantic versioning continuity

**Recommendation:** v1.0.0 - The rename is significant enough to warrant a major version reset.

---

## Dependencies

### Packages Template Depends On
- fifty_tokens (path: ../../packages/fifty_tokens)
- fifty_theme (path: ../../packages/fifty_theme)
- fifty_ui (path: ../../packages/fifty_ui)
- fifty_cache (path: ../../packages/fifty_cache)
- fifty_storage (path: ../../packages/fifty_storage)
- fifty_utils (path: ../../packages/fifty_utils)
- fifty_connectivity (path: ../../packages/fifty_connectivity)

### No Reverse Dependencies
No packages depend on fifty_arch (it's a template, not a library).

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Git history confusion | Medium | Low | Use `git mv` for proper tracking |
| Broken CI/CD | Low | Medium | Update any workflows referencing old path |
| User confusion | Medium | Medium | Comprehensive migration guide |
| Missed references | Medium | Low | Grep for "fifty_arch" after move |

---

## Notes

- This is a structural/organizational change, not a code change
- The template's internal code remains the same
- Consider adding more templates in future (clean_arch, bloc_pattern)
- May want to add a template generator CLI in future

---

**Created:** 2025-12-31
**Brief Owner:** Igris AI
