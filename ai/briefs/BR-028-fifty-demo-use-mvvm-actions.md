# BR-028: Fifty Demo - Use MVVM+Actions Template Pattern

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** L-Large (2-4d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-01-05
**Completed:** _(pending)_

---

## Problem

**What's broken or missing?**

The `apps/fifty_demo/` application was supposed to follow the `templates/mvvm_actions/` architecture pattern but instead uses a completely different architecture:

**Current (Wrong):**
- Uses `Provider` + `ChangeNotifier` for state management
- Uses `GetIt` for dependency injection
- ViewModels extend `ChangeNotifier`
- Actions are plain classes without base functionality
- No `ApiResponse<T>` pattern
- No `ActionPresenter` for UX orchestration
- No `Bindings` classes

**Expected (from coding_guidelines.md):**
- Uses `GetX` for state management
- Uses GetX `Bindings` for dependency injection
- ViewModels extend `GetxController`
- Actions extend `ActionPresenter` with `actionHandler()`
- Uses `ApiResponse<T>` and `apiFetch()` pattern
- Uses `Obx()` for reactive UI

**Evidence:**

```dart
// Current (Wrong)
class HomeViewModel extends ChangeNotifier {  // Should be GetxController
  void _notifyUpdate() {
    notifyListeners();  // Should be update() or .obs
  }
}

// Current (Wrong)
class HomeActions {  // Should extend ActionPresenter
  Future<void> onPlayClickSound() async {
    // No loading overlay, no error handling
  }
}

// Current (Wrong)
serviceLocator.registerFactory<HomeViewModel>(  // Should be GetX binding
  () => HomeViewModel(...),
);
```

**Why does it matter?**

1. **Contradicts coding_guidelines.md** - Generated standards mandate MVVM+Actions with GetX
2. **Bad reference implementation** - Developers will copy wrong patterns
3. **Missing UX orchestration** - No loading overlays, snackbars, error handling
4. **No state recovery** - ChangeNotifier doesn't persist like GetX

---

## Goal

**What should happen after this brief is completed?**

Refactor `apps/fifty_demo/` to follow the `templates/mvvm_actions/` architecture:
- Replace Provider with GetX
- Replace ChangeNotifier with GetxController
- Add ActionPresenter base class
- Add Bindings for each feature
- Use Obx() for reactive widgets

---

## Context & Inputs

### Architecture Comparison

| Aspect | Current (Wrong) | Expected (mvvm_actions) |
|--------|-----------------|-------------------------|
| State Mgmt | Provider + ChangeNotifier | GetX + Rx observables |
| DI | GetIt | GetX Bindings |
| ViewModel | extends ChangeNotifier | extends GetxController |
| Actions | plain class | extends ActionPresenter |
| UI Binding | Consumer<VM> | GetView<VM> + Obx() |
| Async State | manual bool isLoading | ApiResponse<T> |
| Error Handling | try-catch inline | actionHandler() |

### Files Requiring Changes

**Core:**
- `pubspec.yaml` - Replace provider with get
- `lib/core/di/service_locator.dart` - Replace with bindings pattern
- `lib/main.dart` - Use GetMaterialApp
- `lib/app/fifty_demo_app.dart` - Use GetMaterialApp with pages

**Shared:**
- Add `lib/core/presentation/actions/action_presenter.dart`
- Add `lib/core/routing/route_manager.dart`

**Features (each needs):**
- ViewModels: Change base class to GetxController
- Actions: Add ActionPresenter base
- Views: Change to GetView<VM>, use Obx()
- Add: {feature}_bindings.dart

**Estimated file changes:** ~40 files

### Reference Implementation

See `templates/mvvm_actions/lib/src/modules/space/` for correct pattern:
- `space_bindings.dart`
- `controllers/space_view_model.dart`
- `actions/space_actions.dart`
- `views/orbital_command_page.dart`

---

## Constraints

### Technical Requirements
- Must use GetX (package: get)
- Must follow coding_guidelines.md patterns
- Must preserve all existing functionality
- Must pass flutter analyze

### Out of Scope
- Changing feature logic
- Adding new features
- Changing FDL styling

---

## Tasks

### Pending
- [ ] Task 1: Update pubspec.yaml - replace provider with get
- [ ] Task 2: Add ActionPresenter base class from mvvm_actions
- [ ] Task 3: Add RouteManager from mvvm_actions
- [ ] Task 4: Refactor Home feature to GetX pattern
- [ ] Task 5: Refactor Map Demo feature to GetX pattern
- [ ] Task 6: Refactor Dialogue Demo feature to GetX pattern
- [ ] Task 7: Refactor UI Showcase feature to GetX pattern
- [ ] Task 8: Replace GetIt with GetX bindings in each feature
- [ ] Task 9: Update main.dart to use GetMaterialApp with pages
- [ ] Task 10: Update FiftyDemoApp to use GetMaterialApp
- [ ] Task 11: Run flutter analyze and fix issues
- [ ] Task 12: Test all features work correctly

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] pubspec.yaml uses `get` instead of `provider`
2. [ ] All ViewModels extend `GetxController`
3. [ ] All Actions extend `ActionPresenter`
4. [ ] All features have `*_bindings.dart` files
5. [ ] Views use `GetView<VM>` or `GetWidget<VM>`
6. [ ] Reactive UI uses `Obx()` wrapper
7. [ ] `GetIt` removed, using GetX DI only
8. [ ] `GetMaterialApp` used with route pages
9. [ ] All features functional after refactor
10. [ ] `flutter analyze` passes

---

## Test Plan

### Manual Tests
- [ ] Launch app, verify home loads
- [ ] Navigate to Map Demo, verify works
- [ ] Navigate to Dialogue Demo, verify works
- [ ] Navigate to UI Showcase, verify works
- [ ] Test loading states (actionHandler)
- [ ] Test error handling displays

### Automated Tests
- [ ] Widget tests for navigation
- [ ] Unit tests for viewmodels

---

## Workflow State

**Phase:** INIT
**Active Agent:** none
**Retry Count:** 0

### Agent Log
_(Timestamped subagent invocations)_

---

**Created:** 2026-01-05
**Last Updated:** 2026-01-05
**Brief Owner:** Igris AI