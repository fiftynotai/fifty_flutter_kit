import 'validator.dart';

/// Validator that combines multiple validators (all must pass).
///
/// Short-circuits on first failure, returning the error message from the
/// first failing validator.
///
/// **Example:**
/// ```dart
/// And<String>([
///   Required(),
///   MinLength(8),
///   HasUppercase(),
/// ])
/// ```
///
/// **Example with password validation:**
/// ```dart
/// And<String>([
///   Required(message: 'Password is required'),
///   MinLength(8, message: 'Password must be at least 8 characters'),
///   HasUppercase(message: 'Password must contain an uppercase letter'),
///   HasLowercase(message: 'Password must contain a lowercase letter'),
///   HasNumber(message: 'Password must contain a number'),
///   HasSpecialChar(message: 'Password must contain a special character'),
/// ])
/// ```
class And<T> extends Validator<T> {
  /// The list of validators that must all pass.
  final List<Validator<T>> validators;

  /// Creates an AND composite validator.
  ///
  /// [validators] is the list of validators that must all pass.
  /// [message] is the fallback message (not typically used since
  /// individual validators provide their own messages).
  const And(
    this.validators, {
    super.message = 'Validation failed',
  });

  @override
  String? validate(T? value) {
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}

/// Validator that passes if any validator passes.
///
/// Returns the error from the last validator if all fail.
///
/// **Example:**
/// ```dart
/// Or<String>([
///   Email(),
///   Pattern(RegExp(r'^\d{10}$'), message: 'Must be email or 10-digit phone'),
/// ])
/// ```
///
/// **Example with flexible identifier:**
/// ```dart
/// Or<String>([
///   Email(message: 'Invalid email'),
///   Pattern(RegExp(r'^\+?[0-9]{10,15}$'), message: 'Invalid phone'),
///   Pattern(RegExp(r'^@[a-zA-Z0-9_]{1,15}$'), message: 'Invalid username'),
/// ], message: 'Please enter a valid email, phone, or username')
/// ```
class Or<T> extends Validator<T> {
  /// The list of validators where at least one must pass.
  final List<Validator<T>> validators;

  /// Creates an OR composite validator.
  ///
  /// [validators] is the list of validators where at least one must pass.
  /// [message] is the fallback message if all validators fail.
  const Or(
    this.validators, {
    super.message = 'Validation failed',
  });

  @override
  String? validate(T? value) {
    String? lastError;
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error == null) return null;
      lastError = error;
    }
    return lastError ?? message;
  }
}
