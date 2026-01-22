/// Defines a step in a multi-step form.
///
/// Each step contains a set of fields that are validated together.
/// Steps can have custom validators that validate relationships between fields.
///
/// **Example:**
/// ```dart
/// FormStep(
///   title: 'Account Details',
///   description: 'Enter your account information',
///   fields: ['email', 'password', 'confirmPassword'],
///   validator: (values) => values['password'] == values['confirmPassword']
///       ? null
///       : 'Passwords must match',
/// )
/// ```
///
/// **With optional step:**
/// ```dart
/// FormStep(
///   title: 'Additional Info',
///   description: 'Optional details about yourself',
///   fields: ['bio', 'website', 'twitter'],
///   isOptional: true,
/// )
/// ```
class FormStep {
  /// Step title displayed in progress indicator.
  final String title;

  /// Optional step description providing context.
  final String? description;

  /// Field names included in this step.
  ///
  /// These fields will be validated when attempting to advance past this step.
  final List<String> fields;

  /// Whether this step is optional (can be skipped).
  ///
  /// Optional steps don't require validation to pass before proceeding.
  /// Defaults to false.
  final bool isOptional;

  /// Custom validator for the entire step.
  ///
  /// Receives all field values and returns an error message if validation fails.
  /// Use this to validate relationships between fields (e.g., password matching).
  ///
  /// **Example:**
  /// ```dart
  /// validator: (values) {
  ///   if (values['startDate'] != null && values['endDate'] != null) {
  ///     final start = DateTime.parse(values['startDate']);
  ///     final end = DateTime.parse(values['endDate']);
  ///     if (end.isBefore(start)) {
  ///       return 'End date must be after start date';
  ///     }
  ///   }
  ///   return null;
  /// }
  /// ```
  final String? Function(Map<String, dynamic> values)? validator;

  /// Creates a form step definition.
  const FormStep({
    required this.title,
    this.description,
    required this.fields,
    this.isOptional = false,
    this.validator,
  });

  /// Creates a copy of this step with the given fields replaced.
  FormStep copyWith({
    String? title,
    String? description,
    List<String>? fields,
    bool? isOptional,
    String? Function(Map<String, dynamic> values)? validator,
  }) {
    return FormStep(
      title: title ?? this.title,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      isOptional: isOptional ?? this.isOptional,
      validator: validator ?? this.validator,
    );
  }

  @override
  String toString() {
    return 'FormStep(title: $title, fields: $fields, isOptional: $isOptional)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FormStep) return false;
    return title == other.title &&
        description == other.description &&
        _listEquals(fields, other.fields) &&
        isOptional == other.isOptional;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      description,
      Object.hashAll(fields),
      isOptional,
    );
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
