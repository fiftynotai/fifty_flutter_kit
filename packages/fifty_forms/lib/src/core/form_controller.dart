import 'dart:async';

import 'package:flutter/foundation.dart';

import '../validators/validator.dart';
import 'field_state.dart';
import 'form_status.dart';

/// Controller for managing form state and validation.
///
/// Handles field registration, value tracking, validation (sync and async),
/// and form submission. Uses [ChangeNotifier] for reactive UI updates.
///
/// **Example:**
/// ```dart
/// final controller = FiftyFormController(
///   initialValues: {'email': '', 'password': ''},
///   validators: {
///     'email': [Required(), Email()],
///     'password': [Required(), MinLength(8)],
///   },
///   onValidationChanged: (isValid) {
///     print('Form is ${isValid ? 'valid' : 'invalid'}');
///   },
/// );
///
/// // Update field value
/// controller.setValue('email', 'user@example.com');
///
/// // Check validation
/// final isValid = await controller.validate();
///
/// // Submit form
/// await controller.submit((values) async {
///   await api.register(values['email'], values['password']);
/// });
/// ```
class FiftyFormController extends ChangeNotifier {
  /// Creates a form controller.
  ///
  /// [initialValues] is the initial field values map.
  /// [validators] is the validators for each field.
  /// [onValidationChanged] is called when overall form validity changes.
  FiftyFormController({
    Map<String, dynamic> initialValues = const {},
    Map<String, List<Validator<dynamic>>> validators = const {},
    this.onValidationChanged,
  })  : _validators = Map.from(validators),
        _initialValues = Map.from(initialValues) {
    // Register fields from initial values
    for (final entry in initialValues.entries) {
      _fields[entry.key] = FieldState<dynamic>.initial(entry.value);
    }
  }

  // ---- Internal State ----

  /// Field states indexed by field name.
  final Map<String, FieldState<dynamic>> _fields = {};

  /// Validators for each field.
  final Map<String, List<Validator<dynamic>>> _validators;

  /// Initial values for reset functionality.
  final Map<String, dynamic> _initialValues;

  /// Current form status.
  FormStatus _status = FormStatus.idle;

  /// Debounce timers for async validation.
  final Map<String, Timer> _debounceTimers = {};

  /// Previous overall validity state.
  bool _previousIsValid = true;

  /// Callback when overall form validity changes.
  final void Function(bool isValid)? onValidationChanged;

  // ---- Public Getters ----

  /// Current form status.
  FormStatus get status => _status;

  /// Whether the form is valid (all fields valid, not validating).
  bool get isValid {
    for (final state in _fields.values) {
      if (!state.isValid) return false;
    }
    return true;
  }

  /// Whether any field has been modified from initial value.
  bool get isDirty {
    for (final state in _fields.values) {
      if (state.isDirty) return true;
    }
    return false;
  }

  /// Whether any field is currently validating.
  bool get isValidating {
    for (final state in _fields.values) {
      if (state.isValidating) return true;
    }
    return false;
  }

  /// All field values as a map.
  Map<String, dynamic> get values {
    return _fields.map((key, state) => MapEntry(key, state.value));
  }

  /// All field errors as a map (only includes fields with errors).
  Map<String, String> get errors {
    final result = <String, String>{};
    for (final entry in _fields.entries) {
      if (entry.value.hasError) {
        result[entry.key] = entry.value.error!;
      }
    }
    return result;
  }

  /// All registered field names.
  List<String> get fieldNames => _fields.keys.toList();

  // ---- Array Field Access ----

  /// Gets the value of an array field item.
  ///
  /// [arrayName] is the base array name (e.g., 'addresses').
  /// [index] is the item index (0-indexed).
  /// [fieldName] is the field within the item (e.g., 'street').
  ///
  /// Equivalent to `getValue('addresses[0].street')`.
  ///
  /// **Example:**
  /// ```dart
  /// final street = controller.getArrayValue<String>('addresses', 0, 'street');
  /// ```
  T? getArrayValue<T>(String arrayName, int index, String fieldName) {
    return getValue<T>('$arrayName[$index].$fieldName');
  }

  /// Sets the value of an array field item.
  ///
  /// [arrayName] is the base array name (e.g., 'addresses').
  /// [index] is the item index (0-indexed).
  /// [fieldName] is the field within the item (e.g., 'street').
  /// [value] is the new value.
  /// [validate] whether to run validation after setting (default: true).
  ///
  /// Equivalent to `setValue('addresses[0].street', value)`.
  ///
  /// **Example:**
  /// ```dart
  /// controller.setArrayValue('addresses', 0, 'street', '123 Main St');
  /// ```
  void setArrayValue(
    String arrayName,
    int index,
    String fieldName,
    dynamic value, {
    bool validate = true,
  }) {
    setValue('$arrayName[$index].$fieldName', value, validate: validate);
  }

