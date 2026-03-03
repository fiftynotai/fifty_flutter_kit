import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// State data for custom TTS controls builders.
///
/// Bundles all TTS state values and callbacks into an immutable
/// object for use with [SpeechTtsControls.contentBuilder].
@immutable
class SpeechTtsState {
  /// Creates TTS state with the given values.
  const SpeechTtsState({
    required this.enabled,
    required this.onEnabledChanged,
    required this.rate,
    required this.pitch,
    required this.volume,
    required this.isSpeaking,
    required this.compact,
    this.onRateChanged,
    this.onPitchChanged,
    this.onVolumeChanged,
  });

  /// Whether TTS is enabled.
  final bool enabled;

  /// Callback when TTS enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Current speech rate (0.5 - 2.0).
  final double rate;

  /// Callback when rate changes. Null if slider is hidden.
  final ValueChanged<double>? onRateChanged;

  /// Current pitch (0.5 - 2.0).
  final double pitch;

  /// Callback when pitch changes. Null if slider is hidden.
  final ValueChanged<double>? onPitchChanged;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Callback when volume changes. Null if slider is hidden.
  final ValueChanged<double>? onVolumeChanged;

  /// Whether TTS is currently speaking.
  final bool isSpeaking;

  /// Whether to use compact layout.
  final bool compact;

  /// Compares value fields only, not callbacks.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechTtsState &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          rate == other.rate &&
          pitch == other.pitch &&
          volume == other.volume &&
          isSpeaking == other.isSpeaking &&
          compact == other.compact;

  @override
  int get hashCode => Object.hash(enabled, rate, pitch, volume, isSpeaking, compact);

  @override
  String toString() =>
      'SpeechTtsState(enabled: $enabled, rate: $rate, pitch: $pitch, '
      'volume: $volume, speaking: $isSpeaking)';
}
