/// Printing Demo Page
///
/// Demonstrates printing engine with printer discovery and ticket printing.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
import '../actions/printing_demo_actions.dart';
import '../controllers/printing_demo_view_model.dart';

/// Printing demo page widget.
///
/// Shows printer discovery and print functionality.
class PrintingDemoPage extends GetView<PrintingDemoViewModel> {
  /// Creates a printing demo page.
  const PrintingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintingDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<PrintingDemoActions>();
        return Scaffold(
          backgroundColor: FiftyColors.darkBurgundy,
          appBar: AppBar(
            backgroundColor: FiftyColors.surfaceDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: FiftyColors.cream),
              onPressed: actions.onBackTapped,
            ),
            title: const Text(
              'PRINTING ENGINE',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyLarge,
                fontWeight: FontWeight.bold,
                color: FiftyColors.cream,
                letterSpacing: 2,
              ),
            ),
          ),
          body: DemoScaffold(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Row
                  Row(
                    children: [
                      StatusIndicator(
                        label: 'DISCOVERY',
                        state: viewModel.isDiscovering
                            ? StatusState.loading
                            : (viewModel.printers.isNotEmpty
                                ? StatusState.ready
                                : StatusState.idle),
                      ),
                      const SizedBox(width: FiftySpacing.lg),
                      StatusIndicator(
                        label: 'PRINT',
                        state: viewModel.isPrinting
                            ? StatusState.loading
                            : (viewModel.lastResult?.success == true
                                ? StatusState.ready
                                : StatusState.idle),
                      ),
                    ],
                  ),
                  const SizedBox(height: FiftySpacing.xl),

                  // Discovery Section
                  const SectionHeader(
                    title: 'Printer Discovery',
                    subtitle: 'Find available printers',
                  ),
                  _buildDiscoverySection(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Printers List Section
                  if (viewModel.printers.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Available Printers',
                      subtitle: '${viewModel.printers.length} printers found',
                    ),
                    _buildPrintersList(viewModel, actions),
                    const SizedBox(height: FiftySpacing.xl),
                  ],

                  // Ticket Preview Section
                  const SectionHeader(
                    title: 'Ticket Preview',
                    subtitle: 'Sample receipt ticket',
                  ),
                  _buildTicketPreview(viewModel),
                  const SizedBox(height: FiftySpacing.xl),

                  // Print Section
                  const SectionHeader(
                    title: 'Print',
                    subtitle: 'Send to selected printer',
                  ),
                  _buildPrintSection(context, viewModel, actions),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverySection(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.isDiscovering
                      ? 'Searching for printers...'
                      : viewModel.printers.isEmpty
                          ? 'Tap to discover nearby printers'
                          : '${viewModel.printers.length} printers discovered',
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: FiftyColors.cream,
                  ),
                ),
              ],
            ),
          ),
          FiftyButton(
            label: viewModel.isDiscovering ? 'SEARCHING...' : 'DISCOVER',
            variant: FiftyButtonVariant.secondary,
            loading: viewModel.isDiscovering,
            onPressed: viewModel.isDiscovering
                ? null
                : () => actions.onDiscoverTapped(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintersList(
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    return Column(
      children: viewModel.printers.map((printer) {
        final isSelected = viewModel.selectedPrinter?.id == printer.id;
        final isOnline = printer.status == PrinterStatus.online;

        return Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.md),
            onTap: isOnline ? () => actions.onPrinterSelected(printer) : null,
            child: Opacity(
              opacity: isOnline ? 1.0 : 0.5,
              child: Row(
                children: [
                  // Connection type icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FiftyColors.burgundy.withValues(alpha: 0.3)
                          : FiftyColors.slateGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                    ),
                    child: Icon(
                      printer.icon,
                      color: isSelected
                          ? FiftyColors.burgundy
                          : FiftyColors.slateGrey,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.md),

                  // Printer info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          printer.name,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodyMedium,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: FiftyColors.cream,
                          ),
                        ),
                        const SizedBox(height: FiftySpacing.xs),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: viewModel.getStatusColor(printer.status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: FiftySpacing.xs),
                            Text(
                              viewModel.getStatusLabel(printer.status),
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.bodySmall,
                                color: viewModel.getStatusColor(printer.status),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: FiftyColors.hunterGreen,
                      size: 24,
                    )
                  else if (isOnline)
                    Icon(
                      Icons.radio_button_unchecked,
                      color: FiftyColors.cream.withValues(alpha: 0.3),
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTicketPreview(PrintingDemoViewModel viewModel) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(FiftySpacing.md),
        decoration: BoxDecoration(
          color: FiftyColors.cream,
          borderRadius: BorderRadius.circular(FiftyRadii.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: viewModel.sampleTicketLines.map((line) {
            return Text(
              line,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                color: FiftyColors.darkBurgundy,
                height: 1.4,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPrintSection(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected printer info
          Row(
            children: [
              Icon(
                Icons.print_outlined,
                color: FiftyColors.cream.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: Text(
                  viewModel.selectedPrinter != null
                      ? 'Selected: ${viewModel.selectedPrinter!.name}'
                      : 'No printer selected',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),

          // Last result
          if (viewModel.lastResult != null) ...[
            const SizedBox(height: FiftySpacing.sm),
            Container(
              padding: const EdgeInsets.all(FiftySpacing.sm),
              decoration: BoxDecoration(
                color: viewModel.lastResult!.success
                    ? FiftyColors.hunterGreen.withValues(alpha: 0.2)
                    : FiftyColors.burgundy.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    viewModel.lastResult!.success
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: viewModel.lastResult!.success
                        ? FiftyColors.hunterGreen
                        : FiftyColors.burgundy,
                    size: 16,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Expanded(
                    child: Text(
                      viewModel.lastResult!.message,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: viewModel.lastResult!.success
                            ? FiftyColors.hunterGreen
                            : FiftyColors.burgundy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: FiftySpacing.md),

          // Print button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: viewModel.isPrinting ? 'PRINTING...' : 'PRINT TICKET',
              variant: FiftyButtonVariant.primary,
              loading: viewModel.isPrinting,
              onPressed: viewModel.selectedPrinter != null && !viewModel.isPrinting
                  ? () => actions.onPrintTapped(context)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
