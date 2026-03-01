import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A checkbox control integrated with [FiftyFormController].
///
/// Wraps [FiftyCheckbox] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization (boolean)
/// - Error display from validation
/// - Touch tracking on toggle
///
/// **Example:**
/// ```dart
/// FiftyCheckboxFormField(
///   name: 'acceptTerms',
///   controller: formController,
///   validators: [
///     Custom<bool>(
///       (value) => value == true ? null : 'You must accept the terms',
///     ),
///   ],
///   label: 'I accept the terms and conditions',
/// )
/// ```
///
/// **Example without validation:**
/// ```dart
/// FiftyCheckboxFormField(
///   name: 'newsletter',
///   controller: formController,
///   label: 'Subscribe to newsletter',
/// )
/// ```
class FiftyCheckboxFormField extends StatefulWidget {
  /// Creates a form-integrated checkbox field.
  const FiftyCheckboxFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.label,
    this.enabled = true,
    this.initialValue = false,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Optional label displayed next to the checkbox.
  final String? label;

  /// Whether the checkbox is enabled.
  final bool enabled;

  /// Initial value for the field.
  final bool initialValue;

  @override
  State<FiftyCheckboxFormField> createState() => _FiftyCheckboxFormFieldState();
}

class _FiftyCheckboxFormFieldState extends State<FiftyCheckboxFormField>
    with FormFieldMixin<FiftyCheckboxFormField> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue;

  void _handleChanged(bool value) {
    onFieldChanged(value);
    onFieldBlur(); // Mark touched on toggle
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final value = controller?.getValue<bool>(fieldName) ?? false;
        final errorText = shouldShowError ? fieldError : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyCheckbox(
              value: value,
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
