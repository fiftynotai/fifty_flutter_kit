/// Result of a validation operation.
///
/// Encapsulates validation state with errors mapped to field names.
/// Use factory constructors for convenience.
///
/// **Example:**
/// ```dart
/// final result = ValidationResult.invalid({'email': 'Invalid email format'});
/// if (!result.isValid) {
///   print(result.errors);
/// }
/// ```
///
/// **Multiple errors:**
/// ```dart
/// final result = ValidationResult.invalid({
///   'password': 'Password too short',
///   'confirmPassword': 'Passwords do not match',
/// });
///
/// for (final entry in result.errors.entries) {
///   print('${entry.key}: ${entry.value}');
/// }
/// ```
class ValidationResult {
  /// Whether the validation passed.
  final bool isValid;

  /// Map of field names to their error messages.
  ///
  /// Empty if validation passed.
  final Map<String, String> errors;

  const ValidationResult._({
    required this.isValid,
    required this.errors,
  });

  /// Creates a successful validation result with no errors.
  ///
  /// **Example:**
  /// ```dart
  /// final result = ValidationResult.valid();
  /// print(result.isValid); // true
  /// print(result.errors.isEmpty); // true
  /// ```
  factory ValidationResult.valid() => const ValidationResult._(
        isValid: true,
        errors: {},
      );

  /// Creates a failed validation result with the given errors.
  ///
  /// [errors] must not be empty.
  ///
  /// **Example:**
  /// ```dart
  /// final result = ValidationResult.invalid({
  ///   'email': 'Email is required',
  ///   'name': 'Name is required',
  /// });
  /// ```
  factory ValidationResult.invalid(Map<String, String> errors) {
    assert(errors.isNotEmpty, 'Invalid result must have at least one error');
    return ValidationResult._(
      isValid: false,
      errors: Map.unmodifiable(errors),
    );
  }

  /// Gets the error message for a specific field.
  ///
  /// Returns null if the field has no error.
  String? getError(String fieldName) => errors[fieldName];

  /// Whether a specific field has an error.
  bool hasError(String fieldName) => errors.containsKey(fieldName);

  /// Whether there are any errors.
  bool get hasErrors => errors.isNotEmpty;

  /// Total number of fields with errors.
  int get errorCount => errors.length;

  /// List of field names that have errors.
  List<String> get errorFields => errors.keys.toList();

  /// Merges this result with another, combining errors.
  ///
  /// The resulting validity is the AND of both results.
  ///
  /// **Example:**
  /// ```dart
  /// final result1 = ValidationResult.invalid({'email': 'Invalid'});
  /// final result2 = ValidationResult.invalid({'name': 'Required'});
  /// final combined = result1.merge(result2);
  /// print(combined.errors); // {email: Invalid, name: Required}
  /// ```
  ValidationResult merge(ValidationResult other) {
    if (isValid && other.isValid) {
      return ValidationResult.valid();
    }

    final mergedErrors = <String, String>{
      ...errors,
      ...other.errors,
    };

    return ValidationResult.invalid(mergedErrors);
  }

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult.valid()';
    }
    return 'ValidationResult.invalid($errors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ValidationResult) return false;
    return isValid == other.isValid && _mapEquals(errors, other.errors);
  }

  @override
  int get hashCode => Object.hash(isValid, Object.hashAll(errors.entries));

  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
