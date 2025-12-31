import 'dart:ui';

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Navigation bar style variants.
enum FiftyNavBarStyle {
  /// Pill-shaped (stadium/capsule) with large border radius.
  pill,

  /// Standard rectangular with standard border radius.
  standard,
}

/// An item in [FiftyNavBar].
class FiftyNavItem {
  /// Creates a navigation item.
  const FiftyNavItem({
    required this.label,
    this.icon,
  });

  /// The label text for this item.
  final String label;

  /// Optional icon for this item.
  final IconData? icon;
}

/// A floating "Dynamic Island" style navigation bar.
///
/// Implements the FDL "Command Deck" specification:
/// - Glassmorphism: BackdropFilter blur 20px + black 50% opacity
/// - Shape: Pill (100px radius) or Standard (12px radius)
/// - Selection: Active item gets Crimson underbar
///
/// Example:
/// ```dart
/// FiftyNavBar(
///   items: [
///     FiftyNavItem(label: 'Home', icon: Icons.home),
///     FiftyNavItem(label: 'Search', icon: Icons.search),
///     FiftyNavItem(label: 'Profile', icon: Icons.person),
///   ],
///   selectedIndex: _currentIndex,
///   onItemSelected: (index) => setState(() => _currentIndex = index),
/// )
/// ```
class FiftyNavBar extends StatelessWidget {
  /// Creates a Fifty-styled navigation bar.
  const FiftyNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.style = FiftyNavBarStyle.pill,
    this.height = 56.0,
    this.margin,
  });

  /// The navigation items to display.
  final List<FiftyNavItem> items;

  /// The index of the currently selected item.
  final int selectedIndex;

  /// Callback when an item is selected.
  final ValueChanged<int> onItemSelected;

  /// The visual style of the navigation bar.
  final FiftyNavBarStyle style;

  /// The height of the navigation bar.
  ///
  /// Defaults to 56.0 pixels.
  final double height;

  /// Margin around the navigation bar.
  ///
  /// Defaults to horizontal padding based on style.
  final EdgeInsetsGeometry? margin;

  BorderRadius get _borderRadius {
    switch (style) {
      case FiftyNavBarStyle.pill:
        return BorderRadius.circular(100);
      case FiftyNavBarStyle.standard:
        return FiftyRadii.standardRadius;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveMargin = margin ??
        EdgeInsets.symmetric(
          horizontal: style == FiftyNavBarStyle.pill
              ? FiftySpacing.lg
              : FiftySpacing.md,
        );

    return Container(
      margin: effectiveMargin,
      height: height,
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: FiftyColors.voidBlack.withValues(alpha: 0.5),
              borderRadius: _borderRadius,
              border: Border.all(
                color: FiftyColors.hyperChrome.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                return Expanded(
                  child: _FiftyNavBarItem(
                    item: items[index],
                    isSelected: index == selectedIndex,
                    onTap: () => onItemSelected(index),
                    primaryColor: colorScheme.primary,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _FiftyNavBarItem extends StatefulWidget {
  const _FiftyNavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
  });

  final FiftyNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;

  @override
  State<_FiftyNavBarItem> createState() => _FiftyNavBarItemState();
}

class _FiftyNavBarItemState extends State<_FiftyNavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final textColor = widget.isSelected || _isHovered
        ? FiftyColors.terminalWhite
        : FiftyColors.hyperChrome;
    final iconColor = widget.isSelected
        ? widget.primaryColor
        : (_isHovered ? FiftyColors.terminalWhite : FiftyColors.hyperChrome);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: fifty.fast,
          curve: fifty.standardCurve,
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.sm,
            vertical: FiftySpacing.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.item.icon != null) ...[
                AnimatedContainer(
                  duration: fifty.fast,
                  curve: fifty.standardCurve,
                  child: Icon(
                    widget.item.icon,
                    size: 20,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              AnimatedDefaultTextStyle(
                duration: fifty.fast,
                curve: fifty.standardCurve,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: 10,
                  fontWeight: widget.isSelected
                      ? FiftyTypography.medium
                      : FiftyTypography.regular,
                  color: textColor,
                  letterSpacing: FiftyTypography.tight * 10,
                ),
                child: Text(widget.item.label.toUpperCase()),
              ),
              const SizedBox(height: 4),
              // Crimson underbar for selected state
              AnimatedContainer(
                duration: fifty.fast,
                curve: fifty.standardCurve,
                height: 2,
                width: widget.isSelected ? 24 : 0,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