  /// Gets all values for an array as a list of maps.
  ///
  /// Collects all fields matching the pattern `{arrayName}[{index}].{fieldName}`
  /// and groups them by index into a list of maps.
  ///
  /// **Example:**
  /// ```dart
  /// final addresses = controller.getArrayValues('addresses');
  /// // Returns: [
  /// //   {'street': '123 Main', 'city': 'NYC'},
  /// //   {'street': '456 Oak', 'city': 'LA'},
  /// // ]
  /// ```
  List<Map<String, dynamic>> getArrayValues(String arrayName) {
    final result = <Map<String, dynamic>>[];

    // Find all fields starting with arrayName[
    final prefix = '$arrayName[';
    final matchingFields =
        _fields.keys.where((k) => k.startsWith(prefix)).toList();

    if (matchingFields.isEmpty) return result;

    // Extract indices and group by index
    final indexedValues = <int, Map<String, dynamic>>{};
    final pattern = RegExp(r'\[(\d+)\]\.(.+)$');

    for (final fieldName in matchingFields) {
      // Parse: arrayName[index].fieldName
      final match = pattern.firstMatch(fieldName);
      if (match != null) {
        final index = int.parse(match.group(1)!);
        final field = match.group(2)!;

        indexedValues.putIfAbsent(index, () => {});
        indexedValues[index]![field] = _fields[fieldName]?.value;
      }
    }

    // Convert to ordered list
    final sortedIndices = indexedValues.keys.toList()..sort();
    for (final index in sortedIndices) {
      result.add(indexedValues[index]!);
    }

    return result;
  }

  /// Removes all fields for an array item and shifts subsequent items.
  ///
  /// When removing item at [index]:
  /// 1. Removes all fields matching `{arrayName}[{index}].*`
  /// 2. Shifts all fields with higher indices down by 1
  ///
  /// **Example:**
  /// ```dart
  /// // Before: addresses[0], addresses[1], addresses[2]
  /// controller.removeArrayItem('addresses', 1);
  /// // After: addresses[0], addresses[1] (was addresses[2])
  /// ```
  void removeArrayItem(String arrayName, int index) {
    final prefix = '$arrayName[$index].';
    final toRemove = _fields.keys.where((k) => k.startsWith(prefix)).toList();

    for (final fieldName in toRemove) {
      unregisterField(fieldName);
    }

    // Shift subsequent items down
    int currentIndex = index + 1;
    while (true) {
      final currentPrefix = '$arrayName[$currentIndex].';
      final nextFields =
          _fields.keys.where((k) => k.startsWith(currentPrefix)).toList();

      if (nextFields.isEmpty) break;

      for (final oldName in nextFields) {
        final fieldPart = oldName.substring(currentPrefix.length);
        final newName = '$arrayName[${currentIndex - 1}].$fieldPart';
        final state = _fields[oldName]!;

        _fields[newName] = state;
        _fields.remove(oldName);

        // Move validators
        if (_validators.containsKey(oldName)) {
          _validators[newName] = _validators[oldName]!;
          _validators.remove(oldName);
        }

        // Move initial values
        if (_initialValues.containsKey(oldName)) {
          _initialValues[newName] = _initialValues[oldName];
          _initialValues.remove(oldName);
        }
      }

      currentIndex++;
    }

    notifyListeners();
  }

  /// Gets the current count of items in an array.
  ///
  /// Counts unique indices found in fields matching `{arrayName}[*].*`.
  ///
  /// **Example:**
  /// ```dart
  /// final count = controller.getArrayLength('addresses');
  /// // Returns: 3 (if there are addresses[0], addresses[1], addresses[2])
  /// ```
  int getArrayLength(String arrayName) {
    final prefix = '$arrayName[';
    final indices = <int>{};
    final pattern = RegExp(r'\[(\d+)\]');

    for (final fieldName in _fields.keys) {
      if (fieldName.startsWith(prefix)) {
        final match = pattern.firstMatch(fieldName);
        if (match != null) {
          indices.add(int.parse(match.group(1)!));
        }
      }
    }

    return indices.length;
  }

  // ---- Field Access ----

  /// Gets the current value of a field.
  ///
  /// Returns null if the field is not registered.
  T? getValue<T>(String name) {
    final state = _fields[name];
    if (state == null) return null;
    return state.value as T?;
  }

