/// Fifty Forms - Production-ready form building for Flutter.
///
/// Provides:
/// - [FiftyFormController] for form state management
/// - [FieldState] for tracking individual field state
/// - [FormStatus] for form lifecycle status
/// - [Validator] for composable sync validators
/// - [AsyncValidator] for async validators with debouncing
/// - Form field widgets integrated with fifty_ui components
///
/// **Example:**
/// ```dart
/// import 'package:fifty_forms/fifty_forms.dart';
///
/// // Create form controller
/// final controller = FiftyFormController(
///   initialValues: {'email': '', 'password': ''},
///   validators: {
///     'email': [Required(), Email()],
///     'password': [Required(), MinLength(8)],
///   },
/// );
///
/// // Build form with integrated fields
/// Column(
///   children: [
///     FiftyTextFormField(
///       name: 'email',
///       controller: controller,
///       label: 'Email',
///       keyboardType: TextInputType.emailAddress,
///     ),
///     FiftyTextFormField(
///       name: 'password',
///       controller: controller,
///       label: 'Password',
///       obscureText: true,
///     ),
///   ],
/// )
///
/// // Validate and submit
/// await controller.submit((values) async {
///   await api.login(values['email'], values['password']);
/// });
/// ```
///
/// **Features:**
/// - Field state tracking (touched, dirty, validating)
/// - Sync and async validation with debouncing
/// - Form-level validation and submission
/// - FDL-styled form field widgets
/// - UI widgets (FiftyForm, FiftySubmitButton, FiftyFormProgress, etc.)
/// - Models (FormStep, ValidationResult)
/// - Multi-step wizard forms support
/// - Dynamic form arrays
/// - Draft auto-save persistence via DraftManager
library;

export 'src/core/core.dart';
export 'src/validators/validators.dart';
export 'src/fields/fields.dart';
export 'src/widgets/widgets.dart';
export 'src/models/models.dart';
export 'src/persistence/persistence.dart';
