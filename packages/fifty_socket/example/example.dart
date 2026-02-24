import 'package:fifty_socket/fifty_socket.dart';

/// Example: Extend SocketService for a notification system.
class NotificationSocketService extends SocketService {
  final String _token;

  NotificationSocketService({required String token})
      : _token = token,
        super(
          reconnectConfig: const ReconnectConfig(
            enabled: true,
            baseRetrySeconds: 5,
            maxRetries: 10,
            exponentialBackoff: true,
          ),
          heartbeatConfig: const HeartbeatConfig(
            pingIntervalSeconds: 30,
          ),
          logLevel: LogLevel.info,
        );

  @override
  String getWebSocketUrl() {
    return 'wss://api.example.com/socket?jwt=$_token';
  }

  /// Subscribe to user notifications channel.
  void subscribeToNotifications(String userId) {
    // Guard against duplicate subscriptions per connection session
    if (shouldAllowSubscription()) {
      joinChannel('notifications:$userId');
      markSubscriptionComplete();
    }
  }
}

void main() async {
  final socket = NotificationSocketService(token: 'my-jwt-token');

  // Monitor connection state
  socket.stateStream.listen((state) {
    print('Connection state: ${state.state}');
  });

  // Monitor errors
  socket.errorStream.listen((error) {
    print('Error [${error.type}]: ${error.message}');
  });

  // Connect and subscribe
  await socket.connect();
  socket.subscribeToNotifications('user_123');

  // Listen for messages
  socket.messageStream
      .where((msg) => msg.event.value == 'new_notification')
      .listen((msg) {
    print('New notification: ${msg.payload}');
  });
}
