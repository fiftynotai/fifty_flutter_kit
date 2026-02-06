import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';

/// Size chip stock state for visual styling.
enum SizeChipState {
  /// Size is available with normal stock.
  available,

  /// Size is selected by user.
  selected,

  /// Size has low stock (1-3 items).
  lowStock,

  /// Size is sold out (0 stock).
  soldOut,
}

/// **SizeChip**
///
/// Individual size selection chip with availability indicators.
///
/// **States:**
/// - Available: transparent bg, slateGrey border, cream text
/// - Selected: burgundy bg, burgundy border, cream text
/// - Low Stock: transparent bg, warning border, warning text
/// - Sold Out: surfaceDark 50% bg, slateGrey 50% border, slateGrey 50% text
///
/// **Example Usage:**
/// ```dart
/// SizeChip(
///   size: 10.0,
///   stock: 5,
///   isSelected: false,
///   onTap: () => selectSize(10.0),
/// )
/// ```
class SizeChip extends StatelessWidget {
  /// The US shoe size to display.
  final double size;

  /// Number of units in stock for this size.
  final int stock;

  /// Whether this size is currently selected.
  final bool isSelected;

  /// Callback when chip is tapped (null if disabled).
  final VoidCallback? onTap;

  /// Low stock threshold (default: 3).
  static const int lowStockThreshold = 3;

  /// Creates a [SizeChip] with the specified parameters.
  const SizeChip({
    required this.size,
    required this.stock,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  /// Determines the visual state of the chip based on selection and stock.
  SizeChipState get state {
    if (stock == 0) return SizeChipState.soldOut;
    if (isSelected) return SizeChipState.selected;
    if (stock <= lowStockThreshold) return SizeChipState.lowStock;
    return SizeChipState.available;
  }

  /// Whether this chip can be tapped.
  bool get isEnabled => stock > 0 && onTap != null;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticLabel,
      button: isEnabled,
      selected: isSelected,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(
            minHeight: 44,
            minWidth: 56,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.md,
            vertical: SneakerSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: Border.all(color: _borderColor, width: 1.5),
            borderRadius: SneakerRadii.chip,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatSize(size),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  height: 1.2,
                ),
              ),
              if (state == SizeChipState.lowStock) ...[
                const SizedBox(height: 2),
                Text(
                  '$stock left',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: SneakerColors.warning.withValues(alpha: 0.8),
                    height: 1.0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (state) {
      case SizeChipState.selected:
        return SneakerColors.burgundy;
      case SizeChipState.soldOut:
        return SneakerColors.surfaceDark.withValues(alpha: 0.5);
      case SizeChipState.available:
      case SizeChipState.lowStock:
        return Colors.transparent;
    }
  }

  Color get _borderColor {
    switch (state) {
      case SizeChipState.selected:
        return SneakerColors.burgundy;
      case SizeChipState.lowStock:
        return SneakerColors.warning;
      case SizeChipState.soldOut:
        return SneakerColors.slateGrey.withValues(alpha: 0.5);
      case SizeChipState.available:
        return SneakerColors.slateGrey;
    }
  }

  Color get _textColor {
    switch (state) {
      case SizeChipState.selected:
        return SneakerColors.cream;
      case SizeChipState.lowStock:
        return SneakerColors.warning;
      case SizeChipState.soldOut:
        return SneakerColors.slateGrey.withValues(alpha: 0.5);
      case SizeChipState.available:
        return SneakerColors.cream;
    }
  }

  String get _semanticLabel {
    final sizeStr = _formatSize(size);
    switch (state) {
      case SizeChipState.selected:
        return 'Size $sizeStr, selected';
      case SizeChipState.lowStock:
        return 'Size $sizeStr, only $stock left';
      case SizeChipState.soldOut:
        return 'Size $sizeStr, sold out';
      case SizeChipState.available:
        return 'Size $sizeStr, available';
    }
  }

  /// Formats size value, omitting .0 for whole numbers.
  String _formatSize(double size) {
    if (size == size.roundToDouble()) {
      return size.toInt().toString();
    }
    return size.toString();
  }
}
