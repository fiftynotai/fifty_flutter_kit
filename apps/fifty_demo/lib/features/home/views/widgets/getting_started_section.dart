/// Getting Started Section
///
/// A 2x2 grid of quick action cards for the home page.
/// Provides navigation to key demo features.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Getting Started section with 4 quick action cards in a 2x2 grid.
///
/// Provides navigation to:
/// - Explore Packages (packages tab)
/// - UI Components (ui kit tab)
/// - Audio Demo (dialogue demo page)
/// - Map Demo (map demo page)
class GettingStartedSection extends StatelessWidget {
  /// Creates the getting started section.
  const GettingStartedSection({
    required this.onExplorePackages,
    required this.onUiComponents,
    required this.onAudioDemo,
    required this.onMapDemo,
    super.key,
  });

  /// Callback when Explore Packages is tapped.
  final VoidCallback onExplorePackages;

  /// Callback when UI Components is tapped.
  final VoidCallback onUiComponents;

  /// Callback when Audio Demo is tapped.
  final VoidCallback onAudioDemo;

  /// Callback when Map Demo is tapped.
  final VoidCallback onMapDemo;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: FiftySpacing.md,
      crossAxisSpacing: FiftySpacing.md,
      childAspectRatio: 1.1,
      children: [
        _ActionCard(
          icon: Icons.apps,
          title: 'EXPLORE PACKAGES',
          description: 'Browse the ecosystem',
          onTap: onExplorePackages,
        ),
        _ActionCard(
          icon: Icons.widgets_outlined,
          title: 'UI COMPONENTS',
          description: 'View design system',
          onTap: onUiComponents,
        ),
        _ActionCard(
          icon: Icons.headphones,
          title: 'AUDIO DEMO',
          description: 'Sound engine showcase',
          onTap: onAudioDemo,
        ),
        _ActionCard(
          icon: Icons.map_outlined,
          title: 'MAP DEMO',
          description: 'Interactive grid map',
          onTap: onMapDemo,
        ),
      ],
    );
  }
}

/// A single action card for the getting started grid.
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  /// Size for the icon container.
  static const double _iconContainerSize = 48;

  /// Size for the icon inside the container.
  static const double _iconSize = 24;

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      onTap: onTap,
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _iconContainerSize,
            height: _iconContainerSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: FiftyRadii.mdRadius,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: _iconSize,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: FiftySpacing.xs),
          Text(
            description,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
