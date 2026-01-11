# Implementation Plan: TD-001

**Complexity:** L (Large)
**Estimated Duration:** 4-6 hours
**Risk Level:** Medium
**Created:** 2026-01-11

---

## Executive Summary

Refactor fifty_demo to align with the canonical MVVM+Actions template. This involves:
1. Fixing Actions classes to properly use ActionPresenter's `actionHandler()` method
2. Renaming directories and files to match naming conventions
3. Updating barrel exports and all imports

---

## Pattern Decision: Composition (Option B)

**Recommendation: Keep composition pattern, add `_presenter.actionHandler()` calls**

**Justification:**
1. Current implementation already uses composition (`ViewModel`, `ActionPresenter` constructor)
2. Matches GetX DI pattern via Bindings
3. More testable - can inject mock presenter
4. Matches SpaceActions (primary template feature module)
5. Minimal code changes required

**AuthActions uses inheritance because it's a singleton. fifty_demo's Actions use GetX bindings, so composition is correct.**

---

## Files to Modify (~38 total)

### Phase 1: Actions Pattern Fix (4 files)

| File | Async Methods Needing actionHandler |
|------|-------------------------------------|
| `home_actions.dart` | `onInitializeServices()` |
| `map_demo_actions.dart` | `onInitialize()`, `onPlayBgmTapped()`, `onStopBgmTapped()`, `onTestSfxTapped()`, `onEntityTapped()` |
| `dialogue_demo_actions.dart` | `onInitialize()`, `onPlayTapped()`, `onDialogueTapped()`, `onNextTapped()`, `onPreviousTapped()`, `onMicTapped()` |
| `ui_showcase_actions.dart` | None (all sync) |

### Phase 2: Directory Renames (8 directories)

```bash
# viewmodel/ → controllers/
mv features/home/viewmodel/ features/home/controllers/
mv features/map_demo/viewmodel/ features/map_demo/controllers/
mv features/dialogue_demo/viewmodel/ features/dialogue_demo/controllers/
mv features/ui_showcase/viewmodel/ features/ui_showcase/controllers/

# view/ → views/
mv features/home/view/ features/home/views/
mv features/map_demo/view/ features/map_demo/views/
mv features/dialogue_demo/view/ features/dialogue_demo/views/
mv features/ui_showcase/view/ features/ui_showcase/views/
```

### Phase 3: File Renames (4 files)

```bash
mv features/home/controllers/home_viewmodel.dart features/home/controllers/home_view_model.dart
mv features/map_demo/controllers/map_demo_viewmodel.dart features/map_demo/controllers/map_demo_view_model.dart
mv features/dialogue_demo/controllers/dialogue_demo_viewmodel.dart features/dialogue_demo/controllers/dialogue_demo_view_model.dart
mv features/ui_showcase/controllers/ui_showcase_viewmodel.dart features/ui_showcase/controllers/ui_showcase_view_model.dart
```

### Phase 4: Barrel Export Updates (4 files)

Update exports in: `home.dart`, `map_demo.dart`, `dialogue_demo.dart`, `ui_showcase.dart`

### Phase 5: Import Updates (~20+ files)

Pattern replacements:
- `viewmodel/` → `controllers/`
- `view/` → `views/`
- `_viewmodel.dart` → `_view_model.dart`

---

## Code Changes

### Actions Pattern Example

**BEFORE (map_demo_actions.dart:39-42):**
```dart
Future<void> onPlayBgmTapped() async {
  await _viewModel.coordinator.startExplorationBgm();
  _viewModel.update();
}
```

**AFTER:**
```dart
Future<void> onPlayBgmTapped(BuildContext context) async {
  await _presenter.actionHandler(context, () async {
    await _viewModel.coordinator.startExplorationBgm();
    _viewModel.update();
  });
}
```

### View Update Example

**BEFORE (map_demo_page.dart):**
```dart
onPressed: () => actions.onPlayBgmTapped(),
```

**AFTER:**
```dart
onPressed: () => actions.onPlayBgmTapped(context),
```

---

## Decision: features/ vs modules/

**Keep `features/`** - Acceptable deviation, semantic preference for apps.

---

## Order of Operations

1. ✅ Create branch
2. Phase 1: Fix Actions pattern (app still functional)
3. Checkpoint commit
4. Phase 2+3: Rename directories and files
5. Phase 4+5: Update imports
6. Checkpoint commit
7. Phase 6: Test
8. Final commit

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Broken imports | Medium | High | Run `flutter analyze` after each phase |
| Missing BuildContext | Medium | Medium | Update all action calls in views |
| Runtime crashes | Low | High | Test each feature after changes |

---

## Complexity Breakdown

| Phase | Complexity | Est. Time |
|-------|------------|-----------|
| Phase 1: Actions Fix | Medium | 1.5 hours |
| Phase 2: Dir Renames | Simple | 15 min |
| Phase 3: File Renames | Simple | 15 min |
| Phase 4: Barrel Updates | Simple | 15 min |
| Phase 5: Import Updates | Medium | 1.5 hours |
| Phase 6: Testing | Medium | 1 hour |
| **Total** | **Large** | **~5 hours** |

---

## Acceptance Criteria

- [ ] All Actions classes use `_presenter.actionHandler()` for async methods
- [ ] Directory structure: `controllers/`, `views/`
- [ ] File naming: `{name}_view_model.dart`
- [ ] All barrel exports updated
- [ ] All imports resolved
- [ ] `flutter analyze` passes
- [ ] App runs without errors
- [ ] Loading overlays appear on async operations
