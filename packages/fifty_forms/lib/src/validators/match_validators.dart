import 'validator.dart';

/// Interface for validators that need access to other field values.
///
/// Use this interface when a validator needs to compare the current field's
/// value against another field in the form.
///
/// **Example:**
/// ```dart
/// class ConfirmPassword extends FieldReferenceValidator<String> {
///   @override
///   String get referenceFieldName => 'password';
///
///   @override
///   String? validateWithReference(String? value, dynamic referenceValue) {
///     if (value != referenceValue) return 'Passwords do not match';
///     return null;
///   }
/// }
/// ```
abstract class FieldReferenceValidator<T> extends Validator<T> {
  /// Creates a field reference validator.
  const FieldReferenceValidator({required super.message});

  /// The name of the field to compare against.
  String get referenceFieldName;

  /// Validates against the reference field value.
  ///
  /// [value] is the current field's value.
  /// [referenceValue] is the value of the referenced field.
  ///
  /// Returns an error message if validation fails, or null if valid.
  String? validateWithReference(T? value, dynamic referenceValue);

  /// Standard validate method - cannot be used without reference value.
  ///
  /// This method always returns null. Use [validateWithReference] instead
  /// when the form controller provides the reference field value.
  @override
  String? validate(T? value) => null;
}

/// Validator that checks if a field's value equals another field's value.
///
/// Commonly used for password confirmation fields.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Equals('password', message: 'Passwords do not match')
/// ```
class Equals extends FieldReferenceValidator<dynamic> {
  @override
  final String referenceFieldName;

  /// Creates an equals validator.
  ///
  /// [referenceFieldName] is the name of the field to compare against.
  /// [message] is the error message shown when validation fails.
  const Equals(
    this.referenceFieldName, {
    String? message,
  }) : super(message: message ?? 'Must match $referenceFieldName');

  @override
  String? validateWithReference(dynamic value, dynamic referenceValue) {
    if (value == null) return null;
    if (value != referenceValue) return message;
    return null;
  }
}

/// Validator that checks if a field's value differs from another field's value.
///
/// Useful for ensuring two fields have different values (e.g., new password
/// must be different from old password).
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// NotEquals('oldPassword', message: 'New password must be different')
/// ```
class NotEquals extends FieldReferenceValidator<dynamic> {
  @override
  final String referenceFieldName;

  /// Creates a not equals validator.
  ///
  /// [referenceFieldName] is the name of the field to compare against.
  /// [message] is the error message shown when validation fails.
  const NotEquals(
    this.referenceFieldName, {
    String? message,
  }) : super(message: message ?? 'Must be different from $referenceFieldName');

  @override
  String? validateWithReference(dynamic value, dynamic referenceValue) {
    if (value == null) return null;
    if (value == referenceValue) return message;
    return null;
  }
}
