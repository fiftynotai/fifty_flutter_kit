import 'package:flutter/material.dart';

/// **FiftyCursor**
///
/// An animated blinking cursor widget for text input or typing animations.
/// Follows FDL v2 design patterns with theme-aware colors.
///
/// Features:
/// - Smooth fade animation for blinking effect
/// - Customizable dimensions
/// - Customizable blink duration
/// - Theme-aware default color
///
/// **Why**
/// - Provides consistent cursor animation across the ecosystem
/// - Useful for dialogue systems, typing effects, and input indicators
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage (uses primary color)
/// Row(
///   children: [
///     Text('Type here'),
///     FiftyCursor(),
///   ],
/// )
///
/// // Custom color and size
/// FiftyCursor(
///   color: Colors.green,
///   width: 3,
///   height: 24,
/// )
///
/// // Custom blink speed
/// FiftyCursor(
///   blinkDuration: Duration(milliseconds: 300),
/// )
///
/// // In a dialogue display
/// Row(
///   children: [
///     Expanded(child: Text(displayedText)),
///     if (isTyping) const FiftyCursor(),
///   ],
/// )
/// ```
class FiftyCursor extends StatefulWidget {
  /// Creates a Fifty-styled blinking cursor.
  const FiftyCursor({
    super.key,
    this.color,
    this.width = 2,
    this.height = 20,
    this.blinkDuration = const Duration(milliseconds: 500),
  });

  /// The color of the cursor. Defaults to primary color.
  final Color? color;

  /// The width of the cursor.
  final double width;

  /// The height of the cursor.
  final double height;

  /// Duration of one blink cycle (fade in + fade out).
  final Duration blinkDuration;

  @override
  State<FiftyCursor> createState() => _FiftyCursorState();
}

class _FiftyCursorState extends State<FiftyCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.blinkDuration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(FiftyCursor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blinkDuration != widget.blinkDuration) {
      _controller.duration = widget.blinkDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cursorColor = widget.color ?? colorScheme.primary;

    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: cursorColor,
      ),
    );
  }
}
