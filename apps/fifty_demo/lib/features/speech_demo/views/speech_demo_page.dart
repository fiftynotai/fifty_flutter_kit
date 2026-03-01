/// Speech Demo Page
///
/// Demonstrates speech engine with TTS and STT functionality.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/speech_demo_actions.dart';
import '../controllers/speech_demo_view_model.dart';

/// Speech demo page widget.
///
/// Shows TTS and STT functionality demonstration.
class SpeechDemoPage extends GetView<SpeechDemoViewModel> {
  /// Creates a speech demo page.
  const SpeechDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpeechDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<SpeechDemoActions>();
        final colorScheme = Theme.of(context).colorScheme;

        return DemoScaffold(
          title: 'Speech Engine',
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Row
                  _buildStatusRow(context, viewModel),
                  SizedBox(height: FiftySpacing.xl),

                  // Error Message
                  _buildErrorCard(context, viewModel),

                  // TTS Section
                  const FiftySectionHeader(
                    title: 'Text-to-Speech',
                    subtitle: 'Convert text to spoken audio',
                  ),
                  _buildTtsSection(context, viewModel, actions),
                  SizedBox(height: FiftySpacing.xl),

                  // Voice Settings Section
                  const FiftySectionHeader(
                    title: 'Voice Settings',
                    subtitle: 'Adjust rate, pitch, and volume',
                  ),
                  _buildVoiceSettingsSection(context, viewModel, actions),
                  SizedBox(height: FiftySpacing.xl),

                  // Preset Phrases Section
                  const FiftySectionHeader(
                    title: 'Sample Phrases',
                    subtitle: 'Tap to speak a preset phrase',
                  ),
                  _buildPresetPhrasesSection(context, viewModel, actions),
                  SizedBox(height: FiftySpacing.xl),

                  // STT Section
                  const FiftySectionHeader(
                    title: 'Speech-to-Text',
                    subtitle: 'Convert spoken audio to text',
                  ),
                  _buildSttSection(context, viewModel, actions),
                  SizedBox(height: FiftySpacing.xl),

                  // Recognition History Section
                  if (viewModel.recognitionHistory.isNotEmpty) ...[
                    FiftySectionHeader(
                      title: 'Recognition History',
                      subtitle: '${viewModel.recognitionHistory.length} phrases',
                      trailing: TextButton(
                        onPressed: actions.onClearHistoryTapped,
                        child: Text(
                          'CLEAR',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodySmall,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    _buildHistorySection(context, viewModel),
                    SizedBox(height: FiftySpacing.xl),
                  ],
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildStatusRow(BuildContext context, SpeechDemoViewModel viewModel) {
    return Row(
      children: [
        FiftyStatusIndicator(
          label: 'TTS',
          state: !viewModel.ttsEnabled
              ? FiftyStatusState.offline
              : viewModel.isSpeaking
                  ? FiftyStatusState.loading
                  : FiftyStatusState.ready,
        ),
        SizedBox(width: FiftySpacing.lg),
        FiftyStatusIndicator(
          label: 'STT',
          state: !viewModel.sttEnabled
              ? FiftyStatusState.offline
              : !viewModel.sttAvailable
                  ? FiftyStatusState.offline
                  : viewModel.isListening
                      ? FiftyStatusState.loading
                      : FiftyStatusState.ready,
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, SpeechDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;

    if (viewModel.errorMessage.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: FiftySpacing.md),
      child: FiftyCard(
        padding: EdgeInsets.all(FiftySpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.error,
              size: 20,
            ),
            SizedBox(width: FiftySpacing.sm),
            Expanded(
              child: Text(
                viewModel.errorMessage,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTtsSection(
    BuildContext context,
    SpeechDemoViewModel viewModel,
    SpeechDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TTS Enable Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.record_voice_over,
                    color: viewModel.ttsEnabled
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  SizedBox(width: FiftySpacing.sm),
                  Text(
                    'ENABLE TTS',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyMedium,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              FiftySwitch(
                value: viewModel.ttsEnabled,
                onChanged: (value) => actions.onTtsToggled(enabled: value),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.md),

          // Text Input
          FiftyTextField(
            hint: 'Enter text to speak...',
            onChanged: actions.onTextChanged,
            maxLines: 3,
            enabled: viewModel.ttsEnabled,
          ),
          SizedBox(height: FiftySpacing.md),

          // Speak/Stop Buttons
          Row(
            children: [
              Expanded(
                child: FiftyButton(
                  label: viewModel.isSpeaking ? 'SPEAKING...' : 'SPEAK',
                  variant: FiftyButtonVariant.primary,
                  loading: viewModel.isSpeaking,
                  onPressed: viewModel.ttsEnabled &&
                          !viewModel.isSpeaking &&
                          viewModel.currentText.isNotEmpty
                      ? () => actions.onSpeakTapped(context, viewModel.currentText)
                      : null,
                ),
              ),
              if (viewModel.isSpeaking) ...[
                SizedBox(width: FiftySpacing.sm),
                FiftyButton(
                  label: 'STOP',
                  variant: FiftyButtonVariant.secondary,
                  onPressed: actions.onStopSpeakingTapped,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSettingsSection(
    BuildContext context,
    SpeechDemoViewModel viewModel,
    SpeechDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          // Speech Rate
          _buildSliderRow(
            context: context,
            icon: Icons.speed,
            label: 'RATE',
            value: viewModel.speechRate,
            min: 0.25,
            max: 2.0,
            displayValue: '${viewModel.speechRate.toStringAsFixed(2)}x',
            onChanged: viewModel.ttsEnabled ? actions.onSpeechRateChanged : null,
          ),
          SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: FiftySpacing.md),

          // Pitch
          _buildSliderRow(
            context: context,
            icon: Icons.tune,
            label: 'PITCH',
            value: viewModel.pitch,
            min: 0.5,
            max: 2.0,
            displayValue: viewModel.pitch.toStringAsFixed(2),
            onChanged: viewModel.ttsEnabled ? actions.onPitchChanged : null,
          ),
          SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: FiftySpacing.md),

          // Volume
          _buildSliderRow(
            context: context,
            icon: Icons.volume_up,
            label: 'VOLUME',
            value: viewModel.volume,
            min: 0.0,
            max: 1.0,
            displayValue: '${(viewModel.volume * 100).round()}%',
            onChanged: viewModel.ttsEnabled ? actions.onVolumeChanged : null,
          ),
          SizedBox(height: FiftySpacing.md),

          // Reset Button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: 'RESET TO DEFAULTS',
              variant: FiftyButtonVariant.ghost,
              onPressed: viewModel.ttsEnabled ? actions.onResetSettingsTapped : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required void Function(double)? onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onChanged != null;

    return Row(
      children: [
        Icon(
          icon,
          color: enabled
              ? colorScheme.onSurface.withValues(alpha: 0.7)
              : colorScheme.onSurface.withValues(alpha: 0.3),
          size: 20,
        ),
        SizedBox(width: FiftySpacing.sm),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: enabled
                  ? colorScheme.onSurface.withValues(alpha: 0.7)
                  : colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
        Expanded(
          child: FiftySlider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            displayValue,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: enabled ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPhrasesSection(
    BuildContext context,
    SpeechDemoViewModel viewModel,
    SpeechDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: viewModel.samplePhrases.map((phrase) {
        return Padding(
          padding: EdgeInsets.only(bottom: FiftySpacing.sm),
          child: FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.md),
            onTap: viewModel.ttsEnabled && !viewModel.isSpeaking
                ? () => actions.onPresetPhraseTapped(context, phrase)
                : null,
            child: Opacity(
              opacity: viewModel.ttsEnabled ? 1.0 : 0.5,
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      phrase,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyMedium,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSttSection(
    BuildContext context,
    SpeechDemoViewModel viewModel,
    SpeechDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STT Enable Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.mic,
                    color: viewModel.sttEnabled
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  SizedBox(width: FiftySpacing.sm),
                  Text(
                    'ENABLE STT',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyMedium,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              FiftySwitch(
                value: viewModel.sttEnabled,
                onChanged: (value) => actions.onSttToggled(enabled: value),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.lg),

          // Microphone Button and Status
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: viewModel.sttEnabled ? () => actions.onMicTapped(context) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: viewModel.isListening
                          ? colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: viewModel.isListening
                            ? colorScheme.primary
                            : viewModel.sttEnabled
                                ? colorScheme.outline
                                : colorScheme.outline.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      viewModel.isListening ? Icons.mic : Icons.mic_none,
                      color: viewModel.isListening
                          ? colorScheme.primary
                          : viewModel.sttEnabled
                              ? colorScheme.onSurface.withValues(alpha: 0.7)
                              : colorScheme.onSurface.withValues(alpha: 0.3),
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: FiftySpacing.md),
                Text(
                  viewModel.isListening
                      ? 'LISTENING...'
                      : viewModel.sttEnabled
                          ? 'TAP TO SPEAK'
                          : 'DISABLED',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: viewModel.isListening
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Real-time Transcription Display
          if (viewModel.recognizedText.isNotEmpty || viewModel.isListening) ...[
            SizedBox(height: FiftySpacing.lg),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(
                  color: viewModel.isListening ? colorScheme.primary : colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (viewModel.isListening)
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(right: FiftySpacing.sm),
                          decoration: BoxDecoration(
                            color: fiftyTheme?.warning ?? colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        viewModel.isListening ? 'RECOGNIZING...' : 'RECOGNIZED:',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: FiftySpacing.sm),
                  Text(
                    viewModel.recognizedText.isNotEmpty
                        ? '"${viewModel.recognizedText}"'
                        : 'Waiting for speech...',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyLarge,
                      color: viewModel.recognizedText.isNotEmpty
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, SpeechDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Column(
      children: viewModel.recognitionHistory.map((phrase) {
        final confidencePercent = (phrase.confidence * 100).round();
        final timeAgo = _formatTimeAgo(phrase.timestamp);

        return Padding(
          padding: EdgeInsets.only(bottom: FiftySpacing.sm),
          child: FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${phrase.text}"',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: colorScheme.onSurface,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: FiftySpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: successColor,
                          size: 14,
                        ),
                        SizedBox(width: FiftySpacing.xs),
                        Text(
                          '$confidencePercent% confidence',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodySmall,
                            color: successColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }
}
