# Implementation Plan: BR-031 - Fifty Forms Package

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 weeks (8-12 working days)
**Risk Level:** Medium
**Created:** 2026-01-21
**Brief:** BR-031-fifty-forms.md

---

## Summary

Create `fifty_forms` - a production-ready Flutter forms package providing declarative form building with FiftyFormController, 15+ composable validators, field state tracking, multi-step wizard forms, dynamic form arrays, and draft auto-save persistence. All fields wrap fifty_ui components and follow FDL v2 compliance.

---

## Architecture Overview

```
fifty_forms/
├── lib/
│   ├── src/
│   │   ├── core/                    # State Management Layer
│   │   │   ├── form_controller.dart        # FiftyFormController (ChangeNotifier)
│   │   │   ├── field_state.dart            # FieldState (touched, dirty, validating)
│   │   │   ├── form_state_enum.dart        # FormStatus enum
│   │   │   └── form_options.dart           # FormOptions configuration
│   │   │
│   │   ├── validators/              # Validation Layer (15+ validators)
│   │   │   ├── validator.dart              # Base Validator<T> class
│   │   │   ├── required_validator.dart     # Required()
│   │   │   ├── string_validators.dart      # MinLength, MaxLength, Pattern, Email, Url, AlphaNumeric
│   │   │   ├── number_validators.dart      # Min, Max, Range, Integer, Positive
│   │   │   ├── date_validators.dart        # MinDate, MaxDate, MinAge, FutureDate, PastDate
│   │   │   ├── password_validators.dart    # HasUppercase, HasLowercase, HasNumber, HasSpecialChar
│   │   │   ├── match_validators.dart       # Equals, NotEquals
│   │   │   ├── async_validator.dart        # AsyncValidator with debounce
│   │   │   ├── custom_validator.dart       # Custom((value) => errorOrNull)
│   │   │   └── validators.dart             # Barrel export
│   │   │
│   │   ├── fields/                  # Field Wrappers (14 types)
│   │   │   ├── form_field_base.dart        # Base FiftyFormFieldBase
│   │   │   ├── text_form_field.dart        # Wraps FiftyTextField
│   │   │   ├── dropdown_form_field.dart    # Wraps FiftyDropdown
│   │   │   ├── checkbox_form_field.dart    # Wraps FiftyCheckbox
│   │   │   ├── switch_form_field.dart      # Wraps FiftySwitch
│   │   │   ├── radio_form_field.dart       # Wraps FiftyRadio
│   │   │   ├── slider_form_field.dart      # Wraps FiftySlider
│   │   │   ├── date_form_field.dart        # Date picker integration
│   │   │   ├── time_form_field.dart        # Time picker integration
│   │   │   ├── file_form_field.dart        # File picker placeholder
│   │   │   └── fields.dart                 # Barrel export
│   │   │
│   │   ├── widgets/                 # UI Widgets (9 widgets)
│   │   │   ├── fifty_form.dart             # Form container
│   │   │   ├── fifty_form_field.dart       # Field wrapper with state
│   │   │   ├── fifty_multi_step_form.dart  # Wizard-style form
│   │   │   ├── fifty_form_array.dart       # Dynamic field lists
│   │   │   ├── fifty_submit_button.dart    # Submit with loading state
│   │   │   ├── fifty_form_error.dart       # Form-level error display
│   │   │   ├── fifty_field_error.dart      # Field-level error display
│   │   │   ├── fifty_form_progress.dart    # Multi-step progress indicator
│   │   │   ├── fifty_validation_summary.dart # All errors summary
│   │   │   └── widgets.dart                # Barrel export
│   │   │
│   │   ├── persistence/             # Draft Persistence Layer
│   │   │   ├── draft_manager.dart          # DraftManager with fifty_storage
│   │   │   └── persistence.dart            # Barrel export
│   │   │
│   │   └── models/                  # Domain Models
│   │       ├── form_step.dart              # FormStep definition
│   │       ├── validation_result.dart      # ValidationResult
│   │       └── models.dart                 # Barrel export
│   │
│   └── fifty_forms.dart             # Main barrel export
│
├── example/                         # Example App (4 demos)
├── test/                            # Unit & Widget Tests (270+)
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

---

## Dependency Graph

```
                    ┌─────────────────────────────────────────────────┐
                    │                 FiftyFormController             │
                    │     (ChangeNotifier - Central State Hub)        │
                    └─────────┬───────────────────────┬───────────────┘
                              │                       │
              ┌───────────────┼───────────────────────┼────────────────┐
              │               │                       │                │
              ▼               ▼                       ▼                ▼
      ┌─────────────┐ ┌─────────────┐       ┌─────────────┐  ┌─────────────┐
      │ FieldState  │ │ Validators  │       │ DraftManager│  │  FormStep   │
      │ (per field) │ │ (composable)│       │(fifty_storage)│  │ (wizard)   │
      └─────────────┘ └─────────────┘       └─────────────┘  └─────────────┘
