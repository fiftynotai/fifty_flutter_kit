import 'package:fifty_socket/fifty_socket.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/socket_controller.dart';

/// Hero card displaying the current WebSocket connection state.
///
/// Maps each [SocketConnectionState] to a semantic icon, color, and
/// [FiftyBadge] variant. Shows the reconnect attempt number when
/// the socket is in a reconnecting state.
class ConnectionStatusCard extends StatelessWidget {
  /// Creates a connection status card.
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SocketController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final state = controller.connectionState.value;
      final mapping = _stateMapping(state);

      return FiftyCard(
        size: FiftyCardSize.hero,
        child: SizedBox(
          width: double.infinity,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mapping.icon,
              size: 48,
              color: mapping.color,
            ),
            SizedBox(height: FiftySpacing.md),
            Text(
              state.name.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.titleLarge,
                fontWeight: FiftyTypography.bold,
                color: colorScheme.onSurface,
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              ),
            ),
            SizedBox(height: FiftySpacing.sm),
            FiftyBadge(
              label: _badgeLabel(state, controller.reconnectAttempt.value),
              variant: mapping.badgeVariant,
              showGlow: state == SocketConnectionState.connected,
            ),
            if (state == SocketConnectionState.reconnecting) ...[
              SizedBox(height: FiftySpacing.sm),
              Text(
                'Attempt ${controller.reconnectAttempt.value}',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.regular,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        ),
      );
    });
  }

  /// Returns the badge label based on the current state and attempt.
  String _badgeLabel(SocketConnectionState state, int attempt) {
    switch (state) {
      case SocketConnectionState.connected:
        return 'Online';
      case SocketConnectionState.connecting:
        return 'Connecting';
      case SocketConnectionState.disconnected:
        return 'Offline';
      case SocketConnectionState.reconnecting:
        return 'Retry #$attempt';
      case SocketConnectionState.disconnecting:
        return 'Closing';
    }
  }

  /// Maps a [SocketConnectionState] to visual properties.
  _StateMapping _stateMapping(SocketConnectionState state) {
    switch (state) {
      case SocketConnectionState.connected:
        return _StateMapping(
          icon: Icons.cloud_done_rounded,
          color: FiftyColors.hunterGreen,
          badgeVariant: FiftyBadgeVariant.success,
        );
      case SocketConnectionState.connecting:
        return _StateMapping(
          icon: Icons.cloud_upload_rounded,
          color: FiftyColors.slateGrey,
          badgeVariant: FiftyBadgeVariant.neutral,
        );
      case SocketConnectionState.disconnected:
        return _StateMapping(
          icon: Icons.cloud_off_rounded,
          color: FiftyColors.burgundy,
          badgeVariant: FiftyBadgeVariant.error,
        );
      case SocketConnectionState.reconnecting:
        return _StateMapping(
          icon: Icons.cloud_sync_rounded,
          color: FiftyColors.warning,
          badgeVariant: FiftyBadgeVariant.warning,
        );
      case SocketConnectionState.disconnecting:
        return _StateMapping(
          icon: Icons.cloud_outlined,
          color: FiftyColors.slateGrey,
          badgeVariant: FiftyBadgeVariant.neutral,
        );
    }
  }
}

/// Internal mapping of visual properties for a connection state.
class _StateMapping {
  const _StateMapping({
    required this.icon,
    required this.color,
    required this.badgeVariant,
  });

  final IconData icon;
  final Color color;
  final FiftyBadgeVariant badgeVariant;
}
