import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **MobileDrawer**
///
/// Slide-out drawer for mobile navigation.
///
/// Features:
/// - Glassmorphism background
/// - Logo at top
/// - Navigation items with icons
/// - Close button
/// - Slide from right
class MobileDrawer extends StatelessWidget {
  /// Creates a mobile navigation drawer.
  const MobileDrawer({
    super.key,
    this.onClose,
    this.onNavigate,
    this.currentRoute,
  });

  /// Callback when close button is tapped.
  final VoidCallback? onClose;

  /// Callback when a navigation item is selected.
  final void Function(String route)? onNavigate;

  /// Current route for active state highlighting.
  final String? currentRoute;

  /// Navigation items with their icons and routes.
  static const List<_NavItemData> _navItems = [
    _NavItemData(label: 'HOME', icon: Icons.home_outlined, route: '/'),
    _NavItemData(label: 'DROPS', icon: Icons.new_releases_outlined, route: '/drops'),
    _NavItemData(label: 'BRANDS', icon: Icons.storefront_outlined, route: '/brands'),
    _NavItemData(label: 'SELL', icon: Icons.sell_outlined, route: '/sell'),
    _NavItemData(label: 'CART', icon: Icons.shopping_bag_outlined, route: '/cart'),
    _NavItemData(label: 'PROFILE', icon: Icons.person_outline, route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            color: SneakerColors.glassBackgroundStrong,
            border: Border(
              left: BorderSide(
                color: SneakerColors.glassBorder,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: SneakerSpacing.xxxl),
                Expanded(
                  child: _buildNavItems(),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(SneakerSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SNEAKER DROPS',
            style: SneakerTypography.textTheme.titleMedium?.copyWith(
              letterSpacing: 2,
              fontWeight: SneakerTypography.extraBold,
            ),
          ),
          _CloseButton(onTap: onClose),
        ],
      ),
    );
  }

  Widget _buildNavItems() {
    return ListView.separated(
      padding: SneakerSpacing.horizontalLg,
      itemCount: _navItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: SneakerSpacing.sm),
      itemBuilder: (context, index) {
        final item = _navItems[index];
        final isActive = currentRoute == item.route ||
            (currentRoute == '/home' && item.route == '/');
        return _DrawerNavItem(
          label: item.label,
          icon: item.icon,
          isActive: isActive,
          onTap: () {
            onNavigate?.call(item.route);
            onClose?.call();
          },
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(SneakerSpacing.lg),
      child: Text(
        'Version 1.0.0',
        style: SneakerTypography.textTheme.bodySmall?.copyWith(
          color: SneakerColors.slateGrey.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Data class for navigation items.
class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

/// Navigation item widget for the drawer.
class _DrawerNavItem extends StatefulWidget {
  const _DrawerNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered;

    return Semantics(
      label: '${widget.label} navigation item',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Focus(
            child: AnimatedContainer(
              duration: SneakerAnimations.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: SneakerSpacing.lg,
                vertical: SneakerSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? SneakerColors.burgundy.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: SneakerRadii.radiusMd,
                border: widget.isActive
                    ? Border.all(
                        color: SneakerColors.burgundy.withValues(alpha: 0.5),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: isHighlighted
                        ? SneakerColors.cream
                        : SneakerColors.slateGrey,
                    size: 24,
                  ),
                  const SizedBox(width: SneakerSpacing.md),
                  AnimatedDefaultTextStyle(
                    duration: SneakerAnimations.fast,
                    style: SneakerTypography.label.copyWith(
                      color: isHighlighted
                          ? SneakerColors.cream
                          : SneakerColors.slateGrey,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Close button for the drawer header.
class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Close navigation menu',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Focus(
            child: AnimatedContainer(
              duration: SneakerAnimations.fast,
              padding: SneakerSpacing.allSm,
              decoration: BoxDecoration(
                color: _isHovered
                    ? SneakerColors.burgundy.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: SneakerRadii.radiusMd,
              ),
              child: Icon(
                Icons.close,
                color:
                    _isHovered ? SneakerColors.cream : SneakerColors.slateGrey,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
