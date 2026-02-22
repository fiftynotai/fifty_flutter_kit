import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **SplashPage**
///
/// FDL-styled splash screen with Orbital Command space theme.
/// Shown while the app determines the current authentication status.
/// Typically rendered by [AuthHandler] when [AuthState.checking] is active.
///
/// **FDL Aesthetic:**
/// - Void Black background (#050505)
/// - ORBITAL COMMAND text in Monument Extended, uppercase, crimsonPulse
/// - FiftyLoadingIndicator with animated dots
/// - FDL v2 styling
///
/// // ----------------------------------------------------
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Orbital Command branding
            Text(
              'ORBITAL COMMAND',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyHeadline,
                fontSize: FiftyTypography.section,
                fontWeight: FiftyTypography.ultrabold,
                color: FiftyColors.crimsonPulse,
                letterSpacing: 4,
              ),
            ),

            const SizedBox(height: FiftySpacing.xxl),

            // Subtle grid lines effect
            Container(
              width: 200,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    FiftyColors.hyperChrome.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: FiftySpacing.xxl),

            // FDL-compliant loading indicator
            const FiftyLoadingIndicator(
              text: 'INITIALIZING SYSTEMS',
              style: FiftyLoadingStyle.sequence,
              size: FiftyLoadingSize.medium,
              sequences: [
                '> INITIALIZING...',
                '> ESTABLISHING UPLINK...',
                '> AUTHENTICATING...',
                '> SYNCING DATA...',
              ],
            ),

            const SizedBox(height: FiftySpacing.huge),

            // Subtle version/system info
            Text(
              'v0.1.0',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FiftyTypography.regular,
                color: FiftyColors.hyperChrome.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
