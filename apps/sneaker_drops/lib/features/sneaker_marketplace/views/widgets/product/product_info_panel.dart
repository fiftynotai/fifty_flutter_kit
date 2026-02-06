import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/sneaker_model.dart';
import '../filter/size_selector_grid.dart';
import 'price_trend.dart';
import 'rarity_badge.dart';

/// **ProductInfoPanel**
///
/// Product information panel with purchase options.
///
/// Displays brand, name, rarity, price with trend, size selector grid,
/// add to cart button, and authenticity guarantee badge.
///
/// **Example Usage:**
/// ```dart
/// ProductInfoPanel(
///   sneaker: sneaker,
///   selectedSize: 10.0,
///   onSizeSelected: (size) => setState(() => selectedSize = size),
///   onAddToCart: () => addToCart(sneaker, selectedSize),
///   isAddingToCart: false,
/// )
/// ```
class ProductInfoPanel extends StatelessWidget {
  /// The sneaker to display information for.
  final SneakerModel sneaker;

  /// Currently selected size (null if none selected).
  final double? selectedSize;

  /// Callback when a size is selected.
  final ValueChanged<double> onSizeSelected;

  /// Callback when add to cart button is pressed.
  final VoidCallback onAddToCart;

  /// Whether add to cart action is in progress.
  final bool isAddingToCart;

  /// Creates a [ProductInfoPanel] with the specified parameters.
  const ProductInfoPanel({
    required this.sneaker,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.onAddToCart,
    this.isAddingToCart = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Text(
          sneaker.brand.toUpperCase(),
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 12,
            fontWeight: SneakerTypography.semiBold,
            letterSpacing: 2,
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xs),

        // Product name
        Text(
          sneaker.name,
          style: SneakerTypography.sectionTitle,
        ),
        const SizedBox(height: SneakerSpacing.xs),

        // Colorway
        Text(
          '"${sneaker.colorway}"',
          style: SneakerTypography.body.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Rarity badge
        RarityBadge(
          rarity: sneaker.rarity,
          size: RarityBadgeSize.large,
        ),
        const SizedBox(height: SneakerSpacing.xxl),

        // Price with trend
        PriceTrend(
          price: sneaker.price,
          marketPrice: sneaker.marketPrice,
          size: PriceTrendSize.large,
          showMarketLabel: true,
        ),
        const SizedBox(height: SneakerSpacing.xxxl),

        // Size selector section
        _buildSizeSection(),
        const SizedBox(height: SneakerSpacing.xxl),

        // Add to cart button
        _AddToCartButton(
          onPressed: selectedSize != null ? onAddToCart : null,
          isLoading: isAddingToCart,
          isDisabled: selectedSize == null,
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Authenticity guarantee
        _buildAuthenticityBadge(),
      ],
    );
  }

  Widget _buildSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SELECT SIZE',
              style: SneakerTypography.label.copyWith(
                letterSpacing: 2,
              ),
            ),
            if (selectedSize != null)
              Text(
                'US ${_formatSize(selectedSize!)}',
                style: SneakerTypography.label.copyWith(
                  color: SneakerColors.burgundy,
                ),
              ),
          ],
        ),
        const SizedBox(height: SneakerSpacing.md),

        // Size grid
        SizeSelectorGrid(
          sizes: sneaker.sizes,
          selectedSize: selectedSize,
          onSizeSelected: onSizeSelected,
        ),
      ],
    );
  }

  Widget _buildAuthenticityBadge() {
    return Container(
      padding: SneakerSpacing.allMd,
      decoration: BoxDecoration(
        color: SneakerColors.hunterGreen.withValues(alpha: 0.15),
        borderRadius: SneakerRadii.radiusMd,
        border: Border.all(
          color: SneakerColors.hunterGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            size: 20,
            color: SneakerColors.hunterGreen,
          ),
          const SizedBox(width: SneakerSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUTHENTICITY GUARANTEED',
                  style: TextStyle(
                    fontFamily: SneakerTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: SneakerTypography.bold,
                    letterSpacing: 1,
                    color: SneakerColors.hunterGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Every pair is verified by our authentication experts',
                  style: TextStyle(
                    fontFamily: SneakerTypography.fontFamily,
                    fontSize: 11,
                    fontWeight: SneakerTypography.regular,
                    color: SneakerColors.slateGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSize(double size) {
    if (size == size.truncate()) {
      return size.toInt().toString();
    }
    return size.toString();
  }
}

/// Internal add to cart button with loading state.
class _AddToCartButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  const _AddToCartButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
  });

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isDisabled && !widget.isLoading;

    return Semantics(
      label: widget.isDisabled
          ? 'Select a size to add to cart'
          : 'Add to cart',
      button: true,
      enabled: isEnabled,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: isEnabled ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: SneakerAnimations.fast,
            padding: SneakerSpacing.allLg,
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? SneakerColors.grailGradient
                  : null,
              color: isEnabled ? null : SneakerColors.surfaceDark,
              borderRadius: SneakerRadii.radiusMd,
              border: Border.all(
                color: isEnabled
                    ? Colors.transparent
                    : SneakerColors.border,
              ),
              boxShadow: _isHovered && isEnabled
                  ? [
                      BoxShadow(
                        color: SneakerColors.burgundy.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            transform: Matrix4.identity()
              ..setEntry(0, 0, _isPressed ? 0.98 : 1.0)
              ..setEntry(1, 1, _isPressed ? 0.98 : 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(SneakerColors.cream),
                    ),
                  )
                else ...[
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 20,
                    color: isEnabled
                        ? SneakerColors.cream
                        : SneakerColors.slateGrey,
                  ),
                  const SizedBox(width: SneakerSpacing.sm),
                  Text(
                    widget.isDisabled ? 'SELECT SIZE' : 'ADD TO CART',
                    style: SneakerTypography.label.copyWith(
                      color: isEnabled
                          ? SneakerColors.cream
                          : SneakerColors.slateGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
