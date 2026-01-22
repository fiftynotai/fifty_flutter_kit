# BR-031: Fifty Forms Package

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2 weeks)
**Status:** Done
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

Form handling in Flutter is verbose and repetitive. The `fifty_ui` package provides input components (FiftyTextField, FiftyDropdown, FiftySwitch) but lacks a form orchestration layer. Common pain points:
- No composable validation system
- Manual async validation with debouncing
- No field state tracking (touched, dirty, validating)
- No multi-step form support
- No dynamic field arrays
- No draft persistence
- Repetitive boilerplate for every form

Developers rewrite form logic for every project, leading to inconsistency and bugs.

---

## Goal

Create `fifty_forms` - a production-ready Flutter package providing declarative form building with:
- FiftyFormController for state management
- Composable validators (sync and async)
- Field state tracking (touched, dirty, validating)
- Multi-step wizard forms
- Dynamic form arrays
- Draft auto-save persistence
- Seamless integration with fifty_ui components
- FDL-compliant styling

---

## Context & Inputs

**Target Location:** `packages/fifty_forms/`

**Ecosystem Integration:**
| Package | Integration |
|---------|-------------|
| fifty_ui | All form fields use fifty_ui components |
| fifty_tokens | Spacing, colors, typography |
| fifty_theme | Form theming |
| fifty_storage | Draft persistence |
| fifty_connectivity | Disable submit when offline |

**Similar Package Reference:** `packages/fifty_ui/` (component patterns)

---

## Proposed Solution

### Core Components

**FiftyFormController**
```dart
FiftyFormController({
  initialValues: Map<String, dynamic>,
  validators: Map<String, List<Validator>>,
  onValidationChanged: (bool isValid) => {},
})
```

**Key API:**
- `getValue(name)` / `setValue(name, value)` - Field access
- `getError(name)` - Get validation error
- `isTouched(name)` / `isDirty(name)` - Field state
- `isValid` / `isDirty` - Form state
- `values` / `errors` - All values/errors
- `validate()` / `validateField(name)` - Run validation
- `reset()` / `clear()` / `submit()` - Form actions

### Field Types

| Type | Widget | Purpose |
|------|--------|---------|
| `text` | FiftyTextField | General text |
| `email` | FiftyTextField | Email input |
| `password` | FiftyTextField | Obscured input |
| `phone` | FiftyTextField | Phone keyboard |
| `number` | FiftyTextField | Numeric input |
| `multiline` | FiftyTextField | Textarea |
| `dropdown` | FiftyDropdown | Select options |
| `checkbox` | FiftyCheckbox | Boolean toggle |
| `switch` | FiftySwitch | Boolean toggle |
| `radio` | FiftyRadioGroup | Single select |
| `date` | FiftyDatePicker | Date selection |
| `time` | FiftyTimePicker | Time selection |
| `slider` | FiftySlider | Numeric range |
| `file` | FiftyFilePicker | File upload |

### Validators

**Built-in Validators:**

| Category | Validators |
|----------|------------|
| Required | `Required()` |
| String | `MinLength(n)`, `MaxLength(n)`, `Pattern(regex)`, `Email()`, `Url()`, `AlphaNumeric()` |
| Number | `Min(n)`, `Max(n)`, `Range(min, max)`, `Integer()`, `Positive()` |
| Date | `MinDate(date)`, `MaxDate(date)`, `MinAge(years)`, `FutureDate()`, `PastDate()` |
| Match | `Equals(fieldName)`, `NotEquals(fieldName)` |
| Password | `HasUppercase()`, `HasLowercase()`, `HasNumber()`, `HasSpecialChar()` |
| Custom | `Custom((value) => errorOrNull)` |
| Async | `AsyncValidator(validator, debounce)` |

### Multi-Step Forms

```dart
FiftyMultiStepForm(
  controller: controller,
  steps: [
    FormStep(title: 'Account', fields: ['email', 'password']),
    FormStep(title: 'Profile', fields: ['name', 'birthdate']),
    FormStep(title: 'Preferences', fields: ['newsletter', 'theme']),
  ],
  onComplete: (values) => handleSubmit(values),
)
```

**Step API:**
- `nextStep()` / `previousStep()` - Navigation
- `goToStep(index)` - Jump to step
- `currentStep` / `isFirstStep` / `isLastStep` - State

### Form Arrays

```dart
FiftyFormArray(
  name: 'addresses',
  minItems: 1,
  maxItems: 5,
  builder: (index, remove) => AddressFields(index, remove),
  addButton: (add) => FiftyButton(label: 'Add Address', onPressed: add),
)
```

**Array API:**
- `addArrayItem(name, value)` - Add item
- `removeArrayItem(name, index)` - Remove item
- `getValue(name)` - Get array as List

### Draft Persistence

```dart
FiftyForm(
  controller: controller,
  autosave: true,
  autosaveKey: 'registration_form',
  autosaveDebounce: Duration(seconds: 2),
  onDraftRestored: (values) => showToast('Draft restored'),
)
```

**Draft API:**
- `saveDraft()` / `loadDraft()` / `clearDraft()` - Manual control
- `hasDraft` - Check for saved draft

### UI Widgets

| Widget | Purpose |
|--------|---------|
| `FiftyForm` | Form container with validation |
| `FiftyFormField` | Field wrapper with state |
| `FiftyMultiStepForm` | Wizard-style form |
| `FiftyFormArray` | Dynamic field lists |
| `FiftySubmitButton` | Submit with loading state |
| `FiftyFormError` | Form-level error display |
| `FiftyFieldError` | Field-level error display |
| `FiftyFormProgress` | Multi-step progress indicator |
| `FiftyValidationSummary` | All errors summary |

