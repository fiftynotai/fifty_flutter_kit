# Changelog

All notable changes to fifty_forms will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [0.1.1] - 2026-02-22

### Added

- Pubspec `screenshots` field for pub.dev sidebar gallery

## [0.1.0] - 2026-01-21

Initial release of the fifty_forms package.

### Added

#### Core Components
- `FiftyFormController` - Centralized form state management with reactive updates
  - Field registration and unregistration
  - Value get/set with automatic validation
  - Form-level validation and submission
  - Async validation with debouncing
  - Validation change callbacks
- `FieldState<T>` - Immutable field state model
  - Value, error, touched, dirty, and validating states
  - `isValid` and `hasError` computed properties
  - `copyWith` for immutable updates
- `FormStatus` enum - Form lifecycle states (idle, validating, submitting, submitted, error)

#### Validators (25 built-in)
- **Required**: `Required` - Non-null, non-empty values (supports strings, collections, maps)
- **String Validators**:
  - `MinLength(n)` - Minimum string length
  - `MaxLength(n)` - Maximum string length
  - `Pattern(regex)` - Regular expression matching
  - `Email()` - Valid email format
  - `Url()` - Valid URL format with http/https/ftp schemes
  - `AlphaNumeric()` - Letters and numbers only
- **Number Validators**:
  - `Min(n)` - Minimum numeric value
  - `Max(n)` - Maximum numeric value
  - `Range(min, max)` - Value within range (inclusive)
  - `Integer()` - Whole numbers only
  - `Positive()` - Greater than zero
- **Date Validators**:
  - `MinDate(date)` - On or after specified date
  - `MaxDate(date)` - On or before specified date
  - `MinAge(years)` - Minimum age validation
  - `FutureDate()` - Must be in the future
  - `PastDate()` - Must be in the past
- **Password Validators**:
  - `HasUppercase()` - Contains uppercase letter
  - `HasLowercase()` - Contains lowercase letter
  - `HasNumber()` - Contains digit (0-9)
  - `HasSpecialChar()` - Contains special character
- **Comparison Validators**:
  - `Equals(fieldName)` - Equals another field's value
  - `NotEquals(fieldName)` - Differs from another field
- **Custom Validators**:
  - `Custom<T>(fn)` - Synchronous custom validation function
  - `AsyncCustom<T>(fn)` - Asynchronous validation with configurable debounce
- **Composite Validators**:
  - `And<T>(validators)` - All validators must pass
  - `Or<T>(validators)` - At least one validator must pass

#### Form Field Wrappers (9 field types)
- `FiftyTextFormField` - Text input with FiftyTextField
- `FiftyDropdownFormField` - Dropdown selection with FiftyDropdown
- `FiftyCheckboxFormField` - Checkbox toggle with FiftyCheckbox
- `FiftySwitchFormField` - Switch toggle with FiftySwitch
- `FiftyRadioFormField` - Radio button selection
- `FiftySliderFormField` - Slider input with FiftySlider
- `FiftyDateFormField` - Date picker integration
- `FiftyTimeFormField` - Time picker integration
- `FiftyFileFormField` - File picker integration
- `FormFieldBase` - Base class for custom field implementations

#### UI Widgets (9 components)
- `FiftyForm` - Form container with controller binding
- `FiftySubmitButton` - Submit button with loading state and validity tracking
- `FiftyFormProgress` - Step progress indicator for multi-step forms
- `FiftyMultiStepForm` - Multi-step wizard container with navigation
- `FiftyFormArray` - Dynamic repeating field groups with animations
- `FiftyFormError` - Form-level error display
- `FiftyFieldError` - Field-level error display
- `FiftyValidationSummary` - Summary of all validation errors
- `FiftyFormField` - Generic field wrapper

#### Models
- `FormStep` - Step definition for multi-step forms
  - Title, description, field names
  - Optional step support
  - Step-level custom validation
- `ValidationResult` - Validation result container

#### Persistence
- `DraftManager` - Auto-save and restore form drafts
  - GetStorage integration
  - Configurable debounce delay
  - Manual and automatic save/restore
  - Draft existence checking

#### Example App
- Login form demo (simple validation)
- Registration form demo (complex validation with async username check)
- Multi-step form demo (wizard with progress indicator)
- Dynamic form demo (array fields with add/remove)

### Technical Details

- Full FDL v2 compliance (consumes fifty_tokens and fifty_ui)
- Async validation with configurable debounce (default 300ms)
- Field state tracking (touched, dirty, validating)
- Form-level and step-level validation
- Array field support with automatic index management
- Lightweight persistence via GetStorage
- Reactive updates via ChangeNotifier
- Comprehensive Dartdoc documentation on all public APIs
