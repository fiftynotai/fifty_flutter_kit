/// Feature Navigation Card
///
/// A card widget for navigating to demo features.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Feature navigation card widget.
///
/// Displays a tappable card with icon, title, and subtitle.
class FeatureNavCard extends StatelessWidget {
  const FeatureNavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  /// Card title.
  final String title;

  /// Card subtitle.
  final String subtitle;

  /// Leading icon.
  final IconData icon;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
                borderRadius: FiftyRadii.standardRadius,
                border: Border.all(
                  color: FiftyColors.crimsonPulse.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: FiftyColors.crimsonPulse,
                size: 24,
              ),
            ),
            const SizedBox(width: FiftySpacing.lg),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyHeadline,
                      fontSize: FiftyTypography.body,
                      fontWeight: FontWeight.bold,
                      color: FiftyColors.terminalWhite,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.mono,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            const Icon(
              Icons.chevron_right,
              color: FiftyColors.hyperChrome,
            ),
          ],
        ),
      ),
    );
  }
}
