import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';

/// **FilterPriceRange**
///
/// Dual-thumb price range slider with text inputs.
///
/// **Features:**
/// - Min and max price inputs
/// - Range slider with dual thumbs
/// - Live update of matching product count
/// - Currency formatting
///
/// **Example Usage:**
/// ```dart
/// FilterPriceRange(
///   min: 0,
///   max: 1000,
///   currentMin: 100,
///   currentMax: 500,
///   onChanged: (range) => setState(() {
///     minPrice = range.start;
///     maxPrice = range.end;
///   }),
///   matchingCount: 24,
/// )
/// ```
class FilterPriceRange extends StatefulWidget {
  /// Absolute minimum price value.
  final double min;

  /// Absolute maximum price value.
  final double max;

  /// Current minimum price selection.
  final double currentMin;

  /// Current maximum price selection.
  final double currentMax;

  /// Callback when range values change.
  final ValueChanged<RangeValues> onChanged;

  /// Number of products matching current range (optional).
  final int? matchingCount;

  /// Currency symbol to display.
  final String currencySymbol;

  /// Creates a [FilterPriceRange] with the specified parameters.
  const FilterPriceRange({
    required this.min,
    required this.max,
    required this.currentMin,
    required this.currentMax,
    required this.onChanged,
    this.matchingCount,
    this.currencySymbol = '\$',
    super.key,
  });

  @override
  State<FilterPriceRange> createState() => _FilterPriceRangeState();
}

class _FilterPriceRangeState extends State<FilterPriceRange> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.currentMin, widget.currentMax);
    _minController = TextEditingController(
      text: _formatPrice(widget.currentMin),
    );
    _maxController = TextEditingController(
      text: _formatPrice(widget.currentMax),
    );
  }

  @override
  void didUpdateWidget(FilterPriceRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMin != widget.currentMin ||
        oldWidget.currentMax != widget.currentMax) {
      _currentRange = RangeValues(widget.currentMin, widget.currentMax);
      _minController.text = _formatPrice(widget.currentMin);
      _maxController.text = _formatPrice(widget.currentMax);
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _onSliderChanged(RangeValues values) {
    setState(() {
      _currentRange = values;
      _minController.text = _formatPrice(values.start);
      _maxController.text = _formatPrice(values.end);
    });
    widget.onChanged(values);
  }

  void _onMinFieldChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      final newMin = parsed.clamp(widget.min, _currentRange.end);
      setState(() {
        _currentRange = RangeValues(newMin, _currentRange.end);
      });
      widget.onChanged(_currentRange);
    }
  }

  void _onMaxFieldChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      final newMax = parsed.clamp(_currentRange.start, widget.max);
      setState(() {
        _currentRange = RangeValues(_currentRange.start, newMax);
      });
      widget.onChanged(_currentRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: SneakerColors.cream,
                letterSpacing: 0.5,
              ),
            ),
            if (widget.matchingCount != null)
              Text(
                '${widget.matchingCount} items',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: SneakerColors.slateGrey,
                ),
              ),
          ],
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Input fields row
        Row(
          children: [
            Expanded(child: _buildPriceInput('Min', _minController, _onMinFieldChanged)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SneakerSpacing.sm),
              child: Container(
                width: 16,
                height: 1,
                color: SneakerColors.slateGrey,
              ),
            ),
            Expanded(child: _buildPriceInput('Max', _maxController, _onMaxFieldChanged)),
          ],
        ),
        const SizedBox(height: SneakerSpacing.lg),

        // Range slider
        SliderTheme(
          data: SliderThemeData(
            rangeThumbShape: _PriceRangeThumbShape(),
            rangeTrackShape: _PriceRangeTrackShape(),
            overlayColor: SneakerColors.burgundy.withValues(alpha: 0.2),
            activeTrackColor: SneakerColors.burgundy,
            inactiveTrackColor: SneakerColors.border,
            thumbColor: SneakerColors.cream,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: RangeSlider(
            values: _currentRange,
            min: widget.min,
            max: widget.max,
            divisions: ((widget.max - widget.min) / 10).round(),
            onChanged: _onSliderChanged,
          ),
        ),

        // Range labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.currencySymbol}${_formatPrice(widget.min)}',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  color: SneakerColors.slateGrey.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '${widget.currencySymbol}${_formatPrice(widget.max)}',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  color: SneakerColors.slateGrey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInput(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: SneakerColors.slateGrey,
          ),
        ),
        const SizedBox(height: SneakerSpacing.xs),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: SneakerColors.surfaceDark,
            borderRadius: SneakerRadii.radiusSm,
            border: Border.all(color: SneakerColors.border),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: SneakerSpacing.sm),
                child: Text(
                  widget.currencySymbol,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SneakerColors.slateGrey,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SneakerColors.cream,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SneakerSpacing.xs,
                      vertical: SneakerSpacing.sm,
                    ),
                    isDense: true,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom thumb shape for the range slider.
class _PriceRangeThumbShape extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 20);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final canvas = context.canvas;

    // Outer circle (border)
    final borderPaint = Paint()
      ..color = SneakerColors.burgundy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Inner circle (fill)
    final fillPaint = Paint()
      ..color = SneakerColors.cream
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 8, fillPaint);
    canvas.drawCircle(center, 8, borderPaint);
  }
}

/// Custom track shape for the range slider.
class _PriceRangeTrackShape extends RangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = true,
    bool isDiscrete = false,
  }) {
    const trackHeight = 4.0;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = true,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final canvas = context.canvas;
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    // Inactive track (full width)
    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? SneakerColors.border
      ..style = PaintingStyle.fill;

    final inactiveRRect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    canvas.drawRRect(inactiveRRect, inactivePaint);

    // Active track (between thumbs)
    final activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? SneakerColors.burgundy
      ..style = PaintingStyle.fill;

    final activeRect = Rect.fromLTRB(
      startThumbCenter.dx,
      rect.top,
      endThumbCenter.dx,
      rect.bottom,
    );
    final activeRRect = RRect.fromRectAndRadius(activeRect, const Radius.circular(2));
    canvas.drawRRect(activeRRect, activePaint);
  }
}
