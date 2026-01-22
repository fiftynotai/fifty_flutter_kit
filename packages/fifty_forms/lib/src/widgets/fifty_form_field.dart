import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import 'fifty_field_error.dart';

/// Wraps any widget with a label and error display.
///
/// This widget provides a consistent layout for form fields:
/// - Label text above the field (optional)
/// - The field widget itself
/// - Animated error message below (when errors exist)
///
/// **Example:**
/// ```dart
/// FiftyFormField(
///   name: 'bio',
///   label: 'Biography',
///   controller: controller,
///   child: TextField(
///     onChanged: (value) => controller.setValue('bio', value),
///   ),
/// )
/// ```
class FiftyFormField extends StatelessWidget {
  /// The field name used to identify this field in the form controller.
  final String name;

  /// Optional label displayed above the field.
  final String? label;

  /// The form controller managing this field's state.
  final FiftyFormController controller;

  /// The form field widget (TextField, Dropdown, etc.).
  final Widget child;

  /// Whether to show the error message below the field.
  ///
  /// Defaults to true. Set to false if you want to handle error display
  /// separately or use [FiftyValidationSummary] instead.
  final bool showError;

  /// Creates a form field wrapper.
  const FiftyFormField({
    super.key,
    required this.name,
    this.label,
    required this.controller,
    required this.child,
    this.showError = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            if (label != null) ...[
              Text(
                label!.toUpperCase(),
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelMedium,
                  fontWeight: FiftyTypography.bold,
                  letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
            ],
            // Field
            child,
            // Error
            if (showError)
              FiftyFieldError(
                controller: controller,
                fieldName: name,
              ),
          ],
        );
      },
    );
  }
}
