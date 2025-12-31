import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_utils/fifty_utils.dart';

void main() {
  group('DurationExtensions', () {
    group('format', () {
      test('formats hours, minutes, and seconds', () {
        const duration = Duration(hours: 2, minutes: 5, seconds: 30);
        expect(duration.format(), equals('02:05:30'));
      });

      test('formats zero duration', () {
        const duration = Duration.zero;
        expect(duration.format(), equals('00:00:00'));
      });

      test('formats only minutes', () {
        const duration = Duration(minutes: 45);
        expect(duration.format(), equals('00:45:00'));
      });

      test('formats only seconds', () {
        const duration = Duration(seconds: 30);
        expect(duration.format(), equals('00:00:30'));
      });

      test('formats large hours', () {
        const duration = Duration(hours: 100, minutes: 30, seconds: 15);
        expect(duration.format(), equals('100:30:15'));
      });

      test('pads single digit values', () {
        const duration = Duration(hours: 1, minutes: 2, seconds: 3);
        expect(duration.format(), equals('01:02:03'));
      });
    });

    group('formatCompact', () {
      test('formats hours and minutes', () {
        const duration = Duration(hours: 2, minutes: 5);
        expect(duration.formatCompact(), equals('2h 5m'));
      });

      test('formats only hours', () {
        const duration = Duration(hours: 3);
        expect(duration.formatCompact(), equals('3h'));
      });

      test('formats only minutes', () {
        const duration = Duration(minutes: 45);
        expect(duration.formatCompact(), equals('45m'));
      });

      test('formats minutes and seconds when under an hour', () {
        const duration = Duration(minutes: 5, seconds: 30);
        expect(duration.formatCompact(), equals('5m 30s'));
      });

      test('formats only seconds when under a minute', () {
        const duration = Duration(seconds: 45);
        expect(duration.formatCompact(), equals('45s'));
      });

      test('returns 0s for zero duration', () {
        const duration = Duration.zero;
        expect(duration.formatCompact(), equals('0s'));
      });

      test('does not show seconds when hours present', () {
        const duration = Duration(hours: 1, minutes: 30, seconds: 45);
        expect(duration.formatCompact(), equals('1h 30m'));
      });
    });
  });
}
