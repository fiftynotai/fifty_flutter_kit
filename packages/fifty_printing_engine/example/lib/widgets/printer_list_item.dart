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
    final isConnected = status == PrinterStatus.connected || status == PrinterStatus.printing;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Type Icon
                CircleAvatar(
                  backgroundColor: _getStatusColor(status, colorScheme).withValues(alpha: 0.2),
                  child: Icon(
                    printer.type == PrinterType.bluetooth
                        ? Icons.bluetooth
                        : Icons.wifi,
                    color: _getStatusColor(status, colorScheme),
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
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status, colorScheme),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getStatusText(status),
                            style: TextStyle(
                              color: _getStatusColor(status, colorScheme),
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
                  color: colorScheme.error,
                  onPressed: onRemove,
                  tooltip: 'Remove printer',
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
                  FilledButton.icon(
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Connect'),
                    onPressed: onConnect,
                  )
                else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.link_off, size: 18),
                    label: const Text('Disconnect'),
                    onPressed: onDisconnect,
                  ),

                OutlinedButton.icon(
                  icon: const Icon(Icons.health_and_safety, size: 18),
                  label: const Text('Health Check'),
                  onPressed: onCheckHealth,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
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

  Color _getStatusColor(PrinterStatus status, ColorScheme colorScheme) {
    switch (status) {
      case PrinterStatus.connected:
      case PrinterStatus.printing:
        return Colors.green;
      case PrinterStatus.connecting:
        return Colors.orange;
      case PrinterStatus.error:
      case PrinterStatus.healthCheckFailed:
        return colorScheme.error;
      case PrinterStatus.disconnected:
        return colorScheme.onSurfaceVariant;
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
