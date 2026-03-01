import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Size variants for [FiftyLabeledIconButton].
enum FiftyLabeledIconButtonSize {
  /// Small size (36x36 icon container).
  small,

  /// Medium size (48x48 icon container).
  medium,

  /// Large size (60x60 icon container).
  large,
}

/// Style variants for [FiftyLabeledIconButton].
enum FiftyLabeledIconButtonStyle {
  /// Filled background style.
  filled,

  /// Outlined border style.
  outlined,

  /// Ghost/transparent style.
  ghost,
}

/// **FiftyLabeledIconButton**
///
/// A circular icon button with an optional label displayed below.
/// Follows FDL v2 design patterns with theme-aware colors.
///
/// Features:
/// - Three size variants (small, medium, large)
/// - Three style variants (filled, outlined, ghost)
/// - Optional label text below the icon
/// - Selected state styling
/// - Custom color support
/// - Disabled state
///
/// **Why**
/// - Provides consistent control buttons across the ecosystem
/// - Useful for toolbars, control panels, and action grids
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage
/// FiftyLabeledIconButton(
///   icon: Icons.zoom_in,
///   label: 'ZOOM IN',
///   onPressed: () => handleZoomIn(),
/// )
///
/// // Without label
/// FiftyLabeledIconButton(
///   icon: Icons.play_arrow,
///   onPressed: () => handlePlay(),
///   size: FiftyLabeledIconButtonSize.large,
/// )
///
/// // Selected state
/// FiftyLabeledIconButton(
///   icon: Icons.grid_view,
///   label: 'Grid',
///   isSelected: _viewMode == ViewMode.grid,
///   onPressed: () => setViewMode(ViewMode.grid),
/// )
///
/// // Custom color
/// FiftyLabeledIconButton(
///   icon: Icons.delete,
///   label: 'Delete',
///   color: Colors.red,
///   onPressed: () => handleDelete(),
/// )
///
/// // Outlined style
/// FiftyLabeledIconButton(
///   icon: Icons.settings,
///   label: 'Settings',
///   style: FiftyLabeledIconButtonStyle.outlined,
///   onPressed: () => openSettings(),
/// )
/// ```
class FiftyLabeledIconButton extends StatelessWidget {
  /// Creates a Fifty-styled labeled icon button.
  const FiftyLabeledIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.label,
    this.size = FiftyLabeledIconButtonSize.medium,
    this.style = FiftyLabeledIconButtonStyle.filled,
    this.isSelected = false,
    this.color,
    this.enabled = true,
  });

  /// The icon to display.
  final IconData icon;

  /// Optional label text displayed below the icon.
  final String? label;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Size variant of the button.
  final FiftyLabeledIconButtonSize size;

  /// Style variant of the button.
  final FiftyLabeledIconButtonStyle style;

  /// Whether the button is in selected state.
  final bool isSelected;

  /// Custom color for the button. Defaults to primary color.
  final Color? color;

  /// Whether the button is enabled.
  final bool enabled;

  /// Returns the container size based on [size].
  double get _containerSize {
    switch (size) {
      case FiftyLabeledIconButtonSize.small:
        return 36;
      case FiftyLabeledIconButtonSize.medium:
        return 48;
      case FiftyLabeledIconButtonSize.large:
        return 60;
    }
  }

  /// Returns the icon size based on [size].
  double get _iconSize {
    switch (size) {
      case FiftyLabeledIconButtonSize.small:
        return 18;
      case FiftyLabeledIconButtonSize.medium:
        return 24;
      case FiftyLabeledIconButtonSize.large:
        return 28;
    }
  }

  /// Returns the label font size based on [size].
  double get _labelFontSize {
    switch (size) {
      case FiftyLabeledIconButtonSize.small:
        return 9;
      case FiftyLabeledIconButtonSize.medium:
        return 10;
      case FiftyLabeledIconButtonSize.large:
        return 11;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && onPressed != null;
    final opacity = isEnabled ? 1.0 : 0.5;
    final effectiveColor = color ?? colorScheme.primary;

    // Determine colors based on style and selection state
    Color backgroundColor;
    Color borderColor;
    Color iconColor;

    if (isSelected) {
      backgroundColor = effectiveColor.withValues(alpha: 0.2);
      borderColor = effectiveColor;
      iconColor = effectiveColor;
    } else {
      switch (style) {
        case FiftyLabeledIconButtonStyle.filled:
          backgroundColor = effectiveColor.withValues(alpha: 0.1);
          borderColor = effectiveColor.withValues(alpha: 0.3);
          iconColor = effectiveColor;
        case FiftyLabeledIconButtonStyle.outlined:
          backgroundColor = Colors.transparent;
          borderColor = colorScheme.outline;
          iconColor = colorScheme.onSurfaceVariant;
        case FiftyLabeledIconButtonStyle.ghost:
          backgroundColor = Colors.transparent;
          borderColor = Colors.transparent;
          iconColor = colorScheme.onSurfaceVariant;
      }
    }

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: _containerSize,
              height: _containerSize,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(color: borderColor),
              ),
              child: Icon(
                icon,
                size: _iconSize,
                color: iconColor,
              ),
            ),
            // Label
            if (label != null) ...[
              SizedBox(height: FiftySpacing.xs),
              Text(
                label!,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: _labelFontSize,
                  color: isSelected
                      ? effectiveColor
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
