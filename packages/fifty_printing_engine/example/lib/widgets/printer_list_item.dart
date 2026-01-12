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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Type Icon
                CircleAvatar(
                  backgroundColor: _getStatusColor(status).withOpacity(0.1),
                  child: Icon(
                    printer.type == PrinterType.bluetooth
                        ? Icons.bluetooth
                        : Icons.wifi,
                    color: _getStatusColor(status),
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
                              color: _getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
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
                  color: Colors.red,
                  onPressed: onRemove,
                  tooltip: 'Remove printer',
                ),
              ],
            ),

            const SizedBox(height: 12),

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

            const SizedBox(height: 16),

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!isConnected)
                  FilledButton.tonalIcon(
                    onPressed: onConnect,
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Connect'),
                  )
                else
                  FilledButton.tonalIcon(
                    onPressed: onDisconnect,
                    icon: const Icon(Icons.link_off, size: 18),
                    label: const Text('Disconnect'),
                  ),

                OutlinedButton.icon(
                  onPressed: onCheckHealth,
                  icon: const Icon(Icons.health_and_safety, size: 18),
                  label: const Text('Health Check'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
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

  Color _getStatusColor(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.connected:
      case PrinterStatus.printing:
        return Colors.green;
      case PrinterStatus.connecting:
        return Colors.blue;
      case PrinterStatus.error:
      case PrinterStatus.healthCheckFailed:
        return Colors.red;
      case PrinterStatus.disconnected:
        return Colors.grey;
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
