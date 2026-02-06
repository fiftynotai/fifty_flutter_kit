import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../data/models/sneaker_model.dart';
import 'filter_checkbox_group.dart';
import 'filter_price_range.dart';
import 'filter_state.dart';
import 'size_selector_grid.dart';

/// **GlassFilterPanel**
///
/// Glassmorphism filter sidebar/sheet for the catalog page.
///
/// **Features:**
/// - Frosted glass background (blur 20, 85% opacity)
/// - Contains filter groups for brands, sizes, price, rarities
/// - Width: 320px on desktop, full-width bottom sheet on mobile
/// - Clear all filters button
/// - Apply filters button
///
/// **Example Usage:**
/// ```dart
/// GlassFilterPanel(
///   filters: currentFilters,
///   onFiltersChanged: (filters) => setState(() => currentFilters = filters),
///   availableBrands: ['Nike', 'Adidas', 'New Balance'],
///   availableSizes: sneaker.sizes,
///   priceRange: RangeValues(0, 1000),
/// )
/// ```
class GlassFilterPanel extends StatelessWidget {
  /// Current filter state.
  final FilterState filters;

  /// Callback when any filter changes.
  final ValueChanged<FilterState> onFiltersChanged;

  /// Callback when clear all is pressed.
  final VoidCallback? onClearAll;

  /// Callback when apply button is pressed (for bottom sheet mode).
  final VoidCallback? onApply;

  /// List of available brand names.
  final List<String> availableBrands;

  /// List of available sizes with stock information.
  final List<SneakerSize> availableSizes;

  /// Absolute price range bounds.
  final RangeValues priceRange;

  /// Number of products matching current filters.
  final int? matchingCount;

  /// Whether panel is displayed as bottom sheet.
  final bool isBottomSheet;

  /// Panel width for sidebar mode (desktop).
  static const double sidebarWidth = 320.0;

