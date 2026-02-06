import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **CartSummary**
///
/// Order summary panel for cart/checkout displaying pricing breakdown.
///
/// Features:
/// - Subtotal display
/// - Shipping cost (calculated or "Free" indicator)
/// - Tax calculation
/// - Total (highlighted with emphasis)
/// - Checkout CTA button
///
/// **Example Usage:**
/// ```dart
/// CartSummary(
///   subtotal: 549.00,
///   shipping: 0.0,
///   tax: 45.00,
///   checkoutLabel: 'CHECKOUT',
///   onCheckout: () => navigateToCheckout(),
/// )
/// ```
class CartSummary extends StatelessWidget {
  /// Creates a cart summary panel.
  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.onCheckout,
    this.checkoutLabel = 'CHECKOUT',
    this.isLoading = false,
  });

  /// Subtotal before shipping and tax.
  final double subtotal;

  /// Shipping cost (0 for free shipping).
  final double shipping;

  /// Tax amount.
  final double tax;

  /// Label for checkout button.
  final String checkoutLabel;

  /// Callback when checkout button is pressed.
  final VoidCallback onCheckout;

  /// Whether checkout is in progress.
  final bool isLoading;

  /// Calculated total.
  double get total => subtotal + shipping + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusLg,
        border: Border.all(
          color: SneakerColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'ORDER SUMMARY',
            style: SneakerTypography.label.copyWith(
              color: SneakerColors.slateGrey,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: SneakerSpacing.lg),

          // Subtotal
          _SummaryRow(
            label: 'Subtotal',
            value: _formatCurrency(subtotal),
          ),
          const SizedBox(height: SneakerSpacing.md),

          // Shipping
          _SummaryRow(
            label: 'Shipping',
            value: shipping == 0 ? 'FREE' : _formatCurrency(shipping),
            valueColor: shipping == 0 ? SneakerColors.hunterGreen : null,
          ),
          const SizedBox(height: SneakerSpacing.md),

          // Tax
          _SummaryRow(
            label: 'Tax',
            value: _formatCurrency(tax),
          ),

          // Divider
          Padding(
            padding: SneakerSpacing.verticalLg,
            child: Divider(
              color: SneakerColors.border,
              height: 1,
            ),
          ),

          // Total
          _SummaryRow(
            label: 'Total',
            value: _formatCurrency(total),
            isTotal: true,
          ),
          const SizedBox(height: SneakerSpacing.xxl),

          // Checkout button
          _CheckoutButton(
            label: checkoutLabel,
            onPressed: onCheckout,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}

/// Internal row for summary line items.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? SneakerTypography.cardTitle
              : SneakerTypography.description.copyWith(
                  color: SneakerColors.slateGrey,
                ),
        ),
        AnimatedSwitcher(
          duration: SneakerAnimations.fast,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            value,
            key: ValueKey(value),
            style: isTotal
                ? SneakerTypography.sectionTitle.copyWith(
                    color: SneakerColors.cream,
                  )
                : SneakerTypography.description.copyWith(
                    color: valueColor ?? SneakerColors.cream,
                    fontWeight: SneakerTypography.medium,
                  ),
          ),
        ),
      ],
    );
  }
}

/// Internal checkout button with hover effect.
class _CheckoutButton extends StatefulWidget {
  const _CheckoutButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<_CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<_CheckoutButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.label,
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: SneakerAnimations.fast,
            padding: SneakerSpacing.allLg,
            decoration: BoxDecoration(
              gradient: SneakerColors.grailGradient,
              borderRadius: SneakerRadii.radiusMd,
              boxShadow: _isHovered && !widget.isLoading
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
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(SneakerColors.cream),
                      ),
                    )
                  : Text(
                      widget.label,
                      style: SneakerTypography.label.copyWith(
                        color: SneakerColors.cream,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
