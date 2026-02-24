import 'dart:async';

import 'package:fifty_socket/fifty_socket.dart';
import 'package:get/get.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

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

/// A received channel message with metadata for display.
class ChannelMessage {
  /// Creates a channel message entry.
  ChannelMessage({
    required this.topic,
    required this.event,
    required this.payload,
  }) : timestamp = DateTime.now();

  /// The channel topic the message arrived on.
  final String topic;

  /// The event name.
  final String event;

  /// The message payload.
  final Map<String, dynamic> payload;

  /// When the message was received.
  final DateTime timestamp;
}

/// **SocketController**
///
/// GetxController that wraps [DemoSocketService] with reactive state.
///
/// Provides observable properties for connection state, errors, event
/// log entries, channel management, and message exchange. Listens to
/// both the state stream and error stream and exposes simple methods
/// for the UI to call.
///
/// **Key Features:**
/// - Connection lifecycle management (connect, disconnect, reconnect)
/// - Channel join/leave with topic tracking
/// - Message sending and receiving with history
/// - Event log for debugging
class SocketController extends GetxController {
  /// The underlying socket service instance.
  final DemoSocketService _service = DemoSocketService();

  // ---------------------------------------------------------------------------
  // Reactive observables - Connection
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
  // Reactive observables - Channel management
  // ---------------------------------------------------------------------------

  /// List of currently joined channel topics.
  final joinedChannels = <String>[].obs;

  /// Reverse-chronological list of received channel messages (newest first).
  final messages = <ChannelMessage>[].obs;

  /// Current channel topic input value.
  final channelTopic = 'test:lobby'.obs;

  /// Current message input value.
  final messageInput = ''.obs;

  // ---------------------------------------------------------------------------
  // Internal state
  // ---------------------------------------------------------------------------

  /// Map of topic to [PhoenixChannel] instances for active management.
  final Map<String, PhoenixChannel> _channelRefs = {};

  /// Map of topic to channel message stream subscriptions.
  final Map<String, StreamSubscription<Message>> _channelSubs = {};

  // ---------------------------------------------------------------------------
  // Stream subscriptions
  // ---------------------------------------------------------------------------

  StreamSubscription<SocketStateInfo>? _stateSub;
  StreamSubscription<SocketError>? _errorSub;

  /// Maximum number of event log entries to retain.
  static const int _maxLogEntries = 50;

  /// Maximum number of channel messages to retain.
  static const int _maxMessages = 100;

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
    for (final sub in _channelSubs.values) {
      sub.cancel();
    }
    _channelSubs.clear();
    _service.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  /// The current reconnect configuration from the service.
  ReconnectConfig get reconnectConfig => _service.reconnectConfig;

  // ---------------------------------------------------------------------------
  // Connection actions
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
    _clearChannelState();
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
  // Channel actions
  // ---------------------------------------------------------------------------

  /// **joinChannel**
  ///
  /// Joins a Phoenix channel by topic string.
  ///
  /// Subscribes to the channel's message stream and adds received messages
  /// to the [messages] observable list for UI display.
  ///
  /// **Parameters:**
  /// - [topic]: The channel topic to join (e.g. "test:lobby", "echo:ping").
  void joinChannel(String topic) {
    if (topic.isEmpty) return;
    if (_channelRefs.containsKey(topic)) {
      _addLogEntry('Already joined: $topic');
      return;
    }
    if (!isConnected.value) {
      _addLogEntry('Cannot join channel: not connected');
      return;
    }

    try {
      final channel = _service.joinChannel(topic);
      _channelRefs[topic] = channel;
      joinedChannels.add(topic);
      _addLogEntry('Joined channel: $topic');

      // Subscribe to channel messages (filter out internal Phoenix events).
      final sub = _service.messageStream
          .where((msg) =>
              msg.topic == topic &&
              msg.event.value != 'phx_reply' &&
              msg.event.value != 'phx_close' &&
              msg.event.value != 'phx_error')
          .listen((msg) {
        final payload = msg.payload ?? {};
        _addMessage(ChannelMessage(
          topic: msg.topic ?? topic,
          event: msg.event.value,
          payload: Map<String, dynamic>.from(payload),
        ));
      });
      _channelSubs[topic] = sub;
    } catch (e) {
      _addLogEntry('Failed to join channel $topic: $e');
    }
  }

  /// **leaveChannel**
  ///
  /// Leaves a previously joined Phoenix channel.
  ///
  /// Cancels the message stream subscription and removes the channel
  /// from the joined channels list.
  ///
  /// **Parameters:**
  /// - [topic]: The channel topic to leave.
  void leaveChannel(String topic) {
    final channel = _channelRefs[topic];
    if (channel == null) {
      _addLogEntry('Not in channel: $topic');
      return;
    }

    _channelSubs[topic]?.cancel();
    _channelSubs.remove(topic);
    _service.leaveChannel(channel);
    _channelRefs.remove(topic);
    joinedChannels.remove(topic);
    _addLogEntry('Left channel: $topic');
  }

  /// **sendMessage**
  ///
  /// Pushes a message to a joined Phoenix channel.
  ///
  /// **Parameters:**
  /// - [topic]: The channel topic to send on.
  /// - [event]: The event name.
  /// - [payload]: The message payload map.
  void sendMessage(String topic, String event, Map<String, dynamic> payload) {
    final channel = _channelRefs[topic];
    if (channel == null) {
      _addLogEntry('Cannot send: not in channel $topic');
      return;
    }

    try {
      channel.push(event, payload);
      _addLogEntry('Sent [$event] on $topic');
    } catch (e) {
      _addLogEntry('Failed to send message: $e');
    }
  }

  /// Clears the received messages list.
  void clearMessages() {
    messages.clear();
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

    // Clear channel tracking on disconnect (channels are invalidated).
    if (info.state == SocketConnectionState.disconnected) {
      _clearChannelState();
    }
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

  void _addMessage(ChannelMessage message) {
    messages.insert(0, message);
    if (messages.length > _maxMessages) {
      messages.removeRange(_maxMessages, messages.length);
    }
  }

  /// Clears all channel-related state (refs, subscriptions, observable list).
  void _clearChannelState() {
    for (final sub in _channelSubs.values) {
      sub.cancel();
    }
    _channelSubs.clear();
    _channelRefs.clear();
    joinedChannels.clear();
  }
}
