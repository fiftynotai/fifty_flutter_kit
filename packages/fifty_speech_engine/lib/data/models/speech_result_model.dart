/// **SpeechResultModel**
///
/// Represents a speech recognition result with the recognized text
/// and a flag indicating whether this is a final result or partial.
///
/// **Example:**
/// ```dart
/// final result = SpeechResultModel('Hello world', true);
/// print(result.text); // 'Hello world'
/// print(result.isFinal); // true
/// ```
class SpeechResultModel {
  /// The recognized text from speech input
  final String text;

  /// Whether this is a final result (true) or partial (false)
  final bool isFinal;

  /// Creates a new speech result model
  const SpeechResultModel(this.text, this.isFinal);

  /// Creates a final result
  factory SpeechResultModel.final_(String text) =>
      SpeechResultModel(text, true);

  /// Creates a partial result
  factory SpeechResultModel.partial(String text) =>
      SpeechResultModel(text, false);

  @override
  String toString() => 'SpeechResultModel(text: $text, isFinal: $isFinal)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechResultModel &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          isFinal == other.isFinal;

  @override
  int get hashCode => text.hashCode ^ isFinal.hashCode;
}
