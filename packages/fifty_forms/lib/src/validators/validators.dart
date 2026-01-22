/// Form validation components.
///
/// Provides a comprehensive set of composable validators for form validation.
///
/// **Base Classes:**
/// - [Validator] - Base class for synchronous validators
/// - [AsyncValidator] - Base class for asynchronous validators
/// - [FieldReferenceValidator] - Base class for validators that compare fields
///
/// **Built-in Validators:**
/// - [Required] - Requires non-null, non-empty values
/// - String: [MinLength], [MaxLength], [Pattern], [Email], [Url], [AlphaNumeric]
/// - Number: [Min], [Max], [Range], [Integer], [Positive]
/// - Date: [MinDate], [MaxDate], [MinAge], [FutureDate], [PastDate]
/// - Password: [HasUppercase], [HasLowercase], [HasNumber], [HasSpecialChar]
/// - Match: [Equals], [NotEquals]
/// - Custom: [Custom], [AsyncCustom]
/// - Composite: [And], [Or]
///
/// **Example:**
/// ```dart
/// final validators = [
///   Required(),
///   MinLength(8),
///   HasUppercase(),
///   HasNumber(),
/// ];
///
/// for (final validator in validators) {
///   final error = validator.validate(value);
///   if (error != null) return error;
/// }
/// ```
library;

export 'composite_validators.dart';
export 'custom_validator.dart';
export 'date_validators.dart';
export 'match_validators.dart';
export 'number_validators.dart';
export 'password_validators.dart';
export 'required_validator.dart';
export 'string_validators.dart';
export 'validator.dart';
