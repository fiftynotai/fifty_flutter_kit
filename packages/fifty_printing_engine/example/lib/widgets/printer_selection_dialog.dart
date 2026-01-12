import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class PrinterSelectionDialog extends StatefulWidget {
  final List<PrinterDevice> availablePrinters;

  const PrinterSelectionDialog({
    super.key,
    required this.availablePrinters,
  });

  @override
  State<PrinterSelectionDialog> createState() => _PrinterSelectionDialogState();
}

class _PrinterSelectionDialogState extends State<PrinterSelectionDialog> {
  final Set<String> _selectedPrinterIds = {};

  @override
  void initState() {
    super.initState();
    // Select all by default
    _selectedPrinterIds.addAll(widget.availablePrinters.map((p) => p.id));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Printers'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose which printers to print to:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availablePrinters.length,
                itemBuilder: (context, index) {
                  final printer = widget.availablePrinters[index];
                  final isSelected = _selectedPrinterIds.contains(printer.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedPrinterIds.add(printer.id);
                          } else {
                            _selectedPrinterIds.remove(printer.id);
                          }
                        });
                      },
                      title: Text(
                        printer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    printer.type == PrinterType.bluetooth
                                        ? Icons.bluetooth
                                        : Icons.wifi,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    printer.type == PrinterType.bluetooth
                                        ? 'Bluetooth'
                                        : 'WiFi',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              if (printer.role != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    printer.role!.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      secondary: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(printer.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _selectedPrinterIds.isEmpty
              ? null
              : () {
                  Navigator.pop(context, _selectedPrinterIds.toList());
                },
          icon: const Icon(Icons.print),
          label: Text('Print to ${_selectedPrinterIds.length}'),
        ),
      ],
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
}
