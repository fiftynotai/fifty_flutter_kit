/// **SneakerService**
///
/// Mock service providing sneaker data for the marketplace.
///
/// In production, this would connect to a backend API. For demo purposes,
/// it provides realistic mock data with simulated network delays.
///
/// **Example Usage:**
/// ```dart
/// final service = SneakerService();
/// final sneakers = await service.fetchSneakers();
/// final trending = await service.fetchTrending();
/// ```
library;

import '../models/sneaker_model.dart';

/// **SneakerService**
///
/// Service layer for fetching sneaker data.
///
/// Provides methods for listing, filtering, and fetching individual sneakers.
/// Currently uses mock data; designed to be easily swapped for real API.
class SneakerService {
  /// Simulated network delay duration.
  static const _mockDelay = Duration(milliseconds: 500);

  /// Mock sneaker inventory.
  static final List<SneakerModel> _mockSneakers = [
    SneakerModel(
      id: 'aj1-chicago',
      name: 'Air Jordan 1 Retro High OG',
      brand: 'Nike',
      colorway: 'Chicago',
      price: 180.0,
      marketPrice: 650.0,
      imageUrl: 'assets/images/sneakers/aj1_chicago.png',
      images: [
        'assets/images/sneakers/aj1_chicago_1.png',
        'assets/images/sneakers/aj1_chicago_2.png',
        'assets/images/sneakers/aj1_chicago_3.png',
        'assets/images/sneakers/aj1_chicago_4.png',
      ],
      sizes: _generateSizes(8.0, 13.0, [9.0, 10.5]),
      rarity: SneakerRarity.grail,
      releaseDate: DateTime(2022, 10, 29),
      description:
          'The Air Jordan 1 "Chicago" is one of the most iconic sneakers ever made. '
          'Originally released in 1985, this colorway features the classic red, white, '
          'and black color blocking that defined sneaker culture.',
      isNew: false,
    ),
    SneakerModel(
      id: 'aj1-bred',
      name: 'Air Jordan 1 Retro High OG',
      brand: 'Nike',
      colorway: 'Bred',
      price: 180.0,
      marketPrice: 380.0,
      imageUrl: 'assets/images/sneakers/aj1_bred.png',
      images: [
        'assets/images/sneakers/aj1_bred_1.png',
        'assets/images/sneakers/aj1_bred_2.png',
        'assets/images/sneakers/aj1_bred_3.png',
        'assets/images/sneakers/aj1_bred_4.png',
      ],
      sizes: _generateSizes(7.0, 14.0, [8.0]),
      rarity: SneakerRarity.rare,
      releaseDate: DateTime(2023, 11, 25),
      description:
          'The "Bred" (Black/Red) Air Jordan 1 is a legendary colorway that Michael Jordan '
          'wore when he was fined \$5,000 per game by the NBA for violating uniform rules. '
          'This rebellious history cemented its place in sneaker lore.',
      isNew: false,
    ),
    SneakerModel(
      id: 'dunk-low-panda',
      name: 'Dunk Low',
      brand: 'Nike',
      colorway: 'Panda',
      price: 110.0,
      marketPrice: 130.0,
      imageUrl: 'assets/images/sneakers/dunk_panda.png',
      images: [
        'assets/images/sneakers/dunk_panda_1.png',
        'assets/images/sneakers/dunk_panda_2.png',
        'assets/images/sneakers/dunk_panda_3.png',
        'assets/images/sneakers/dunk_panda_4.png',
      ],
      sizes: _generateSizes(6.0, 15.0, []),
      rarity: SneakerRarity.common,
      releaseDate: DateTime(2024, 1, 15),
      description:
          'The Nike Dunk Low "Panda" became one of the most sought-after sneakers of the decade. '
          'Its clean black and white color blocking makes it incredibly versatile and '
          'perfect for any outfit.',
      isNew: true,
    ),
    SneakerModel(
      id: 'yeezy-350-zebra',
      name: 'Yeezy Boost 350 V2',
      brand: 'Adidas',
      colorway: 'Zebra',
      price: 230.0,
      marketPrice: 320.0,
      imageUrl: 'assets/images/sneakers/yeezy_zebra.png',
      images: [
        'assets/images/sneakers/yeezy_zebra_1.png',
        'assets/images/sneakers/yeezy_zebra_2.png',
        'assets/images/sneakers/yeezy_zebra_3.png',
        'assets/images/sneakers/yeezy_zebra_4.png',
      ],
      sizes: _generateSizes(4.0, 14.0, [5.0, 6.0]),
      rarity: SneakerRarity.rare,
      releaseDate: DateTime(2023, 8, 12),
      description:
          'The Yeezy Boost 350 V2 "Zebra" features a distinctive white and black striped '
          'Primeknit upper with the iconic "SPLY-350" branding. The Boost midsole '
          'provides exceptional comfort for all-day wear.',
      isNew: false,
    ),
    SneakerModel(
      id: 'yeezy-slide-onyx',
      name: 'Yeezy Slide',
      brand: 'Adidas',
      colorway: 'Onyx',
      price: 70.0,
      marketPrice: 95.0,
      imageUrl: 'assets/images/sneakers/yeezy_slide_onyx.png',
      images: [
        'assets/images/sneakers/yeezy_slide_onyx_1.png',
        'assets/images/sneakers/yeezy_slide_onyx_2.png',
        'assets/images/sneakers/yeezy_slide_onyx_3.png',
        'assets/images/sneakers/yeezy_slide_onyx_4.png',
      ],
      sizes: _generateSlideSizes(5.0, 14.0, []),
      rarity: SneakerRarity.common,
      releaseDate: DateTime(2024, 3, 1),
      description:
          'The Yeezy Slide "Onyx" is a minimalist slide sandal made from injected EVA foam. '
          'The monochromatic black colorway and futuristic design have made it '
          'a staple for casual wear.',
      isNew: true,
    ),
    SneakerModel(
      id: 'nb-550-white-green',
      name: 'New Balance 550',
      brand: 'New Balance',
      colorway: 'White Green',
      price: 130.0,
      marketPrice: 160.0,
      imageUrl: 'assets/images/sneakers/nb_550_green.png',
      images: [
        'assets/images/sneakers/nb_550_green_1.png',
        'assets/images/sneakers/nb_550_green_2.png',
        'assets/images/sneakers/nb_550_green_3.png',
        'assets/images/sneakers/nb_550_green_4.png',
      ],
      sizes: _generateSizes(6.0, 13.0, [7.5]),
      rarity: SneakerRarity.common,
      releaseDate: DateTime(2024, 2, 14),
      description:
          'The New Balance 550 "White Green" is a retro basketball silhouette originally '
          'from 1989. Its vintage aesthetic and premium leather construction have '
          'made it a favorite among style-conscious consumers.',
      isNew: true,
    ),
    SneakerModel(
      id: 'af1-white',
      name: 'Air Force 1 Low',
      brand: 'Nike',
      colorway: 'White',
      price: 110.0,
      marketPrice: 120.0,
      imageUrl: 'assets/images/sneakers/af1_white.png',
      images: [
        'assets/images/sneakers/af1_white_1.png',
        'assets/images/sneakers/af1_white_2.png',
        'assets/images/sneakers/af1_white_3.png',
        'assets/images/sneakers/af1_white_4.png',
      ],
      sizes: _generateSizes(6.0, 15.0, []),
      rarity: SneakerRarity.common,
      releaseDate: DateTime(2024, 1, 1),
      description:
          'The Nike Air Force 1 Low "White" is the quintessential sneaker. First released '
          'in 1982, it was the first basketball shoe to feature Nike Air technology. '
          'The all-white colorway remains the most popular iteration.',
      isNew: false,
    ),
    SneakerModel(
      id: 'am90-infrared',
      name: 'Air Max 90',
      brand: 'Nike',
      colorway: 'Infrared',
      price: 140.0,
      marketPrice: 200.0,
      imageUrl: 'assets/images/sneakers/am90_infrared.png',
      images: [
        'assets/images/sneakers/am90_infrared_1.png',
        'assets/images/sneakers/am90_infrared_2.png',
        'assets/images/sneakers/am90_infrared_3.png',
        'assets/images/sneakers/am90_infrared_4.png',
      ],
      sizes: _generateSizes(7.0, 13.0, [9.5, 11.0]),
      rarity: SneakerRarity.rare,
      releaseDate: DateTime(2023, 3, 26),
      description:
          'The Air Max 90 "Infrared" is one of the most iconic colorways in Nike history. '
          'Designed by Tinker Hatfield in 1990, the visible Air unit and bold '
          'infrared accents revolutionized sneaker design.',
      isNew: false,
    ),
    SneakerModel(
      id: 'travis-scott-aj1-low',
      name: 'Air Jordan 1 Low OG',
      brand: 'Nike',
      colorway: 'Travis Scott Reverse Mocha',
      price: 150.0,
      marketPrice: 1200.0,
      imageUrl: 'assets/images/sneakers/ts_aj1_low.png',
      images: [
        'assets/images/sneakers/ts_aj1_low_1.png',
        'assets/images/sneakers/ts_aj1_low_2.png',
        'assets/images/sneakers/ts_aj1_low_3.png',
        'assets/images/sneakers/ts_aj1_low_4.png',
      ],
      sizes: _generateSizes(7.0, 13.0, [7.0, 8.0, 9.0, 10.0, 11.0]),
      rarity: SneakerRarity.grail,
      releaseDate: DateTime(2022, 7, 21),
      description:
          'The Travis Scott x Air Jordan 1 Low "Reverse Mocha" features the signature '
          'reversed Swoosh and premium materials. This collaboration between Nike and '
          'Travis Scott is one of the most hyped releases in sneaker history.',
      isNew: false,
    ),
    SneakerModel(
      id: 'samba-og-white',
      name: 'Samba OG',
      brand: 'Adidas',
      colorway: 'Cloud White',
      price: 100.0,
      marketPrice: 110.0,
      imageUrl: 'assets/images/sneakers/samba_white.png',
      images: [
        'assets/images/sneakers/samba_white_1.png',
        'assets/images/sneakers/samba_white_2.png',
        'assets/images/sneakers/samba_white_3.png',
        'assets/images/sneakers/samba_white_4.png',
      ],
      sizes: _generateSizes(6.0, 13.0, []),
      rarity: SneakerRarity.common,
      releaseDate: DateTime(2024, 4, 1),
      description:
          'The Adidas Samba OG is a timeless classic originally designed for indoor soccer '
          'in 1950. Its sleek leather upper and gum sole have made it a '
          'perennial favorite both on and off the pitch.',
      isNew: true,
    ),
  ];

