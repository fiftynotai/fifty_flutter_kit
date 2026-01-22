import 'validator.dart';

/// Validator that requires a minimum numeric value.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Min(0, message: 'Value must be at least 0')
/// ```
class Min extends Validator<num> {
  /// The minimum allowed value.
  final num min;

  /// Creates a minimum value validator.
  ///
  /// [min] is the minimum allowed value (inclusive).
  /// [message] is the error message shown when validation fails.
  const Min(
    this.min, {
    String? message,
  }) : super(message: message ?? 'Must be at least $min');

  @override
  String? validate(num? value) {
    if (value == null) return null;
    if (value < min) return message;
    return null;
  }
}

/// Validator that enforces a maximum numeric value.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Max(100, message: 'Value must be at most 100')
/// ```
class Max extends Validator<num> {
  /// The maximum allowed value.
  final num max;

  /// Creates a maximum value validator.
  ///
  /// [max] is the maximum allowed value (inclusive).
  /// [message] is the error message shown when validation fails.
  const Max(
    this.max, {
    String? message,
  }) : super(message: message ?? 'Must be at most $max');

  @override
  String? validate(num? value) {
    if (value == null) return null;
    if (value > max) return message;
    return null;
  }
}

/// Validator that requires a value within a specific range.
///
/// Both minimum and maximum values are inclusive.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Range(1, 10, message: 'Value must be between 1 and 10')
/// ```
class Range extends Validator<num> {
  /// The minimum allowed value (inclusive).
  final num min;

  /// The maximum allowed value (inclusive).
  final num max;

  /// Creates a range validator.
  ///
  /// [min] is the minimum allowed value (inclusive).
  /// [max] is the maximum allowed value (inclusive).
  /// [message] is the error message shown when validation fails.
  const Range(
    this.min,
    this.max, {
    String? message,
  }) : super(message: message ?? 'Must be between $min and $max');

  @override
  String? validate(num? value) {
    if (value == null) return null;
    if (value < min || value > max) return message;
    return null;
  }
}

/// Validator that requires an integer value (no decimal places).
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Integer(message: 'Must be a whole number')
/// ```
class Integer extends Validator<num> {
  /// Creates an integer validator.
  ///
  /// [message] is the error message shown when validation fails.
  const Integer({
    super.message = 'Must be a whole number',
  });

  @override
  String? validate(num? value) {
    if (value == null) return null;
    if (value != value.truncate()) return message;
    return null;
  }
}

/// Validator that requires a positive value (greater than 0).
///
/// Zero is not considered positive.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// Positive(message: 'Must be greater than 0')
/// ```
class Positive extends Validator<num> {
  /// Creates a positive number validator.
  ///
  /// [message] is the error message shown when validation fails.
  const Positive({
    super.message = 'Must be greater than 0',
  });

  @override
  String? validate(num? value) {
    if (value == null) return null;
    if (value <= 0) return message;
    return null;
  }
}
