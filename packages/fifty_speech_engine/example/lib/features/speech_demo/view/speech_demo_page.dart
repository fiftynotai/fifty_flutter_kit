/// Speech demo page - main view for TTS and STT demonstration.
///
/// Combines TTS and STT panels into a single scrollable page
/// with proper state management through ViewModel and Actions.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../actions/speech_demo_actions.dart';
import '../viewmodel/speech_demo_viewmodel.dart';
import 'widgets/stt_panel.dart';
import 'widgets/tts_panel.dart';

/// Main page for the speech demo feature.
class SpeechDemoPage extends StatefulWidget {
  const SpeechDemoPage({super.key});

  @override
  State<SpeechDemoPage> createState() => _SpeechDemoPageState();
}

class _SpeechDemoPageState extends State<SpeechDemoPage> {
  late final SpeechDemoViewModel _viewModel;
  late final SpeechDemoActions _actions;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator<SpeechDemoViewModel>();
    _actions = serviceLocator<SpeechDemoActions>();
    _initialize();
  }

  Future<void> _initialize() async {
    await _actions.onInitialize();
    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return _buildLoadingState();
    }

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return _buildContent();
      },
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: FiftySpacing.lg),
          Text(
            'INITIALIZING SPEECH ENGINE...',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyLarge,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      children: [
        // TTS Panel
        TtsPanel(
          isSpeaking: _viewModel.isSpeaking,
          currentLanguage: _viewModel.language,
          availableLanguages: _viewModel.availableLanguages,
          statusLabel: _viewModel.ttsStatusLabel,
          onSpeak: _actions.onSpeakTapped,
          onStop: _actions.onStopSpeakingTapped,
          onLanguageChanged: _actions.onLanguageChanged,
        ),

        const SizedBox(height: FiftySpacing.xl),

        // STT Panel
        SttPanel(
          isListening: _viewModel.isListening,
          isProcessing: _viewModel.isProcessing,
          recognizedText: _viewModel.displayText,
          statusLabel: _viewModel.sttStatusLabel,
          continuousListening: _viewModel.continuousListening,
          hasError: _viewModel.hasError,
          errorMessage: _viewModel.lastError,
          onListenToggle: _actions.onListenTapped,
          onClear: _actions.onClearRecognizedText,
          onContinuousToggle: _actions.onContinuousListeningToggled,
        ),

        const SizedBox(height: FiftySpacing.xl),

        // Info card
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildInfoCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Text(
                'ABOUT THIS DEMO',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.medium,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          Text(
            'This demo showcases the fifty_speech_engine package capabilities:\n\n'
            '- Text-to-Speech (TTS): Convert text to natural speech\n'
            '- Speech-to-Text (STT): Recognize and transcribe speech\n'
            '- Multiple language support\n'
            '- Continuous and single-phrase recognition modes\n\n'
            'Note: Speech recognition requires microphone permissions.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
