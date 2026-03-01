/// Socket Demo Page
///
/// Demonstrates WebSocket connection lifecycle with mock states.
library;

import 'package:fifty_socket/fifty_socket.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/socket_demo_actions.dart';
import '../controllers/socket_demo_view_model.dart';

/// Socket demo page widget.
///
/// Shows connection status, channel management, and message log
/// using simulated WebSocket states.
class SocketDemoPage extends GetView<SocketDemoViewModel> {
  /// Creates a socket demo page.
  const SocketDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocketDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<SocketDemoActions>();

        return DemoScaffold(
          title: 'Fifty Socket',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const FiftySectionHeader(
                  title: 'WebSocket Demo',
                  subtitle: 'Simulated Phoenix WebSocket lifecycle',
                ),

                // Demo Mode Badge
                _buildDemoModeBadge(context),
                SizedBox(height: FiftySpacing.lg),

                // Connection Status
                _buildConnectionStatus(context, viewModel),
                SizedBox(height: FiftySpacing.lg),

                // Connection Actions
                _buildConnectionActions(context, viewModel, actions),
                SizedBox(height: FiftySpacing.lg),

                // Socket Config
                _buildConfigCard(context),
                SizedBox(height: FiftySpacing.lg),

                // Channel Management
                const FiftySectionHeader(
                  title: 'Channels',
                  subtitle: 'Join and leave Phoenix channels',
                ),
                _buildChannelSection(context, viewModel, actions),
                SizedBox(height: FiftySpacing.lg),

                // Message Log
                const FiftySectionHeader(
                  title: 'Message Log',
                  subtitle: 'Connection events and messages',
                ),
                _buildMessageLog(context, viewModel, actions),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoModeBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(FiftySpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.smRadius,
        border: Border.all(
          color: colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.science_outlined,
            color: colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              'DEMO MODE - No live server required. All states are simulated.',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                color: colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(
    BuildContext context,
    SocketDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final stateColor = _connectionStateColor(colorScheme, viewModel.connectionState);

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: viewModel.connectionState == SocketConnectionState.connecting ||
                      viewModel.connectionState == SocketConnectionState.reconnecting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                      ),
                    )
                  : Icon(
                      _connectionStateIcon(viewModel.connectionState),
                      color: stateColor,
                      size: 24,
                    ),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.connectionStateLabel,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: stateColor,
                    letterSpacing: 2,
                  ),
                ),
                if (viewModel.connectionState == SocketConnectionState.reconnecting)
                  Text(
                    'Attempt ${viewModel.reconnectAttempt}/10',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                Text(
                  '${viewModel.joinedChannels.length} channel(s) active',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionActions(
    BuildContext context,
    SocketDemoViewModel viewModel,
    SocketDemoActions actions,
  ) {
    final isConnected =
        viewModel.connectionState == SocketConnectionState.connected;
    final isDisconnected =
        viewModel.connectionState == SocketConnectionState.disconnected;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FiftyButton(
                label: viewModel.isConnecting ? 'CONNECTING...' : 'CONNECT',
                variant: FiftyButtonVariant.primary,
                loading: viewModel.isConnecting,
                onPressed: isDisconnected
                    ? () => actions.onConnectTapped(context)
                    : null,
              ),
            ),
            SizedBox(width: FiftySpacing.md),
            Expanded(
              child: FiftyButton(
                label: 'DISCONNECT',
                variant: FiftyButtonVariant.secondary,
                onPressed: isConnected
                    ? () => actions.onDisconnectTapped(context)
                    : null,
              ),
            ),
          ],
        ),
        SizedBox(height: FiftySpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FiftyButton(
            label: 'SIMULATE RECONNECT',
            variant: FiftyButtonVariant.ghost,
            onPressed: isConnected
                ? () => actions.onSimulateReconnectTapped(context)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SOCKET CONFIGURATION',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: FiftySpacing.sm),
          _buildConfigRow(context, 'URL', SocketDemoViewModel.demoConfig.url),
          _buildConfigRow(context, 'Reconnect Base', '${SocketDemoViewModel.demoConfig.reconnectBaseRetry}s'),
          _buildConfigRow(context, 'Max Retries', '${SocketDemoViewModel.demoConfig.reconnectMaxRetries}'),
          _buildConfigRow(context, 'Heartbeat', '${SocketDemoViewModel.demoConfig.heartbeatInterval}s'),
          _buildConfigRow(context, 'Timeout', '${SocketDemoViewModel.demoConfig.heartbeatTimeout}s'),
          _buildConfigRow(context, 'Log Level', SocketDemoViewModel.demoConfig.logLevel),
        ],
      ),
    );
  }

  Widget _buildConfigRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelSection(
    BuildContext context,
    SocketDemoViewModel viewModel,
    SocketDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isConnected =
        viewModel.connectionState == SocketConnectionState.connected;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          for (final topic in SocketDemoViewModel.availableChannels)
            _buildChannelRow(context, viewModel, actions, topic, isConnected),
          if (!isConnected)
            Padding(
              padding: EdgeInsets.only(top: FiftySpacing.sm),
              child: Text(
                'Connect first to manage channels',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChannelRow(
    BuildContext context,
    SocketDemoViewModel viewModel,
    SocketDemoActions actions,
    String topic,
    bool isConnected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isJoined = viewModel.joinedChannels.contains(topic);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isJoined
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: FiftySpacing.sm),
          // Channel name
          Expanded(
            child: Text(
              topic,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: isJoined ? FontWeight.bold : FontWeight.normal,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Send button (when joined)
          if (isJoined) ...[
            GestureDetector(
              onTap: () => actions.onSendMessageTapped(topic),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: FiftyRadii.smRadius,
                ),
                child: Text(
                  'SEND',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.tertiary,
                  ),
                ),
              ),
            ),
            SizedBox(width: FiftySpacing.sm),
          ],
          // Join/Leave button
          GestureDetector(
            onTap: isConnected
                ? () => isJoined
                    ? actions.onLeaveChannelTapped(context, topic)
                    : actions.onJoinChannelTapped(context, topic)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.sm,
                vertical: FiftySpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isJoined
                    ? colorScheme.error.withValues(alpha: 0.15)
                    : isConnected
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                borderRadius: FiftyRadii.smRadius,
              ),
              child: Text(
                isJoined ? 'LEAVE' : 'JOIN',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: isJoined
                      ? colorScheme.error
                      : isConnected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageLog(
    BuildContext context,
    SocketDemoViewModel viewModel,
    SocketDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (viewModel.messages.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: actions.onClearMessagesTapped,
              child: Text(
                'CLEAR LOG',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        SizedBox(height: FiftySpacing.sm),
        FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.md),
          child: viewModel.messages.isEmpty
              ? Center(
                  child: Text(
                    'No messages yet. Connect to start.',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (final msg in viewModel.messages.reversed.take(20))
                      _buildMessageRow(context, msg),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildMessageRow(BuildContext context, DemoMessage message) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSystem = message.topic == 'system';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSystem
                ? Icons.info_outline
                : message.isOutgoing
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
            size: 12,
            color: isSystem
                ? colorScheme.onSurface.withValues(alpha: 0.4)
                : message.isOutgoing
                    ? colorScheme.primary
                    : colorScheme.tertiary,
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSystem)
                  Text(
                    '${message.topic} / ${message.event}',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.labelSmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                Text(
                  isSystem ? message.payload : message.payload,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: isSystem
                        ? colorScheme.onSurface.withValues(alpha: 0.6)
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${message.timestamp.hour.toString().padLeft(2, '0')}:'
            '${message.timestamp.minute.toString().padLeft(2, '0')}:'
            '${message.timestamp.second.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Color _connectionStateColor(
    ColorScheme colorScheme,
    SocketConnectionState state,
  ) {
    switch (state) {
      case SocketConnectionState.disconnected:
        return colorScheme.onSurface.withValues(alpha: 0.5);
      case SocketConnectionState.connecting:
        return colorScheme.primary;
      case SocketConnectionState.connected:
        return colorScheme.tertiary;
      case SocketConnectionState.reconnecting:
        return colorScheme.error;
      case SocketConnectionState.disconnecting:
        return colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  IconData _connectionStateIcon(SocketConnectionState state) {
    switch (state) {
      case SocketConnectionState.disconnected:
        return Icons.cloud_off_outlined;
      case SocketConnectionState.connecting:
        return Icons.cloud_sync_outlined;
      case SocketConnectionState.connected:
        return Icons.cloud_done_outlined;
      case SocketConnectionState.reconnecting:
        return Icons.cloud_sync_outlined;
      case SocketConnectionState.disconnecting:
        return Icons.cloud_off_outlined;
    }
  }
}
