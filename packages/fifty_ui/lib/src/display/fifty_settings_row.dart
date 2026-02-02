import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **FiftySettingsRow**
///
/// A settings row widget with icon, label, and toggle switch for boolean settings.
/// Follows FDL v2 design patterns with theme-aware colors.
///
/// Features:
/// - Optional leading icon with colored background
/// - Label text with optional subtitle
/// - FiftySwitch toggle on the right
/// - Optional trailing text (e.g., current value description)
/// - Disabled state support
/// - Tap handler for the entire row
///
/// **Why**
/// - Provides consistent settings UI across the ecosystem
/// - Integrates with FiftySwitch for toggle functionality
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage
/// FiftySettingsRow(
///   label: 'Dark Mode',
///   value: _isDarkMode,
///   onChanged: (value) => setState(() => _isDarkMode = value),
/// )
///
/// // With icon and subtitle
/// FiftySettingsRow(
///   label: 'Notifications',
///   subtitle: 'Receive push notifications',
///   icon: Icons.notifications,
///   value: _notificationsEnabled,
///   onChanged: (value) => setState(() => _notificationsEnabled = value),
/// )
///
/// // With trailing text
/// FiftySettingsRow(
///   label: 'Auto-save',
///   trailingText: 'Every 5 min',
///   value: _autoSaveEnabled,
///   onChanged: (value) => setState(() => _autoSaveEnabled = value),
/// )
///
/// // Disabled state
/// FiftySettingsRow(
///   label: 'Premium Feature',
///   subtitle: 'Upgrade to unlock',
///   value: false,
///   onChanged: null,
///   enabled: false,
/// )
/// ```
class FiftySettingsRow extends StatelessWidget {
  /// Creates a Fifty-styled settings row.
  const FiftySettingsRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailingText,
    this.enabled = true,
    this.switchSize = FiftySwitchSize.medium,
  });

  /// The primary label text.
  final String label;

  /// Optional subtitle text displayed below the label.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// Color for the leading icon. Defaults to primary color.
  final Color? iconColor;

  /// Optional text displayed before the switch.
  final String? trailingText;

  /// Whether the switch is on or off.
  final bool value;

  /// Callback when the switch is toggled.
  ///
  /// If null, the row is non-interactive.
  final ValueChanged<bool>? onChanged;

  /// Whether the row is enabled.
  final bool enabled;

  /// Size variant of the switch.
  final FiftySwitchSize switchSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged?.call(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FiftySpacing.sm),
          child: Row(
            children: [
              // Leading icon
              if (icon != null) ...[
                _buildIcon(colorScheme),
                const SizedBox(width: FiftySpacing.md),
              ],
              // Label and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyMedium,
                        fontWeight: FiftyTypography.medium,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.labelMedium,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Trailing text
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelMedium,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
              ],
              // Switch
              FiftySwitch(
                value: value,
                onChanged: isEnabled ? onChanged : null,
                enabled: isEnabled,
                size: switchSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    final color = iconColor ?? colorScheme.primary;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: FiftyRadii.mdRadius,
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }
}
