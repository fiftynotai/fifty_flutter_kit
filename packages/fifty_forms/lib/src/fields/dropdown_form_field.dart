import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A dropdown selector integrated with [FiftyFormController].
///
/// Wraps [FiftyDropdown] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization
/// - Error display from validation
/// - Touch tracking on selection
///
/// **Example:**
/// ```dart
/// FiftyDropdownFormField<String>(
///   name: 'country',
///   controller: formController,
///   validators: [Required()],
///   items: [
///     FiftyDropdownItem(value: 'us', label: 'United States'),
///     FiftyDropdownItem(value: 'uk', label: 'United Kingdom'),
///     FiftyDropdownItem(value: 'ca', label: 'Canada'),
///   ],
///   label: 'Country',
///   hint: 'Select your country',
/// )
/// ```
///
/// **Example with enum:**
/// ```dart
/// enum Priority { low, medium, high }
///
/// FiftyDropdownFormField<Priority>(
///   name: 'priority',
///   controller: formController,
///   items: [
///     FiftyDropdownItem(value: Priority.low, label: 'Low'),
///     FiftyDropdownItem(value: Priority.medium, label: 'Medium'),
///     FiftyDropdownItem(value: Priority.high, label: 'High'),
///   ],
///   label: 'Priority',
/// )
/// ```
class FiftyDropdownFormField<T> extends StatefulWidget {
  /// Creates a form-integrated dropdown field.
  const FiftyDropdownFormField({
    super.key,
    required this.name,
    required this.controller,
    required this.items,
    this.validators,
    this.label,
    this.hint,
    this.enabled = true,
    this.initialValue,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// List of selectable items.
  final List<FiftyDropdownItem<T>> items;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Label displayed above the dropdown.
  final String? label;

  /// Hint text when no value is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Initial value for the field.
  final T? initialValue;

  @override
  State<FiftyDropdownFormField<T>> createState() =>
      _FiftyDropdownFormFieldState<T>();
}

class _FiftyDropdownFormFieldState<T> extends State<FiftyDropdownFormField<T>>
    with FormFieldMixin<FiftyDropdownFormField<T>> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue;

  void _handleChanged(T? value) {
    onFieldChanged(value);
    onFieldBlur(); // Mark touched on selection
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final value = controller?.getValue<T>(fieldName);
        final errorText = shouldShowError ? fieldError : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyDropdown<T>(
              items: widget.items,
              value: value,
              onChanged: widget.enabled ? _handleChanged : null,
              label: widget.label,
              hint: widget.hint,
              enabled: widget.enabled,
            ),
            if (errorText != null) ...[
              const SizedBox(height: FiftySpacing.xs),
              Text(
                errorText,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.regular,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
