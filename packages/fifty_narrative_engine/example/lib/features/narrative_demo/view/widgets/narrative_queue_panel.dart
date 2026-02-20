/// Sentence queue panel widget.
///
/// Displays the list of sentences queued for processing
/// with instruction type indicators and theme-aware styling.
library;

import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../service/demo_narrative.dart';

/// Widget displaying the sentence queue.
class NarrativeQueuePanel extends StatelessWidget {
  const NarrativeQueuePanel({
    super.key,
    required this.queue,
    required this.getInstructionLabel,
  });

  /// List of sentences in the queue.
  final List<DemoNarrative> queue;

  /// Function to get the instruction label.
  final String Function(String) getInstructionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(colorScheme),
          const SizedBox(height: 12),
          if (queue.isEmpty)
            _buildEmptyState(colorScheme)
          else
            _buildQueueList(colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SENTENCE QUEUE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
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

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.queue_outlined,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Queue is empty',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add sentences using the buttons below',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList(ColorScheme colorScheme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: queue.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final sentence = queue[index];
          return _buildQueueItem(index + 1, sentence, colorScheme);
        },
      ),
    );
  }

  Widget _buildQueueItem(int index, DemoNarrative sentence, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 8),

          _buildInstructionBadge(sentence.instruction, colorScheme),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              sentence.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBadge(String instruction, ColorScheme colorScheme) {
    final label = getInstructionLabel(instruction);
    final color = _getInstructionColor(instruction, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getInstructionColor(String instruction, ColorScheme colorScheme) {
    final lower = instruction.toLowerCase();
    if (lower.contains('write') && lower.contains('read')) {
      return colorScheme.primary;
    }
    if (lower.contains('write')) return colorScheme.tertiary;
    if (lower.contains('read')) return colorScheme.secondary;
    if (lower.contains('ask')) return colorScheme.error;
    if (lower.contains('wait')) return colorScheme.primary;
    if (lower.contains('navigate')) return colorScheme.primary;
    return colorScheme.onSurfaceVariant;
  }
}
