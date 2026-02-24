/// **SocketConnectionState**
///
/// Represents the current state of the WebSocket connection.
///
// ────────────────────────────────────────────────
enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  disconnecting,
}

/// **SocketStateInfo**
///
/// Contains detailed information about the current socket state.
///
/// **Key Features:**
/// - Current connection state
/// - Reconnection attempt tracking
/// - Timestamp for state change tracking
///
/// **Usage Example:**
/// ```dart
/// socketService.stateStream.listen((state) {
///   if (state.state == SocketConnectionState.reconnecting) {
///     print('Reconnecting... Attempt ${state.reconnectAttempt}');
///   }
/// });
/// ```
///
// ────────────────────────────────────────────────
class SocketStateInfo {
  final SocketConnectionState state;
  final DateTime timestamp;
  final int? reconnectAttempt;

  SocketStateInfo({
    required this.state,
    DateTime? timestamp,
    this.reconnectAttempt,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '$state${reconnectAttempt != null ? ' (attempt $reconnectAttempt)' : ''}';
}
