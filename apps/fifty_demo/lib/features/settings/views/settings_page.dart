/// Settings Page
///
/// Provides app configuration, theme selection, and app information.
/// Uses theme-aware colors for light/dark mode support.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../controllers/settings_view_model.dart';

/// Settings page widget.
///
/// Displays theme options, app info, and configuration settings.
/// Uses theme-aware colors via [ColorScheme].
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
                const FiftySectionHeader(
                  title: 'Appearance',
                  subtitle: 'Theme and display settings',
                ),
                _buildThemeSelector(context, viewModel),
                SizedBox(height: FiftySpacing.xl),

                // App Information
                const FiftySectionHeader(
                  title: 'App Info',
                  subtitle: 'Version and build details',
                ),
                _buildAppInfo(context),
                SizedBox(height: FiftySpacing.xl),

                // About
                const FiftySectionHeader(
                  title: 'About',
                  subtitle: 'Fifty Flutter Kit',
                ),
                _buildAbout(context),
                SizedBox(height: FiftySpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          _buildThemeOption(
            context,
            viewModel,
            AppThemeMode.dark,
            'Dark Mode',
            'Default FDL theme',
            Icons.dark_mode_outlined,
          ),
          Divider(
            color: colorScheme.surfaceContainerHighest,
            height: FiftySpacing.md,
          ),
          _buildThemeOption(
            context,
            viewModel,
            AppThemeMode.light,
            'Light Mode',
            'Light theme variant',
            Icons.light_mode_outlined,
          ),
          Divider(
            color: colorScheme.surfaceContainerHighest,
            height: FiftySpacing.md,
          ),
          _buildThemeOption(
            context,
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
    BuildContext context,
    SettingsViewModel viewModel,
    AppThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = viewModel.themeMode == mode;

    return InkWell(
      onTap: () {
        viewModel.themeMode = mode;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: FiftySpacing.sm),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: FiftySpacing.md),
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
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          _buildInfoRow(context, 'App', SettingsViewModel.appName),
          _buildInfoRow(context, 'Version', SettingsViewModel.appVersion),
          _buildInfoRow(context, 'Build', SettingsViewModel.buildNumber),
          _buildInfoRow(context, 'Architecture', SettingsViewModel.architecture),
          _buildInfoRow(context, 'Design System', SettingsViewModel.designSystem),
          _buildInfoRow(context, 'Framework', SettingsViewModel.frameworkVersion),
          _buildInfoRow(context, 'State', SettingsViewModel.stateManagement),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
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
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FIFTY FLUTTER KIT',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyLarge,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: FiftySpacing.sm),
          Text(
            'A comprehensive Flutter ecosystem providing design tokens, '
            'theming, UI components, and specialized engines for building '
            'sophisticated applications.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: FiftySpacing.md),
          Divider(color: colorScheme.surfaceContainerHighest),
          SizedBox(height: FiftySpacing.sm),
          _buildInfoRow(context, 'Copyright', SettingsViewModel.copyright),
          _buildInfoRow(context, 'License', SettingsViewModel.license),
        ],
      ),
    );
  }
}
