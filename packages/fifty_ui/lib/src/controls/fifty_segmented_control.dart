import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Visual variants for [FiftySegmentedControl].
enum FiftySegmentedControlVariant {
  /// Cream background with burgundy text.
  /// Used for content filters (Daily/Weekly/Monthly).
  primary,

  /// Slate-grey background with cream text.
  /// Used for system settings (Light/Dark/System).
  secondary,
}

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
/// - Two visual variants: primary and secondary
/// - Icon + label support
/// - Responsive expanded mode
///
/// **Variants:**
/// - [FiftySegmentedControlVariant.primary]: Cream background with burgundy text.
///   Use for content filters (Daily/Weekly/Monthly).
/// - [FiftySegmentedControlVariant.secondary]: Slate-grey background with cream text.
///   Use for system settings (Light/Dark/System).
///
/// Primary variant example (default):
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
/// Secondary variant example:
/// ```dart
/// FiftySegmentedControl<ThemeMode>(
///   variant: FiftySegmentedControlVariant.secondary,
///   segments: [
///     FiftySegment(value: ThemeMode.light, label: 'Light'),
///     FiftySegment(value: ThemeMode.dark, label: 'Dark'),
///     FiftySegment(value: ThemeMode.system, label: 'System'),
///   ],
///   selected: _themeMode,
///   onChanged: (value) => setState(() => _themeMode = value),
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
    this.variant = FiftySegmentedControlVariant.primary,
    this.expanded = false,
    this.enabled = true,
  });

  /// The visual variant of the segmented control.
  ///
  /// - [FiftySegmentedControlVariant.primary]: Cream background with burgundy text
  /// - [FiftySegmentedControlVariant.secondary]: Slate-grey background with cream text
  ///
  /// Defaults to [FiftySegmentedControlVariant.primary].
  final FiftySegmentedControlVariant variant;

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
    final colorScheme = theme.colorScheme;

    final containerColor = colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outline;

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
                      variant: variant,
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
                    variant: variant,
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
    required this.variant,
    required this.onTap,
  });

  final FiftySegment<T> segment;
  final bool isSelected;
  final FiftySegmentedControlVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Active colors are variant-based (mode-independent)
    // Primary: light background with primary text (for content filters)
    // Secondary: muted background with light text (for system settings)
    final activeColor = variant == FiftySegmentedControlVariant.primary
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;
    final activeTextColor = variant == FiftySegmentedControlVariant.primary
        ? colorScheme.primary
        : colorScheme.onPrimary;
    final inactiveTextColor = colorScheme.onSurfaceVariant;

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
            Flexible(
              child: Text(
                segment.label,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyMedium,
                  fontWeight: isSelected
                      ? FiftyTypography.semiBold
                      : FiftyTypography.medium,
                  color: isSelected ? activeTextColor : inactiveTextColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
