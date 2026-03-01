import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Reusable card showing a [ConnectivityType] with icon, color, and badge.
class StatusCard extends StatelessWidget {
  /// Creates a status card for the given connectivity [type].
  const StatusCard({super.key, required this.type});

  /// The connectivity type to display.
  final ConnectivityType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = _iconFor(type);
    final color = _colorFor(type, colorScheme);
    final badgeVariant = _badgeVariantFor(type);

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 48, color: color),
          SizedBox(height: FiftySpacing.md),
          Text(
            type.name.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.titleMedium,
              fontWeight: FiftyTypography.bold,
              color: colorScheme.onSurface,
              letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            ),
          ),
          SizedBox(height: FiftySpacing.md),
          FiftyBadge(
            label: type.name.toUpperCase(),
            variant: badgeVariant,
            showGlow: true,
          ),
        ],
      ),
    );
  }

  /// Maps a [ConnectivityType] to its display icon.
  IconData _iconFor(ConnectivityType type) {
    switch (type) {
      case ConnectivityType.wifi:
        return Icons.wifi;
      case ConnectivityType.mobileData:
        return Icons.cell_tower;
      case ConnectivityType.disconnected:
        return Icons.wifi_off;
      case ConnectivityType.noInternet:
        return Icons.cloud_off;
      case ConnectivityType.connecting:
        return Icons.sync;
    }
  }

  /// Maps a [ConnectivityType] to its display color.
  Color _colorFor(ConnectivityType type, ColorScheme colorScheme) {
    switch (type) {
      case ConnectivityType.wifi:
      case ConnectivityType.mobileData:
        return colorScheme.primary;
      case ConnectivityType.disconnected:
      case ConnectivityType.noInternet:
        return colorScheme.error;
      case ConnectivityType.connecting:
        // ignore: deprecated_member_use
        return FiftyColors.hyperChrome;
    }
  }

  /// Maps a [ConnectivityType] to a badge variant.
  FiftyBadgeVariant _badgeVariantFor(ConnectivityType type) {
    switch (type) {
      case ConnectivityType.wifi:
      case ConnectivityType.mobileData:
        return FiftyBadgeVariant.success;
      case ConnectivityType.disconnected:
      case ConnectivityType.noInternet:
        return FiftyBadgeVariant.error;
      case ConnectivityType.connecting:
        return FiftyBadgeVariant.neutral;
    }
  }
}
