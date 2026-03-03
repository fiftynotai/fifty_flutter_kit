import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../core/form_status.dart';

/// Builder for a custom submit button.
///
/// Replaces the default [FiftyButton] while the widget retains ownership
/// of [ListenableBuilder] controller listening and state computation.
///
/// - [isLoading] whether the form is currently submitting.
/// - [isDisabled] whether the button should be inactive.
/// - [onPressed] the submit action (null when disabled).
/// - [label] the resolved label text (respects [loadingText] during submission).
typedef SubmitButtonBuilder = Widget Function(
  bool isLoading,
  bool isDisabled,
  VoidCallback? onPressed,
  String label,
);

/// Submit button that integrates with [FiftyFormController].
///
/// Features:
/// - Disables when form is invalid or submitting (when [disableWhenInvalid] is true)
/// - Shows loading indicator during submission
/// - Uses [FiftyButton] internally for FDL compliance
///
/// **Example:**
/// ```dart
/// FiftySubmitButton(
///   controller: controller,
///   onPressed: () => controller.submit((values) async {
///     await api.save(values);
///   }),
///   child: Text('SUBMIT'),
/// )
/// ```
///
/// **With loading text:**
/// ```dart
/// FiftySubmitButton(
///   controller: controller,
///   onPressed: _handleSubmit,
///   loadingText: 'SAVING',
///   child: Text('SAVE'),
/// )
/// ```
class FiftySubmitButton extends StatelessWidget {
  /// The form controller to integrate with.
  final FiftyFormController controller;

  /// Callback when the button is pressed.
  ///
  /// Typically triggers form submission via [FiftyFormController.submit].
  final VoidCallback onPressed;

  /// The button label.
  final String label;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Text to display during loading state.
  ///
  /// If not provided, shows "..." animation.
  final String? loadingText;

  /// Whether to disable the button when the form is invalid.
  ///
  /// Defaults to true. When true, the button is disabled if:
  /// - The form is currently invalid
  /// - The form is currently submitting
  /// - The form is currently validating
  final bool disableWhenInvalid;

  /// The button variant.
  ///
  /// Defaults to [FiftyButtonVariant.primary].
  final FiftyButtonVariant variant;

  /// The button size.
  ///
  /// Defaults to [FiftyButtonSize.medium].
  final FiftyButtonSize size;

  /// Whether the button expands to fill available width.
  ///
  /// Defaults to false.
  final bool expanded;

  /// Whether to apply glitch effect on hover.
  ///
  /// Defaults to false.
  final bool isGlitch;

  /// Optional builder to replace the default [FiftyButton].
  ///
  /// When null, the default [FiftyButton] is rendered with all configured
  /// properties. The [ListenableBuilder] wrapper and state computation
  /// are retained by the widget regardless of this builder.
  final SubmitButtonBuilder? buttonBuilder;

  /// Creates a form submit button.
  const FiftySubmitButton({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.label,
    this.icon,
    this.loadingText,
    this.disableWhenInvalid = true,
    this.variant = FiftyButtonVariant.primary,
    this.size = FiftyButtonSize.medium,
    this.expanded = false,
    this.isGlitch = false,
    this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final isLoading = controller.status == FormStatus.submitting;
        final isValidating = controller.status == FormStatus.validating;
        final isFormInvalid = !controller.isValid;

        // Determine if button should be disabled
        final bool isDisabled;
        if (disableWhenInvalid) {
          isDisabled = isLoading || isValidating || isFormInvalid;
        } else {
          isDisabled = isLoading || isValidating;
        }

        if (buttonBuilder != null) {
          final resolvedLabel = isLoading ? (loadingText ?? label) : label;
          return buttonBuilder!(
            isLoading,
            isDisabled,
            isDisabled ? null : onPressed,
            resolvedLabel,
          );
        }

        return FiftyButton(
          label: isLoading ? (loadingText ?? label) : label,
          icon: icon,
          onPressed: isDisabled ? null : onPressed,
          loading: isLoading,
          disabled: isDisabled,
          variant: variant,
          size: size,
          expanded: expanded,
          isGlitch: isGlitch,
        );
      },
    );
  }
}
