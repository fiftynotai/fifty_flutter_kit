import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/modules/menu/controllers/menu_view_model.dart';
import '/src/modules/menu/views/menu_drawer_item.dart';
import '/src/modules/menu/views/logout_drawer_item.dart';
import '/src/modules/theme/theme.dart';
import '/src/modules/locale/locale.dart';

/// Navigation drawer widget styled as "Command Center".
///
/// Displays a side drawer with FDL Kinetic Brutalism aesthetic:
/// - voidBlack background
/// - "COMMAND CENTER" header with crimsonPulse accent
/// - Operator status badge
/// - Navigation menu items with gunmetal/crimsonPulse styling
/// - Settings section with theme and language controls
/// - Logout option at bottom
///
/// ## Usage:
/// ```dart
/// Scaffold(
///   drawer: SideMenuDrawer(),
///   // ...
/// )
/// ```
///
/// The drawer is reactive and automatically updates when menu items change.
class SideMenuDrawer extends GetWidget<MenuViewModel> {
  /// Creates a [SideMenuDrawer].
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Command Center header
              _buildCommandCenterHeader(context),

              const FiftyDivider(),

              // Navigation section
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: FiftySpacing.sm),

                    // Section header: NAVIGATION
                    _buildSectionHeader('NAVIGATION'),
                    const SizedBox(height: FiftySpacing.sm),

                    // Menu items
                    ...controller.menuItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final menuItem = entry.value;

                      return MenuDrawerItem(
                        label: menuItem.label,
                        icon: menuItem.icon,
                        isSelected: controller.isSelected(index),
                        onTap: () {
                          controller.selectMenuItemByIndex(index);
                          Navigator.of(context).pop(); // Close drawer
                        },
                      );
                    }),

                    const SizedBox(height: FiftySpacing.lg),
                    const FiftyDivider(),
                    const SizedBox(height: FiftySpacing.md),

                    // Section header: SETTINGS
                    _buildSectionHeader(tkSettings.tr.toUpperCase()),
                    const SizedBox(height: FiftySpacing.sm),

                    // Theme switcher with FDL styling
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode_outlined,
                      child: const ThemeDrawerItem(),
                    ),

                    // Language switcher with FDL styling
                    _buildSettingsItem(
                      context,
                      icon: Icons.language,
                      child: const LanguageDrawerItem(),
                    ),
                  ],
                ),
              ),

              // Bottom section: Logout
              const FiftyDivider(),
              const LogoutDrawerItem(),
              const SizedBox(height: FiftySpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Command Center header with logo and status badge.
  Widget _buildCommandCenterHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Command Center title row
          Row(
            children: [
              // Logo with crimson glow effect
              Container(
                padding: const EdgeInsets.all(FiftySpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(FiftySpacing.sm),
                  border: Border.all(
                    color: FiftyColors.crimsonPulse.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AssetsManager.logoPath,
                  height: 32,
                  width: 32,
                  colorFilter: const ColorFilter.mode(
                    FiftyColors.crimsonPulse,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => const Icon(
                    Icons.radar,
                    size: 32,
                    color: FiftyColors.crimsonPulse,
                  ),
                ),
              ),
              const SizedBox(width: FiftySpacing.md),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMMAND CENTER',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyHeadline,
                        fontSize: FiftyTypography.body,
                        fontWeight: FiftyTypography.ultrabold,
                        color: FiftyColors.crimsonPulse,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      appName.tr.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.mono,
                        fontWeight: FiftyTypography.regular,
                        color: FiftyColors.hyperChrome,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.md),

          // Operator status badge
          FiftyChip(
            label: 'OPERATOR ONLINE',
            variant: FiftyChipVariant.success,
          ),
        ],
      ),
    );
  }

  /// Builds a section header with FDL styling.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              color: FiftyColors.crimsonPulse,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              fontWeight: FiftyTypography.medium,
              color: FiftyColors.hyperChrome,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps settings items with FDL-consistent styling.
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          iconColor: FiftyColors.hyperChrome,
          textColor: colorScheme.onSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
          ),
        ),
      ),
      child: child,
    );
  }
}
