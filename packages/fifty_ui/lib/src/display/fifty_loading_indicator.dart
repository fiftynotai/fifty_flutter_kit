import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Loading indicator styles following FDL.
///
/// - [dots]: Animated dots sequence "> LOADING..."
/// - [pulse]: Pulsing text opacity effect
/// - [static]: No animation (for reduced motion)
/// - [sequence]: Cycles through text sequences
enum FiftyLoadingStyle {
  /// Animated dots: "." -> ".." -> "..."
  dots,

  /// Pulsing text opacity effect.
  pulse,

  /// Static text with no animation.
  static,

  /// Cycles through text sequences.
  ///
  /// Use [FiftyLoadingIndicator.sequences] to provide custom sequence list.
  sequence,
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
///
/// Sequence mode example:
/// ```dart
/// FiftyLoadingIndicator(
///   style: FiftyLoadingStyle.sequence,
///   sequences: [
///     '> INITIALIZING...',
///     '> LOADING ASSETS...',
///     '> COMPILING...',
///   ],
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
    this.sequences,
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
  /// Defaults to [FiftyColors.burgundy].
  final Color? color;

  /// Custom sequence list for [FiftyLoadingStyle.sequence] mode.
  ///
  /// Each string in the list is displayed in order, cycling continuously.
  /// If null, defaults to:
  /// - '> INITIALIZING...'
  /// - '> MOUNTING...'
  /// - '> SYNCING...'
  /// - '> COMPILING...'
  final List<String>? sequences;

  /// Default sequences used when [sequences] is null.
  static const List<String> defaultSequences = [
    '> INITIALIZING...',
    '> MOUNTING...',
    '> SYNCING...',
    '> COMPILING...',
  ];

  @override
  State<FiftyLoadingIndicator> createState() => _FiftyLoadingIndicatorState();
}

class _FiftyLoadingIndicatorState extends State<FiftyLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;
  int _sequenceIndex = 0;

  List<String> get _effectiveSequences =>
      widget.sequences ?? FiftyLoadingIndicator.defaultSequences;

  @override
  void initState() {
    super.initState();

    // Different durations based on style
    final duration = widget.style == FiftyLoadingStyle.sequence
        ? const Duration(milliseconds: 1000) // 1 second per sequence item
        : const Duration(milliseconds: 450); // 3 dots * 150ms

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    )..addListener(_updateAnimation);

    // Start animation if not static
    if (widget.style != FiftyLoadingStyle.static) {
      _controller.repeat();
    }
  }

  void _updateAnimation() {
    if (widget.style == FiftyLoadingStyle.dots) {
      final newDotCount = (_controller.value * 3).floor() + 1;
      if (newDotCount != _dotCount) {
        setState(() {
          _dotCount = newDotCount.clamp(1, 3);
        });
      }
    } else if (widget.style == FiftyLoadingStyle.sequence) {
      // Update sequence index when animation completes a cycle
      if (_controller.value >= 1.0) {
        setState(() {
          _sequenceIndex = (_sequenceIndex + 1) % _effectiveSequences.length;
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
      } else {
        // Update duration based on new style
        _controller.duration = widget.style == FiftyLoadingStyle.sequence
            ? const Duration(milliseconds: 1000)
            : const Duration(milliseconds: 450);
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
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
        return FiftyTypography.bodySmall;
      case FiftyLoadingSize.medium:
        return FiftyTypography.bodyMedium;
      case FiftyLoadingSize.large:
        return FiftyTypography.bodyLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = widget.color ?? colorScheme.primary;
    final fontSize = _getFontSize();

    // Check for reduced motion preference
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // Force static style for reduced motion
    final effectiveStyle =
        reduceMotion ? FiftyLoadingStyle.static : widget.style;

    final textStyle = TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: fontSize,
      fontWeight: FiftyTypography.medium,
      color: effectiveColor,
      letterSpacing: FiftyTypography.letterSpacingLabel,
    );

    switch (effectiveStyle) {
      case FiftyLoadingStyle.dots:
        return _buildDotsIndicator(textStyle);
      case FiftyLoadingStyle.pulse:
        return _buildPulseIndicator(textStyle);
      case FiftyLoadingStyle.static:
        return _buildStaticIndicator(textStyle);
      case FiftyLoadingStyle.sequence:
        return _buildSequenceIndicator(textStyle);
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

  Widget _buildSequenceIndicator(TextStyle style) {
    final sequences = _effectiveSequences;
    final currentSequence = sequences[_sequenceIndex % sequences.length];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Text(
        currentSequence,
        key: ValueKey(_sequenceIndex),
        style: style,
      ),
    );
  }
}
