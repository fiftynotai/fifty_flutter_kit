import 'package:fifty_speech_engine/stt/stt_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Note: SttManager wraps SpeechToText which is created internally
  // (not injectable). Tests cover construction, state getters, and
  // pure logic (flushQueue, guard clauses) that don't require
  // platform audio hardware.

  group('SttManager', () {
    late SttManager manager;

    setUp(() {
      manager = SttManager();
    });

    group('construction', () {
      test('creates instance without error', () {
        expect(manager, isA<SttManager>());
      });

      test('isListening is false initially', () {
        expect(manager.isListening, isFalse);
      });

      test('isAvailable is false initially', () {
        expect(manager.isAvailable, isFalse);
      });

      test('isProcessing is false initially', () {
        expect(manager.isProcessing, isFalse);
      });

      test('partialResults is false initially', () {
        expect(manager.partialResults, isFalse);
      });

      test('onResult is null initially', () {
        expect(manager.onResult, isNull);
      });

      test('onError is null initially', () {
        expect(manager.onError, isNull);
      });
    });

    group('callbacks', () {
      test('onResult can be assigned', () {
        manager.onResult = (text) async {};

        expect(manager.onResult, isNotNull);
      });

      test('onResult can be set to null', () {
        manager.onResult = (text) async {};
        manager.onResult = null;

        expect(manager.onResult, isNull);
      });

      test('onError can be assigned', () {
        manager.onError = (error) {};

        expect(manager.onError, isNotNull);
      });

      test('onError can be set to null', () {
        manager.onError = (error) {};
        manager.onError = null;

        expect(manager.onError, isNull);
      });

      test('onResult receives correct text when invoked directly', () async {
        String? received;
        manager.onResult = (text) async {
          received = text;
        };

        await manager.onResult!('hello world');

        expect(received, 'hello world');
      });

      test('onError receives correct message when invoked directly', () {
        String? received;
        manager.onError = (error) {
          received = error;
        };

        manager.onError!('mic not found');

        expect(received, 'mic not found');
      });
    });

    group('partialResults', () {
      test('can be set to true', () {
        manager.partialResults = true;

        expect(manager.partialResults, isTrue);
      });

      test('can be toggled', () {
        manager.partialResults = true;
        manager.partialResults = false;

        expect(manager.partialResults, isFalse);
      });
    });

    group('flushQueue', () {
      test('can be called without error when queue is empty', () {
        expect(() => manager.flushQueue(), returnsNormally);
      });

      test('can be called multiple times', () {
        manager.flushQueue();
        manager.flushQueue();

        // No error indicates success
        expect(manager.isListening, isFalse);
      });
    });

    group('stopListening', () {
      test('does nothing when not listening', () async {
        // isListening is false, so stopListening should bail early
        await manager.stopListening();

        expect(manager.isListening, isFalse);
      });
    });

    group('cancelListening', () {
      test('does nothing when not listening', () async {
        // isListening is false, so cancelListening should bail early
        await manager.cancelListening();

        expect(manager.isListening, isFalse);
      });
    });

    group('startListening', () {
      test('does nothing when not available', () async {
        // isAvailable is false by default, so startListening should bail
        await manager.startListening();

        expect(manager.isListening, isFalse);
      });
    });

    group('dispose', () {
      test('can be called without error', () {
        expect(() => manager.dispose(), returnsNormally);
      });

      test('isListening remains false after dispose', () {
        manager.dispose();

        expect(manager.isListening, isFalse);
      });
    });

    group('multiple instances', () {
      test('instances are independent', () {
        final manager1 = SttManager();
        final manager2 = SttManager();

        manager1.onResult = (text) async {};
        manager1.partialResults = true;

        expect(manager1.onResult, isNotNull);
        expect(manager2.onResult, isNull);
        expect(manager1.partialResults, isTrue);
        expect(manager2.partialResults, isFalse);
      });
    });
  });
}
