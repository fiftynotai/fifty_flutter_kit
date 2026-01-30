import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A modal dialog with FDL v2 styling.
///
/// Features:
/// - xxxl border radius (32px) for hero feel
/// - Border glow effect
/// - Optional close button
/// - Animated entrance using compiling duration
/// - Mode-aware colors
///
/// Example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => FiftyDialog(
///     title: 'CONFIRM ACTION',
///     content: Text('Are you sure you want to proceed?'),
///     actions: [
///       FiftyButton(
///         label: 'CANCEL',
///         variant: FiftyButtonVariant.ghost,
///         onPressed: () => Navigator.pop(context),
///       ),
///       FiftyButton(
///         label: 'CONFIRM',
///         onPressed: () => handleConfirm(context),
///       ),
///     ],
///   ),
/// );
/// ```
class FiftyDialog extends StatelessWidget {
  /// Creates a Fifty-styled dialog.
  const FiftyDialog({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.showCloseButton = true,
    this.showGlow = true,
  });

  /// The dialog title.
  ///
  /// Displayed in uppercase with headline styling.
  final String? title;

  /// The main content of the dialog.
  final Widget content;

  /// Action buttons displayed at the bottom.
  final List<Widget> actions;

  /// Whether to show the close button in the top-right.
  final bool showCloseButton;

  /// Whether to show the primary glow effect.
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final backgroundColor = colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outline;
    final closeIconColor = colorScheme.onSurfaceVariant;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedContainer(
        duration: fifty.compiling,
        curve: fifty.enterCurve,
        constraints: const BoxConstraints(
          maxWidth: 480,
          minWidth: 280,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: FiftyRadii.xxxlRadius,
          border: Border.all(
            color: showGlow ? colorScheme.primary : borderColor,
            width: showGlow ? 2 : 1,
          ),
          boxShadow: showGlow ? fifty.shadowGlow : FiftyShadows.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.all(FiftySpacing.lg),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.titleLarge,
                            fontWeight: FiftyTypography.extraBold,
                            color: colorScheme.onSurface,
                            letterSpacing: FiftyTypography.letterSpacingDisplayMedium,
                          ),
                        ),
                      ),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: closeIconColor,
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                left: FiftySpacing.lg,
                right: FiftySpacing.lg,
                top: title != null ? 0 : FiftySpacing.lg,
                bottom: actions.isNotEmpty ? FiftySpacing.lg : FiftySpacing.lg,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  fontWeight: FiftyTypography.regular,
                  color: colorScheme.onSurface,
                  height: FiftyTypography.lineHeightBody,
                ),
                child: content,
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: FiftySpacing.lg,
                  right: FiftySpacing.lg,
                  bottom: FiftySpacing.lg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions.map((action) {
                    final index = actions.indexOf(action);
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index > 0 ? FiftySpacing.md : 0,
                      ),
                      child: action,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show a FiftyDialog with proper animation.
///
/// Example:
/// ```dart
/// showFiftyDialog(
///   context: context,
///   builder: (context) => FiftyDialog(
///     title: 'CONFIRM',
///     content: Text('Proceed?'),
///   ),
/// );
/// ```
Future<T?> showFiftyDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final barrierColor = colorScheme.scrim;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: barrierColor,
    transitionDuration: FiftyMotion.compiling,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    // FDL Rule: "NO FADES. Use slides, wipes, reveals."
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.15),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: FiftyMotion.enter,
        )),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: FiftyMotion.enter,
          )),
          child: child,
        ),
      );
    },
  );
}
