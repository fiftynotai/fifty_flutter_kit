import 'package:fifty_socket/fifty_socket.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/socket_controller.dart';
import '../widgets/connection_status_card.dart';
import '../widgets/event_log_tile.dart';

/// Primary screen for the Fifty Socket example app.
///
/// Organised into eight sections:
/// 1. Connection Status - hero card with state badge
/// 2. Connection Actions - connect / disconnect / force reconnect
/// 3. Channel Management - join/leave channels, list of joined channels
/// 4. Messaging - send messages, view received messages
/// 5. Configuration - reconnect and heartbeat config slates
/// 6. Controls - auto-reconnect toggle and log level selector
/// 7. Error Stream - list of recent errors
/// 8. Event Log - scrollable timestamped log
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FIFTY SOCKET',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleMedium,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ConnectionStatusSection(),
              SizedBox(height: FiftySpacing.xxl),
              _ConnectionActionsSection(),
              SizedBox(height: FiftySpacing.xxl),
              _ChannelManagementSection(),
              SizedBox(height: FiftySpacing.xxl),
              _MessagingSection(),
              SizedBox(height: FiftySpacing.xxl),
              _ConfigurationSection(),
              SizedBox(height: FiftySpacing.xxl),
              _ControlsSection(),
              SizedBox(height: FiftySpacing.xxl),
              _ErrorStreamSection(),
              SizedBox(height: FiftySpacing.xxl),
              _EventLogSection(),
              SizedBox(height: FiftySpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Section 1: Connection Status
// =============================================================================

class _ConnectionStatusSection extends StatelessWidget {
  const _ConnectionStatusSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftySectionHeader(title: 'Connection Status'),
        ConnectionStatusCard(),
      ],
    );
  }
}

// =============================================================================
// Section 2: Connection Actions
// =============================================================================

class _ConnectionActionsSection extends StatelessWidget {
  const _ConnectionActionsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FiftySectionHeader(title: 'Connection Actions'),
        Obx(() {
          final state = controller.connectionState.value;
          final canConnect =
              state == SocketConnectionState.disconnected;
          final canDisconnect =
              state == SocketConnectionState.connected ||
                  state == SocketConnectionState.connecting ||
                  state == SocketConnectionState.reconnecting;
          final canForceReconnect =
              state != SocketConnectionState.connecting;

          return Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              FiftyButton(
                label: 'Connect',
                icon: Icons.power_rounded,
                variant: FiftyButtonVariant.primary,
                size: FiftyButtonSize.small,
                onPressed: canConnect ? controller.connect : null,
              ),
              FiftyButton(
                label: 'Disconnect',
                icon: Icons.power_off_rounded,
                variant: FiftyButtonVariant.danger,
                size: FiftyButtonSize.small,
                onPressed: canDisconnect ? controller.disconnect : null,
              ),
              FiftyButton(
                label: 'Force Reconnect',
                icon: Icons.refresh_rounded,
                variant: FiftyButtonVariant.secondary,
                size: FiftyButtonSize.small,
                onPressed:
                    canForceReconnect ? controller.forceReconnect : null,
              ),
            ],
          );
        }),
      ],
    );
  }
}

// =============================================================================
// Section 3: Channel Management
// =============================================================================

