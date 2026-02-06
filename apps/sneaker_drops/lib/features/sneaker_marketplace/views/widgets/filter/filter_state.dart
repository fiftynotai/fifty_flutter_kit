import '../../../data/models/sneaker_model.dart';

/// **FilterState**
///
/// Immutable state model for filter panel selections.
///
/// Tracks user selections for brands, sizes, price range, and rarities.
/// Used by [GlassFilterPanel] to manage and communicate filter changes.
///
/// **Example Usage:**
/// ```dart
/// final filters = FilterState(
///   selectedBrands: {'Nike', 'Adidas'},
///   selectedSizes: {10.0, 10.5},
///   minPrice: 100.0,
///   maxPrice: 500.0,
///   selectedRarities: {SneakerRarity.grail},
/// );
/// ```
class FilterState {
  /// Set of selected brand names.
  final Set<String> selectedBrands;

  /// Set of selected US shoe sizes.
  final Set<double> selectedSizes;

  /// Minimum price filter (null means no minimum).
  final double? minPrice;

  /// Maximum price filter (null means no maximum).
  final double? maxPrice;

  /// Set of selected rarity classifications.
  final Set<SneakerRarity> selectedRarities;

  /// Creates a [FilterState] with the specified selections.
  const FilterState({
    this.selectedBrands = const {},
    this.selectedSizes = const {},
    this.minPrice,
    this.maxPrice,
    this.selectedRarities = const {},
  });

  /// Creates an empty [FilterState] with no filters applied.
  const FilterState.empty()
      : selectedBrands = const {},
        selectedSizes = const {},
        minPrice = null,
        maxPrice = null,
        selectedRarities = const {};

  /// Whether any filters are currently active.
  bool get hasFilters =>
      selectedBrands.isNotEmpty ||
      selectedSizes.isNotEmpty ||
      minPrice != null ||
      maxPrice != null ||
      selectedRarities.isNotEmpty;

  /// Total count of active filter selections.
  int get activeFilterCount =>
      selectedBrands.length +
      selectedSizes.length +
      (minPrice != null ? 1 : 0) +
      (maxPrice != null ? 1 : 0) +
      selectedRarities.length;

  /// Creates a copy of this [FilterState] with the given fields replaced.
  FilterState copyWith({
    Set<String>? selectedBrands,
    Set<double>? selectedSizes,
    double? minPrice,
    double? maxPrice,
    Set<SneakerRarity>? selectedRarities,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return FilterState(
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      selectedRarities: selectedRarities ?? this.selectedRarities,
    );
  }

  /// Clears all filters and returns an empty state.
  FilterState clear() => const FilterState.empty();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState &&
        _setEquals(other.selectedBrands, selectedBrands) &&
        _setEquals(other.selectedSizes, selectedSizes) &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        _setEquals(other.selectedRarities, selectedRarities);
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.every(b.contains);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(selectedBrands),
        Object.hashAll(selectedSizes),
        minPrice,
        maxPrice,
        Object.hashAll(selectedRarities),
      );

  @override
  String toString() =>
      'FilterState(brands: ${selectedBrands.length}, sizes: ${selectedSizes.length}, '
      'price: $minPrice-$maxPrice, rarities: ${selectedRarities.length})';
}
