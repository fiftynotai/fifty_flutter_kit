/// Sentence Queue Panel Widget
///
/// Displays the sentence queue with current position.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/sentences_integration_service.dart';

/// Sentence queue panel widget.
///
/// Shows all sentences in the queue with current highlighted.
class SentenceQueuePanel extends StatelessWidget {
  const SentenceQueuePanel({
    required this.sentences,
    required this.currentIndex,
    super.key,
    this.onSentenceTap,
  });

  final List<Sentence> sentences;
  final int currentIndex;
  final void Function(int)? onSentenceTap;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUEUE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyHeadline,
                  fontSize: FiftyTypography.mono,
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.crimsonPulse,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${sentences.length} ITEMS',
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: 10,
                  color: FiftyColors.hyperChrome,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: FiftyColors.border),
          const SizedBox(height: FiftySpacing.md),
          // Sentence list
          ...sentences.asMap().entries.map((entry) {
            final index = entry.key;
            final sentence = entry.value;
            final isCurrent = index == currentIndex;
            final isPast = index < currentIndex;

            return GestureDetector(
              onTap: onSentenceTap != null ? () => onSentenceTap!(index) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: FiftySpacing.sm,
                  horizontal: FiftySpacing.sm,
                ),
                margin: const EdgeInsets.only(bottom: FiftySpacing.xs),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? FiftyColors.crimsonPulse.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: isCurrent
                      ? Border.all(
                          color: FiftyColors.crimsonPulse.withValues(alpha: 0.3),
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
                            ? FiftyColors.crimsonPulse
                            : isPast
                                ? FiftyColors.igrisGreen.withValues(alpha: 0.5)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? FiftyColors.crimsonPulse
                              : isPast
                                  ? FiftyColors.igrisGreen
                                  : FiftyColors.border,
                        ),
                      ),
                      child: Center(
                        child: isPast
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: FiftyColors.terminalWhite,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamilyMono,
                                  fontSize: 10,
                                  color: isCurrent
                                      ? FiftyColors.terminalWhite
                                      : FiftyColors.hyperChrome,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    // Sentence preview
                    Expanded(
                      child: Text(
                        sentence.text,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          color: isCurrent
                              ? FiftyColors.terminalWhite
                              : isPast
                                  ? FiftyColors.hyperChrome
                                  : FiftyColors.hyperChrome.withValues(alpha: 0.7),
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
