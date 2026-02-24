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
/// Organised into six sections:
/// 1. Connection Status - hero card with state badge
/// 2. Connection Actions - connect / disconnect / force reconnect
/// 3. Configuration - reconnect and heartbeat config slates
/// 4. Controls - auto-reconnect toggle and log level selector
/// 5. Error Stream - list of recent errors
/// 6. Event Log - scrollable timestamped log
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
      body: const SafeArea(
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
// Section 3: Configuration
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
        const SizedBox(height: FiftySpacing.md),
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
// Section 4: Controls
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
        const SizedBox(height: FiftySpacing.md),
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
// Section 5: Error Stream
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
                        const EdgeInsets.only(bottom: FiftySpacing.sm),
                    child: FiftyCard(
                      padding: const EdgeInsets.all(FiftySpacing.md),
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
                          const SizedBox(width: FiftySpacing.sm),
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
                                const SizedBox(
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
// Section 6: Event Log
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
            padding: const EdgeInsets.all(FiftySpacing.md),
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
