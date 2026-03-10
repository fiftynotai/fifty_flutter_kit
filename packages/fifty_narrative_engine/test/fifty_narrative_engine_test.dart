import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_narrative_engine/fifty_narrative_engine.dart';

class TestSentence implements BaseNarrativeModel {
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
  group('NarrativeEngine', () {
    test('initializes with idle status', () {
      final engine = NarrativeEngine();

      expect(engine.status, ProcessingStatus.idle);
      expect(engine.sentences, isEmpty);
      expect(engine.processingIndex, 0);

      engine.dispose();
    });

    test('enqueues sentences', () {
      final engine = NarrativeEngine();

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
      final engine = NarrativeEngine(
        onSentencesChanged: (sentences) {},
      );

      final interpreter = NarrativeInterpreter(
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
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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

    test('pauseUntilUserContinues blocks and continueAfterUserInput resumes',
        () async {
      final writtenTexts = <String>[];
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          writtenTexts.add(sentence.text);
        },
        onWait: (sentence) async {
          // The interpreter calls pauseUntilUserContinues for waitForUserInput
          // when there is no navigation. We simulate the blocking flow manually.
          await engine.pauseUntilUserContinues();
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'Before pause', waitForUserInput: true),
        TestSentence(text: 'After pause'),
      ]);

      // Start processing in background
      final processing = engine.process();

      // Wait for the first sentence to be processed and engine to pause
      await Future.delayed(const Duration(milliseconds: 100));

      expect(writtenTexts, contains('Before pause'));
      expect(engine.status, ProcessingStatus.paused);

      // The second sentence should NOT have been processed yet
      expect(writtenTexts, isNot(contains('After pause')));

      // Resume via user input
      engine.continueAfterUserInput();

      await processing;

      expect(writtenTexts, contains('After pause'));

      engine.dispose();
    });

    test('dispose closes the status stream', () async {
      final engine = NarrativeEngine();

      engine.dispose();

      // After dispose, listening to the stream should eventually get a done event
      var streamDone = false;
      engine.onStatusChanged.listen(
        (_) {},
        onDone: () => streamDone = true,
      );

      // Allow microtasks to complete
      await Future.delayed(const Duration(milliseconds: 10));

      expect(streamDone, true);
    });

    test('reset clears queue and resets index to idle', () async {
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          engine.addSentenceToWritten(sentence);
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'Hello'),
      ]);

      await engine.process();

      // After processing, reset is called internally by _finish,
      // but let's verify explicit reset works from a fresh state.
      engine.enqueue([
        TestSentence(text: 'Queued'),
      ]);

      engine.reset();

      expect(engine.processingIndex, 0);
      expect(engine.status, ProcessingStatus.idle);

      engine.dispose();
    });

    test('clearProcessedSentences clears the written list', () async {
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          engine.addSentenceToWritten(sentence);
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'First'),
        TestSentence(text: 'Second'),
      ]);

      await engine.process();

      expect(engine.sentences.length, 2);

      engine.clearProcessedSentences();

      expect(engine.sentences, isEmpty);

      engine.dispose();
    });

    test('process with no interpreter still completes', () async {
      final engine = NarrativeEngine();

      engine.enqueue([
        TestSentence(text: 'Uninterpreted'),
      ]);

      var completed = false;
      await engine.process(onComplete: () => completed = true);

      expect(completed, true);
      expect(engine.status, ProcessingStatus.idle);

      engine.dispose();
    });

    test('double process call is guarded', () async {
      var writeCount = 0;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {
          writeCount++;
          // Small delay to allow the second process() call to attempt
          await Future.delayed(const Duration(milliseconds: 20));
        },
      );

      engine.registerInterpreter(interpreter);

      engine.enqueue([
        TestSentence(text: 'Only once'),
      ]);

      // Call process twice concurrently
      final first = engine.process();
      final second = engine.process();

      await Future.wait([first, second]);

      // The second call should return immediately (re-entrant guard)
      expect(writeCount, 1);

      engine.dispose();
    });

    test('status stream emits changes', () async {
      final engine = NarrativeEngine();
      final statuses = <ProcessingStatus>[];

      engine.onStatusChanged.listen(statuses.add);

      final interpreter = NarrativeInterpreter(
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

  group('NarrativeQueue', () {
    test('pushBack adds to end', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'First'));
      queue.pushBack(TestSentence(text: 'Second'));

      expect(queue.length, 2);
      expect(queue.pop().text, 'First');
      expect(queue.pop().text, 'Second');
    });

    test('pushFront adds to beginning', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'First'));
      queue.pushFront(TestSentence(text: 'Zero'));

      expect(queue.pop().text, 'Zero');
    });

    test('pushOrdered sorts by order', () {
      final queue = NarrativeQueue();

      queue.pushOrdered(TestSentence(text: 'C', order: 3));
      queue.pushOrdered(TestSentence(text: 'A', order: 1));
      queue.pushOrdered(TestSentence(text: 'B', order: 2));

      expect(queue.pop().text, 'A');
      expect(queue.pop().text, 'B');
      expect(queue.pop().text, 'C');
    });

    test('clear empties queue', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'Test'));
      expect(queue.isNotEmpty, true);

      queue.clear();
      expect(queue.isEmpty, true);
    });

    test('peek returns without removing', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'Test'));

      expect(queue.peek().text, 'Test');
      expect(queue.length, 1);
    });

    test('pushBackAll adds multiple items to end', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'First'));
      queue.pushBackAll([
        TestSentence(text: 'Second'),
        TestSentence(text: 'Third'),
      ]);

      expect(queue.length, 3);
      expect(queue.pop().text, 'First');
      expect(queue.pop().text, 'Second');
      expect(queue.pop().text, 'Third');
    });

    test('pushFrontAll adds multiple items to front in order', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'Last'));
      queue.pushFrontAll([
        TestSentence(text: 'First'),
        TestSentence(text: 'Second'),
      ]);

      expect(queue.length, 3);
      expect(queue.pop().text, 'First');
      expect(queue.pop().text, 'Second');
      expect(queue.pop().text, 'Last');
    });

    test('pushOrderedAll sorts multiple items by order', () {
      final queue = NarrativeQueue();

      queue.pushOrderedAll([
        TestSentence(text: 'C', order: 3),
        TestSentence(text: 'A', order: 1),
        TestSentence(text: 'B', order: 2),
      ]);

      expect(queue.length, 3);
      expect(queue.pop().text, 'A');
      expect(queue.pop().text, 'B');
      expect(queue.pop().text, 'C');
    });

    test('pop on empty queue throws StateError', () {
      final queue = NarrativeQueue();

      expect(() => queue.pop(), throwsStateError);
    });

    test('peek on empty queue throws StateError', () {
      final queue = NarrativeQueue();

      expect(() => queue.peek(), throwsStateError);
    });

    test('toList returns items in queue order', () {
      final queue = NarrativeQueue();

      queue.pushOrdered(TestSentence(text: 'B', order: 2));
      queue.pushOrdered(TestSentence(text: 'A', order: 1));

      final list = queue.toList();

      expect(list.length, 2);
      expect(list[0].text, 'A');
      expect(list[1].text, 'B');
    });

    test('contains finds existing item', () {
      final queue = NarrativeQueue();
      final sentence = TestSentence(text: 'Target');

      queue.pushBack(sentence);

      expect(queue.contains(sentence), true);
      expect(queue.contains(TestSentence(text: 'Other')), false);
    });

    test('remove removes specific item', () {
      final queue = NarrativeQueue();
      final target = TestSentence(text: 'Remove me');

      queue.pushBack(TestSentence(text: 'Keep'));
      queue.pushBack(target);

      queue.remove(target);

      expect(queue.length, 1);
      expect(queue.pop().text, 'Keep');
    });

    test('removeWhere removes matching items', () {
      final queue = NarrativeQueue();

      queue.pushBack(TestSentence(text: 'Keep', order: 1));
      queue.pushBack(TestSentence(text: 'Remove', order: 2));
      queue.pushBack(TestSentence(text: 'Also remove', order: 3));

      queue.removeWhere((item) => (item.order ?? 0) > 1);

      expect(queue.length, 1);
      expect(queue.pop().text, 'Keep');
    });
  });

  group('NarrativeInterpreter', () {
    test('handles write instruction', () async {
      var writeCalled = false;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
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

    test('invokes onAsk when sentence has choices', () async {
      BaseNarrativeModel? askedSentence;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
        onAsk: (sentence) async {
          askedSentence = sentence;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'What do you choose?',
        instruction: 'write',
        choices: ['Option A', 'Option B'],
      ));

      expect(askedSentence, isNotNull);
      expect(askedSentence!.text, 'What do you choose?');
      expect(askedSentence!.choices, ['Option A', 'Option B']);

      engine.dispose();
    });

    test('does not invoke onAsk when choices is empty', () async {
      var askCalled = false;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
        onAsk: (sentence) async {
          askCalled = true;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'No choices here',
        instruction: 'write',
      ));

      expect(askCalled, false);

      engine.dispose();
    });

    test('invokes onWait when waitForUserInput is true', () async {
      BaseNarrativeModel? waitedSentence;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
        onWait: (sentence) async {
          waitedSentence = sentence;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'Tap to continue',
        instruction: 'write',
        waitForUserInput: true,
      ));

      expect(waitedSentence, isNotNull);
      expect(waitedSentence!.text, 'Tap to continue');

      engine.dispose();
    });

    test('invokes onNavigate when phase changes', () async {
      BaseNarrativeModel? navigatedSentence;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
        onNavigate: (sentence) async {
          navigatedSentence = sentence;
        },
      );

      await interpreter.interpret(TestSentence(
        text: 'Moving to chapter 2',
        instruction: 'write',
        phase: 'chapter_2',
      ));

      expect(navigatedSentence, isNotNull);
      expect(navigatedSentence!.text, 'Moving to chapter 2');
      expect(interpreter.currentPhase, 'chapter_2');

      engine.dispose();
    });

    test('does not invoke onNavigate when phase is same', () async {
      var navigateCalled = false;
      final engine = NarrativeEngine();

      final interpreter = NarrativeInterpreter(
        engine: engine,
        onWrite: (sentence) async {},
        onNavigate: (sentence) async {
          navigateCalled = true;
        },
      );

      // First interpret sets the phase
      await interpreter.interpret(TestSentence(
        text: 'First',
        instruction: 'write',
        phase: 'chapter_1',
      ));

      expect(navigateCalled, true);

      // Reset flag
      navigateCalled = false;

      // Same phase — should NOT navigate
      await interpreter.interpret(TestSentence(
        text: 'Second',
        instruction: 'write',
        phase: 'chapter_1',
      ));

      expect(navigateCalled, false);

      engine.dispose();
    });
  });

  group('SafeNarrativeWriter', () {
    test('writes first sentence', () async {
      var writeCount = 0;
      final writer = SafeNarrativeWriter((sentence) async {
        writeCount++;
      });

      await writer.write(TestSentence(text: 'Test'));

      expect(writeCount, 1);
    });

    test('prevents duplicate writes', () async {
      var writeCount = 0;
      final writer = SafeNarrativeWriter((sentence) async {
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
      final writer = SafeNarrativeWriter((sentence) async {
        writeCount++;
      });

      await writer.write(TestSentence(text: 'First'));
      await writer.write(TestSentence(text: 'Second'));

      expect(writeCount, 2);
    });

    test('reset allows re-writing', () async {
      var writeCount = 0;
      final writer = SafeNarrativeWriter((sentence) async {
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
