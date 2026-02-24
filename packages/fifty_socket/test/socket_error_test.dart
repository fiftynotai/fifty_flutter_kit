import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

void main() {
  group('SocketErrorType', () {
    test('has all expected values', () {
      expect(SocketErrorType.values, hasLength(6));
      expect(SocketErrorType.values, contains(SocketErrorType.connection));
      expect(SocketErrorType.values, contains(SocketErrorType.authentication));
      expect(SocketErrorType.values, contains(SocketErrorType.channel));
      expect(SocketErrorType.values, contains(SocketErrorType.message));
      expect(SocketErrorType.values, contains(SocketErrorType.timeout));
      expect(SocketErrorType.values, contains(SocketErrorType.unknown));
    });
  });

  group('SocketError', () {
    test('construction with required fields', () {
      final error = SocketError(
        type: SocketErrorType.connection,
        message: 'Connection failed',
      );
      expect(error.type, SocketErrorType.connection);
      expect(error.message, 'Connection failed');
      expect(error.originalError, isNull);
      expect(error.timestamp, isA<DateTime>());
    });

    test('construction with all fields', () {
      final now = DateTime(2025, 1, 1);
      final original = Exception('root cause');
      final error = SocketError(
        type: SocketErrorType.authentication,
        message: 'Token expired',
        originalError: original,
        timestamp: now,
      );
      expect(error.type, SocketErrorType.authentication);
      expect(error.message, 'Token expired');
      expect(error.originalError, original);
      expect(error.timestamp, now);
    });

    test('auto-generates timestamp when not provided', () {
      final before = DateTime.now();
      final error = SocketError(
        type: SocketErrorType.unknown,
        message: 'test',
      );
      final after = DateTime.now();

      expect(error.timestamp.isAfter(before) || error.timestamp.isAtSameMomentAs(before), isTrue);
      expect(error.timestamp.isBefore(after) || error.timestamp.isAtSameMomentAs(after), isTrue);
    });

    test('toString includes type, message, and timestamp', () {
      final timestamp = DateTime(2025, 6, 15, 10, 30, 0);
      final error = SocketError(
        type: SocketErrorType.timeout,
        message: 'Operation timed out',
        timestamp: timestamp,
      );
      final str = error.toString();
      expect(str, contains('SocketErrorType.timeout'));
      expect(str, contains('Operation timed out'));
      expect(str, contains(timestamp.toIso8601String()));
    });
  });
}
