/// Socket Demo ViewModel
///
/// Business logic for the socket demo feature.
/// Uses a mock/demo mode to demonstrate WebSocket connection lifecycle
/// and channel management without requiring a live server.
library;

import 'dart:async';

import 'package:fifty_socket/fifty_socket.dart';
import 'package:get/get.dart';

/// Simulated message for the demo.
class DemoMessage {
  /// Creates a demo message.
  const DemoMessage({
    required this.topic,
    required this.event,
    required this.payload,
    required this.timestamp,
    required this.isOutgoing,
  });

  /// The channel topic.
  final String topic;

  /// The event name.
  final String event;

  /// The message payload.
  final String payload;

  /// When the message was sent/received.
  final DateTime timestamp;

  /// Whether this message was sent (true) or received (false).
  final bool isOutgoing;
}

/// ViewModel for the socket demo feature.
///
/// Simulates WebSocket connection lifecycle using mock state transitions.
/// Shows SocketConnectionState, channel management, and message flow
/// without requiring an actual Phoenix server.
class SocketDemoViewModel extends GetxController {
  // ---------------------------------------------------------------------------
  // Observable State
  // ---------------------------------------------------------------------------

  /// Current simulated connection state.
  final _connectionState = SocketConnectionState.disconnected.obs;
  SocketConnectionState get connectionState => _connectionState.value;

  /// List of joined channels.
  final _joinedChannels = <String>[].obs;
  List<String> get joinedChannels => _joinedChannels;

  /// Message log.
  final _messages = <DemoMessage>[].obs;
  List<DemoMessage> get messages => _messages;

  /// Whether a connection attempt is in progress.
  final _isConnecting = false.obs;
  bool get isConnecting => _isConnecting.value;

  /// Current reconnect attempt (for display).
  final _reconnectAttempt = 0.obs;
  int get reconnectAttempt => _reconnectAttempt.value;

  /// Demo socket configuration.
  static const demoConfig = (
    url: 'wss://demo.example.com/socket',
    reconnectBaseRetry: 5,
    reconnectMaxRetries: 10,
    heartbeatInterval: 30,
    heartbeatTimeout: 60,
    logLevel: 'info',
  );

  /// Available demo channels.
  static const List<String> availableChannels = [
    'notifications:user_123',
    'chat:lobby',
    'presence:global',
  ];

  Timer? _simulationTimer;

  @override
  void onClose() {
    _simulationTimer?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Connection Actions
  // ---------------------------------------------------------------------------

  /// Simulates connecting to a WebSocket server.
  Future<void> connect() async {
    if (_connectionState.value == SocketConnectionState.connected) return;

    _connectionState.value = SocketConnectionState.connecting;
    _isConnecting.value = true;
    _addSystemMessage('Connecting to ${demoConfig.url}...');
    update();

    // Simulate connection delay
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    _connectionState.value = SocketConnectionState.connected;
    _isConnecting.value = false;
    _reconnectAttempt.value = 0;
    _addSystemMessage('Connected successfully');
    update();
  }

  /// Simulates disconnecting from the WebSocket server.
  void disconnect() {
    _simulationTimer?.cancel();
    _connectionState.value = SocketConnectionState.disconnecting;
    _addSystemMessage('Disconnecting...');
    update();

    // Simulate brief disconnect delay
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      _connectionState.value = SocketConnectionState.disconnected;
      _joinedChannels.clear();
      _addSystemMessage('Disconnected');
      update();
    });
  }

  /// Simulates a reconnection sequence.
  Future<void> simulateReconnect() async {
    _simulationTimer?.cancel();
    _connectionState.value = SocketConnectionState.reconnecting;
    _reconnectAttempt.value = 1;
    _addSystemMessage('Connection lost. Reconnecting...');
    update();

    // Simulate 3 reconnect attempts
    for (var i = 1; i <= 3; i++) {
      _reconnectAttempt.value = i;
      _addSystemMessage('Reconnect attempt $i/10...');
      update();
      await Future<void>.delayed(const Duration(milliseconds: 1000));
    }

    _connectionState.value = SocketConnectionState.connected;
    _reconnectAttempt.value = 0;
    _addSystemMessage('Reconnected successfully');
    update();
  }

  // ---------------------------------------------------------------------------
  // Channel Actions
  // ---------------------------------------------------------------------------

  /// Simulates joining a channel.
  void joinChannel(String topic) {
    if (_joinedChannels.contains(topic)) return;
    if (_connectionState.value != SocketConnectionState.connected) return;

    _joinedChannels.add(topic);
    _addSystemMessage('Joined channel: $topic');
    update();

    // Simulate receiving a welcome message
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      _messages.add(DemoMessage(
        topic: topic,
        event: 'phx_reply',
        payload: '{"status": "ok", "response": {}}',
        timestamp: DateTime.now(),
        isOutgoing: false,
      ));
      update();
    });
  }

  /// Simulates leaving a channel.
  void leaveChannel(String topic) {
    _joinedChannels.remove(topic);
    _addSystemMessage('Left channel: $topic');
    update();
  }

  // ---------------------------------------------------------------------------
  // Message Actions
  // ---------------------------------------------------------------------------

  /// Simulates sending a message on a channel.
  void sendMessage(String topic, String event, String payload) {
    if (_connectionState.value != SocketConnectionState.connected) return;
    if (!_joinedChannels.contains(topic)) return;

    _messages.add(DemoMessage(
      topic: topic,
      event: event,
      payload: payload,
      timestamp: DateTime.now(),
      isOutgoing: true,
    ));
    update();

    // Simulate echo response
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      _messages.add(DemoMessage(
        topic: topic,
        event: 'echo_reply',
        payload: '{"echo": $payload}',
        timestamp: DateTime.now(),
        isOutgoing: false,
      ));
      update();
    });
  }

  /// Clears all messages.
  void clearMessages() {
    _messages.clear();
    update();
  }

  /// Resets demo to initial state.
  void resetDemo() {
    _simulationTimer?.cancel();
    _connectionState.value = SocketConnectionState.disconnected;
    _joinedChannels.clear();
    _messages.clear();
    _isConnecting.value = false;
    _reconnectAttempt.value = 0;
    update();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _addSystemMessage(String text) {
    _messages.add(DemoMessage(
      topic: 'system',
      event: 'info',
      payload: text,
      timestamp: DateTime.now(),
      isOutgoing: false,
    ));
  }

  /// Gets a display label for the current connection state.
  String get connectionStateLabel {
    switch (_connectionState.value) {
      case SocketConnectionState.disconnected:
        return 'DISCONNECTED';
      case SocketConnectionState.connecting:
        return 'CONNECTING';
      case SocketConnectionState.connected:
        return 'CONNECTED';
      case SocketConnectionState.reconnecting:
        return 'RECONNECTING';
      case SocketConnectionState.disconnecting:
        return 'DISCONNECTING';
    }
  }
}
