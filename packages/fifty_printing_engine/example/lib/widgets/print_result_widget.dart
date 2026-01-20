import 'package:fifty_tokens/fifty_tokens.dart';
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
    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.lg),
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
                color: result.isSuccess
                    ? FiftyColors.success
                    : result.isPartialSuccess
                        ? FiftyColors.warning
                        : FiftyColors.error,
                size: 28,
              ),
              SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Print Result',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.terminalWhite,
                          ),
                    ),
                    SizedBox(height: FiftySpacing.xs),
                    Text(
                      result.isSuccess
                          ? 'All printers succeeded'
                          : result.isPartialSuccess
                              ? 'Some printers failed'
                              : 'All printers failed',
                      style: TextStyle(
                        color: FiftyColors.hyperChrome,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.lg),

          // Summary Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total',
                  result.totalPrinters.toString(),
                  FiftyColors.crimsonPulse,
                ),
              ),
              SizedBox(width: FiftySpacing.md),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Success',
                  result.successCount.toString(),
                  FiftyColors.success,
                ),
              ),
              SizedBox(width: FiftySpacing.md),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Failed',
                  result.failedCount.toString(),
                  FiftyColors.error,
                ),
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.lg),

          // Per-Printer Details
          Text(
            'Details',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.terminalWhite,
                ),
          ),
          SizedBox(height: FiftySpacing.sm),

          ...result.results.entries.map((entry) {
            final printerId = entry.key;
            final printerResult = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: FiftySpacing.sm),
              child: Container(
                padding: EdgeInsets.all(FiftySpacing.md),
                decoration: BoxDecoration(
                  color: printerResult.success
                      ? FiftyColors.success.withValues(alpha: 0.1)
                      : FiftyColors.error.withValues(alpha: 0.1),
                  borderRadius: FiftyRadii.standardRadius,
                  border: Border.all(
                    color: printerResult.success
                        ? FiftyColors.success.withValues(alpha: 0.3)
                        : FiftyColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      printerResult.success
                          ? Icons.check_circle
                          : Icons.error,
                      color: printerResult.success
                          ? FiftyColors.success
                          : FiftyColors.error,
                      size: 20,
                    ),
                    SizedBox(width: FiftySpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            printerId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: FiftyColors.terminalWhite,
                            ),
                          ),
                          if (printerResult.errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(top: FiftySpacing.xs),
                              child: Text(
                                printerResult.errorMessage!,
                                style: TextStyle(
                                  color: FiftyColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${printerResult.duration.inMilliseconds}ms',
                      style: TextStyle(
                        color: FiftyColors.hyperChrome,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