---

## Package Structure

```
fifty_forms/
├── lib/
│   ├── src/
│   │   ├── core/
│   │   │   ├── form_controller.dart
│   │   │   ├── field_state.dart
│   │   │   ├── form_state.dart
│   │   │   └── form_options.dart
│   │   ├── validators/
│   │   │   ├── validator.dart
│   │   │   ├── required.dart
│   │   │   ├── string_validators.dart
│   │   │   ├── number_validators.dart
│   │   │   ├── date_validators.dart
│   │   │   ├── password_validators.dart
│   │   │   ├── match_validators.dart
│   │   │   ├── async_validator.dart
│   │   │   └── custom_validator.dart
│   │   ├── fields/
│   │   │   ├── form_field.dart
│   │   │   ├── text_field.dart
│   │   │   ├── dropdown_field.dart
│   │   │   ├── checkbox_field.dart
│   │   │   ├── radio_field.dart
│   │   │   ├── date_field.dart
│   │   │   ├── switch_field.dart
│   │   │   └── file_field.dart
│   │   ├── widgets/
│   │   │   ├── fifty_form.dart
│   │   │   ├── fifty_form_field.dart
│   │   │   ├── fifty_multi_step_form.dart
│   │   │   ├── fifty_form_array.dart
│   │   │   ├── fifty_submit_button.dart
│   │   │   ├── fifty_form_error.dart
│   │   │   ├── fifty_field_error.dart
│   │   │   ├── fifty_form_progress.dart
│   │   │   ├── fifty_validation_summary.dart
│   │   │   └── widgets.dart
│   │   ├── persistence/
│   │   │   ├── draft_manager.dart
│   │   │   └── persistence.dart
│   │   └── themes/
│   │       ├── form_theme.dart
│   │       └── themes.dart
│   └── fifty_forms.dart
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   └── examples/
│   │       ├── login_form.dart
│   │       ├── registration_form.dart
│   │       ├── multi_step_form.dart
│   │       └── dynamic_form.dart
│   └── pubspec.yaml
├── test/
│   ├── core/
│   ├── validators/
│   ├── fields/
│   ├── widgets/
│   └── persistence/
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

---

## Acceptance Criteria

- [ ] FiftyFormController with full state management API
- [ ] FieldState tracking (value, error, touched, dirty, validating)
- [ ] 14 field types with fifty_ui integration
- [ ] 15+ built-in validators (string, number, date, password, match)
- [ ] AsyncValidator with debounce support
- [ ] Custom validator support
- [ ] FiftyMultiStepForm with step navigation
- [ ] FiftyFormArray for dynamic fields
- [ ] Draft auto-save with fifty_storage
- [ ] 9 UI widgets with FDL compliance
- [ ] Example app with 4 demo scenarios
- [ ] Unit tests (180+ tests)
- [ ] Documentation (README, API docs, CHANGELOG)

---

## Test Plan

**Unit Tests:**
- FormController state management
- All validator types return correct errors
- Async validator debouncing
- Field state transitions (touched, dirty)
- Form array add/remove operations
- Multi-step navigation and validation
- Draft save/load cycle

**Widget Tests:**
- FiftyForm renders children correctly
- FiftyFormField displays errors
- FiftySubmitButton disabled when invalid
- FiftyMultiStepForm step transitions
- FiftyFormArray dynamic rendering
- FiftyValidationSummary displays all errors

**Integration Tests:**
- Complete form flow (fill → validate → submit)
- Multi-step form completion
- Draft restore on app restart
- Async validation with API mock

---

## Constraints

- Must follow FDL (Fifty Design Language) patterns
- All fields must wrap fifty_ui components
- Use ChangeNotifier pattern (framework-agnostic)
- No external dependencies beyond Flutter SDK and ecosystem packages
- Validators must be composable and reusable
- Async validators must support cancellation

---

## Delivery

- [ ] Package at `packages/fifty_forms/`
- [ ] Example app at `packages/fifty_forms/example/`
- [ ] README.md with usage examples
- [ ] CHANGELOG.md with v0.1.0 entry
- [ ] All tests passing
- [ ] Analyzer clean (no warnings)

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- [2026-01-21 T+0] INIT: Hunt initiated by Monarch
- [2026-01-21 T+1] PLANNING: Summoning ARCHITECT for implementation plan...
- [2026-01-21 T+2] PLANNING: ARCHITECT complete - Plan saved to ai/plans/BR-031-plan.md
- [2026-01-21 T+3] APPROVAL: Awaiting Monarch approval for implementation...
- [2026-01-21 T+4] APPROVAL: Monarch approved - Proceeding to BUILDING
- [2026-01-21 T+5] BUILDING: Phase 1 (Foundation) - FiftyFormController, FieldState
- [2026-01-21 T+6] BUILDING: Phase 2 (Validators) - 25 composable validators
- [2026-01-21 T+7] BUILDING: Phase 3 (Fields) - 11 field wrappers
- [2026-01-21 T+8] BUILDING: Phase 4 (Widgets) - 8 UI widgets + 3 models
- [2026-01-21 T+9] BUILDING: Phase 5 (Multi-Step) - FiftyMultiStepForm, FiftyFormArray
- [2026-01-21 T+10] BUILDING: Phase 6 (Polish) - DraftManager, example app, docs
- [2026-01-21 T+11] COMPLETE: All phases done, analyzer clean, 41 Dart files

---
