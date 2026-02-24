import 'dart:async';
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

import 'heartbeat_config.dart';
import 'log_level.dart';
import 'reconnect_config.dart';
import 'socket_error.dart';
import 'socket_state.dart';

/// **SocketService**
///
/// Generic base class for WebSocket management providing connection lifecycle,
/// channel management, error handling, and automatic reconnection.
///
/// **Why**
/// - Eliminate code duplication between domain-specific socket services
/// - Provide production-ready WebSocket infrastructure
/// - No domain assumptions - works for any Phoenix WebSocket use case
///
/// **Key Features:**
/// - Connection management (connect, disconnect, reconnect)
/// - Configurable auto-reconnect with exponential backoff
/// - Channel lifecycle management with auto-restoration
/// - Separate error and state streams for granular monitoring
/// - Configurable logging levels
/// - Runtime configuration changes (enable/disable reconnect)
///
/// **Usage Example:**
/// ```dart
/// class NotificationSocketService extends SocketService {
///   NotificationSocketService() : super(
///     reconnectConfig: const ReconnectConfig(enabled: true),
///     logLevel: LogLevel.info,
///   );
///
///   @override
///   String getWebSocketUrl() {
///     final token = getAuthToken(); // Your auth logic
///     return 'wss://api.example.com/socket?jwt=$token';
///   }
///
///   void subscribeToNotifications() {
///     joinChannel('notifications:user_123');
///
///     messageStream
///       .where((msg) => msg.event.value == 'new_notification')
///       .listen((msg) => handleNotification(msg));
///   }
/// }
/// ```
///
/// **Subclass Responsibilities:**
/// - Implement `getWebSocketUrl()` to provide connection URL
/// - Handle domain-specific message routing
/// - Manage domain-specific channels
///
// ────────────────────────────────────────────────
abstract class SocketService {
  PhoenixSocket? _socket;
  final List<PhoenixChannel> _channels = [];
  final Map<String, PhoenixChannel> _channelsByTopic = {}; // For restoration

  // State management
  final _stateController = StreamController<SocketStateInfo>.broadcast();
  final _errorController = StreamController<SocketError>.broadcast();
  SocketConnectionState _currentState = SocketConnectionState.disconnected;

  // Reconnection
  ReconnectConfig _reconnectConfig;
  bool _isReconnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  // Heartbeat monitoring (ping/pong timeout detection)
  final HeartbeatConfig _heartbeatConfig;
  DateTime? _lastPingReceived;
  Timer? _pingWatchdogTimer;

  // Subscription session tracking (prevents duplicate subscriptions per connection)
  bool _hasSubscribedForCurrentConnection = false;

  // Logging
  LogLevel _logLevel;

  /// **Constructor**
  ///
  /// Creates a new SocketService with optional configuration.
  ///
  /// **Parameters:**
  /// - `reconnectConfig`: Reconnection strategy configuration
  /// - `heartbeatConfig`: Heartbeat monitoring configuration
  /// - `logLevel`: Logging verbosity level
  ///
  // ────────────────────────────────────────────────
  SocketService({
    ReconnectConfig reconnectConfig = const ReconnectConfig(),
    HeartbeatConfig heartbeatConfig = const HeartbeatConfig(),
    LogLevel logLevel = LogLevel.info,
  })  : _reconnectConfig = reconnectConfig,
        _heartbeatConfig = heartbeatConfig,
        _logLevel = logLevel;

  /// **Public Streams**
  // ────────────────────────────────────────────────

  /// Stream of connection state changes
  Stream<SocketStateInfo> get stateStream => _stateController.stream;

  /// Stream of errors (separate from state for granular handling)
  Stream<SocketError> get errorStream => _errorController.stream;

  /// Stream of raw WebSocket messages (subclasses filter and route)
  Stream<Message> get messageStream => _socket!.messageStream;

  /// **Public Getters**
  // ────────────────────────────────────────────────

  /// Current connection state
  SocketConnectionState get currentState => _currentState;

  /// Whether socket is currently connected
  bool get isConnected => _currentState == SocketConnectionState.connected;

  /// Whether socket is currently reconnecting
  bool get isReconnecting => _currentState == SocketConnectionState.reconnecting;

  /// Immutable list of active channels
  List<PhoenixChannel> get activeChannels => List.unmodifiable(_channels);

