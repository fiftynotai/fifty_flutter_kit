/// STT Controls Widget
///
/// Speech-to-text controls and display.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// STT controls widget.
///
/// Provides microphone button and recognized text display.
class SttControls extends StatelessWidget {
  const SttControls({
    required this.isListening,
    required this.recognizedText,
    required this.onMicTapped,
    super.key,
  });

  final bool isListening;
  final String recognizedText;
  final VoidCallback onMicTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mic button and status
          Row(
            children: [
              GestureDetector(
                onTap: onMicTapped,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isListening
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isListening
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    color: isListening
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isListening ? 'LISTENING...' : 'TAP TO SPEAK',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        color: isListening
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      'Commands: "next", "previous", "skip", "stop"',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 10,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Recognized text
          if (recognizedText.isNotEmpty) ...[
            const SizedBox(height: FiftySpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECOGNIZED:',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: 10,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    '"$recognizedText"',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyLarge,
                      color: colorScheme.onSurface,
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
}
