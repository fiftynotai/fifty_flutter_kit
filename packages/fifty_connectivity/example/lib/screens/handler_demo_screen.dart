import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Live showcase of the [ConnectionHandler] widget.
///
/// When connected, shows sample dashboard content.
/// When offline, the handler automatically switches to its built-in retry UI.
class HandlerDemoScreen extends StatelessWidget {
  /// Creates the handler demo screen.
  const HandlerDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConnectionHandler')),
      body: ConnectionHandler(
        connectedWidget: _buildConnectedContent(context),
        tryAgainAction: () =>
            ConnectionActions.instance.checkConnectivity(),
      ),
    );
  }

  /// Builds sample dashboard content shown when connected.
  Widget _buildConnectedContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = Get.find<ConnectionViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Connected status header
          FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.xxl),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: FiftySpacing.lg),
                Text(
                  'UPLINK ACTIVE',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleLarge,
                    fontWeight: FiftyTypography.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                  ),
                ),
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'All systems operational',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Live telemetry showing handler is passing data through
          Obx(
            () => FiftyDataSlate(
              title: 'LIVE FEED',
              data: {
                'Connection': vm.connectionType.value.name.toUpperCase(),
                'Status': vm.isConnected() ? 'ONLINE' : 'OFFLINE',
                'Uptime': vm.dialogTimer.value,
              },
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Simulated data items to show content flows through handler
          ..._buildDataItems(colorScheme),
        ],
      ),
    );
  }

  /// Builds simulated data feed items.
  List<Widget> _buildDataItems(ColorScheme colorScheme) {
    final items = [
      ('Sensor Alpha', 'Active', Icons.sensors),
      ('Telemetry Stream', 'Receiving', Icons.stream),
      ('Navigation Array', 'Locked', Icons.gps_fixed),
      ('Comm Relay', 'Online', Icons.cell_tower),
    ];

    return items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
        child: FiftyCard(
          child: Row(
            children: [
              Icon(item.$3, size: 24, color: colorScheme.primary),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Text(
                  item.$1,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FiftyTypography.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              FiftyBadge.status(item.$2),
            ],
          ),
        ),
      );
    }).toList();
  }
}