  /// Current reconnection configuration
  ReconnectConfig get reconnectConfig => _reconnectConfig;

  /// **Protected Methods for Subscription Session Management**
  // ────────────────────────────────────────────────

  /// **shouldAllowSubscription**
  ///
  /// Checks if subscriptions should be allowed for the current connection session.
  /// Prevents duplicate subscriptions when Phoenix socket emits multiple `connected` events.
  ///
  /// **Returns:**
  /// - `bool`: true if subscriptions haven't been initialized yet for this connection
  ///
  /// **Usage Example (in subclass):**
  /// ```dart
  /// void _initializeAutoSubscription() {
  ///   stateStream.listen((state) {
  ///     if (state.state == SocketConnectionState.connected) {
  ///       if (shouldAllowSubscription()) {
  ///         subscribeToVenues();
  ///         markSubscriptionComplete();
  ///       }
  ///     }
  ///   });
  /// }
  /// ```
  ///
  /// **Why:**
  /// - Phoenix WebSocket can emit `connected` state multiple times during initialization
  /// - Prevents duplicate channel join attempts within same connection session
  /// - Automatically resets on disconnect/reconnect for fresh subscriptions
  ///
  // ────────────────────────────────────────────────
  @protected
  bool shouldAllowSubscription() => !_hasSubscribedForCurrentConnection;

  /// **markSubscriptionComplete**
  ///
  /// Marks that subscriptions have been initialized for the current connection session.
  /// Prevents duplicate subscriptions until the connection is closed and reopened.
  ///
  /// **Usage Example (in subclass):**
  /// ```dart
  /// if (shouldAllowSubscription()) {
  ///   subscribeToVenues();
  ///   markSubscriptionComplete(); // Prevent duplicate calls
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  @protected
  void markSubscriptionComplete() {
    _hasSubscribedForCurrentConnection = true;
  }

  /// **Abstract Method**
  ///
  /// Subclass must provide WebSocket URL (with auth if needed).
  ///
  /// **Returns:**
  /// - `String`: Full WebSocket URL including protocol, host, path, and query params
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// String getWebSocketUrl() {
  ///   final token = getAuthToken(); // Your auth logic
  ///   return 'wss://api.example.com/socket?jwt=$token';
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  String getWebSocketUrl();

  /// **connect**
  ///
  /// Establishes WebSocket connection and sets up event listeners.
  ///
  /// **Key Features:**
  /// - Initializes Phoenix socket with URL from subclass
  /// - Sets up connection event listeners
  /// - Restores channels if reconnecting with auto-reconnect enabled
  /// - Triggers auto-reconnect on failure if enabled
  /// - Idempotent: safe to call multiple times (skips if already connected)
  ///
  /// **Throws:**
  /// - Connection errors (emitted to errorStream)
  ///
  /// **Usage Example:**
  /// ```dart
  /// await socketService.connect();
  /// ```
  ///
  // ────────────────────────────────────────────────
  Future<void> connect() async {
    // Idempotent: skip if already connected (prevents duplicate state events on hot restart)
    if (_currentState == SocketConnectionState.connected) {
      _log(LogLevel.debug, 'Already connected, skipping connect()');
      return;
    }

    _updateState(SocketConnectionState.connecting);
    _log(LogLevel.info, 'Connecting to WebSocket...');

    try {
      _socket = PhoenixSocket(
        getWebSocketUrl(),
        socketOptions: PhoenixSocketOptions(
          heartbeat: Duration(seconds: _heartbeatConfig.pingIntervalSeconds),
        ),
      );
      await _socket!.connect();
      _setupListeners();
      // Connected state set by openStream.listen() - single source of truth
      // Counter resets in openStream listener on successful connection only
      // Channel restoration happens in openStream listener (after socket opens)
      _log(LogLevel.info, 'Connection initiated, waiting for openStream...');
    } catch (e) {
      _log(LogLevel.error, 'Connection failed: $e');
      _emitError(SocketErrorType.connection, 'Failed to connect', e);
      _updateState(SocketConnectionState.disconnected);

      // Auto-reconnect if enabled
      if (_reconnectConfig.enabled) {
        reconnect();
      }

      rethrow;
    }
  }

