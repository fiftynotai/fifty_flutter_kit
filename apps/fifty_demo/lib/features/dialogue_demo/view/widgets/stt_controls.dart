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
                        ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isListening
                          ? FiftyColors.crimsonPulse
                          : FiftyColors.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    color: isListening
                        ? FiftyColors.crimsonPulse
                        : FiftyColors.hyperChrome,
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
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.body,
                        color: isListening
                            ? FiftyColors.crimsonPulse
                            : FiftyColors.hyperChrome,
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    const Text(
                      'Commands: "next", "previous", "skip", "stop"',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: 10,
                        color: FiftyColors.hyperChrome,
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
                color: FiftyColors.voidBlack,
                borderRadius: FiftyRadii.standardRadius,
                border: Border.all(color: FiftyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECOGNIZED:',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: 10,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    '"$recognizedText"',
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: FiftyColors.terminalWhite,
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
