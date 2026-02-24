import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

/// Test subclass that exposes protected subscription guard methods.
class TestSocketService extends SocketService {
  TestSocketService() : super(
    reconnectConfig: const ReconnectConfig(enabled: false),
    logLevel: LogLevel.none,
  );

  @override
  String getWebSocketUrl() => 'wss://test.example.com/socket';

  /// Expose protected method for testing.
  bool testShouldAllowSubscription() => shouldAllowSubscription();

  /// Expose protected method for testing.
  void testMarkSubscriptionComplete() => markSubscriptionComplete();
}

void main() {
  group('Subscription Guard', () {
    late TestSocketService service;

    setUp(() {
      service = TestSocketService();
    });

    tearDown(() {
      service.dispose();
    });

    test('initially allows subscription', () {
      expect(service.testShouldAllowSubscription(), isTrue);
    });

    test('blocks subscription after markSubscriptionComplete', () {
      service.testMarkSubscriptionComplete();
      expect(service.testShouldAllowSubscription(), isFalse);
    });

    test('calling markSubscriptionComplete multiple times keeps blocked', () {
      service.testMarkSubscriptionComplete();
      service.testMarkSubscriptionComplete();
      expect(service.testShouldAllowSubscription(), isFalse);
    });
  });
}