  /// **disconnect**
  ///
  /// Closes WebSocket connection and optionally clears channels.
  ///
  /// **Behavior:**
  /// - Stops any pending reconnection attempts
  /// - Clears channels if auto-reconnect is disabled
  /// - Preserves channels if auto-reconnect is enabled (for restoration)
  /// - Closes socket connection
  ///
  /// **Usage Example:**
  /// ```dart
  /// socketService.disconnect(); // User logged out
  /// ```
  ///
  // ────────────────────────────────────────────────
  void disconnect() {
    _log(LogLevel.info, 'Disconnecting...');
    _updateState(SocketConnectionState.disconnecting);
    _stopReconnect();
    _reconnectAttempts = 0; // Reset counter for fresh retry budget on next connect
    _stopPingWatchdog(); // Stop heartbeat monitoring

    // Leave channels if auto-reconnect disabled
    if (!_reconnectConfig.enabled) {
      leaveAllChannels();
      _channelsByTopic.clear();
    }

    _socket?.close();
    _updateState(SocketConnectionState.disconnected);
    _log(LogLevel.info, 'Disconnected');
  }

  /// **reconnect**
  ///
  /// Initiates reconnection with configured retry strategy.
  ///
  /// **Key Features:**
  /// - Prevents duplicate reconnection attempts
  /// - Supports exponential backoff
  /// - Respects max retry limit
  /// - Preserves channels for restoration
  /// - Only works if auto-reconnect enabled
  ///
  /// **Usage Example:**
  /// ```dart
  /// // Manual reconnect (e.g., after token refresh)
  /// socketService.reconnect();
  /// ```
  ///
  // ────────────────────────────────────────────────
  void reconnect() {
    if (_isReconnecting) {
      _log(LogLevel.debug, 'Already reconnecting, ignoring duplicate call');
      return;
    }

    if (!_reconnectConfig.enabled) {
      _log(LogLevel.info, 'Auto-reconnect disabled, skipping reconnect');
      return;
    }

    _isReconnecting = true;
    _updateState(SocketConnectionState.reconnecting, attempt: _reconnectAttempts);
    _log(LogLevel.info, 'Starting reconnection attempts...');

    _socket?.close();
    _socket?.dispose();

    _scheduleReconnect();
  }

  /// **forceReconnect**
  ///
  /// Forces a fresh reconnection attempt, bypassing max retry limits.
  /// Used for manual user-initiated reconnections (e.g., tap to reconnect button).
  ///
  /// **Key Features:**
  /// - Bypasses max retry limit (resets counter to 0)
  /// - Allows manual reconnection after automatic retries exhausted
  /// - Gives fresh retry budget (10 new attempts)
  /// - Provides user control over connection recovery
  ///
  /// **Usage Example:**
  /// ```dart
  /// // User taps reconnect button after max attempts reached
  /// socketService.forceReconnect();
  /// ```
  ///
  /// **Difference from reconnect():**
  /// - reconnect(): Respects current attempt counter and max retry limit
  /// - forceReconnect(): Resets counter to 0, always allows reconnection
  ///
  /// **Why:**
  /// - Automatic reconnection should have limits (prevent infinite loops)
  /// - Manual user action should be allowed (user explicitly requesting)
  /// - Separation of automatic vs manual reconnection logic
  ///
  // ────────────────────────────────────────────────
  void forceReconnect() {
    _log(LogLevel.info, 'Force reconnect requested (manual override)');
    _reconnectAttempts = 0;  // Reset counter - bypass max attempts check
    reconnect();
  }

