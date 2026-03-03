# Implementation Plan: FR-003

**Complexity:** S (Small)
**Estimated Duration:** 2-3 hours
**Risk Level:** Low

## Summary

Add optional builder callbacks to 3 widgets in the `fifty_forms` package (`FiftyMultiStepForm`, `FiftyValidationSummary`, `FiftyFormProgress`, `FiftySubmitButton`) so consumers can replace default visual content while keeping form validation and state management intact. No data classes needed -- all builder signatures have 5 or fewer params.

---

## Key Design Decisions

### Decision 1: FiftyMultiStepForm already has builders

**Analysis:** `FiftyMultiStepForm` already has:
- `stepBuilder` (required) -- builder for each step's content
- `progressBuilder` (optional) -- custom progress indicator

The brief's `stepBuilder(step, index, isActive, isCompleted)` is already satisfied by the existing `stepBuilder(context, stepIndex, step)`. The brief's `indicatorBuilder(currentStep, totalSteps)` is already satisfied by the existing `progressBuilder(current, total, steps)`.

**Answer: Add a `navigationBuilder` instead.** The only hardcoded visual content in `FiftyMultiStepForm` that cannot be customized is the navigation buttons section (`_buildNavigationButtons()`). Adding a `navigationBuilder` lets consumers replace the Back/Next/Complete button row. This is the real remaining gap.

The navigationBuilder receives the state needed to render navigation controls:
- `isFirstStep` (bool) -- whether to show back button
- `isLastStep` (bool) -- whether this is the final step (show "Complete" vs "Next")
- `isSubmitting` (bool) -- loading state
- `onNext` (VoidCallback) -- advance or complete
- `onPrevious` (VoidCallback) -- go back

5 params -- clean positional typedef, no data class needed.

### Decision 2: FiftyValidationSummary builder scope

**Analysis:** The widget uses `ListenableBuilder` + `AnimatedSize` + `AnimatedOpacity` + `FiftyCard` as the outer structure, with error list as inner content.

**Answer:** Add `contentBuilder` that replaces the `FiftyCard` and its entire inner Column (title row + error items). The `AnimatedSize` + `AnimatedOpacity` animation wrapper stays widget-owned. This way:
- Widget-owned: `ListenableBuilder`, show/hide animation, controller listening
- Builder replaces: The card + error list content

Builder receives `Map<String, String> errors` (the same map from `controller.errors`). Consumers who need `onFieldTap` already have it via the widget's existing `onFieldTap` callback.

Correction: the builder should also receive `onFieldTap` so the consumer can wire tap actions on their custom error items. So the builder params are:
- `errors` (Map<String, String>) -- field name to error message
- `onFieldTap` (void Function(String)?) -- the same callback the widget already receives

2 params -- simple positional typedef.

### Decision 3: FiftyFormProgress builder scope

