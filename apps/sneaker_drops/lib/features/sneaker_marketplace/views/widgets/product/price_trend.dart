import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **PriceTrend**
///
/// Price display with market trend indicator showing price direction.
///
/// **Features:**
/// - Current price displayed in bold
/// - Arrow icon (up green, down red)
/// - Percentage change text
/// - Animated trend indicator
///
/// **Usage:**
/// ```dart
/// PriceTrend(
///   price: 170.0,
///   marketPrice: 650.0,
///   showTrend: true,
/// )
/// ```
class PriceTrend extends StatelessWidget {
  /// Current/retail price in USD.
  final double price;

  /// Current market/resale price in USD.
  final double marketPrice;

  /// Whether to show the trend indicator. Defaults to true.
  final bool showTrend;

  /// Size of the price text. Defaults to medium.
  final PriceTrendSize size;

  /// Currency symbol. Defaults to '$'.
  final String currencySymbol;

  /// Whether to show market price label. Defaults to false.
  final bool showMarketLabel;

  /// Creates a [PriceTrend] with the specified parameters.
  const PriceTrend({
    required this.price,
    required this.marketPrice,
    this.showTrend = true,
    this.size = PriceTrendSize.medium,
    this.currencySymbol = '\$',
    this.showMarketLabel = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentChange = _calculatePercentChange();
    final isPositive = percentChange >= 0;
    final trendColor = isPositive ? SneakerColors.hunterGreen : SneakerColors.burgundy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Price row with trend
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price
            Text(
              _formatPrice(marketPrice),
              style: _getPriceStyle(),
            ),

            // Trend indicator
            if (showTrend) ...[
              const SizedBox(width: 8),
              _buildTrendIndicator(
                isPositive: isPositive,
                percentChange: percentChange,
                color: trendColor,
              ),
            ],
          ],
        ),

        // Market label or retail comparison
        if (showMarketLabel)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Market Price',
              style: TextStyle(
                fontFamily: SneakerTypography.fontFamily,
                fontSize: _getLabelFontSize(),
                fontWeight: SneakerTypography.regular,
                color: SneakerColors.slateGrey,
              ),
            ),
          ),

        // Retail price comparison
        if (marketPrice != price)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Retail: ${_formatPrice(price)}',
              style: TextStyle(
                fontFamily: SneakerTypography.fontFamily,
                fontSize: _getLabelFontSize(),
                fontWeight: SneakerTypography.regular,
                color: SneakerColors.slateGrey,
                decoration: TextDecoration.lineThrough,
                decorationColor: SneakerColors.slateGrey.withValues(alpha: 0.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrendIndicator({
    required bool isPositive,
    required double percentChange,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getTrendPaddingH(),
        vertical: _getTrendPaddingV(),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Arrow icon
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: _getIconSize(),
            color: color,
          ),
          const SizedBox(width: 2),

          // Percentage text
          Text(
            '${percentChange.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              fontSize: _getTrendFontSize(),
              fontWeight: SneakerTypography.semiBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: value.truncateToDouble() == value ? 0 : 2,
    );
    return formatter.format(value);
  }

  double _calculatePercentChange() {
    if (price == 0) return 0;
    return ((marketPrice - price) / price) * 100;
  }

  TextStyle _getPriceStyle() {
    switch (size) {
      case PriceTrendSize.small:
        return TextStyle(
          fontFamily: SneakerTypography.fontFamily,
          fontSize: 14,
          fontWeight: SneakerTypography.bold,
          color: SneakerColors.cream,
        );
      case PriceTrendSize.medium:
        return TextStyle(
          fontFamily: SneakerTypography.fontFamily,
          fontSize: 18,
          fontWeight: SneakerTypography.bold,
          color: SneakerColors.cream,
        );
      case PriceTrendSize.large:
        return TextStyle(
          fontFamily: SneakerTypography.fontFamily,
          fontSize: 24,
          fontWeight: SneakerTypography.extraBold,
          color: SneakerColors.cream,
        );
    }
  }

  double _getLabelFontSize() {
    switch (size) {
      case PriceTrendSize.small:
        return 10;
      case PriceTrendSize.medium:
        return 12;
      case PriceTrendSize.large:
        return 14;
    }
  }

  double _getTrendFontSize() {
    switch (size) {
      case PriceTrendSize.small:
        return 10;
      case PriceTrendSize.medium:
        return 11;
      case PriceTrendSize.large:
        return 12;
    }
  }

  double _getIconSize() {
    switch (size) {
      case PriceTrendSize.small:
        return 10;
      case PriceTrendSize.medium:
        return 12;
      case PriceTrendSize.large:
        return 14;
    }
  }

  double _getTrendPaddingH() {
    switch (size) {
      case PriceTrendSize.small:
        return 4;
      case PriceTrendSize.medium:
        return 6;
      case PriceTrendSize.large:
        return 8;
    }
  }

  double _getTrendPaddingV() {
    switch (size) {
      case PriceTrendSize.small:
        return 2;
      case PriceTrendSize.medium:
        return 3;
      case PriceTrendSize.large:
        return 4;
    }
  }
}

/// Size variants for [PriceTrend].
enum PriceTrendSize {
  /// Small price (14px font).
  small,

  /// Medium price (18px font).
  medium,

  /// Large price (24px font).
  large,
}

/// **PriceTrendCompact**
///
/// Compact inline version of price trend for space-constrained layouts.
///
/// **Usage:**
/// ```dart
/// PriceTrendCompact(
///   price: 170.0,
///   marketPrice: 650.0,
/// )
/// ```
class PriceTrendCompact extends StatelessWidget {
  /// Current/retail price in USD.
  final double price;

  /// Current market/resale price in USD.
  final double marketPrice;

  /// Currency symbol. Defaults to '$'.
  final String currencySymbol;

  /// Creates a [PriceTrendCompact] with the specified parameters.
  const PriceTrendCompact({
    required this.price,
    required this.marketPrice,
    this.currencySymbol = '\$',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentChange = _calculatePercentChange();
    final isPositive = percentChange >= 0;
    final trendColor = isPositive ? SneakerColors.hunterGreen : SneakerColors.burgundy;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Price
        Text(
          _formatPrice(marketPrice),
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 14,
            fontWeight: SneakerTypography.bold,
            color: SneakerColors.cream,
          ),
        ),
        const SizedBox(width: 4),

        // Trend arrow
        Icon(
          isPositive
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          size: 12,
          color: trendColor,
        ),

        // Percentage
        Text(
          '${percentChange.abs().toStringAsFixed(0)}%',
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 11,
            fontWeight: SneakerTypography.semiBold,
            color: trendColor,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double value) {
    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  double _calculatePercentChange() {
    if (price == 0) return 0;
    return ((marketPrice - price) / price) * 100;
  }
}
