/// Status Indicator Widget
///
/// Displays a status indicator with label and optional icon.
/// Used throughout the demo to show engine/service status.
/// Uses theme-aware colors for light/dark mode support.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Status states for the indicator.
enum StatusState {
  /// Service is ready/connected.
  ready,

  /// Service is loading/initializing.
  loading,

  /// Service has an error.
  error,

  /// Service is offline/disconnected.
  offline,

  /// Service is idle/inactive.
  idle,
}

/// A status indicator widget.
///
/// Shows a colored dot with label to indicate status.
/// Uses theme-aware colors via [ColorScheme] for labels,
/// while status colors remain semantic (green=ready, yellow=loading, etc).
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    required this.label,
    required this.state,
    super.key,
    this.showDot = true,
  });

  /// The label text to display.
  final String label;

  /// The current status state.
  final StatusState state;

  /// Whether to show the colored dot.
  final bool showDot;

  Color _getDotColor(ColorScheme colorScheme, FiftyThemeExtension? fiftyTheme) {
    switch (state) {
      case StatusState.ready:
        return fiftyTheme?.success ?? colorScheme.tertiary;
      case StatusState.loading:
        return fiftyTheme?.warning ?? colorScheme.error;
      case StatusState.error:
        return colorScheme.error;
      case StatusState.offline:
        return colorScheme.onSurfaceVariant;
      case StatusState.idle:
        return colorScheme.outline;
    }
  }

  String get _statusText {
    switch (state) {
      case StatusState.ready:
        return 'READY';
      case StatusState.loading:
        return 'LOADING';
      case StatusState.error:
        return 'ERROR';
      case StatusState.offline:
        return 'OFFLINE';
      case StatusState.idle:
        return 'IDLE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final dotColor = _getDotColor(colorScheme, fiftyTheme);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.xs),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: FiftySpacing.xs),
        Text(
          '[$_statusText]',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            color: dotColor,
          ),
        ),
      ],
    );
  }
}