**Analysis:** `FiftyFormProgress` is a StatelessWidget that renders step circles with connecting lines and optional labels. It is a standalone indicator widget (not part of multi-step form by default -- it's used by `FiftyMultiStepForm` when `progressBuilder` is null).

**Answer:** Add `contentBuilder` that replaces the entire Column content (step circles + labels). Builder receives:
- `currentStep` (int, 1-indexed)
- `totalSteps` (int)
- `stepLabels` (List<String>?)

3 params -- clean positional typedef. The widget already receives these as constructor params, so the builder just gets them forwarded.

### Decision 4: FiftySubmitButton builder scope

**Analysis:** `FiftySubmitButton` uses `ListenableBuilder` to listen to the controller, computes `isLoading`/`isDisabled` state, then renders a `FiftyButton`. The builder should replace the `FiftyButton` rendering.

**Answer:** Add `buttonBuilder` that replaces the `FiftyButton`. Builder receives:
- `isLoading` (bool) -- currently submitting
- `isDisabled` (bool) -- button should be inactive
- `onPressed` (VoidCallback?) -- the submit action (null when disabled)
- `label` (String) -- resolved label text (respects loadingText)

4 params -- clean positional typedef.

The `ListenableBuilder` wrapper stays widget-owned.

### Decision 5: No data classes needed

All builder signatures have 5 or fewer params. Positional typedefs are clean and IDE-discoverable at this count. No immutable data class ceremony needed (unlike FR-002's 9-10 param cases).

---

## Typedefs

```dart
/// Builder for custom navigation buttons in a multi-step form.
typedef MultiStepNavigationBuilder = Widget Function(
  bool isFirstStep,
  bool isLastStep,
  bool isSubmitting,
  VoidCallback onNext,
  VoidCallback onPrevious,
);

/// Builder for custom validation summary content.
typedef ValidationSummaryContentBuilder = Widget Function(
  Map<String, String> errors,
  void Function(String fieldName)? onFieldTap,
);

/// Builder for custom form progress indicator content.
typedef FormProgressContentBuilder = Widget Function(
  int currentStep,
  int totalSteps,
  List<String>? stepLabels,
);

/// Builder for custom submit button.
typedef SubmitButtonBuilder = Widget Function(
  bool isLoading,
  bool isDisabled,
  VoidCallback? onPressed,
  String label,
);
```

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_forms/lib/src/widgets/fifty_multi_step_form.dart` | MODIFY | Add `navigationBuilder` param + typedef |
| `packages/fifty_forms/lib/src/widgets/fifty_validation_summary.dart` | MODIFY | Add `contentBuilder` param + typedef |
| `packages/fifty_forms/lib/src/widgets/fifty_form_progress.dart` | MODIFY | Add `contentBuilder` param + typedef |
| `packages/fifty_forms/lib/src/widgets/fifty_submit_button.dart` | MODIFY | Add `buttonBuilder` param + typedef |
| `packages/fifty_forms/test/widgets/fifty_multi_step_form_builder_test.dart` | CREATE | Builder tests for multi-step navigation |
| `packages/fifty_forms/test/widgets/fifty_validation_summary_builder_test.dart` | CREATE | Builder tests for validation summary |
| `packages/fifty_forms/test/widgets/fifty_form_progress_builder_test.dart` | CREATE | Builder tests for form progress |
| `packages/fifty_forms/test/widgets/fifty_submit_button_builder_test.dart` | CREATE | Builder tests for submit button |

---

## Implementation Steps

### Phase 1: FiftyMultiStepForm navigationBuilder

**File:** `packages/fifty_forms/lib/src/widgets/fifty_multi_step_form.dart`

1. Add `MultiStepNavigationBuilder` typedef at file top (before class), with doc comment
2. Add `this.navigationBuilder` optional param to constructor (after `expandedButtons`)
3. Add `final MultiStepNavigationBuilder? navigationBuilder;` field with doc comment
4. In `build()` method, replace the navigation buttons SliverToBoxAdapter:
   ```dart
   // Navigation buttons
   SliverToBoxAdapter(
     child: widget.navigationBuilder != null
         ? widget.navigationBuilder!(
             isFirstStep,
             isLastStep,
             _isSubmitting,
             nextStep,
             previousStep,
           )
         : _buildNavigationButtons(),
   ),
   ```
5. Existing `_buildNavigationButtons()` method stays unchanged (default path)

**Note:** `stepBuilder` and `progressBuilder` already exist. The brief's requested builders map to these existing params. Only the navigation section is truly hardcoded.

### Phase 2: FiftyValidationSummary contentBuilder

**File:** `packages/fifty_forms/lib/src/widgets/fifty_validation_summary.dart`

1. Add `ValidationSummaryContentBuilder` typedef at file top (before class), with doc comment
2. Add `this.contentBuilder` optional param to constructor (after `animationDuration`)
3. Add `final ValidationSummaryContentBuilder? contentBuilder;` field with doc comment
4. In `build()` method, inside the `ListenableBuilder`, after computing `errors` and `hasErrors`:
   - If `contentBuilder != null && hasErrors`: use `contentBuilder!(errors, onFieldTap)` instead of the `FiftyCard(...)` block
   - The `AnimatedSize` + `AnimatedOpacity` wrapper stays around both paths
   - When builder is null or no errors: existing code unchanged

**Build method structure (modified section inside ListenableBuilder):**
```dart
child: hasErrors
    ? (contentBuilder != null
        ? contentBuilder!(errors, onFieldTap)
        : FiftyCard(
            // ... existing default code unchanged
          ))
    : const SizedBox.shrink(),
```

### Phase 3: FiftyFormProgress contentBuilder

**File:** `packages/fifty_forms/lib/src/widgets/fifty_form_progress.dart`

1. Add `FormProgressContentBuilder` typedef at file top (before class), with doc comment
2. Add `this.contentBuilder` optional param to constructor (after `animationDuration`)
3. Add `final FormProgressContentBuilder? contentBuilder;` field with doc comment
4. In `build()` method, early-return if builder provided:
   ```dart
   Widget build(BuildContext context) {
     if (contentBuilder != null) {
       return contentBuilder!(currentStep, totalSteps, stepLabels);
     }

     // Default path (existing code unchanged)
     final theme = Theme.of(context);
     ...
   }
   ```

**Note:** The constructor assert on `currentStep`/`totalSteps` stays -- those validations apply regardless of which rendering path is used.

### Phase 4: FiftySubmitButton buttonBuilder

**File:** `packages/fifty_forms/lib/src/widgets/fifty_submit_button.dart`

1. Add `SubmitButtonBuilder` typedef at file top (before class), with doc comment
2. Add `this.buttonBuilder` optional param to constructor (after `isGlitch`)
3. Add `final SubmitButtonBuilder? buttonBuilder;` field with doc comment
4. In `build()` method, inside the `ListenableBuilder`, after computing `isLoading`/`isDisabled`:
   ```dart
   if (buttonBuilder != null) {
     final resolvedLabel = isLoading ? (loadingText ?? label) : label;
     return buttonBuilder!(
       isLoading,
       isDisabled,
       isDisabled ? null : onPressed,
       resolvedLabel,
     );
   }

   // Default path (existing FiftyButton code unchanged)
   return FiftyButton(...);
   ```

The `ListenableBuilder` wrapper stays widget-owned.

### Phase 5: Widget Tests

All test files follow the same pattern established in FR-002: `buildTestWidget()` helper, `MaterialApp` + `FiftyTheme.dark()` wrapping, capture variables to verify builder params.

**File:** `packages/fifty_forms/test/widgets/fifty_multi_step_form_builder_test.dart`

Test setup needs:
- A `FiftyFormController` with some fields registered
- A list of `FormStep` definitions
- Wrap in `MaterialApp(theme: FiftyTheme.dark(), home: Scaffold(body: ...))`

Test groups:
1. `navigationBuilder` group:
   - Renders custom navigation when navigationBuilder provided
   - Renders default navigation buttons when navigationBuilder is null
   - Builder receives correct isFirstStep/isLastStep values on step 0
   - Builder receives correct isFirstStep/isLastStep on last step
   - onNext callback advances the step
   - onPrevious callback goes back a step
   - isSubmitting is true during form completion

**Estimated:** 7 tests

**File:** `packages/fifty_forms/test/widgets/fifty_validation_summary_builder_test.dart`

Test setup needs:
- A `FiftyFormController` with fields + validators to produce errors
- Trigger validation to populate errors

Test groups:
1. `contentBuilder` group:
   - Renders builder widget when contentBuilder provided and errors exist
   - Renders default FiftyCard when contentBuilder is null
   - Does not call builder when no errors (even if builder provided)
   - Builder receives correct error map
   - Builder receives onFieldTap callback
   - Animation wrapper preserved with contentBuilder

**Estimated:** 6 tests

**File:** `packages/fifty_forms/test/widgets/fifty_form_progress_builder_test.dart`

Test groups:
1. `contentBuilder` group:
   - Renders builder widget when contentBuilder provided
   - Renders default step circles when contentBuilder is null
   - Builder receives correct currentStep value
   - Builder receives correct totalSteps value
   - Builder receives stepLabels when provided
   - Builder receives null stepLabels when not provided

**Estimated:** 6 tests

**File:** `packages/fifty_forms/test/widgets/fifty_submit_button_builder_test.dart`

Test setup needs:
- A `FiftyFormController`
- Possibly set up fields with/without errors to test isDisabled

Test groups:
1. `buttonBuilder` group:
   - Renders builder widget when buttonBuilder provided
   - Renders default FiftyButton when buttonBuilder is null
   - Builder receives isLoading=false when idle
   - Builder receives isDisabled=true when form invalid (with disableWhenInvalid=true)
   - Builder receives non-null onPressed when form valid
   - Builder receives null onPressed when disabled
   - Builder receives resolved label (loadingText during submission)

**Estimated:** 7 tests

**Total new tests:** ~26

### Phase 6: Verify

1. Run `flutter test` in `packages/fifty_forms/`
2. Run `flutter analyze` -- zero issues
3. Verify no existing tests break (there are currently no tests in the package, so this is a baseline)

---

## Testing Strategy

- **Widget tests:** Builder rendering, value/callback forwarding, defaults preserved (~26 tests)
- **No data class tests needed:** No data classes created (all typedefs are positional)
- **No existing tests to regress:** The fifty_forms package has no test directory yet; these will be the first tests
- **Analyzer:** Zero issues on `flutter analyze`

### Test Helper Pattern

Each test file uses:
- `buildTestWidget()` factory with all relevant params
- `MaterialApp(theme: FiftyTheme.dark(), home: Scaffold(body: ...))` wrapping
- Captured variables for verifying builder receives correct values
- `find.text('Custom ...')` to verify builder output is rendered
- `find.text('DEFAULT_MARKER')` to verify default is NOT rendered when builder active

### FiftyFormController in tests

Tests need `FiftyFormController` instances:
- For `FiftyMultiStepForm`: controller with initial values matching step fields
- For `FiftyValidationSummary`: controller with validators + `markAllTouched()` + `validate()` to force errors
- For `FiftySubmitButton`: controller with/without validators to test valid/invalid states
- Controllers must be disposed in test teardown

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| FiftyMultiStepForm uses CustomScrollView -- tests may need specific viewport constraints | Medium | Low | Wrap in `SizedBox(height: 600, width: 400)` or use `MediaQuery` override in test helper |
| FiftyFormController async validation in tests | Low | Low | Use `Required()` validator (sync) for simplicity; call `validate()` then `pump()` |
| FiftyTheme.dark() needed for FiftyCard/FiftyButton resolution | Medium | Low | All test helpers use `MaterialApp(theme: FiftyTheme.dark())` (same as FR-002 pattern) |
| Brief lists stepBuilder/indicatorBuilder for FiftyMultiStepForm but they already exist | Low | Low | Document that these are already present; add `navigationBuilder` as the actual missing gap |

---

## Backward Compatibility

- All new params are optional with null defaults
- No constructor param order changes for existing params (new params added at end)
- No changes to existing build output when builders are null
- No new files to export (typedefs live in same file as widget)
- No barrel export changes needed

---

## File Count Summary

| Category | Count |
|----------|-------|
| New source files | 0 |
| Modified source files | 4 (widgets) |
| New test files | 4 |
| Total files affected | 8 |

---

## Deviation from Brief

The brief lists 5 builders across 4 widgets:

| Brief's Builder | Status | Notes |
|----------------|--------|-------|
| `FiftyMultiStepForm.stepBuilder` | ALREADY EXISTS | Required param `stepBuilder(context, stepIndex, step)` |
| `FiftyMultiStepForm.indicatorBuilder` | ALREADY EXISTS | Optional param `progressBuilder(current, total, steps)` |
| `FiftyValidationSummary.errorBuilder` | PLANNED | Named `contentBuilder` for consistency with FR-001/FR-002 |
| `FiftyFormProgress.progressBuilder` | PLANNED | Named `contentBuilder` for consistency |
| `FiftySubmitButton.buttonBuilder` | PLANNED | Named `buttonBuilder` (clear intent) |

**Addition not in brief:** `FiftyMultiStepForm.navigationBuilder` -- the navigation buttons are the actual remaining hardcoded visual in this widget. Added to close the real gap.
