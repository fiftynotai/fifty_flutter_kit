/// Gameplay Settings Section
///
/// Displays AI difficulty selector and turn timer configuration controls.
/// Uses FDL components: [FiftySectionHeader], [FiftyButton], [FiftySlider].
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../battle/models/game_state.dart';
import '../../actions/settings_actions.dart';
import '../../controllers/settings_view_model.dart';

/// Gameplay controls section with AI difficulty and timer settings.
///
/// Observes [SettingsViewModel] reactively via `Obx()`. All interactions
/// are delegated to [SettingsActions].
///
/// **Components:**
/// - AI Difficulty: Row of 3 buttons (EASY / MEDIUM / HARD).
/// - Turn Timer Duration slider (15s - 120s).
/// - Warning Threshold slider (5s - 30s).
/// - Critical Threshold slider (3s - 15s).
class GameplaySettingsSection extends StatelessWidget {
  /// Creates the gameplay settings section.
  const GameplaySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<SettingsViewModel>();
    final actions = Get.find<SettingsActions>();

    return Obx(() {
      final difficulty = vm.defaultDifficulty.value;
      final duration = vm.turnDuration.value;
      final warning = vm.warningThreshold.value;
      final critical = vm.criticalThreshold.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const FiftySectionHeader(
            title: 'Gameplay',
            size: FiftySectionHeaderSize.medium,
          ),

          // AI Difficulty label
          Text(
            'DEFAULT AI DIFFICULTY',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelMedium,
              fontWeight: FiftyTypography.bold,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            ),
          ),

          const SizedBox(height: FiftySpacing.sm),

          // Difficulty buttons row
          Row(
            children: [
              Expanded(
                child: FiftyButton(
                  label: 'EASY',
                  variant: difficulty == AIDifficulty.easy
                      ? FiftyButtonVariant.primary
                      : FiftyButtonVariant.ghost,
                  size: FiftyButtonSize.small,
                  onPressed: () =>
                      actions.onDifficultyChanged(AIDifficulty.easy),
                ),
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: FiftyButton(
                  label: 'MEDIUM',
                  variant: difficulty == AIDifficulty.medium
                      ? FiftyButtonVariant.primary
                      : FiftyButtonVariant.ghost,
                  size: FiftyButtonSize.small,
                  onPressed: () =>
                      actions.onDifficultyChanged(AIDifficulty.medium),
                ),
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: FiftyButton(
                  label: 'HARD',
                  variant: difficulty == AIDifficulty.hard
                      ? FiftyButtonVariant.primary
                      : FiftyButtonVariant.ghost,
                  size: FiftyButtonSize.small,
                  onPressed: () =>
                      actions.onDifficultyChanged(AIDifficulty.hard),
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.xl),

          // Turn Timer Duration
          _TimerSliderRow(
            label: 'TURN TIMER',
            value: duration.toDouble(),
            min: 15,
            max: 120,
            suffix: 's',
            onChanged: actions.onTurnDurationChanged,
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Warning Threshold
          _TimerSliderRow(
            label: 'WARNING THRESHOLD',
            value: warning.toDouble(),
            min: 5,
            max: 30,
            suffix: 's',
            onChanged: actions.onWarningThresholdChanged,
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Critical Threshold
          _TimerSliderRow(
            label: 'CRITICAL THRESHOLD',
            value: critical.toDouble(),
            min: 3,
            max: 15,
            suffix: 's',
            onChanged: actions.onCriticalThresholdChanged,
          ),
        ],
      );
    });
  }
}

/// A labeled timer slider row showing the value in seconds.
class _TimerSliderRow extends StatelessWidget {
  const _TimerSliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  /// Label text displayed above the slider.
  final String label;

  /// Current value.
  final double value;

  /// Minimum slider value.
  final double min;

  /// Maximum slider value.
  final double max;

  /// Suffix for the value display (e.g. 's' for seconds).
  final String suffix;

  /// Callback when the slider value changes.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              ),
            ),
            Text(
              '${value.round()}$suffix',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.medium,
                color: FiftyColors.slateGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.sm),

        // Slider
        FiftySlider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labelBuilder: (v) => '${v.round()}$suffix',
        ),
      ],
    );
  }
}
