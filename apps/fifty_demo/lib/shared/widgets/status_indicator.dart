/// Status Indicator Widget
///
/// Displays a status indicator with label and optional icon.
/// Used throughout the demo to show engine/service status.
library;

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

  Color get _dotColor {
    switch (state) {
      case StatusState.ready:
        return FiftyColors.hunterGreen;
      case StatusState.loading:
        return FiftyColors.warning;
      case StatusState.error:
        return FiftyColors.burgundy;
      case StatusState.offline:
        return FiftyColors.slateGrey;
      case StatusState.idle:
        return FiftyColors.borderDark;
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _dotColor,
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
            color: FiftyColors.cream.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: FiftySpacing.xs),
        Text(
          '[$_statusText]',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            color: _dotColor,
          ),
        ),
      ],
    );
  }
}
