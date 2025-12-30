/// Sentence queue panel widget.
///
/// Displays the list of sentences queued for processing
/// with instruction type indicators and FDL styling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../service/demo_sentence.dart';

/// Widget displaying the sentence queue.
class SentenceQueuePanel extends StatelessWidget {
  const SentenceQueuePanel({
    super.key,
    required this.queue,
    required this.getInstructionLabel,
  });

  /// List of sentences in the queue.
  final List<DemoSentence> queue;

  /// Function to get the instruction label.
  final String Function(String) getInstructionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal.withValues(alpha: 0.5),
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: FiftyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),

          const SizedBox(height: FiftySpacing.md),

          // Queue list or empty state
          if (queue.isEmpty)
            _buildEmptyState()
          else
            _buildQueueList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'SENTENCE QUEUE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.mono,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.hyperChrome,
            letterSpacing: 2.0,
          ),
        ),
        FiftyChip(
          label: '${queue.length}',
          variant: queue.isEmpty
              ? FiftyChipVariant.defaultVariant
              : FiftyChipVariant.success,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.queue_outlined,
            color: FiftyColors.hyperChrome.withValues(alpha: 0.5),
            size: 32,
          ),
          const SizedBox(height: FiftySpacing.sm),
          Text(
            'Queue is empty',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              color: FiftyColors.hyperChrome.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            'Add sentences using the buttons below',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: FiftyColors.hyperChrome.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: queue.length,
        separatorBuilder: (_, __) => const SizedBox(height: FiftySpacing.xs),
        itemBuilder: (context, index) {
          final sentence = queue[index];
          return _buildQueueItem(index + 1, sentence);
        },
      ),
    );
  }

  Widget _buildQueueItem(int index, DemoSentence sentence) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: FiftyColors.voidBlack.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        border: Border.all(color: FiftyColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Index number
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FiftyColors.gunmetal,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FiftyTypography.medium,
                color: FiftyColors.hyperChrome,
              ),
            ),
          ),

          const SizedBox(width: FiftySpacing.sm),

          // Instruction badge
          _buildInstructionBadge(sentence.instruction),

          const SizedBox(width: FiftySpacing.sm),

          // Text (truncated)
          Expanded(
            child: Text(
              sentence.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                color: FiftyColors.terminalWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBadge(String instruction) {
    final label = getInstructionLabel(instruction);
    final color = _getInstructionColor(instruction);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 10,
          fontWeight: FiftyTypography.medium,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getInstructionColor(String instruction) {
    final lower = instruction.toLowerCase();
    if (lower.contains('write') && lower.contains('read')) {
      return FiftyColors.crimsonPulse;
    }
    if (lower.contains('write')) return FiftyColors.igrisGreen;
    if (lower.contains('read')) return FiftyColors.success;
    if (lower.contains('ask')) return FiftyColors.warning;
    if (lower.contains('wait')) return FiftyColors.crimsonPulse;
    if (lower.contains('navigate')) return FiftyColors.crimsonPulse;
    return FiftyColors.hyperChrome;
  }
}
