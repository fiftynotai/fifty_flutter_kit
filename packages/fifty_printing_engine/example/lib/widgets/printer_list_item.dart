import 'package:fifty_tokens/fifty_tokens.dart';
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
    final status = printer.status;
    final isConnected = status == PrinterStatus.connected || status == PrinterStatus.printing;

    return FiftyCard(
      margin: EdgeInsets.only(bottom: FiftySpacing.md),
      padding: EdgeInsets.all(FiftySpacing.lg),
      scanlineOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Type Icon
              CircleAvatar(
                backgroundColor: _getStatusColor(status).withValues(alpha: 0.2),
                child: Icon(
                  printer.type == PrinterType.bluetooth
                      ? Icons.bluetooth
                      : Icons.wifi,
                  color: _getStatusColor(status),
                ),
              ),
              SizedBox(width: FiftySpacing.md),

              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      printer.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: FiftyColors.terminalWhite,
                      ),
                    ),
                    SizedBox(height: FiftySpacing.xs),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: FiftySpacing.sm),
                        Text(
                          _getStatusText(status),
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remove Button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: FiftyColors.error,
                onPressed: onRemove,
                tooltip: 'Remove printer',
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.md),

          // Details
          _buildDetailRow(
            Icons.tag,
            'ID',
            printer.id,
          ),

          if (printer.type == PrinterType.bluetooth)
            _buildDetailRow(
              Icons.bluetooth,
              'MAC',
              (printer as BluetoothPrinterDevice).macAddress,
            )
          else
            _buildDetailRow(
              Icons.lan,
              'Address',
              '${(printer as WiFiPrinterDevice).ipAddress}:${(printer as WiFiPrinterDevice).port}',
            ),

          if (printer.role != null)
            _buildDetailRow(
              Icons.assignment,
              'Role',
              printer.role!.name.toUpperCase(),
            ),

          _buildDetailRow(
            Icons.copy_all,
            'Default Copies',
            '${printer.defaultCopies}',
          ),

          SizedBox(height: FiftySpacing.lg),

          // Action Buttons
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: [
              if (!isConnected)
                FiftyButton(
                  label: 'Connect',
                  icon: Icons.link,
                  size: FiftyButtonSize.small,
                  onPressed: onConnect,
                )
              else
                FiftyButton(
                  label: 'Disconnect',
                  icon: Icons.link_off,
                  variant: FiftyButtonVariant.secondary,
                  size: FiftyButtonSize.small,
                  onPressed: onDisconnect,
                ),

              FiftyButton(
                label: 'Health Check',
                icon: Icons.health_and_safety,
                variant: FiftyButtonVariant.secondary,
                size: FiftyButtonSize.small,
                onPressed: onCheckHealth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: FiftySpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: FiftyColors.hyperChrome),
          SizedBox(width: FiftySpacing.sm),
          Text(
            '$label: ',
            style: TextStyle(
              color: FiftyColors.hyperChrome,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: FiftyColors.terminalWhite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.connected:
      case PrinterStatus.printing:
        return FiftyColors.success;
      case PrinterStatus.connecting:
        return FiftyColors.warning;
      case PrinterStatus.error:
      case PrinterStatus.healthCheckFailed:
        return FiftyColors.error;
      case PrinterStatus.disconnected:
        return FiftyColors.hyperChrome;
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
