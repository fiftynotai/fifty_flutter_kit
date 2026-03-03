import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_speech_engine/src/widgets/speech_tts_state.dart';

void main() {
  group('SpeechTtsState', () {
    SpeechTtsState buildState({
      bool enabled = true,
      ValueChanged<bool>? onEnabledChanged,
      double rate = 1.0,
      double pitch = 1.0,
      double volume = 1.0,
      bool isSpeaking = false,
      bool compact = false,
      ValueChanged<double>? onRateChanged,
      ValueChanged<double>? onPitchChanged,
      ValueChanged<double>? onVolumeChanged,
    }) {
      return SpeechTtsState(
        enabled: enabled,
        onEnabledChanged: onEnabledChanged ?? (_) {},
        rate: rate,
        pitch: pitch,
        volume: volume,
        isSpeaking: isSpeaking,
        compact: compact,
        onRateChanged: onRateChanged,
        onPitchChanged: onPitchChanged,
        onVolumeChanged: onVolumeChanged,
      );
    }

    test('construction with all fields', () {
      void onEnabled(bool v) {}
      void onRate(double v) {}
      void onPitch(double v) {}
      void onVolume(double v) {}

      final state = SpeechTtsState(
        enabled: true,
        onEnabledChanged: onEnabled,
        rate: 1.5,
        pitch: 0.8,
        volume: 0.5,
        isSpeaking: true,
        compact: true,
        onRateChanged: onRate,
        onPitchChanged: onPitch,
        onVolumeChanged: onVolume,
      );

      expect(state.enabled, isTrue);
      expect(state.onEnabledChanged, onEnabled);
      expect(state.rate, 1.5);
      expect(state.pitch, 0.8);
      expect(state.volume, 0.5);
      expect(state.isSpeaking, isTrue);
      expect(state.compact, isTrue);
      expect(state.onRateChanged, onRate);
      expect(state.onPitchChanged, onPitch);
      expect(state.onVolumeChanged, onVolume);
    });

    test('equal instances with same values are equal', () {
      final a = buildState(enabled: true, rate: 1.5, pitch: 0.8);
      final b = buildState(enabled: true, rate: 1.5, pitch: 0.8);

      expect(a, equals(b));
    });

    test('different values are not equal', () {
      final a = buildState(enabled: true, rate: 1.5);
      final b = buildState(enabled: false, rate: 1.5);

      expect(a, isNot(equals(b)));
    });

    test('different rate values are not equal', () {
      final a = buildState(rate: 1.0);
      final b = buildState(rate: 1.5);

      expect(a, isNot(equals(b)));
    });

    test('different pitch values are not equal', () {
      final a = buildState(pitch: 1.0);
      final b = buildState(pitch: 0.5);

      expect(a, isNot(equals(b)));
    });

    test('different volume values are not equal', () {
      final a = buildState(volume: 1.0);
      final b = buildState(volume: 0.3);

      expect(a, isNot(equals(b)));
    });

    test('different isSpeaking values are not equal', () {
      final a = buildState(isSpeaking: false);
      final b = buildState(isSpeaking: true);

      expect(a, isNot(equals(b)));
    });

    test('different compact values are not equal', () {
      final a = buildState(compact: false);
      final b = buildState(compact: true);

      expect(a, isNot(equals(b)));
    });

    test('different callbacks but same values are equal', () {
      final a = buildState(
        enabled: true,
        rate: 1.5,
        onEnabledChanged: (_) {},
        onRateChanged: (_) {},
      );
      final b = buildState(
        enabled: true,
        rate: 1.5,
        onEnabledChanged: (_) {},
        onRateChanged: (_) {},
      );

      expect(a, equals(b));
    });

    test('hashCode consistent with equality', () {
      final a = buildState(enabled: true, rate: 1.5, pitch: 0.8);
      final b = buildState(enabled: true, rate: 1.5, pitch: 0.8);

      expect(a.hashCode, equals(b.hashCode));
    });

    test('hashCode differs for different values', () {
      final a = buildState(rate: 1.0);
      final b = buildState(rate: 2.0);

      // Not strictly required but expected in practice
      expect(a.hashCode, isNot(equals(b.hashCode)));
    });

    test('toString contains key values', () {
      final state = buildState(
        enabled: true,
        rate: 1.5,
        pitch: 0.8,
        volume: 0.5,
        isSpeaking: true,
      );

      final str = state.toString();
      expect(str, contains('enabled: true'));
      expect(str, contains('rate: 1.5'));
      expect(str, contains('pitch: 0.8'));
      expect(str, contains('volume: 0.5'));
      expect(str, contains('speaking: true'));
    });

    test('toString contains SpeechTtsState prefix', () {
      final state = buildState();
      expect(state.toString(), startsWith('SpeechTtsState('));
    });
  });
}
