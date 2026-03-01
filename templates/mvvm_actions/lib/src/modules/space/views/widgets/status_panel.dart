import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Connection status states for the space module.
enum ApiConnectionStatus {
  /// Successfully connected to NASA API.
  connected,

  /// Connection attempt in progress.
  connecting,

  /// Failed to connect or connection lost.
  disconnected,
}

/// **StatusPanel**
///
/// A status panel displaying API connection information and tracking stats.
///
/// **Features**:
/// - API connection status indicator
/// - Last sync timestamp
/// - Objects tracked count
/// - Uses FiftyDataSlate for terminal-style display
///
/// **Usage**:
/// ```dart
/// StatusPanel(
///   connectionStatus: ApiConnectionStatus.connected,
///   lastSyncTime: DateTime.now(),
///   objectsTracked: 42,
/// )
/// ```
class StatusPanel extends StatelessWidget {
  /// Current API connection status.
  final ApiConnectionStatus connectionStatus;

  /// Timestamp of the last successful data sync.
  final DateTime? lastSyncTime;

  /// Number of NEO objects currently being tracked.
  final int objectsTracked;

  /// Optional callback when refresh is requested.
  final VoidCallback? onRefresh;

  const StatusPanel({
    super.key,
    required this.connectionStatus,
    this.lastSyncTime,
    this.objectsTracked = 0,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FiftyDataSlate(
      title: 'SYSTEM STATUS',
      showGlow: connectionStatus == ApiConnectionStatus.connected,
      data: {
        'API STATUS': _getStatusText(),
        'LAST SYNC': _formatLastSync(),
        'TRACKING': '$objectsTracked OBJECTS',
      },
    );
  }

  /// Returns formatted status text based on connection state.
  String _getStatusText() {
    switch (connectionStatus) {
      case ApiConnectionStatus.connected:
        return 'ONLINE';
      case ApiConnectionStatus.connecting:
        return 'CONNECTING...';
      case ApiConnectionStatus.disconnected:
        return 'OFFLINE';
    }
  }

  /// Formats the last sync time for display.
  String _formatLastSync() {
    if (lastSyncTime == null) {
      return 'NEVER';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);

    if (difference.inSeconds < 60) {
      return 'JUST NOW';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m AGO';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h AGO';
    } else {
      return '${difference.inDays}d AGO';
    }
  }
}

/// **StatusIndicator**
///
/// A compact status indicator widget with animated glow for connection state.
///
/// **Usage**:
/// ```dart
/// StatusIndicator(
///   status: ApiConnectionStatus.connected,
///   label: 'NASA API',
/// )
/// ```
class StatusIndicator extends StatelessWidget {
  /// The current connection status.
  final ApiConnectionStatus status;

  /// Optional label to display next to the indicator.
  final String? label;

  const StatusIndicator({
    super.key,
    required this.status,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status dot
        FiftyBadge(
          label: _getStatusLabel(),
          variant: _getVariant(),
          showGlow: status == ApiConnectionStatus.connected,
        ),

        if (label != null) ...[
          SizedBox(width: FiftySpacing.sm),
          Text(
            label!,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              fontWeight: FiftyTypography.regular,
              color: FiftyColors.hyperChrome,
            ),
          ),
        ],
      ],
    );
  }

  String _getStatusLabel() {
    switch (status) {
      case ApiConnectionStatus.connected:
        return 'ONLINE';
      case ApiConnectionStatus.connecting:
        return 'SYNC';
      case ApiConnectionStatus.disconnected:
        return 'OFFLINE';
    }
  }

  FiftyBadgeVariant _getVariant() {
    switch (status) {
      case ApiConnectionStatus.connected:
        return FiftyBadgeVariant.success;
      case ApiConnectionStatus.connecting:
        return FiftyBadgeVariant.warning;
      case ApiConnectionStatus.disconnected:
        return FiftyBadgeVariant.error;
    }
  }
}
