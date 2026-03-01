import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Data class for navigation pill items.
///
/// Used with [FiftyNavPillBar] to define navigation options.
///
/// **Example Usage**
/// ```dart
/// final items = [
///   FiftyNavPillItem(
///     id: 'home',
///     label: 'Home',
///     icon: Icons.home,
///   ),
///   FiftyNavPillItem(
///     id: 'settings',
///     label: 'Settings',
///     icon: Icons.settings,
///   ),
/// ];
/// ```
class FiftyNavPillItem {
  /// Creates a navigation pill item.
  const FiftyNavPillItem({
    required this.id,
    required this.label,
    this.icon,
  });

  /// Unique identifier for the item.
  final String id;

  /// Display label for the item.
  final String label;

  /// Optional icon for the item.
  final IconData? icon;
}

/// **FiftyNavPill**
///
/// A styled navigation pill widget for section selection.
/// Follows FDL v2 design patterns with theme-aware colors.
///
/// Features:
/// - Selectable pill with optional icon and label
/// - Active state with primary color styling
/// - Inactive state with subtle border
/// - Customizable active color
///
/// **Why**
/// - Provides consistent navigation UI across the ecosystem
/// - Useful for tab-like navigation within pages
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// FiftyNavPill(
///   label: 'Overview',
///   icon: Icons.dashboard,
///   isActive: selectedTab == 'overview',
///   onTap: () => setState(() => selectedTab = 'overview'),
/// )
/// ```
class FiftyNavPill extends StatelessWidget {
  /// Creates a Fifty-styled navigation pill.
  const FiftyNavPill({
    required this.label,
    required this.isActive,
    required this.onTap,
    super.key,
    this.icon,
    this.activeColor,
  });

  /// The label text to display.
  final String label;

  /// Optional icon to display before the label.
  final IconData? icon;

  /// Whether this pill is currently selected.
  final bool isActive;

  /// Callback when the pill is tapped.
  final VoidCallback onTap;

  /// Custom active color. Defaults to primary color.
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = activeColor ?? colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: FiftyRadii.lgRadius,
          border: Border.all(
            color: isActive ? color : colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive ? color : colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: FiftySpacing.xs),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: isActive ? FiftyTypography.medium : null,
                color: isActive ? color : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// **FiftyNavPillBar**
///
/// A horizontal bar containing navigation pills.
/// Wraps [FiftyNavPill] widgets with consistent spacing and scrolling.
///
/// Features:
/// - Horizontal scrollable layout
/// - Consistent spacing between pills
/// - Supports any number of items
/// - Active item tracking
///
/// **Example Usage**
/// ```dart
/// FiftyNavPillBar(
///   items: [
///     FiftyNavPillItem(id: 'all', label: 'All', icon: Icons.list),
///     FiftyNavPillItem(id: 'active', label: 'Active', icon: Icons.play_arrow),
///     FiftyNavPillItem(id: 'completed', label: 'Completed', icon: Icons.check),
///   ],
///   selectedId: _selectedTab,
///   onSelected: (id) => setState(() => _selectedTab = id),
/// )
/// ```
class FiftyNavPillBar extends StatelessWidget {
  /// Creates a Fifty-styled navigation pill bar.
  const FiftyNavPillBar({
    required this.items,
    required this.selectedId,
    required this.onSelected,
    super.key,
    this.activeColor,
    this.spacing = 8,
    this.padding,
  });

  /// The list of navigation items.
  final List<FiftyNavPillItem> items;

  /// The ID of the currently selected item.
  final String selectedId;

  /// Callback when an item is selected.
  final ValueChanged<String> onSelected;

  /// Custom active color for all pills.
  final Color? activeColor;

  /// Spacing between pills.
  final double spacing;

  /// Optional padding around the bar.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            FiftyNavPill(
              label: items[i].label,
              icon: items[i].icon,
              isActive: items[i].id == selectedId,
              onTap: () => onSelected(items[i].id),
              activeColor: activeColor,
            ),
          ],
        ],
      ),
    );
  }
}
