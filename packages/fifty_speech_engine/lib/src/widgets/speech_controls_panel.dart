/// Combined Speech Controls Panel
///
/// Provides a unified panel with both TTS and STT controls in a single widget.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import 'speech_stt_controls.dart';
import 'speech_tts_controls.dart';

/// **SpeechControlsPanel**
///
/// A combined panel that includes both text-to-speech (TTS) and
/// speech-to-text (STT) controls in a single, organized widget.
///
/// **Why**
/// - Provides a unified interface for all speech-related controls
/// - Reduces boilerplate when using both TTS and STT features
/// - Allows selective display of TTS-only, STT-only, or both
/// - Follows FDL design patterns for consistency
///
/// **Key Features**
/// - Combined TTS and STT controls in a single card
/// - Selective display via [showTts] and [showStt] flags
/// - Consistent styling and spacing
/// - Compact mode for space-constrained layouts
///
/// **Example:**
/// ```dart
/// SpeechControlsPanel(
///   // TTS controls
///   ttsEnabled: _ttsEnabled,
///   onTtsEnabledChanged: (v) => setState(() => _ttsEnabled = v),
///   rate: _rate,
///   onRateChanged: (v) => setState(() => _rate = v),
///   isSpeaking: _isSpeaking,
///
///   // STT controls
///   sttEnabled: _sttEnabled,
///   onSttEnabledChanged: (v) => setState(() => _sttEnabled = v),
///   isListening: _isListening,
///   onListenPressed: () => _toggleListening(),
///   recognizedText: _recognizedText,
/// )
/// ```
class SpeechControlsPanel extends StatelessWidget {
  /// Creates a combined speech controls panel.
  const SpeechControlsPanel({
    // TTS props
    required this.ttsEnabled,
    required this.onTtsEnabledChanged,
    this.rate = 1.0,
    this.onRateChanged,
    this.pitch = 1.0,
    this.onPitchChanged,
    this.volume = 1.0,
    this.onVolumeChanged,
    this.isSpeaking = false,

    // STT props
    required this.sttEnabled,
    required this.onSttEnabledChanged,
    required this.isListening,
    required this.onListenPressed,
    this.recognizedText = '',
    this.isSttAvailable = true,
    this.sttErrorMessage,
    this.onClearRecognizedText,
    this.sttHintText,

    // Panel options
    this.showTts = true,
    this.showStt = true,
    this.compact = false,
    this.title,
    super.key,
  });

  // -- TTS Properties --

  /// Whether TTS is enabled.
  final bool ttsEnabled;

  /// Callback when TTS enabled state changes.
  final ValueChanged<bool> onTtsEnabledChanged;

  /// Current speech rate (0.5 - 2.0).
  final double rate;

  /// Callback when rate changes. If null, slider is hidden.
  final ValueChanged<double>? onRateChanged;

  /// Current pitch (0.5 - 2.0).
  final double pitch;

  /// Callback when pitch changes. If null, slider is hidden.
  final ValueChanged<double>? onPitchChanged;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Callback when volume changes. If null, slider is hidden.
  final ValueChanged<double>? onVolumeChanged;

  /// Whether TTS is currently speaking.
  final bool isSpeaking;

  // -- STT Properties --

  /// Whether STT is enabled.
  final bool sttEnabled;

  /// Callback when STT enabled state changes.
  final ValueChanged<bool> onSttEnabledChanged;

  /// Whether STT is currently listening.
  final bool isListening;

  /// Callback when microphone button is pressed.
  final VoidCallback onListenPressed;

  /// The text recognized from speech.
  final String recognizedText;

  /// Whether STT is available on this device.
  final bool isSttAvailable;

  /// STT error message to display.
  final String? sttErrorMessage;

  /// Callback when clear recognized text button is pressed.
  final VoidCallback? onClearRecognizedText;

  /// Hint text for STT microphone button.
  final String? sttHintText;

  // -- Panel Options --

  /// Whether to show TTS controls.
  final bool showTts;

  /// Whether to show STT controls.
  final bool showStt;

  /// Whether to use compact layout.
  final bool compact;

  /// Optional title for the panel.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
      scanlineOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional title
          if (title != null) ...[
            Text(
              title!.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.bold,
                color: colorScheme.onSurface,
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              ),
            ),
            SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
            Container(height: 1, color: colorScheme.outline),
            SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
          ],

          // TTS controls
          if (showTts)
            SpeechTtsControls(
              enabled: ttsEnabled,
              onEnabledChanged: onTtsEnabledChanged,
              rate: rate,
              onRateChanged: onRateChanged,
              pitch: pitch,
              onPitchChanged: onPitchChanged,
              volume: volume,
              onVolumeChanged: onVolumeChanged,
              isSpeaking: isSpeaking,
              compact: compact,
              showCard: false,
            ),

          // Divider between TTS and STT
          if (showTts && showStt) ...[
            SizedBox(height: compact ? FiftySpacing.md : FiftySpacing.lg),
            Container(
              height: 1,
              color: colorScheme.outline,
            ),
            SizedBox(height: compact ? FiftySpacing.md : FiftySpacing.lg),
          ],

          // STT controls
          if (showStt)
            SpeechSttControls(
              enabled: sttEnabled,
              onEnabledChanged: onSttEnabledChanged,
              isListening: isListening,
              onListenPressed: onListenPressed,
              recognizedText: recognizedText,
              isAvailable: isSttAvailable,
              errorMessage: sttErrorMessage,
              onClear: onClearRecognizedText,
              compact: compact,
              showCard: false,
              hintText: sttHintText,
            ),
        ],
      ),
    );
  }
}
