/// **CartItemModel**
///
/// Represents an item in the shopping cart with sneaker reference,
/// selected size, and quantity information.
///
/// **Example Usage:**
/// ```dart
/// final cartItem = CartItemModel(
///   id: 'cart-001',
///   sneaker: sneakerModel,
///   selectedSize: 10.0,
///   quantity: 1,
///   addedAt: DateTime.now(),
/// );
/// ```
library;

import 'sneaker_model.dart';

/// **CartItemModel**
///
/// Immutable data model representing an item in the shopping cart.
///
/// Links a [SneakerModel] with the customer's selected size and quantity.
/// Tracks when the item was added for potential time-based features
/// (cart expiration, hold time, etc.).
class CartItemModel {
  /// Unique identifier for this cart item.
  final String id;

  /// The sneaker product in the cart.
  final SneakerModel sneaker;

  /// The size selected by the customer.
  final double selectedSize;

  /// Number of units of this sneaker/size combination.
  final int quantity;

  /// Timestamp when the item was added to cart.
  final DateTime addedAt;

  /// Creates a [CartItemModel] with the specified parameters.
  const CartItemModel({
    required this.id,
    required this.sneaker,
    required this.selectedSize,
    required this.quantity,
    required this.addedAt,
  });

  /// Total price for this line item (market price * quantity).
  double get lineTotal => sneaker.marketPrice * quantity;

  /// Formatted size string (e.g., "US 10" or "US 10.5").
  String get formattedSize {
    if (selectedSize == selectedSize.truncate()) {
      return 'US ${selectedSize.toInt()}';
    }
    return 'US $selectedSize';
  }

  /// Creates a copy of this [CartItemModel] with the given fields replaced.
  CartItemModel copyWith({
    String? id,
    SneakerModel? sneaker,
    double? selectedSize,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      sneaker: sneaker ?? this.sneaker,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Creates a [CartItemModel] from a JSON map.
  ///
  /// Note: The [sneaker] field expects a nested JSON object that will
  /// be deserialized using [SneakerModel.fromJson].
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      sneaker: SneakerModel.fromJson(json['sneaker'] as Map<String, dynamic>),
      selectedSize: (json['selectedSize'] as num).toDouble(),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Converts this [CartItemModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sneaker': sneaker.toJson(),
      'selectedSize': selectedSize,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CartItemModel(id: $id, sneaker: ${sneaker.displayName}, size: $formattedSize, qty: $quantity)';
}
