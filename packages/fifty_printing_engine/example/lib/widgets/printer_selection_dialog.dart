import 'package:fifty_ui/fifty_ui.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyDialog(
      title: 'Select Printers',
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
                  final isSelected =
                      _selectedPrinterIds.contains(printer.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FiftyCard(
                      scanlineOnHover: false,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedPrinterIds.remove(printer.id);
                          } else {
                            _selectedPrinterIds.add(printer.id);
                          }
                        });
                      },
                      selected: isSelected,
                      child: Row(
                        children: [
                          FiftyCheckbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  _selectedPrinterIds.add(printer.id);
                                } else {
                                  _selectedPrinterIds.remove(printer.id);
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  printer.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          printer.type ==
                                                  PrinterType.bluetooth
                                              ? Icons.bluetooth
                                              : Icons.wifi,
                                          size: 14,
                                          color: colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          printer.type ==
                                                  PrinterType.bluetooth
                                              ? 'Bluetooth'
                                              : 'WiFi',
                                          style: TextStyle(
                                            color: colorScheme
                                                .onSurfaceVariant,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (printer.role != null)
                                      FiftyBadge(
                                        label: printer.role!.name,
                                        variant:
                                            FiftyBadgeVariant.neutral,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FiftyStatusIndicator(
                            label: '',
                            state: _mapStatus(printer.status),
                            showStatusLabel: false,
                            size: FiftyStatusSize.small,
                          ),
                        ],
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
        FiftyButton(
          label: 'Cancel',
          variant: FiftyButtonVariant.ghost,
          onPressed: () => Navigator.pop(context),
        ),
        FiftyButton(
          icon: Icons.print,
          label: 'Print to ${_selectedPrinterIds.length}',
          disabled: _selectedPrinterIds.isEmpty,
          onPressed: () {
            Navigator.pop(context, _selectedPrinterIds.toList());
          },
        ),
      ],
    );
  }
}
