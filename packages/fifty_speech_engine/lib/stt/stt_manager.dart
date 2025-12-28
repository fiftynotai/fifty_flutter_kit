import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// **SttManager - Speech-to-Text (STT) handler**
///
/// Handles all Speech-to-Text (STT) functionality including:
/// - Microphone permission handling
/// - Starting/stopping speech recognition
/// - Continuous listening
/// - Language switching
/// - Queueing overlapping recognition results
/// - Deduplicating and safely processing input
///
/// This class provides a simple interface to capture voice input from the user
/// and stream it back to the game engine or UI.
///
/// **Usage Example:**
/// ```dart
/// final stt = SttManager();
/// await stt.initialize();
///
/// stt.onResult = (text) async => print('Recognized: $text');
/// stt.onError = (error) => print('Error: $error');
///
/// await stt.startListening(localeId: 'en_US');
/// ```
///
/// Part of the [Fifty Design Language](https://github.com/fiftynotai/fifty_eco_system) ecosystem.
class SttManager {
  final SpeechToText _speech = SpeechToText();

  /// Internal queue to hold overlapping recognition results
  final List<SpeechRecognitionResult> _queue = [];

  /// Whether a result is currently being processed
  bool isProcessing = false;

  /// Whether the STT engine is currently listening
  bool _isListening = false;

  /// Whether the device supports speech recognition
  bool _isAvailable = false;

  /// Whether to emit partial results
  bool partialResults = false;

  /// Optional callback that receives recognized text
  Future<void> Function(String text)? onResult;

  /// Optional callback for errors
  void Function(String error)? onError;

  /// Initializes the STT engine
  ///
  /// Returns true if speech recognition is available on the device.
  Future<bool> initialize() async {
    _isAvailable = await _speech.initialize(
      onError: (error) => onError?.call(error.errorMsg),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
    );
    return _isAvailable;
  }

  /// Starts listening and streams recognized text
  ///
  /// - [localeId]: Language locale (e.g. 'en_US')
  /// - [partialResults]: Whether to emit partial results
  /// - [listenContinuously]: Use dictation mode for longer input
  Future<void> startListening({
    String localeId = 'en_US',
    bool partialResults = true,
    bool listenContinuously = true,
  }) async {
    this.partialResults = partialResults;

    if (!_isAvailable || _isListening) return;

    _isListening = true;

    final options = SpeechListenOptions(
      listenMode:
          listenContinuously ? ListenMode.dictation : ListenMode.confirmation,
      partialResults: partialResults,
    );

    await _speech.listen(
      onResult: _handleSttResult,
      listenOptions: options,
      localeId: localeId,
    );
  }

  /// Internal handler for STT results with queue support and throttling
  Future<void> _handleSttResult(SpeechRecognitionResult result) async {
    if (isProcessing) {
      _queue.add(result);
      return;
    }

    isProcessing = true;

    try {
      if (result.finalResult || partialResults) {
        await onResult?.call(result.recognizedWords);
      }
    } catch (e) {
      onError?.call('Failed to process STT result: $e');
    }

    isProcessing = false;

    if (_queue.isNotEmpty) {
      final next = _queue.removeAt(0);
      await _handleSttResult(next);
    }
  }

  /// Stops listening and finalizes result
  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    flushQueue(); // clear pending results
    await _speech.stop();
  }

  /// Cancels listening and discards results
  Future<void> cancelListening() async {
    if (!_isListening) return;
    _isListening = false;
    flushQueue(); // clear pending results
    await _speech.cancel();
  }

  /// Returns whether speech recognition is active
  bool get isListening => _isListening;

  /// Returns whether the engine is initialized and available
  bool get isAvailable => _isAvailable;

  /// Clears any queued results manually
  void flushQueue() => _queue.clear();

  /// Disposes resources and cancels listening
  void dispose() {
    cancelListening();
  }
}
