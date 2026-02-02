/// Home Page
///
/// Main landing page for the Fifty Demo app.
/// Displays getting started actions, updates, and resources.
/// Uses theme-aware colors for light/dark mode support.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../dialogue_demo/views/dialogue_demo_page.dart';
import '../../map_demo/views/map_demo_page.dart';
import '../controllers/home_view_model.dart';
import 'widgets/getting_started_section.dart';
import 'widgets/resources_section.dart';
import 'widgets/whats_new_section.dart';

/// Home page widget.
///
/// Displays getting started actions, what's new, resources, and system info.
/// Uses theme-aware colors via [ColorScheme].
class HomePage extends GetView<HomeViewModel> {
  /// Creates the home page.
  ///
  /// [onTabChange] is an optional callback to switch to a different tab.
  /// If not provided, tab navigation will show a snackbar message.
  const HomePage({
    super.key,
    this.onTabChange,
  });

  /// Callback to switch to a different tab index.
  ///
  /// Index mapping:
  /// - 0: Home
  /// - 1: Packages
  /// - 2: UI Kit
  /// - 3: Settings
  final void Function(int index)? onTabChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GetBuilder<HomeViewModel>(
      builder: (viewModel) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Getting Started Section
                const FiftySectionHeader(
                  title: 'Getting Started',
                  subtitle: 'Quick actions',
                ),
                GettingStartedSection(
                  onExplorePackages: () => _navigateToTab(context, 1),
                  onUiComponents: () => _navigateToTab(context, 2),
                  onAudioDemo: () => Get.to<void>(() => const DialogueDemoPage()),
                  onMapDemo: () => Get.to<void>(() => const MapDemoPage()),
                ),
                const SizedBox(height: FiftySpacing.xxl),

                // What's New Section
                const FiftySectionHeader(
                  title: "What's New",
                  subtitle: 'Recent updates',
                ),
                const WhatsNewSection(),
                const SizedBox(height: FiftySpacing.xxl),

                // Resources Section
                const FiftySectionHeader(
                  title: 'Resources',
                  subtitle: 'External links',
                ),
                const ResourcesSection(),
                const SizedBox(height: FiftySpacing.xxl),

                // System Info Section
                const FiftySectionHeader(
                  title: 'System Info',
                  subtitle: 'Application details',
                ),
                FiftyCard(
                  padding: const EdgeInsets.all(FiftySpacing.lg),
                  hasTexture: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(colorScheme, 'App', 'Fifty Demo'),
                      _buildInfoRow(colorScheme, 'Version', '1.0.0'),
                      _buildInfoRow(colorScheme, 'Architecture', 'MVVM + Actions'),
                      _buildInfoRow(colorScheme, 'UI System', 'Fifty Design Language'),
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

  /// Navigates to a tab by index.
  ///
  /// Uses [onTabChange] callback if provided, otherwise shows a snackbar.
  void _navigateToTab(BuildContext context, int tabIndex) {
    if (onTabChange != null) {
      onTabChange!(tabIndex);
    } else {
      // Fallback: show snackbar with navigation hint
      final tabNames = ['Home', 'Packages', 'UI Kit', 'Settings'];
      FiftySnackbar.show(
        context,
        message: 'Navigate to ${tabNames[tabIndex]} tab',
        variant: FiftySnackbarVariant.info,
      );
    }
  }

  Widget _buildInfoRow(ColorScheme colorScheme, String label, String value) {
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
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
