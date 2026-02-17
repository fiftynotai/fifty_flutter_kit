import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class PrinterListItem extends StatelessWidget {
  final PrinterDevice printer;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onCheckHealth;
  final VoidCallback onRemove;

  const PrinterListItem({
    super.key,
    required this.printer,
    required this.onConnect,
    required this.onDisconnect,
    required this.onCheckHealth,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final status = printer.status;
    final isConnected =
        status == PrinterStatus.connected || status == PrinterStatus.printing;

    return FiftyCard(
      scanlineOnHover: false,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Type Icon
              CircleAvatar(
                backgroundColor:
                    colorScheme.primary.withValues(alpha: 0.2),
                child: Icon(
                  printer.type == PrinterType.bluetooth
                      ? Icons.bluetooth
                      : Icons.wifi,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),

              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      printer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FiftyStatusIndicator(
                      label: _getStatusText(status),
                      state: _mapStatus(status),
                      showStatusLabel: false,
                      size: FiftyStatusSize.small,
                    ),
                  ],
                ),
              ),

              // Remove Button
              FiftyIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Remove printer',
                onPressed: onRemove,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Details
          _buildDetailRow(
            context,
            Icons.tag,
            'ID',
            printer.id,
          ),

          if (printer.type == PrinterType.bluetooth)
            _buildDetailRow(
              context,
              Icons.bluetooth,
              'MAC',
              (printer as BluetoothPrinterDevice).macAddress,
            )
          else
            _buildDetailRow(
              context,
              Icons.lan,
              'Address',
              '${(printer as WiFiPrinterDevice).ipAddress}:${(printer as WiFiPrinterDevice).port}',
            ),

          if (printer.role != null)
            _buildDetailRow(
              context,
              Icons.assignment,
              'Role',
              printer.role!.name.toUpperCase(),
            ),

          _buildDetailRow(
            context,
            Icons.copy_all,
            'Default Copies',
            '${printer.defaultCopies}',
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!isConnected)
                FiftyButton(
                  icon: Icons.link,
                  label: 'Connect',
                  onPressed: onConnect,
                  size: FiftyButtonSize.small,
                )
              else
                FiftyButton(
                  icon: Icons.link_off,
                  label: 'Disconnect',
                  variant: FiftyButtonVariant.outline,
                  onPressed: onDisconnect,
                  size: FiftyButtonSize.small,
                ),
              FiftyButton(
                icon: Icons.health_and_safety,
                label: 'Health Check',
                variant: FiftyButtonVariant.outline,
                onPressed: onCheckHealth,
                size: FiftyButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  FiftyStatusState _mapStatus(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.connected:
        return FiftyStatusState.ready;
      case PrinterStatus.printing:
        return FiftyStatusState.loading;
      case PrinterStatus.connecting:
        return FiftyStatusState.loading;
      case PrinterStatus.error:
        return FiftyStatusState.error;
      case PrinterStatus.healthCheckFailed:
        return FiftyStatusState.error;
      case PrinterStatus.disconnected:
        return FiftyStatusState.offline;
    }
  }

  String _getStatusText(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.connected:
        return 'Connected';
      case PrinterStatus.connecting:
        return 'Connecting...';
      case PrinterStatus.disconnected:
        return 'Disconnected';
      case PrinterStatus.printing:
        return 'Printing';
      case PrinterStatus.error:
        return 'Error';
      case PrinterStatus.healthCheckFailed:
        return 'Health Check Failed';
    }
  }
}
