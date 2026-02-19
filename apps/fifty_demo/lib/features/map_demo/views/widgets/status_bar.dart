/// Status Bar Widget
///
/// FDL-styled status display showing map state information.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Status bar displaying current map state.
///
/// Shows:
/// - Status label (READY, LOADING, ERROR, EMPTY)
/// - Entity count
/// - Error message (if any)
class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.status,
    required this.entityCount,
    this.hasError = false,
    this.errorMessage,
  });

  /// Current status label.
  final String status;

  /// Entity count label.
  final String entityCount;

  /// Whether there is an error.
  final bool hasError;

  /// Error message to display.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      backgroundColor: FiftyColors.surfaceDark.withValues(alpha: 0.9),
      scanlineOnHover: false,
      hoverScale: 1.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Package title
          const Text(
            'FIFTY WORLD ENGINE',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.bold,
              color: FiftyColors.cream,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          const _VerticalDivider(),
          const SizedBox(width: FiftySpacing.md),

          // Status indicator
          _buildStatusIndicator(),
          const SizedBox(width: FiftySpacing.sm),

          // Status label
          Text(
            status,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              color: _getStatusColor(),
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.semiBold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(width: FiftySpacing.md),
          const _VerticalDivider(),
          const SizedBox(width: FiftySpacing.md),

          // Entity count
          Text(
            entityCount,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              color: FiftyColors.cream,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.regular,
            ),
          ),

          // Error message (if any)
          if (hasError && errorMessage != null) ...[
            const SizedBox(width: FiftySpacing.md),
            const _VerticalDivider(),
            const SizedBox(width: FiftySpacing.md),
            SizedBox(
              width: 200,
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: FiftyColors.error,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'READY':
        return FiftyColors.success;
      case 'LOADING':
        return FiftyColors.warning;
      case 'ERROR':
        return FiftyColors.error;
      case 'EMPTY':
      default:
        return FiftyColors.slateGrey;
    }
  }
}

/// Simple vertical divider styled for FDL.
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      color: FiftyColors.slateGrey.withValues(alpha: 0.3),
    );
  }
}
