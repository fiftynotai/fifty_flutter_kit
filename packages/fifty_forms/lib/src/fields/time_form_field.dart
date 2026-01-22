import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A time picker field integrated with [FiftyFormController].
///
/// Displays the selected time in a read-only [FiftyTextField] and shows
/// a time picker dialog on tap. Uses FDL styling for the picker.
///
/// **Example:**
/// ```dart
/// FiftyTimeFormField(
///   name: 'startTime',
///   controller: formController,
///   label: 'Start Time',
///   hint: 'Select start time',
/// )
/// ```
///
/// **Example with 24-hour format:**
/// ```dart
/// FiftyTimeFormField(
///   name: 'meetingTime',
///   controller: formController,
///   label: 'Meeting Time',
///   use24HourFormat: true,
///   validators: [Required()],
/// )
/// ```
class FiftyTimeFormField extends StatefulWidget {
  /// Creates a form-integrated time picker field.
  const FiftyTimeFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.label,
    this.hint,
    this.enabled = true,
    this.initialValue,
    this.use24HourFormat = false,
    this.timeFormat,
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

  /// Hint text displayed when no time is selected.
  final String? hint;

  /// Whether the field is enabled.
  final bool enabled;

  /// Initial value for the field.
  final TimeOfDay? initialValue;

  /// Whether to use 24-hour format.
  final bool use24HourFormat;

  /// Custom time format function.
  ///
  /// If null, uses standard format based on [use24HourFormat].
  final String Function(TimeOfDay time)? timeFormat;

  /// Widget displayed before the input (e.g., an icon).
  final Widget? prefix;

  /// Widget displayed after the input (e.g., a clock icon).
  ///
  /// If null, displays a clock icon.
  final Widget? suffix;

  @override
  State<FiftyTimeFormField> createState() => _FiftyTimeFormFieldState();
}

class _FiftyTimeFormFieldState extends State<FiftyTimeFormField>
    with FormFieldMixin<FiftyTimeFormField> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue;

  String _formatTime(TimeOfDay time) {
    if (widget.timeFormat != null) {
      return widget.timeFormat!(time);
    }

    if (widget.use24HourFormat) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }
  }

  Future<void> _showTimePicker() async {
    if (!widget.enabled) return;

    final currentValue = controller?.getValue<TimeOfDay>(fieldName);
    final now = TimeOfDay.now();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentValue ?? now,
      builder: (context, child) {
        // Apply FDL styling to the time picker
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: FiftyColors.primary,
              onPrimary: Colors.white,
              surface:
                  isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
              onSurface: isDark ? Colors.white : FiftyColors.darkBurgundy,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor:
                  isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FiftyColors.primary,
                textStyle: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontWeight: FiftyTypography.medium,
                ),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor:
                  isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
              hourMinuteTextColor:
                  isDark ? Colors.white : FiftyColors.darkBurgundy,
              dialHandColor: FiftyColors.primary,
              dialBackgroundColor: isDark
                  ? FiftyColors.slateGrey.withValues(alpha: 0.2)
                  : FiftyColors.borderLight,
              entryModeIconColor: FiftyColors.slateGrey,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: widget.use24HourFormat,
            ),
            child: child!,
          ),
        );
      },
    );

    if (selectedTime != null) {
      onFieldChanged(selectedTime);
      onFieldBlur();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final value = controller?.getValue<TimeOfDay>(fieldName);
        final errorText = shouldShowError ? fieldError : null;
        final displayText = value != null ? _formatTime(value) : '';

        return GestureDetector(
          onTap: widget.enabled ? _showTimePicker : null,
          child: AbsorbPointer(
            child: FiftyTextField(
              controller: TextEditingController(text: displayText),
              label: widget.label,
              hint: widget.hint ?? 'Select time',
              errorText: errorText,
              enabled: widget.enabled,
              prefix: widget.prefix,
              suffix: widget.suffix ??
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? FiftyColors.slateGrey
                        : Colors.grey[600],
                  ),
            ),
          ),
        );
      },
    );
  }
}