  /// **autoReconnectIfNeeded**
  ///
  /// Attempts reconnection only if socket is truly disconnected and not already reconnecting.
  /// Used for automatic reconnection triggers (network restore, app resume).
  ///
  /// **Defensive Guards:**
  /// - Skip if already connected (no unnecessary reconnection)
  /// - Skip if already reconnecting (prevent duplicate attempts during state transitions)
  /// - Resets retry counter (allows reconnection after max attempts reached)
  ///
  /// **Usage Example:**
  /// ```dart
  /// // Network restored after being offline
  /// socketService.autoReconnectIfNeeded();
  ///
  /// // App resumed from background
  /// socketService.autoReconnectIfNeeded();
  /// ```
  ///
  /// **Difference from forceReconnect():**
  /// - `forceReconnect()`: Always reconnects (manual user action - tap to reconnect)
  /// - `autoReconnectIfNeeded()`: Only reconnects if needed (automatic triggers - network/app events)
  ///
  /// **Why Two Methods:**
  /// - Manual action: User expects immediate reconnection attempt
  /// - Automatic trigger: Should be defensive and idempotent (safe to call multiple times)
  ///
  /// **Edge Cases Handled:**
  /// - Already connected: Skip reconnection (avoid disrupting working connection)
  /// - Already reconnecting: Skip to prevent duplicate attempts during brief state transitions
  /// - Max attempts reached: Reset counter to allow fresh reconnection attempt
  ///
  // ────────────────────────────────────────────────
  void autoReconnectIfNeeded() {
    // Guard #1: Already connected - no need to reconnect
    if (_currentState == SocketConnectionState.connected) {
      _log(LogLevel.debug, 'Auto-reconnect skipped: already connected');
      return;
    }

    // Guard #2: Already reconnecting - avoid duplicate attempts
    if (_isReconnecting) {
      _log(LogLevel.debug, 'Auto-reconnect skipped: already reconnecting');
      return;
    }

    _log(LogLevel.info, 'Auto-reconnect triggered (network/app restored)');
    _reconnectAttempts = 0;  // Reset counter - bypass max attempts check
    reconnect();
  }

