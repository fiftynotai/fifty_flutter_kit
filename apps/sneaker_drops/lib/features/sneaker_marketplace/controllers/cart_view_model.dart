import 'package:get/get.dart';

import '../data/models/cart_item_model.dart';
import '../data/models/sneaker_model.dart';

/// **CartViewModel**
///
/// ViewModel for cart state management using GetX reactive state.
///
/// Manages the shopping cart state including items, quantities, and totals.
/// Provides computed properties for pricing breakdown and methods for
/// cart manipulation.
///
/// **Example Usage:**
/// ```dart
/// final cartVM = Get.find<CartViewModel>();
/// cartVM.addItem(sneaker, size: 10.0);
/// print(cartVM.total); // 650.0
/// ```
class CartViewModel extends GetxController {
  /// Internal list of cart items.
  final RxList<CartItemModel> _items = <CartItemModel>[].obs;

  /// Loading state for async operations.
  final RxBool _isLoading = false.obs;

  /// Error message if any operation fails.
  final RxnString _error = RxnString();

  // ============================================================
  // GETTERS
  // ============================================================

  /// Observable list of cart items.
  List<CartItemModel> get items => _items;

  /// Whether the cart is loading.
  bool get isLoading => _isLoading.value;

  /// Current error message, if any.
  String? get error => _error.value;

  /// Whether the cart is empty.
  bool get isEmpty => _items.isEmpty;

  /// Whether the cart has items.
  bool get isNotEmpty => _items.isNotEmpty;

  /// Total number of items (considering quantities).
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Number of unique items in cart.
  int get uniqueItemCount => _items.length;

  // ============================================================
  // COMPUTED PRICING
  // ============================================================

  /// Subtotal before shipping and tax.
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Shipping cost.
  /// Free shipping over $500, otherwise $15 flat rate.
  double get shipping => subtotal >= 500 ? 0.0 : 15.0;

  /// Tax amount (8% of subtotal).
  double get tax => subtotal * 0.08;

  /// Total amount due.
  double get total => subtotal + shipping + tax;

  /// Tax rate as percentage.
  static const double taxRate = 0.08;

  /// Free shipping threshold.
  static const double freeShippingThreshold = 500.0;

  /// Flat shipping rate when under threshold.
  static const double flatShippingRate = 15.0;

  // ============================================================
  // CART OPERATIONS
  // ============================================================

  /// Adds a sneaker to the cart with the selected size.
  ///
  /// If the same sneaker/size combination already exists, increments quantity.
  /// Otherwise, creates a new cart item.
  ///
  /// **Parameters:**
  /// - [sneaker]: The sneaker to add
  /// - [size]: The selected size
  /// - [quantity]: Initial quantity (default: 1)
  void addItem(SneakerModel sneaker, {required double size, int quantity = 1}) {
    // Check if item already exists with same sneaker and size
    final existingIndex = _items.indexWhere(
      (item) => item.sneaker.id == sneaker.id && item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      // Add new item
      final newItem = CartItemModel(
        id: _generateCartItemId(),
        sneaker: sneaker,
        selectedSize: size,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      _items.add(newItem);
    }
  }

  /// Removes an item from the cart.
  ///
  /// **Parameters:**
  /// - [item]: The cart item to remove
  void removeItem(CartItemModel item) {
    _items.removeWhere((i) => i.id == item.id);
  }

  /// Removes an item by its ID.
  ///
  /// **Parameters:**
  /// - [itemId]: The cart item ID to remove
  void removeItemById(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
  }

  /// Updates the quantity of an item.
  ///
  /// If quantity is 0 or less, removes the item from cart.
  ///
  /// **Parameters:**
  /// - [item]: The cart item to update
  /// - [quantity]: The new quantity
  void updateQuantity(CartItemModel item, int quantity) {
    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
  }

  /// Increments the quantity of an item by 1.
  ///
  /// **Parameters:**
  /// - [item]: The cart item to increment
  void incrementQuantity(CartItemModel item) {
    updateQuantity(item, item.quantity + 1);
  }

  /// Decrements the quantity of an item by 1.
  /// Removes item if quantity reaches 0.
  ///
  /// **Parameters:**
  /// - [item]: The cart item to decrement
  void decrementQuantity(CartItemModel item) {
    updateQuantity(item, item.quantity - 1);
  }

  /// Clears all items from the cart.
  void clear() {
    _items.clear();
    _error.value = null;
  }

  /// Checks if a specific sneaker/size combination is in the cart.
  ///
  /// **Parameters:**
  /// - [sneakerId]: The sneaker ID to check
  /// - [size]: The size to check
  ///
  /// **Returns:** True if the combination exists in cart.
  bool containsItem(String sneakerId, double size) {
    return _items.any(
      (item) => item.sneaker.id == sneakerId && item.selectedSize == size,
    );
  }

  /// Gets the quantity of a specific sneaker/size combination.
  ///
  /// **Parameters:**
  /// - [sneakerId]: The sneaker ID
  /// - [size]: The size
  ///
  /// **Returns:** Quantity in cart, or 0 if not found.
  int getQuantity(String sneakerId, double size) {
    final item = _items.firstWhereOrNull(
      (item) => item.sneaker.id == sneakerId && item.selectedSize == size,
    );
    return item?.quantity ?? 0;
  }

  // ============================================================
  // INTERNAL HELPERS
  // ============================================================

  /// Generates a unique cart item ID.
  String _generateCartItemId() {
    return 'cart-${DateTime.now().millisecondsSinceEpoch}-${_items.length}';
  }

  /// Sets loading state.
  void setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Sets error state.
  void setError(String? message) {
    _error.value = message;
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    // Could load persisted cart from local storage here
  }

  @override
  void onClose() {
    // Could persist cart to local storage here
    super.onClose();
  }
}
