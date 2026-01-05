/// Section Header Widget
///
/// A styled section header for organizing demo content.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A section header widget.
///
/// Displays a title with optional subtitle and trailing widget.
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
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyHeadline,
                      fontSize: FiftyTypography.body,
                      fontWeight: FontWeight.bold,
                      color: FiftyColors.crimsonPulse,
                      letterSpacing: 2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.mono,
                        color: FiftyColors.hyperChrome,
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
            color: FiftyColors.border,
          ),
        ],
        const SizedBox(height: FiftySpacing.md),
      ],
    );
  }
}
