import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/route_manager.dart';
import '../../../core/theme/sneaker_colors.dart';
import '../../../core/theme/sneaker_radii.dart';
import '../../../core/theme/sneaker_spacing.dart';
import '../../../core/theme/sneaker_typography.dart';
import '../controllers/cart_view_model.dart';
import '../data/models/sneaker_model.dart';
import '../data/services/sneaker_service.dart';
import 'widgets/navigation/glass_nav_bar.dart';
import 'widgets/product/product_info_panel.dart';
import 'widgets/product/related_products.dart';
import 'widgets/product/sneaker_viewer_360.dart';

/// **ProductDetailPage**
///
/// Product detail page with 360-degree viewer and size selector.
///
/// Layout:
/// - Back button + minimal nav
/// - 360-degree viewer (left/top)
/// - Product info panel (right/bottom):
///   - Brand + Name
///   - Rarity badge
///   - Price with trend
///   - Size selector grid
///   - Add to cart button
///   - Authenticity guarantee
/// - Description section
/// - Related products carousel
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  /// Currently selected size.
  double? _selectedSize;

  /// Whether add to cart is in progress.
  bool _isAddingToCart = false;

  /// Loaded sneaker data.
  SneakerModel? _sneaker;

  /// Related sneakers.
  List<SneakerModel> _relatedSneakers = [];

  /// Whether data is loading.
  bool _isLoading = true;

  /// Error message if loading fails.
  String? _error;

  /// Sneaker service for fetching data.
  final SneakerService _sneakerService = SneakerService();

  /// Cart view model.
  CartViewModel get _cartVM {
    if (!Get.isRegistered<CartViewModel>()) {
      Get.put(CartViewModel());
    }
    return Get.find<CartViewModel>();
  }

  @override
  void initState() {
    super.initState();
    _loadSneakerData();
  }

  /// Loads sneaker data from the service.
  Future<void> _loadSneakerData() async {
    final productId = Get.parameters['id'];

    if (productId == null || productId.isEmpty) {
      setState(() {
        _error = 'Product not found';
        _isLoading = false;
      });
      return;
    }

    try {
      final sneaker = await _sneakerService.fetchSneakerById(productId);

      if (sneaker == null) {
        setState(() {
          _error = 'Product not found';
          _isLoading = false;
        });
        return;
      }

      // Load related sneakers (same brand, different product)
      final allSneakers = await _sneakerService.fetchSneakers(
        brand: sneaker.brand,
      );
      final related = allSneakers
          .where((s) => s.id != sneaker.id)
          .take(4)
          .toList();

      setState(() {
        _sneaker = sneaker;
        _relatedSneakers = related;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load product';
        _isLoading = false;
      });
    }
  }

  /// Handles add to cart action.
  Future<void> _handleAddToCart() async {
    if (_sneaker == null || _selectedSize == null) return;

    setState(() => _isAddingToCart = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _cartVM.addItem(_sneaker!, size: _selectedSize!);

    setState(() => _isAddingToCart = false);

    // Show success feedback
    _showAddedToCartSnackbar();
  }

  /// Shows success snackbar after adding to cart.
  void _showAddedToCartSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: SneakerColors.hunterGreen,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Added to cart',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  color: SneakerColors.cream,
                ),
              ),
            ),
            TextButton(
              onPressed: () => RouteManager.toCart(),
              child: Text(
                'VIEW CART',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontWeight: SneakerTypography.bold,
                  color: SneakerColors.burgundy,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: SneakerColors.surfaceDark,
        behavior: SnackBarBehavior.floating,
        margin: SneakerSpacing.allLg,
        shape: RoundedRectangleBorder(
          borderRadius: SneakerRadii.radiusMd,
          side: BorderSide(color: SneakerColors.border),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
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
              child: _isLoading
                  ? _buildLoadingState()
                  : _error != null
                      ? _buildErrorState()
                      : _buildContent(),
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

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(SneakerColors.burgundy),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: SneakerColors.slateGrey,
          ),
          const SizedBox(height: SneakerSpacing.lg),
          Text(
            _error ?? 'Something went wrong',
            style: SneakerTypography.body.copyWith(
              color: SneakerColors.slateGrey,
            ),
          ),
          const SizedBox(height: SneakerSpacing.xxl),
          TextButton(
            onPressed: () => RouteManager.back(),
            child: Text(
              'GO BACK',
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.burgundy,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final sneaker = _sneaker!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _buildDesktopLayout(sneaker);
        } else {
          return _buildMobileLayout(sneaker);
        }
      },
    );
  }

  Widget _buildDesktopLayout(SneakerModel sneaker) {
    return SingleChildScrollView(
      child: Padding(
        padding: SneakerSpacing.pageDesktop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            _buildBackButton(),
            const SizedBox(height: SneakerSpacing.xxl),

            // Main content row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 360 Viewer (left)
                Expanded(
                  flex: 3,
                  child: SneakerViewer360(
                    imageUrls: sneaker.images,
                    primaryImageUrl: sneaker.imageUrl,
                    height: 500,
                  ),
                ),
                const SizedBox(width: SneakerSpacing.xxxl),

                // Product info (right)
                Expanded(
                  flex: 2,
                  child: ProductInfoPanel(
                    sneaker: sneaker,
                    selectedSize: _selectedSize,
                    onSizeSelected: (size) => setState(() => _selectedSize = size),
                    onAddToCart: _handleAddToCart,
                    isAddingToCart: _isAddingToCart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SneakerSpacing.massive),

            // Description section
            _buildDescription(sneaker),
            const SizedBox(height: SneakerSpacing.massive),

            // Related products
            if (_relatedSneakers.isNotEmpty)
              RelatedProductsGrid(
                sneakers: _relatedSneakers,
                onSneakerTap: (s) => RouteManager.toProduct(s.id),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(SneakerModel sneaker) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          Padding(
            padding: SneakerSpacing.horizontalLg,
            child: _buildBackButton(),
          ),
          const SizedBox(height: SneakerSpacing.lg),

          // 360 Viewer
          Padding(
            padding: SneakerSpacing.horizontalLg,
            child: SneakerViewer360(
              imageUrls: sneaker.images,
              primaryImageUrl: sneaker.imageUrl,
              height: 300,
            ),
          ),
          const SizedBox(height: SneakerSpacing.xxl),

          // Product info
          Padding(
            padding: SneakerSpacing.horizontalLg,
            child: ProductInfoPanel(
              sneaker: sneaker,
              selectedSize: _selectedSize,
              onSizeSelected: (size) => setState(() => _selectedSize = size),
              onAddToCart: _handleAddToCart,
              isAddingToCart: _isAddingToCart,
            ),
          ),
          const SizedBox(height: SneakerSpacing.xxxl),

          // Description section
          Padding(
            padding: SneakerSpacing.horizontalLg,
            child: _buildDescription(sneaker),
          ),
          const SizedBox(height: SneakerSpacing.xxxl),

          // Related products
          if (_relatedSneakers.isNotEmpty)
            RelatedProducts(
              sneakers: _relatedSneakers,
              onSneakerTap: (s) => RouteManager.toProduct(s.id),
            ),

          const SizedBox(height: SneakerSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => RouteManager.back(),
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
              'BACK',
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.slateGrey,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(SneakerModel sneaker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT THIS SNEAKER',
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.slateGrey,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),
        Text(
          sneaker.description,
          style: SneakerTypography.body.copyWith(
            color: SneakerColors.cream.withValues(alpha: 0.8),
            height: 1.7,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xxl),

        // Product details
        _buildDetailRow('Release Date', _formatDate(sneaker.releaseDate)),
        _buildDetailRow('Retail Price', '\$${sneaker.price.toStringAsFixed(0)}'),
        _buildDetailRow('Style', sneaker.colorway),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SneakerSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: SneakerTypography.description.copyWith(
                color: SneakerColors.slateGrey,
              ),
            ),
          ),
          Text(
            value,
            style: SneakerTypography.description.copyWith(
              color: SneakerColors.cream,
              fontWeight: SneakerTypography.medium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
