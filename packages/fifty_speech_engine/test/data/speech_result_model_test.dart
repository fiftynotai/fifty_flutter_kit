import 'package:fifty_speech_engine/data/models/speech_result_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeechResultModel', () {
    group('construction', () {
      test('default constructor creates instance with given values', () {
        const model = SpeechResultModel('Hello world', true);

        expect(model.text, 'Hello world');
        expect(model.isFinal, isTrue);
      });

      test('default constructor with partial result', () {
        const model = SpeechResultModel('Hel', false);

        expect(model.text, 'Hel');
        expect(model.isFinal, isFalse);
      });

      test('default constructor with empty text', () {
        const model = SpeechResultModel('', true);

        expect(model.text, isEmpty);
        expect(model.isFinal, isTrue);
      });
    });

    group('factory constructors', () {
      test('final_ creates a final result', () {
        final model = SpeechResultModel.final_('Done speaking');

        expect(model.text, 'Done speaking');
        expect(model.isFinal, isTrue);
      });

      test('partial creates a partial result', () {
        final model = SpeechResultModel.partial('Still going');

        expect(model.text, 'Still going');
        expect(model.isFinal, isFalse);
      });

      test('final_ with empty text', () {
        final model = SpeechResultModel.final_('');

        expect(model.text, isEmpty);
        expect(model.isFinal, isTrue);
      });

      test('partial with empty text', () {
        final model = SpeechResultModel.partial('');

        expect(model.text, isEmpty);
        expect(model.isFinal, isFalse);
      });
    });

    group('equality', () {
      test('identical instances are equal', () {
        const model = SpeechResultModel('test', true);

        expect(model == model, isTrue);
      });

      test('same values are equal', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('hello', true);

        expect(a, equals(b));
      });

      test('different text values are not equal', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('world', true);

        expect(a, isNot(equals(b)));
      });

      test('different isFinal values are not equal', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('hello', false);

        expect(a, isNot(equals(b)));
      });

      test('factory-created instance equals default constructor', () {
        final factoryResult = SpeechResultModel.final_('test');
        const constructorResult = SpeechResultModel('test', true);

        expect(factoryResult, equals(constructorResult));
      });

      test('partial factory equals constructor with false', () {
        final factoryResult = SpeechResultModel.partial('test');
        const constructorResult = SpeechResultModel('test', false);

        expect(factoryResult, equals(constructorResult));
      });

      test('not equal to non-SpeechResultModel object', () {
        const model = SpeechResultModel('test', true);

        // ignore: unrelated_type_equality_checks
        expect(model == 'not a model', isFalse);
      });
    });

    group('hashCode', () {
      test('same values produce same hashCode', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('hello', true);

        expect(a.hashCode, equals(b.hashCode));
      });

      test('different text produces different hashCode', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('world', true);

        expect(a.hashCode, isNot(equals(b.hashCode)));
      });

      test('different isFinal produces different hashCode', () {
        const a = SpeechResultModel('hello', true);
        const b = SpeechResultModel('hello', false);

        expect(a.hashCode, isNot(equals(b.hashCode)));
      });
    });

    group('toString', () {
      test('contains text value', () {
        const model = SpeechResultModel('Hello world', true);

        expect(model.toString(), contains('Hello world'));
      });

      test('contains isFinal value', () {
        const model = SpeechResultModel('test', true);

        expect(model.toString(), contains('isFinal: true'));
      });

      test('contains SpeechResultModel prefix', () {
        const model = SpeechResultModel('test', false);

        expect(model.toString(), startsWith('SpeechResultModel('));
      });

      test('full format for final result', () {
        const model = SpeechResultModel('Hello', true);

        expect(
          model.toString(),
          'SpeechResultModel(text: Hello, isFinal: true)',
        );
      });

      test('full format for partial result', () {
        const model = SpeechResultModel('Hel', false);

        expect(
          model.toString(),
          'SpeechResultModel(text: Hel, isFinal: false)',
        );
      });
    });

    group('const usage', () {
      test('can be used as const', () {
        // Compile-time const verification
        const model = SpeechResultModel('const test', true);

        expect(model.text, 'const test');
      });

      test('const instances with same values are identical', () {
        const a = SpeechResultModel('same', true);
        const b = SpeechResultModel('same', true);

        expect(identical(a, b), isTrue);
      });
    });
  });
}
