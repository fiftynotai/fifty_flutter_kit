/// Sentences Demo Page
///
/// Demonstrates all SentenceEngine features including:
/// - write, read, wait, ask, navigate modes
/// - Combined read + write
/// - Order-based queue sorting
/// - Processing status tracking
/// - Pause/resume controls
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/sentences_demo_actions.dart';
import '../controllers/sentences_demo_view_model.dart';
import '../service/demo_sentences.dart';

/// Sentences demo page widget.
///
/// Shows dialogue selection, sentence display, queue panel, and playback controls.
class SentencesDemoPage extends GetView<SentencesDemoViewModel> {
  /// Creates a sentences demo page.
  const SentencesDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SentencesDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<SentencesDemoActions>();

        return DemoScaffold(
          title: 'Sentences Engine',
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicator
                  _buildStatusBar(context, viewModel),
                  const SizedBox(height: FiftySpacing.lg),

                  // Mode Selection
                  const FiftySectionHeader(
                    title: 'Demo Mode',
                    subtitle: 'Select instruction type to demonstrate',
                  ),
                  _buildModeSelector(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Phase indicator (for navigate mode)
                  if (viewModel.currentPhase.isNotEmpty) ...[
                    _buildPhaseIndicator(context, viewModel),
                    const SizedBox(height: FiftySpacing.lg),
                  ],

                  // Sentence Display
                  FiftySectionHeader(
                    title: 'Dialogue Display',
                    subtitle: _getModeSubtitle(viewModel.selectedMode),
                  ),
                  _buildDialogueDisplay(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.lg),

                  // Choice buttons (for ask mode)
                  if (viewModel.isShowingChoices) ...[
                    _buildChoiceButtons(context, viewModel, actions),
                    const SizedBox(height: FiftySpacing.lg),
                  ],

                  // Continue button (for wait mode)
                  if (viewModel.isWaitingForInput &&
                      !viewModel.isShowingChoices) ...[
                    _buildContinueButton(context, viewModel, actions),
                    const SizedBox(height: FiftySpacing.lg),
                  ],

                  // Progress Bar
                  _buildProgressBar(context, viewModel),
                  const SizedBox(height: FiftySpacing.lg),

                  // Playback Controls
                  _buildPlaybackControls(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.lg),

                  // TTS Toggle (for read/combined modes)
                  if (_showTtsToggle(viewModel.selectedMode)) ...[
                    _buildTtsToggle(context, viewModel, actions),
                    const SizedBox(height: FiftySpacing.lg),
                  ],

                  // Queue Panel
                  FiftySectionHeader(
                    title: 'Sentence Queue',
                    subtitle: '${viewModel.sentences.length} sentences',
                  ),
                  _buildQueuePanel(context, viewModel, actions),
                ],
              ),
            ),
          );
        },
      );
  }

  /// Returns subtitle based on selected mode.
  String _getModeSubtitle(DemoMode mode) {
    return switch (mode) {
      DemoMode.write => 'Text appears with typewriter effect',
      DemoMode.read => 'Text is spoken using TTS',
      DemoMode.wait => 'Tap to continue after each sentence',
      DemoMode.ask => 'Select from available choices',
      DemoMode.navigate => 'Navigate between phases',
      DemoMode.combined => 'Display and speak simultaneously',
      DemoMode.orderQueue => 'Sentences sorted by order field',
    };
  }

  /// Whether to show TTS toggle for this mode.
  bool _showTtsToggle(DemoMode mode) {
    return mode == DemoMode.read || mode == DemoMode.combined;
  }

  Widget _buildStatusBar(BuildContext context, SentencesDemoViewModel viewModel) {
    final FiftyStatusState state;
    final String label = viewModel.statusLabel;

    state = switch (viewModel.processingStatus) {
      DemoProcessingStatus.idle => FiftyStatusState.idle,
      DemoProcessingStatus.processing => FiftyStatusState.loading,
      DemoProcessingStatus.paused => FiftyStatusState.ready,
      DemoProcessingStatus.cancelled => FiftyStatusState.idle,
      DemoProcessingStatus.completed => FiftyStatusState.ready,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FiftyStatusIndicator(label: label, state: state),
        Row(
          children: [
            if (viewModel.ttsEnabled && _showTtsToggle(viewModel.selectedMode))
              _buildTtsBadge(context),
            if (viewModel.isAutoAdvanceEnabled)
              _buildAutoAdvanceBadge(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTtsBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(right: FiftySpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FiftyRadii.sm),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.volume_up,
            size: 14,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: FiftySpacing.xs),
          Text(
            'TTS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoAdvanceBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FiftyRadii.sm),
        border: Border.all(color: successColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 14,
            color: successColor,
          ),
          const SizedBox(width: FiftySpacing.xs),
          Text(
            'AUTO',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: successColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: DemoMode.values.map((mode) {
        final isSelected = viewModel.selectedMode == mode;

        return GestureDetector(
          onTap: () => actions.onModeSelected(context, mode),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(FiftyRadii.md),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getModeIcon(mode),
                  size: 18,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(height: FiftySpacing.xs),
                Text(
                  mode.displayName.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Returns icon for each demo mode.
  IconData _getModeIcon(DemoMode mode) {
    return switch (mode) {
      DemoMode.write => Icons.edit,
      DemoMode.read => Icons.record_voice_over,
      DemoMode.wait => Icons.pause_circle_outline,
      DemoMode.ask => Icons.help_outline,
      DemoMode.navigate => Icons.navigation,
      DemoMode.combined => Icons.surround_sound,
      DemoMode.orderQueue => Icons.sort,
    };
  }

  Widget _buildPhaseIndicator(
    BuildContext context,
    SentencesDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final accentColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: accentColor,
            size: 20,
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            'CURRENT PHASE:',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            viewModel.currentPhase.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              fontWeight: FontWeight.bold,
              color: accentColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButtons(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT A CHOICE:',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: FiftySpacing.sm),
        ...viewModel.currentChoices.map((choice) => Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: GestureDetector(
            onTap: () => actions.onChoiceSelected(context, choice),
            child: FiftyCard(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.md,
                vertical: FiftySpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Expanded(
                    child: Text(
                      choice,
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
        )),
        if (viewModel.lastSelectedChoice.isNotEmpty) ...[
          const SizedBox(height: FiftySpacing.sm),
          Text(
            'Last choice: "${viewModel.lastSelectedChoice}"',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContinueButton(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GestureDetector(
        onTap: actions.onContinueTapped,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.xl,
            vertical: FiftySpacing.md,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(FiftyRadii.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                color: colorScheme.onPrimary,
                size: 20,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Text(
                'TAP TO CONTINUE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTtsToggle(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.volume_up,
                color: viewModel.ttsEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Text(
                'Text-to-Speech',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Switch(
            value: viewModel.ttsEnabled,
            onChanged: (_) => actions.onTtsToggled(),
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
            activeThumbColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDialogueDisplay(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final sentence = viewModel.currentSentence;

    return GestureDetector(
      onTap: actions.onDialogueTapped,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker and instruction badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Speaker label
                if (sentence?.speaker != null)
                  Text(
                    sentence!.speaker!,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // Instruction badge
                if (sentence != null)
                  _buildInstructionBadge(context, sentence.instruction),
              ],
            ),
            if (sentence?.speaker != null || sentence != null)
              const SizedBox(height: FiftySpacing.sm),
            // Dialogue text
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      viewModel.displayedText.isEmpty && viewModel.isEmpty
                          ? 'No dialogue loaded...'
                          : viewModel.displayedText.isEmpty
                              ? 'Tap PLAY to start dialogue...'
                              : viewModel.displayedText,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        color: viewModel.displayedText.isEmpty
                            ? colorScheme.onSurface.withValues(alpha: 0.5)
                            : colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // Typing cursor
                  if (viewModel.isTyping) const _TypingCursor(),
                ],
              ),
            ),
            const SizedBox(height: FiftySpacing.sm),
            // Hint
            Text(
              _getHintText(viewModel),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: 10,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionBadge(BuildContext context, String instruction) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color badgeColor;
    final IconData icon;

    if (instruction.contains('read') && instruction.contains('write')) {
      badgeColor = colorScheme.tertiary;
      icon = Icons.surround_sound;
    } else if (instruction.contains('read')) {
      badgeColor = colorScheme.secondary;
      icon = Icons.record_voice_over;
    } else if (instruction == 'ask') {
      badgeColor = colorScheme.error;
      icon = Icons.help_outline;
    } else if (instruction == 'navigate') {
      badgeColor = colorScheme.primary;
      icon = Icons.navigation;
    } else {
      badgeColor = colorScheme.outline;
      icon = Icons.edit;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FiftyRadii.sm),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: badgeColor),
          const SizedBox(width: FiftySpacing.xs),
          Text(
            instruction.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: badgeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText(SentencesDemoViewModel viewModel) {
    if (viewModel.isTyping) {
      return 'TAP TO SKIP';
    }
    if (viewModel.isShowingChoices) {
      return 'SELECT A CHOICE ABOVE';
    }
    if (viewModel.isWaitingForInput) {
      return 'TAP TO CONTINUE';
    }
    if (viewModel.isAtEnd) {
      return 'END OF DIALOGUE';
    }
    if (viewModel.hasNext) {
      return 'TAP TO CONTINUE';
    }
    return 'TAP PLAY TO START';
  }

  Color _getInstructionColor(String instruction, ColorScheme colorScheme) {
    if (instruction.contains('read') && instruction.contains('write')) {
      return colorScheme.tertiary;
    } else if (instruction.contains('read')) {
      return colorScheme.secondary;
    } else if (instruction == 'ask') {
      return colorScheme.error;
    } else if (instruction == 'navigate') {
      return colorScheme.primary;
    } else if (instruction == 'wait') {
      return colorScheme.tertiary;
    }
    return colorScheme.outline;
  }

  Widget _buildProgressBar(
    BuildContext context,
    SentencesDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final progressColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROGRESS',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              viewModel.isEmpty ? '0/0' : viewModel.progressText,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(FiftyRadii.sm),
          child: LinearProgressIndicator(
            value: viewModel.progress,
            backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous
          _ControlButton(
            icon: Icons.skip_previous,
            label: 'PREV',
            onTap: viewModel.hasPrevious ? actions.onPreviousTapped : null,
            colorScheme: colorScheme,
          ),
          // Play/Pause
          _ControlButton(
            icon: viewModel.isPlaying || viewModel.isAutoAdvanceEnabled
                ? Icons.pause
                : Icons.play_arrow,
            label: viewModel.isPlaying || viewModel.isAutoAdvanceEnabled
                ? 'PAUSE'
                : 'PLAY',
            onTap: viewModel.isEmpty ? null : actions.onPlayPauseTapped,
            isPrimary: true,
            colorScheme: colorScheme,
          ),
          // Next
          _ControlButton(
            icon: Icons.skip_next,
            label: 'NEXT',
            onTap: viewModel.hasNext ? actions.onNextTapped : null,
            colorScheme: colorScheme,
          ),
          // Reset
          _ControlButton(
            icon: Icons.replay,
            label: 'RESET',
            onTap: viewModel.isEmpty
                ? null
                : () => actions.onResetTapped(context),
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildQueuePanel(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    if (viewModel.isEmpty) {
      return FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Center(
          child: Text(
            'No sentences in queue',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUEUE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${viewModel.sentences.length} ITEMS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: 10,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          const SizedBox(height: FiftySpacing.md),
          // Sentence list
          ...viewModel.sentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;
            final isCurrent = index == viewModel.currentIndex;
            final isPast = index < viewModel.currentIndex;

            return GestureDetector(
              onTap: () => actions.onSentenceTapped(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: FiftySpacing.sm,
                  horizontal: FiftySpacing.sm,
                ),
                margin: const EdgeInsets.only(bottom: FiftySpacing.xs),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: isCurrent
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    // Index indicator
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? colorScheme.primary
                            : isPast
                                ? successColor.withValues(alpha: 0.5)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? colorScheme.primary
                              : isPast
                                  ? successColor
                                  : colorScheme.outline,
                        ),
                      ),
                      child: Center(
                        child: isPast
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: colorScheme.onSurface,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamily,
                                  fontSize: 10,
                                  color: isCurrent
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    // Instruction type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FiftySpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getInstructionColor(sentence.instruction, colorScheme)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        sentence.instruction.toUpperCase(),
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: _getInstructionColor(sentence.instruction, colorScheme),
                        ),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    // Speaker badge
                    if (sentence.speaker != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FiftySpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          sentence.speaker!,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: FiftySpacing.xs),
                    ],
                    // Sentence preview
                    Expanded(
                      child: Text(
                        sentence.text,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: isCurrent
                              ? colorScheme.onSurface
                              : isPast
                                  ? colorScheme.onSurface.withValues(alpha: 0.5)
                                  : colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// A control button for playback.
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isPrimary ? 56 : 44,
              height: isPrimary ? 56 : 44,
              decoration: BoxDecoration(
                color: isPrimary
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPrimary
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
              ),
              child: Icon(
                icon,
                color: isPrimary
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                size: isPrimary ? 28 : 22,
              ),
            ),
            const SizedBox(height: FiftySpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: 10,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Blinking typing cursor widget.
class _TypingCursor extends StatefulWidget {
  const _TypingCursor();

  @override
  State<_TypingCursor> createState() => _TypingCursorState();
}

class _TypingCursorState extends State<_TypingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 20,
        color: colorScheme.primary,
      ),
    );
  }
}
