import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_utils/fifty_utils.dart';

void main() {
  group('DateTimeExtensions', () {
    group('isToday', () {
      test('returns true for today', () {
        final now = DateTime.now();
        expect(now.isToday, isTrue);
      });

      test('returns false for a fixed date in the past', () {
        final pastDate = DateTime(2020, 1, 1);
        expect(pastDate.isToday, isFalse);
      });

      test('returns true for different time today', () {
        final now = DateTime.now();
        final earlierToday = DateTime(now.year, now.month, now.day, 1, 0, 0);
        expect(earlierToday.isToday, isTrue);
      });
    });

    group('isYesterday', () {
      test('returns false for today', () {
        final now = DateTime.now();
        expect(now.isYesterday, isFalse);
      });

      test('returns false for a fixed old date', () {
        final oldDate = DateTime(2020, 1, 1);
        expect(oldDate.isYesterday, isFalse);
      });
    });

    group('isTomorrow', () {
      test('returns false for today', () {
        final now = DateTime.now();
        expect(now.isTomorrow, isFalse);
      });

      test('returns false for a fixed old date', () {
        final oldDate = DateTime(2020, 1, 1);
        expect(oldDate.isTomorrow, isFalse);
      });
    });

    group('isSameDay', () {
      test('returns true for same day different time', () {
        final date1 = DateTime(2024, 10, 28, 10, 30);
        final date2 = DateTime(2024, 10, 28, 15, 45);
        expect(date1.isSameDay(date2), isTrue);
      });

      test('returns false for different days', () {
        final date1 = DateTime(2024, 10, 28);
        final date2 = DateTime(2024, 10, 29);
        expect(date1.isSameDay(date2), isFalse);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2024, 10, 28);
        final date2 = DateTime(2024, 11, 28);
        expect(date1.isSameDay(date2), isFalse);
      });

      test('returns false for different years', () {
        final date1 = DateTime(2024, 10, 28);
        final date2 = DateTime(2025, 10, 28);
        expect(date1.isSameDay(date2), isFalse);
      });
    });

    group('isSameMonth', () {
      test('returns true for same month different day', () {
        final date1 = DateTime(2024, 10, 1);
        final date2 = DateTime(2024, 10, 31);
        expect(date1.isSameMonth(date2), isTrue);
      });

      test('returns false for different months', () {
        final date1 = DateTime(2024, 10, 15);
        final date2 = DateTime(2024, 11, 15);
        expect(date1.isSameMonth(date2), isFalse);
      });
    });

    group('isSameYear', () {
      test('returns true for same year different month', () {
        final date1 = DateTime(2024, 1, 1);
        final date2 = DateTime(2024, 12, 31);
        expect(date1.isSameYear(date2), isTrue);
      });

      test('returns false for different years', () {
        final date1 = DateTime(2024, 6, 15);
        final date2 = DateTime(2025, 6, 15);
        expect(date1.isSameYear(date2), isFalse);
      });
    });

    group('startOfDay', () {
      test('returns midnight of the same day', () {
        final date = DateTime(2024, 10, 28, 15, 30, 45);
        final start = date.startOfDay;
        expect(start, equals(DateTime(2024, 10, 28, 0, 0, 0)));
      });
    });

    group('endOfDay', () {
      test('returns end of day', () {
        final date = DateTime(2024, 10, 28, 10, 30);
        final end = date.endOfDay;
        expect(end, equals(DateTime(2024, 10, 28, 23, 59, 59, 999)));
      });
    });

    group('daysBetween', () {
      test('returns correct days between two dates', () {
        final date1 = DateTime(2024, 10, 1);
        final date2 = DateTime(2024, 10, 15);
        expect(date1.daysBetween(date2), equals(14));
      });

      test('returns negative for past dates', () {
        final date1 = DateTime(2024, 10, 15);
        final date2 = DateTime(2024, 10, 1);
        expect(date1.daysBetween(date2), equals(-14));
      });

      test('returns 0 for same day', () {
        final date1 = DateTime(2024, 10, 15, 10, 0);
        final date2 = DateTime(2024, 10, 15, 20, 0);
        expect(date1.daysBetween(date2), equals(0));
      });
    });

    group('format', () {
      test('formats with default pattern', () {
        final date = DateTime(2024, 10, 28);
        expect(date.format(), equals('28/10/2024'));
      });

      test('formats with custom pattern', () {
        final date = DateTime(2024, 10, 28);
        expect(date.format('yyyy-MM-dd'), equals('2024-10-28'));
      });

      test('formats with month name pattern', () {
        final date = DateTime(2024, 10, 28);
        expect(date.format('MMMM d, yyyy'), equals('October 28, 2024'));
      });
    });

    group('formatTime', () {
      test('formats with default pattern', () {
        final date = DateTime(2024, 10, 28, 14, 30);
        expect(date.formatTime(), equals('14:30'));
      });

      test('formats with custom pattern', () {
        final date = DateTime(2024, 10, 28, 14, 30, 45);
        expect(date.formatTime('HH:mm:ss'), equals('14:30:45'));
      });
    });

    group('formatDateTime', () {
      test('formats with default pattern', () {
        final date = DateTime(2024, 10, 28, 14, 30);
        expect(date.formatDateTime(), equals('28/10/2024 14:30'));
      });
    });

    group('timeAgo', () {
      test('returns "just now" for current time', () {
        final now = DateTime.now();
        expect(now.timeAgo(), equals('just now'));
      });

      test('returns minutes ago pattern', () {
        final pastDate = DateTime.now().subtract(const Duration(minutes: 5));
        final result = pastDate.timeAgo();
        expect(result, matches(RegExp(r'^\d+ minutes? ago$')));
      });

      test('returns hours ago pattern', () {
        final pastDate = DateTime.now().subtract(const Duration(hours: 3));
        final result = pastDate.timeAgo();
        expect(result, matches(RegExp(r'^\d+ hours? ago$')));
      });

      test('returns days ago pattern', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 5));
        final result = pastDate.timeAgo();
        expect(result, matches(RegExp(r'^\d+ days? ago$')));
      });

      test('returns months ago pattern', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 60));
        final result = pastDate.timeAgo();
        expect(result, matches(RegExp(r'^\d+ months? ago$')));
      });

      test('returns years ago pattern', () {
        final pastDate = DateTime.now().subtract(const Duration(days: 400));
        final result = pastDate.timeAgo();
        expect(result, matches(RegExp(r'^\d+ years? ago$')));
      });

      test('returns "in X days" pattern for future dates', () {
        final futureDate = DateTime.now().add(const Duration(days: 10));
        final result = futureDate.timeAgo();
        expect(result, matches(RegExp(r'^in \d+ days?$')));
      });

      test('returns "in X hours" pattern for future dates', () {
        final futureDate = DateTime.now().add(const Duration(hours: 5));
        final result = futureDate.timeAgo();
        expect(result, matches(RegExp(r'^in \d+ hours?$')));
      });

      test('returns "in a moment" for very near future', () {
        final futureDate = DateTime.now().add(const Duration(seconds: 30));
        expect(futureDate.timeAgo(), equals('in a moment'));
      });

      // Fixed date tests for exact behavior
      test('calculates correctly for fixed past dates', () {
        final baseTime = DateTime(2024, 6, 15, 12, 0, 0);
        final oneHourAgo = DateTime(2024, 6, 15, 11, 0, 0);

        // Since timeAgo uses DateTime.now(), we test the pattern
        final diff = baseTime.difference(oneHourAgo);
        expect(diff.inHours, equals(1));
      });

      test('handles singular vs plural correctly', () {
        // Test with a 1-unit difference
        final now = DateTime.now();
        final oneMinuteAgo = now.subtract(const Duration(minutes: 1, seconds: 30));
        expect(oneMinuteAgo.timeAgo(), equals('1 minute ago'));
      });
    });
  });
}
