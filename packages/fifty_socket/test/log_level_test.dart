import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

void main() {
  group('LogLevel', () {
    test('has all expected values', () {
      expect(LogLevel.values, hasLength(4));
      expect(LogLevel.values, contains(LogLevel.none));
      expect(LogLevel.values, contains(LogLevel.error));
      expect(LogLevel.values, contains(LogLevel.info));
      expect(LogLevel.values, contains(LogLevel.debug));
    });

    test('index ordering: none < error < info < debug', () {
      expect(LogLevel.none.index, 0);
      expect(LogLevel.error.index, 1);
      expect(LogLevel.info.index, 2);
      expect(LogLevel.debug.index, 3);
    });

    test('none has lowest index', () {
      expect(LogLevel.none.index, lessThan(LogLevel.error.index));
      expect(LogLevel.none.index, lessThan(LogLevel.info.index));
      expect(LogLevel.none.index, lessThan(LogLevel.debug.index));
    });

    test('debug has highest index', () {
      expect(LogLevel.debug.index, greaterThan(LogLevel.none.index));
      expect(LogLevel.debug.index, greaterThan(LogLevel.error.index));
      expect(LogLevel.debug.index, greaterThan(LogLevel.info.index));
    });
  });
}
