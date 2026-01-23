/// Settings Page
///
/// Provides app configuration, theme selection, and app information.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../controllers/settings_view_model.dart';

/// Settings page widget.
///
/// Displays theme options, app info, and configuration settings.
class SettingsPage extends GetView<SettingsViewModel> {
  /// Creates a settings page.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsViewModel>(
      builder: (viewModel) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Settings
                const SectionHeader(
                  title: 'Appearance',
                  subtitle: 'Theme and display settings',
                ),
                _buildThemeSelector(viewModel),
                const SizedBox(height: FiftySpacing.xl),

                // App Information
                const SectionHeader(
                  title: 'App Info',
                  subtitle: 'Version and build details',
                ),
                _buildAppInfo(),
                const SizedBox(height: FiftySpacing.xl),

                // About
                const SectionHeader(
                  title: 'About',
                  subtitle: 'Fifty Flutter Kit',
                ),
                _buildAbout(),
                const SizedBox(height: FiftySpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(SettingsViewModel viewModel) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          _buildThemeOption(
            viewModel,
            AppThemeMode.dark,
            'Dark Mode',
            'Default FDL theme',
            Icons.dark_mode_outlined,
          ),
          const Divider(
            color: FiftyColors.surfaceDark,
            height: FiftySpacing.md,
          ),
          _buildThemeOption(
            viewModel,
            AppThemeMode.light,
            'Light Mode',
            'Light theme variant',
            Icons.light_mode_outlined,
          ),
          const Divider(
            color: FiftyColors.surfaceDark,
            height: FiftySpacing.md,
          ),
          _buildThemeOption(
            viewModel,
            AppThemeMode.system,
            'System',
            'Follow device settings',
            Icons.settings_suggest_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    SettingsViewModel viewModel,
    AppThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = viewModel.themeMode == mode;

    return InkWell(
      onTap: () {
        viewModel.themeMode = mode;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FiftySpacing.sm),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? FiftyColors.burgundy : FiftyColors.cream,
              size: 24,
            ),
            const SizedBox(width: FiftySpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? FiftyColors.burgundy : FiftyColors.cream,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: FiftyColors.cream.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: FiftyColors.burgundy,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          _buildInfoRow('App', SettingsViewModel.appName),
          _buildInfoRow('Version', SettingsViewModel.appVersion),
          _buildInfoRow('Build', SettingsViewModel.buildNumber),
          _buildInfoRow('Architecture', SettingsViewModel.architecture),
          _buildInfoRow('Design System', SettingsViewModel.designSystem),
          _buildInfoRow('Framework', SettingsViewModel.frameworkVersion),
          _buildInfoRow('State', SettingsViewModel.stateManagement),
        ],
      ),
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
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: FiftyColors.cream,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout() {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FIFTY FLUTTER KIT',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyLarge,
              fontWeight: FontWeight.w600,
              color: FiftyColors.burgundy,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Text(
            'A comprehensive Flutter ecosystem providing design tokens, '
            'theming, UI components, and specialized engines for building '
            'sophisticated applications.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          const Divider(color: FiftyColors.surfaceDark),
          const SizedBox(height: FiftySpacing.sm),
          _buildInfoRow('Copyright', SettingsViewModel.copyright),
          _buildInfoRow('License', SettingsViewModel.license),
        ],
      ),
    );
  }
}
