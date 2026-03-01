import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Status states for the indicator.
///
/// Represents the various operational states that can be displayed
/// by a [FiftyStatusIndicator].
enum FiftyStatusState {
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

/// Size variants for the status indicator.
enum FiftyStatusSize {
  /// Small size (6px dot, bodySmall text).
  small,

  /// Medium size (8px dot, body text).
  medium,

  /// Large size (10px dot, bodyLarge text).
  large,
}

/// **FiftyStatusIndicator**
///
/// A status indicator widget that displays a colored dot with label
/// to indicate the operational state of a service or component.
///
/// Features:
/// - Five semantic states (ready, loading, error, offline, idle)
/// - Three size variants (small, medium, large)
/// - Theme-aware colors via [FiftyThemeExtension]
/// - Optional dot visibility
/// - Custom color override support
///
/// **Why**
/// - Provides consistent status visualization across the ecosystem
/// - Uses semantic colors that adapt to light/dark mode
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage
/// FiftyStatusIndicator(
///   label: 'Engine',
///   state: FiftyStatusState.ready,
/// )
///
/// // Without status label
/// FiftyStatusIndicator(
///   label: 'API',
///   state: FiftyStatusState.loading,
///   showStatusLabel: false,
/// )
///
/// // Large size with custom color
/// FiftyStatusIndicator(
///   label: 'Database',
///   state: FiftyStatusState.ready,
///   size: FiftyStatusSize.large,
///   customColor: Colors.purple,
/// )
///
/// // Without dot
/// FiftyStatusIndicator(
///   label: 'Service',
///   state: FiftyStatusState.offline,
///   showDot: false,
/// )
/// ```
class FiftyStatusIndicator extends StatelessWidget {
  /// Creates a Fifty-styled status indicator.
  const FiftyStatusIndicator({
    required this.label,
    required this.state,
    super.key,
    this.size = FiftyStatusSize.medium,
    this.showDot = true,
    this.showStatusLabel = true,
    this.customColor,
  });

  /// The label text to display.
  final String label;

  /// The current status state.
  final FiftyStatusState state;

  /// The size variant of the indicator.
  final FiftyStatusSize size;

  /// Whether to show the colored dot.
  final bool showDot;

  /// Whether to show the status text in brackets.
  final bool showStatusLabel;

  /// Custom color override for the dot and status text.
  ///
  /// When set, overrides the state-based color.
  final Color? customColor;

  /// Returns the appropriate dot size based on [size].
  double get _dotSize {
    switch (size) {
      case FiftyStatusSize.small:
        return 6;
      case FiftyStatusSize.medium:
        return 8;
      case FiftyStatusSize.large:
        return 10;
    }
  }

  /// Returns the appropriate font size based on [size].
  double get _fontSize {
    switch (size) {
      case FiftyStatusSize.small:
        return FiftyTypography.bodySmall;
      case FiftyStatusSize.medium:
        return FiftyTypography.bodyMedium;
      case FiftyStatusSize.large:
        return FiftyTypography.bodyLarge;
    }
  }

  /// Returns the color for the dot based on current state.
  Color _getDotColor(ColorScheme colorScheme, FiftyThemeExtension? fiftyTheme) {
    if (customColor != null) {
      return customColor!;
    }

    switch (state) {
      case FiftyStatusState.ready:
        return fiftyTheme?.success ?? colorScheme.tertiary;
      case FiftyStatusState.loading:
        return fiftyTheme?.warning ?? colorScheme.error;
      case FiftyStatusState.error:
        return colorScheme.error;
      case FiftyStatusState.offline:
        return colorScheme.onSurfaceVariant;
      case FiftyStatusState.idle:
        return colorScheme.outline;
    }
  }

  /// Returns the status text for the current state.
  String get _statusText {
    switch (state) {
      case FiftyStatusState.ready:
        return 'READY';
      case FiftyStatusState.loading:
        return 'LOADING';
      case FiftyStatusState.error:
        return 'ERROR';
      case FiftyStatusState.offline:
        return 'OFFLINE';
      case FiftyStatusState.idle:
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
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: FiftySpacing.xs),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: _fontSize,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        if (showStatusLabel) ...[
          SizedBox(width: FiftySpacing.xs),
          Text(
            '[$_statusText]',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: _fontSize,
              color: dotColor,
            ),
          ),
        ],
      ],
    );
  }
}