```

---

## Phase Breakdown

### Phase 1: Foundation (Days 1-2)
- Package scaffold with pubspec.yaml
- FieldState model (touched, dirty, validating)
- FormStatus enum
- FiftyFormController (ChangeNotifier)
- **Deliverables:** 45+ unit tests

### Phase 2: Validation System (Days 3-4)
- Base Validator<T> class
- 15+ validators: Required, String(6), Number(5), Date(5), Password(4), Match(2)
- AsyncValidator with debounce/cancellation
- Custom validator wrapper
- **Deliverables:** 55+ unit tests

### Phase 3: Field Wrappers (Days 5-6)
- FiftyFormFieldBase abstract class
- 10 field types wrapping fifty_ui components
- Auto-registration with controller
- **Deliverables:** 40+ widget tests

### Phase 4: UI Widgets (Days 7-8)
- FiftyForm container
- FiftySubmitButton with loading state
- Error display widgets
- FiftyValidationSummary
- FiftyFormProgress
- **Deliverables:** 35+ widget tests

### Phase 5: Multi-Step & Arrays (Days 9-10)
- FormStep model
- FiftyMultiStepForm wizard
- FiftyFormArray dynamic fields
- Controller array extensions
- **Deliverables:** 45+ tests

### Phase 6: Persistence & Polish (Days 11-12)
- DraftManager with fifty_storage
- Example app (4 demos)
- Documentation (README, CHANGELOG)
- Final cleanup
- **Deliverables:** 20+ integration tests

---

## Total Files: 47 new files

---

## Testing Strategy

| Component | Test Type | Count | Target |
|-----------|-----------|-------|--------|
| FieldState | Unit | 15 | 100% |
| FiftyFormController | Unit | 50 | 90% |
| Validators | Unit | 60 | 100% |
| AsyncValidator | Unit | 15 | 95% |
| Field wrappers | Widget | 40 | 80% |
| UI widgets | Widget | 35 | 80% |
| Multi-step | Widget | 15 | 85% |
| Form arrays | Unit+Widget | 20 | 90% |
| Persistence | Integration | 10 | 90% |
| Full flows | Integration | 10 | Key paths |

**Total Tests:** 270+ (exceeds 180 requirement)

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Async validator race conditions | Medium | High | Cancellation tokens, debounce, extensive tests |
| fifty_ui API changes | Low | Medium | Pin version, follow patterns |
| Form array nested validation | Medium | Medium | Dot-notation early, thorough testing |

---

## Critical Path

```
Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
(Core)    (Valid)   (Fields)  (Widgets) (Multi)   (Polish)
```

All phases are blocking except Phase 6 docs can partially parallelize.

---

## Pattern References

| Pattern | Source | Applied To |
|---------|--------|------------|
| ChangeNotifier controller | fifty_skill_tree | FiftyFormController |
| Condition composition | fifty_achievement_engine | Validators |
| Widget wrapper pattern | fifty_ui | Field wrappers |
| FDL consumption | fifty_skill_tree | All widgets |
