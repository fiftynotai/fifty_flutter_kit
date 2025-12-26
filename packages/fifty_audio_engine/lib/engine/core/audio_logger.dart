import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

/// **Audio Logger**
///
/// Utility class for logging audio-related actions and transitions
/// (for debugging and development purposes only).
///
/// Can be toggled on/off globally using [AudioLogger.enabled].
///
/// ─────────────────────────────────────────────────────────────────────────────
class FiftyAudioLogger {
  static bool enabled = kDebugMode;

  static void log(String message) {
    if (!enabled) return;
    final now = DateTime.now().toIso8601String().substring(11, 23);
    dev.log('🎧 [$now] $message');
  }

  static void play(String pathOrType) => log('▶️  play → $pathOrType');
  static void stop() => log('⏹️  stop');
  static void pause() => log('⏸️  pause');
  static void resume() => log('▶️  resume');
  static void volume(double value) => log('🔊 volume → $value');
  static void mute() => log('🔇 muted');
  static void unmute() => log('🔈 unmuted');
  static void activate() => log('🔇 activated');
  static void deactivate() => log('🔈 deactivated');
  static void fade(double from, double to, Duration duration, Curve curve) =>
      log('🌗 fade from $from to $to over ${duration.inMilliseconds}ms using ${curve.runtimeType}');
}
