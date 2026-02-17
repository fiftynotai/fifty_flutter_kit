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
    _selectedPrinterIds.addAll(widget.availablePrinters.map((p) => p.id));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(
        'Select Printers',
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose which printers to print to:',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
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
                    clipBehavior: Clip.antiAlias,
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
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    printer.type == PrinterType.bluetooth
                                        ? 'Bluetooth'
                                        : 'WiFi',
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              if (printer.role != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    printer.role!.name.toUpperCase(),
                                    style: TextStyle(
                                      color: colorScheme.onPrimaryContainer,
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
                          color: _getStatusColor(printer.status, colorScheme),
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
          icon: const Icon(Icons.print),
          label: Text('Print to ${_selectedPrinterIds.length}'),
          onPressed: _selectedPrinterIds.isEmpty
              ? null
              : () {
                  Navigator.pop(context, _selectedPrinterIds.toList());
                },
        ),
      ],
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
}
