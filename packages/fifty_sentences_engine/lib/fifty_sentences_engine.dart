/// Fifty Sentences Engine - A sentence processing engine for games and interactive applications.
///
/// This package provides a complete sentence processing system for Flutter applications,
/// enabling narration, player interaction, and navigation control in games and visual novels.
library;

export 'data/base_sentence.dart';
export 'data/sentence_queue.dart';
export 'engine/sentence_interpreter.dart';
export 'engine/sentence_writer.dart';
export 'engine/sentences_engine.dart';

import 'fifty_sentences_engine_platform_interface.dart';

/// Main entry point for FiftySentencesEngine plugin.
///
/// Provides platform version information.
class FiftySentencesEngine {
  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    return FiftySentencesEnginePlatform.instance.getPlatformVersion();
  }
}
