import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Snackbar variants for different message types.
enum FiftySnackbarVariant {
  /// Informational message.
  info,

  /// Success message.
  success,

  /// Warning message.
  warning,

  /// Error message.
  error,
}

/// A themed snackbar with FDL styling.
///
/// Use the static [show] method to display a snackbar.
///
/// Features:
/// - Four variants: info, success, warning, error
/// - Border glow matching variant color
/// - Gunmetal background with variant accent
///
/// Example:
/// ```dart
/// FiftySnackbar.show(
///   context,
///   message: 'Deployment successful!',
///   variant: FiftySnackbarVariant.success,
/// );
/// ```
class FiftySnackbar {
  FiftySnackbar._();

  /// Shows a Fifty-styled snackbar.
  ///
  /// The [context] must have a [ScaffoldMessenger] ancestor.
  static void show(
    BuildContext context, {
    required String message,
    FiftySnackbarVariant variant = FiftySnackbarVariant.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final accentColor = _getAccentColor(fifty, colorScheme, variant);

    final snackBar = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: FiftyColors.gunmetal,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.standardRadius,
        side: BorderSide(color: accentColor, width: 1),
      ),
      content: Row(
        children: [
          Icon(
            _getIcon(variant),
            color: accentColor,
            size: 20,
          ),
          const SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: 14,
                fontWeight: FiftyTypography.regular,
                color: FiftyColors.terminalWhite,
              ),
            ),
          ),
        ],
      ),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel.toUpperCase(),
              textColor: accentColor,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Color _getAccentColor(
    FiftyThemeExtension fifty,
    ColorScheme colorScheme,
    FiftySnackbarVariant variant,
  ) {
    switch (variant) {
      case FiftySnackbarVariant.info:
        return FiftyColors.hyperChrome;
      case FiftySnackbarVariant.success:
        return fifty.success;
      case FiftySnackbarVariant.warning:
        return fifty.warning;
      case FiftySnackbarVariant.error:
        return colorScheme.error;
    }
  }

  static IconData _getIcon(FiftySnackbarVariant variant) {
    switch (variant) {
      case FiftySnackbarVariant.info:
        return Icons.info_outline;
      case FiftySnackbarVariant.success:
        return Icons.check_circle_outline;
      case FiftySnackbarVariant.warning:
        return Icons.warning_amber_outlined;
      case FiftySnackbarVariant.error:
        return Icons.error_outline;
    }
  }
}
