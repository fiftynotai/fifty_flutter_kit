import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_sentences_engine/fifty_sentences_engine.dart';

class TestSentence implements BaseSentenceModel {
  TestSentence({
    this.order,
    required this.text,
    this.instruction = 'write',
    this.waitForUserInput = false,
    this.phase,
    this.choices = const [],
  });

  @override
  final int? order;

  @override
  final String text;

  @override
  final String instruction;

  @override
  final bool waitForUserInput;

  @override
  final String? phase;

  @override
  final List<dynamic> choices;
}

void main() {
  group('SentenceEngine', () {
    test('initializes with idle status', () {
      final engine = SentenceEngine();

      expect(engine.status, ProcessingStatus.idle);
      expect(engine.sentences, isEmpty);
      expect(engine.processingIndex, 0);

      engine.dispose();
    });

    test('enqueues sentences', () {
      final engine = SentenceEngine();

      engine.enqueue([
        TestSentence(text: 'First'),
        TestSentence(text: 'Second'),
      ]);

      // Queue is internal, but we can verify processing works
      expect(engine.status, ProcessingStatus.idle);

      engine.dispose();
    });

    test('processes sentences and calls onWrite', () async {
      final writtenTexts = <String>[];
      final engine = SentenceEngine(
        onSentencesChanged: (sentences) {},
      );

      final interpreter = SentenceInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          writtenTexts.add(sentence.text);
          engine.addSentenceToWritten(sentence);
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'Hello'),
        TestSentence(text: 'World'),
      ]);

      await engine.process();

      expect(writtenTexts, ['Hello', 'World']);
      expect(engine.sentences.length, 2);

      engine.dispose();
    });

    test('pause and resume work correctly', () async {
      var processedCount = 0;
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          processedCount++;
          if (processedCount == 1) {
            engine.pause();
          }
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'First'),
        TestSentence(text: 'Second'),
      ]);

      // Start processing in background
      final processing = engine.process();

      // Wait a bit for first sentence
      await Future.delayed(const Duration(milliseconds: 100));

      expect(engine.status, ProcessingStatus.paused);
      expect(processedCount, 1);

      // Resume
      engine.resume();

      await processing;

      expect(processedCount, 2);

      engine.dispose();
    });

    test('cancel stops processing', () async {
      var wasInterrupted = false;
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          await Future.delayed(const Duration(milliseconds: 50));
          engine.cancel();
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'First'),
        TestSentence(text: 'Second'),
      ]);

      await engine.process(
        onInterrupted: () => wasInterrupted = true,
      );

      expect(wasInterrupted, true);

      engine.dispose();
    });

    test('status stream emits changes', () async {
      final engine = SentenceEngine();
      final statuses = <ProcessingStatus>[];

      engine.onStatusChanged.listen(statuses.add);

      final interpreter = SentenceInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([TestSentence(text: 'Test')]);

      await engine.process();

      // Allow stream events to propagate
      await Future.delayed(const Duration(milliseconds: 10));

      expect(statuses, contains(ProcessingStatus.processing));
      // After processing completes, it resets to idle
      expect(statuses, contains(ProcessingStatus.idle));

      engine.dispose();
    });
  });

  group('SentenceQueue', () {
    test('pushBack adds to end', () {
      final queue = SentenceQueue();

      queue.pushBack(TestSentence(text: 'First'));
      queue.pushBack(TestSentence(text: 'Second'));

      expect(queue.length, 2);
      expect(queue.pop().text, 'First');
      expect(queue.pop().text, 'Second');
    });

    test('pushFront adds to beginning', () {
      final queue = SentenceQueue();

      queue.pushBack(TestSentence(text: 'First'));
      queue.pushFront(TestSentence(text: 'Zero'));

      expect(queue.pop().text, 'Zero');
    });

    test('pushOrdered sorts by order', () {
      final queue = SentenceQueue();

      queue.pushOrdered(TestSentence(text: 'C', order: 3));
      queue.pushOrdered(TestSentence(text: 'A', order: 1));
      queue.pushOrdered(TestSentence(text: 'B', order: 2));

      expect(queue.pop().text, 'A');
      expect(queue.pop().text, 'B');
      expect(queue.pop().text, 'C');
    });

    test('clear empties queue', () {
      final queue = SentenceQueue();

      queue.pushBack(TestSentence(text: 'Test'));
      expect(queue.isNotEmpty, true);

      queue.clear();
      expect(queue.isEmpty, true);
    });

    test('peek returns without removing', () {
      final queue = SentenceQueue();

      queue.pushBack(TestSentence(text: 'Test'));

      expect(queue.peek().text, 'Test');
      expect(queue.length, 1);
    });
  });

  group('SentenceInterpreter', () {
    test('handles write instruction', () async {
      var writeCalled = false;
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          writeCalled = true;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'Test',
        instruction: 'write',
      ));

      expect(writeCalled, true);

      engine.dispose();
    });

    test('handles read instruction', () async {
      var readText = '';
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onRead: (text) async {
          readText = text;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'Hello',
        instruction: 'read',
      ));

      expect(readText, 'Hello');

      engine.dispose();
    });

    test('handles combined instructions', () async {
      var readCalled = false;
      var writeCalled = false;
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onRead: (text) async => readCalled = true,
        onWrite: (sentence) async => writeCalled = true,
      );

      await interpreter.interpret(TestSentence(
        text: 'Test',
        instruction: 'read + write',
      ));

      expect(readCalled, true);
      expect(writeCalled, true);

      engine.dispose();
    });

    test('calls onUnhandled for unknown instructions', () async {
      var unhandledCalled = false;
      final engine = SentenceEngine();

      final interpreter = SentenceInterpreter(
        engine: engine,
        onUnhandled: (sentence) async => unhandledCalled = true,
      );

      await interpreter.interpret(TestSentence(
        text: 'Test',
        instruction: 'custom_action',
      ));

      expect(unhandledCalled, true);

      engine.dispose();
    });
  });

  group('SafeSentenceWriter', () {
    test('writes first sentence', () async {
      var writeCount = 0;
      final writer = SafeSentenceWriter((sentence) async {
        writeCount++;
      });

      await writer.write(TestSentence(text: 'Test'));

      expect(writeCount, 1);
    });

    test('prevents duplicate writes', () async {
      var writeCount = 0;
      final writer = SafeSentenceWriter((sentence) async {
        writeCount++;
      });

      final sentence = TestSentence(text: 'Test');

      await writer.write(sentence);
      await writer.write(sentence);
      await writer.write(sentence);

      expect(writeCount, 1);
    });

    test('writes different sentences', () async {
      var writeCount = 0;
      final writer = SafeSentenceWriter((sentence) async {
        writeCount++;
      });

      await writer.write(TestSentence(text: 'First'));
      await writer.write(TestSentence(text: 'Second'));

      expect(writeCount, 2);
    });

    test('reset allows re-writing', () async {
      var writeCount = 0;
      final writer = SafeSentenceWriter((sentence) async {
        writeCount++;
      });

      final sentence = TestSentence(text: 'Test');

      await writer.write(sentence);
      writer.reset();
      await writer.write(sentence);

      expect(writeCount, 2);
    });
  });
}
