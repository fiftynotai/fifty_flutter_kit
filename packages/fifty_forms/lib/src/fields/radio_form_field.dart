import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A radio button control integrated with [FiftyFormController].
///
/// Wraps [FiftyRadio] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization (generic type)
/// - Error display from validation
/// - Touch tracking on selection
///
/// Note: Multiple [FiftyRadioFormField] widgets with the same [name]
/// share the same form field value (like a radio group).
///
/// **Example:**
/// ```dart
/// Column(
///   children: [
///     FiftyRadioFormField<String>(
///       name: 'paymentMethod',
///       value: 'card',
///       controller: formController,
///       validators: [Required()],
///       label: 'Credit Card',
///     ),
///     FiftyRadioFormField<String>(
///       name: 'paymentMethod',
///       value: 'cash',
///       controller: formController,
///       label: 'Cash',
///     ),
///     FiftyRadioFormField<String>(
///       name: 'paymentMethod',
///       value: 'transfer',
///       controller: formController,
///       label: 'Bank Transfer',
///     ),
///   ],
/// )
/// ```
///
/// **Example with enum:**
/// ```dart
/// enum Size { small, medium, large }
///
/// Column(
///   children: [
///     FiftyRadioFormField<Size>(
///       name: 'size',
///       value: Size.small,
///       controller: formController,
///       label: 'Small',
///     ),
///     FiftyRadioFormField<Size>(
///       name: 'size',
///       value: Size.medium,
///       controller: formController,
///       label: 'Medium',
///     ),
///     FiftyRadioFormField<Size>(
///       name: 'size',
///       value: Size.large,
///       controller: formController,
///       label: 'Large',
///     ),
///   ],
/// )
/// ```
class FiftyRadioFormField<T> extends StatefulWidget {
  /// Creates a form-integrated radio button field.
  const FiftyRadioFormField({
    super.key,
    required this.name,
    required this.value,
    required this.controller,
    this.validators,
    this.label,
    this.enabled = true,
  });

  /// Unique field name for form registration.
  ///
  /// All radio buttons in the same group should share the same name.
  final String name;

  /// The value represented by this radio button.
  final T value;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  ///
  /// Only provide validators on the first radio in the group.
  final List<Validator<dynamic>>? validators;

  /// Optional label displayed next to the radio button.
  final String? label;

  /// Whether the radio button is enabled.
  final bool enabled;

  @override
  State<FiftyRadioFormField<T>> createState() => _FiftyRadioFormFieldState<T>();
}

class _FiftyRadioFormFieldState<T> extends State<FiftyRadioFormField<T>>
    with FormFieldMixin<FiftyRadioFormField<T>> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  void _handleChanged(T? value) {
    if (value != null) {
      onFieldChanged(value);
      onFieldBlur(); // Mark touched on selection
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final groupValue = controller?.getValue<T>(fieldName);
        final errorText = shouldShowError ? fieldError : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyRadio<T>(
              value: widget.value,
              groupValue: groupValue,
              onChanged: widget.enabled ? _handleChanged : null,
              label: widget.label,
              enabled: widget.enabled,
            ),
            if (errorText != null) ...[
              SizedBox(height: FiftySpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 32), // Align with label
                child: Text(
                  errorText,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FiftyTypography.regular,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
