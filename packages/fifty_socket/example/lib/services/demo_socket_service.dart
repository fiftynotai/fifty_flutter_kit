import 'package:fifty_socket/fifty_socket.dart';

/// A demo [SocketService] subclass for the example app.
///
/// Uses shorter retry intervals and debug logging to demonstrate
/// the full socket lifecycle in a development environment.
///
/// The WebSocket URL points to the Fifty Socket Test Server running
/// on the VPS, implementing the Phoenix V2 JSON wire protocol.
class DemoSocketService extends SocketService {
  /// Creates a demo socket service with aggressive retry settings.
  DemoSocketService()
      : super(
          reconnectConfig: const ReconnectConfig(
            enabled: true,
            baseRetrySeconds: 3,
            maxRetries: 5,
            exponentialBackoff: true,
            maxBackoffSeconds: 30,
          ),
          heartbeatConfig: const HeartbeatConfig(
            pingIntervalSeconds: 15,
            timeoutSeconds: 30,
          ),
          logLevel: LogLevel.debug,
        );

  @override
  String getWebSocketUrl() => 'ws://76.13.180.77:4000/socket';
}
