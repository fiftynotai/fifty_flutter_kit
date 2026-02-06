import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/sneaker_model.dart';
import '../data/services/sneaker_service.dart';
import '../views/widgets/filter/filter_state.dart';

/// Sort options for the product catalog.
enum SortOption {
  /// Sort by newest release date.
  newest,

  /// Sort by price from low to high.
  priceLow,

  /// Sort by price from high to low.
  priceHigh,

  /// Sort by trending (highest markup).
  trending,
}

/// View mode for the product grid.
enum ViewMode {
  /// Display products in a grid layout.
  grid,

  /// Display products in a list layout.
  list,
}

/// **CatalogViewModel**
///
/// ViewModel for catalog page state management.
///
/// Manages product listing, filtering, sorting, and pagination for the
/// catalog page. Uses GetX reactive state management.
///
/// **State:**
/// - sneakers: List of sneaker products
/// - isLoading: Loading state for initial load
/// - isLoadingMore: Loading state for pagination
/// - filters: Current filter selections
/// - sortBy: Current sort option
/// - viewMode: Grid or list view
///
/// **Example Usage:**
/// ```dart
/// final controller = Get.put(CatalogViewModel(SneakerService()));
/// Obx(() => Text('${controller.filteredSneakers.length} products'));
/// ```
class CatalogViewModel extends GetxController {
  /// Creates a [CatalogViewModel] with the given service.
  CatalogViewModel(this._service);

  final SneakerService _service;

  // ============================================================
  // REACTIVE STATE
  // ============================================================

  /// All sneakers from the service.
  final RxList<SneakerModel> _allSneakers = <SneakerModel>[].obs;

  /// Whether initial data is loading.
  final RxBool isLoading = true.obs;

  /// Whether more data is being loaded (pagination).
  final RxBool isLoadingMore = false.obs;

  /// Whether all data has been loaded.
  final RxBool hasReachedEnd = false.obs;

  /// Current filter state.
  final Rx<FilterState> filters = const FilterState.empty().obs;

  /// Current sort option.
  final Rx<SortOption> sortBy = SortOption.newest.obs;

  /// Current view mode (grid/list).
  final Rx<ViewMode> viewMode = ViewMode.grid.obs;

  /// Available brand names for filtering.
  final RxList<String> availableBrands = <String>[].obs;

  /// Price range bounds.
  final Rx<RangeValues> priceRange = const RangeValues(0, 2000).obs;

  /// All available sizes across products.
  final RxList<SneakerSize> availableSizes = <SneakerSize>[].obs;

  // ============================================================
  // COMPUTED PROPERTIES
  // ============================================================

  /// Filtered and sorted list of sneakers.
  List<SneakerModel> get filteredSneakers {
    var result = List<SneakerModel>.from(_allSneakers);

    // Apply brand filter
    if (filters.value.selectedBrands.isNotEmpty) {
      result = result
          .where((s) => filters.value.selectedBrands.contains(s.brand))
          .toList();
    }

    // Apply rarity filter
    if (filters.value.selectedRarities.isNotEmpty) {
      result = result
          .where((s) => filters.value.selectedRarities.contains(s.rarity))
          .toList();
    }

    // Apply price filter
    if (filters.value.minPrice != null) {
      result = result
          .where((s) => s.marketPrice >= filters.value.minPrice!)
          .toList();
    }
    if (filters.value.maxPrice != null) {
      result = result
          .where((s) => s.marketPrice <= filters.value.maxPrice!)
          .toList();
    }

    // Apply size filter
    if (filters.value.selectedSizes.isNotEmpty) {
      result = result.where((s) {
        return s.sizes.any((size) =>
            filters.value.selectedSizes.contains(size.size) && size.isAvailable);
      }).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case SortOption.newest:
        result.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      case SortOption.priceLow:
        result.sort((a, b) => a.marketPrice.compareTo(b.marketPrice));
      case SortOption.priceHigh:
        result.sort((a, b) => b.marketPrice.compareTo(a.marketPrice));
      case SortOption.trending:
        result.sort((a, b) => b.priceMarkup.compareTo(a.priceMarkup));
    }

    return result;
  }

  /// Total count of products matching current filters.
  int get productCount => filteredSneakers.length;

  /// Whether any filters are active.
  bool get hasActiveFilters => filters.value.hasFilters;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Fetches initial sneaker data.
  Future<void> fetchSneakers() async {
    isLoading.value = true;
    try {
      final sneakers = await _service.fetchSneakers();
      _allSneakers.assignAll(sneakers);
      hasReachedEnd.value = true; // Mock service returns all data at once
    } finally {
      isLoading.value = false;
    }
  }

  /// Applies new filter state.
  void applyFilters(FilterState newFilters) {
    filters.value = newFilters;
  }

  /// Clears all active filters.
  void clearFilters() {
    filters.value = const FilterState.empty();
  }

  /// Sets the sort option.
  void setSort(SortOption option) {
    sortBy.value = option;
  }

  /// Toggles between grid and list view.
  void toggleViewMode() {
    viewMode.value =
        viewMode.value == ViewMode.grid ? ViewMode.list : ViewMode.grid;
  }

  /// Sets the view mode directly.
  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  /// Loads more products (pagination).
  ///
  /// In a real app, this would fetch the next page of results.
  /// For the mock service, this is a no-op since all data is loaded at once.
  Future<void> loadMore() async {
    if (isLoadingMore.value || hasReachedEnd.value) return;

    isLoadingMore.value = true;
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      // Mock service already returns all data, so we just mark as reached end
      hasReachedEnd.value = true;
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Refreshes the catalog data.
  @override
  Future<void> refresh() async {
    hasReachedEnd.value = false;
    await fetchSneakers();
  }

  // ============================================================
  // PRIVATE METHODS
  // ============================================================

  Future<void> _loadInitialData() async {
    try {
      // Load data in parallel
      final results = await Future.wait([
        _service.fetchSneakers(),
        _service.fetchBrands(),
        _service.fetchPriceRange(),
      ]);

      _allSneakers.assignAll(results[0] as List<SneakerModel>);
      availableBrands.assignAll(results[1] as List<String>);

      final priceRangeData = results[2] as Map<String, double>;
      priceRange.value = RangeValues(
        priceRangeData['min'] ?? 0,
        priceRangeData['max'] ?? 2000,
      );

      // Collect all unique sizes
      final sizes = <double, SneakerSize>{};
      for (final sneaker in _allSneakers) {
        for (final size in sneaker.sizes) {
          sizes[size.size] = size;
        }
      }
      availableSizes.assignAll(
        sizes.values.toList()..sort((a, b) => a.size.compareTo(b.size)),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
