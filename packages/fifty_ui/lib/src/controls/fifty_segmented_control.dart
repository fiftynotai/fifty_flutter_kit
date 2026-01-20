import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A segment option for [FiftySegmentedControl].
class FiftySegment<T> {
  /// Creates a segment option.
  const FiftySegment({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The value associated with this segment.
  final T value;

  /// The display label for this segment.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;
}

/// A segmented control following FDL v2 styling.
///
/// Features:
/// - Pill-style segments with animated selection
/// - Dark mode: slateGrey active background
/// - Light mode: cream active background
/// - Icon + label support
/// - Responsive expanded mode
///
/// **CRITICAL v2 DESIGN DECISION:**
/// Active segments use [FiftyColors.slateGrey] in dark mode and
/// [FiftyColors.cream] in light mode, NOT the primary color!
///
/// Example:
/// ```dart
/// FiftySegmentedControl<String>(
///   segments: [
///     FiftySegment(value: 'daily', label: 'Daily'),
///     FiftySegment(value: 'weekly', label: 'Weekly'),
///     FiftySegment(value: 'monthly', label: 'Monthly'),
///   ],
///   selected: _period,
///   onChanged: (value) => setState(() => _period = value),
/// )
/// ```
///
/// With icons:
/// ```dart
/// FiftySegmentedControl<ViewMode>(
///   segments: [
///     FiftySegment(value: ViewMode.grid, label: 'Grid', icon: Icons.grid_view),
///     FiftySegment(value: ViewMode.list, label: 'List', icon: Icons.list),
///   ],
///   selected: _viewMode,
///   onChanged: (value) => setState(() => _viewMode = value),
///   expanded: true,
/// )
/// ```
class FiftySegmentedControl<T> extends StatelessWidget {
  /// Creates a Fifty-styled segmented control.
  const FiftySegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expanded = false,
    this.enabled = true,
  });

  /// The available segment options.
  final List<FiftySegment<T>> segments;

  /// The currently selected value.
  final T selected;

  /// Callback when the selection changes.
  final ValueChanged<T> onChanged;

  /// Whether the control expands to fill available width.
  ///
  /// When true, segments are evenly distributed.
  /// Defaults to false.
  final bool expanded;

  /// Whether the control is enabled.
  ///
  /// When false, the control is disabled and non-interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerColor = isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: FiftyRadii.xlRadius,
          border: Border.all(color: borderColor),
        ),
        child: expanded
            ? Row(
                children: segments.map((segment) {
                  final isSelected = segment.value == selected;
                  return Expanded(
                    child: _FiftySegmentItem<T>(
                      segment: segment,
                      isSelected: isSelected,
                      isDark: isDark,
                      onTap: enabled ? () => onChanged(segment.value) : null,
                    ),
                  );
                }).toList(),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: segments.map((segment) {
                  final isSelected = segment.value == selected;
                  return _FiftySegmentItem<T>(
                    segment: segment,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: enabled ? () => onChanged(segment.value) : null,
                  );
                }).toList(),
              ),
      ),
    );
  }
}

/// Individual segment item widget.
class _FiftySegmentItem<T> extends StatelessWidget {
  const _FiftySegmentItem({
    required this.segment,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final FiftySegment<T> segment;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // v2 design: slateGrey for dark mode, cream for light mode
    final activeColor = isDark ? FiftyColors.slateGrey : FiftyColors.cream;
    final activeTextColor = isDark ? FiftyColors.cream : FiftyColors.darkBurgundy;
    final inactiveTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: FiftyMotion.fast,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: FiftyRadii.lgRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (segment.icon != null) ...[
              Icon(
                segment.icon,
                size: 18,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
              const SizedBox(width: FiftySpacing.sm),
            ],
            Text(
              segment.label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: isSelected
                    ? FiftyTypography.semiBold
                    : FiftyTypography.medium,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
