/// Display Settings Section
///
/// Displays theme mode selector with Dark and Light options.
/// Uses FDL components: [FiftySectionHeader], [FiftyButton].
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../actions/settings_actions.dart';
import '../../controllers/settings_view_model.dart';

/// Display controls section with theme mode toggle.
///
/// Observes [SettingsViewModel] reactively via `Obx()`. All interactions
/// are delegated to [SettingsActions].
///
/// **Components:**
/// - Theme Mode: Two buttons (DARK / LIGHT) with selected state highlighted.
class DisplaySettingsSection extends StatelessWidget {
  /// Creates the display settings section.
  const DisplaySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<SettingsViewModel>();
    final actions = Get.find<SettingsActions>();

    return Obx(() {
      final currentTheme = vm.themeMode.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const FiftySectionHeader(
            title: 'Display',
            size: FiftySectionHeaderSize.medium,
          ),

          // Theme Mode label
          Text(
            'THEME MODE',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelMedium,
              fontWeight: FiftyTypography.bold,
              color: FiftyColors.cream,
              letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            ),
          ),

          const SizedBox(height: FiftySpacing.sm),

          // Theme mode buttons
          Row(
            children: [
              Expanded(
                child: _ThemeModeCard(
                  label: 'DARK',
                  icon: Icons.dark_mode_rounded,
                  isSelected: currentTheme == ThemeMode.dark,
                  onTap: () => actions.onThemeModeChanged(ThemeMode.dark),
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: _ThemeModeCard(
                  label: 'LIGHT',
                  icon: Icons.light_mode_rounded,
                  isSelected: currentTheme == ThemeMode.light,
                  onTap: () => actions.onThemeModeChanged(ThemeMode.light),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

/// A selectable card for theme mode options.
///
/// Displays an icon and label with highlighted border when selected.
class _ThemeModeCard extends StatelessWidget {
  const _ThemeModeCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  /// Display label (e.g. 'DARK', 'LIGHT').
  final String label;

  /// Icon displayed above the label.
  final IconData icon;

  /// Whether this option is currently selected.
  final bool isSelected;

  /// Callback when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: FiftySpacing.lg,
          horizontal: FiftySpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withAlpha(30)
              : Colors.transparent,
          borderRadius: FiftyRadii.mdRadius,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : FiftyColors.slateGrey.withAlpha(60),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? colorScheme.primary : FiftyColors.slateGrey,
            ),
            const SizedBox(height: FiftySpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight:
                    isSelected ? FiftyTypography.bold : FiftyTypography.medium,
                color: isSelected ? colorScheme.primary : FiftyColors.slateGrey,
                letterSpacing: FiftyTypography.letterSpacingLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
