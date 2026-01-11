/// Display Section Widget
///
/// Showcases FDL display components.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../controllers/ui_showcase_view_model.dart';

/// Display section widget.
///
/// Shows cards, data slates, and navigation components.
class DisplaySection extends StatelessWidget {
  const DisplaySection({
    required this.viewModel,
    super.key,
  });

  final UiShowcaseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cards
        const _SectionLabel(label: 'CARDS'),
        const SizedBox(height: FiftySpacing.md),
        const FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STANDARD CARD',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyHeadline,
                  fontSize: FiftyTypography.body,
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.terminalWhite,
                ),
              ),
              SizedBox(height: FiftySpacing.sm),
              Text(
                'Cards provide containment for content with consistent styling.',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.mono,
                  color: FiftyColors.hyperChrome,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Data Slate
        const _SectionLabel(label: 'DATA SLATE'),
        const SizedBox(height: FiftySpacing.md),
        const FiftyDataSlate(
          title: 'SYSTEM STATUS',
          data: {
            'CPU': '45%',
            'Memory': '2.4 GB',
            'Uptime': '72h',
            'Status': 'ONLINE',
          },
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Hero Section
        const _SectionLabel(label: 'HERO SECTION'),
        const SizedBox(height: FiftySpacing.md),
        const FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.lg),
          child: FiftyHeroSection(
            title: 'HERO TITLE',
            subtitle: 'Supporting text goes here',
            titleSize: FiftyHeroSize.h2,
            titleGradient: LinearGradient(
              colors: [
                FiftyColors.crimsonPulse,
                FiftyColors.terminalWhite,
              ],
            ),
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Navigation Bar
        const _SectionLabel(label: 'NAVIGATION BAR'),
        const SizedBox(height: FiftySpacing.md),
        FiftyNavBar(
          items: const [
            FiftyNavItem(label: 'HOME', icon: Icons.home),
            FiftyNavItem(label: 'SEARCH', icon: Icons.search),
            FiftyNavItem(label: 'SETTINGS', icon: Icons.settings),
          ],
          selectedIndex: viewModel.tabIndex,
          onItemSelected: viewModel.setTabIndex,
          style: FiftyNavBarStyle.pill,
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Color Palette
        const _SectionLabel(label: 'COLOR PALETTE'),
        const SizedBox(height: FiftySpacing.md),
        const Wrap(
          spacing: FiftySpacing.sm,
          runSpacing: FiftySpacing.sm,
          children: [
            _ColorSwatch(color: FiftyColors.crimsonPulse, label: 'CRIMSON'),
            _ColorSwatch(color: FiftyColors.voidBlack, label: 'VOID'),
            _ColorSwatch(color: FiftyColors.terminalWhite, label: 'TERMINAL'),
            _ColorSwatch(color: FiftyColors.hyperChrome, label: 'CHROME'),
            _ColorSwatch(color: FiftyColors.igrisGreen, label: 'GREEN'),
            _ColorSwatch(color: FiftyColors.warning, label: 'WARNING'),
            _ColorSwatch(color: FiftyColors.error, label: 'ERROR'),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        color: FiftyColors.hyperChrome,
        letterSpacing: 1,
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(FiftySpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: FiftyColors.border),
        borderRadius: FiftyRadii.standardRadius,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: FiftyColors.border),
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: 8,
              color: FiftyColors.hyperChrome,
            ),
          ),
        ],
      ),
    );
  }
}
