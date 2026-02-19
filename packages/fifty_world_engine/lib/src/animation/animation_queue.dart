import 'dart:async';
import 'dart:ui' show VoidCallback;

/// An entry in the animation queue.
///
/// Each entry wraps an async operation (the animation) with an optional
/// completion callback.
class AnimationEntry {
  /// The async function that performs the animation.
  /// Must complete (via Future) when the animation is done.
  final Future<void> Function() execute;

  /// Called after this entry completes.
  final VoidCallback? onComplete;

  /// Creates an animation entry.
  const AnimationEntry({
    required this.execute,
    this.onComplete,
  });

  /// Creates an entry from a synchronous action with a fixed duration.
  ///
  /// The action is called immediately, then the entry waits [duration]
  /// before completing.
  factory AnimationEntry.timed({
    required void Function() action,
    required Duration duration,
    VoidCallback? onComplete,
  }) {
    return AnimationEntry(
      execute: () async {
        action();
        await Future<void>.delayed(duration);
      },
      onComplete: onComplete,
    );
  }
}

/// Executes animation entries sequentially.
///
/// When the queue starts processing, it calls [onStart]. When all entries
/// have completed, it calls [onComplete]. This is designed to integrate
/// with [InputManager] for input blocking during animations.
///
/// Usage:
/// ```dart
/// final queue = AnimationQueue(
///   onStart: () => inputManager.block(),
///   onComplete: () => inputManager.unblock(),
/// );
/// queue.enqueue(AnimationEntry(execute: () => moveEntity(...)));
/// queue.enqueue(AnimationEntry(execute: () => showDamage(...)));
/// ```
class AnimationQueue {
  /// Called when the queue starts processing (first entry begins).
  final VoidCallback? onStart;

  /// Called when the queue finishes processing (last entry completes).
  final VoidCallback? onComplete;

  final List<AnimationEntry> _queue = [];
  bool _isRunning = false;
  bool _cancelled = false;

  /// Creates an animation queue.
  ///
  /// - [onStart]: invoked when the first entry begins processing.
  /// - [onComplete]: invoked when the last entry finishes processing.
  AnimationQueue({this.onStart, this.onComplete});

  /// Whether the queue is currently processing entries.
  bool get isRunning => _isRunning;

  /// Number of entries remaining (including the currently executing one).
  int get length => _queue.length;

  /// Adds an entry to the queue and starts processing if not already running.
  void enqueue(AnimationEntry entry) {
    _queue.add(entry);
    if (!_isRunning) {
      _processQueue();
    }
  }

  /// Adds multiple entries and starts processing if not already running.
  void enqueueAll(List<AnimationEntry> entries) {
    _queue.addAll(entries);
    if (!_isRunning) {
      _processQueue();
    }
  }

  /// Cancels all pending entries and stops after the current one finishes.
  ///
  /// Does NOT interrupt a currently executing animation.
  void cancel() {
    _cancelled = true;
    _queue.clear();
  }

  Future<void> _processQueue() async {
    _isRunning = true;
    _cancelled = false;
    onStart?.call();

    try {
      while (_queue.isNotEmpty && !_cancelled) {
        final entry = _queue.removeAt(0);
        try {
          await entry.execute();
        } catch (e, st) {
          // Log but don't propagate — the queue must keep processing.
          // ignore: avoid_print
          print('[AnimationQueue] entry.execute() threw: $e\n$st');
        }
        try {
          entry.onComplete?.call();
        } catch (e, st) {
          // Log but don't propagate — callers rely on onComplete to resolve
          // Completers; if we let this throw, the queue exits early and
          // remaining entries are orphaned.
          // ignore: avoid_print
          print('[AnimationQueue] entry.onComplete() threw: $e\n$st');
        }
      }
    } finally {
      _isRunning = false;
      _cancelled = false;
      onComplete?.call();
    }
  }
}
