import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// **FiftyInfoRow**
///
/// A simple key-value row display widget for showing labeled information.
/// Follows FDL v2 design patterns with theme-aware colors.
///
/// Features:
/// - Label text on the left
/// - Value text on the right
/// - Optional leading icon
/// - Optional custom value color
/// - Optional tap handler
/// - Consistent spacing and typography
///
/// **Why**
/// - Provides consistent information display across the ecosystem
/// - Useful for detail views, metadata display, and summaries
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage
/// FiftyInfoRow(
///   label: 'Status',
///   value: 'Active',
/// )
///
/// // With icon
/// FiftyInfoRow(
///   label: 'Email',
///   value: 'user@example.com',
///   icon: Icons.email,
/// )
///
/// // With custom value color
/// FiftyInfoRow(
///   label: 'Balance',
///   value: '\$1,234.56',
///   valueColor: Colors.green,
/// )
///
/// // Tappable row
/// FiftyInfoRow(
///   label: 'Website',
///   value: 'www.example.com',
///   icon: Icons.link,
///   onTap: () => launchUrl(url),
/// )
///
/// // In a list
/// Column(
///   children: [
///     FiftyInfoRow(label: 'Name', value: 'John Doe'),
///     FiftyInfoRow(label: 'Role', value: 'Developer'),
///     FiftyInfoRow(label: 'Location', value: 'San Francisco'),
///   ],
/// )
/// ```
class FiftyInfoRow extends StatelessWidget {
  /// Creates a Fifty-styled info row.
  const FiftyInfoRow({
    required this.label,
    required this.value,
    super.key,
    this.icon,
    this.valueColor,
    this.onTap,
    this.labelStyle,
    this.valueStyle,
  });

  /// The label text (key).
  final String label;

  /// The value text.
  final String value;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional custom color for the value text.
  final Color? valueColor;

  /// Called when the row is tapped.
  final VoidCallback? onTap;

  /// Optional custom style for the label text.
  final TextStyle? labelStyle;

  /// Optional custom style for the value text.
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final defaultLabelStyle = TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: FiftyTypography.bodySmall,
      color: colorScheme.onSurfaceVariant,
    );

    final defaultValueStyle = TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: FiftyTypography.bodySmall,
      fontWeight: FiftyTypography.medium,
      color: valueColor ?? colorScheme.onSurface,
    );

    final content = Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.sm),
      child: Row(
        children: [
          // Leading icon
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: FiftySpacing.sm),
          ],
          // Label
          Text(
            label,
            style: labelStyle ?? defaultLabelStyle,
          ),
          const Spacer(),
          // Value
          Text(
            value,
            style: valueStyle ?? defaultValueStyle,
          ),
          // Chevron for tappable rows
          if (onTap != null) ...[
            SizedBox(width: FiftySpacing.xs),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
