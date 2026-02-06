import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../data/models/sneaker_model.dart';
import 'size_chip.dart';

/// **SizeSelectorGrid**
///
/// Grid of size options with availability indicators.
///
/// **Features:**
/// - 4 columns on desktop, 3 on mobile
/// - Size chip states: available, selected, low stock, sold out
/// - Touch target: 44px minimum height
/// - Responsive layout based on available width
///
/// **Example Usage:**
/// ```dart
/// SizeSelectorGrid(
///   sizes: sneaker.sizes,
///   selectedSize: 10.0,
///   onSizeSelected: (size) => setState(() => selectedSize = size),
/// )
/// ```
class SizeSelectorGrid extends StatelessWidget {
  /// List of available sizes with stock information.
  final List<SneakerSize> sizes;

  /// Currently selected size (null if none selected).
  final double? selectedSize;

  /// Callback when a size is selected.
  final ValueChanged<double> onSizeSelected;

  /// Number of columns on desktop (width >= 600).
  final int desktopColumns;

  /// Number of columns on mobile (width < 600).
  final int mobileColumns;

  /// Creates a [SizeSelectorGrid] with the specified parameters.
  const SizeSelectorGrid({
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    this.desktopColumns = 4,
    this.mobileColumns = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return _buildEmptyState();
    }

    // Sort sizes numerically
    final sortedSizes = List<SneakerSize>.from(sizes)
      ..sort((a, b) => a.size.compareTo(b.size));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 600;
        final columns = isDesktop ? desktopColumns : mobileColumns;

        return Wrap(
          spacing: SneakerSpacing.sm,
          runSpacing: SneakerSpacing.sm,
          children: sortedSizes.map((sizeData) {
            // Calculate width to fit columns with spacing
            final totalSpacing = SneakerSpacing.sm * (columns - 1);
            final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

            return SizedBox(
              width: itemWidth,
              child: SizeChip(
                size: sizeData.size,
                stock: sizeData.stock,
                isSelected: selectedSize == sizeData.size,
                onTap: sizeData.isAvailable && sizeData.stock > 0
                    ? () => onSizeSelected(sizeData.size)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SneakerColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: const Center(
        child: Text(
          'No sizes available',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: SneakerColors.slateGrey,
          ),
        ),
      ),
    );
  }
}
