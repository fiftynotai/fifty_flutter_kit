/// STT (Speech-to-Text) panel widget.
///
/// Provides controls for speech-to-text functionality including:
/// - Listen toggle button
/// - Recognized text display
/// - Status indicator
/// - Clear button
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import 'status_indicator.dart';

/// Panel for STT controls.
class SttPanel extends StatelessWidget {
  const SttPanel({
    super.key,
    required this.isListening,
    required this.isProcessing,
    required this.recognizedText,
    required this.statusLabel,
    required this.continuousListening,
    required this.hasError,
    this.errorMessage,
    required this.onListenToggle,
    required this.onClear,
    required this.onContinuousToggle,
  });

  /// Whether currently listening.
  final bool isListening;

  /// Whether processing recognition.
  final bool isProcessing;

  /// Recognized text to display.
  final String recognizedText;

  /// Status label text.
  final String statusLabel;

  /// Whether continuous listening is enabled.
  final bool continuousListening;

  /// Whether there is an error.
  final bool hasError;

  /// Error message to display.
  final String? errorMessage;

  /// Callback when listen is toggled.
  final VoidCallback onListenToggle;

  /// Callback when clear is tapped.
  final VoidCallback onClear;

  /// Callback when continuous mode is toggled.
  final VoidCallback onContinuousToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FiftyCard(
      child: Padding(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mic_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    const Text(
                      'SPEECH-TO-TEXT',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyHeadline,
                        fontSize: FiftyTypography.section,
                        fontWeight: FiftyTypography.ultrabold,
                        color: FiftyColors.terminalWhite,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                StatusIndicator(
                  label: statusLabel,
                  isActive: isListening || isProcessing,
                  isError: hasError,
                ),
              ],
            ),

            const SizedBox(height: FiftySpacing.lg),

            // Result display
            _buildResultDisplay(colorScheme),

            const SizedBox(height: FiftySpacing.lg),

            // Continuous mode toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Continuous Mode',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.body,
                    color: FiftyColors.hyperChrome,
                  ),
                ),
                FiftySwitch(
                  value: continuousListening,
                  onChanged: isListening ? null : (_) => onContinuousToggle(),
                ),
              ],
            ),

            const SizedBox(height: FiftySpacing.lg),

            // Action buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FiftyButton(
                    label: isListening ? 'STOP LISTENING' : 'START LISTENING',
                    icon: isListening
                        ? Icons.mic_off_rounded
                        : Icons.mic_rounded,
                    variant: isListening
                        ? FiftyButtonVariant.danger
                        : FiftyButtonVariant.primary,
                    onPressed: isProcessing ? null : onListenToggle,
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
                Expanded(
                  child: FiftyButton(
                    label: 'CLEAR',
                    icon: Icons.clear_rounded,
                    variant: FiftyButtonVariant.secondary,
                    onPressed: recognizedText.isEmpty ? null : onClear,
                  ),
                ),
              ],
            ),

            // Error message
            if (hasError && errorMessage != null) ...[
              const SizedBox(height: FiftySpacing.md),
              Container(
                padding: const EdgeInsets.all(FiftySpacing.md),
                decoration: BoxDecoration(
                  color: FiftyColors.warning.withValues(alpha: 0.1),
                  borderRadius: FiftyRadii.standardRadius,
                  border: Border.all(
                    color: FiftyColors.warning.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: FiftyColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          color: FiftyColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultDisplay(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: FiftyColors.voidBlack,
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(
          color: isListening
              ? colorScheme.primary.withValues(alpha: 0.5)
              : FiftyColors.border,
          width: isListening ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            isListening ? 'Listening...' : 'Recognized Text:',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: isListening
                  ? colorScheme.primary
                  : FiftyColors.hyperChrome,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          // Text content
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              color: recognizedText.isEmpty
                  ? FiftyColors.hyperChrome.withValues(alpha: 0.5)
                  : FiftyColors.terminalWhite,
              fontStyle: recognizedText.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
            child: Text(
              recognizedText.isEmpty
                  ? 'Tap "Start Listening" to begin speech recognition...'
                  : recognizedText,
            ),
          ),
          // Listening indicator
          if (isListening) ...[
            const SizedBox(height: FiftySpacing.md),
            _buildListeningWave(colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildListeningWave(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: _WaveBar(
            delay: index * 100,
            color: colorScheme.primary,
          ),
        );
      }),
    );
  }
}

/// Animated wave bar for listening indicator.
class _WaveBar extends StatefulWidget {
  const _WaveBar({
    required this.delay,
    required this.color,
  });

  final int delay;
  final Color color;

  @override
  State<_WaveBar> createState() => _WaveBarState();
}

class _WaveBarState extends State<_WaveBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 8, end: 24).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 4,
          height: _animation.value,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
