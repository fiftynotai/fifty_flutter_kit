/// Inputs Section Widget
///
/// Showcases FDL input components.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

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
        const _SectionLabel(label: 'TEXT INPUT'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter text...',
                  hintStyle: const TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    color: FiftyColors.hyperChrome,
                  ),
                  filled: true,
                  fillColor: FiftyColors.voidBlack,
                  border: OutlineInputBorder(
                    borderRadius: FiftyRadii.standardRadius,
                    borderSide: const BorderSide(color: FiftyColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: FiftyRadii.standardRadius,
                    borderSide: const BorderSide(color: FiftyColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: FiftyRadii.standardRadius,
                    borderSide: const BorderSide(color: FiftyColors.crimsonPulse),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  color: FiftyColors.terminalWhite,
                ),
                onChanged: viewModel.setInputValue,
              ),
              if (viewModel.inputValue.isNotEmpty) ...[
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'VALUE: "${viewModel.inputValue}"',
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.mono,
                    color: FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Toggle Switch
        const _SectionLabel(label: 'TOGGLE SWITCH'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ENABLE FEATURE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.body,
                  color: FiftyColors.terminalWhite,
                ),
              ),
              GestureDetector(
                onTap: viewModel.toggleSwitch,
                child: Container(
                  width: 48,
                  height: 24,
                  decoration: BoxDecoration(
                    color: viewModel.switchValue
                        ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: viewModel.switchValue
                          ? FiftyColors.crimsonPulse
                          : FiftyColors.border,
                    ),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: viewModel.switchValue
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: viewModel.switchValue
                            ? FiftyColors.crimsonPulse
                            : FiftyColors.hyperChrome,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Slider
        const _SectionLabel(label: 'SLIDER'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'VALUE',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: FiftyColors.terminalWhite,
                    ),
                  ),
                  Text(
                    '${(viewModel.sliderValue * 100).toInt()}%',
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: FiftyColors.crimsonPulse,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FiftySpacing.md),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: FiftyColors.crimsonPulse,
                  inactiveTrackColor: FiftyColors.border,
                  thumbColor: FiftyColors.crimsonPulse,
                  overlayColor: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: viewModel.sliderValue,
                  onChanged: viewModel.setSliderValue,
                ),
              ),
            ],
          ),
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
