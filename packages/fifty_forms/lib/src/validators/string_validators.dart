import 'validator.dart';

/// Validator that requires a minimum string length.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// MinLength(8, message: 'Must be at least 8 characters')
/// ```
class MinLength extends Validator<String> {
  /// The minimum required length.
  final int length;

  /// Creates a minimum length validator.
  ///
  /// [length] is the minimum required string length.
  /// [message] is the error message shown when validation fails.
  const MinLength(
    this.length, {
    String? message,
  }) : super(message: message ?? 'Must be at least $length characters');

  @override
  String? validate(String? value) {
    if (value == null) return null;
    if (value.length < length) return message;
    return null;
  }
}

/// Validator that enforces a maximum string length.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// MaxLength(100, message: 'Must be at most 100 characters')
/// ```
class MaxLength extends Validator<String> {
  /// The maximum allowed length.
  final int length;

  /// Creates a maximum length validator.
  ///
  /// [length] is the maximum allowed string length.
  /// [message] is the error message shown when validation fails.
  const MaxLength(
    this.length, {
    String? message,
  }) : super(message: message ?? 'Must be at most $length characters');

  @override
  String? validate(String? value) {
    if (value == null) return null;
    if (value.length > length) return message;
    return null;
  }
}

/// Validator that checks if a string matches a regular expression pattern.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Pattern(RegExp(r'^[A-Z]{3}$'), message: 'Must be 3 uppercase letters')
/// ```
class Pattern extends Validator<String> {
  /// The regular expression pattern to match against.
  final RegExp regex;

  /// Creates a pattern validator.
  ///
  /// [regex] is the regular expression pattern to match.
  /// [message] is the error message shown when validation fails.
  const Pattern(
    this.regex, {
    super.message = 'Invalid format',
  });

  @override
  String? validate(String? value) {
    if (value == null) return null;
    if (!regex.hasMatch(value)) return message;
    return null;
  }
}

/// Validator that checks for a valid email format.
///
/// Uses a standard email regex pattern that validates:
/// - Local part with alphanumeric characters, dots, hyphens, and underscores
/// - @ symbol
/// - Domain with alphanumeric characters and hyphens
/// - TLD with at least 2 characters
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Email(message: 'Please enter a valid email')
/// ```
class Email extends Validator<String> {
  /// Standard email validation regex.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Creates an email validator.
  ///
  /// [message] is the error message shown when validation fails.
  const Email({
    super.message = 'Invalid email address',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_emailRegex.hasMatch(value)) return message;
    return null;
  }
}

/// Validator that checks for a valid URL format.
///
/// Validates URLs with:
/// - http, https, or ftp protocol (required)
/// - Valid domain name or IP address
/// - Optional port number
/// - Optional path, query string, and fragment
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Url(message: 'Please enter a valid URL')
/// ```
class Url extends Validator<String> {
  /// Creates a URL validator.
  ///
  /// [message] is the error message shown when validation fails.
  const Url({
    super.message = 'Invalid URL',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    // Use Uri.tryParse for more reliable URL validation
    final uri = Uri.tryParse(value);
    if (uri == null) return message;
    if (!uri.hasScheme || !['http', 'https', 'ftp'].contains(uri.scheme.toLowerCase())) {
      return message;
    }
    if (uri.host.isEmpty) return message;
    return null;
  }
}

/// Validator that checks if a string contains only alphanumeric characters.
///
/// Allows letters (a-z, A-Z) and numbers (0-9) only.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// AlphaNumeric(message: 'Only letters and numbers allowed')
/// ```
class AlphaNumeric extends Validator<String> {
  /// Alphanumeric validation regex.
  static final RegExp _alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');

  /// Creates an alphanumeric validator.
  ///
  /// [message] is the error message shown when validation fails.
  const AlphaNumeric({
    super.message = 'Only letters and numbers allowed',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_alphaNumericRegex.hasMatch(value)) return message;
    return null;
  }
}
