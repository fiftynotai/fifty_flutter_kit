import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/sneaker_model.dart';
import 'price_trend.dart';
import 'sneaker_image.dart';

/// **RelatedProducts**
///
/// Horizontal carousel of related sneakers.
///
/// Displays a scrollable row of related product cards with
/// image, name, and price information.
///
/// **Example Usage:**
/// ```dart
/// RelatedProducts(
///   sneakers: relatedSneakers,
///   onSneakerTap: (sneaker) => navigateToDetail(sneaker),
/// )
/// ```
class RelatedProducts extends StatelessWidget {
  /// List of related sneakers to display.
  final List<SneakerModel> sneakers;

  /// Callback when a sneaker is tapped.
  final ValueChanged<SneakerModel> onSneakerTap;

  /// Section title. Defaults to 'YOU MAY ALSO LIKE'.
  final String title;

  /// Height of product cards.
  final double cardHeight;

  /// Creates a [RelatedProducts] carousel.
  const RelatedProducts({
    required this.sneakers,
    required this.onSneakerTap,
    this.title = 'YOU MAY ALSO LIKE',
    this.cardHeight = 240,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (sneakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: SneakerSpacing.horizontalLg,
          child: Text(
            title,
            style: SneakerTypography.label.copyWith(
              letterSpacing: 2,
              color: SneakerColors.slateGrey,
            ),
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Carousel
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: SneakerSpacing.horizontalLg,
            itemCount: sneakers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: SneakerSpacing.md),
            itemBuilder: (context, index) {
              return _RelatedProductCard(
                sneaker: sneakers[index],
                onTap: () => onSneakerTap(sneakers[index]),
                height: cardHeight,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Internal related product card widget.
class _RelatedProductCard extends StatefulWidget {
  final SneakerModel sneaker;
  final VoidCallback onTap;
  final double height;

  const _RelatedProductCard({
    required this.sneaker,
    required this.onTap,
    required this.height,
  });

  @override
  State<_RelatedProductCard> createState() => _RelatedProductCardState();
}

class _RelatedProductCardState extends State<_RelatedProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Card width based on height to maintain aspect ratio
    final cardWidth = widget.height * 0.75;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          width: cardWidth,
          height: widget.height,
          transform: Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: SneakerColors.surfaceDark,
            borderRadius: SneakerRadii.radiusLg,
            border: Border.all(
              color: _isHovered
                  ? SneakerColors.burgundy.withValues(alpha: 0.5)
                  : SneakerColors.border,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: SneakerColors.burgundy.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(SneakerRadii.lg - 1),
                  ),
                  child: Container(
                    color: SneakerColors.darkBurgundy,
                    child: SneakerImage(
                      imageUrl: widget.sneaker.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: SneakerSpacing.allMd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        widget.sneaker.brand.toUpperCase(),
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
                      Expanded(
                        child: Text(
                          widget.sneaker.name,
                          style: TextStyle(
                            fontFamily: SneakerTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: SneakerTypography.bold,
                            color: SneakerColors.cream,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Price
                      PriceTrendCompact(
                        price: widget.sneaker.price,
                        marketPrice: widget.sneaker.marketPrice,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// **RelatedProductsGrid**
///
/// Grid layout variant of related products for larger screens.
///
/// **Example Usage:**
/// ```dart
/// RelatedProductsGrid(
///   sneakers: relatedSneakers,
///   onSneakerTap: (sneaker) => navigateToDetail(sneaker),
///   columns: 4,
/// )
/// ```
class RelatedProductsGrid extends StatelessWidget {
  /// List of related sneakers to display.
  final List<SneakerModel> sneakers;

  /// Callback when a sneaker is tapped.
  final ValueChanged<SneakerModel> onSneakerTap;

  /// Section title.
  final String title;

  /// Number of columns.
  final int columns;

  /// Creates a [RelatedProductsGrid].
  const RelatedProductsGrid({
    required this.sneakers,
    required this.onSneakerTap,
    this.title = 'YOU MAY ALSO LIKE',
    this.columns = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (sneakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          title,
          style: SneakerTypography.label.copyWith(
            letterSpacing: 2,
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final spacing = SneakerSpacing.md;
            final totalSpacing = spacing * (columns - 1);
            final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: sneakers.map((sneaker) {
                return SizedBox(
                  width: itemWidth,
                  child: _RelatedProductCard(
                    sneaker: sneaker,
                    onTap: () => onSneakerTap(sneaker),
                    height: itemWidth * 1.4,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
