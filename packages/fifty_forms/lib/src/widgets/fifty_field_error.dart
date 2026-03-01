import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';

/// Animated error message for a single field.
///
/// Shows/hides with animation based on field error state.
/// Only displays error when the field has been touched (to avoid showing
/// errors before user interaction).
///
/// **Example:**
/// ```dart
/// FiftyFieldError(
///   controller: controller,
///   fieldName: 'email',
/// )
/// ```
///
/// **With custom duration:**
/// ```dart
/// FiftyFieldError(
///   controller: controller,
///   fieldName: 'password',
///   animationDuration: Duration(milliseconds: 300),
/// )
/// ```
class FiftyFieldError extends StatelessWidget {
  /// The form controller containing the field state.
  final FiftyFormController controller;

  /// The name of the field to monitor for errors.
  final String fieldName;

  /// Duration of the show/hide animation.
  ///
  /// Defaults to 200 milliseconds.
  final Duration animationDuration;

  /// Creates a field error display widget.
  const FiftyFieldError({
    super.key,
    required this.controller,
    required this.fieldName,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final fieldState = controller.getFieldState(fieldName);
        final error = fieldState.error;
        final isTouched = fieldState.isTouched;

        // Only show error if field has been touched and has an error
        final showError = isTouched && error != null;

        return AnimatedSize(
          duration: animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: showError ? 1.0 : 0.0,
            child: showError
                ? Padding(
                    padding: EdgeInsets.only(top: FiftySpacing.xs),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.error,
                          size: FiftyTypography.bodySmall,
                        ),
                        SizedBox(width: FiftySpacing.xs),
                        Flexible(
                          child: Text(
                            error,
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.regular,
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
