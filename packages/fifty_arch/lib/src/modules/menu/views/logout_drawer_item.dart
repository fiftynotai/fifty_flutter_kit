import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/modules/menu/actions/menu_actions.dart';
import '/src/modules/locale/data/keys.dart';

/// Logout drawer item for the navigation menu.
///
/// Displays a logout option with FDL Kinetic Brutalism styling
/// that triggers the logout flow with confirmation dialog.
///
/// ## Usage:
/// ```dart
/// Drawer(
///   child: ListView(
///     children: [
///       LogoutDrawerItem(),
///     ],
///   ),
/// )
/// ```
class LogoutDrawerItem extends StatelessWidget {
  /// Creates a [LogoutDrawerItem].
  const LogoutDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLogoutConfirmation(context),
        splashColor: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
        highlightColor: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                size: 20,
                color: FiftyColors.crimsonPulse,
              ),
              const SizedBox(width: FiftySpacing.md),
              Text(
                tkLogoutBtn.tr.toUpperCase(),
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.body - 2,
                  fontWeight: FiftyTypography.medium,
                  color: FiftyColors.crimsonPulse,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before logging out.
  void _showLogoutConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftySpacing.sm),
          side: BorderSide(
            color: FiftyColors.border,
            width: 1,
          ),
        ),
        title: Text(
          tkLogoutConfirmTitle.tr.toUpperCase(),
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyHeadline,
            fontSize: FiftyTypography.body,
            fontWeight: FiftyTypography.ultrabold,
            color: colorScheme.onSurface,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          tkLogoutConfirmMessage.tr,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.body - 2,
            fontWeight: FiftyTypography.regular,
            color: FiftyColors.hyperChrome,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: FiftyColors.hyperChrome,
            ),
            child: Text(
              tkCancelBtn.tr.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FiftyTypography.medium,
                letterSpacing: 1,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close drawer
              MenuActions.logout(); // Perform logout
            },
            style: TextButton.styleFrom(
              foregroundColor: FiftyColors.crimsonPulse,
            ),
            child: Text(
              tkLogoutBtn.tr.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FiftyTypography.medium,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
