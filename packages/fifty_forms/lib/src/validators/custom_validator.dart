import 'validator.dart';

/// Validator that uses a custom validation function.
///
/// Use this when you need validation logic that doesn't fit the built-in
/// validators. The function receives the value and returns an error message
/// or null if valid.
///
/// **Example:**
/// ```dart
/// Custom<String>(
///   (value) => value?.contains('@') == true ? null : 'Must contain @',
/// )
/// ```
///
/// **Example with external validation:**
/// ```dart
/// Custom<String>(
///   (value) {
///     if (value == null) return null;
///     if (bannedUsernames.contains(value)) {
///       return 'This username is not available';
///     }
///     return null;
///   },
/// )
/// ```
class Custom<T> extends Validator<T> {
  /// The custom validation function.
  ///
  /// Takes the value and returns an error message or null if valid.
  final String? Function(T? value) validator;

  /// Creates a custom validator.
  ///
  /// [validator] is the custom validation function.
  /// [message] is the fallback error message (used if validator returns
  /// a non-null value but the message should be overridden).
  const Custom(
    this.validator, {
    super.message = 'Validation failed',
  });

  @override
  String? validate(T? value) {
    return validator(value);
  }
}
