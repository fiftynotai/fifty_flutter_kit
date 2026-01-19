import 'package:flutter/material.dart';

/// A widget that adds a glowing effect around its child.
///
/// This is a simple, non-animated glow effect using box shadows.
/// For animated glow, use [PulseAnimationWidget].
///
/// **Example:**
/// ```dart
/// GlowAnimationWidget(
///   enabled: isSelected,
///   color: Colors.amber,
///   blurRadius: 12,
///   child: SkillNodeWidget(...),
/// )
/// ```
class GlowAnimationWidget extends StatelessWidget {
  /// Creates a glow animation widget.
  ///
  /// **Parameters:**
  /// - [child]: The widget to wrap with glow
  /// - [enabled]: Whether the glow is visible (default true)
  /// - [color]: Color of the glow
  /// - [blurRadius]: Blur radius of the glow (default 8)
  /// - [spreadRadius]: Spread radius of the glow (default 0)
  /// - [opacity]: Opacity of the glow (default 0.5)
  const GlowAnimationWidget({
    super.key,
    required this.child,
    this.enabled = true,
    this.color = const Color(0xFFFFD700),
    this.blurRadius = 8,
    this.spreadRadius = 0,
    this.opacity = 0.5,
  });

  /// The widget to wrap with glow.
  final Widget child;

  /// Whether the glow is visible.
  final bool enabled;

  /// Color of the glow.
  final Color color;

  /// Blur radius of the glow.
  final double blurRadius;

  /// Spread radius of the glow.
  final double spreadRadius;

  /// Opacity of the glow.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((opacity * 255).toInt()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
