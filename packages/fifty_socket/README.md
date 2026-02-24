# fifty_socket

Phoenix WebSocket infrastructure with auto-reconnect, heartbeat monitoring, and channel management. Part of the [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

## Features

- **Abstract base class** -- Extend `SocketService` for any Phoenix WebSocket use case
- **Auto-reconnect** -- Configurable retry strategy with exponential backoff
- **Heartbeat monitoring** -- Ping/pong watchdog detects silent disconnects
- **Channel management** -- Join, leave, and auto-restore channels on reconnect
- **Typed errors** -- Categorized error stream (`SocketErrorType`) for granular handling
- **Connection state** -- Observable state stream with reconnect attempt tracking
- **Subscription guards** -- Prevent duplicate channel joins per connection session
- **Configurable logging** -- Four log levels (none, error, info, debug)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_socket: ^0.1.0
```

## Quick Start

Extend `SocketService` and implement `getWebSocketUrl()`:

```dart
import 'package:fifty_socket/fifty_socket.dart';

class ChatSocketService extends SocketService {
  final String _token;

  ChatSocketService({required String token})
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

  void subscribeToChat(String roomId) {
    if (shouldAllowSubscription()) {
      joinChannel('chat:$roomId');
      markSubscriptionComplete();
    }
  }
}
```

### Connect and listen:

```dart
final socket = ChatSocketService(token: 'my-jwt-token');

// Listen for state changes
socket.stateStream.listen((state) {
  print('State: ${state.state}');
  if (state.reconnectAttempt != null) {
    print('Reconnect attempt: ${state.reconnectAttempt}');
  }
});

// Listen for errors
socket.errorStream.listen((error) {
  if (error.type == SocketErrorType.authentication) {
    // Refresh token and reconnect
  }
});

// Connect
await socket.connect();

// Join a channel
socket.subscribeToChat('room_123');

// Disconnect when done
socket.disconnect();
socket.dispose();
```

## Configuration

### ReconnectConfig

Controls automatic reconnection behavior:

```dart
const config = ReconnectConfig(
  enabled: true,             // Enable auto-reconnect (default: true)
  baseRetrySeconds: 5,       // Base delay between retries (default: 5)
  maxRetries: 10,            // Maximum retry attempts (default: 10)
  exponentialBackoff: true,  // Use exponential backoff (default: true)
  maxBackoffSeconds: 60,     // Maximum backoff delay (default: 60)
);

// Convenience constructors
const disabled = ReconnectConfig.disabled;
const defaults = ReconnectConfig.defaults;
```

### HeartbeatConfig

Controls ping/pong watchdog for silent disconnect detection:

```dart
const config = HeartbeatConfig(
  pingIntervalSeconds: 30,           // Phoenix ping interval (default: 30)
  timeoutSeconds: 60,                // Timeout threshold (default: 2x ping)
  watchdogCheckIntervalSeconds: 15,  // Watchdog check frequency (default: 15)
);
```

### LogLevel

Controls logging verbosity:

| Level | What gets logged |
|-------|-----------------|
| `LogLevel.none` | Nothing |
| `LogLevel.error` | Errors only |
| `LogLevel.info` | Errors + connect/disconnect events |
| `LogLevel.debug` | Everything including individual messages |

Change at runtime:

```dart
socketService.setLogLevel(LogLevel.debug);
```

## Error Handling

Errors are emitted to a dedicated `errorStream` with typed categorization:

```dart
socketService.errorStream.listen((error) {
  switch (error.type) {
    case SocketErrorType.connection:
      // Connection failed
      break;
    case SocketErrorType.authentication:
      // Token invalid/expired
      break;
    case SocketErrorType.channel:
      // Channel join/leave failed
      break;
    case SocketErrorType.message:
      // Message parsing failed
      break;
    case SocketErrorType.timeout:
      // Heartbeat timeout (silent disconnect)
      break;
    case SocketErrorType.unknown:
      // Uncategorized error
      break;
  }
});
```

## Reconnection Methods

Three methods for different reconnection scenarios:

| Method | Use Case | Resets Counter | Guards |
|--------|----------|---------------|--------|
| `reconnect()` | Internal auto-reconnect | No | Checks enabled + not already reconnecting |
| `forceReconnect()` | User taps "reconnect" button | Yes | None -- always attempts |
| `autoReconnectIfNeeded()` | Network restored, app resumed | Yes | Checks connected + not already reconnecting |

## Part of Fifty Flutter Kit

This package is part of the [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit) ecosystem.

## License

MIT License. See [LICENSE](LICENSE) for details.