  /// Generates size options from min to max with specified sold-out sizes.
  static List<SneakerSize> _generateSizes(
    double min,
    double max,
    List<double> soldOut,
  ) {
    final sizes = <SneakerSize>[];
    for (double size = min; size <= max; size += 0.5) {
      final isSoldOut = soldOut.contains(size);
      sizes.add(SneakerSize(
        size: size,
        stock: isSoldOut ? 0 : (5 + (size.toInt() % 3)),
        isAvailable: !isSoldOut,
      ));
    }
    return sizes;
  }

  /// Generates slide sizes (whole sizes only).
  static List<SneakerSize> _generateSlideSizes(
    double min,
    double max,
    List<double> soldOut,
  ) {
    final sizes = <SneakerSize>[];
    for (double size = min; size <= max; size += 1.0) {
      final isSoldOut = soldOut.contains(size);
      sizes.add(SneakerSize(
        size: size,
        stock: isSoldOut ? 0 : (3 + (size.toInt() % 5)),
        isAvailable: !isSoldOut,
      ));
    }
    return sizes;
  }

  /// Fetches all sneakers with optional filtering.
  ///
  /// **Parameters:**
  /// - [brand]: Filter by brand name (case-insensitive)
  /// - [minPrice]: Minimum market price filter
  /// - [maxPrice]: Maximum market price filter
  /// - [rarity]: Filter by rarity level
  ///
  /// **Returns:** List of sneakers matching the filters.
  Future<List<SneakerModel>> fetchSneakers({
    String? brand,
    double? minPrice,
    double? maxPrice,
    SneakerRarity? rarity,
  }) async {
    await Future.delayed(_mockDelay);

    var result = List<SneakerModel>.from(_mockSneakers);

    if (brand != null && brand.isNotEmpty) {
      result = result
          .where((s) => s.brand.toLowerCase() == brand.toLowerCase())
          .toList();
    }

    if (minPrice != null) {
      result = result.where((s) => s.marketPrice >= minPrice).toList();
    }

    if (maxPrice != null) {
      result = result.where((s) => s.marketPrice <= maxPrice).toList();
    }

    if (rarity != null) {
      result = result.where((s) => s.rarity == rarity).toList();
    }

    return result;
  }

