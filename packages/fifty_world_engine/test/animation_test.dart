import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_world_engine/src/animation/animation_queue.dart';

void main() {
  group('AnimationQueue', () {
    test('starts not running', () {
      final queue = AnimationQueue();
      expect(queue.isRunning, isFalse);
      expect(queue.length, 0);
    });

    test('executes entries sequentially', () async {
      final order = <int>[];
      final queue = AnimationQueue();

      queue.enqueueAll([
        AnimationEntry(execute: () async {
          order.add(1);
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }),
        AnimationEntry(execute: () async {
          order.add(2);
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }),
        AnimationEntry(execute: () async {
          order.add(3);
        }),
      ]);

      // Wait for processing
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(order, [1, 2, 3]);
    });

    test('calls onStart and onComplete', () async {
      bool started = false;
      bool completed = false;

      final queue = AnimationQueue(
        onStart: () => started = true,
        onComplete: () => completed = true,
      );

      queue.enqueue(AnimationEntry(
        execute: () async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        },
      ));

      expect(started, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completed, isTrue);
    });

    test('calls entry onComplete callbacks', () async {
      final completions = <int>[];

      final queue = AnimationQueue();
      queue.enqueueAll([
        AnimationEntry(
          execute: () async {},
          onComplete: () => completions.add(1),
        ),
        AnimationEntry(
          execute: () async {},
          onComplete: () => completions.add(2),
        ),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completions, [1, 2]);
    });

    test('cancel clears pending entries', () async {
      final executed = <int>[];

      final queue = AnimationQueue();
      queue.enqueueAll([
        AnimationEntry(execute: () async {
          executed.add(1);
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }),
        AnimationEntry(execute: () async {
          executed.add(2);
        }),
      ]);

      // Cancel while first is still executing
      await Future<void>.delayed(const Duration(milliseconds: 10));
      queue.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(executed, [1]); // Only first executed
    });

    test('AnimationEntry.timed executes action with delay', () async {
      bool actionCalled = false;
      final entry = AnimationEntry.timed(
        action: () => actionCalled = true,
        duration: const Duration(milliseconds: 20),
      );

      await entry.execute();
      expect(actionCalled, isTrue);
    });

    test('isRunning is true while processing', () async {
      final queue = AnimationQueue();
      queue.enqueue(AnimationEntry(
        execute: () async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
      ));

      expect(queue.isRunning, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(queue.isRunning, isFalse);
    });

    test('continues processing when entry.execute() throws', () async {
      final order = <int>[];
      bool queueCompleted = false;

      final queue = AnimationQueue(
        onComplete: () => queueCompleted = true,
      );

      queue.enqueueAll([
        AnimationEntry(execute: () async {
          order.add(1);
        }),
        AnimationEntry(execute: () async {
          throw Exception('die() failed');
        }),
        AnimationEntry(execute: () async {
          order.add(3);
        }),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(order, [1, 3]);
      expect(queue.isRunning, isFalse);
      expect(queueCompleted, isTrue);
    });

    test('calls entry.onComplete even when execute throws', () async {
      final completions = <int>[];

      final queue = AnimationQueue();
      queue.enqueueAll([
        AnimationEntry(
          execute: () async => throw Exception('boom'),
          onComplete: () => completions.add(1),
        ),
        AnimationEntry(
          execute: () async {},
          onComplete: () => completions.add(2),
        ),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(completions, [1, 2]);
    });

    test('resets isRunning after exception', () async {
      final queue = AnimationQueue();
      queue.enqueue(AnimationEntry(
        execute: () async => throw Exception('crash'),
      ));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(queue.isRunning, isFalse);
    });

    test('continues processing when entry.onComplete() throws', () async {
      final order = <int>[];
      bool queueCompleted = false;

      final queue = AnimationQueue(
        onComplete: () => queueCompleted = true,
      );

      queue.enqueueAll([
        AnimationEntry(
          execute: () async => order.add(1),
          onComplete: () => throw Exception('onComplete crashed'),
        ),
        AnimationEntry(
          execute: () async => order.add(2),
        ),
      ]);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(order, [1, 2]);
      expect(queue.isRunning, isFalse);
      expect(queueCompleted, isTrue);
    });

    test('calls queue onComplete even when entry onComplete throws', () async {
      bool queueCompleted = false;

      final queue = AnimationQueue(
        onComplete: () => queueCompleted = true,
      );

      queue.enqueue(AnimationEntry(
        execute: () async {},
        onComplete: () => throw Exception('removeEntity failed'),
      ));

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(queue.isRunning, isFalse);
      expect(queueCompleted, isTrue);
    });

    test('can enqueue after completion', () async {
      final order = <int>[];
      final queue = AnimationQueue();

      queue.enqueue(AnimationEntry(execute: () async {
        order.add(1);
      }));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(queue.isRunning, isFalse);

      queue.enqueue(AnimationEntry(execute: () async {
        order.add(2);
      }));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(order, [1, 2]);
    });
  });
}
