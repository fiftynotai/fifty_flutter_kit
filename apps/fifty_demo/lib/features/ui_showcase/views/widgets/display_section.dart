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
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.cream,
                ),
              ),
              SizedBox(height: FiftySpacing.sm),
              Text(
                'Cards provide containment for content with consistent styling.',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: FiftyColors.slateGrey,
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
                FiftyColors.burgundy,
                FiftyColors.cream,
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
            _ColorSwatch(color: FiftyColors.burgundy, label: 'BURGUNDY'),
            _ColorSwatch(color: FiftyColors.darkBurgundy, label: 'DARK BURGUNDY'),
            _ColorSwatch(color: FiftyColors.cream, label: 'CREAM'),
            _ColorSwatch(color: FiftyColors.slateGrey, label: 'SLATE GREY'),
            _ColorSwatch(color: FiftyColors.hunterGreen, label: 'HUNTER GREEN'),
            _ColorSwatch(color: FiftyColors.powderBlush, label: 'POWDER BLUSH'),
            _ColorSwatch(color: FiftyColors.warning, label: 'WARNING'),
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
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        color: FiftyColors.slateGrey,
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
        border: Border.all(color: FiftyColors.borderDark),
        borderRadius: FiftyRadii.lgRadius,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: FiftyColors.borderDark),
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 8,
              color: FiftyColors.slateGrey,
            ),
          ),
        ],
      ),
    );
  }
}
