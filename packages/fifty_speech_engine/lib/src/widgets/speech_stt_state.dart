import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// State data for custom STT controls builders.
///
/// Bundles all STT state values and callbacks into an immutable
/// object for use with [SpeechSttControls.contentBuilder].
@immutable
class SpeechSttState {
  /// Creates STT state with the given values.
  const SpeechSttState({
    required this.enabled,
    required this.onEnabledChanged,
    required this.isListening,
    required this.onListenPressed,
    required this.recognizedText,
    required this.isAvailable,
    required this.compact,
    this.errorMessage,
    this.onClear,
    this.hintText,
  });

  /// Whether STT is enabled.
  final bool enabled;

  /// Callback when STT enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Whether STT is currently listening.
  final bool isListening;

  /// Callback when microphone button is pressed.
  final VoidCallback onListenPressed;

  /// The text recognized from speech.
  final String recognizedText;

  /// Whether STT is available on this device.
  final bool isAvailable;

  /// Error message to display.
  final String? errorMessage;

  /// Callback when clear button is pressed.
  final VoidCallback? onClear;

  /// Whether to use compact layout.
  final bool compact;

  /// Hint text shown below microphone button.
  final String? hintText;

  /// Compares value fields only, not callbacks.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechSttState &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          isListening == other.isListening &&
          recognizedText == other.recognizedText &&
          isAvailable == other.isAvailable &&
          errorMessage == other.errorMessage &&
          compact == other.compact &&
          hintText == other.hintText;

  @override
  int get hashCode => Object.hash(
        enabled, isListening, recognizedText, isAvailable,
        errorMessage, compact, hintText,
      );

  @override
  String toString() =>
      'SpeechSttState(enabled: $enabled, listening: $isListening, '
      'text: "$recognizedText", available: $isAvailable)';
}
