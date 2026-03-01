import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A custom drawer item widget for the navigation menu.
///
/// Displays a menu item with an icon and label following FDL v2
/// aesthetic with Orbital Command space theme.
///
/// ## Features:
/// - Gunmetal background when selected
/// - Crimson pulse left border accent when selected
/// - UPPERCASE text with letter spacing
/// - hyperChrome icon color, crimsonPulse when selected
/// - Responds to tap gestures with FDL motion
///
/// ## Example:
/// ```dart
/// MenuDrawerItem(
///   label: 'DASHBOARD',
///   icon: Icons.radar,
///   isSelected: true,
///   onTap: () => controller.selectMenuItem(homeItem),
/// )
/// ```
class MenuDrawerItem extends StatelessWidget {
  /// The text label to display.
  final String label;

  /// The icon to display before the label.
  final IconData icon;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// Callback when the item is tapped.
  final VoidCallback onTap;

  /// Creates a [MenuDrawerItem].
  ///
  /// All parameters are required.
  const MenuDrawerItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: colorScheme.primary.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: FiftyMotion.fast,
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surfaceContainerHighest : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? FiftyColors.crimsonPulse : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.0,
                color: isSelected ? FiftyColors.crimsonPulse : FiftyColors.hyperChrome,
              ),
              SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.body - 2,
                    fontWeight: FiftyTypography.medium,
                    color: isSelected ? FiftyColors.crimsonPulse : colorScheme.onSurface,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              // Arrow indicator for selected item
              if (isSelected)
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: FiftyColors.crimsonPulse,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
