import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// A styled card wrapper for audio channel sections.
///
/// Provides consistent styling with a title header and optional
/// status badge indicator.
class ChannelCard extends StatelessWidget {
  /// Creates a channel card.
  const ChannelCard({
    super.key,
    required this.title,
    required this.child,
    this.statusLabel,
    this.statusActive = false,
  });

  /// The title displayed at the top of the card.
  final String title;

  /// The content of the card.
  final Widget child;

  /// Optional status label shown as a badge.
  final String? statusLabel;

  /// Whether the status badge should show active glow.
  final bool statusActive;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      hasTexture: true,
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  fontWeight: FiftyTypography.medium,
                  color: FiftyColors.cream,
                  letterSpacing: 1,
                ),
              ),
              if (statusLabel != null)
                FiftyBadge(
                  label: statusLabel!,
                  variant: statusActive
                      ? FiftyBadgeVariant.success
                      : FiftyBadgeVariant.neutral,
                  showGlow: statusActive,
                ),
            ],
          ),
          const SizedBox(height: FiftySpacing.lg),
          child,
        ],
      ),
    );
  }
}
