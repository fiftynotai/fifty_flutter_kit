import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import 'nav_cart_badge.dart';

/// **GlassNavBar**
///
/// Glassmorphism navigation bar with frosted glass effect.
///
/// Features:
/// - BackdropFilter with blur (sigma: 10)
/// - Semi-transparent dark burgundy background
/// - Responsive: full nav on desktop, hamburger on mobile
/// - Cart badge integration
/// - Search icon
///
/// Height: 64px desktop, 56px mobile
class GlassNavBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a glassmorphism navigation bar.
  const GlassNavBar({
    super.key,
    this.onSearchTap,
    this.onCartTap,
    this.onMenuTap,
    this.cartItemCount = 0,
    this.currentRoute,
    this.onNavigate,
  });

  /// Callback when search icon is tapped.
  final VoidCallback? onSearchTap;

  /// Callback when cart icon is tapped.
  final VoidCallback? onCartTap;

  /// Callback when hamburger menu is tapped (mobile only).
  final VoidCallback? onMenuTap;

  /// Number of items in the cart for badge display.
  final int cartItemCount;

  /// Current route for active state highlighting.
  final String? currentRoute;

  /// Callback when a navigation item is selected.
  final void Function(String route)? onNavigate;

  /// Breakpoint for mobile/desktop layout.
  static const double _mobileBreakpoint = 768.0;

  /// Desktop nav bar height.
  static const double _desktopHeight = 64.0;

  /// Mobile nav bar height.
  static const double _mobileHeight = 56.0;

  @override
  Size get preferredSize => const Size.fromHeight(_desktopHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _mobileBreakpoint;
        final height = isMobile ? _mobileHeight : _desktopHeight;

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: SneakerColors.glassBackground,
                border: Border(
                  bottom: BorderSide(
                    color: SneakerColors.glassBorder,
                    width: 1,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
              ),
              child: Row(
                children: [
                  _buildLogo(),
                  const Spacer(),
                  if (!isMobile) ...[
                    _buildNavItems(),
                    const SizedBox(width: SneakerSpacing.xxl),
                  ],
                  _buildActionButtons(isMobile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Text(
      'SNEAKER DROPS',
      style: SneakerTypography.textTheme.titleMedium?.copyWith(
        letterSpacing: 2,
        fontWeight: SneakerTypography.extraBold,
      ),
    );
  }

  Widget _buildNavItems() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavItem(
          label: 'HOME',
          isActive: currentRoute == '/' || currentRoute == '/home',
          onTap: () => onNavigate?.call('/'),
        ),
        const SizedBox(width: SneakerSpacing.xxl),
        _NavItem(
          label: 'DROPS',
          isActive: currentRoute == '/drops',
          onTap: () => onNavigate?.call('/drops'),
        ),
        const SizedBox(width: SneakerSpacing.xxl),
        _NavItem(
          label: 'BRANDS',
          isActive: currentRoute == '/brands',
          onTap: () => onNavigate?.call('/brands'),
        ),
        const SizedBox(width: SneakerSpacing.xxl),
        _NavItem(
          label: 'SELL',
          isActive: currentRoute == '/sell',
          onTap: () => onNavigate?.call('/sell'),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavIconButton(
          icon: Icons.search,
          onTap: onSearchTap,
          semanticLabel: 'Search',
        ),
        const SizedBox(width: SneakerSpacing.md),
        NavCartBadge(
          itemCount: cartItemCount,
          onTap: onCartTap,
        ),
        if (isMobile) ...[
          const SizedBox(width: SneakerSpacing.md),
          _NavIconButton(
            icon: Icons.menu,
            onTap: onMenuTap,
            semanticLabel: 'Open menu',
          ),
        ],
      ],
    );
  }
}

/// Internal navigation item widget with hover effect.
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Focus(
          child: AnimatedDefaultTextStyle(
            duration: SneakerAnimations.fast,
            style: SneakerTypography.label.copyWith(
              color: widget.isActive || _isHovered
                  ? SneakerColors.cream
                  : SneakerColors.slateGrey,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label),
                const SizedBox(height: SneakerSpacing.xs),
                AnimatedContainer(
                  duration: SneakerAnimations.fast,
                  height: 2,
                  width: widget.isActive || _isHovered ? 24 : 0,
                  decoration: BoxDecoration(
                    color: SneakerColors.burgundy,
                    borderRadius: SneakerRadii.radiusFull,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal icon button for nav bar actions.
class _NavIconButton extends StatefulWidget {
  const _NavIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  State<_NavIconButton> createState() => _NavIconButtonState();
}

class _NavIconButtonState extends State<_NavIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
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
                widget.icon,
                color: _isHovered ? SneakerColors.cream : SneakerColors.slateGrey,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
