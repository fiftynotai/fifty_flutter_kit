/// Home Page
///
/// Main landing page for the Fifty Demo app.
/// Displays ecosystem status and navigation to demo features.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
import '../controllers/home_view_model.dart';
import 'widgets/ecosystem_status.dart';
import 'widgets/feature_nav_card.dart';

/// Home page widget.
///
/// Displays ecosystem status overview and feature navigation cards.
class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      builder: (viewModel) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ecosystem Status Section
                const SectionHeader(
                  title: 'Ecosystem Status',
                  subtitle: 'Fifty package integration status',
                ),
                EcosystemStatus(packages: viewModel.packages),
                const SizedBox(height: FiftySpacing.xl),

                // Quick Status Row
                Row(
                  children: [
                    StatusIndicator(
                      label: 'PACKAGES',
                      state: viewModel.allReady
                          ? StatusState.ready
                          : StatusState.loading,
                    ),
                    const SizedBox(width: FiftySpacing.lg),
                    Text(
                      '${viewModel.readyCount}/${viewModel.totalCount} READY',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: FiftyColors.cream.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.xxl),

                // Analytics Section
                const SectionHeader(
                  title: 'Analytics',
                  subtitle: 'Demo statistics overview',
                ),
                const Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        icon: Icons.visibility_outlined,
                        value: '45.2k',
                        label: 'Total Views',
                        trend: '+12%',
                      ),
                    ),
                    SizedBox(width: FiftySpacing.md),
                    Expanded(
                      child: _StatsCard(
                        icon: Icons.favorite_outline,
                        value: '8.4k',
                        label: 'Likes',
                        trend: '+5%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.md),
                const Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        icon: Icons.shopping_cart_outlined,
                        value: '350',
                        label: 'Orders',
                        trend: '+2%',
                      ),
                    ),
                    SizedBox(width: FiftySpacing.md),
                    Expanded(
                      child: _StatsCard(
                        icon: Icons.attach_money,
                        value: '\$12.5k',
                        label: 'Revenue',
                        trend: '+8%',
                        accentColor: FiftyColors.hunterGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.xxl),

                // Demo Features Section
                const SectionHeader(
                  title: 'Demo Features',
                  subtitle: 'Explore ecosystem capabilities',
                ),
                ...HomeViewModel.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: FiftySpacing.md),
                    child: FeatureNavCard(
                      title: feature.title,
                      subtitle: feature.subtitle,
                      icon: IconData(feature.icon, fontFamily: 'MaterialIcons'),
                      onTap: () {
                        // Navigation handled by parent IndexedStack
                      },
                    ),
                  ),
                ),
                const SizedBox(height: FiftySpacing.xxl),

                // System Info Section
                const SectionHeader(
                  title: 'System Info',
                  subtitle: 'Application details',
                ),
                FiftyCard(
                  padding: const EdgeInsets.all(FiftySpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('App', 'Fifty Demo'),
                      _buildInfoRow('Version', '1.0.0'),
                      _buildInfoRow('Architecture', 'MVVM + Actions'),
                      _buildInfoRow('UI System', 'Fifty Design Language'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream,
            ),
          ),
        ],
      ),
    );
  }
}

/// A statistics card widget for the home page.
class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.trend,
    this.accentColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final String trend;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? FiftyColors.burgundy;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: FiftyRadii.smRadius,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: FiftyColors.hunterGreen.withValues(alpha: 0.1),
                  borderRadius: FiftyRadii.smRadius,
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FontWeight.bold,
                    color: FiftyColors.hunterGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          Text(
            value,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.titleLarge,
              fontWeight: FontWeight.bold,
              color: FiftyColors.cream,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: FiftyColors.cream.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
