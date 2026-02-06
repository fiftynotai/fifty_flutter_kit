/// **SneakerModel**
///
/// Immutable sneaker product model representing a sneaker in the marketplace.
///
/// Contains all essential product information including pricing, sizing,
/// rarity classification, and media assets for display.
///
/// **Example Usage:**
/// ```dart
/// final sneaker = SneakerModel(
///   id: 'aj1-chicago',
///   name: 'Air Jordan 1 Retro High OG',
///   brand: 'Nike',
///   colorway: 'Chicago',
///   price: 170.0,
///   marketPrice: 650.0,
///   imageUrl: 'https://example.com/aj1-chicago.jpg',
///   images: ['angle1.jpg', 'angle2.jpg', 'angle3.jpg'],
///   sizes: [SneakerSize(size: 10.0, stock: 5)],
///   rarity: SneakerRarity.grail,
///   releaseDate: DateTime(2023, 10, 28),
///   description: 'The iconic Chicago colorway...',
///   isNew: true,
/// );
/// ```
library;

/// Rarity classification for sneakers.
///
/// - [common]: Widely available, retail pricing
/// - [rare]: Limited release, moderate markup
/// - [grail]: Highly sought after, significant markup
enum SneakerRarity {
  /// Widely available sneakers at retail pricing.
  common,

  /// Limited release sneakers with moderate price markup.
  rare,

  /// Highly sought-after sneakers with significant price markup.
  grail,
}

/// **SneakerSize**
///
/// Represents a specific size option for a sneaker product.
///
/// Tracks availability and stock count for inventory management.
class SneakerSize {
  /// The US shoe size (e.g., 9.5, 10.0, 11.0).
  final double size;

  /// Number of units in stock for this size.
  final int stock;

  /// Whether this size is currently available for purchase.
  final bool isAvailable;

  /// Creates a [SneakerSize] with the specified parameters.
  const SneakerSize({
    required this.size,
    required this.stock,
    this.isAvailable = true,
  });

  /// Creates a copy of this [SneakerSize] with the given fields replaced.
  SneakerSize copyWith({
    double? size,
    int? stock,
    bool? isAvailable,
  }) {
    return SneakerSize(
      size: size ?? this.size,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  /// Creates a [SneakerSize] from a JSON map.
  factory SneakerSize.fromJson(Map<String, dynamic> json) {
    return SneakerSize(
      size: (json['size'] as num).toDouble(),
      stock: json['stock'] as int,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  /// Converts this [SneakerSize] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'stock': stock,
      'isAvailable': isAvailable,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SneakerSize &&
        other.size == size &&
        other.stock == stock &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode => Object.hash(size, stock, isAvailable);

  @override
  String toString() => 'SneakerSize(size: $size, stock: $stock, isAvailable: $isAvailable)';
}

/// **SneakerModel**
///
/// Immutable data model representing a sneaker product.
///
/// This model contains all necessary information for displaying a sneaker
/// in the marketplace, including pricing, images, sizing, and metadata.
class SneakerModel {
  /// Unique identifier for the sneaker.
  final String id;

  /// Product name (e.g., "Air Jordan 1 Retro High OG").
  final String name;

  /// Brand name (e.g., "Nike", "Adidas", "New Balance").
  final String brand;

  /// Colorway name (e.g., "Chicago", "Bred", "Panda").
  final String colorway;

  /// Retail price in USD.
  final double price;

  /// Current market/resale price in USD.
  final double marketPrice;

  /// Primary image URL for product display.
  final String imageUrl;

  /// List of image URLs for 360-degree viewer.
  final List<String> images;

  /// Available sizes with stock information.
  final List<SneakerSize> sizes;

  /// Rarity classification affecting visual treatment.
  final SneakerRarity rarity;

  /// Original release date.
  final DateTime releaseDate;

  /// Product description text.
  final String description;

  /// Whether this is a new/recent release.
  final bool isNew;

  /// Creates a [SneakerModel] with the specified parameters.
  const SneakerModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.colorway,
    required this.price,
    required this.marketPrice,
    required this.imageUrl,
    required this.images,
    required this.sizes,
    required this.rarity,
    required this.releaseDate,
    required this.description,
    this.isNew = false,
  });

  /// Whether any size is currently in stock.
  bool get isInStock => sizes.any((s) => s.isAvailable && s.stock > 0);

  /// The price markup percentage from retail to market price.
  double get priceMarkup => ((marketPrice - price) / price) * 100;

  /// Formatted display name combining name and colorway.
  String get displayName => '$name "$colorway"';

  /// Creates a copy of this [SneakerModel] with the given fields replaced.
  SneakerModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? colorway,
    double? price,
    double? marketPrice,
    String? imageUrl,
    List<String>? images,
    List<SneakerSize>? sizes,
    SneakerRarity? rarity,
    DateTime? releaseDate,
    String? description,
    bool? isNew,
  }) {
    return SneakerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      colorway: colorway ?? this.colorway,
      price: price ?? this.price,
      marketPrice: marketPrice ?? this.marketPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      sizes: sizes ?? this.sizes,
      rarity: rarity ?? this.rarity,
      releaseDate: releaseDate ?? this.releaseDate,
      description: description ?? this.description,
      isNew: isNew ?? this.isNew,
    );
  }

  /// Creates a [SneakerModel] from a JSON map.
  factory SneakerModel.fromJson(Map<String, dynamic> json) {
    return SneakerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      colorway: json['colorway'] as String,
      price: (json['price'] as num).toDouble(),
      marketPrice: (json['marketPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      sizes: (json['sizes'] as List<dynamic>)
          .map((s) => SneakerSize.fromJson(s as Map<String, dynamic>))
          .toList(),
      rarity: SneakerRarity.values.firstWhere(
        (r) => r.name == json['rarity'],
        orElse: () => SneakerRarity.common,
      ),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      description: json['description'] as String,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  /// Converts this [SneakerModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'colorway': colorway,
      'price': price,
      'marketPrice': marketPrice,
      'imageUrl': imageUrl,
      'images': images,
      'sizes': sizes.map((s) => s.toJson()).toList(),
      'rarity': rarity.name,
      'releaseDate': releaseDate.toIso8601String(),
      'description': description,
      'isNew': isNew,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SneakerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SneakerModel(id: $id, name: $displayName, brand: $brand)';
}
