import 'validator.dart';

/// Validator that requires a non-null, non-empty value.
///
/// Works with:
/// - Strings (rejects null, empty, whitespace-only)
/// - Collections (rejects null, empty)
/// - Any other type (rejects null)
///
/// **Example:**
/// ```dart
/// Required(message: 'This field is required')
/// ```
class Required extends Validator<dynamic> {
  /// Creates a required validator.
  ///
  /// [message] is the error message shown when validation fails.
  const Required({
    super.message = 'This field is required',
  });

  @override
  String? validate(dynamic value) {
    if (value == null) return message;
    if (value is String && value.trim().isEmpty) return message;
    if (value is Iterable && value.isEmpty) return message;
    if (value is Map && value.isEmpty) return message;
    return null;
  }
}
