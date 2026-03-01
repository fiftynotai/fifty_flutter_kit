/// Entity Info Panel Widget
///
/// Displays information about a selected map entity.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Entity info panel widget.
///
/// Shows details about a selected entity on the map.
class EntityInfoPanel extends StatelessWidget {
  const EntityInfoPanel({
    required this.entityId,
    required this.entityType,
    super.key,
    this.entityName,
    this.x,
    this.y,
    this.onClose,
  });

  final String entityId;
  final String entityType;
  final String? entityName;
  final double? x;
  final double? y;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENTITY INFO',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 1,
                ),
              ),
              if (onClose != null)
                GestureDetector(
                  onTap: onClose,
                  child: Icon(
                    Icons.close,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
            ],
          ),
          SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: FiftySpacing.md),
          // Info rows
          _InfoRow(label: 'ID', value: entityId),
          _InfoRow(label: 'TYPE', value: entityType.toUpperCase()),
          if (entityName != null) _InfoRow(label: 'NAME', value: entityName!),
          if (x != null && y != null)
            _InfoRow(
              label: 'POSITION',
              value: '(${x!.toStringAsFixed(1)}, ${y!.toStringAsFixed(1)})',
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
