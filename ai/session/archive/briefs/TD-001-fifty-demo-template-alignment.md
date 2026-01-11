# TD-001: Align fifty_demo with MVVM+Actions Template

**Type:** Technical Debt
**Priority:** P1-High
**Effort:** L-Large (1-2 days)
**Status:** Done
**Created:** 2026-01-11
**Assignee:** -

---

## Problem

The `apps/fifty_demo` implementation deviates significantly from the canonical `templates/mvvm_actions` architecture in multiple ways:

1. **Actions classes don't use ActionPresenter** - All 4 Actions classes hold `_presenter` but never call `actionHandler()`, bypassing loading overlays and error handling
2. **Directory structure differs** - Uses `features/` instead of `modules/`, different subfolder names
3. **Naming conventions inconsistent** - `viewmodel/` vs `controllers/`, `view/` vs `views/`
4. **Missing barrel exports** - No `{module}.dart` files aggregating exports

---

## Goal

Refactor fifty_demo to fully comply with templates/mvvm_actions structure:
- Actions properly use ActionPresenter pattern
- Directory structure matches template
- Naming conventions aligned
- Barrel exports added per feature

---

## Context & Inputs

### Current Structure (fifty_demo)
```
lib/
├── features/
│   └── {feature}/
│       ├── actions/{feature}_actions.dart
│       ├── viewmodel/{feature}_viewmodel.dart
│       ├── view/{feature}_page.dart
│       └── service/...
```

### Target Structure (template)
```
lib/src/
├── modules/
│   └── {module}/
│       ├── {module}.dart              # Barrel export
│       ├── {module}_bindings.dart
│       ├── actions/{module}_actions.dart
│       ├── controllers/{module}_view_model.dart
│       ├── data/
│       │   ├── models/
│       │   └── services/
│       └── views/
│           ├── {module}_page.dart
│           └── widgets/
```

### Files to Modify

**Core (3 files):**
- `lib/core/presentation/actions/action_presenter.dart` - OK
- `lib/core/bindings/initial_bindings.dart` - Update paths
- `lib/core/navigation/app_navigation.dart` - Update paths

**Features (4 x 6 = 24 files):**
For each feature (home, map_demo, dialogue_demo, ui_showcase):
- Rename `viewmodel/` → `controllers/`
- Rename `view/` → `views/`
- Rename `{name}_viewmodel.dart` → `{name}_view_model.dart`
- Add barrel export `{feature}.dart`
- Fix Actions to use `actionHandler()`
- Update all imports

---

## Constraints

1. **Must maintain functionality** - App must work identically after refactor
2. **Preserve FDL compliance** - Keep all fifty_tokens/fifty_ui usage
3. **No behavior changes** - Pure structural refactor
4. **Update tests if any** - Ensure any existing tests pass

---

## Acceptance Criteria

- [ ] All Actions classes use `_presenter.actionHandler()` or `extends ActionPresenter`
- [ ] Directory structure matches `modules/{name}/controllers/`, `modules/{name}/views/`
- [ ] File naming uses underscore: `{name}_view_model.dart`
- [ ] Each feature has barrel export `{feature}.dart`
- [ ] All imports updated throughout codebase
- [ ] App runs without errors
- [ ] No functionality regression

---

## Test Plan

### Manual Testing
1. Launch app - verify home loads
2. Navigate to each feature - verify all 4 work
3. Test async operations - verify loading overlay appears
4. Trigger error condition - verify error snackbar appears
5. Test all interactive elements per feature

### Automated
- Run `flutter analyze` - zero issues
- Run existing tests if any

---

## Implementation Approach

### Phase 1: Actions Pattern Fix (HIGH PRIORITY)
Fix all 4 Actions classes to properly use ActionPresenter:

**Option A: Extend ActionPresenter (like AuthActions)**
```dart
class HomeActions extends ActionPresenter {
  late HomeViewModel _viewModel;

  HomeActions._() {
    _viewModel = Get.find();
  }

  Future<void> onInitializeServices(BuildContext context) async {
    await actionHandler(context, () async {
      await _viewModel.initializeServices();
    });
  }
}
```

**Option B: Use composition (like SpaceActions)**
```dart
class HomeActions {
  final HomeViewModel _viewModel;
  final ActionPresenter _presenter;

  Future<void> onInitializeServices(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.initializeServices();
    });
  }
}
```

### Phase 2: Directory Restructure
1. Rename folders: `viewmodel/` → `controllers/`, `view/` → `views/`
2. Rename files: `{name}_viewmodel.dart` → `{name}_view_model.dart`
3. Optionally rename `features/` → `modules/` (or document as intentional deviation)

### Phase 3: Barrel Exports
Add `{feature}.dart` to each feature folder with all exports.

### Phase 4: Update Imports
Run find/replace across all files to update import paths.

---

## Delivery

- [ ] Branch: `refactor/TD-001-template-alignment`
- [ ] PR with all changes
- [ ] Update CURRENT_SESSION.md
- [ ] Archive brief when complete

---

## Notes

- Consider whether `features/` vs `modules/` is an acceptable deviation (semantic preference)
- May want to add `lib/src/` wrapper or document why omitted
- Integration services pattern (vs API services) is acceptable for demo app

---

## Related

- BR-028: Original MVVM+Actions migration (completed)
- templates/mvvm_actions: Canonical reference
- ai/context/coding_guidelines.md: Architecture standards
