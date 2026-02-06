import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/cart_item_model.dart';
import 'cart_item_card.dart';
import 'cart_summary.dart';
import 'empty_cart_state.dart';

/// **CartDrawer**
///
/// Slide-in cart drawer with glassmorphism effect.
///
/// Features:
/// - Slides from right side of screen
/// - Glassmorphism background (90% opacity, blur 20)
/// - Width: 400px on desktop, full-width on mobile
/// - Sticky checkout button at bottom
/// - Scrollable cart items list
/// - Empty state when cart is empty
///
/// **Example Usage:**
/// ```dart
/// CartDrawer(
///   items: cartItems,
///   onClose: () => closeDrawer(),
///   onCheckout: () => navigateToCheckout(),
///   onQuantityChanged: (item, qty) => updateQuantity(item, qty),
///   onRemove: (item) => removeFromCart(item),
/// )
/// ```
class CartDrawer extends StatelessWidget {
  /// Creates a cart drawer widget.
  const CartDrawer({
    super.key,
    required this.items,
    required this.onClose,
    required this.onCheckout,
    required this.onQuantityChanged,
    required this.onRemove,
    this.taxRate = 0.08,
    this.freeShippingThreshold = 200.0,
    this.shippingCost = 15.0,
  });

  /// List of items in the cart.
  final List<CartItemModel> items;

  /// Callback when close button is tapped.
  final VoidCallback onClose;

  /// Callback when checkout button is tapped.
  final VoidCallback onCheckout;

  /// Callback when item quantity changes.
  final Function(CartItemModel, int) onQuantityChanged;

  /// Callback when item is removed.
  final Function(CartItemModel) onRemove;

  /// Tax rate for calculations (default 8%).
  final double taxRate;

  /// Threshold for free shipping.
  final double freeShippingThreshold;

  /// Shipping cost if below threshold.
  final double shippingCost;

  /// Desktop drawer width.
  static const double _desktopWidth = 400.0;

  /// Mobile breakpoint.
  static const double _mobileBreakpoint = 768.0;

  /// Calculate subtotal from all items.
  double get _subtotal => items.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Calculate shipping (free if above threshold).
  double get _shipping => _subtotal >= freeShippingThreshold ? 0.0 : shippingCost;

  /// Calculate tax.
  double get _tax => _subtotal * taxRate;

  /// Total item count.
  int get _itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < _mobileBreakpoint;
    final drawerWidth = isMobile ? screenWidth : _desktopWidth;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: isMobile
              ? BorderRadius.zero
              : const BorderRadius.only(
                  topLeft: Radius.circular(SneakerRadii.xl),
                  bottomLeft: Radius.circular(SneakerRadii.xl),
                ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: drawerWidth,
              height: double.infinity,
              decoration: BoxDecoration(
                color: SneakerColors.glassBackgroundStrong,
                border: isMobile
                    ? null
                    : Border(
                        left: BorderSide(
                          color: SneakerColors.glassBorder,
                          width: 1,
                        ),
                      ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: items.isEmpty
                          ? EmptyCartState(onStartShopping: onClose)
                          : _buildItemsList(),
                    ),
                    if (items.isNotEmpty) _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SneakerColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'YOUR CART',
                style: SneakerTypography.cardTitle.copyWith(
                  letterSpacing: 2,
                ),
              ),
              if (_itemCount > 0) ...[
                const SizedBox(width: SneakerSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SneakerSpacing.sm,
                    vertical: SneakerSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: SneakerColors.burgundy,
                    borderRadius: SneakerRadii.radiusFull,
                  ),
                  child: Text(
                    _itemCount.toString(),
                    style: SneakerTypography.badge.copyWith(
                      color: SneakerColors.cream,
                    ),
                  ),
                ),
              ],
            ],
          ),
          _CloseButton(onTap: onClose),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      padding: SneakerSpacing.allLg,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: SneakerSpacing.md,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(
          item: item,
          onQuantityChanged: (qty) => onQuantityChanged(item, qty),
          onRemove: () => onRemove(item),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: SneakerColors.border,
            width: 1,
          ),
        ),
      ),
      child: CartSummary(
        subtotal: _subtotal,
        shipping: _shipping,
        tax: _tax,
        onCheckout: onCheckout,
      ),
    );
  }
}

/// Internal close button widget.
class _CloseButton extends StatefulWidget {
  const _CloseButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Close cart',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
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
              color: _isHovered ? SneakerColors.cream : SneakerColors.slateGrey,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
