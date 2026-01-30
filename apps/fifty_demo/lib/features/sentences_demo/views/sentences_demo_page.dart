/// Sentences Demo Page
///
/// Demonstrates sentence queue and typewriter effect.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
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

                  // Dialogue Selection
                  const SectionHeader(
                    title: 'Select Dialogue',
                    subtitle: 'Choose a preset dialogue sequence',
                  ),
                  _buildDialogueSelector(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Sentence Display
                  const SectionHeader(
                    title: 'Dialogue Display',
                    subtitle: 'Tap to advance or skip typing',
                  ),
                  _buildDialogueDisplay(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.lg),

                  // Progress Bar
                  _buildProgressBar(context, viewModel),
                  const SizedBox(height: FiftySpacing.lg),

                  // Playback Controls
                  _buildPlaybackControls(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Queue Panel
                  SectionHeader(
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

  Widget _buildStatusBar(BuildContext context, SentencesDemoViewModel viewModel) {
    final StatusState state;
    final String label;

    switch (viewModel.playbackState) {
      case PlaybackState.idle:
        state = StatusState.idle;
        label = 'SENTENCES';
      case PlaybackState.typing:
        state = StatusState.loading;
        label = 'TYPING';
      case PlaybackState.waiting:
        state = StatusState.ready;
        label = 'WAITING';
      case PlaybackState.playing:
        state = StatusState.ready;
        label = 'PLAYING';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusIndicator(label: label, state: state),
        if (viewModel.isAutoAdvanceEnabled)
          _buildAutoAdvanceBadge(context),
      ],
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

  Widget _buildDialogueSelector(
    BuildContext context,
    SentencesDemoViewModel viewModel,
    SentencesDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: DemoSentences.dialogueNames.map((name) {
        final isSelected = viewModel.selectedDialogue == name;

        return GestureDetector(
          onTap: () => actions.onDialogueSelected(context, name),
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
            child: Text(
              name.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
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
            // Speaker label
            if (sentence?.speaker != null) ...[
              Text(
                sentence!.speaker!,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
            ],
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
              viewModel.isTyping
                  ? 'TAP TO SKIP'
                  : viewModel.hasNext
                      ? 'TAP TO CONTINUE'
                      : 'END OF DIALOGUE',
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
