## 0.1.0

- Initial release
- Abstract `SocketService` base class for Phoenix WebSocket connections
- `ReconnectConfig` -- configurable auto-reconnect with exponential backoff
- `HeartbeatConfig` -- ping/pong watchdog for silent disconnect detection
- Typed error handling (`SocketError`, `SocketErrorType`)
- Connection state tracking (`SocketConnectionState`, `SocketStateInfo`)
- Channel lifecycle management with auto-restoration on reconnect
- Subscription session guards to prevent duplicate channel joins
- Configurable logging via `LogLevel`
