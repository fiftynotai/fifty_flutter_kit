import 'dart:async';

import 'package:fifty_socket/fifty_socket.dart';
import 'package:get/get.dart';

import '../services/demo_socket_service.dart';

/// A timestamped log entry for the event log.
class EventLogEntry {
  /// Creates a log entry with the given [message] and current time.
  EventLogEntry(this.message) : timestamp = DateTime.now();

  /// The log message.
  final String message;

  /// When the event occurred.
  final DateTime timestamp;
}

/// GetxController that wraps [DemoSocketService] with reactive state.
///
/// Provides observable properties for connection state, errors, and
/// event log entries. Listens to both the state stream and error stream
/// and exposes simple methods for the UI to call.
class SocketController extends GetxController {
  /// The underlying socket service instance.
  final DemoSocketService _service = DemoSocketService();

  // ---------------------------------------------------------------------------
  // Reactive observables
  // ---------------------------------------------------------------------------

  /// Current connection state.
  final connectionState = SocketConnectionState.disconnected.obs;

  /// Whether the socket is currently connected.
  final isConnected = false.obs;

  /// Whether the socket is in a reconnecting state.
  final isReconnecting = false.obs;

  /// Current reconnect attempt number (0 when not reconnecting).
  final reconnectAttempt = 0.obs;

  /// List of errors received from the error stream.
  final errors = <SocketError>[].obs;

  /// Reverse-chronological event log entries (newest first).
  final eventLog = <EventLogEntry>[].obs;

  /// Whether auto-reconnect is currently enabled.
  final autoReconnectEnabled = true.obs;

  /// Current log level.
  final currentLogLevel = LogLevel.debug.obs;

  // ---------------------------------------------------------------------------
  // Stream subscriptions
  // ---------------------------------------------------------------------------

  StreamSubscription<SocketStateInfo>? _stateSub;
  StreamSubscription<SocketError>? _errorSub;

  /// Maximum number of event log entries to retain.
  static const int _maxLogEntries = 50;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _stateSub = _service.stateStream.listen(_onStateChange);
    _errorSub = _service.errorStream.listen(_onError);
    _addLogEntry('Controller initialized');
  }

  @override
  void onClose() {
    _stateSub?.cancel();
    _errorSub?.cancel();
    _service.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  /// The current reconnect configuration from the service.
  ReconnectConfig get reconnectConfig => _service.reconnectConfig;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Initiates a WebSocket connection.
  Future<void> connect() async {
    _addLogEntry('Connecting...');
    try {
      await _service.connect();
    } catch (_) {
      // Error is handled via errorStream listener.
    }
  }

  /// Disconnects the WebSocket.
  void disconnect() {
    _addLogEntry('Disconnecting...');
    _service.disconnect();
  }

  /// Forces a fresh reconnection attempt, resetting the retry counter.
  void forceReconnect() {
    _addLogEntry('Force reconnect requested');
    _service.forceReconnect();
  }

  /// Toggles auto-reconnect on or off.
  void toggleAutoReconnect() {
    if (autoReconnectEnabled.value) {
      _service.disableAutoReconnect();
      autoReconnectEnabled.value = false;
      _addLogEntry('Auto-reconnect disabled');
    } else {
      _service.enableAutoReconnect();
      autoReconnectEnabled.value = true;
      _addLogEntry('Auto-reconnect enabled');
    }
  }

  /// Sets the logging verbosity level.
  void setLogLevel(LogLevel level) {
    _service.setLogLevel(level);
    currentLogLevel.value = level;
    _addLogEntry('Log level set to ${level.name}');
  }

  /// Clears the event log.
  void clearLog() {
    eventLog.clear();
  }

  /// Clears the error list.
  void clearErrors() {
    errors.clear();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _onStateChange(SocketStateInfo info) {
    connectionState.value = info.state;
    isConnected.value = info.state == SocketConnectionState.connected;
    isReconnecting.value = info.state == SocketConnectionState.reconnecting;
    reconnectAttempt.value = info.reconnectAttempt ?? 0;

    final attemptSuffix = info.reconnectAttempt != null
        ? ' (attempt ${info.reconnectAttempt})'
        : '';
    _addLogEntry('State -> ${info.state.name}$attemptSuffix');
  }

  void _onError(SocketError error) {
    errors.insert(0, error);
    _addLogEntry('ERROR [${error.type.name}]: ${error.message}');
  }

  void _addLogEntry(String message) {
    eventLog.insert(0, EventLogEntry(message));
    if (eventLog.length > _maxLogEntries) {
      eventLog.removeRange(_maxLogEntries, eventLog.length);
    }
  }
}
