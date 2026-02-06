import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/animations/animation_constants.dart';
import '../../../core/routes/route_manager.dart';
import '../../../core/theme/sneaker_colors.dart';
import '../../../core/theme/sneaker_radii.dart';
import '../../../core/theme/sneaker_spacing.dart';
import '../../../core/theme/sneaker_typography.dart';
import '../controllers/cart_view_model.dart';
import '../data/models/order_model.dart';
import 'widgets/cart/cart_item_card.dart';
import 'widgets/cart/cart_summary.dart';
import 'widgets/checkout/checkout_stepper.dart';
import 'widgets/checkout/order_confirmation.dart';
import 'widgets/navigation/glass_nav_bar.dart';

/// **CheckoutPage**
///
/// Checkout flow with progress stepper.
///
/// Steps:
/// 1. Cart Review
/// 2. Shipping Info
/// 3. Payment
/// 4. Confirmation
///
/// Each step slides in from right.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  /// Current checkout step (0-3).
  int _currentStep = 0;

  /// Whether order is being placed.
  bool _isPlacingOrder = false;

  /// Completed order (after payment).
  OrderModel? _completedOrder;

  /// Step labels.
  static const List<String> _stepLabels = [
    'Review',
    'Shipping',
    'Payment',
    'Confirm',
  ];

  /// Form key for shipping info.
  final _shippingFormKey = GlobalKey<FormState>();

  /// Shipping form controllers.
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  /// Payment form controllers.
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  /// Cart view model.
  CartViewModel get _cartVM {
    if (!Get.isRegistered<CartViewModel>()) {
      Get.put(CartViewModel());
    }
    return Get.find<CartViewModel>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  /// Advances to the next step.
  void _nextStep() {
    if (_currentStep < 3) {
      // Validate shipping form before proceeding
      if (_currentStep == 1) {
        if (!_shippingFormKey.currentState!.validate()) return;
      }

      setState(() => _currentStep++);

      // If we're on payment step (2), place order when clicking next
      if (_currentStep == 3) {
        _placeOrder();
      }
    }
  }

  /// Goes back to the previous step.
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  /// Places the order.
  Future<void> _placeOrder() async {
    setState(() => _isPlacingOrder = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Create order
    final order = OrderModel.fromCart(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      items: _cartVM.items,
    );

    // Clear cart
    _cartVM.clear();

    setState(() {
      _completedOrder = order;
      _isPlacingOrder = false;
    });
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
              child: _completedOrder != null
                  ? OrderConfirmation(
                      order: _completedOrder!,
                      onContinueShopping: () => RouteManager.toCatalog(),
                    )
                  : _buildCheckoutContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Obx(() => GlassNavBar(
          cartItemCount: _cartVM.itemCount,
          onCartTap: () => RouteManager.toCart(),
          onNavigate: (route) => RouteManager.to(route),
        ));
  }

  Widget _buildCheckoutContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: isDesktop
              ? SneakerSpacing.pageDesktop
              : SneakerSpacing.pageMobile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              _buildHeader(),
              const SizedBox(height: SneakerSpacing.xxl),

              // Stepper
              CheckoutStepper(
                currentStep: _currentStep,
                steps: _stepLabels,
                onStepTap: (step) {
                  if (step < _currentStep) {
                    setState(() => _currentStep = step);
                  }
                },
              ),
              const SizedBox(height: SneakerSpacing.xxxl),

              // Step content
              if (isDesktop)
                _buildDesktopLayout()
              else
                _buildMobileLayout(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: _currentStep > 0 ? _previousStep : () => RouteManager.back(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: SneakerColors.slateGrey,
                ),
                const SizedBox(width: SneakerSpacing.sm),
                Text(
                  _currentStep > 0 ? 'BACK' : 'CART',
                  style: SneakerTypography.label.copyWith(
                    color: SneakerColors.slateGrey,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: SneakerSpacing.xxl),

        // Title
        Text(
          'CHECKOUT',
          style: SneakerTypography.sectionTitle.copyWith(
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step content (left)
        Expanded(
          flex: 3,
          child: _buildStepContent(),
        ),
        const SizedBox(width: SneakerSpacing.xxxl),

        // Order summary (right)
        SizedBox(
          width: 360,
          child: Column(
            children: [
              Obx(() => CartSummary(
                    subtotal: _cartVM.subtotal,
                    shipping: _cartVM.shipping,
                    tax: _cartVM.tax,
                    checkoutLabel: _getCheckoutButtonLabel(),
                    onCheckout: _nextStep,
                    isLoading: _isPlacingOrder,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Step content
        _buildStepContent(),
        const SizedBox(height: SneakerSpacing.xxxl),

        // Continue button
        _ContinueButton(
          label: _getCheckoutButtonLabel(),
          onPressed: _nextStep,
          isLoading: _isPlacingOrder,
        ),
      ],
    );
  }

  String _getCheckoutButtonLabel() {
    switch (_currentStep) {
      case 0:
        return 'CONTINUE TO SHIPPING';
      case 1:
        return 'CONTINUE TO PAYMENT';
      case 2:
        return 'PLACE ORDER';
      default:
        return 'CONTINUE';
    }
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: SneakerAnimations.medium,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_currentStep),
        child: _getStepWidget(),
      ),
    );
  }

  Widget _getStepWidget() {
    switch (_currentStep) {
      case 0:
        return _buildCartReviewStep();
      case 1:
        return _buildShippingStep();
      case 2:
        return _buildPaymentStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCartReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REVIEW YOUR ORDER',
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.slateGrey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Cart items
        Obx(() => Column(
              children: _cartVM.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: SneakerSpacing.md),
                  child: CartItemCard(
                    item: item,
                    onQuantityChanged: (qty) => _cartVM.updateQuantity(item, qty),
                    onRemove: () => _cartVM.removeItem(item),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildShippingStep() {
    return Form(
      key: _shippingFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHIPPING INFORMATION',
            style: SneakerTypography.label.copyWith(
              color: SneakerColors.slateGrey,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: SneakerSpacing.lg),

          _CheckoutTextField(
            controller: _nameController,
            label: 'Full Name',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: SneakerSpacing.md),

          _CheckoutTextField(
            controller: _emailController,
            label: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: SneakerSpacing.md),

          _CheckoutTextField(
            controller: _phoneController,
            label: 'Phone Number',
            keyboardType: TextInputType.phone,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: SneakerSpacing.md),

          _CheckoutTextField(
            controller: _addressController,
            label: 'Street Address',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: SneakerSpacing.md),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _CheckoutTextField(
                  controller: _cityController,
                  label: 'City',
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: SneakerSpacing.md),
              Expanded(
                child: _CheckoutTextField(
                  controller: _zipController,
                  label: 'ZIP Code',
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT DETAILS',
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.slateGrey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Security note
        Container(
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
                Icons.lock_outline_rounded,
                size: 18,
                color: SneakerColors.hunterGreen,
              ),
              const SizedBox(width: SneakerSpacing.sm),
              Text(
                'Your payment information is encrypted and secure',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontSize: 12,
                  color: SneakerColors.hunterGreen,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SneakerSpacing.xxl),

        _CheckoutTextField(
          controller: _cardNumberController,
          label: 'Card Number',
          keyboardType: TextInputType.number,
          hintText: '4242 4242 4242 4242',
        ),
        const SizedBox(height: SneakerSpacing.md),

        Row(
          children: [
            Expanded(
              child: _CheckoutTextField(
                controller: _expiryController,
                label: 'Expiry Date',
                hintText: 'MM/YY',
              ),
            ),
            const SizedBox(width: SneakerSpacing.md),
            Expanded(
              child: _CheckoutTextField(
                controller: _cvvController,
                label: 'CVV',
                obscureText: true,
                hintText: '123',
              ),
            ),
          ],
        ),
        const SizedBox(height: SneakerSpacing.xxl),

        // Demo note
        Container(
          padding: SneakerSpacing.allMd,
          decoration: BoxDecoration(
            color: SneakerColors.warning.withValues(alpha: 0.15),
            borderRadius: SneakerRadii.radiusMd,
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: SneakerColors.warning,
              ),
              const SizedBox(width: SneakerSpacing.sm),
              Expanded(
                child: Text(
                  'Demo mode: No real payment will be processed',
                  style: TextStyle(
                    fontFamily: SneakerTypography.fontFamily,
                    fontSize: 12,
                    color: SneakerColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Internal text field for checkout forms.
class _CheckoutTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _CheckoutTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 11,
            fontWeight: SneakerTypography.semiBold,
            letterSpacing: 1,
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            color: SneakerColors.cream,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              color: SneakerColors.slateGrey.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: SneakerColors.surfaceDark,
            border: OutlineInputBorder(
              borderRadius: SneakerRadii.radiusMd,
              borderSide: BorderSide(color: SneakerColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: SneakerRadii.radiusMd,
              borderSide: BorderSide(color: SneakerColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: SneakerRadii.radiusMd,
              borderSide: BorderSide(color: SneakerColors.burgundy),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: SneakerRadii.radiusMd,
              borderSide: BorderSide(color: SneakerColors.burgundy),
            ),
            contentPadding: SneakerSpacing.allMd,
          ),
        ),
      ],
    );
  }
}

/// Internal continue button for mobile layout.
class _ContinueButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const _ContinueButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          width: double.infinity,
          padding: SneakerSpacing.allLg,
          decoration: BoxDecoration(
            gradient: SneakerColors.grailGradient,
            borderRadius: SneakerRadii.radiusMd,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: SneakerColors.burgundy.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
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
    );
  }
}
