/// TTS (Text-to-Speech) panel widget.
///
/// Provides controls for text-to-speech functionality including:
/// - Text input field
/// - Speak/Stop buttons
/// - Language selector
/// - Status indicator
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../service/speech_service.dart';
import 'status_indicator.dart';

/// Panel for TTS controls.
class TtsPanel extends StatefulWidget {
  const TtsPanel({
    super.key,
    required this.isSpeaking,
    required this.currentLanguage,
    required this.availableLanguages,
    required this.statusLabel,
    required this.onSpeak,
    required this.onStop,
    required this.onLanguageChanged,
  });

  /// Whether currently speaking.
  final bool isSpeaking;

  /// Current language setting.
  final SpeechLanguage currentLanguage;

  /// Available languages for selection.
  final List<SpeechLanguage> availableLanguages;

  /// Status label text.
  final String statusLabel;

  /// Callback when speak is tapped.
  final void Function(String text) onSpeak;

  /// Callback when stop is tapped.
  final VoidCallback onStop;

  /// Callback when language is changed.
  final void Function(SpeechLanguage language) onLanguageChanged;

  @override
  State<TtsPanel> createState() => _TtsPanelState();
}

class _TtsPanelState extends State<TtsPanel> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set default demo text
    _textController.text = 'Hello! This is a demonstration of the '
        'Fifty Speech Engine text-to-speech capabilities.';
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
              children: [
                Icon(
                  Icons.volume_up_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: FiftySpacing.sm),
                const Text(
                  'TEXT-TO-SPEECH',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    fontWeight: FiftyTypography.extraBold,
                    color: FiftyColors.cream,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: FiftySpacing.sm),
                StatusIndicator(
                  label: widget.statusLabel,
                  isActive: widget.isSpeaking,
                ),
              ],
            ),

            const SizedBox(height: FiftySpacing.lg),

            // Text input
            FiftyTextField(
              controller: _textController,
              focusNode: _focusNode,
              hint: 'Enter text to speak...',
              maxLines: 4,
              enabled: !widget.isSpeaking,
            ),

            const SizedBox(height: FiftySpacing.lg),

            // Language selector
            Row(
              children: [
                const Text(
                  'Language:',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    color: FiftyColors.slateGrey,
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
                Expanded(
                  child: _buildLanguageDropdown(colorScheme),
                ),
              ],
            ),

            const SizedBox(height: FiftySpacing.lg),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FiftyButton(
                    label: 'SPEAK',
                    variant: FiftyButtonVariant.primary,
                    onPressed: widget.isSpeaking
                        ? null
                        : () => widget.onSpeak(_textController.text),
                  ),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: FiftyButton(
                    label: 'STOP',
                    variant: FiftyButtonVariant.secondary,
                    onPressed: widget.isSpeaking ? widget.onStop : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: FiftyColors.darkBurgundy,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: DropdownButton<SpeechLanguage>(
        value: widget.currentLanguage,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: FiftyColors.surfaceDark,
        style: const TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.bodyLarge,
          color: FiftyColors.cream,
        ),
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: colorScheme.primary,
        ),
        items: widget.availableLanguages.map((language) {
          return DropdownMenuItem<SpeechLanguage>(
            value: language,
            child: Text(language.displayName),
          );
        }).toList(),
        onChanged: widget.isSpeaking
            ? null
            : (language) {
                if (language != null) {
                  widget.onLanguageChanged(language);
                }
              },
      ),
    );
  }
}
