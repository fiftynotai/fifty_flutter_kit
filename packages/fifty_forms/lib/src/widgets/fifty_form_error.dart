import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../core/form_status.dart';

/// Displays form-level error message.
///
/// Shows when form status is [FormStatus.error] and a message is provided.
/// Useful for displaying submission errors or form-wide validation errors.
///
/// **Example:**
/// ```dart
/// FiftyFormError(
///   controller: controller,
///   message: 'Please fix the errors above',
/// )
/// ```
///
/// **With custom message based on status:**
/// ```dart
/// FiftyFormError(
///   controller: controller,
///   message: controller.status == FormStatus.error
///       ? 'Submission failed. Please try again.'
///       : null,
/// )
/// ```
class FiftyFormError extends StatelessWidget {
  /// The form controller to monitor.
  final FiftyFormController controller;

  /// The error message to display.
  ///
  /// If null, the widget displays nothing even when the form has errors.
  final String? message;

  /// Optional icon to display before the message.
  ///
  /// Defaults to [Icons.error_outline].
  final IconData? icon;

  /// Animation duration for show/hide transition.
  ///
  /// Defaults to 200 milliseconds.
  final Duration animationDuration;

  /// Creates a form error display widget.
  const FiftyFormError({
    super.key,
    required this.controller,
    this.message,
    this.icon,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final showError =
            controller.status == FormStatus.error && message != null;

        return AnimatedSize(
          duration: animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: showError ? 1.0 : 0.0,
            child: showError
                ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: FiftySpacing.md),
                    padding: const EdgeInsets.all(FiftySpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: FiftyRadii.lgRadius,
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon ?? Icons.error_outline,
                          color: colorScheme.error,
                          size: FiftyTypography.titleSmall,
                        ),
                        const SizedBox(width: FiftySpacing.sm),
                        Expanded(
                          child: Text(
                            message!,
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodyMedium,
                              fontWeight: FiftyTypography.medium,
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
