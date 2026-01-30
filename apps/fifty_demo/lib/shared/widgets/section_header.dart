/// Section Header Widget
///
/// A styled section header for organizing demo content.
/// Uses theme-aware colors for light/dark mode support.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A section header widget.
///
/// Displays a title with optional subtitle and trailing widget.
/// Uses theme-aware colors via [ColorScheme].
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.showDivider = true,
  });

  /// The section title.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Whether to show a divider line.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: FiftySpacing.sm),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodyLarge,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: FiftySpacing.sm),
          Container(
            height: 1,
            color: colorScheme.outline,
          ),
        ],
        const SizedBox(height: FiftySpacing.md),
      ],
    );
  }
}
