/// **Duration Extensions**
///
/// Extension methods for Duration providing convenient formatting.
///
/// **Usage**:
/// ```dart
/// final duration = Duration(hours: 2, minutes: 5);
/// String formatted = duration.format(); // "02:05:00"
/// ```
extension DurationExtensions on Duration {
  /// Formats this duration into a human-readable string 'HH:mm:ss'.
  ///
  /// Example:
  /// ```dart
  /// String formatted = Duration(hours: 2, minutes: 5).format();
  /// print(formatted); // "02:05:00"
  /// ```
  String format() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(inHours);
    final minutes = twoDigits(inMinutes.remainder(60));
    final seconds = twoDigits(inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  /// Formats this duration into a compact string.
  ///
  /// Only shows relevant units (e.g., "2h 5m" instead of "02:05:00").
  ///
  /// Example:
  /// ```dart
  /// String compact = Duration(hours: 2, minutes: 5).formatCompact();
  /// print(compact); // "2h 5m"
  /// ```
  String formatCompact() {
    final parts = <String>[];

    if (inHours > 0) {
      parts.add('${inHours}h');
    }
    if (inMinutes.remainder(60) > 0) {
      parts.add('${inMinutes.remainder(60)}m');
    }
    if (inSeconds.remainder(60) > 0 && inHours == 0) {
      parts.add('${inSeconds.remainder(60)}s');
    }

    return parts.isEmpty ? '0s' : parts.join(' ');
  }
}
