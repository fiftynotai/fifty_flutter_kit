# Fifty Forms

Production-ready form building with validation, multi-step wizards, and draft persistence for the Fifty Flutter Kit.

## Features

- **State Management** - `FiftyFormController` for centralized form state
- **Immutable Field State** - `FieldState` tracks value, touched, dirty, error states
- **25 Built-in Validators** - Required, Email, MinLength, Pattern, and more
- **Async Validation** - Debounced async validators for server-side checks
- **FDL Components** - Form field wrappers for fifty_ui components
- **Multi-Step Forms** - Wizard-style forms with step validation
- **Dynamic Arrays** - Add/remove repeating field groups
- **Draft Persistence** - Auto-save and restore form data

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_forms:
    path: ../fifty_forms  # or published version
```

## Quick Start

```dart
import 'package:fifty_forms/fifty_forms.dart';

// Create form controller
final controller = FiftyFormController(
  initialValues: {'email': '', 'password': ''},
  validators: {
    'email': [Required(), Email()],
    'password': [Required(), MinLength(8)],
  },
);

// Build form
Column(
  children: [
    FiftyTextFormField(
      name: 'email',
      controller: controller,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
    ),
    FiftyTextFormField(
      name: 'password',
      controller: controller,
      label: 'Password',
      obscureText: true,
    ),
    FiftySubmitButton(
      controller: controller,
      label: 'LOGIN',
      onPressed: () => controller.submit((values) async {
        await api.login(values['email'], values['password']);
      }),
    ),
  ],
)
```

## Table of Contents

- [API Reference](#api-reference)
  - [FiftyFormController](#fiftyformcontroller)
  - [FieldState](#fieldstate)
  - [FormStatus](#formstatus)
- [Validators](#validators)
  - [String Validators](#string-validators)
  - [Number Validators](#number-validators)
  - [Date Validators](#date-validators)
  - [Password Validators](#password-validators)
  - [Comparison Validators](#comparison-validators)
  - [Custom Validators](#custom-validators)
  - [Composite Validators](#composite-validators)
- [Form Fields](#form-fields)
- [Multi-Step Forms](#multi-step-forms)
- [Dynamic Form Arrays](#dynamic-form-arrays)
- [Draft Persistence](#draft-persistence)
- [UI Widgets](#ui-widgets)
- [Example App](#example-app)
- [FDL Compliance](#fdl-compliance)

## API Reference

### FiftyFormController

The central state manager for forms. Handles field registration, value tracking, validation (sync and async), and form submission.

```dart
final controller = FiftyFormController(
  initialValues: {'name': '', 'age': 0},
  validators: {
    'name': [Required(), MinLength(2)],
    'age': [Required(), Min(18)],
  },
  onValidationChanged: (isValid) => print('Valid: $isValid'),
);

// Get/set values
controller.setValue('name', 'John');
final name = controller.getValue<String>('name');

// Check state
controller.isValid;      // All fields valid?
controller.isDirty;      // Any field changed?
controller.isValidating; // Async validation running?

// Field operations
controller.registerField('newField', initialValue: '');
controller.unregisterField('fieldToRemove');
controller.markTouched('name');
controller.markAllTouched();

// Actions
await controller.validate();     // Validate all fields
await controller.validateField('email'); // Validate single field
controller.clearErrors();        // Clear all validation errors
controller.reset();              // Reset to initial values
controller.clear();              // Clear all values

// Submit
await controller.submit((values) async {
  await api.save(values);
});

// Cleanup
controller.dispose();
```

**Key Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `status` | `FormStatus` | Current form lifecycle status |
| `isValid` | `bool` | All fields valid and not validating |
| `isDirty` | `bool` | Any field changed from initial value |
| `isValidating` | `bool` | Async validation in progress |
| `values` | `Map<String, dynamic>` | All current field values |
| `errors` | `Map<String, String>` | All fields with errors |
| `fieldNames` | `List<String>` | All registered field names |

### FieldState

Immutable state container for a form field. Tracks the current value, validation error, and interaction state.

```dart
class FieldState<T> {
  final T? value;           // Current value
  final String? error;      // Validation error
  final bool isTouched;     // Field has been focused
  final bool isDirty;       // Value differs from initial
  final bool isValidating;  // Async validation running

  bool get isValid => error == null && !isValidating;
  bool get hasError => error != null;
}

