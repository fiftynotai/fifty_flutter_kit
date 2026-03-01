import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A toggle switch integrated with [FiftyFormController].
///
/// Wraps [FiftySwitch] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization (boolean)
/// - Error display from validation
/// - Touch tracking on toggle
///
/// **Example:**
/// ```dart
/// FiftySwitchFormField(
///   name: 'notifications',
///   controller: formController,
///   label: 'Enable notifications',
/// )
/// ```
///
/// **Example with size variant:**
/// ```dart
/// FiftySwitchFormField(
///   name: 'darkMode',
///   controller: formController,
///   label: 'Dark mode',
///   size: FiftySwitchSize.small,
/// )
/// ```
class FiftySwitchFormField extends StatefulWidget {
  /// Creates a form-integrated switch field.
  const FiftySwitchFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.label,
    this.enabled = true,
    this.size = FiftySwitchSize.medium,
    this.initialValue = false,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Optional label displayed next to the switch.
  final String? label;

  /// Whether the switch is enabled.
  final bool enabled;

  /// Size variant of the switch.
  final FiftySwitchSize size;

  /// Initial value for the field.
  final bool initialValue;

  @override
  State<FiftySwitchFormField> createState() => _FiftySwitchFormFieldState();
}

class _FiftySwitchFormFieldState extends State<FiftySwitchFormField>
    with FormFieldMixin<FiftySwitchFormField> {
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
            FiftySwitch(
              value: value,
              onChanged: widget.enabled ? _handleChanged : null,
              label: widget.label,
              enabled: widget.enabled,
              size: widget.size,
            ),
            if (errorText != null) ...[
              SizedBox(height: FiftySpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 60), // Align with label
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
