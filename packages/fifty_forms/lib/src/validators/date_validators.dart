import 'validator.dart';

/// Validator that requires a date on or after a minimum date.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// MinDate(DateTime(2020, 1, 1), message: 'Date must be after Jan 1, 2020')
/// ```
class MinDate extends Validator<DateTime> {
  /// The minimum allowed date (inclusive).
  final DateTime min;

  /// Creates a minimum date validator.
  ///
  /// [min] is the minimum allowed date (inclusive).
  /// [message] is the error message shown when validation fails.
  MinDate(
    this.min, {
    String? message,
  }) : super(message: message ?? 'Date must be on or after ${_formatDate(min)}');

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (value.isBefore(min)) return message;
    return null;
  }
}

/// Validator that requires a date on or before a maximum date.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// MaxDate(DateTime(2030, 12, 31), message: 'Date must be before Dec 31, 2030')
/// ```
class MaxDate extends Validator<DateTime> {
  /// The maximum allowed date (inclusive).
  final DateTime max;

  /// Creates a maximum date validator.
  ///
  /// [max] is the maximum allowed date (inclusive).
  /// [message] is the error message shown when validation fails.
  MaxDate(
    this.max, {
    String? message,
  }) : super(message: message ?? 'Date must be on or before ${_formatDate(max)}');

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (value.isAfter(max)) return message;
    return null;
  }
}

/// Validator that requires a minimum age in years.
///
/// Calculates age based on the difference between the provided date and today.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// MinAge(18, message: 'Must be at least 18 years old')
/// ```
class MinAge extends Validator<DateTime> {
  /// The minimum required age in years.
  final int years;

  /// Creates a minimum age validator.
  ///
  /// [years] is the minimum required age in years.
  /// [message] is the error message shown when validation fails.
  const MinAge(
    this.years, {
    String? message,
  }) : super(message: message ?? 'Must be at least $years years old');

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;

    final now = DateTime.now();
    var age = now.year - value.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (now.month < value.month ||
        (now.month == value.month && now.day < value.day)) {
      age--;
    }

    if (age < years) return message;
    return null;
  }
}

/// Validator that requires a date in the future.
///
/// The date must be after the current date/time.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// FutureDate(message: 'Date must be in the future')
/// ```
class FutureDate extends Validator<DateTime> {
  /// Creates a future date validator.
  ///
  /// [message] is the error message shown when validation fails.
  const FutureDate({
    super.message = 'Date must be in the future',
  });

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (!value.isAfter(DateTime.now())) return message;
    return null;
  }
}

/// Validator that requires a date in the past.
///
/// The date must be before the current date/time.
///
/// Returns null for null values (use [Required] to check for null).
///
/// **Example:**
/// ```dart
/// PastDate(message: 'Date must be in the past')
/// ```
class PastDate extends Validator<DateTime> {
  /// Creates a past date validator.
  ///
  /// [message] is the error message shown when validation fails.
  const PastDate({
    super.message = 'Date must be in the past',
  });

  @override
  String? validate(DateTime? value) {
    if (value == null) return null;
    if (!value.isBefore(DateTime.now())) return message;
    return null;
  }
}

/// Formats a date for display in error messages.
String _formatDate(DateTime date) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
