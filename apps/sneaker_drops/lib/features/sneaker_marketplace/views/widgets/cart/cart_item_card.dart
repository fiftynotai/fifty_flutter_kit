import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/cart_item_model.dart';
import 'quantity_stepper.dart';

/// **CartItemCard**
///
/// Individual cart item display with product details and quantity controls.
///
/// Features:
/// - Floating sneaker thumbnail (80x80px)
/// - Product name and size display
/// - Quantity stepper (+/- buttons)
/// - Price that updates on quantity change
/// - Swipe to remove on mobile (Dismissible)
/// - Remove button on desktop (hover reveal)
///
/// **Example Usage:**
/// ```dart
/// CartItemCard(
///   item: cartItem,
///   onQuantityChanged: (qty) => updateQty(cartItem, qty),
///   onRemove: () => removeFromCart(cartItem),
/// )
/// ```
class CartItemCard extends StatefulWidget {
  /// Creates a cart item card.
  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  /// The cart item to display.
  final CartItemModel item;

  /// Callback when quantity changes.
  final Function(int) onQuantityChanged;

  /// Callback when item is removed.
  final VoidCallback onRemove;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    final card = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: SneakerAnimations.fast,
        padding: SneakerSpacing.allLg,
        decoration: BoxDecoration(
          color: _isHovered
              ? SneakerColors.surfaceDark
              : SneakerColors.surfaceDark.withValues(alpha: 0.5),
          borderRadius: SneakerRadii.radiusLg,
          border: Border.all(
            color: _isHovered ? SneakerColors.border : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            const SizedBox(width: SneakerSpacing.lg),
            Expanded(child: _buildDetails()),
            if (!isMobile) ...[
              const SizedBox(width: SneakerSpacing.lg),
              _buildRemoveButton(),
            ],
          ],
        ),
      ),
    );

    // Wrap with Dismissible on mobile for swipe-to-remove
    if (isMobile) {
      return Dismissible(
        key: ValueKey(widget.item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => widget.onRemove(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: SneakerSpacing.horizontalXl,
          decoration: BoxDecoration(
            color: SneakerColors.burgundy,
            borderRadius: SneakerRadii.radiusLg,
          ),
          child: const Icon(
            Icons.delete_outline,
            color: SneakerColors.cream,
            size: 28,
          ),
        ),
        child: card,
      );
    }

    return card;
  }

  Widget _buildThumbnail() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: SneakerColors.darkBurgundy,
        borderRadius: SneakerRadii.radiusMd,
        boxShadow: [
          BoxShadow(
            color: SneakerColors.burgundy.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: SneakerRadii.radiusMd,
        child: Image.network(
          widget.item.sneaker.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.sports_basketball,
        color: SneakerColors.slateGrey,
        size: 32,
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product name
        Text(
          widget.item.sneaker.displayName,
          style: SneakerTypography.cardTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: SneakerSpacing.xs),

        // Size
        Text(
          widget.item.formattedSize,
          style: SneakerTypography.description.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.md),

        // Price and quantity row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Line total price
            AnimatedSwitcher(
              duration: SneakerAnimations.fast,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                '\$${widget.item.lineTotal.toStringAsFixed(0)}',
                key: ValueKey(widget.item.lineTotal),
                style: SneakerTypography.price.copyWith(
                  color: SneakerColors.cream,
                  fontWeight: SneakerTypography.extraBold,
                ),
              ),
            ),

            // Quantity stepper
            QuantityStepper(
              quantity: widget.item.quantity,
              onChanged: widget.onQuantityChanged,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return AnimatedOpacity(
      duration: SneakerAnimations.fast,
      opacity: _isHovered ? 1.0 : 0.0,
      child: IconButton(
        onPressed: widget.onRemove,
        icon: const Icon(Icons.close),
        color: SneakerColors.slateGrey,
        hoverColor: SneakerColors.burgundy.withValues(alpha: 0.2),
        tooltip: 'Remove from cart',
        iconSize: 20,
      ),
    );
  }
}