  /// **_scheduleReconnect**
  ///
  /// Schedules the next reconnection attempt with backoff strategy.
  ///
  /// **Why Private:**
  /// - Internal reconnection scheduling logic
  /// - Called by reconnect() and failed reconnect attempts
  ///
  // ────────────────────────────────────────────────
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _reconnectConfig.maxRetries) {
      _log(LogLevel.error, 'Max reconnect attempts (${_reconnectConfig.maxRetries}) reached');
      _emitError(
        SocketErrorType.connection,
        'Max reconnect attempts reached',
        'Attempted $_reconnectAttempts times',
      );
      _stopReconnect();
      _updateState(SocketConnectionState.disconnected);
      return;
    }

    int delay = _calculateBackoff();
    _log(LogLevel.info, 'Reconnect attempt ${_reconnectAttempts + 1}/${_reconnectConfig.maxRetries} in ${delay}s');

    _reconnectTimer = Timer(Duration(seconds: delay), () async {
      _reconnectAttempts++;
      _updateState(SocketConnectionState.reconnecting, attempt: _reconnectAttempts);
      try {
        await connect();
        _stopReconnect();
        _isReconnecting = false;
      } catch (e) {
        _log(LogLevel.error, 'Reconnect attempt $_reconnectAttempts failed: $e');
        _scheduleReconnect(); // Schedule next attempt
      }
    });
  }

  /// **_calculateBackoff**
  ///
  /// Calculates reconnection delay with optional exponential backoff.
  ///
  /// **Returns:**
  /// - `int`: Delay in seconds before next reconnection attempt
  ///
  /// **Why Private:**
  /// - Internal backoff calculation logic
  ///
  // ────────────────────────────────────────────────
  int _calculateBackoff() {
    if (!_reconnectConfig.exponentialBackoff) {
      return _reconnectConfig.baseRetrySeconds;
    }

    int delay = _reconnectConfig.baseRetrySeconds * (1 << _reconnectAttempts);
    return delay.clamp(
      _reconnectConfig.baseRetrySeconds,
      _reconnectConfig.maxBackoffSeconds,
    );
  }

  /// **_stopReconnect**
  ///
  /// Stops reconnection attempts and cleans up timers.
  ///
  /// **Why Private:**
  /// - Internal cleanup called by disconnect and successful reconnect
  ///
  // ────────────────────────────────────────────────
  void _stopReconnect() {
    _isReconnecting = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// **joinChannel**
  ///
  /// Joins a Phoenix channel by topic.
  ///
  /// **Parameters:**
  /// - `topic`: Channel topic string (e.g., 'location:123', 'chat:room_abc')
  /// - `params`: Optional parameters for channel join
  ///
  /// **Returns:**
  /// - `PhoenixChannel`: The joined channel instance
  ///
  /// **Throws:**
  /// - Channel join errors (emitted to errorStream)
  ///
  /// **Usage Example:**
  /// ```dart
  /// final channel = socketService.joinChannel('notifications:user_123');
  /// channel.on('new_message', (payload, ref, joinRef) {
  ///   handleMessage(payload);
  /// });
  /// ```
  ///
  // ────────────────────────────────────────────────
  PhoenixChannel joinChannel(String topic, {Map<String, dynamic>? params}) {
    _log(LogLevel.info, 'Joining channel: $topic');

    try {
      final channel = _socket!.addChannel(topic: topic, parameters: params ?? {});
      _channels.add(channel);
      _channelsByTopic[topic] = channel; // Track for restoration
      channel.join();
      return channel;
    } catch (e) {
      _log(LogLevel.error, 'Failed to join channel $topic: $e');
      _emitError(SocketErrorType.channel, 'Failed to join channel: $topic', e);
      rethrow;
    }
  }

  /// **leaveChannel**
  ///
  /// Leaves a specific Phoenix channel.
  ///
  /// **Parameters:**
  /// - `channel`: The channel instance to leave
  ///
  /// **Usage Example:**
  /// ```dart
  /// socketService.leaveChannel(myChannel);
  /// ```
  ///
  // ────────────────────────────────────────────────
  void leaveChannel(PhoenixChannel channel) {
    _log(LogLevel.info, 'Leaving channel: ${channel.topic}');

    try {
      channel.leave();
      _socket?.removeChannel(channel);
      _channels.remove(channel);
      _channelsByTopic.remove(channel.topic);
    } catch (e) {
      _log(LogLevel.error, 'Failed to leave channel ${channel.topic}: $e');
      _emitError(SocketErrorType.channel, 'Failed to leave channel: ${channel.topic}', e);
    }
  }

  /// **leaveAllChannels**
  ///
  /// Leaves all currently active channels.
  ///
  /// **Usage Example:**
  /// ```dart
  /// socketService.leaveAllChannels(); // Clean up before logout
  /// ```
  ///
  // ────────────────────────────────────────────────
  void leaveAllChannels() {
    _log(LogLevel.info, 'Leaving all channels (${_channels.length})');

    for (var channel in List.from(_channels)) {
      leaveChannel(channel);
    }
  }

  /// **enableAutoReconnect**
  ///
  /// Enables auto-reconnect at runtime with optional custom configuration.
  ///
  /// **Parameters:**
  /// - `baseRetrySeconds`: Base delay between retries
  /// - `maxRetries`: Maximum reconnection attempts
  /// - `exponentialBackoff`: Whether to use exponential backoff
  ///
  /// **Usage Example:**
  /// ```dart
  /// // User came back online
  /// socketService.enableAutoReconnect();
  /// ```
  ///
  // ────────────────────────────────────────────────
  void enableAutoReconnect({
    int? baseRetrySeconds,
    int? maxRetries,
    bool? exponentialBackoff,
  }) {
    _reconnectConfig = ReconnectConfig(
      enabled: true,
      baseRetrySeconds: baseRetrySeconds ?? _reconnectConfig.baseRetrySeconds,
      maxRetries: maxRetries ?? _reconnectConfig.maxRetries,
      exponentialBackoff: exponentialBackoff ?? _reconnectConfig.exponentialBackoff,
    );
    _log(LogLevel.info, 'Auto-reconnect enabled');
  }

  /// **disableAutoReconnect**
  ///
  /// Disables auto-reconnect at runtime and stops any pending reconnection.
  ///
  /// **Usage Example:**
  /// ```dart
  /// // User went offline intentionally
  /// socketService.disableAutoReconnect();
  /// socketService.disconnect();
  /// ```
  ///
  // ────────────────────────────────────────────────
  void disableAutoReconnect() {
    _reconnectConfig = const ReconnectConfig(enabled: false);
    _stopReconnect();
    _log(LogLevel.info, 'Auto-reconnect disabled');
  }

  /// **setLogLevel**
  ///
  /// Changes logging verbosity at runtime.
  ///
  /// **Parameters:**
  /// - `level`: New log level (none, error, info, debug)
  ///
  /// **Usage Example:**
  /// ```dart
  /// // Debug mode
  /// socketService.setLogLevel(LogLevel.debug);
  ///
  /// // Production mode
  /// socketService.setLogLevel(LogLevel.error);
  /// ```
  ///
  // ────────────────────────────────────────────────
  void setLogLevel(LogLevel level) {
    _logLevel = level;
    _log(LogLevel.info, 'Log level changed to: $level');
  }

  /// **_startPingWatchdog**
  ///
  /// Starts monitoring Phoenix heartbeat pings for timeout detection.
  ///
  /// **How It Works:**
  /// - Records current time as last ping received
  /// - Starts periodic timer to check for ping timeout
  /// - Checks every `watchdogCheckIntervalSeconds`
  /// - If no ping received for `timeoutSeconds`, triggers reconnection
  ///
  /// **Why Private:**
  /// - Internal monitoring setup called by _setupListeners()
  /// - Should only be called when socket opens
  ///
  // ────────────────────────────────────────────────
  void _startPingWatchdog() {
    _lastPingReceived = DateTime.now();
    _pingWatchdogTimer?.cancel();

    _log(
      LogLevel.info,
      'Starting ping watchdog (interval: ${_heartbeatConfig.pingIntervalSeconds}s, timeout: ${_heartbeatConfig.timeoutSeconds}s, check every: ${_heartbeatConfig.watchdogCheckIntervalSeconds}s)',
    );

    _pingWatchdogTimer = Timer.periodic(
      Duration(seconds: _heartbeatConfig.watchdogCheckIntervalSeconds),
      (_) => _checkPingTimeout(),
    );
  }

  /// **_onPingReceived**
  ///
  /// Updates last ping timestamp when heartbeat received from Phoenix.
  ///
  /// **Why Private:**
  /// - Internal ping tracking called by messageStream listener
  /// - Updates observable state for monitoring
  ///
  // ────────────────────────────────────────────────
  void _onPingReceived() {
    _lastPingReceived = DateTime.now();
    _log(LogLevel.debug, 'Heartbeat ping received');
  }

  /// **_checkPingTimeout**
  ///
  /// Checks if ping timeout exceeded and triggers reconnection if needed.
  ///
  /// **Logic:**
  /// - Calculates time since last ping
  /// - If elapsed > timeout threshold -> force disconnect and reconnect
  /// - Logs detailed timeout information for debugging
  /// - Prevents reconnection if already disconnected
  ///
  /// **Why Private:**
  /// - Internal timeout check called by watchdog timer
  /// - Part of heartbeat monitoring system
  ///
  // ────────────────────────────────────────────────
  void _checkPingTimeout() {
    if (_lastPingReceived == null) return;

    final elapsed = DateTime.now().difference(_lastPingReceived!).inSeconds;

    // Log check for debugging (only at debug level to avoid log spam)
    _log(LogLevel.debug, 'Ping watchdog check: ${elapsed}s since last ping');

    if (elapsed > _heartbeatConfig.timeoutSeconds) {
      _log(
        LogLevel.error,
        'Ping timeout! No heartbeat for ${elapsed}s (threshold: ${_heartbeatConfig.timeoutSeconds}s) - connection appears dead',
      );

      _emitError(
        SocketErrorType.timeout,
        'Heartbeat timeout - no ping received for ${elapsed}s',
        'Last ping received: $_lastPingReceived',
      );

      // Prevent duplicate reconnection if already disconnected
      if (_currentState == SocketConnectionState.disconnected ||
          _currentState == SocketConnectionState.disconnecting) {
        _log(LogLevel.debug, 'Already disconnected/disconnecting, skipping timeout reconnect');
        return;
      }

      // Force close and trigger reconnection
      _stopPingWatchdog();
      _socket?.close();
      disconnect();

      if (_reconnectConfig.enabled) {
        reconnect();
      }
    }
  }

  /// **_stopPingWatchdog**
  ///
  /// Stops ping monitoring and cleans up watchdog timer.
  ///
  /// **Why Private:**
  /// - Internal cleanup called by disconnect() and dispose()
  /// - Ensures timer is properly canceled to prevent memory leaks
  ///
  // ────────────────────────────────────────────────
  void _stopPingWatchdog() {
    _pingWatchdogTimer?.cancel();
    _pingWatchdogTimer = null;
    _lastPingReceived = null;
    _log(LogLevel.debug, 'Ping watchdog stopped');
  }

  /// **_setupListeners**
  ///
  /// Sets up Phoenix socket event listeners for open, close, error, and message events.
  ///
  /// **Why Private:**
  /// - Internal setup called by connect()
  /// - Should not be called multiple times
  ///
  // ────────────────────────────────────────────────
  void _setupListeners() {
    _socket!.openStream.listen((_) {
      _log(LogLevel.info, 'Socket opened');

      // Handle channel restoration BEFORE emitting connected state
      // This prevents race condition with _initializeAutoSubscription()
      final isReconnection = _channelsByTopic.isNotEmpty;
      if (isReconnection) {
        // Mark subscription complete BEFORE emitting state to prevent auto-subscription
        markSubscriptionComplete();
        _log(LogLevel.info, 'Restoring ${_channelsByTopic.length} channels after reconnect');

        final topics = _channelsByTopic.keys.toList();
        _channels.clear(); // Clear old channel references

        for (var topic in topics) {
          try {
            joinChannel(topic);
          } catch (e) {
            _log(LogLevel.error, 'Failed to restore channel $topic: $e');
          }
        }
      }

      // Now emit connected state (auto-subscription will be blocked if we restored)
      _updateState(SocketConnectionState.connected);
      _reconnectAttempts = 0;
      _startPingWatchdog(); // Start heartbeat monitoring
    });

    _socket!.closeStream.listen((_) {
      _log(LogLevel.info, 'Socket closed');
      _stopPingWatchdog(); // Stop heartbeat monitoring
      _updateState(SocketConnectionState.disconnected);

      // Auto-reconnect if enabled and not already reconnecting
      if (_reconnectConfig.enabled && !_isReconnecting) {
        reconnect();
      }
    });

    _socket!.errorStream.listen((error) {
      _log(LogLevel.error, 'Socket error: $error');
      _emitError(SocketErrorType.connection, 'Socket error', error);
    });

    // Monitor Phoenix heartbeat pings
    _socket!.messageStream
        .where((msg) => msg.topic == 'phoenix' && msg.event.value == 'phx_reply')
        .listen((_) => _onPingReceived());

    // Log messages if debug level
    _socket!.messageStream.listen((message) {
      _log(LogLevel.debug, 'Message received: ${message.event.value} on ${message.topic}');
    });
  }

  /// **_updateState**
  ///
  /// Updates connection state and broadcasts to state stream.
  ///
  /// **Why Private:**
  /// - Internal state management
  /// - Ensures state changes are always broadcast
  /// - Resets subscription session flag when disconnecting/reconnecting
  ///
  // ────────────────────────────────────────────────
  void _updateState(SocketConnectionState state, {int? attempt}) {
    _currentState = state;

    // Reset subscription flag when connection session ends
    // This allows fresh subscriptions on next connection
    if (state == SocketConnectionState.disconnecting ||
        state == SocketConnectionState.reconnecting ||
        state == SocketConnectionState.disconnected) {
      _hasSubscribedForCurrentConnection = false;
    }

    _stateController.add(SocketStateInfo(
      state: state,
      reconnectAttempt: attempt,
    ));
  }

  /// **_emitError**
  ///
  /// Emits error to error stream with categorization.
  ///
  /// **Why Private:**
  /// - Internal error handling
  /// - Ensures errors are properly categorized and logged
  ///
  // ────────────────────────────────────────────────
  void _emitError(SocketErrorType type, String message, [dynamic originalError]) {
    _errorController.add(SocketError(
      type: type,
      message: message,
      originalError: originalError,
    ));
  }

  /// **_log**
  ///
  /// Logs messages based on current log level configuration.
  ///
  /// **Why Private:**
  /// - Internal logging mechanism
  /// - Respects configured log level
  ///
  // ────────────────────────────────────────────────
  void _log(LogLevel level, String message) {
    if (_logLevel.index < level.index) return;

    String prefix = runtimeType.toString();
    log('[$prefix] $message', name: 'SocketService');
  }

  /// **dispose**
  ///
  /// Cleans up resources and closes streams.
  ///
  /// **Usage Example:**
  /// ```dart
  /// @override
  /// void onClose() {
  ///   socketService.dispose();
  ///   super.onClose();
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  void dispose() {
    _log(LogLevel.info, 'Disposing socket service');
    _stopReconnect();
    _stopPingWatchdog(); // Stop heartbeat monitoring
    leaveAllChannels();
    _socket?.dispose();
    _stateController.close();
    _errorController.close();
  }
}
