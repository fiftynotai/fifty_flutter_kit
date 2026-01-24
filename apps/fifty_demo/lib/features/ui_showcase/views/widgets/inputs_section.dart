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
              FiftyTextField(
                hint: 'Enter text...',
                onChanged: viewModel.setInputValue,
              ),
              if (viewModel.inputValue.isNotEmpty) ...[
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'VALUE: "${viewModel.inputValue}"',
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.slateGrey,
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
              const Text(
                'ENABLE FEATURE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: FiftyColors.cream,
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
              const Text(
                'VOLUME',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: FiftyColors.cream,
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
      ],
    );
  }
}

