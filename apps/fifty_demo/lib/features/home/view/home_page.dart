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
import '../viewmodel/home_viewmodel.dart';
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
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.mono,
                        color: FiftyColors.hyperChrome,
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
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: FiftyColors.hyperChrome,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: FiftyColors.terminalWhite,
            ),
          ),
        ],
      ),
    );
  }
}
