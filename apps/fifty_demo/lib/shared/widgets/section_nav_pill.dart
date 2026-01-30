/// Section Navigation Pill Widget
///
/// Reusable navigation pill for section selection.
/// Uses theme-aware colors for light/dark mode support.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A styled navigation pill widget for section selection.
///
/// Displays a selectable pill with icon and label, styled according
/// to FDL v2 design tokens with theme-aware colors.
class SectionNavPill extends StatelessWidget {
  /// Creates a section navigation pill.
  const SectionNavPill({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  /// The label text to display.
  final String label;

  /// The icon to display.
  final IconData icon;

  /// Whether this pill is currently selected.
  final bool isActive;

  /// Callback when the pill is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: FiftyRadii.lgRadius,
          border: Border.all(
            color: isActive ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: FiftySpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section information data class.
///
/// Used to define sections for navigation.
class SectionNavInfo {
  /// Creates section information.
  const SectionNavInfo({
    required this.id,
    required this.label,
    required this.iconCodePoint,
  });

  /// Unique identifier for the section.
  final String id;

  /// Display label for the section.
  final String label;

  /// Material icon code point.
  final int iconCodePoint;

  /// Gets the icon data from the code point.
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
