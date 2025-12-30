import 'dart:collection';
import 'base_sentence.dart';

/// **SentenceQueue**
///
/// Optimized queue for large-scale sentence processing.
/// Manages `BaseSentenceModel` items with optional `order`-based sorting.
///
/// **Key Responsibilities:**
/// - Manual vs order-based enqueuing
/// - Efficient, lazy sorting for `pushOrdered` operations
/// - In-place operations for low memory churn
///
/// **Usage Example:**
/// ```dart
/// final queue = SentenceQueue();
/// queue.pushBack(sentence1);
/// queue.pushOrdered(sentence2); // Will be sorted by order
/// final next = queue.pop();
/// ```
class SentenceQueue {
  final ListQueue<BaseSentenceModel> _queue = ListQueue<BaseSentenceModel>();
  bool _isSorted = true;

  /// **Push a sentence to the end (no sort)**
  void pushBack(BaseSentenceModel item) {
    _queue.addLast(item);
    _isSorted = false;
  }

  /// **Push many to the end (no sort)**
  void pushBackAll(Iterable<BaseSentenceModel> items) {
    _queue.addAll(items);
    _isSorted = false;
  }

  /// **Push a sentence to the front (no sort)**
  void pushFront(BaseSentenceModel item) {
    _queue.addFirst(item);
    _isSorted = false;
  }

  /// **Push many to the front (no sort)**
  void pushFrontAll(Iterable<BaseSentenceModel> items) {
    for (final item in items.toList().reversed) {
      _queue.addFirst(item);
    }
    _isSorted = false;
  }

  /// **Push one with `order` and force sort**
  void pushOrdered(BaseSentenceModel item) {
    _queue.add(item);
    _isSorted = false;
    _resortIfNeeded();
  }

  /// **Push many with `order` and force sort**
  void pushOrderedAll(Iterable<BaseSentenceModel> items) {
    _queue.addAll(items);
    _isSorted = false;
    _resortIfNeeded();
  }

  /// **Force sort manually**
  void sortByOrder() {
    _isSorted = false;
    _resortIfNeeded();
  }

  /// **Pop first sentence**
  BaseSentenceModel pop() {
    _resortIfNeeded();
    return _queue.removeFirst();
  }

  /// **Peek without removing**
  BaseSentenceModel peek() {
    _resortIfNeeded();
    return _queue.first;
  }

  /// **List of all items (preserves queue order)**
  List<BaseSentenceModel> toList() {
    _resortIfNeeded();
    return _queue.toList();
  }

  /// **Clear all**
  void clear() {
    _queue.clear();
    _isSorted = true;
  }

  /// Returns the number of items in the queue.
  int get length => _queue.length;

  /// Returns true if the queue is empty.
  bool get isEmpty => _queue.isEmpty;

  /// Returns true if the queue is not empty.
  bool get isNotEmpty => _queue.isNotEmpty;

  /// Check if an item exists in the queue.
  bool contains(BaseSentenceModel item) => _queue.contains(item);

  /// Remove a specific item from the queue.
  void remove(BaseSentenceModel item) => _queue.remove(item);

  /// Remove items matching a condition.
  void removeWhere(bool Function(BaseSentenceModel) test) {
    _queue.removeWhere(test);
  }

  /// **Internal sorter (called lazily only once per batch)**
  void _resortIfNeeded() {
    if (_isSorted || _queue.length <= 1) return;

    final list = _queue.toList();
    list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    _queue
      ..clear()
      ..addAll(list);

    _isSorted = true;
  }
}
