import 'package:fifty_speech_engine/tts/tts_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Note: TtsManager wraps FlutterTts which is created internally
  // (not injectable). Tests cover construction and state getters
  // that don't require platform interaction.

  group('TtsManager', () {
    late TtsManager manager;

    setUp(() {
      manager = TtsManager();
    });

    group('construction', () {
      test('creates instance without error', () {
        expect(manager, isA<TtsManager>());
      });

      test('isSpeaking is false initially', () {
        expect(manager.isSpeaking, isFalse);
      });

      test('onSpeechComplete is null initially', () {
        expect(manager.onSpeechComplete, isNull);
      });
    });

    group('onSpeechComplete callback', () {
      test('can be assigned', () {
        var called = false;
        manager.onSpeechComplete = () => called = true;

        expect(manager.onSpeechComplete, isNotNull);

        // Invoke to verify it's the correct callback
        manager.onSpeechComplete!();
        expect(called, isTrue);
      });

      test('can be set to null', () {
        manager.onSpeechComplete = () {};
        manager.onSpeechComplete = null;

        expect(manager.onSpeechComplete, isNull);
      });

      test('can be reassigned', () {
        var firstCalled = false;
        var secondCalled = false;

        manager.onSpeechComplete = () => firstCalled = true;
        manager.onSpeechComplete = () => secondCalled = true;

        manager.onSpeechComplete!();

        expect(firstCalled, isFalse);
        expect(secondCalled, isTrue);
      });
    });

    group('dispose', () {
      test('can be called without error', () {
        // dispose() calls stop() internally -- should not throw
        // even without initialization
        expect(() => manager.dispose(), returnsNormally);
      });

      test('isSpeaking remains false after dispose', () {
        manager.dispose();

        expect(manager.isSpeaking, isFalse);
      });
    });

    group('multiple instances', () {
      test('instances are independent', () {
        final manager1 = TtsManager();
        final manager2 = TtsManager();

        manager1.onSpeechComplete = () {};

        expect(manager1.onSpeechComplete, isNotNull);
        expect(manager2.onSpeechComplete, isNull);
        expect(manager1.isSpeaking, isFalse);
        expect(manager2.isSpeaking, isFalse);
      });
    });
  });
}
