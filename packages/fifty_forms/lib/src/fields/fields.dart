/// Field wrapper widgets for fifty_forms.
///
/// Provides form-integrated field widgets that wrap fifty_ui components
/// and connect them to [FiftyFormController] for automatic:
/// - Field registration
/// - Value synchronization
/// - Error display from validation
/// - Touch tracking
///
/// **Available Fields:**
/// - [FiftyTextFormField] - Text input
/// - [FiftyDropdownFormField] - Dropdown selector
/// - [FiftyCheckboxFormField] - Checkbox toggle
/// - [FiftySwitchFormField] - Switch toggle
/// - [FiftyRadioFormField] - Radio button
/// - [FiftySliderFormField] - Slider control
/// - [FiftyDateFormField] - Date picker
/// - [FiftyTimeFormField] - Time picker
/// - [FiftyFileFormField] - File upload (placeholder)
///
/// **Example:**
/// ```dart
/// final controller = FiftyFormController(
///   initialValues: {'email': '', 'acceptTerms': false},
///   validators: {
///     'email': [Required(), Email()],
///     'acceptTerms': [
///       Custom<bool>((v) => v == true ? null : 'Required'),
///     ],
///   },
/// );
///
/// Column(
///   children: [
///     FiftyTextFormField(
///       name: 'email',
///       controller: controller,
///       label: 'Email',
///     ),
///     FiftyCheckboxFormField(
///       name: 'acceptTerms',
///       controller: controller,
///       label: 'I accept the terms',
///     ),
///   ],
/// )
/// ```
library;

export 'form_field_base.dart';
export 'text_form_field.dart';
export 'dropdown_form_field.dart';
export 'checkbox_form_field.dart';
export 'switch_form_field.dart';
export 'radio_form_field.dart';
export 'slider_form_field.dart';
export 'date_form_field.dart';
export 'time_form_field.dart';
export 'file_form_field.dart';
