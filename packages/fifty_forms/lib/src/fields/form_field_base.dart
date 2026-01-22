import 'package:flutter/widgets.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';

/// Mixin for form field widgets that provides controller integration.
///
/// This mixin handles automatic field registration with [FiftyFormController]
/// and provides helper methods for value changes and blur events.
///
/// **Example:**
/// ```dart
/// class _MyFormFieldState extends State<MyFormField>
///     with FormFieldMixin<MyFormField> {
///   @override
///   FiftyFormController? get controller => widget.controller;
///
///   @override
///   String get fieldName => widget.name;
///
///   @override
///   List<Validator<dynamic>>? get validators => widget.validators;
///
///   @override
///   Widget build(BuildContext context) {
///     return TextField(
///       onChanged: (value) => onFieldChanged(value),
///       onEditingComplete: () => onFieldBlur(),
///     );
///   }
/// }
/// ```
mixin FormFieldMixin<T extends StatefulWidget> on State<T> {
  /// The form controller this field is registered with.
  ///
  /// If null, the field operates in standalone mode without
  /// automatic validation or state tracking.
  FiftyFormController? get controller;

  /// The unique name for this field in the form.
  ///
  /// This name is used to register the field with the controller
  /// and to get/set field values and errors.
  String get fieldName;

  /// Optional validators for this field.
  ///
  /// These validators are registered with the controller when
  /// the field is initialized.
  List<Validator<dynamic>>? get validators;

  /// Initial value for the field when registering.
  ///
  /// Override this to provide a default initial value for the field.
  dynamic get initialValue => null;

  @override
  void initState() {
    super.initState();
    _registerField();
  }

  /// Registers this field with the form controller.
  void _registerField() {
    if (controller != null && fieldName.isNotEmpty) {
      controller!.registerField(
        fieldName,
        initialValue: initialValue,
        validators: validators,
      );
    }
  }

  @override
  void dispose() {
    // Note: Don't unregister - field might be temporarily removed from tree
    // The controller will handle cleanup when disposed
    super.dispose();
  }

  /// Call this when the field value changes.
  ///
  /// Updates the controller value and triggers validation.
  /// If no controller is present, this is a no-op.
  void onFieldChanged(dynamic value) {
    controller?.setValue(fieldName, value);
  }

  /// Call this when the field loses focus.
  ///
  /// Marks the field as touched in the controller, which enables
  /// error display. If no controller is present, this is a no-op.
  void onFieldBlur() {
    controller?.markTouched(fieldName);
  }

  /// Gets the current error message for this field.
  ///
  /// Returns null if there is no error or no controller.
  String? get fieldError => controller?.getError(fieldName);

  /// Gets the current value of this field from the controller.
  ///
  /// Returns null if no controller is present.
  V? getFieldValue<V>() => controller?.getValue<V>(fieldName);

  /// Whether this field should show its error.
  ///
  /// Returns true if the field is touched and has an error,
  /// or if the form has been submitted with errors.
  bool get shouldShowError {
    if (controller == null) return false;
    final state = controller!.getFieldState(fieldName);
    return state.isTouched && state.hasError;
  }
}
