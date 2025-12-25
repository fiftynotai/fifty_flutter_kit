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

    // Note: Standard SnackBar uses default animation.
    // For FDL-compliant slide animation, use showWithSlide() instead.
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

  /// Shows a Fifty-styled snackbar with slide animation.
  ///
  /// Alternative to [show] that uses overlay for full control over animation.
  /// Slides from bottom with no fade effect (FDL compliant).
  static void showWithSlide(
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

    late OverlayEntry overlayEntry;
    late AnimationController controller;

    // Create animation controller
    controller = AnimationController(
      duration: FiftyMotion.compiling,
      vsync: Navigator.of(context),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: FiftyMotion.enter,
    ));

    void removeOverlay() {
      controller.reverse().then((_) {
        overlayEntry.remove();
        controller.dispose();
      });
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: FiftySpacing.lg,
        left: FiftySpacing.lg,
        right: FiftySpacing.lg,
        child: SlideTransition(
          position: slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.md,
              ),
              decoration: BoxDecoration(
                color: FiftyColors.gunmetal,
                borderRadius: FiftyRadii.standardRadius,
                border: Border.all(color: accentColor, width: 1),
              ),
              child: Row(
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
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(width: FiftySpacing.md),
                    GestureDetector(
                      onTap: () {
                        onAction();
                        removeOverlay();
                      },
                      child: Text(
                        actionLabel.toUpperCase(),
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: 14,
                          fontWeight: FiftyTypography.medium,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    controller.forward();

    // Auto dismiss
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        removeOverlay();
      }
    });
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
