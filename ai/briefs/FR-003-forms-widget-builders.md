# FR-003: Add builder patterns to fifty_forms wizard and summary widgets

**Type:** Feature Request
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-03-03
**Completed:**

---

## Feature Description

**What is the proposed feature?**

Add builder/customization callbacks to `FiftyMultiStepForm` (step rendering), `FiftyValidationSummary` (error display), and `FiftyFormProgress` (progress indicator) so consumers can provide their own step/summary/progress UI while keeping the form validation pipeline intact.

**Why is this valuable?**

The forms package handles validation, multi-step state, draft persistence, and field management. `FiftyFormField` already takes a `child` widget (good pattern). But `FiftyMultiStepForm` has hardcoded step rendering and `FiftyValidationSummary` has a fixed layout. Consumers should be able to customize the wizard UX (step animations, custom indicators, summary layout).

---

## User Value

### Who Benefits?
- [x] Developers (building with the package)

### Pain Point Solved
**Current situation:**
`FiftyMultiStepForm` renders steps with a hardcoded layout. Consumers can't customize step indicators, transition animations, or step content wrappers. `FiftyValidationSummary` has a fixed error display format.

**With this feature:**
Consumers use the form validation/persistence pipeline with their own wizard UX. Step indicators, transitions, and error displays become swappable.

---

## Technical Approach

### Widgets to Update

| Widget | Builder to Add | Fallback |
|--------|---------------|----------|
| `FiftyMultiStepForm` | `stepBuilder(step, index, isActive, isCompleted)` | Default step layout |
| `FiftyMultiStepForm` | `indicatorBuilder(currentStep, totalSteps)` | Default step indicator |
| `FiftyValidationSummary` | `errorBuilder(errors)` | Default error list |
| `FiftyFormProgress` | `progressBuilder(progress, label)` | Default progress bar |
| `FiftySubmitButton` | `buttonBuilder(isValid, isSubmitting, onSubmit)` | Default submit button |

### Pattern

```dart
FiftyMultiStepForm(
  steps: mySteps,
  // Optional — if null, uses default step indicator
  indicatorBuilder: (currentStep, totalSteps) {
    return MyCustomStepDots(current: currentStep, total: totalSteps);
  },
)
```

### Constraints
- `FiftyFormField` already takes `child` — no change needed
- Default widgets remain unchanged (backward compatible)
- Builder is optional — null means use default
- Form validation logic unaffected

---

## Acceptance Criteria

1. [ ] Each target widget has an optional builder callback
2. [ ] Null builder falls back to current default widget
3. [ ] Existing API unchanged (backward compatible)
4. [ ] Form validation/persistence pipeline unaffected
5. [ ] All existing tests pass
6. [ ] New tests for builder pattern

---

## Notes

`FiftyFormField` already follows the right pattern by accepting a `child` widget. This brief extends that philosophy to the remaining hardcoded widgets.

---

**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Brief Owner:** Fifty.ai
