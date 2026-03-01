import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A card-style radio button control following FDL v2 styling.
///
/// Features:
/// - Icon centered in card
/// - Label below icon
/// - Border highlight when selected with ring effect
/// - Works as part of a radio group
/// - Kinetic hover animation on icon
///
/// Example:
/// ```dart
/// Row(
///   children: [
///     Expanded(
///       child: FiftyRadioCard<ThemeMode>(
///         value: ThemeMode.light,
///         groupValue: _themeMode,
///         onChanged: (v) => setState(() => _themeMode = v),
///         icon: Icons.light_mode,
///         label: 'Light',
///       ),
///     ),
///     SizedBox(width: FiftySpacing.md),
///     Expanded(
///       child: FiftyRadioCard<ThemeMode>(
///         value: ThemeMode.dark,
///         groupValue: _themeMode,
///         onChanged: (v) => setState(() => _themeMode = v),
///         icon: Icons.dark_mode,
///         label: 'Dark',
///       ),
///     ),
///   ],
/// )
/// ```
class FiftyRadioCard<T> extends StatefulWidget {
  /// Creates a Fifty-styled radio card.
  const FiftyRadioCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.label,
    this.enabled = true,
  });

  /// The value represented by this radio card.
  final T value;

  /// The currently selected value for the group.
  ///
  /// This radio card is considered selected if [value] == [groupValue].
  final T? groupValue;

  /// Callback when this radio card is selected.
  ///
  /// If null, the radio card is disabled.
  final ValueChanged<T?>? onChanged;

  /// The icon displayed in the center of the card.
  final IconData icon;

  /// The label displayed below the icon.
  final String label;

  /// Whether the radio card is enabled.
  final bool enabled;

  @override
  State<FiftyRadioCard<T>> createState() => _FiftyRadioCardState<T>();
}

class _FiftyRadioCardState<T> extends State<FiftyRadioCard<T>> {
  bool _isHovered = false;

  bool get _isSelected => widget.value == widget.groupValue;

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final fiftyTheme = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    // Border colors per design - using theme colors
    final unselectedBorderColor = colorScheme.outline;
    final selectedBorderColor = fiftyTheme?.accent ?? colorScheme.primary;

    // Background per design - using theme colors
    final backgroundColor = colorScheme.surfaceContainerHighest;

    // Icon color per design - using theme colors
    final iconColor = colorScheme.onSurfaceVariant;

    // Label color per design - colorScheme.onSurface is mode-aware
    final labelColor = colorScheme.onSurface;

    return Semantics(
      label: widget.label,
      selected: _isSelected,
      enabled: isEnabled,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: _handleTap,
          child: Opacity(
            opacity: opacity,
            child: AnimatedContainer(
              duration: fifty.fast,
              curve: fifty.standardCurve,
              padding: EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: FiftyRadii.xlRadius,
                border: Border.all(
                  color:
                      _isSelected ? selectedBorderColor : unselectedBorderColor,
                  width: _isSelected ? 2.0 : 1.0,
                ),
                boxShadow: _isSelected
                    ? [
                        BoxShadow(
                          color: selectedBorderColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    duration: fifty.fast,
                    scale: _isHovered && isEnabled ? 1.1 : 1.0,
                    child: Icon(
                      widget.icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: FiftySpacing.xs),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FiftyTypography.medium,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
