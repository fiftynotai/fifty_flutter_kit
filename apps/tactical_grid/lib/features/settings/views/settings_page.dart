/// Settings Page
///
/// Main settings screen for Tactical Grid. Displays three configurable
/// sections: Audio, Gameplay, and Display. Includes a "Reset to Defaults"
/// button at the bottom.
///
/// Accessible from the menu via the SETTINGS button.
///
/// **Layout:**
/// ```
/// [< Back]  SETTINGS
/// ────────────────────
/// AUDIO section
/// GAMEPLAY section
/// DISPLAY section
/// [RESET TO DEFAULTS]
/// ```
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../actions/settings_actions.dart';
import 'widgets/audio_settings_section.dart';
import 'widgets/display_settings_section.dart';
import 'widgets/gameplay_settings_section.dart';

/// Full settings page with audio, gameplay, and display sections.
///
/// Uses [SettingsActions] for user interactions and observes
/// [SettingsViewModel] for reactive state updates via `Obx()`.
class SettingsPage extends StatelessWidget {
  /// Creates the settings page.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = Get.find<SettingsActions>();

    return Scaffold(
      backgroundColor: FiftyColors.darkBurgundy,
      body: SafeArea(
        child: Column(
          children: [
            // -- Header row: back button + title --
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.md,
                vertical: FiftySpacing.sm,
              ),
              child: Row(
                children: [
                  FiftyIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back to menu',
                    variant: FiftyIconButtonVariant.ghost,
                    size: FiftyIconButtonSize.small,
                    onPressed: () => Get.back<void>(),
                  ),
                  const SizedBox(width: FiftySpacing.md),
                  Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.titleLarge,
                      fontWeight: FiftyTypography.bold,
                      color: FiftyColors.cream,
                      letterSpacing: FiftyTypography.letterSpacingLabel,
                    ),
                  ),
                ],
              ),
            ),

            // -- Scrollable settings content --
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.xl,
                  vertical: FiftySpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AudioSettingsSection(),
                    const SizedBox(height: FiftySpacing.xl),
                    const GameplaySettingsSection(),
                    const SizedBox(height: FiftySpacing.xl),
                    const DisplaySettingsSection(),
                    const SizedBox(height: FiftySpacing.xxl),

                    // -- Reset to defaults button --
                    Center(
                      child: FiftyButton(
                        label: 'RESET TO DEFAULTS',
                        variant: FiftyButtonVariant.ghost,
                        size: FiftyButtonSize.medium,
                        onPressed: () => actions.onResetToDefaults(),
                      ),
                    ),

                    const SizedBox(height: FiftySpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
