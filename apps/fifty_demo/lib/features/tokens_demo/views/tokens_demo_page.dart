/// Tokens Demo Page
///
/// Demonstrates runtime palette switching via FiftyTokens.configure().
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/tokens_demo_actions.dart';
import '../controllers/tokens_demo_view_model.dart';

/// Tokens demo page widget.
///
/// Shows color swatches for the active palette and buttons to swap
/// between FDL v2 and Baltic Blue at runtime.
class TokensDemoPage extends GetView<TokensDemoViewModel> {
  /// Creates a tokens demo page.
  const TokensDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TokensDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<TokensDemoActions>();

        return DemoScaffold(
          title: 'Fifty Tokens',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active palette indicator
                const FiftySectionHeader(
                  title: 'Active Palette',
                  subtitle: 'Runtime token configuration demo',
                ),
                _buildPaletteIndicator(context, viewModel),
                SizedBox(height: FiftySpacing.xl),

                // Color swatches
                const FiftySectionHeader(
                  title: 'Color Tokens',
                  subtitle: 'Current semantic color values',
                ),
                _buildColorSwatches(context),
                SizedBox(height: FiftySpacing.xl),

                // Action buttons
                const FiftySectionHeader(
                  title: 'Palette Switcher',
                  subtitle: 'Swap tokens and rebuild theme at runtime',
                ),
                _buildActionButtons(context, viewModel, actions),
                SizedBox(height: FiftySpacing.xl),

                // How it works
                _buildHowItWorks(context),
                SizedBox(height: FiftySpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaletteIndicator(
    BuildContext context,
    TokensDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(FiftyRadii.sm),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.paletteName.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  viewModel.isBalticBlue
                      ? 'Baltic Blue preset via FiftyTokens.load()'
                      : 'Default design tokens (FiftyPreset.fdlV2)',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Configuration status badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FiftySpacing.sm,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: viewModel.isBalticBlue
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              viewModel.isBalticBlue ? 'CUSTOM' : 'DEFAULT',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                fontWeight: FontWeight.bold,
                color: viewModel.isBalticBlue
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatches(BuildContext context) {
    // Read colors from FiftyColors (which reads from FiftyTokens.active)
    final swatches = [
      ('Primary', FiftyColors.primary),
      ('Secondary', FiftyColors.secondary),
      ('Background', FiftyColors.background),
      ('Surface', FiftyColors.surface),
      ('Success', FiftyColors.success),
      ('Accent', FiftyColors.accent),
    ];

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: swatches.map((swatch) {
          final (label, color) = swatch;
          return _buildSwatchRow(context, label, color);
        }).toList(),
      ),
    );
  }

  Widget _buildSwatchRow(BuildContext context, String label, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    final hex =
        '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        children: [
          // Color swatch
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(FiftyRadii.sm),
              border: Border.all(
                color: colorScheme.outline,
              ),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          // Label
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Hex value
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FiftySpacing.sm,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              hex,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TokensDemoViewModel viewModel,
    TokensDemoActions actions,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FiftyButton(
            label: 'APPLY BALTIC BLUE',
            onPressed: viewModel.isBalticBlue
                ? null
                : () => actions.onApplyBalticBlue(context),
            variant: FiftyButtonVariant.primary,
          ),
        ),
        SizedBox(height: FiftySpacing.md),
        SizedBox(
          width: double.infinity,
          child: FiftyButton(
            label: 'RESET TO FDL V2',
            onPressed: viewModel.isBalticBlue
                ? () => actions.onResetToFdl(context)
                : null,
            variant: FiftyButtonVariant.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
              SizedBox(width: FiftySpacing.sm),
              Text(
                'HOW IT WORKS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.sm),
          _buildInfoItem(
            context,
            'FiftyTokens.load(preset) swaps the entire active preset',
          ),
          _buildInfoItem(
            context,
            'FiftyTheme.dark() / .light() read from FiftyTokens.active',
          ),
          _buildInfoItem(
            context,
            'Get.forceAppUpdate() rebuilds the entire widget tree',
          ),
          _buildInfoItem(
            context,
            'All pages reflect the new palette instantly',
          ),
          _buildInfoItem(
            context,
            'FiftyTokens.reset() restores FDL v2 defaults',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: FiftySpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