  /// Sets the value of a field.
  ///
  /// [name] is the field name.
  /// [value] is the new value.
  /// [validate] whether to run validation after setting (default: true).
  void setValue(String name, dynamic value, {bool validate = true}) {
    final currentState = _fields[name];
    if (currentState == null) {
      // Auto-register the field if not registered
      registerField(name, initialValue: value);
      return;
    }

    // Check if value changed from initial
    final initialValue = _initialValues[name];
    final isDirty = value != initialValue;

    _fields[name] = currentState.copyWith(
      value: value,
      isDirty: isDirty,
      clearError: true,
    );

    if (validate) {
      _validateFieldInternal(name);
    }

    _checkValidityChanged();
    notifyListeners();
  }

  /// Gets the validation error for a field.
  ///
  /// Returns null if the field has no error or is not registered.
  String? getError(String name) {
    return _fields[name]?.error;
  }

  /// Gets the complete state of a field.
  ///
  /// Returns an empty state if the field is not registered.
  FieldState<dynamic> getFieldState(String name) {
    return _fields[name] ?? FieldState<dynamic>.initial(null);
  }

  // ---- Field Registration ----

  /// Registers a field with the form.
  ///
  /// [name] is the unique field name.
  /// [initialValue] is the initial value (optional).
  /// [validators] is the list of validators for this field (optional).
  void registerField(
    String name, {
    dynamic initialValue,
    List<Validator<dynamic>>? validators,
  }) {
    if (_fields.containsKey(name)) return;

    _fields[name] = FieldState<dynamic>.initial(initialValue);
    _initialValues[name] = initialValue;

    if (validators != null && validators.isNotEmpty) {
      _validators[name] = validators;
    }

    notifyListeners();
  }

  /// Unregisters a field from the form.
  ///
  /// Removes the field state, validators, and initial value.
  void unregisterField(String name) {
    _fields.remove(name);
    _validators.remove(name);
    _initialValues.remove(name);
    _debounceTimers[name]?.cancel();
    _debounceTimers.remove(name);
    notifyListeners();
  }

  // ---- Validation ----

  /// Validates all fields and returns whether the form is valid.
  ///
  /// Runs both sync and async validators.
  /// Updates form status during validation.
  Future<bool> validate() async {
    _status = FormStatus.validating;
    notifyListeners();

    // Mark all fields as touched
    markAllTouched();

    // Run validation on all fields
    final futures = <Future<void>>[];
    for (final name in _fields.keys) {
      futures.add(_validateFieldAsync(name));
    }

    await Future.wait(futures);

    _status = isValid ? FormStatus.idle : FormStatus.error;
    _checkValidityChanged();
    notifyListeners();

    return isValid;
  }

  /// Validates a single field and returns whether it is valid.
  ///
  /// Runs both sync and async validators for the field.
  Future<bool> validateField(String name) async {
    await _validateFieldAsync(name);
    _checkValidityChanged();
    notifyListeners();
    return _fields[name]?.isValid ?? true;
  }

  /// Clears all validation errors.
  void clearErrors() {
    for (final name in _fields.keys) {
      final state = _fields[name]!;
      _fields[name] = state.copyWith(clearError: true);
    }
    if (_status == FormStatus.error) {
      _status = FormStatus.idle;
    }
    notifyListeners();
  }

  // ---- Touch Tracking ----

  /// Marks a field as touched.
  ///
  /// Typically called when a field loses focus.
  void markTouched(String name) {
    final state = _fields[name];
    if (state == null || state.isTouched) return;

    _fields[name] = state.copyWith(isTouched: true);
    notifyListeners();
  }

  /// Marks all fields as touched.
  ///
  /// Useful before submission to show all errors.
  void markAllTouched() {
    for (final name in _fields.keys) {
      final state = _fields[name]!;
      if (!state.isTouched) {
        _fields[name] = state.copyWith(isTouched: true);
      }
    }
    notifyListeners();
  }

  // ---- Form Actions ----

  /// Resets all fields to their initial values.
  ///
  /// Clears touched, dirty, and error states.
  void reset() {
    for (final name in _fields.keys) {
      final initialValue = _initialValues[name];
      _fields[name] = FieldState<dynamic>.initial(initialValue);
    }
    _status = FormStatus.idle;
    _checkValidityChanged();
    notifyListeners();
  }

  /// Clears all field values to null/empty.
  ///
  /// Does not change initial values (reset will still restore original values).
  void clear() {
    for (final name in _fields.keys) {
      _fields[name] = FieldState<dynamic>.initial(null);
    }
    _status = FormStatus.idle;
    _checkValidityChanged();
    notifyListeners();
  }

