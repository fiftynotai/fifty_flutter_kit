import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

void main() {
  group('SocketConnectionState', () {
    test('has all expected values', () {
      expect(SocketConnectionState.values, hasLength(5));
      expect(SocketConnectionState.values, contains(SocketConnectionState.disconnected));
      expect(SocketConnectionState.values, contains(SocketConnectionState.connecting));
      expect(SocketConnectionState.values, contains(SocketConnectionState.connected));
      expect(SocketConnectionState.values, contains(SocketConnectionState.reconnecting));
      expect(SocketConnectionState.values, contains(SocketConnectionState.disconnecting));
    });
  });

  group('SocketStateInfo', () {
    test('construction with required fields', () {
      final info = SocketStateInfo(state: SocketConnectionState.connected);
      expect(info.state, SocketConnectionState.connected);
      expect(info.timestamp, isA<DateTime>());
      expect(info.reconnectAttempt, isNull);
    });

    test('construction with all fields', () {
      final now = DateTime(2025, 1, 1);
      final info = SocketStateInfo(
        state: SocketConnectionState.reconnecting,
        timestamp: now,
        reconnectAttempt: 3,
      );
      expect(info.state, SocketConnectionState.reconnecting);
      expect(info.timestamp, now);
      expect(info.reconnectAttempt, 3);
    });

    test('auto-generates timestamp when not provided', () {
      final before = DateTime.now();
      final info = SocketStateInfo(state: SocketConnectionState.disconnected);
      final after = DateTime.now();

      expect(info.timestamp.isAfter(before) || info.timestamp.isAtSameMomentAs(before), isTrue);
      expect(info.timestamp.isBefore(after) || info.timestamp.isAtSameMomentAs(after), isTrue);
    });

    test('toString without reconnectAttempt shows state only', () {
      final info = SocketStateInfo(state: SocketConnectionState.connected);
      expect(info.toString(), 'SocketConnectionState.connected');
    });

    test('toString with reconnectAttempt includes attempt number', () {
      final info = SocketStateInfo(
        state: SocketConnectionState.reconnecting,
        reconnectAttempt: 5,
      );
      expect(info.toString(), 'SocketConnectionState.reconnecting (attempt 5)');
    });
  });
}
