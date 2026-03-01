import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';

/// Displays a summary of all form validation errors.
///
/// Useful for showing all errors in one place, typically at the top or bottom
/// of a form. Each error can be tapped to scroll to the corresponding field.
///
/// **Example:**
/// ```dart
/// FiftyValidationSummary(
///   controller: controller,
///   onFieldTap: (name) => scrollToField(name),
/// )
/// ```
///
/// **With custom title:**
/// ```dart
/// FiftyValidationSummary(
///   controller: controller,
///   title: 'Please correct the following:',
///   onFieldTap: (name) {
///     // Scroll to field or focus it
///     _focusNodes[name]?.requestFocus();
///   },
/// )
/// ```
class FiftyValidationSummary extends StatelessWidget {
  /// The form controller containing field errors.
  final FiftyFormController controller;

  /// Callback when a field error is tapped.
  ///
  /// Receives the field name. Use this to scroll to or focus the field.
  final void Function(String fieldName)? onFieldTap;

  /// Title displayed above the error list.
  ///
  /// Defaults to 'Please fix the following errors:'.
  final String? title;

  /// Animation duration for show/hide transition.
  ///
  /// Defaults to 200 milliseconds.
  final Duration animationDuration;

  /// Creates a validation summary widget.
  const FiftyValidationSummary({
    super.key,
    required this.controller,
    this.onFieldTap,
    this.title,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final errors = controller.errors;
        final hasErrors = errors.isNotEmpty;

        return AnimatedSize(
          duration: animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: hasErrors ? 1.0 : 0.0,
            child: hasErrors
                ? FiftyCard(
                    scanlineOnHover: false,
                    backgroundColor:
                        colorScheme.error.withValues(alpha: 0.08),
                    padding: EdgeInsets.all(FiftySpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: colorScheme.error,
                              size: FiftyTypography.titleMedium,
                            ),
                            SizedBox(width: FiftySpacing.sm),
                            Expanded(
                              child: Text(
                                title ?? 'Please fix the following errors:',
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamily,
                                  fontSize: FiftyTypography.bodyMedium,
                                  fontWeight: FiftyTypography.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: FiftySpacing.md),
                        // Error list
                        ...errors.entries.map((entry) {
                          return _ErrorItem(
                            fieldName: entry.key,
                            errorMessage: entry.value,
                            onTap: onFieldTap != null
                                ? () => onFieldTap!(entry.key)
                                : null,
                          );
                        }),
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

/// Individual error item in the validation summary.
class _ErrorItem extends StatelessWidget {
  final String fieldName;
  final String errorMessage;
  final VoidCallback? onTap;

  const _ErrorItem({
    required this.fieldName,
    required this.errorMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              color: colorScheme.error,
              fontSize: FiftyTypography.bodyMedium,
            ),
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  fontWeight: FiftyTypography.regular,
                  color: colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: _formatFieldName(fieldName),
                    style: TextStyle(
                      fontWeight: FiftyTypography.medium,
                      color: colorScheme.error,
                    ),
                  ),
                  const TextSpan(text: ': '),
                  TextSpan(text: errorMessage),
                ],
              ),
            ),
          ),
          if (onTap != null) ...[
            SizedBox(width: FiftySpacing.sm),
            Icon(
              Icons.chevron_right,
              color: colorScheme.error.withValues(alpha: 0.7),
              size: FiftyTypography.titleSmall,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: FiftyRadii.smRadius,
        child: content,
      );
    }

    return content;
  }

  /// Converts camelCase or snake_case field name to Title Case.
  String _formatFieldName(String name) {
    // Handle camelCase
    final words = name
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        )
        // Handle snake_case
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
    return words;
  }
}