  /// Submits the form with the provided callback.
  ///
  /// [onSubmit] is called with all field values if validation passes.
  /// Updates form status to [FormStatus.submitting] during submission.
  /// Sets [FormStatus.submitted] on success, [FormStatus.error] on failure.
  ///
  /// **Example:**
  /// ```dart
  /// await controller.submit((values) async {
  ///   await api.createUser(values);
  /// });
  /// ```
  Future<void> submit(
    Future<void> Function(Map<String, dynamic> values) onSubmit,
  ) async {
    // Validate first
    final isFormValid = await validate();
    if (!isFormValid) {
      _status = FormStatus.error;
      notifyListeners();
      return;
    }

    // Submit
    _status = FormStatus.submitting;
    notifyListeners();

    try {
      await onSubmit(values);
      _status = FormStatus.submitted;
    } catch (e) {
      _status = FormStatus.error;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // ---- Private Methods ----

  /// Validates a field synchronously (internal).
  void _validateFieldInternal(String name) {
    final validators = _validators[name];
    if (validators == null || validators.isEmpty) return;

    final state = _fields[name];
    if (state == null) return;

    final value = state.value;

    // Run sync validators
    for (final validator in validators) {
      if (validator is AsyncValidator) continue;

      final error = validator.validate(value);
      if (error != null) {
        _fields[name] = state.copyWith(error: error);
        return;
      }
    }

    // Clear error if all sync validators pass
    _fields[name] = state.copyWith(clearError: true);

    // Check for async validators
    final hasAsync = validators.any((v) => v is AsyncValidator);
    if (hasAsync) {
      _scheduleAsyncValidation(name);
    }
  }

  /// Validates a field with both sync and async validators.
  Future<void> _validateFieldAsync(String name) async {
    final validators = _validators[name];
    if (validators == null || validators.isEmpty) return;

    final state = _fields[name];
    if (state == null) return;

    final value = state.value;

    // Run sync validators first
    for (final validator in validators) {
      if (validator is AsyncValidator) continue;

      final error = validator.validate(value);
      if (error != null) {
        _fields[name] = state.copyWith(error: error);
        notifyListeners();
        return;
      }
    }

    // Clear error and run async validators
    _fields[name] = state.copyWith(clearError: true);

    // Run async validators
    for (final validator in validators) {
      if (validator is! AsyncValidator) continue;

      _fields[name] = _fields[name]!.copyWith(isValidating: true);
      notifyListeners();

      try {
        final error = await validator.validateAsync(value);
        if (error != null) {
          _fields[name] = _fields[name]!.copyWith(
            error: error,
            isValidating: false,
          );
          notifyListeners();
          return;
        }
      } finally {
        _fields[name] = _fields[name]!.copyWith(isValidating: false);
      }
    }
  }

  /// Schedules async validation with debouncing.
  void _scheduleAsyncValidation(String name) {
    _debounceTimers[name]?.cancel();

    final validators = _validators[name];
    if (validators == null) return;

    final asyncValidator =
        validators.whereType<AsyncValidator<dynamic>>().firstOrNull;
    if (asyncValidator == null) return;

    // Mark as validating
    final state = _fields[name];
    if (state != null) {
      _fields[name] = state.copyWith(isValidating: true);
      notifyListeners();
    }

    _debounceTimers[name] = Timer(asyncValidator.debounce, () async {
      await _runAsyncValidators(name);
    });
  }

  /// Runs async validators for a field.
  Future<void> _runAsyncValidators(String name) async {
    final validators = _validators[name];
    if (validators == null) return;

    final state = _fields[name];
    if (state == null) return;

    final value = state.value;

    for (final validator in validators) {
      if (validator is! AsyncValidator) continue;

      try {
        final error = await validator.validateAsync(value);
        if (error != null) {
          _fields[name] = _fields[name]!.copyWith(
            error: error,
            isValidating: false,
          );
          _checkValidityChanged();
          notifyListeners();
          return;
        }
      } catch (_) {
        _fields[name] = _fields[name]!.copyWith(isValidating: false);
        notifyListeners();
        rethrow;
      }
    }

    _fields[name] = _fields[name]!.copyWith(isValidating: false);
    _checkValidityChanged();
    notifyListeners();
  }

  /// Checks if overall validity changed and calls callback.
  void _checkValidityChanged() {
    final currentIsValid = isValid;
    if (currentIsValid != _previousIsValid) {
      _previousIsValid = currentIsValid;
      onValidationChanged?.call(currentIsValid);
    }
  }

  @override
  void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    super.dispose();
  }
}
