/// Base class for form field validators.
///
/// Validators check field values and return error messages when validation fails.
/// Extend this class to create custom sync validators.
///
/// **Example:**
/// ```dart
/// class MinLength extends Validator<String> {
///   final int length;
///
///   const MinLength(this.length, {String? message})
///       : super(message: message ?? 'Minimum $length characters required');
///
///   @override
///   String? validate(String? value) {
///     if (value == null || value.length < length) {
///       return message;
///     }
///     return null;
///   }
/// }
/// ```
abstract class Validator<T> {
  /// Creates a validator with an error message.
  ///
  /// [message] is the error message returned when validation fails.
  const Validator({required this.message});

  /// Error message returned when validation fails.
  final String message;

  /// Validates [value] and returns error message or null if valid.
  ///
  /// Returns [message] if the value is invalid.
  /// Returns null if the value is valid.
  String? validate(T? value);
}

/// Marker interface for async validators.
///
/// Async validators are used for validation that requires asynchronous
/// operations, such as API calls or database queries.
///
/// **Example:**
/// ```dart
/// class UniqueEmailValidator extends AsyncValidator<String> {
///   final Future<bool> Function(String) checkEmail;
///
///   UniqueEmailValidator({
///     required this.checkEmail,
///     super.debounce,
///   }) : super(message: 'Email already exists');
///
///   @override
///   Future<String?> validateAsync(String? value) async {
///     if (value == null || value.isEmpty) return null;
///     final exists = await checkEmail(value);
///     return exists ? message : null;
///   }
/// }
/// ```
abstract class AsyncValidator<T> extends Validator<T> {
  /// Creates an async validator.
  ///
  /// [message] is the error message returned when validation fails.
  /// [debounce] is the duration to wait before running validation.
  const AsyncValidator({
    required super.message,
    this.debounce = const Duration(milliseconds: 300),
  });

  /// Duration to wait before running validation.
  ///
  /// This helps reduce API calls when the user is typing.
  final Duration debounce;

  /// Synchronous validation is not supported for async validators.
  ///
  /// Always returns null. Use [validateAsync] instead.
  @override
  String? validate(T? value) => null;

  /// Validates [value] asynchronously.
  ///
  /// Returns error message if the value is invalid.
  /// Returns null if the value is valid.
  Future<String?> validateAsync(T? value);
}

/// Async validator that uses a custom async function.
///
/// Use this for validation that requires asynchronous operations,
/// such as API calls, database queries, or file system checks.
///
/// **Example:**
/// ```dart
/// AsyncCustom<String>(
///   (value) async {
///     final exists = await api.checkEmailExists(value);
///     return exists ? 'Email already registered' : null;
///   },
///   debounce: Duration(milliseconds: 500),
/// )
/// ```
///
/// **Example with username availability:**
/// ```dart
/// AsyncCustom<String>(
///   (value) async {
///     if (value == null || value.isEmpty) return null;
///     final available = await userService.isUsernameAvailable(value);
///     return available ? null : 'Username is already taken';
///   },
///   debounce: Duration(milliseconds: 300),
///   message: 'Username check failed',
/// )
/// ```
class AsyncCustom<T> extends AsyncValidator<T> {
  /// The async validation function.
  ///
  /// Takes the value and returns a Future with an error message or null.
  final Future<String?> Function(T? value) validator;

  /// Creates an async custom validator.
  ///
  /// [validator] is the async validation function.
  /// [message] is the fallback error message.
  /// [debounce] is the duration to wait before running validation.
  const AsyncCustom(
    this.validator, {
    super.message = 'Validation failed',
    super.debounce,
  });

  @override
  Future<String?> validateAsync(T? value) {
    return validator(value);
  }
}
