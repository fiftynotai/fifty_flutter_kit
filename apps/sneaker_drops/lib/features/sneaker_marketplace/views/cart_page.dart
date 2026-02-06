import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/route_manager.dart';
import '../../../core/theme/sneaker_colors.dart';
import '../../../core/theme/sneaker_radii.dart';
import '../../../core/theme/sneaker_spacing.dart';
import '../../../core/theme/sneaker_typography.dart';
import '../controllers/cart_view_model.dart';
import 'widgets/cart/cart_item_card.dart';
import 'widgets/cart/cart_summary.dart';
import 'widgets/cart/empty_cart_state.dart';
import 'widgets/navigation/glass_nav_bar.dart';

/// **CartPage**
///
/// Shopping cart page (full page, not drawer).
///
/// Layout:
/// - GlassNavBar
/// - Page title with item count
/// - Cart items list (using CartItemCard)
/// - Order summary sidebar (desktop) or bottom (mobile)
/// - Empty state when no items
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  /// Gets or creates the CartViewModel.
  CartViewModel get _cartVM {
    if (!Get.isRegistered<CartViewModel>()) {
      Get.put(CartViewModel());
    }
    return Get.find<CartViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SneakerColors.darkBurgundy,
      body: SafeArea(
        child: Column(
          children: [
            // Navigation bar
            _buildNavBar(),

            // Content
            Expanded(
              child: Obx(() {
                if (_cartVM.isEmpty) {
                  return EmptyCartState(
                    onStartShopping: () => RouteManager.toCatalog(),
                  );
                }
                return _buildCartContent(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Obx(() => GlassNavBar(
          cartItemCount: _cartVM.itemCount,
          onCartTap: () {}, // Already on cart page
          onNavigate: (route) => RouteManager.to(route),
        ));
  }

  Widget _buildCartContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _buildDesktopLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: SneakerSpacing.pageDesktop,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart items (left)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: SneakerSpacing.xxl),
                Expanded(
                  child: _buildCartItemsList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: SneakerSpacing.xxxl),

          // Order summary (right)
          SizedBox(
            width: 360,
            child: Obx(() => CartSummary(
                  subtotal: _cartVM.subtotal,
                  shipping: _cartVM.shipping,
                  tax: _cartVM.tax,
                  onCheckout: () => RouteManager.toCheckout(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Header
        Padding(
          padding: SneakerSpacing.horizontalLg,
          child: _buildHeader(),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Cart items
        Expanded(
          child: Padding(
            padding: SneakerSpacing.horizontalLg,
            child: _buildCartItemsList(),
          ),
        ),

        // Order summary (bottom)
        Container(
          decoration: BoxDecoration(
            color: SneakerColors.surfaceDark,
            border: Border(
              top: BorderSide(color: SneakerColors.border),
            ),
          ),
          padding: SneakerSpacing.allLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary row
              Obx(() => _buildMobileSummary()),
              const SizedBox(height: SneakerSpacing.lg),

              // Checkout button
              _CheckoutButtonMobile(
                onPressed: () => RouteManager.toCheckout(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => RouteManager.back(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: SneakerColors.slateGrey,
            ),
          ),
        ),
        const SizedBox(width: SneakerSpacing.lg),

        // Title
        Text(
          'YOUR CART',
          style: SneakerTypography.sectionTitle.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: SneakerSpacing.md),

        // Item count badge
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: SneakerColors.burgundy.withValues(alpha: 0.2),
                borderRadius: SneakerRadii.radiusFull,
              ),
              child: Text(
                '${_cartVM.itemCount} ${_cartVM.itemCount == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: SneakerTypography.semiBold,
                  color: SneakerColors.cream,
                ),
              ),
            )),

        const Spacer(),

        // Clear cart button
        Obx(() => _cartVM.isNotEmpty
            ? GestureDetector(
                onTap: () => _showClearCartDialog(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'CLEAR ALL',
                    style: SneakerTypography.label.copyWith(
                      color: SneakerColors.slateGrey,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCartItemsList() {
    return Obx(() => ListView.separated(
          itemCount: _cartVM.items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: SneakerSpacing.md),
          itemBuilder: (context, index) {
            final item = _cartVM.items[index];
            return CartItemCard(
              item: item,
              onQuantityChanged: (qty) => _cartVM.updateQuantity(item, qty),
              onRemove: () => _cartVM.removeItem(item),
            );
          },
        ));
  }

  Widget _buildMobileSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total',
              style: SneakerTypography.description.copyWith(
                color: SneakerColors.slateGrey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${_cartVM.total.toStringAsFixed(2)}',
              style: SneakerTypography.sectionTitle,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_cartVM.shipping == 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: SneakerColors.hunterGreen.withValues(alpha: 0.2),
                  borderRadius: SneakerRadii.radiusSm,
                ),
                child: Text(
                  'FREE SHIPPING',
                  style: TextStyle(
                    fontFamily: SneakerTypography.fontFamily,
                    fontSize: 10,
                    fontWeight: SneakerTypography.bold,
                    color: SneakerColors.hunterGreen,
                    letterSpacing: 1,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Tax: \$${_cartVM.tax.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: SneakerTypography.fontFamily,
                fontSize: 11,
                color: SneakerColors.slateGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showClearCartDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: SneakerColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: SneakerRadii.radiusLg,
          side: BorderSide(color: SneakerColors.border),
        ),
        title: Text(
          'Clear Cart?',
          style: SneakerTypography.cardTitle,
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: SneakerTypography.description.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'CANCEL',
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.slateGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _cartVM.clear();
              Get.back();
            },
            child: Text(
              'CLEAR',
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.burgundy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal mobile checkout button.
class _CheckoutButtonMobile extends StatefulWidget {
  final VoidCallback onPressed;

  const _CheckoutButtonMobile({required this.onPressed});

  @override
  State<_CheckoutButtonMobile> createState() => _CheckoutButtonMobileState();
}

class _CheckoutButtonMobileState extends State<_CheckoutButtonMobile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        padding: SneakerSpacing.allLg,
        decoration: BoxDecoration(
          gradient: SneakerColors.grailGradient,
          borderRadius: SneakerRadii.radiusMd,
          boxShadow: [
            BoxShadow(
              color: SneakerColors.burgundy.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        transform: Matrix4.identity()
          ..setEntry(0, 0, _isPressed ? 0.98 : 1.0)
          ..setEntry(1, 1, _isPressed ? 0.98 : 1.0),
        child: Text(
          'CHECKOUT',
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.cream,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
