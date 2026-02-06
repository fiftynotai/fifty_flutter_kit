import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../controllers/catalog_view_model.dart';

/// **SortDropdown**
///
/// Dropdown menu for selecting sort options in the catalog.
///
/// Features:
/// - Dropdown with current selection displayed
/// - Four sort options: Newest, Price Low-High, Price High-Low, Trending
/// - Styled to match glassmorphism design system
/// - Accessible with semantic labels
///
/// **Example Usage:**
/// ```dart
/// SortDropdown(
///   selected: SortOption.newest,
///   onChanged: (option) => controller.setSort(option),
/// )
/// ```
class SortDropdown extends StatelessWidget {
  /// Creates a [SortDropdown] with the specified parameters.
  const SortDropdown({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Currently selected sort option.
  final SortOption selected;

  /// Callback when sort option changes.
  final ValueChanged<SortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusMd,
        border: Border.all(color: SneakerColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SneakerSpacing.md,
        vertical: SneakerSpacing.xs,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SortOption>(
          value: selected,
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: SneakerColors.slateGrey,
            size: 20,
          ),
          dropdownColor: SneakerColors.surfaceDark,
          borderRadius: SneakerRadii.radiusMd,
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 13,
            fontWeight: SneakerTypography.medium,
            color: SneakerColors.cream,
          ),
          selectedItemBuilder: (context) {
            return SortOption.values.map((option) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sort_rounded,
                      size: 16,
                      color: SneakerColors.slateGrey,
                    ),
                    const SizedBox(width: SneakerSpacing.sm),
                    Text(
                      _getSortLabel(option),
                      style: TextStyle(
                        fontFamily: SneakerTypography.fontFamily,
                        fontSize: 13,
                        fontWeight: SneakerTypography.medium,
                        color: SneakerColors.cream,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          items: SortOption.values.map((option) {
            return DropdownMenuItem<SortOption>(
              value: option,
              child: Row(
                children: [
                  Icon(
                    _getSortIcon(option),
                    size: 16,
                    color: option == selected
                        ? SneakerColors.burgundy
                        : SneakerColors.slateGrey,
                  ),
                  const SizedBox(width: SneakerSpacing.sm),
                  Text(
                    _getSortLabel(option),
                    style: TextStyle(
                      color: option == selected
                          ? SneakerColors.cream
                          : SneakerColors.slateGrey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return 'Newest';
      case SortOption.priceLow:
        return 'Price: Low to High';
      case SortOption.priceHigh:
        return 'Price: High to Low';
      case SortOption.trending:
        return 'Trending';
    }
  }

  IconData _getSortIcon(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return Icons.schedule_rounded;
      case SortOption.priceLow:
        return Icons.arrow_upward_rounded;
      case SortOption.priceHigh:
        return Icons.arrow_downward_rounded;
      case SortOption.trending:
        return Icons.trending_up_rounded;
    }
  }
}
