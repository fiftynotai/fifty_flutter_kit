import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/animations/loading_skeleton.dart';
import '../../../core/animations/scroll_reveal.dart';
import '../../../core/theme/sneaker_colors.dart';
import '../../../core/theme/sneaker_radii.dart';
import '../../../core/theme/sneaker_spacing.dart';
import '../../../core/theme/sneaker_typography.dart';
import '../controllers/catalog_view_model.dart';
import '../data/services/sneaker_service.dart';
import 'widgets/catalog/sort_dropdown.dart';
import 'widgets/catalog/view_mode_toggle.dart';
import 'widgets/filter/glass_filter_panel.dart';
import 'widgets/navigation/glass_nav_bar.dart';
import 'widgets/product/sneaker_card.dart';

/// **CatalogPage**
///
/// Product catalog with filter panel and product grid.
///
/// Features:
/// - GlassNavBar at top
/// - Page title with product count
/// - View toggle (grid/list)
/// - Sort dropdown
/// - Filter panel (sidebar on desktop, bottom sheet on mobile)
/// - Product grid with SneakerCards
/// - Load more / infinite scroll
///
/// **Layout (Desktop):**
/// - Left sidebar: GlassFilterPanel (320px)
/// - Right content: Product grid (4 columns)
///
/// **Layout (Mobile):**
/// - Filter button triggers bottom sheet
/// - Product grid (2 columns)
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final CatalogViewModel _controller;
  final ScrollController _scrollController = ScrollController();

  /// Breakpoint for desktop layout.
  static const double _desktopBreakpoint = 1024.0;

  /// Breakpoint for tablet layout.
  static const double _tabletBreakpoint = 768.0;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CatalogViewModel(SneakerService()));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(() => GlassFilterPanel(
            filters: _controller.filters.value,
            onFiltersChanged: _controller.applyFilters,
            onClearAll: _controller.clearFilters,
            onApply: () => Navigator.pop(context),
            availableBrands: _controller.availableBrands,
            availableSizes: _controller.availableSizes,
            priceRange: _controller.priceRange.value,
            matchingCount: _controller.productCount,
            isBottomSheet: true,
          )),
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
            GlassNavBar(
              currentRoute: '/catalog',
              cartItemCount: 0,
              onSearchTap: () {
                // TODO: Implement search
              },
              onCartTap: () {
                // TODO: Navigate to cart
              },
            ),

            // Main content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
                  final isTablet = constraints.maxWidth >= _tabletBreakpoint;

                  if (isDesktop) {
                    return _buildDesktopLayout(constraints);
                  } else {
                    return _buildMobileLayout(constraints, isTablet);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter sidebar
        Padding(
          padding: const EdgeInsets.all(SneakerSpacing.lg),
          child: Obx(() => GlassFilterPanel(
                filters: _controller.filters.value,
                onFiltersChanged: _controller.applyFilters,
                onClearAll: _controller.clearFilters,
                availableBrands: _controller.availableBrands,
                availableSizes: _controller.availableSizes,
                priceRange: _controller.priceRange.value,
                matchingCount: _controller.productCount,
              )),
        ),

        // Product grid
        Expanded(
          child: _buildProductSection(crossAxisCount: 4),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BoxConstraints constraints, bool isTablet) {
    return _buildProductSection(
      crossAxisCount: isTablet ? 3 : 2,
      showFilterButton: true,
    );
  }

  Widget _buildProductSection({
    required int crossAxisCount,
    bool showFilterButton = false,
  }) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header with title and controls
        SliverToBoxAdapter(
          child: _buildHeader(showFilterButton: showFilterButton),
        ),

        // Product grid
        Obx(() {
          if (_controller.isLoading.value) {
            return SliverPadding(
              padding: const EdgeInsets.all(SneakerSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: SneakerSpacing.lg,
                  crossAxisSpacing: SneakerSpacing.lg,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const SkeletonCard(),
                  childCount: 8,
                ),
              ),
            );
          }

          final sneakers = _controller.filteredSneakers;

          if (sneakers.isEmpty) {
            return SliverFillRemaining(
              child: _buildEmptyState(),
            );
          }

          return Obx(() {
            if (_controller.viewMode.value == ViewMode.list) {
              return _buildListView(sneakers);
            }
            return _buildGridView(sneakers, crossAxisCount);
          });
        }),

        // Load more indicator
        Obx(() {
          if (_controller.isLoadingMore.value) {
            return SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(SneakerSpacing.xxl),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(SneakerColors.burgundy),
                ),
              ),
            );
          }

          if (!_controller.hasReachedEnd.value &&
              _controller.filteredSneakers.isNotEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(SneakerSpacing.xxl),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _controller.loadMore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SneakerColors.burgundy,
                      foregroundColor: SneakerColors.cream,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SneakerSpacing.xxxl,
                        vertical: SneakerSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: SneakerRadii.radiusMd,
                      ),
                    ),
                    child: Text(
                      'LOAD MORE',
                      style: SneakerTypography.label,
                    ),
                  ),
                ),
              ),
            );
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: SneakerSpacing.massive),
        ),
      ],
    );
  }

  Widget _buildHeader({bool showFilterButton = false}) {
    return Padding(
      padding: const EdgeInsets.all(SneakerSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Obx(() => Text(
                      'ALL SNEAKERS (${_controller.productCount})',
                      style: SneakerTypography.sectionTitle,
                    )),
              ),
              if (showFilterButton) ...[
                _buildFilterButton(),
                const SizedBox(width: SneakerSpacing.md),
              ],
              Obx(() => ViewModeToggle(
                    mode: _controller.viewMode.value,
                    onChanged: _controller.setViewMode,
                  )),
              const SizedBox(width: SneakerSpacing.md),
              Obx(() => SortDropdown(
                    selected: _controller.sortBy.value,
                    onChanged: _controller.setSort,
                  )),
            ],
          ),

          // Active filters row
          Obx(() {
            if (!_controller.hasActiveFilters) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: SneakerSpacing.md),
              child: _buildActiveFiltersRow(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Obx(() {
      final hasFilters = _controller.hasActiveFilters;
      return GestureDetector(
        onTap: _showFilterBottomSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.md,
            vertical: SneakerSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: hasFilters ? SneakerColors.burgundy : SneakerColors.surfaceDark,
            borderRadius: SneakerRadii.radiusMd,
            border: Border.all(
              color: hasFilters ? SneakerColors.burgundy : SneakerColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 18,
                color: hasFilters ? SneakerColors.cream : SneakerColors.slateGrey,
              ),
              const SizedBox(width: SneakerSpacing.xs),
              Text(
                hasFilters
                    ? 'FILTERS (${_controller.filters.value.activeFilterCount})'
                    : 'FILTERS',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: SneakerTypography.semiBold,
                  letterSpacing: 0.5,
                  color:
                      hasFilters ? SneakerColors.cream : SneakerColors.slateGrey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActiveFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Brand chips
          ..._controller.filters.value.selectedBrands.map(
            (brand) => _buildFilterChip(
              label: brand,
              onRemove: () {
                final newBrands =
                    Set<String>.from(_controller.filters.value.selectedBrands)
                      ..remove(brand);
                _controller.applyFilters(
                  _controller.filters.value.copyWith(selectedBrands: newBrands),
                );
              },
            ),
          ),

          // Rarity chips
          ..._controller.filters.value.selectedRarities.map(
            (rarity) => _buildFilterChip(
              label: rarity.name.toUpperCase(),
              onRemove: () {
                final newRarities = Set.from(_controller.filters.value.selectedRarities)
                  ..remove(rarity);
                _controller.applyFilters(
                  _controller.filters.value.copyWith(
                    selectedRarities: newRarities.cast(),
                  ),
                );
              },
            ),
          ),

          // Price range chip
          if (_controller.filters.value.minPrice != null ||
              _controller.filters.value.maxPrice != null)
            _buildFilterChip(
              label:
                  '\$${_controller.filters.value.minPrice?.toStringAsFixed(0) ?? '0'} - \$${_controller.filters.value.maxPrice?.toStringAsFixed(0) ?? '2000+'}',
              onRemove: () {
                _controller.applyFilters(
                  _controller.filters.value.copyWith(
                    clearMinPrice: true,
                    clearMaxPrice: true,
                  ),
                );
              },
            ),

          // Clear all button
          GestureDetector(
            onTap: _controller.clearFilters,
            child: Padding(
              padding: const EdgeInsets.only(left: SneakerSpacing.sm),
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontSize: 12,
                  fontWeight: SneakerTypography.medium,
                  color: SneakerColors.powderBlush,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: SneakerSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: SneakerSpacing.md,
        vertical: SneakerSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: SneakerColors.burgundy.withValues(alpha: 0.3),
        borderRadius: SneakerRadii.badge,
        border: Border.all(
          color: SneakerColors.burgundy.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              fontSize: 11,
              fontWeight: SneakerTypography.medium,
              color: SneakerColors.cream,
            ),
          ),
          const SizedBox(width: SneakerSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: SneakerColors.cream,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List sneakers, int crossAxisCount) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: SneakerSpacing.lg),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: SneakerSpacing.lg,
          crossAxisSpacing: SneakerSpacing.lg,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final sneaker = sneakers[index];
            return ScrollReveal(
              delay: Duration(milliseconds: 50 * (index % crossAxisCount)),
              child: SneakerCard(
                sneaker: sneaker,
                onTap: () {
                  // TODO: Navigate to product detail
                },
                onQuickAdd: () {
                  // TODO: Add to cart
                },
              ),
            );
          },
          childCount: sneakers.length,
        ),
      ),
    );
  }

  Widget _buildListView(List sneakers) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: SneakerSpacing.lg),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final sneaker = sneakers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: SneakerSpacing.md),
              child: ScrollReveal(
                delay: Duration(milliseconds: 50 * index),
                child: SneakerCardCompact(
                  sneaker: sneaker,
                  onTap: () {
                    // TODO: Navigate to product detail
                  },
                ),
              ),
            );
          },
          childCount: sneakers.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: SneakerColors.slateGrey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: SneakerSpacing.lg),
          Text(
            'No sneakers found',
            style: SneakerTypography.productTitle.copyWith(
              color: SneakerColors.cream,
            ),
          ),
          const SizedBox(height: SneakerSpacing.sm),
          Text(
            'Try adjusting your filters',
            style: SneakerTypography.description.copyWith(
              color: SneakerColors.slateGrey,
            ),
          ),
          const SizedBox(height: SneakerSpacing.xxl),
          ElevatedButton(
            onPressed: _controller.clearFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: SneakerColors.burgundy,
              foregroundColor: SneakerColors.cream,
              padding: const EdgeInsets.symmetric(
                horizontal: SneakerSpacing.xxl,
                vertical: SneakerSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: SneakerRadii.radiusMd,
              ),
            ),
            child: Text(
              'CLEAR FILTERS',
              style: SneakerTypography.label,
            ),
          ),
        ],
      ),
    );
  }
}
