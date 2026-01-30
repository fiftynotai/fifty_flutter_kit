/// Inputs Section Widget
///
/// Showcases FDL input components.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/section_label.dart';
import '../../controllers/ui_showcase_view_model.dart';

/// Inputs section widget.
///
/// Displays input fields, toggles, and sliders.
class InputsSection extends StatelessWidget {
  const InputsSection({
    required this.viewModel,
    super.key,
  });

  final UiShowcaseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Input
        const SectionLabel(label: 'TEXT INPUT'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            children: [
              // Standard input
              FiftyTextField(
                hint: 'Enter text...',
                onChanged: viewModel.setInputValue,
              ),
              const SizedBox(height: FiftySpacing.md),
              // Rounded search input
              const FiftyTextField(
                hint: 'Search...',
                prefix: Icon(Icons.search, size: 20),
                shape: FiftyTextFieldShape.rounded,
              ),
              if (viewModel.inputValue.isNotEmpty) ...[
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'VALUE: "${viewModel.inputValue}"',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Toggle Switch
        const SectionLabel(label: 'TOGGLE SWITCH'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENABLE FEATURE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: colorScheme.onSurface,
                ),
              ),
              FiftySwitch(
                value: viewModel.switchValue,
                onChanged: (_) => viewModel.toggleSwitch(),
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Slider
        const SectionLabel(label: 'SLIDER'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VOLUME',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),
              FiftySlider(
                value: viewModel.sliderValue,
                onChanged: viewModel.setSliderValue,
                showLabel: true,
                labelBuilder: (v) => '${(v * 100).toInt()}%',
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Radio Card
        const SectionLabel(label: 'RADIO CARD'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DISPLAY MODE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.semiBold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),
              Row(
                children: [
                  Expanded(
                    child: FiftyRadioCard<int>(
                      value: 0,
                      groupValue: viewModel.displayMode,
                      onChanged: viewModel.setDisplayMode,
                      icon: Icons.light_mode,
                      label: 'Light',
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: FiftyRadioCard<int>(
                      value: 1,
                      groupValue: viewModel.displayMode,
                      onChanged: viewModel.setDisplayMode,
                      icon: Icons.dark_mode,
                      label: 'Dark',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Segmented Control
        const SectionLabel(label: 'SEGMENTED CONTROL'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRIMARY VARIANT',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.semiBold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
              Text(
                'Cream background with burgundy text',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),
              FiftySegmentedControl<String>(
                segments: const [
                  FiftySegment(value: 'daily', label: 'Daily'),
                  FiftySegment(value: 'weekly', label: 'Weekly'),
                  FiftySegment(value: 'monthly', label: 'Monthly'),
                ],
                selected: viewModel.period,
                onChanged: viewModel.setPeriod,
                variant: FiftySegmentedControlVariant.primary,
              ),
              const SizedBox(height: FiftySpacing.xl),
              Text(
                'SECONDARY VARIANT',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.semiBold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
              Text(
                'Slate-grey background with cream text',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),
              FiftySegmentedControl<String>(
                segments: const [
                  FiftySegment(
                    value: 'light',
                    label: 'Light',
                    icon: Icons.light_mode,
                  ),
                  FiftySegment(
                    value: 'dark',
                    label: 'Dark',
                    icon: Icons.dark_mode,
                  ),
                  FiftySegment(
                    value: 'system',
                    label: 'System',
                    icon: Icons.settings_suggest,
                  ),
                ],
                selected: viewModel.themeSelection,
                onChanged: viewModel.setThemeSelection,
                variant: FiftySegmentedControlVariant.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