// Usage
final state = controller.getFieldState('email');
if (state.isTouched && state.hasError) {
  print(state.error);
}
```

### FormStatus

Enum representing the form lifecycle status:

| Status | Description |
|--------|-------------|
| `idle` | Default state, ready for input |
| `validating` | Validation in progress |
| `submitting` | Form submission in progress |
| `submitted` | Form successfully submitted |
| `error` | Validation or submission failed |

## Validators

### String Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `Required()` | Non-null, non-empty | `Required(message: 'Required')` |
| `MinLength(n)` | Minimum length | `MinLength(8)` |
| `MaxLength(n)` | Maximum length | `MaxLength(100)` |
| `Email()` | Valid email format | `Email()` |
| `Url()` | Valid URL format | `Url()` |
| `Pattern(regex)` | Matches pattern | `Pattern(RegExp(r'^[A-Z]+$'))` |
| `AlphaNumeric()` | Letters and numbers only | `AlphaNumeric()` |

### Number Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `Min(n)` | Minimum value | `Min(0)` |
| `Max(n)` | Maximum value | `Max(100)` |
| `Range(min, max)` | Within range (inclusive) | `Range(1, 10)` |
| `Integer()` | Must be integer | `Integer()` |
| `Positive()` | Must be positive (> 0) | `Positive()` |

### Date Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `MinDate(date)` | On or after date | `MinDate(DateTime.now())` |
| `MaxDate(date)` | On or before date | `MaxDate(DateTime(2030))` |
| `MinAge(years)` | Minimum age | `MinAge(18)` |
| `FutureDate()` | Must be future | `FutureDate()` |
| `PastDate()` | Must be past | `PastDate()` |

### Password Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `HasUppercase()` | Contains uppercase | `HasUppercase()` |
| `HasLowercase()` | Contains lowercase | `HasLowercase()` |
| `HasNumber()` | Contains digit | `HasNumber()` |
| `HasSpecialChar()` | Contains special char | `HasSpecialChar()` |

**Strong Password Example:**

```dart
validators: {
  'password': [
    Required(message: 'Password is required'),
    MinLength(8, message: 'At least 8 characters'),
    HasUppercase(message: 'Must contain uppercase letter'),
    HasLowercase(message: 'Must contain lowercase letter'),
    HasNumber(message: 'Must contain a number'),
    HasSpecialChar(message: 'Must contain special character'),
  ],
}
```

### Comparison Validators

| Validator | Description | Example |
|-----------|-------------|---------|
| `Equals(field)` | Equals another field | `Equals('password')` |
| `NotEquals(field)` | Differs from field | `NotEquals('oldPassword')` |

**Password Confirmation Example:**

```dart
validators: {
  'password': [Required(), MinLength(8)],
  'confirmPassword': [Required(), Equals('password', message: 'Passwords must match')],
}
```

### Custom Validators

**Synchronous:**

```dart
Custom<String>((value) {
  if (value?.contains('banned') == true) {
    return 'Contains banned word';
  }
  return null;
})
```

**Asynchronous with debounce:**

```dart
AsyncCustom<String>(
  (value) async {
    final exists = await api.checkUsername(value);
    return exists ? 'Username taken' : null;
  },
  debounce: Duration(milliseconds: 500),
)
```

### Composite Validators

**And - All must pass:**

```dart
And([Required(), MinLength(8), HasUppercase()])
```

**Or - At least one must pass:**

```dart
Or([Email(), Pattern(phoneRegex)])
```

## Form Fields

Wrapper components for fifty_ui widgets that integrate with `FiftyFormController`:

| Field | Wraps | Use Case |
|-------|-------|----------|
| `FiftyTextFormField` | `FiftyTextField` | Text input |
| `FiftyDropdownFormField` | `FiftyDropdown` | Selection from list |
| `FiftyCheckboxFormField` | `FiftyCheckbox` | Boolean toggle |
| `FiftySwitchFormField` | `FiftySwitch` | On/off toggle |
| `FiftyRadioFormField` | `FiftyRadioGroup` | Single selection from options |
| `FiftySliderFormField` | `FiftySlider` | Numeric range selection |
| `FiftyDateFormField` | Date picker | Date input |
| `FiftyTimeFormField` | Time picker | Time input |
| `FiftyFileFormField` | File picker | File upload |

**Text Field Example:**

```dart
FiftyTextFormField(
  name: 'email',
  controller: controller,
  label: 'Email Address',
  hint: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email,
  onChanged: (value) => print('Changed: $value'),
)
```

**Dropdown Example:**

```dart
FiftyDropdownFormField<String>(
  name: 'country',
  controller: controller,
  label: 'Country',
  items: [
    DropdownItem(value: 'us', label: 'United States'),
    DropdownItem(value: 'uk', label: 'United Kingdom'),
    DropdownItem(value: 'ca', label: 'Canada'),
  ],
)
```

## Multi-Step Forms

Create wizard-style forms with step validation:

```dart
FiftyMultiStepForm(
  controller: controller,
  steps: [
    FormStep(
      title: 'Account',
      description: 'Create your credentials',
      fields: ['email', 'password'],
    ),
    FormStep(
      title: 'Profile',
      fields: ['name', 'bio'],
      isOptional: true,  // Can skip this step
    ),
    FormStep(
      title: 'Review',
      fields: [],
      validator: (values) {
        // Step-level validation
        if (values['bio']?.isEmpty == true) {
          return 'Consider adding a bio';
        }
        return null;
      },
    ),
  ],
  stepBuilder: (context, index, step) => _buildStep(index),
  onComplete: (values) => api.createUser(values),
  onStepChanged: (step) => print('Now on step $step'),
  showProgress: true,
  validateOnNext: true,
  nextLabel: 'NEXT',
  previousLabel: 'BACK',
  completeLabel: 'COMPLETE',
)
```

**FormStep Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Step title for progress indicator |
| `description` | `String?` | Optional step description |
| `fields` | `List<String>` | Field names to validate for this step |
| `isOptional` | `bool` | Can skip if all fields empty |
| `validator` | `Function?` | Custom step-level validation |

## Dynamic Form Arrays

Add/remove repeating field groups:

```dart
FiftyFormArray(
  controller: controller,
  name: 'addresses',
  minItems: 1,
  maxItems: 5,
  itemBuilder: (context, index, remove) => Column(
    children: [
      FiftyTextFormField(
        name: 'addresses[$index].street',
        controller: controller,
        label: 'Street',
      ),
      FiftyTextFormField(
        name: 'addresses[$index].city',
        controller: controller,
        label: 'City',
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: remove,
      ),
    ],
  ),
  addButtonBuilder: (add) => FiftyButton(
    label: 'Add Address',
    onPressed: add,
    variant: FiftyButtonVariant.ghost,
    icon: Icons.add,
  ),
)
```

**Accessing Array Values:**

```dart
// Get single field
final street = controller.getArrayValue<String>('addresses', 0, 'street');

