# BR-039: Forms Demo - Use fifty_forms Package

**Type:** Bug Fix / Compliance
**Priority:** P2-Medium
**Effort:** M-Medium
**Status:** Ready

---

## Problem

The forms demo uses raw Flutter `TextFormField` with 100+ lines of manual styling instead of `FiftyTextFormField` from the fifty_forms package. This doesn't demonstrate the actual package.

---

## Goal

Replace all raw form widgets with fifty_forms components to properly demonstrate the package capabilities.

---

## Context & Inputs

### Affected Files
- `apps/fifty_demo/lib/features/forms_demo/views/forms_demo_page.dart`
- `apps/fifty_demo/lib/features/forms_demo/controllers/forms_demo_view_model.dart`

### Current Implementation (Wrong - 80+ lines of manual styling)
```dart
TextFormField(
  controller: controller,
  validator: validator,
  style: const TextStyle(
    fontFamily: FiftyTypography.fontFamily,
    fontSize: FiftyTypography.bodyMedium,
    color: FiftyColors.cream,
  ),
  decoration: InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: FiftyColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(FiftyRadii.md),
      borderSide: BorderSide(color: FiftyColors.borderDark),
    ),
    // ... 20 more lines
  ),
);
```

### Target Implementation (from fifty_forms)
```dart
FiftyTextFormField(
  label: 'Full Name',
  hint: 'Enter your full name',
  controller: controller,
  validator: validator,
  prefixIcon: Icons.person_outline,
);
```

---

## Required Changes

### 1. Replace TextFormField with FiftyTextFormField
- Use `FiftyTextFormField` for all text inputs
- Use `FiftyPasswordFormField` for password fields

### 2. Use FiftyFormController
```dart
// Use FiftyFormController instead of manual FormState
final formController = FiftyFormController();

// With validators from fifty_forms
FiftyTextFormField(
  validators: [Required(), MinLength(2)],
);
```

### 3. Add Multi-Step Form Demo
The fifty_forms package has `FiftyMultiStepForm`. Add a second demo tab showing:
```dart
FiftyMultiStepForm(
  steps: [
    FiftyFormStep(title: 'Account', fields: [...]),
    FiftyFormStep(title: 'Profile', fields: [...]),
    FiftyFormStep(title: 'Confirm', fields: [...]),
  ],
);
```

---

## Constraints

- Must use components from `packages/fifty_forms`
- Follow MVVM + Actions architecture
- Reduce code from 500+ lines to ~100 lines

---

## Reference

- `packages/fifty_forms/lib/fifty_forms.dart` - Available components
- `packages/fifty_forms/example/` - Usage examples

---

## Acceptance Criteria

- [ ] All form fields use FiftyTextFormField (not raw TextFormField)
- [ ] Password field uses FiftyPasswordFormField
- [ ] Validators use fifty_forms validators (Required, Email, MinLength, etc.)
- [ ] Form controller uses FiftyFormController
- [ ] Multi-step form demo added showing FiftyMultiStepForm
- [ ] Code reduced from 500+ lines to ~100 lines

---

## Test Plan

### Manual Testing
1. Navigate to Forms Demo page
2. Test single form validation (required, email, min length)
3. Test multi-step form navigation (next, back, submit)
4. Verify styling matches FDL v2

### Automated Testing
- No new tests required (demo page)

---

## Delivery

- [ ] Update forms_demo_page.dart
- [ ] Update forms_demo_view_model.dart
- [ ] Add multi-step form demo
- [ ] Run `flutter analyze` - 0 issues
- [ ] Visual verification
