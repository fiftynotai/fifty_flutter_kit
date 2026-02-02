/// Printing Demo Page
///
/// Demonstrates printing engine with real Bluetooth printer discovery
/// and ESC/POS ticket printing using fifty_printing_engine.
library;

import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'package:fifty_theme/fifty_theme.dart';
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
/// Shows Bluetooth printer discovery, registration, and real print functionality.
class PrintingDemoPage extends GetView<PrintingDemoViewModel> {
  /// Creates a printing demo page.
  const PrintingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintingDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<PrintingDemoActions>();

        return DemoScaffold(
          title: 'Printing Engine',
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
                          : (viewModel.registeredPrinters.isNotEmpty
                              ? StatusState.ready
                              : StatusState.idle),
                    ),
                    const SizedBox(width: FiftySpacing.lg),
                    StatusIndicator(
                      label: 'PRINT',
                      state: viewModel.isPrinting
                          ? StatusState.loading
                          : (viewModel.lastResult?.isSuccess == true
                              ? StatusState.ready
                              : StatusState.idle),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Error Message
                if (viewModel.errorMessage != null) ...[
                  _buildErrorCard(context, viewModel),
                  const SizedBox(height: FiftySpacing.md),
                ],

                // Permissions Section (if not granted)
                if (!viewModel.hasPermissions) ...[
                  _buildPermissionsSection(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),
                ],

                // Discovery Section
                const SectionHeader(
                  title: 'Bluetooth Discovery',
                  subtitle: 'Scan for nearby Bluetooth printers',
                ),
                _buildDiscoverySection(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // Discovered Printers (not yet registered)
                if (viewModel.discoveredPrinters.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Discovered Devices',
                    subtitle: '${viewModel.discoveredPrinters.length} found - tap to add',
                  ),
                  _buildDiscoveredPrintersList(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),
                ],

                // Registered Printers
                if (viewModel.registeredPrinters.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Registered Printers',
                    subtitle: '${viewModel.registeredPrinters.length} available',
                  ),
                  _buildRegisteredPrintersList(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),
                ],

                // Ticket Preview Section
                const SectionHeader(
                  title: 'Ticket Preview',
                  subtitle: 'Sample receipt ticket',
                ),
                _buildTicketPreview(context, viewModel),
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
        );
      },
    );
  }

  Widget _buildErrorCard(BuildContext context, PrintingDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final warningColor = fiftyTheme?.warning ?? colorScheme.error;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bluetooth_disabled,
                color: warningColor,
                size: 24,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: Text(
                  'Bluetooth Permissions Required',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.sm),
          Text(
            'Grant Bluetooth permissions to discover and connect to thermal printers.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          Row(
            children: [
              Expanded(
                child: FiftyButton(
                  label: 'OPEN SETTINGS',
                  variant: FiftyButtonVariant.secondary,
                  onPressed: () => actions.onOpenSettingsTapped(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

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
                      ? 'Scanning for Bluetooth devices...'
                      : viewModel.discoveredPrinters.isEmpty
                          ? 'Tap to scan for nearby printers'
                          : '${viewModel.discoveredPrinters.length} devices found',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          FiftyButton(
            label: viewModel.isDiscovering ? 'SCANNING...' : 'SCAN',
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

  Widget _buildDiscoveredPrintersList(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: viewModel.discoveredPrinters.map((discovered) {
        // Check if already registered
        final isRegistered = viewModel.registeredPrinters.any(
          (p) => p is BluetoothPrinterDevice && p.macAddress == discovered.macAddress,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.md),
            onTap: isRegistered ? null : () => actions.onDiscoveredPrinterTapped(context, discovered),
            child: Opacity(
              opacity: isRegistered ? 0.5 : 1.0,
              child: Row(
                children: [
                  // Bluetooth icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                    ),
                    child: Icon(
                      Icons.bluetooth,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.md),

                  // Device info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discovered.name.isNotEmpty ? discovered.name : 'Unknown Device',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodyMedium,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: FiftySpacing.xs),
                        Text(
                          discovered.macAddress,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodySmall,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add button or registered indicator
                  if (isRegistered)
                    Text(
                      'ADDED',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    )
                  else
                    Icon(
                      Icons.add_circle_outline,
                      color: colorScheme.primary,
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

  Widget _buildRegisteredPrintersList(
    BuildContext context,
    PrintingDemoViewModel viewModel,
    PrintingDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Column(
      children: viewModel.registeredPrinters.map((printer) {
        final isSelected = viewModel.selectedPrinterId == printer.id;
        final isConnected = printer.status == PrinterStatus.connected;
        final statusColor = viewModel.getStatusColor(
          printer.status,
          colorScheme,
          fiftyTheme,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.md),
            onTap: () => actions.onRegisteredPrinterTapped(context, printer),
            child: Row(
              children: [
                // Printer type icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(FiftyRadii.sm),
                  ),
                  child: Icon(
                    viewModel.getPrinterTypeIcon(printer.type),
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: FiftySpacing.xs),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: FiftySpacing.xs),
                          Text(
                            viewModel.getStatusLabel(printer.status),
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Connect/Selection indicator
                if (isSelected && !isConnected)
                  FiftyButton(
                    label: 'CONNECT',
                    variant: FiftyButtonVariant.secondary,
                    size: FiftyButtonSize.small,
                    onPressed: () => actions.onConnectTapped(context),
                  )
                else if (isSelected && isConnected)
                  Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: 24,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTicketPreview(BuildContext context, PrintingDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(FiftySpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          borderRadius: BorderRadius.circular(FiftyRadii.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: viewModel.sampleTicketLines.map((line) {
            return Text(
              line,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                color: colorScheme.surface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;
    final errorColor = colorScheme.error;

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
                color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                color: viewModel.lastResult!.isSuccess
                    ? successColor.withValues(alpha: 0.2)
                    : errorColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    viewModel.lastResult!.isSuccess
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: viewModel.lastResult!.isSuccess ? successColor : errorColor,
                    size: 16,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Expanded(
                    child: Text(
                      viewModel.lastResult!.isSuccess
                          ? 'Print sent successfully!'
                          : 'Print failed (${viewModel.lastResult!.failedCount} failed)',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: viewModel.lastResult!.isSuccess ? successColor : errorColor,
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