  /// Creates a [GlassFilterPanel] with the specified parameters.
  const GlassFilterPanel({
    required this.filters,
    required this.onFiltersChanged,
    required this.availableBrands,
    required this.availableSizes,
    required this.priceRange,
    this.onClearAll,
    this.onApply,
    this.matchingCount,
    this.isBottomSheet = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: SneakerSpacing.lg),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: SneakerSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brands filter
                if (availableBrands.isNotEmpty) ...[
                  FilterCheckboxGroup(
                    title: 'BRANDS',
                    options: availableBrands,
                    selected: filters.selectedBrands,
                    onChanged: (brands) => onFiltersChanged(
                      filters.copyWith(selectedBrands: brands),
                    ),
                  ),
                  const SizedBox(height: SneakerSpacing.xxl),
                  _buildDivider(),
                  const SizedBox(height: SneakerSpacing.lg),
                ],

                // Rarity filter
                FilterCheckboxGroup(
                  title: 'RARITY',
                  options: SneakerRarity.values.map(_formatRarity).toList(),
                  selected: filters.selectedRarities
                      .map(_formatRarity)
                      .toSet(),
                  onChanged: (rarities) => onFiltersChanged(
                    filters.copyWith(
                      selectedRarities: rarities
                          .map(_parseRarity)
                          .toSet(),
                    ),
                  ),
                ),
                const SizedBox(height: SneakerSpacing.xxl),
                _buildDivider(),
                const SizedBox(height: SneakerSpacing.lg),

                // Price range filter
                FilterPriceRange(
                  min: priceRange.start,
                  max: priceRange.end,
                  currentMin: filters.minPrice ?? priceRange.start,
                  currentMax: filters.maxPrice ?? priceRange.end,
                  onChanged: (range) => onFiltersChanged(
                    filters.copyWith(
                      minPrice: range.start,
                      maxPrice: range.end,
                      clearMinPrice: range.start == priceRange.start,
                      clearMaxPrice: range.end == priceRange.end,
                    ),
                  ),
                  matchingCount: matchingCount,
                ),
                const SizedBox(height: SneakerSpacing.xxl),
                _buildDivider(),
                const SizedBox(height: SneakerSpacing.lg),

                // Size selector
                if (availableSizes.isNotEmpty) ...[
                  const Text(
                    'SIZE (US)',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SneakerColors.cream,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: SneakerSpacing.md),
                  SizeSelectorGrid(
                    sizes: availableSizes,
                    selectedSize: filters.selectedSizes.isNotEmpty
                        ? filters.selectedSizes.first
                        : null,
                    onSizeSelected: (size) {
                      final newSizes = Set<double>.from(filters.selectedSizes);
                      if (newSizes.contains(size)) {
                        newSizes.remove(size);
                      } else {
                        newSizes.add(size);
                      }
                      onFiltersChanged(filters.copyWith(selectedSizes: newSizes));
                    },
                  ),
                  const SizedBox(height: SneakerSpacing.xxl),
                ],

                // Bottom padding for scroll
                SizedBox(height: isBottomSheet ? 80 : SneakerSpacing.lg),
              ],
            ),
          ),
        ),

        // Apply button for bottom sheet
        if (isBottomSheet && onApply != null) _buildApplyButton(),
      ],
    );

    if (isBottomSheet) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SneakerRadii.xxl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: SneakerColors.darkBurgundy.withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                  color: SneakerColors.glassBorder,
                  width: 1,
                ),
              ),
            ),
            child: content,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: SneakerRadii.radiusXl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: sidebarWidth,
          decoration: BoxDecoration(
            color: SneakerColors.darkBurgundy.withValues(alpha: 0.85),
            borderRadius: SneakerRadii.radiusXl,
            border: Border.all(
              color: SneakerColors.glassBorder,
              width: 1,
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        SneakerSpacing.lg,
        SneakerSpacing.lg,
        SneakerSpacing.lg,
        SneakerSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: SneakerColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune,
                color: SneakerColors.cream,
                size: 20,
              ),
              const SizedBox(width: SneakerSpacing.sm),
              const Text(
                'FILTERS',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: SneakerColors.cream,
                  letterSpacing: 1.0,
                ),
              ),
              if (filters.hasFilters) ...[
                const SizedBox(width: SneakerSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SneakerSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: SneakerColors.burgundy,
                    borderRadius: SneakerRadii.badge,
                  ),
                  child: Text(
                    filters.activeFilterCount.toString(),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: SneakerColors.cream,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (filters.hasFilters)
            GestureDetector(
              onTap: onClearAll ?? () => onFiltersChanged(filters.clear()),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: SneakerColors.powderBlush,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: SneakerColors.border.withValues(alpha: 0.3),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SneakerSpacing.lg,
        SneakerSpacing.md,
        SneakerSpacing.lg,
        SneakerSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: SneakerColors.darkBurgundy,
        border: Border(
          top: BorderSide(
            color: SneakerColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onApply,
            style: ElevatedButton.styleFrom(
              backgroundColor: SneakerColors.burgundy,
              foregroundColor: SneakerColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: SneakerRadii.radiusMd,
              ),
            ),
            child: Text(
              matchingCount != null
                  ? 'SHOW $matchingCount RESULTS'
                  : 'APPLY FILTERS',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatRarity(dynamic rarity) {
    if (rarity is SneakerRarity) {
      switch (rarity) {
        case SneakerRarity.common:
          return 'Common';
        case SneakerRarity.rare:
          return 'Rare';
        case SneakerRarity.grail:
          return 'Grail';
      }
    }
    return rarity.toString();
  }

  SneakerRarity _parseRarity(String name) {
    switch (name.toLowerCase()) {
      case 'common':
        return SneakerRarity.common;
      case 'rare':
        return SneakerRarity.rare;
      case 'grail':
        return SneakerRarity.grail;
      default:
        return SneakerRarity.common;
    }
  }
}
