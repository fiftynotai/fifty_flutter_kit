/// What's New Section
///
/// Displays recent updates and releases in the Fifty ecosystem.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// What's New section showing recent updates and releases.
///
/// Displays a list of recent updates with date badges and descriptions.
class WhatsNewSection extends StatelessWidget {
  /// Creates the what's new section.
  const WhatsNewSection({super.key});

  /// List of recent updates to display.
  static const List<_UpdateItem> _updates = [
    _UpdateItem(
      date: 'JAN 2026',
      title: 'FDL V2 COMPONENTS',
      description: 'New design tokens and UI components',
    ),
    _UpdateItem(
      date: 'JAN 2026',
      title: 'FIFTY_FORMS PACKAGE',
      description: 'Form validation and input handling',
    ),
    _UpdateItem(
      date: 'DEC 2025',
      title: 'SKILL TREE ENGINE',
      description: 'RPG-style skill progression system',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < _updates.length; i++) ...[
            _UpdateItemWidget(item: _updates[i]),
            if (i < _updates.length - 1)
              Divider(
                color: colorScheme.outline,
                height: 1,
                indent: FiftySpacing.lg,
                endIndent: FiftySpacing.lg,
              ),
          ],
        ],
      ),
    );
  }
}

/// Data model for an update item.
class _UpdateItem {
  /// Creates an update item.
  const _UpdateItem({
    required this.date,
    required this.title,
    required this.description,
  });

  /// Date label for the update.
  final String date;

  /// Title of the update.
  final String title;

  /// Description of the update.
  final String description;
}

/// Widget to display a single update item.
class _UpdateItemWidget extends StatelessWidget {
  /// Creates an update item widget.
  const _UpdateItemWidget({required this.item});

  final _UpdateItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.sm,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              item.date,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.25,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  item.description,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
