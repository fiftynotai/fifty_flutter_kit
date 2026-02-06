import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **EmptyCartState**
///
/// Empty cart placeholder with call-to-action.
///
/// Features:
/// - Animated sneaker icon illustration
/// - "Your cart is empty" message
/// - "Start shopping" CTA button
/// - Subtle floating animation on icon
///
/// **Example Usage:**
/// ```dart
/// EmptyCartState(
///   onStartShopping: () => navigateToCatalog(),
/// )
/// ```
class EmptyCartState extends StatefulWidget {
  /// Creates an empty cart state widget.
  const EmptyCartState({
    super.key,
    required this.onStartShopping,
  });

  /// Callback when "Start shopping" button is pressed.
  final VoidCallback onStartShopping;

  @override
  State<EmptyCartState> createState() => _EmptyCartStateState();
}

class _EmptyCartStateState extends State<EmptyCartState>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: SneakerAnimations.float,
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -SneakerAnimations.floatAmplitude,
      end: SneakerAnimations.floatAmplitude,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: SneakerAnimations.floatCurve,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: SneakerSpacing.allXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating sneaker icon
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: SneakerColors.surfaceDark,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: SneakerColors.border,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SneakerColors.burgundy.withValues(alpha: 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 56,
                  color: SneakerColors.slateGrey,
                ),
              ),
            ),
            const SizedBox(height: SneakerSpacing.xxxl),

            // Empty message
            Text(
              'YOUR CART IS EMPTY',
              style: SneakerTypography.sectionTitle.copyWith(
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SneakerSpacing.md),

            // Subtitle
            Text(
              'Looks like you haven\'t added any sneakers yet.',
              style: SneakerTypography.description.copyWith(
                color: SneakerColors.slateGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SneakerSpacing.xxxl),

            // CTA button
            _StartShoppingButton(
              onPressed: widget.onStartShopping,
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal CTA button widget.
class _StartShoppingButton extends StatefulWidget {
  const _StartShoppingButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<_StartShoppingButton> createState() => _StartShoppingButtonState();
}

class _StartShoppingButtonState extends State<_StartShoppingButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Start shopping',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: SneakerAnimations.fast,
            padding: EdgeInsets.symmetric(
              horizontal: SneakerSpacing.xxxl,
              vertical: SneakerSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: _isHovered ? SneakerColors.burgundy : Colors.transparent,
              borderRadius: SneakerRadii.radiusMd,
              border: Border.all(
                color: SneakerColors.burgundy,
                width: 2,
              ),
            ),
            child: Text(
              'START SHOPPING',
              style: SneakerTypography.label.copyWith(
                color: _isHovered ? SneakerColors.cream : SneakerColors.burgundy,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
