/// Dialogue Demo Page
///
/// Demonstrates sentence engine with speech integration.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
import '../actions/dialogue_demo_actions.dart';
import '../controllers/dialogue_demo_view_model.dart';
import 'widgets/dialogue_display.dart';
import 'widgets/stt_controls.dart';
import 'widgets/tts_controls.dart';

/// Dialogue demo page widget.
///
/// Shows dialogue playback with TTS/STT controls.
class DialogueDemoPage extends GetView<DialogueDemoViewModel> {
  const DialogueDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<DialogueDemoActions>()) {
        DialogueDemoActions.instance.onInitialize(context);
        // Load default dialogue
        Get.find<DialogueDemoViewModel>().selectDialogue('Introduction');
      }
    });

    return GetBuilder<DialogueDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<DialogueDemoActions>();
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Row
                Row(
                  children: [
                    StatusIndicator(
                      label: 'TTS',
                      state: viewModel.ttsEnabled
                          ? StatusState.ready
                          : StatusState.idle,
                    ),
                    const SizedBox(width: FiftySpacing.lg),
                    StatusIndicator(
                      label: 'STT',
                      state: viewModel.sttListening
                          ? StatusState.loading
                          : StatusState.idle,
                    ),
                    const SizedBox(width: FiftySpacing.lg),
                    Builder(
                      builder: (context) {
                        final colorScheme = Theme.of(context).colorScheme;
                        return Text(
                          viewModel.progressLabel,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodySmall,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Dialogue Selection
                const SectionHeader(
                  title: 'Select Dialogue',
                  subtitle: 'Choose a demo dialogue',
                ),
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Wrap(
                      spacing: FiftySpacing.sm,
                      children: viewModel.dialogueOptions.map((name) {
                        final isSelected = name == viewModel.selectedDialogue;
                        return GestureDetector(
                          onTap: () => viewModel.selectDialogue(name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: FiftySpacing.md,
                              vertical: FiftySpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              borderRadius: FiftyRadii.lgRadius,
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.bodySmall,
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Dialogue Display
                const SectionHeader(
                  title: 'Dialogue',
                  subtitle: 'Tap to advance',
                ),
                DialogueDisplay(
                  text: viewModel.displayedText,
                  speaker: viewModel.currentSpeaker,
                  isTyping: viewModel.isProcessing,
                  onTap: () => actions.onDialogueTapped(context),
                ),
                const SizedBox(height: FiftySpacing.md),
                // Progress bar
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return LinearProgressIndicator(
                      value: viewModel.progress,
                      backgroundColor: colorScheme.outline,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Playback Controls
                const SectionHeader(
                  title: 'Playback',
                  subtitle: 'Dialogue controls',
                ),
                FiftyCard(
                  padding: const EdgeInsets.all(FiftySpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: Icons.skip_previous,
                        onTap: () => actions.onPreviousTapped(context),
                      ),
                      _ControlButton(
                        icon: viewModel.isPlaying
                            ? Icons.stop
                            : Icons.play_arrow,
                        onTap: viewModel.isPlaying
                            ? actions.onStopTapped
                            : () => actions.onPlayTapped(context),
                        isPrimary: true,
                      ),
                      _ControlButton(
                        icon: Icons.skip_next,
                        onTap: () => actions.onNextTapped(context),
                      ),
                      _ControlButton(
                        icon: Icons.replay,
                        onTap: actions.onResetTapped,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FiftySpacing.xl),

                // TTS Controls
                const SectionHeader(
                  title: 'Text-to-Speech',
                  subtitle: 'TTS settings',
                ),
                TtsControls(
                  enabled: viewModel.ttsEnabled,
                  autoAdvance: viewModel.autoAdvance,
                  onToggleTts: actions.onToggleTts,
                  onToggleAutoAdvance: actions.onToggleAutoAdvance,
                ),
                const SizedBox(height: FiftySpacing.xl),

                // STT Controls
                const SectionHeader(
                  title: 'Speech-to-Text',
                  subtitle: 'Voice commands',
                ),
                SttControls(
                  isListening: viewModel.sttListening,
                  recognizedText: viewModel.recognizedText,
                  onMicTapped: () => actions.onMicTapped(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isPrimary ? 56 : 44,
        height: isPrimary ? 56 : 44,
        decoration: BoxDecoration(
          color: isPrimary
              ? colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isPrimary ? colorScheme.primary : colorScheme.outline,
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: isPrimary
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.7),
          size: isPrimary ? 28 : 20,
        ),
      ),
    );
  }
}
