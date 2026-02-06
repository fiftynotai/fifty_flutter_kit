import 'package:flutter/material.dart';

import '../../../core/animations/animation_constants.dart';
import '../../../core/animations/scroll_reveal.dart';
import '../../../core/theme/sneaker_colors.dart';
import '../../../core/theme/sneaker_radii.dart' as radii;
import '../../../core/theme/sneaker_spacing.dart';
import '../../../core/theme/sneaker_typography.dart';
import '../data/models/sneaker_model.dart';
import '../data/services/sneaker_service.dart';
import 'widgets/countdown/drop_countdown.dart';
import 'widgets/hero/kinetic_headline.dart';
import 'widgets/navigation/glass_nav_bar.dart';
import 'widgets/product/floating_sneaker.dart';
import 'widgets/product/sneaker_card.dart';
import 'widgets/product/sneaker_image.dart';

/// **LandingPage**
///
/// Hero landing page with floating sneaker and kinetic headline.
///
/// Sections:
/// 1. Hero section (100vh) - Kinetic headline + floating sneaker
/// 2. Drops section - Upcoming releases with countdown
/// 3. Trending section - Hot sneakers with price trends
/// 4. Brands section - Brand logos carousel
/// 5. Footer - Links and newsletter
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final SneakerService _sneakerService = SneakerService();

  List<SneakerModel> _trendingSneakers = [];
  List<SneakerModel> _upcomingDrops = [];
  List<String> _brands = [];
  bool _isLoading = true;

  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _parallaxOffset = _scrollController.offset * 0.3;
    });
  }

  Future<void> _loadData() async {
    try {
      final trending = await _sneakerService.fetchTrending();
      final drops = await _sneakerService.fetchUpcomingDrops();
      final brands = await _sneakerService.fetchBrands();

      if (mounted) {
        setState(() {
          _trendingSneakers = trending;
          _upcomingDrops = drops.isNotEmpty
              ? drops
              : trending.take(4).toList(); // Fallback if no drops
          _brands = brands;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassNavBar(
        currentRoute: '/',
        cartItemCount: 0,
        onNavigate: (route) {
          // Navigation handling
        },
        onSearchTap: () {
          // Search handling
        },
        onCartTap: () {
          // Cart handling
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: SneakerColors.surfaceGradient,
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: SneakerColors.burgundy,
                ),
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Hero Section
                  SliverToBoxAdapter(
                    child: _buildHeroSection(context),
                  ),

                  // Drops Section
                  SliverToBoxAdapter(
                    child: _buildDropsSection(context),
                  ),

                  // Trending Section
                  SliverToBoxAdapter(
                    child: _buildTrendingSection(context),
                  ),

                  // Brands Section
                  SliverToBoxAdapter(
                    child: _buildBrandsSection(context),
                  ),

                  // Footer
                  SliverToBoxAdapter(
                    child: _buildFooter(context),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: screenHeight,
      decoration: const BoxDecoration(
        gradient: SneakerColors.heroGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
          ),
          child: isMobile
              ? _buildMobileHeroLayout(context)
              : _buildDesktopHeroLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopHeroLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Text content
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KineticHeadline(
                text: 'STEP INTO',
                style: SneakerTypography.heroHeadline.copyWith(
                  fontSize: 64,
                  color: SneakerColors.slateGrey,
                ),
                staggerDelay: const Duration(milliseconds: 100),
              ),
              const SizedBox(height: SneakerSpacing.sm),
              KineticHeadline(
                text: 'THE FUTURE',
                style: SneakerTypography.heroHeadline.copyWith(
                  fontSize: 72,
                  color: SneakerColors.cream,
                ),
                initialDelay: const Duration(milliseconds: 300),
                staggerDelay: const Duration(milliseconds: 150),
              ),
              const SizedBox(height: SneakerSpacing.xxl),
              ScrollReveal(
                delay: const Duration(milliseconds: 800),
                child: Text(
                  'Discover exclusive drops, rare grails, and the hottest releases.',
                  style: SneakerTypography.body.copyWith(
                    color: SneakerColors.slateGrey,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: SneakerSpacing.xxxl),
              ScrollReveal(
                delay: const Duration(milliseconds: 1000),
                child: _buildShopNowButton(),
              ),
            ],
          ),
        ),

        // Right side - Floating sneaker
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -_parallaxOffset * 0.5),
            child: _trendingSneakers.isNotEmpty
                ? FloatingSneaker(
                    imageUrl: _trendingSneakers.first.imageUrl,
                    size: 400,
                    parallaxFactor: 0.5,
                    scrollController: _scrollController,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeroLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Floating sneaker (smaller on mobile)
        Transform.translate(
          offset: Offset(0, -_parallaxOffset * 0.3),
          child: _trendingSneakers.isNotEmpty
              ? FloatingSneaker(
                  imageUrl: _trendingSneakers.first.imageUrl,
                  size: 250,
                  parallaxFactor: 0.3,
                  scrollController: _scrollController,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: SneakerSpacing.xxl),

        // Text content
        KineticHeadline(
          text: 'STEP INTO',
          style: SneakerTypography.heroHeadline.copyWith(
            fontSize: 36,
            color: SneakerColors.slateGrey,
          ),
          staggerDelay: const Duration(milliseconds: 100),
        ),
        const SizedBox(height: SneakerSpacing.sm),
        KineticHeadline(
          text: 'THE FUTURE',
          style: SneakerTypography.heroHeadline.copyWith(
            fontSize: 44,
            color: SneakerColors.cream,
          ),
          initialDelay: const Duration(milliseconds: 300),
          staggerDelay: const Duration(milliseconds: 150),
        ),
        const SizedBox(height: SneakerSpacing.lg),
        ScrollReveal(
          delay: const Duration(milliseconds: 800),
          child: Text(
            'Discover exclusive drops and rare grails.',
            style: SneakerTypography.description.copyWith(
              color: SneakerColors.slateGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xxl),
        ScrollReveal(
          delay: const Duration(milliseconds: 1000),
          child: _buildShopNowButton(),
        ),
      ],
    );
  }

  Widget _buildShopNowButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to shop
        },
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.xxxl,
            vertical: SneakerSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: SneakerColors.burgundy,
            borderRadius: radii.SneakerRadii.radiusMd,
            boxShadow: [
              BoxShadow(
                color: SneakerColors.burgundy.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SHOP NOW',
                style: SneakerTypography.label.copyWith(
                  color: SneakerColors.cream,
                ),
              ),
              const SizedBox(width: SneakerSpacing.sm),
              const Icon(
                Icons.arrow_forward_rounded,
                color: SneakerColors.cream,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
        vertical: SneakerSpacing.massive,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: _buildSectionHeader('DROPPING SOON', 'View All'),
          ),
          const SizedBox(height: SneakerSpacing.xxl),
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _upcomingDrops.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: SneakerSpacing.lg),
              itemBuilder: (context, index) {
                return ScrollReveal(
                  delay: Duration(milliseconds: 100 * index),
                  child: _buildDropCard(_upcomingDrops[index], index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropCard(SneakerModel sneaker, int index) {
    // Generate mock drop times for demo
    final dropTime = DateTime.now().add(Duration(
      days: index + 1,
      hours: (index * 5) % 24,
      minutes: (index * 17) % 60,
    ));

    return Container(
      width: 260,
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: radii.SneakerRadii.card,
        border: Border.all(color: SneakerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: radii.SneakerRadii.radiusLg,
              child: Container(
                color: SneakerColors.darkBurgundy,
                child: Center(
                  child: SneakerImage(
                    imageUrl: sneaker.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: SneakerSpacing.md),

          // Brand
          Text(
            sneaker.brand.toUpperCase(),
            style: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              fontSize: 10,
              fontWeight: SneakerTypography.semiBold,
              letterSpacing: 1.5,
              color: SneakerColors.slateGrey,
            ),
          ),
          const SizedBox(height: 4),

          // Name
          Text(
            sneaker.name,
            style: SneakerTypography.cardTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Colorway
          Text(
            '"${sneaker.colorway}"',
            style: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              fontSize: 12,
              fontWeight: SneakerTypography.regular,
              color: SneakerColors.slateGrey,
            ),
          ),
          const SizedBox(height: SneakerSpacing.md),

          // Countdown
          DropCountdown(
            dropTime: dropTime,
            compact: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
        vertical: SneakerSpacing.massive,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: _buildSectionHeader('TRENDING NOW', 'View All'),
          ),
          const SizedBox(height: SneakerSpacing.xxl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: SneakerSpacing.lg,
              mainAxisSpacing: SneakerSpacing.lg,
              childAspectRatio: 0.7,
            ),
            itemCount: _trendingSneakers.take(crossAxisCount * 2).length,
            itemBuilder: (context, index) {
              return ScrollReveal(
                delay: Duration(milliseconds: 50 * index),
                child: SneakerCard(
                  sneaker: _trendingSneakers[index],
                  onTap: () {
                    // Navigate to detail
                  },
                  onQuickAdd: () {
                    // Add to cart
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
        vertical: SneakerSpacing.massive,
      ),
      decoration: BoxDecoration(
        color: SneakerColors.darkBurgundy.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          ScrollReveal(
            child: Text(
              'SHOP BY BRAND',
              style: SneakerTypography.sectionTitle.copyWith(
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: SneakerSpacing.xxxl),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _brands.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: SneakerSpacing.xxl),
              itemBuilder: (context, index) {
                return ScrollReveal(
                  delay: Duration(milliseconds: 100 * index),
                  child: _buildBrandChip(_brands[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandChip(String brand) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to brand page
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.xxl,
            vertical: SneakerSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: SneakerColors.surfaceDark,
            borderRadius: radii.SneakerRadii.radiusXl,
            border: Border.all(color: SneakerColors.border),
          ),
          child: Center(
            child: Text(
              brand.toUpperCase(),
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.cream,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: SneakerTypography.sectionTitle.copyWith(
            letterSpacing: 2,
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // Navigate to full list
            },
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: SneakerTypography.label.copyWith(
                    color: SneakerColors.burgundy,
                  ),
                ),
                const SizedBox(width: SneakerSpacing.xs),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: SneakerColors.burgundy,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? SneakerSpacing.lg : SneakerSpacing.xxxl,
        vertical: SneakerSpacing.massive,
      ),
      decoration: const BoxDecoration(
        color: SneakerColors.darkBurgundy,
        border: Border(
          top: BorderSide(color: SneakerColors.border),
        ),
      ),
      child: isMobile
          ? _buildMobileFooter()
          : _buildDesktopFooter(),
    );
  }

  Widget _buildDesktopFooter() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SNEAKER DROPS',
                    style: SneakerTypography.productTitle.copyWith(
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: SneakerSpacing.md),
                  Text(
                    'Your destination for exclusive sneaker releases, rare grails, and the hottest drops.',
                    style: SneakerTypography.description.copyWith(
                      color: SneakerColors.slateGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SneakerSpacing.xxxl),

            // Links columns
            Expanded(
              child: _buildFooterColumn('SHOP', [
                'All Sneakers',
                'New Releases',
                'Trending',
                'Grails',
              ]),
            ),
            Expanded(
              child: _buildFooterColumn('SUPPORT', [
                'Help Center',
                'Shipping',
                'Returns',
                'Contact Us',
              ]),
            ),
            Expanded(
              child: _buildFooterColumn('COMPANY', [
                'About',
                'Careers',
                'Press',
                'Blog',
              ]),
            ),

            // Newsletter
            Expanded(
              flex: 2,
              child: _buildNewsletterSection(),
            ),
          ],
        ),
        const SizedBox(height: SneakerSpacing.xxxl),
        const Divider(color: SneakerColors.border),
        const SizedBox(height: SneakerSpacing.lg),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SNEAKER DROPS',
          style: SneakerTypography.productTitle.copyWith(
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: SneakerSpacing.md),
        Text(
          'Your destination for exclusive sneaker releases.',
          style: SneakerTypography.description.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xxl),
        _buildNewsletterSection(),
        const SizedBox(height: SneakerSpacing.xxl),
        const Divider(color: SneakerColors.border),
        const SizedBox(height: SneakerSpacing.lg),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.cream,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: SneakerSpacing.sm),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              link,
              style: SneakerTypography.description.copyWith(
                color: SneakerColors.slateGrey,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildNewsletterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STAY IN THE LOOP',
          style: SneakerTypography.label.copyWith(
            color: SneakerColors.cream,
          ),
        ),
        const SizedBox(height: SneakerSpacing.sm),
        Text(
          'Get notified about exclusive drops and releases.',
          style: SneakerTypography.description.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SneakerSpacing.lg,
                  vertical: SneakerSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: SneakerColors.surfaceDark,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(radii.SneakerRadii.md),
                  ),
                  border: Border.all(color: SneakerColors.border),
                ),
                child: Text(
                  'Enter your email',
                  style: SneakerTypography.description.copyWith(
                    color: SneakerColors.slateGrey,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SneakerSpacing.lg,
                vertical: SneakerSpacing.md,
              ),
              decoration: BoxDecoration(
                color: SneakerColors.burgundy,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(radii.SneakerRadii.md),
                ),
              ),
              child: Text(
                'SUBSCRIBE',
                style: SneakerTypography.label.copyWith(
                  color: SneakerColors.cream,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '2025 Sneaker Drops. All rights reserved.',
          style: SneakerTypography.badge.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        Row(
          children: [
            _buildSocialIcon(Icons.language),
            const SizedBox(width: SneakerSpacing.md),
            _buildSocialIcon(Icons.camera_alt_outlined),
            const SizedBox(width: SneakerSpacing.md),
            _buildSocialIcon(Icons.alternate_email),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Icon(
        icon,
        color: SneakerColors.slateGrey,
        size: 20,
      ),
    );
  }
}
