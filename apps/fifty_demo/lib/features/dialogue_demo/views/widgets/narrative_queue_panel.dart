/// Sentence Queue Panel Widget
///
/// Displays the sentence queue with current position.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/narrative_integration_service.dart';

/// Sentence queue panel widget.
///
/// Shows all sentences in the queue with current highlighted.
class NarrativeQueuePanel extends StatelessWidget {
  const NarrativeQueuePanel({
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
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

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
                '${sentences.length} ITEMS',
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
                                      : colorScheme.onSurface.withValues(alpha: 0.7),
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
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: isCurrent
                              ? colorScheme.onSurface
                              : isPast
                                  ? colorScheme.onSurface.withValues(alpha: 0.7)
                                  : colorScheme.onSurface.withValues(alpha: 0.5),
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
