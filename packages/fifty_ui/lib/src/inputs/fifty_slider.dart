import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A styled slider following FDL v2 design principles.
///
/// Features:
/// - Mode-aware track styling
/// - Primary color active track fill
/// - Rounded thumb with border
/// - Optional value label display
/// - Kinetic hover/drag feedback
/// - Manrope typography
///
/// Example:
/// ```dart
/// FiftySlider(
///   value: _volume,
///   onChanged: (value) => setState(() => _volume = value),
///   min: 0,
///   max: 100,
///   showLabel: true,
/// )
/// ```
class FiftySlider extends StatefulWidget {
  /// Creates a Fifty-styled slider.
  const FiftySlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showLabel = false,
    this.labelBuilder,
    this.enabled = true,
  });

  /// Current value of the slider.
  final double value;

  /// Callback when the value changes.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions.
  ///
  /// If null, the slider is continuous.
  final int? divisions;

  /// Optional label shown above the slider.
  final String? label;

  /// Whether to show the value label above the thumb.
  final bool showLabel;

  /// Custom label builder for the value display.
  ///
  /// If null, displays the value as an integer percentage of max.
  final String Function(double value)? labelBuilder;

  /// Whether the slider is enabled.
  final bool enabled;

  @override
  State<FiftySlider> createState() => _FiftySliderState();
}

class _FiftySliderState extends State<FiftySlider> {
  bool _isDragging = false;
  bool _isHovered = false;

  double get _normalizedValue =>
      ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  String get _valueLabel {
    if (widget.labelBuilder != null) {
      return widget.labelBuilder!(widget.value);
    }
    return widget.value.round().toString();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;
    setState(() => _isDragging = true);
  }

  void _handleDragUpdate(DragUpdateDetails details, double trackWidth) {
    if (!widget.enabled || widget.onChanged == null) return;

    final localPosition = details.localPosition.dx;
    final newNormalized = (localPosition / trackWidth).clamp(0.0, 1.0);
    var newValue = widget.min + newNormalized * (widget.max - widget.min);

    // Apply divisions if specified
    if (widget.divisions != null) {
      final step = (widget.max - widget.min) / widget.divisions!;
      newValue = (newValue / step).round() * step;
    }

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
  }

  void _handleTap(TapUpDetails details, double trackWidth) {
    if (!widget.enabled || widget.onChanged == null) return;

    final localPosition = details.localPosition.dx;
    final newNormalized = (localPosition / trackWidth).clamp(0.0, 1.0);
    var newValue = widget.min + newNormalized * (widget.max - widget.min);

    if (widget.divisions != null) {
      final step = (widget.max - widget.min) / widget.divisions!;
      newValue = (newValue / step).round() * step;
    }

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    final labelColor = isDark ? FiftyColors.slateGrey : Colors.grey[600];
    final trackBackgroundColor = isDark
        ? FiftyColors.slateGrey.withValues(alpha: 0.3)
        : FiftyColors.borderLight;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    final fillColor = isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight;

    const trackHeight = 4.0;
    const thumbSize = 20.0;

    return Opacity(
      opacity: opacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.bold,
                color: labelColor,
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              ),
            ),
            const SizedBox(height: FiftySpacing.sm),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;

              return MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                cursor: isEnabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onHorizontalDragStart: _handleDragStart,
                  onHorizontalDragUpdate: (details) =>
                      _handleDragUpdate(details, trackWidth),
                  onHorizontalDragEnd: _handleDragEnd,
                  onTapUp: (details) => _handleTap(details, trackWidth),
                  child: SizedBox(
                    height: thumbSize + (widget.showLabel ? 24 : 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Track background
                        Positioned(
                          left: 0,
                          right: 0,
                          top: widget.showLabel
                              ? 24 + (thumbSize - trackHeight) / 2
                              : (thumbSize - trackHeight) / 2,
                          child: Container(
                            height: trackHeight,
                            decoration: BoxDecoration(
                              color: trackBackgroundColor,
                              borderRadius:
                                  BorderRadius.circular(trackHeight / 2),
                            ),
                          ),
                        ),

                        // Active track
                        Positioned(
                          left: 0,
                          top: widget.showLabel
                              ? 24 + (thumbSize - trackHeight) / 2
                              : (thumbSize - trackHeight) / 2,
                          child: AnimatedContainer(
                            duration:
                                _isDragging ? Duration.zero : fifty.fast,
                            width: trackWidth * _normalizedValue,
                            height: trackHeight,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(trackHeight / 2),
                            ),
                          ),
                        ),

                        // Value label (positioned above thumb, centered)
                        if (widget.showLabel)
                          Positioned(
                            // Position at thumb center
                            left: (trackWidth - thumbSize) * _normalizedValue +
                                thumbSize / 2,
                            top: 0,
                            child: AnimatedOpacity(
                              duration: fifty.fast,
                              opacity: (_isDragging || _isHovered) ? 1.0 : 0.0,
                              child: FractionalTranslation(
                                // Shift left by 50% to center, up slightly for gap
                                translation: const Offset(-0.5, -0.2),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: FiftySpacing.sm,
                                    vertical: FiftySpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: fillColor,
                                    borderRadius: FiftyRadii.lgRadius,
                                    border: Border.all(
                                      color: colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _valueLabel,
                                    style: TextStyle(
                                      fontFamily: FiftyTypography.fontFamily,
                                      fontSize: FiftyTypography.bodySmall,
                                      fontWeight: FiftyTypography.medium,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Thumb (vertically centered on track)
                        Positioned(
                          left: (trackWidth - thumbSize) * _normalizedValue,
                          top: widget.showLabel ? 24.0 : 0,
                          child: AnimatedScale(
                            duration: fifty.fast,
                            scale: _isDragging ? 1.1 : 1.0,
                            child: Container(
                              width: thumbSize,
                              height: thumbSize,
                              decoration: BoxDecoration(
                                color: fillColor,
                                borderRadius: FiftyRadii.smRadius,
                                border: Border.all(
                                  color: (_isDragging || _isHovered)
                                      ? colorScheme.primary
                                      : borderColor,
                                  width: 2,
                                ),
                                boxShadow: (_isDragging || _isHovered)
                                    ? fifty.shadowGlow
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
