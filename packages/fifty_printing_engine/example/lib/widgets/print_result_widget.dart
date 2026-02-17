import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class PrintResultWidget extends StatelessWidget {
  final PrintResult result;

  const PrintResultWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

    final statusColor = result.isSuccess
        ? fifty.success
        : result.isPartialSuccess
            ? fifty.warning
            : colorScheme.error;

    return FiftyCard(
      scanlineOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                result.isSuccess
                    ? Icons.check_circle
                    : result.isPartialSuccess
                        ? Icons.warning
                        : Icons.error,
                color: statusColor,
                size: 28,
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Print Result',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      result.isSuccess
                          ? 'All printers succeeded'
                          : result.isPartialSuccess
                              ? 'Some printers failed'
                              : 'All printers failed',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Summary Stats
          Row(
            children: [
              Expanded(
                child: FiftyStatCard(
                  label: 'Total',
                  value: result.totalPrinters.toString(),
                  icon: Icons.print,
                  iconColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: FiftyStatCard(
                  label: 'Success',
                  value: result.successCount.toString(),
                  icon: Icons.check_circle,
                  iconColor: fifty.success,
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: FiftyStatCard(
                  label: 'Failed',
                  value: result.failedCount.toString(),
                  icon: Icons.error,
                  iconColor: colorScheme.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Per-Printer Details
          const FiftySectionHeader(
            title: 'Details',
            showDivider: false,
          ),

          ...result.results.entries.map((entry) {
            final printerId = entry.key;
            final printerResult = entry.value;
            final badgeVariant = printerResult.success
                ? FiftyBadgeVariant.success
                : FiftyBadgeVariant.error;

            return Padding(
              padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
              child: FiftyListTile(
                leadingIcon: printerResult.success
                    ? Icons.check_circle
                    : Icons.error,
                leadingIconColor: printerResult.success
                    ? fifty.success
                    : colorScheme.error,
                title: printerId,
                subtitle: printerResult.errorMessage,
                trailing: FiftyBadge(
                  label: printerResult.success ? 'OK' : 'FAIL',
                  variant: badgeVariant,
                ),
                trailingText: '${printerResult.duration.inMilliseconds}ms',
              ),
            );
          }),
        ],
      ),
    );
  }
}
