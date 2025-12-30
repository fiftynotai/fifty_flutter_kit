import 'package:fifty_sentences_engine/data/base_sentence.dart';

/// **SafeSentenceWriter**
///
/// A protective wrapper around a sentence writer function that avoids writing
/// the same sentence twice in a row. Useful for ensuring idempotent behavior
/// in systems where duplicate instructions can be sent (e.g. during turn-based loops).
///
/// **Key Responsibilities:**
/// - Prevent repeated visual or audio rendering of identical sentences
/// - Ensure only *new* or *changed* sentences are passed to the delegate writer
/// - Track last written sentence in memory
///
/// **Usage Example:**
/// ```dart
/// final writer = SafeSentenceWriter((s) => chatBox.write(s));
/// await writer.write(sentence); // writes only if not same as previous
/// ```
class SafeSentenceWriter {
  /// Constructor
  ///
  /// Accepts a delegate writer that performs the actual side-effect.
  SafeSentenceWriter(this._delegate);

  /// Delegate function to call when a sentence is accepted.
  final Future<void> Function(BaseSentenceModel sentence) _delegate;

  /// Last written sentence, used to prevent duplication.
  BaseSentenceModel? _last;

  /// Writes a sentence *only if it differs from the last one*.
  ///
  /// Compares both `text` and `instruction` fields.
  Future<void> write(BaseSentenceModel sentence) async {
    final isDuplicate = _last?.text == sentence.text &&
        _last?.instruction == sentence.instruction;

    if (!isDuplicate) {
      _last = sentence;
      await _delegate(sentence);
    }
  }

  /// Manually clears the last recorded sentence.
  ///
  /// Useful after a game reset or phase change where the next sentence
  /// might intentionally be repeated.
  void reset() {
    _last = null;
  }
}
