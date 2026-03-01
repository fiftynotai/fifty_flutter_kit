/// Resources Section
///
/// Horizontal scrolling section with resource link cards.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Resources section with horizontal scrolling link cards.
///
/// Provides quick access to GitHub, documentation, and examples.
class ResourcesSection extends StatelessWidget {
  /// Creates the resources section.
  const ResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _ResourceCard(
            icon: Icons.code,
            title: 'GITHUB',
            onTap: () => FiftySnackbar.show(
              context,
              message: 'Opening GitHub repository...',
              variant: FiftySnackbarVariant.info,
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          _ResourceCard(
            icon: Icons.menu_book,
            title: 'DOCS',
            onTap: () => FiftySnackbar.show(
              context,
              message: 'Opening documentation...',
              variant: FiftySnackbarVariant.info,
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          _ResourceCard(
            icon: Icons.folder_outlined,
            title: 'EXAMPLES',
            onTap: () => FiftySnackbar.show(
              context,
              message: 'Opening examples...',
              variant: FiftySnackbarVariant.info,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single resource card for horizontal scrolling.
class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  /// Size for the icon container.
  static const double _iconContainerSize = 40;

  /// Size for the icon inside the container.
  static const double _iconSize = 20;

  /// Width of the card.
  static const double _cardWidth = 100;

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      onTap: onTap,
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: SizedBox(
        width: _cardWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _iconContainerSize,
              height: _iconContainerSize,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
                borderRadius: FiftyRadii.smRadius,
              ),
              child: Icon(
                icon,
                color: colorScheme.onSurfaceVariant,
                size: _iconSize,
              ),
            ),
            SizedBox(height: FiftySpacing.sm),
            Text(
              title,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
