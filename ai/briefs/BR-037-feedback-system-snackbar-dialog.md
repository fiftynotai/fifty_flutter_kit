# BR-037: Feedback System - FiftySnackbar & FiftyDialog

**Type:** Bug Fix / Compliance
**Priority:** P1-High
**Effort:** S-Small
**Status:** Ready

---

## Problem

The app uses `Get.snackbar()` and Flutter's raw `Dialog` widget instead of the fifty_ui components `FiftySnackbar` and `FiftyDialog`. This creates inconsistent styling and doesn't demonstrate the design system.

---

## Goal

Replace all snackbar and dialog usages with FDL v2 compliant components to ensure consistent styling across the app.

---

## Context & Inputs

### Affected Files
- `apps/fifty_demo/lib/core/presentation/actions/action_presenter.dart`

### Current Implementation (Wrong)

**Snackbar:**
```dart
Get.snackbar(
  title,
  message,
  backgroundColor: FiftyColors.surfaceDark,
  colorText: FiftyColors.cream,
  ...
);
```

**Dialog:**
```dart
Get.dialog<bool>(
  Dialog(
    backgroundColor: FiftyColors.surfaceDark,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ...
  ),
);
```

### Target Implementation (Correct)

**Snackbar:**
```dart
FiftySnackbar.show(
  context,
  message: message,
  title: title,
  variant: FiftySnackbarVariant.error, // or .success, .info
);
```

**Dialog:**
```dart
final result = await showFiftyDialog<bool>(
  context: context,
  builder: (context) => FiftyDialog(
    title: 'Confirm',
    content: Text(message),
    actions: [
      FiftyButton(
        label: 'NO',
        variant: FiftyButtonVariant.ghost,
        onPressed: () => Navigator.pop(context, false),
      ),
      FiftyButton(
        label: 'YES',
        variant: FiftyButtonVariant.primary,
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  ),
);
```

---

## Constraints

- Must use components from `packages/fifty_ui`
- Follow FDL v2 design tokens
- Maintain existing functionality (error handling, confirmation flow)

---

## Reference

- `packages/fifty_ui/lib/src/feedback/fifty_snackbar.dart` - FiftySnackbar API
- `packages/fifty_ui/lib/src/feedback/fifty_dialog.dart` - FiftyDialog API

---

## Acceptance Criteria

- [ ] All snackbars use FiftySnackbar
- [ ] All dialogs use FiftyDialog
- [ ] Error snackbar shows proper error styling (red/burgundy variant)
- [ ] Success snackbar shows proper success styling (green variant)
- [ ] Confirmation dialog has proper FDL v2 styling with xxxl radius

---

## Test Plan

### Manual Testing
1. Trigger an error action → Verify FiftySnackbar appears with error styling
2. Trigger a success action → Verify FiftySnackbar appears with success styling
3. Trigger confirmation dialog → Verify FiftyDialog appears with proper styling
4. Test dialog YES/NO buttons return correct values

### Automated Testing
- No new tests required (UI feedback components)

---

## Delivery

- [ ] Update action_presenter.dart
- [ ] Run `flutter analyze` - 0 issues
- [ ] Visual verification against design system
