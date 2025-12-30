/// Sentences demo page - main view for sentence processing demonstration.
///
/// Combines dialogue display, queue panel, and controls into a single
/// scrollable page with proper state management through ViewModel and Actions.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../actions/sentences_demo_actions.dart';
import '../viewmodel/sentences_demo_viewmodel.dart';
import 'widgets/dialogue_display.dart';
import 'widgets/instruction_buttons_panel.dart';
import 'widgets/sentence_queue_panel.dart';

/// Main page for the sentences demo feature.
class SentencesDemoPage extends StatefulWidget {
  const SentencesDemoPage({super.key});

  @override
  State<SentencesDemoPage> createState() => _SentencesDemoPageState();
}

class _SentencesDemoPageState extends State<SentencesDemoPage> {
  late final SentencesDemoViewModel _viewModel;
  late final SentencesDemoActions _actions;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator<SentencesDemoViewModel>();
    _actions = serviceLocator<SentencesDemoActions>();
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: FiftyColors.crimsonPulse,
          ),
          SizedBox(height: FiftySpacing.lg),
          Text(
            'INITIALIZING SENTENCES ENGINE...',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              color: FiftyColors.hyperChrome,
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
        // Dialogue Display
        DialogueDisplay(
          currentText: _viewModel.currentText,
          state: _viewModel.state,
          statusLabel: _viewModel.statusLabel,
          choices: _viewModel.currentChoices,
          onTapToContinue: _actions.onTapToContinue,
          onChoiceSelected: _actions.onChoiceSelected,
        ),

        const SizedBox(height: FiftySpacing.xl),

        // Sentence Queue Panel
        SentenceQueuePanel(
          queue: _viewModel.queue,
          getInstructionLabel: _viewModel.getInstructionLabel,
        ),

        const SizedBox(height: FiftySpacing.xl),

        // Instruction Buttons Panel
        InstructionButtonsPanel(
          canProcess: _viewModel.canProcess,
          canPause: _viewModel.canPause,
          canResume: _viewModel.canResume,
          canClearQueue: _viewModel.canClearQueue,
          isActive: _viewModel.isActive,
          onAddWriteTapped: _actions.onAddWriteTapped,
          onAddReadTapped: _actions.onAddReadTapped,
          onAddAskTapped: _actions.onAddAskTapped,
          onAddWaitTapped: _actions.onAddWaitTapped,
          onProcessTapped: _actions.onProcessTapped,
          onPauseTapped: _actions.onPauseTapped,
          onResumeTapped: _actions.onResumeTapped,
          onClearQueueTapped: _actions.onClearQueueTapped,
          onClearAllTapped: _actions.onClearAllTapped,
          onLoadDemoStoryTapped: _actions.onLoadDemoStoryTapped,
        ),

        const SizedBox(height: FiftySpacing.xl),

        // Info card
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal.withValues(alpha: 0.5),
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: FiftyColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: FiftyColors.hyperChrome,
                size: 20,
              ),
              SizedBox(width: FiftySpacing.sm),
              Text(
                'ABOUT THIS DEMO',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.mono,
                  fontWeight: FiftyTypography.medium,
                  color: FiftyColors.hyperChrome,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.md),
          Text(
            'This demo showcases the fifty_sentences_engine package capabilities:\n\n'
            '- WRITE: Display text on screen (narration)\n'
            '- READ: Trigger text-to-speech (voice output)\n'
            '- ASK: Present choices and wait for selection\n'
            '- WAIT: Pause until user taps to continue\n\n'
            'Add sentences to the queue, then tap PROCESS to execute them in order. '
            'The engine handles instruction interpretation, flow control, and user interaction.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: FiftyColors.hyperChrome,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
