import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A date picker field integrated with [FiftyFormController].
///
/// Displays the selected date in a read-only [FiftyTextField] and shows
/// a date picker dialog on tap. Uses FDL styling for the picker.
///
/// **Example:**
/// ```dart
/// FiftyDateFormField(
///   name: 'birthDate',
///   controller: formController,
///   validators: [Required()],
///   label: 'Birth Date',
///   hint: 'Select your birth date',
/// )
/// ```
///
/// **Example with date constraints:**
/// ```dart
/// FiftyDateFormField(
///   name: 'appointmentDate',
///   controller: formController,
///   label: 'Appointment Date',
///   firstDate: DateTime.now(),
///   lastDate: DateTime.now().add(Duration(days: 90)),
///   validators: [
///     DateAfter(DateTime.now(), message: 'Must be a future date'),
///   ],
/// )
/// ```
class FiftyDateFormField extends StatefulWidget {
  /// Creates a form-integrated date picker field.
  const FiftyDateFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.label,
    this.hint,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.initialValue,
    this.dateFormat,
    this.prefix,
    this.suffix,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when no date is selected.
  final String? hint;

  /// Whether the field is enabled.
  final bool enabled;

  /// The earliest allowable date.
  ///
  /// Defaults to 100 years ago.
  final DateTime? firstDate;

  /// The latest allowable date.
  ///
  /// Defaults to 100 years from now.
  final DateTime? lastDate;

  /// Initial value for the field.
  final DateTime? initialValue;

  /// Custom date format function.
  ///
  /// If null, uses 'MMM dd, yyyy' format.
  final String Function(DateTime date)? dateFormat;

  /// Widget displayed before the input (e.g., an icon).
  final Widget? prefix;

  /// Widget displayed after the input (e.g., a calendar icon).
  ///
  /// If null, displays a calendar icon.
  final Widget? suffix;

  @override
  State<FiftyDateFormField> createState() => _FiftyDateFormFieldState();
}

class _FiftyDateFormFieldState extends State<FiftyDateFormField>
    with FormFieldMixin<FiftyDateFormField> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue;

  String _formatDate(DateTime date) {
    if (widget.dateFormat != null) {
      return widget.dateFormat!(date);
    }
    // Default format: Jan 15, 2024
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  Future<void> _showDatePicker() async {
    if (!widget.enabled) return;

    final currentValue = controller?.getValue<DateTime>(fieldName);
    final now = DateTime.now();

    final firstDate =
        widget.firstDate ?? DateTime(now.year - 100, now.month, now.day);
    final lastDate =
        widget.lastDate ?? DateTime(now.year + 100, now.month, now.day);

    final theme = Theme.of(context);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentValue ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontWeight: FiftyTypography.medium,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      onFieldChanged(selectedDate);
      onFieldBlur();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final value = controller?.getValue<DateTime>(fieldName);
        final errorText = shouldShowError ? fieldError : null;
        final displayText = value != null ? _formatDate(value) : '';

        return GestureDetector(
          onTap: widget.enabled ? _showDatePicker : null,
          child: AbsorbPointer(
            child: FiftyTextField(
              controller: TextEditingController(text: displayText),
              label: widget.label,
              hint: widget.hint ?? 'Select date',
              errorText: errorText,
              enabled: widget.enabled,
              prefix: widget.prefix,
              suffix: widget.suffix ??
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        );
      },
    );
  }
}
