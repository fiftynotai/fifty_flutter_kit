/// Display Section Widget
///
/// Showcases FDL display components.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/section_label.dart';
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
        const SectionLabel(label: 'CARDS'),
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
        const SectionLabel(label: 'DATA SLATE'),
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

        // Stat Cards
        const SectionLabel(label: 'STAT CARDS'),
        const SizedBox(height: FiftySpacing.md),
        const Row(
          children: [
            Expanded(
              child: FiftyStatCard(
                label: 'Total Views',
                value: '45.2k',
                icon: Icons.visibility,
                trend: FiftyStatTrend.up,
                trendValue: '12%',
              ),
            ),
            SizedBox(width: FiftySpacing.md),
            Expanded(
              child: FiftyStatCard(
                label: 'Revenue',
                value: '\$12.5k',
                icon: Icons.account_balance_wallet,
                highlight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // List Tiles
        const SectionLabel(label: 'LIST TILES'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              FiftyListTile(
                leadingIcon: Icons.subscriptions,
                leadingIconColor: Colors.blue,
                leadingIconBackgroundColor: Colors.blue.withValues(alpha: 0.15),
                title: 'Subscription',
                subtitle: 'Adobe Creative Cloud',
                trailingText: '-\$54.00',
                trailingSubtext: 'Today',
                showDivider: true,
              ),
              FiftyListTile(
                leadingIcon: Icons.arrow_downward,
                leadingIconColor: FiftyColors.hunterGreen,
                leadingIconBackgroundColor:
                    FiftyColors.hunterGreen.withValues(alpha: 0.15),
                title: 'Deposit',
                subtitle: 'Freelance Work',
                trailingText: '+\$850.00',
                trailingTextColor: FiftyColors.hunterGreen,
                trailingSubtext: 'Yesterday',
                showDivider: true,
              ),
              const FiftyListTile(
                leadingIcon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Push alerts enabled',
                trailing: Icon(Icons.chevron_right, color: FiftyColors.slateGrey),
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Navigation Bar
        const SectionLabel(label: 'NAVIGATION BAR'),
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
        const SectionLabel(label: 'COLOR PALETTE'),
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


class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  /// Width for color swatch container (based on content needs).
  static const double _swatchWidth = 80;

  /// Size for the color preview square.
  static const double _colorPreviewSize = 40;

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _swatchWidth,
      padding: const EdgeInsets.all(FiftySpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: FiftyColors.borderDark),
        borderRadius: FiftyRadii.lgRadius,
      ),
      child: Column(
        children: [
          Container(
            width: _colorPreviewSize,
            height: _colorPreviewSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: FiftyRadii.smRadius,
              border: Border.all(color: FiftyColors.borderDark),
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: FiftyColors.slateGrey,
            ),
          ),
        ],
      ),
    );
  }
}