  /// Fetches a single sneaker by ID.
  ///
  /// **Parameters:**
  /// - [id]: Unique sneaker identifier
  ///
  /// **Returns:** The sneaker if found, null otherwise.
  Future<SneakerModel?> fetchSneakerById(String id) async {
    await Future.delayed(_mockDelay);

    try {
      return _mockSneakers.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Fetches trending sneakers (highest markup from retail).
  ///
  /// **Returns:** Top 5 sneakers sorted by price markup percentage.
  Future<List<SneakerModel>> fetchTrending() async {
    await Future.delayed(_mockDelay);

    final sorted = List<SneakerModel>.from(_mockSneakers)
      ..sort((a, b) => b.priceMarkup.compareTo(a.priceMarkup));

    return sorted.take(5).toList();
  }

  /// Fetches upcoming/new releases.
  ///
  /// **Returns:** Sneakers marked as new, sorted by release date (newest first).
  Future<List<SneakerModel>> fetchUpcomingDrops() async {
    await Future.delayed(_mockDelay);

    final newReleases =
        _mockSneakers.where((s) => s.isNew).toList()
          ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

    return newReleases;
  }

  /// Fetches sneakers by brand.
  ///
  /// **Parameters:**
  /// - [brand]: Brand name to filter by
  ///
  /// **Returns:** All sneakers from the specified brand.
  Future<List<SneakerModel>> fetchByBrand(String brand) async {
    return fetchSneakers(brand: brand);
  }

  /// Fetches grail-tier sneakers only.
  ///
  /// **Returns:** All sneakers with grail rarity.
  Future<List<SneakerModel>> fetchGrails() async {
    return fetchSneakers(rarity: SneakerRarity.grail);
  }

  /// Searches sneakers by name or colorway.
  ///
  /// **Parameters:**
  /// - [query]: Search query string
  ///
  /// **Returns:** Sneakers matching the query in name, colorway, or brand.
  Future<List<SneakerModel>> searchSneakers(String query) async {
    await Future.delayed(_mockDelay);

    if (query.isEmpty) {
      return List<SneakerModel>.from(_mockSneakers);
    }

    final lowerQuery = query.toLowerCase();
    return _mockSneakers.where((s) {
      return s.name.toLowerCase().contains(lowerQuery) ||
          s.colorway.toLowerCase().contains(lowerQuery) ||
          s.brand.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Gets all available brands.
  ///
  /// **Returns:** List of unique brand names.
  Future<List<String>> fetchBrands() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final brands = _mockSneakers.map((s) => s.brand).toSet().toList()..sort();
    return brands;
  }

  /// Gets price range of all sneakers.
  ///
  /// **Returns:** Map with 'min' and 'max' market prices.
  Future<Map<String, double>> fetchPriceRange() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final prices = _mockSneakers.map((s) => s.marketPrice).toList();
    return {
      'min': prices.reduce((a, b) => a < b ? a : b),
      'max': prices.reduce((a, b) => a > b ? a : b),
    };
  }
}
