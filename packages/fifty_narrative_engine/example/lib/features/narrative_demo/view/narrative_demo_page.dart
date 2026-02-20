/// Sentences demo page - main view for sentence processing demonstration.
///
/// Combines dialogue display, queue panel, and controls into a single
/// scrollable page with proper state management through ViewModel and Actions.
library;

import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../actions/narrative_demo_actions.dart';
import '../viewmodel/narrative_demo_viewmodel.dart';
import 'widgets/dialogue_display.dart';
import 'widgets/instruction_buttons_panel.dart';
import 'widgets/narrative_queue_panel.dart';

/// Main page for the sentences demo feature.
class NarrativeDemoPage extends StatefulWidget {
  const NarrativeDemoPage({super.key});

  @override
  State<NarrativeDemoPage> createState() => _NarrativeDemoPageState();
}

class _NarrativeDemoPageState extends State<NarrativeDemoPage> {
  late final NarrativeDemoViewModel _viewModel;
  late final NarrativeDemoActions _actions;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _viewModel = serviceLocator<NarrativeDemoViewModel>();
    _actions = serviceLocator<NarrativeDemoActions>();
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
      return _buildLoadingState(context);
    }

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return _buildContent(context);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'INITIALIZING NARRATIVE ENGINE...',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DialogueDisplay(
          currentText: _viewModel.currentText,
          state: _viewModel.state,
          statusLabel: _viewModel.statusLabel,
          choices: _viewModel.currentChoices,
          onTapToContinue: _actions.onTapToContinue,
          onChoiceSelected: _actions.onChoiceSelected,
        ),

        const SizedBox(height: 24),

        NarrativeQueuePanel(
          queue: _viewModel.queue,
          getInstructionLabel: _viewModel.getInstructionLabel,
        ),

        const SizedBox(height: 24),

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

        const SizedBox(height: 24),

        _buildInfoCard(context),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ABOUT THIS DEMO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This demo showcases the fifty_narrative_engine package capabilities:\n\n'
            '- WRITE: Display text on screen (narration)\n'
            '- READ: Trigger text-to-speech (voice output)\n'
            '- ASK: Present choices and wait for selection\n'
            '- WAIT: Pause until user taps to continue\n\n'
            'Add sentences to the queue, then tap PROCESS to execute them in order. '
            'The engine handles instruction interpretation, flow control, and user interaction.',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
