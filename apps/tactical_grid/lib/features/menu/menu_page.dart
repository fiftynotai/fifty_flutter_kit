/// Menu Page
///
/// Main menu screen for Tactical Grid with title, navigation buttons,
/// and version info. Uses FDL tokens throughout for consistent theming.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../core/routes/route_manager.dart';

/// Main menu screen with game title and navigation buttons.
///
/// Layout:
/// - Game title ("TACTICAL" / "GRID") in display text
/// - Subtitle "A FIFTY SHOWCASE"
/// - PLAY button (primary, navigates to battle)
/// - SETTINGS button (outline, navigates to settings)
/// - Version label at the bottom
class MenuPage extends StatelessWidget {
  /// Creates the main menu page.
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.darkBurgundy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.xxl,
            vertical: FiftySpacing.lg,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Title block
              const _TitleSection(),
              const Spacer(flex: 2),
              // Navigation buttons
              const _NavigationSection(),
              const Spacer(flex: 2),
              // Version label
              const _VersionLabel(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title section with "TACTICAL GRID" and subtitle.
class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TACTICAL',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.displayLarge,
            fontWeight: FiftyTypography.extraBold,
            color: FiftyColors.cream,
            letterSpacing: FiftyTypography.letterSpacingDisplay,
            height: FiftyTypography.lineHeightDisplay,
          ),
        ),
        Text(
          'GRID',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.displayLarge,
            fontWeight: FiftyTypography.extraBold,
            color: FiftyColors.cream,
            letterSpacing: FiftyTypography.letterSpacingDisplay,
            height: FiftyTypography.lineHeightDisplay,
          ),
        ),
        const SizedBox(height: FiftySpacing.md),
        Text(
          'A FIFTY SHOWCASE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodyMedium,
            fontWeight: FiftyTypography.regular,
            color: FiftyColors.slateGrey,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          ),
        ),
      ],
    );
  }
}

/// Navigation section with PLAY and SETTINGS buttons.
class _NavigationSection extends StatelessWidget {
  const _NavigationSection();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FiftyButton(
            label: 'PLAY',
            variant: FiftyButtonVariant.primary,
            size: FiftyButtonSize.large,
            expanded: true,
            onPressed: () => RouteManager.toBattle(),
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyButton(
            label: 'ACHIEVEMENTS',
            variant: FiftyButtonVariant.outline,
            size: FiftyButtonSize.medium,
            expanded: true,
            onPressed: () => RouteManager.toAchievements(),
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyButton(
            label: 'SETTINGS',
            variant: FiftyButtonVariant.outline,
            size: FiftyButtonSize.medium,
            expanded: true,
            onPressed: () => RouteManager.toSettings(),
          ),
        ],
      ),
    );
  }
}

/// Version label displayed at the bottom of the menu.
class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'v1.0.0',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
          letterSpacing: FiftyTypography.letterSpacingBodySmall,
        ),
      ),
    );
  }
}
