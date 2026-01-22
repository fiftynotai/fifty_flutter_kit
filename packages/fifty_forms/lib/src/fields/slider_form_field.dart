import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A slider control integrated with [FiftyFormController].
///
/// Wraps [FiftySlider] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization (double)
/// - Error display from validation
/// - Touch tracking on drag end
///
/// **Example:**
/// ```dart
/// FiftySliderFormField(
///   name: 'volume',
///   controller: formController,
///   min: 0,
///   max: 100,
///   label: 'Volume',
///   showLabel: true,
/// )
/// ```
///
/// **Example with divisions:**
/// ```dart
/// FiftySliderFormField(
///   name: 'rating',
///   controller: formController,
///   min: 1,
///   max: 5,
///   divisions: 4,
///   label: 'Rating',
///   showLabel: true,
///   validators: [
///     Custom<double>((value) {
///       if (value == null || value < 1) return 'Please rate';
///       return null;
///     }),
///   ],
/// )
/// ```
class FiftySliderFormField extends StatefulWidget {
  /// Creates a form-integrated slider field.
  const FiftySliderFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showLabel = false,
    this.labelBuilder,
    this.enabled = true,
    this.initialValue,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// Optional label shown above the slider.
  final String? label;

  /// Whether to show the value label above the thumb.
  final bool showLabel;

  /// Custom label builder for the value display.
  final String Function(double value)? labelBuilder;

  /// Whether the slider is enabled.
  final bool enabled;

  /// Initial value for the field.
  final double? initialValue;

  @override
  State<FiftySliderFormField> createState() => _FiftySliderFormFieldState();
}

class _FiftySliderFormFieldState extends State<FiftySliderFormField>
    with FormFieldMixin<FiftySliderFormField> {
  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue ?? widget.min;

  void _handleChanged(double value) {
    onFieldChanged(value);
    // Don't mark touched on every change, only when drag ends
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final value = controller?.getValue<double>(fieldName) ?? widget.min;
        final errorText = shouldShowError ? fieldError : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onHorizontalDragEnd: (_) => onFieldBlur(),
              child: FiftySlider(
                value: value.clamp(widget.min, widget.max),
                onChanged: widget.enabled ? _handleChanged : null,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                label: widget.label,
                showLabel: widget.showLabel,
                labelBuilder: widget.labelBuilder,
                enabled: widget.enabled,
              ),
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
