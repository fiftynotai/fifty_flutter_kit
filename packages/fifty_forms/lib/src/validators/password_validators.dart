import 'validator.dart';

/// Validator that requires at least one uppercase letter.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// HasUppercase(message: 'Must contain an uppercase letter')
/// ```
class HasUppercase extends Validator<String> {
  /// Uppercase letter regex.
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');

  /// Creates an uppercase validator.
  ///
  /// [message] is the error message shown when validation fails.
  const HasUppercase({
    super.message = 'Must contain at least one uppercase letter',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_uppercaseRegex.hasMatch(value)) return message;
    return null;
  }
}

/// Validator that requires at least one lowercase letter.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// HasLowercase(message: 'Must contain a lowercase letter')
/// ```
class HasLowercase extends Validator<String> {
  /// Lowercase letter regex.
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');

  /// Creates a lowercase validator.
  ///
  /// [message] is the error message shown when validation fails.
  const HasLowercase({
    super.message = 'Must contain at least one lowercase letter',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_lowercaseRegex.hasMatch(value)) return message;
    return null;
  }
}

/// Validator that requires at least one digit (0-9).
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// HasNumber(message: 'Must contain a number')
/// ```
class HasNumber extends Validator<String> {
  /// Digit regex.
  static final RegExp _numberRegex = RegExp(r'[0-9]');

  /// Creates a number validator.
  ///
  /// [message] is the error message shown when validation fails.
  const HasNumber({
    super.message = 'Must contain at least one number',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_numberRegex.hasMatch(value)) return message;
    return null;
  }
}

/// Validator that requires at least one special character.
///
/// Special characters include: !@#$%^&*(),.?":{}|<>~`-_+=[];'/\
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// HasSpecialChar(message: 'Must contain a special character')
/// ```
class HasSpecialChar extends Validator<String> {
  /// Special character regex.
  static final RegExp _specialCharRegex = RegExp(
    r'''[!@#$%^&*(),.?":{}|<>~`\-_+=\[\];'/\\]''',
  );

  /// Creates a special character validator.
  ///
  /// [message] is the error message shown when validation fails.
  const HasSpecialChar({
    super.message = 'Must contain at least one special character',
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!_specialCharRegex.hasMatch(value)) return message;
    return null;
  }
}
