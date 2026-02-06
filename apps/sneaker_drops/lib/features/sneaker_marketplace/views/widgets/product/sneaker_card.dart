import 'package:flutter/material.dart';

import '../../../../../core/animations/hover_lift_animation.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/sneaker_model.dart';
import 'price_trend.dart';
import 'rarity_badge.dart';
import 'sneaker_image.dart';

/// **SneakerCard**
///
/// Product card with hover lift effect for sneaker grid displays.
/// Provides an interactive card with all essential product information.
///
/// **Features:**
/// - Image with hover lift animation
/// - Product name and brand
/// - Price with market trend indicator
/// - Rarity badge
/// - Quick-add button on hover
///
/// **Usage:**
/// ```dart
/// SneakerCard(
///   sneaker: sneaker,
///   onTap: () => navigateToDetail(sneaker),
///   onQuickAdd: () => addToCart(sneaker),
/// )
/// ```
class SneakerCard extends StatefulWidget {
  /// The sneaker model to display.
  final SneakerModel sneaker;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the quick-add button is pressed.
  final VoidCallback? onQuickAdd;

  /// Width of the card. Defaults to expanding to parent.
  final double? width;

  /// Whether to show the quick-add button on hover. Defaults to true.
  final bool showQuickAdd;

  /// Whether to show the rarity badge. Defaults to true.
  final bool showRarityBadge;

  /// Whether to show the price trend. Defaults to true.
  final bool showPriceTrend;

  /// Creates a [SneakerCard] with the specified parameters.
  const SneakerCard({
    required this.sneaker,
    this.onTap,
    this.onQuickAdd,
    this.width,
    this.showQuickAdd = true,
    this.showRarityBadge = true,
    this.showPriceTrend = true,
    super.key,
  });

  @override
  State<SneakerCard> createState() => _SneakerCardState();
}

class _SneakerCardState extends State<SneakerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${widget.sneaker.brand} ${widget.sneaker.name}, ${widget.sneaker.rarity.name} rarity, \$${widget.sneaker.marketPrice.toStringAsFixed(0)}',
      button: true,
      child: HoverLift(
        onTap: widget.onTap,
        child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: SneakerColors.surfaceDark,
            borderRadius: SneakerRadii.card,
            border: Border.all(
              color: _isHovered
                  ? SneakerColors.burgundy.withValues(alpha: 0.5)
                  : SneakerColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with badges
              _buildImageSection(),

              // Content section
              Padding(
                padding: SneakerSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Text(
                      widget.sneaker.brand.toUpperCase(),
                      style: TextStyle(
                        fontFamily: SneakerTypography.fontFamily,
                        fontSize: 10,
                        fontWeight: SneakerTypography.semiBold,
                        letterSpacing: 1.5,
                        color: SneakerColors.slateGrey,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Product name
                    Text(
                      widget.sneaker.name,
                      style: SneakerTypography.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Colorway
                    Text(
                      '"${widget.sneaker.colorway}"',
                      style: TextStyle(
                        fontFamily: SneakerTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: SneakerTypography.regular,
                        color: SneakerColors.slateGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price with trend
                        if (widget.showPriceTrend)
                          Expanded(
                            child: PriceTrendCompact(
                              price: widget.sneaker.price,
                              marketPrice: widget.sneaker.marketPrice,
                            ),
                          )
                        else
                          Expanded(
                            child: Text(
                              '\$${widget.sneaker.marketPrice.toStringAsFixed(0)}',
                              style: SneakerTypography.price,
                            ),
                          ),

                        // Quick add button
                        if (widget.showQuickAdd && widget.onQuickAdd != null)
                          AnimatedOpacity(
                            opacity: _isHovered ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: _buildQuickAddButton(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Product image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SneakerRadii.xxl - 1),
          ),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              color: SneakerColors.darkBurgundy,
              child: SneakerImage(
                imageUrl: widget.sneaker.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Badges overlay
        Positioned(
          top: SneakerSpacing.md,
          left: SneakerSpacing.md,
          right: SneakerSpacing.md,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rarity badge
              if (widget.showRarityBadge)
                RarityBadge(
                  rarity: widget.sneaker.rarity,
                  size: RarityBadgeSize.small,
                ),

              // New badge
              if (widget.sneaker.isNew) _buildNewBadge(),
            ],
          ),
        ),

        // Stock indicator
        if (!widget.sneaker.isInStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: SneakerColors.darkBurgundy.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(SneakerRadii.xxl - 1),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SneakerColors.burgundy,
                    borderRadius: SneakerRadii.badge,
                  ),
                  child: Text(
                    'SOLD OUT',
                    style: TextStyle(
                      fontFamily: SneakerTypography.fontFamily,
                      fontSize: 12,
                      fontWeight: SneakerTypography.bold,
                      letterSpacing: 1.5,
                      color: SneakerColors.cream,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SneakerColors.hunterGreen,
        borderRadius: SneakerRadii.badge,
      ),
      child: Text(
        'NEW',
        style: TextStyle(
          fontFamily: SneakerTypography.fontFamily,
          fontSize: 10,
          fontWeight: SneakerTypography.bold,
          letterSpacing: 1.5,
          color: SneakerColors.cream,
        ),
      ),
    );
  }

  Widget _buildQuickAddButton() {
    return GestureDetector(
      onTap: widget.onQuickAdd,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: SneakerColors.burgundy,
          borderRadius: SneakerRadii.radiusMd,
        ),
        child: Icon(
          Icons.add_shopping_cart_rounded,
          size: 18,
          color: SneakerColors.cream,
        ),
      ),
    );
  }
}

/// **SneakerCardCompact**
///
/// Compact horizontal card variant for list views.
///
/// **Usage:**
/// ```dart
/// SneakerCardCompact(
///   sneaker: sneaker,
///   onTap: () => navigateToDetail(sneaker),
/// )
/// ```
class SneakerCardCompact extends StatelessWidget {
  /// The sneaker model to display.
  final SneakerModel sneaker;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a [SneakerCardCompact] with the specified parameters.
  const SneakerCardCompact({
    required this.sneaker,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      onTap: onTap,
      translateY: -4,
      scale: 1.01,
      child: Container(
        padding: SneakerSpacing.allMd,
        decoration: BoxDecoration(
          color: SneakerColors.surfaceDark,
          borderRadius: SneakerRadii.radiusLg,
          border: Border.all(color: SneakerColors.border),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: SneakerRadii.radiusMd,
              child: Container(
                width: 80,
                height: 80,
                color: SneakerColors.darkBurgundy,
                child: SneakerImage(
                  imageUrl: sneaker.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    sneaker.brand.toUpperCase(),
                    style: TextStyle(
                      fontFamily: SneakerTypography.fontFamily,
                      fontSize: 9,
                      fontWeight: SneakerTypography.semiBold,
                      letterSpacing: 1.5,
                      color: SneakerColors.slateGrey,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Name
                  Text(
                    sneaker.name,
                    style: TextStyle(
                      fontFamily: SneakerTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: SneakerTypography.bold,
                      color: SneakerColors.cream,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price and rarity
                  Row(
                    children: [
                      PriceTrendCompact(
                        price: sneaker.price,
                        marketPrice: sneaker.marketPrice,
                      ),
                      const SizedBox(width: 8),
                      RarityBadge(
                        rarity: sneaker.rarity,
                        size: RarityBadgeSize.small,
                        showLabel: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: SneakerColors.slateGrey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
