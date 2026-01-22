import 'package:flutter/foundation.dart';

/// Immutable state container for a form field.
///
/// Tracks the current value, validation error, and interaction state
/// (touched, dirty, validating) for a single form field.
///
/// **Example:**
/// ```dart
/// final state = FieldState.initial('');
/// print(state.isTouched); // false
/// print(state.isDirty); // false
///
/// final updated = state.copyWith(
///   value: 'hello',
///   isDirty: true,
/// );
/// print(updated.isDirty); // true
/// ```
@immutable
class FieldState<T> {
  /// Creates a field state.
  ///
  /// [value] is the current field value.
  /// [error] is the validation error message, if any.
  /// [isTouched] indicates if the user has interacted with the field.
  /// [isDirty] indicates if the value has changed from the initial value.
  /// [isValidating] indicates if async validation is running.
  const FieldState({
    required this.value,
    this.error,
    this.isTouched = false,
    this.isDirty = false,
    this.isValidating = false,
  });

  /// Creates a field state with an initial value.
  ///
  /// The field is not touched, not dirty, and not validating.
  factory FieldState.initial(T value) {
    return FieldState<T>(value: value);
  }

  /// Creates an empty field state with null value.
  ///
  /// Useful for optional fields or when no initial value is available.
  factory FieldState.empty() {
    return const FieldState<Never>(value: null);
  }

  /// The current value of the field.
  final T? value;

  /// Validation error message, or null if the field is valid.
  final String? error;

  /// Whether the user has interacted with the field (focused/blurred).
  ///
  /// Used to determine when to show validation errors.
  final bool isTouched;

  /// Whether the value has changed from the initial value.
  ///
  /// Used to track unsaved changes.
  final bool isDirty;

  /// Whether async validation is currently running.
  ///
  /// Used to show loading indicators during validation.
  final bool isValidating;

  /// Whether the field has a validation error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Whether the field is valid (no error and not validating).
  bool get isValid => !hasError && !isValidating;

  /// Creates a copy with the given fields replaced.
  FieldState<T> copyWith({
    T? value,
    String? error,
    bool? isTouched,
    bool? isDirty,
    bool? isValidating,
    bool clearError = false,
  }) {
    return FieldState<T>(
      value: value ?? this.value,
      error: clearError ? null : (error ?? this.error),
      isTouched: isTouched ?? this.isTouched,
      isDirty: isDirty ?? this.isDirty,
      isValidating: isValidating ?? this.isValidating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldState<T> &&
        other.value == value &&
        other.error == error &&
        other.isTouched == isTouched &&
        other.isDirty == isDirty &&
        other.isValidating == isValidating;
  }

  @override
  int get hashCode {
    return Object.hash(
      value,
      error,
      isTouched,
      isDirty,
      isValidating,
    );
  }

  @override
  String toString() {
    return 'FieldState(value: $value, error: $error, '
        'touched: $isTouched, dirty: $isDirty, validating: $isValidating)';
  }
}
