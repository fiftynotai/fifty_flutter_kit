/// **OrderModel**
///
/// Represents a completed or pending order in the checkout flow.
///
/// Contains all cart items, pricing breakdown, and order status tracking.
///
/// **Example Usage:**
/// ```dart
/// final order = OrderModel(
///   id: 'ORD-2024-001',
///   items: cartItems,
///   subtotal: 1300.0,
///   shipping: 15.0,
///   tax: 104.0,
///   total: 1419.0,
///   status: OrderStatus.pending,
///   createdAt: DateTime.now(),
/// );
/// ```
library;

import 'cart_item_model.dart';

/// Status of an order in the fulfillment pipeline.
///
/// - [pending]: Order placed, awaiting payment confirmation
/// - [processing]: Payment confirmed, preparing for shipment
/// - [shipped]: Order has been dispatched
/// - [delivered]: Order has been delivered to customer
enum OrderStatus {
  /// Order placed, awaiting payment confirmation.
  pending,

  /// Payment confirmed, preparing for shipment.
  processing,

  /// Order has been dispatched.
  shipped,

  /// Order has been delivered to customer.
  delivered,
}

/// **OrderModel**
///
/// Immutable data model representing a customer order.
///
/// Contains the complete order state including items, pricing breakdown,
/// status tracking, and timestamps.
class OrderModel {
  /// Unique identifier for this order.
  final String id;

  /// List of items in this order.
  final List<CartItemModel> items;

  /// Sum of all line item totals before shipping and tax.
  final double subtotal;

  /// Shipping cost.
  final double shipping;

  /// Tax amount.
  final double tax;

  /// Total amount due (subtotal + shipping + tax).
  final double total;

  /// Current status of the order.
  final OrderStatus status;

  /// Timestamp when the order was created.
  final DateTime createdAt;

  /// Optional tracking number once shipped.
  final String? trackingNumber;

  /// Optional estimated delivery date.
  final DateTime? estimatedDelivery;

  /// Creates an [OrderModel] with the specified parameters.
  const OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    this.trackingNumber,
    this.estimatedDelivery,
  });

  /// Total number of items in the order.
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Whether the order can be cancelled (only pending orders).
  bool get canCancel => status == OrderStatus.pending;

  /// Whether the order is in a final state (delivered).
  bool get isComplete => status == OrderStatus.delivered;

  /// Human-readable status string.
  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  /// Creates a copy of this [OrderModel] with the given fields replaced.
  OrderModel copyWith({
    String? id,
    List<CartItemModel>? items,
    double? subtotal,
    double? shipping,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    String? trackingNumber,
    DateTime? estimatedDelivery,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
    );
  }

  /// Creates an [OrderModel] from a JSON map.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      trackingNumber: json['trackingNumber'] as String?,
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'] as String)
          : null,
    );
  }

  /// Converts this [OrderModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (estimatedDelivery != null)
        'estimatedDelivery': estimatedDelivery!.toIso8601String(),
    };
  }

  /// Creates a new order from cart items with calculated totals.
  ///
  /// **Parameters:**
  /// - [id]: Unique order identifier
  /// - [items]: Cart items to include in order
  /// - [taxRate]: Tax rate as decimal (e.g., 0.08 for 8%)
  /// - [shippingCost]: Flat shipping cost
  factory OrderModel.fromCart({
    required String id,
    required List<CartItemModel> items,
    double taxRate = 0.08,
    double shippingCost = 15.0,
  }) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.lineTotal);
    final tax = subtotal * taxRate;
    final total = subtotal + shippingCost + tax;

    return OrderModel(
      id: id,
      items: items,
      subtotal: subtotal,
      shipping: shippingCost,
      tax: tax,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'OrderModel(id: $id, items: $itemCount, total: \$$total, status: $statusLabel)';
}
