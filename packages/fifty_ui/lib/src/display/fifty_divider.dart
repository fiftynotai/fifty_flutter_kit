import 'package:flutter/material.dart';

/// A themed divider following FDL v2 styling.
///
/// Features:
/// - Horizontal or vertical orientation
/// - Customizable thickness and indentation
/// - Mode-aware border colors
///
/// Example:
/// ```dart
/// FiftyDivider() // Horizontal divider
/// FiftyDivider(vertical: true, height: 40) // Vertical divider
/// ```
class FiftyDivider extends StatelessWidget {
  /// Creates a Fifty-styled divider.
  const FiftyDivider({
    super.key,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.vertical = false,
    this.height,
    this.width,
    this.color,
  });

  /// The thickness of the divider line.
  final double thickness;

  /// The amount of empty space before the divider.
  final double indent;

  /// The amount of empty space after the divider.
  final double endIndent;

  /// Whether the divider is vertical.
  ///
  /// When true, creates a vertical line.
  final bool vertical;

  /// The height of the divider (for vertical) or spacing (for horizontal).
  final double? height;

  /// The width of the divider (for horizontal) or spacing (for vertical).
  final double? width;

  /// The color of the divider.
  ///
  /// Defaults to mode-aware border color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.outline;

    if (vertical) {
      return Container(
        height: height,
        width: thickness,
        margin: EdgeInsets.only(
          top: indent,
          bottom: endIndent,
          left: width != null ? (width! - thickness) / 2 : 0,
          right: width != null ? (width! - thickness) / 2 : 0,
        ),
        color: effectiveColor,
      );
    }

    return Container(
      height: thickness,
      margin: EdgeInsets.only(
        left: indent,
        right: endIndent,
        top: height != null ? (height! - thickness) / 2 : 0,
        bottom: height != null ? (height! - thickness) / 2 : 0,
      ),
      color: effectiveColor,
    );
  }
}