class _ChannelManagementSection extends StatelessWidget {
  const _ChannelManagementSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final topicController = TextEditingController(text: 'test:lobby');
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FiftySectionHeader(title: 'Channel Management'),
        FiftyTextField(
          controller: topicController,
          label: 'CHANNEL TOPIC',
          hint: 'e.g. test:lobby, echo:ping',
          terminalStyle: true,
          prefixStyle: FiftyPrefixStyle.chevron,
          onChanged: (value) => controller.channelTopic.value = value,
        ),
        SizedBox(height: FiftySpacing.sm),
        Obx(() {
          final connected = controller.isConnected.value;
          return Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              FiftyButton(
                label: 'Join',
                icon: Icons.login_rounded,
                variant: FiftyButtonVariant.primary,
                size: FiftyButtonSize.small,
                onPressed: connected
                    ? () => controller.joinChannel(
                        topicController.text.isNotEmpty
                            ? topicController.text
                            : controller.channelTopic.value)
                    : null,
              ),
              FiftyButton(
                label: 'Leave',
                icon: Icons.logout_rounded,
                variant: FiftyButtonVariant.danger,
                size: FiftyButtonSize.small,
                onPressed: connected
                    ? () => controller.leaveChannel(
                        topicController.text.isNotEmpty
                            ? topicController.text
                            : controller.channelTopic.value)
                    : null,
              ),
            ],
          );
        }),
        SizedBox(height: FiftySpacing.md),
        Obx(() {
          if (controller.joinedChannels.isEmpty) {
            return Text(
              'No channels joined',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: controller.joinedChannels
                .map(
                  (topic) => Padding(
                    padding:
                        EdgeInsets.only(bottom: FiftySpacing.xs),
                    child: FiftyCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: FiftySpacing.md,
                        vertical: FiftySpacing.sm,
                      ),
                      scanlineOnHover: false,
                      hoverScale: 1.0,
                      child: Row(
                        children: [
                          Icon(
                            Icons.tag_rounded,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: FiftySpacing.sm),
                          Expanded(
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.bodySmall,
                                fontWeight: FiftyTypography.medium,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.leaveChannel(topic),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }
}

// =============================================================================
// Section 4: Messaging
// =============================================================================

class _MessagingSection extends StatelessWidget {
  const _MessagingSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final messageController = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftySectionHeader(
          title: 'Messaging',
          trailing: Obx(
            () => controller.messages.isNotEmpty
                ? FiftyButton(
                    label: 'Clear',
                    variant: FiftyButtonVariant.ghost,
                    size: FiftyButtonSize.small,
                    onPressed: controller.clearMessages,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        FiftyTextField(
          controller: messageController,
          label: 'MESSAGE',
          hint: 'Type a message...',
          terminalStyle: true,
          prefixStyle: FiftyPrefixStyle.chevron,
          onChanged: (value) => controller.messageInput.value = value,
          onSubmitted: (value) {
            _sendMessage(controller, messageController);
          },
        ),
        SizedBox(height: FiftySpacing.sm),
        Obx(() {
          final hasChannels = controller.joinedChannels.isNotEmpty;
          final hasMessage = controller.messageInput.value.isNotEmpty;
          return FiftyButton(
            label: 'Send',
            icon: Icons.send_rounded,
            variant: FiftyButtonVariant.primary,
            size: FiftyButtonSize.small,
            expanded: true,
            onPressed: hasChannels && hasMessage
                ? () => _sendMessage(controller, messageController)
                : null,
          );
        }),
        SizedBox(height: FiftySpacing.md),
        Obx(() {
          if (controller.messages.isEmpty) {
            return Text(
              'No messages yet',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          }

          return FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.md),
            scanlineOnHover: false,
            hoverScale: 1.0,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final time = msg.timestamp;
                  final timeStr =
                      '${_pad(time.hour)}:${_pad(time.minute)}:${_pad(time.second)}';

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: FiftySpacing.xs / 2),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '[$timeStr] ',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.medium,
                              color: colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: '${msg.topic} ',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.bold,
                              color: FiftyColors.hunterGreen,
                            ),
                          ),
                          TextSpan(
                            text: '${msg.event}: ',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.medium,
                              color: colorScheme.tertiary,
                            ),
                          ),
                          TextSpan(
                            text: msg.payload.toString(),
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              fontWeight: FiftyTypography.regular,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Sends a message on the first joined channel and clears the input.
  void _sendMessage(
    SocketController controller,
    TextEditingController textController,
  ) {
    final text = textController.text.trim();
    if (text.isEmpty || controller.joinedChannels.isEmpty) return;

    final topic = controller.joinedChannels.first;
    controller.sendMessage(topic, 'new_msg', {'body': text});
    textController.clear();
    controller.messageInput.value = '';
  }

  /// Pads a single-digit number with a leading zero.
  String _pad(int value) => value.toString().padLeft(2, '0');
}

// =============================================================================
// Section 5: Configuration
// =============================================================================

class _ConfigurationSection extends StatelessWidget {
  const _ConfigurationSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final reconnect = controller.reconnectConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FiftySectionHeader(title: 'Configuration'),
        FiftyDataSlate(
          title: 'Reconnect Config',
          data: {
            'Enabled': reconnect.enabled ? 'Yes' : 'No',
            'Base Retry': '${reconnect.baseRetrySeconds}s',
            'Max Retries': '${reconnect.maxRetries}',
            'Exp. Backoff': reconnect.exponentialBackoff ? 'Yes' : 'No',
            'Max Backoff': '${reconnect.maxBackoffSeconds}s',
          },
        ),
        SizedBox(height: FiftySpacing.md),
        const FiftyDataSlate(
          title: 'Heartbeat Config',
          data: {
            'Ping Interval': '15s',
            'Timeout': '30s',
            'Watchdog': '15s',
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Section 6: Controls
// =============================================================================

class _ControlsSection extends StatelessWidget {
  const _ControlsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FiftySectionHeader(title: 'Controls'),
        Obx(
          () => FiftySettingsRow(
            label: 'Auto-Reconnect',
            subtitle: 'Automatically retry on disconnect',
            icon: Icons.autorenew_rounded,
            value: controller.autoReconnectEnabled.value,
            onChanged: (_) => controller.toggleAutoReconnect(),
          ),
        ),
        SizedBox(height: FiftySpacing.md),
        Obx(
          () => FiftySegmentedControl<LogLevel>(
            segments: LogLevel.values
                .map(
                  (level) => FiftySegment<LogLevel>(
                    value: level,
                    label: level.name.toUpperCase(),
                  ),
                )
                .toList(),
            selected: controller.currentLogLevel.value,
            onChanged: controller.setLogLevel,
            expanded: true,
            variant: FiftySegmentedControlVariant.secondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Section 7: Error Stream
// =============================================================================

class _ErrorStreamSection extends StatelessWidget {
  const _ErrorStreamSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftySectionHeader(
          title: 'Error Stream',
          trailing: Obx(
            () => controller.errors.isNotEmpty
                ? FiftyButton(
                    label: 'Clear',
                    variant: FiftyButtonVariant.ghost,
                    size: FiftyButtonSize.small,
                    onPressed: controller.clearErrors,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Obx(() {
          if (controller.errors.isEmpty) {
            return Text(
              'No errors',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          }

          return Column(
            children: controller.errors
                .take(10)
                .map(
                  (error) => Padding(
                    padding:
                        EdgeInsets.only(bottom: FiftySpacing.sm),
                    child: FiftyCard(
                      padding: EdgeInsets.all(FiftySpacing.md),
                      size: FiftyCardSize.standard,
                      scanlineOnHover: false,
                      hoverScale: 1.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 16,
                            color: colorScheme.error,
                          ),
                          SizedBox(width: FiftySpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  error.type.name.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily:
                                        FiftyTypography.fontFamily,
                                    fontSize:
                                        FiftyTypography.labelSmall,
                                    fontWeight: FiftyTypography.bold,
                                    color: colorScheme.error,
                                    letterSpacing: FiftyTypography
                                        .letterSpacingLabel,
                                  ),
                                ),
                                SizedBox(
                                    height: FiftySpacing.xs / 2),
                                Text(
                                  error.message,
                                  style: TextStyle(
                                    fontFamily:
                                        FiftyTypography.fontFamily,
                                    fontSize:
                                        FiftyTypography.bodySmall,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }
}

// =============================================================================
// Section 8: Event Log
// =============================================================================

class _EventLogSection extends StatelessWidget {
  const _EventLogSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftySectionHeader(
          title: 'Event Log',
          trailing: Obx(
            () => controller.eventLog.isNotEmpty
                ? FiftyButton(
                    label: 'Clear',
                    variant: FiftyButtonVariant.ghost,
                    size: FiftyButtonSize.small,
                    onPressed: controller.clearLog,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Obx(() {
          if (controller.eventLog.isEmpty) {
            return Text(
              'No events yet',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurfaceVariant,
              ),
            );
          }

          return FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.md),
            scanlineOnHover: false,
            hoverScale: 1.0,
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: controller.eventLog.length,
                itemBuilder: (context, index) {
                  return EventLogTile(
                    entry: controller.eventLog[index],
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
