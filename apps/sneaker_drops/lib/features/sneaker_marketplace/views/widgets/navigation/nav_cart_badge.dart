import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **NavCartBadge**
///
/// Animated cart badge showing item count.
///
/// Features:
/// - Bounces on count change
/// - Uses burgundy background with cream text
/// - Minimum size 18x18px
/// - Uses labelSmall typography (10px)
class NavCartBadge extends StatefulWidget {
  /// Creates an animated cart badge.
  const NavCartBadge({
    super.key,
    required this.itemCount,
    this.onTap,
  });

  /// Number of items in the cart.
  final int itemCount;

  /// Callback when the cart icon is tapped.
  final VoidCallback? onTap;

  @override
  State<NavCartBadge> createState() => _NavCartBadgeState();
}

class _NavCartBadgeState extends State<NavCartBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.itemCount;
    _controller = AnimationController(
      duration: SneakerAnimations.medium,
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: SneakerAnimations.enter)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: SneakerAnimations.bounce)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(NavCartBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != _previousCount && widget.itemCount > 0) {
      _controller.forward(from: 0);
      _previousCount = widget.itemCount;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Shopping cart with ${widget.itemCount} items',
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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: _isHovered
                        ? SneakerColors.cream
                        : SneakerColors.slateGrey,
                    size: 24,
                  ),
                  if (widget.itemCount > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SneakerSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: SneakerColors.burgundy,
                            borderRadius: SneakerRadii.radiusFull,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.itemCount > 99 ? '99+' : '${widget.itemCount}',
                            style: SneakerTypography.badge.copyWith(
                              color: SneakerColors.cream,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
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