// Set single field
controller.setArrayValue('addresses', 0, 'city', 'New York');

// Get all items as list of maps
final addresses = controller.getArrayValues('addresses');
// Returns: [{'street': '123 Main', 'city': 'NYC'}, ...]

// Get array length
final count = controller.getArrayLength('addresses');

// Remove item (shifts subsequent indices)
controller.removeArrayItem('addresses', 1);
```

**FiftyFormArray Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `String` | required | Base name for array fields |
| `minItems` | `int` | `0` | Minimum items required |
| `maxItems` | `int` | `10` | Maximum items allowed |
| `initialCount` | `int` | `1` | Initial number of items |
| `animate` | `bool` | `true` | Animate add/remove |
| `itemSpacing` | `double` | `16` | Spacing between items |

## Draft Persistence

Auto-save and restore form data using GetStorage:

```dart
// Initialize storage (once at app start)
await DraftManager.initStorage();

// Create draft manager
final draftManager = DraftManager(
  controller: controller,
  key: 'registration_form',
  debounce: Duration(seconds: 2),
);

// Start auto-save
draftManager.start();

// Check for existing draft
if (await draftManager.hasDraft()) {
  final restored = await draftManager.restoreDraft();
  if (restored != null) {
    showSnackBar('Draft restored');
  }
}

// Manual save
await draftManager.saveDraft();

// Clear after successful submission
await controller.submit((values) async {
  await api.save(values);
  await draftManager.clearDraft();
});

// Stop auto-save (keeps draft)
draftManager.stop();

// Cleanup
draftManager.dispose();
```

**DraftManager Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `FiftyFormController` | required | Form controller to manage |
| `key` | `String` | required | Unique storage key for draft |
| `debounce` | `Duration` | `2 seconds` | Delay before auto-save |
| `containerName` | `String?` | `'fifty_forms_drafts'` | GetStorage container name |

## UI Widgets

| Widget | Description |
|--------|-------------|
| `FiftyForm` | Form container with controller binding |
| `FiftySubmitButton` | Submit button with loading state |
| `FiftyFormProgress` | Step progress indicator |
| `FiftyMultiStepForm` | Multi-step wizard container |
| `FiftyFormArray` | Dynamic repeating fields |
| `FiftyFormError` | Form-level error display |
| `FiftyFieldError` | Field-level error display |
| `FiftyValidationSummary` | All errors summary |
| `FiftyFormField` | Generic field wrapper |

**FiftySubmitButton Example:**

```dart
FiftySubmitButton(
  controller: controller,
  label: 'SUBMIT',
  icon: Icons.send,
  loadingText: 'SAVING...',
  onPressed: () => controller.submit((values) async {
    await api.save(values);
  }),
  disableWhenInvalid: true,
  expanded: true,
  variant: FiftyButtonVariant.primary,
)
```

## Example App

Run the example app to see all features in action:

```bash
cd packages/fifty_forms/example
flutter run
```

Examples included:
- **Login Form** - Simple validation
- **Registration Form** - Complex validation with async
- **Multi-Step Form** - Wizard with progress
- **Dynamic Form** - Array fields

## FDL Compliance

This package follows the Fifty Design Language (FDL):

- Uses `fifty_tokens` for design tokens (spacing, radii, typography)
- Uses `fifty_ui` for all UI components (buttons, text fields, etc.)
- Consumes theming from FDL packages
- No custom theme classes

## Dependencies

- `flutter` - Flutter SDK
- `fifty_tokens` - Design tokens
- `fifty_theme` - Theme system
- `fifty_ui` - UI components
- `get_storage` - Draft persistence

## License

MIT License - see LICENSE file for details.
