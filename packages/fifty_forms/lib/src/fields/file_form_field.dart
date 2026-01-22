import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';

/// Placeholder for file upload functionality.
///
/// Full implementation will be added in a future version with:
/// - File picker integration
/// - Drag and drop support
/// - Preview for images
/// - Upload progress indicator
/// - Multiple file selection
///
/// **Planned API:**
/// ```dart
/// FiftyFileFormField(
///   name: 'avatar',
///   controller: formController,
///   label: 'Profile Photo',
///   accept: ['image/*'],
///   maxSize: 5 * 1024 * 1024, // 5MB
///   validators: [Required()],
/// )
/// ```
class FiftyFileFormField extends StatelessWidget {
  /// Creates a placeholder file upload field.
  const FiftyFileFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.label,
    this.hint,
    this.enabled = true,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field (not yet implemented).
  final List<Validator<dynamic>>? validators;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed in the upload area.
  final String? hint;

  /// Whether the field is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor =
        isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    final fillColor =
        isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight;
    final textColor = isDark ? FiftyColors.slateGrey : Colors.grey[600];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelMedium,
              fontWeight: FiftyTypography.bold,
              color: textColor,
              letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
        ],
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: FiftyRadii.xlRadius,
            border: Border.all(
              color: borderColor,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: textColor,
                ),
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'File picker coming soon',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FiftyTypography.regular,
                    color: textColor,
                  ),
                ),
                if (hint != null) ...[
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    hint!,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FiftyTypography.regular,
                      color: textColor?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
