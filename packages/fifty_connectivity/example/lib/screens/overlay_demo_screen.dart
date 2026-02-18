import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Live showcase of the [ConnectionOverlay] widget.
///
/// The overlay is already wrapping the entire app via main.dart's builder.
/// This screen shows content underneath the overlay and live overlay state.
class OverlayDemoScreen extends StatelessWidget {
  /// Creates the overlay demo screen.
  const OverlayDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = Get.find<ConnectionViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('ConnectionOverlay')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overlay status indicator
            FiftyCard(
              padding: const EdgeInsets.all(FiftySpacing.xl),
              child: Row(
                children: [
                  FiftyBadge.status('OVERLAY ACTIVE'),
                  const SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      'Wrapping the entire app',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyMedium,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),

            // Current overlay state
            Obx(
              () => FiftyDataSlate(
                title: 'OVERLAY STATE',
                data: {
                  'Connection': vm.connectionType.value.name.toUpperCase(),
                  'Overlay Visible': _isOverlayVisible(vm) ? 'YES' : 'NO',
                  'Component': _activeComponent(vm),
                },
              ),
            ),
            const SizedBox(height: FiftySpacing.xl),

            // Overlay states with visual indicators
            const FiftySectionHeader(title: 'OVERLAY STATES'),
            const SizedBox(height: FiftySpacing.md),
            _buildStateRow(
              context,
              icon: Icons.check_circle,
              iconColor: colorScheme.primary,
              title: 'Connected',
              subtitle: 'No overlay shown',
            ),
            const SizedBox(height: FiftySpacing.sm),
            _buildStateRow(
              context,
              icon: Icons.sync,
              // ignore: deprecated_member_use
              iconColor: FiftyColors.hyperChrome,
              title: 'Connecting',
              subtitle: 'UplinkStatusBar badge at top',
            ),
            const SizedBox(height: FiftySpacing.sm),
            _buildStateRow(
              context,
              icon: Icons.wifi_off,
              iconColor: colorScheme.error,
              title: 'Disconnected',
              subtitle: 'OfflineStatusCard full-screen modal',
            ),
            const SizedBox(height: FiftySpacing.xl),

            // Toggle instruction
            FiftyCard(
              padding: const EdgeInsets.all(FiftySpacing.xl),
              child: Row(
                children: [
                  Icon(
                    Icons.flight,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      'Toggle airplane mode to see the overlay in action across all tabs',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyMedium,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOverlayVisible(ConnectionViewModel vm) {
    final type = vm.connectionType.value;
    return type == ConnectivityType.connecting ||
        type == ConnectivityType.disconnected ||
        type == ConnectivityType.noInternet;
  }

  String _activeComponent(ConnectionViewModel vm) {
    switch (vm.connectionType.value) {
      case ConnectivityType.connecting:
        return 'UplinkStatusBar';
      case ConnectivityType.disconnected:
      case ConnectivityType.noInternet:
        return 'OfflineStatusCard';
      case ConnectivityType.wifi:
      case ConnectivityType.mobileData:
        return 'None';
    }
  }

  Widget _buildStateRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      child: Row(
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FiftyTypography.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
