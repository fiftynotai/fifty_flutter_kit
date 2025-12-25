import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Loading indicator styles following FDL.
///
/// - [dots]: Animated dots sequence "> LOADING..."
/// - [pulse]: Pulsing text opacity effect
/// - [static]: No animation (for reduced motion)
enum FiftyLoadingStyle {
  /// Animated dots: "." -> ".." -> "..."
  dots,

  /// Pulsing text opacity effect.
  pulse,

  /// Static text with no animation.
  static,
}

/// Loading indicator sizes.
enum FiftyLoadingSize {
  /// Small size (12px font).
  small,

  /// Medium size (14px font).
  medium,

  /// Large size (16px font).
  large,
}

/// FDL-compliant loading indicator using text sequences.
///
/// Displays "> LOADING..." with animated dots instead of a spinner.
/// Respects reduced-motion accessibility settings.
///
/// **FDL Rule:** "Loading: Never use a spinner. Use text sequences."
///
/// Example:
/// ```dart
/// FiftyLoadingIndicator(
///   text: 'LOADING',
///   style: FiftyLoadingStyle.dots,
///   size: FiftyLoadingSize.medium,
/// )
/// ```
class FiftyLoadingIndicator extends StatefulWidget {
  /// Creates a Fifty-styled loading indicator.
  const FiftyLoadingIndicator({
    super.key,
    this.text = 'LOADING',
    this.style = FiftyLoadingStyle.dots,
    this.size = FiftyLoadingSize.medium,
    this.color,
    @Deprecated('Use size parameter instead. Will be removed in v1.0.0')
    // ignore: unused_element
    double? legacySize,
    @Deprecated('No longer used. Will be removed in v1.0.0')
    // ignore: unused_element
    double? strokeWidth,
  });

  /// The loading text to display.
  ///
  /// Displayed in uppercase with "> " prefix.
  final String text;

  /// The animation style for the indicator.
  ///
  /// Defaults to [FiftyLoadingStyle.dots].
  final FiftyLoadingStyle style;

  /// The size of the indicator.
  ///
  /// Defaults to [FiftyLoadingSize.medium].
  final FiftyLoadingSize size;

  /// The color of the text.
  ///
  /// Defaults to [FiftyColors.crimsonPulse].
  final Color? color;

  @override
  State<FiftyLoadingIndicator> createState() => _FiftyLoadingIndicatorState();
}

class _FiftyLoadingIndicatorState extends State<FiftyLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450), // 3 dots * 150ms
    )..addListener(_updateDots);

    // Start animation if not static
    if (widget.style != FiftyLoadingStyle.static) {
      _controller.repeat();
    }
  }

  void _updateDots() {
    if (widget.style == FiftyLoadingStyle.dots) {
      final newDotCount = (_controller.value * 3).floor() + 1;
      if (newDotCount != _dotCount) {
        setState(() {
          _dotCount = newDotCount.clamp(1, 3);
        });
      }
    }
  }

  @override
  void didUpdateWidget(FiftyLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style != oldWidget.style) {
      if (widget.style == FiftyLoadingStyle.static) {
        _controller.stop();
      } else if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getFontSize() {
    switch (widget.size) {
      case FiftyLoadingSize.small:
        return 12;
      case FiftyLoadingSize.medium:
        return 14;
      case FiftyLoadingSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? FiftyColors.crimsonPulse;
    final fontSize = _getFontSize();

    // Check for reduced motion preference
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // Force static style for reduced motion
    final effectiveStyle =
        reduceMotion ? FiftyLoadingStyle.static : widget.style;

    final textStyle = TextStyle(
      fontFamily: FiftyTypography.fontFamilyMono,
      fontSize: fontSize,
      fontWeight: FiftyTypography.medium,
      color: effectiveColor,
      letterSpacing: FiftyTypography.tight * fontSize,
    );

    switch (effectiveStyle) {
      case FiftyLoadingStyle.dots:
        return _buildDotsIndicator(textStyle);
      case FiftyLoadingStyle.pulse:
        return _buildPulseIndicator(textStyle);
      case FiftyLoadingStyle.static:
        return _buildStaticIndicator(textStyle);
    }
  }

  Widget _buildDotsIndicator(TextStyle style) {
    final dots = '.' * _dotCount;
    final padding = '.' * (3 - _dotCount);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '> ${widget.text.toUpperCase()}'),
          TextSpan(text: dots),
          // Invisible padding to prevent layout shift
          TextSpan(
            text: padding,
            style: style.copyWith(color: Colors.transparent),
          ),
        ],
      ),
      style: style,
    );
  }

  Widget _buildPulseIndicator(TextStyle style) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Pulse between 0.5 and 1.0 opacity
        final opacity = 0.5 + (0.5 * (0.5 + 0.5 * _controller.value));
        return Opacity(
          opacity: opacity,
          child: Text(
            '> ${widget.text.toUpperCase()}...',
            style: style,
          ),
        );
      },
    );
  }

  Widget _buildStaticIndicator(TextStyle style) {
    return Text(
      '> ${widget.text.toUpperCase()}...',
      style: style,
    );
  }
}
