import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_speech_engine/src/widgets/speech_stt_state.dart';

void main() {
  group('SpeechSttState', () {
    SpeechSttState buildState({
      bool enabled = true,
      ValueChanged<bool>? onEnabledChanged,
      bool isListening = false,
      VoidCallback? onListenPressed,
      String recognizedText = '',
      bool isAvailable = true,
      bool compact = false,
      String? errorMessage,
      VoidCallback? onClear,
      String? hintText,
    }) {
      return SpeechSttState(
        enabled: enabled,
        onEnabledChanged: onEnabledChanged ?? (_) {},
        isListening: isListening,
        onListenPressed: onListenPressed ?? () {},
        recognizedText: recognizedText,
        isAvailable: isAvailable,
        compact: compact,
        errorMessage: errorMessage,
        onClear: onClear,
        hintText: hintText,
      );
    }

    test('construction with all fields', () {
      void onEnabled(bool v) {}
      void onListen() {}
      void onClear() {}

      final state = SpeechSttState(
        enabled: true,
        onEnabledChanged: onEnabled,
        isListening: true,
        onListenPressed: onListen,
        recognizedText: 'hello world',
        isAvailable: true,
        compact: true,
        errorMessage: 'some error',
        onClear: onClear,
        hintText: 'Tap me',
      );

      expect(state.enabled, isTrue);
      expect(state.onEnabledChanged, onEnabled);
      expect(state.isListening, isTrue);
      expect(state.onListenPressed, onListen);
      expect(state.recognizedText, 'hello world');
      expect(state.isAvailable, isTrue);
      expect(state.compact, isTrue);
      expect(state.errorMessage, 'some error');
      expect(state.onClear, onClear);
      expect(state.hintText, 'Tap me');
    });

    test('equal instances with same values are equal', () {
      final a = buildState(
        enabled: true,
        isListening: true,
        recognizedText: 'hello',
      );
      final b = buildState(
        enabled: true,
        isListening: true,
        recognizedText: 'hello',
      );

      expect(a, equals(b));
    });

    test('different values are not equal', () {
      final a = buildState(enabled: true);
      final b = buildState(enabled: false);

      expect(a, isNot(equals(b)));
    });

    test('different isListening values are not equal', () {
      final a = buildState(isListening: false);
      final b = buildState(isListening: true);

      expect(a, isNot(equals(b)));
    });

    test('different recognizedText values are not equal', () {
      final a = buildState(recognizedText: 'hello');
      final b = buildState(recognizedText: 'world');

      expect(a, isNot(equals(b)));
    });

    test('different isAvailable values are not equal', () {
      final a = buildState(isAvailable: true);
      final b = buildState(isAvailable: false);

      expect(a, isNot(equals(b)));
    });

    test('different errorMessage values are not equal', () {
      final a = buildState(errorMessage: null);
      final b = buildState(errorMessage: 'error');

      expect(a, isNot(equals(b)));
    });

    test('different compact values are not equal', () {
      final a = buildState(compact: false);
      final b = buildState(compact: true);

      expect(a, isNot(equals(b)));
    });

    test('different hintText values are not equal', () {
      final a = buildState(hintText: null);
      final b = buildState(hintText: 'Speak now');

      expect(a, isNot(equals(b)));
    });

    test('different callbacks but same values are equal', () {
      final a = buildState(
        enabled: true,
        isListening: false,
        onEnabledChanged: (_) {},
        onListenPressed: () {},
      );
      final b = buildState(
        enabled: true,
        isListening: false,
        onEnabledChanged: (_) {},
        onListenPressed: () {},
      );

      expect(a, equals(b));
    });

    test('hashCode consistent with equality', () {
      final a = buildState(
        enabled: true,
        isListening: true,
        recognizedText: 'test',
      );
      final b = buildState(
        enabled: true,
        isListening: true,
        recognizedText: 'test',
      );

      expect(a.hashCode, equals(b.hashCode));
    });

    test('hashCode differs for different values', () {
      final a = buildState(recognizedText: 'alpha');
      final b = buildState(recognizedText: 'beta');

      expect(a.hashCode, isNot(equals(b.hashCode)));
    });

    test('toString contains key values', () {
      final state = buildState(
        enabled: true,
        isListening: true,
        recognizedText: 'hello world',
        isAvailable: false,
      );

      final str = state.toString();
      expect(str, contains('enabled: true'));
      expect(str, contains('listening: true'));
      expect(str, contains('text: "hello world"'));
      expect(str, contains('available: false'));
    });

    test('toString contains SpeechSttState prefix', () {
      final state = buildState();
      expect(state.toString(), startsWith('SpeechSttState('));
    });
  });
}
