import 'package:fifty_tokens/fifty_tokens.dart';
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
    // Select all by default
    _selectedPrinterIds.addAll(widget.availablePrinters.map((p) => p.id));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FiftyCard(
        padding: EdgeInsets.all(FiftySpacing.xxl),
        scanlineOnHover: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Select Printers',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: FiftyColors.terminalWhite,
                    ),
              ),

              SizedBox(height: FiftySpacing.md),

              Text(
                'Choose which printers to print to:',
                style: TextStyle(color: FiftyColors.hyperChrome),
              ),

              SizedBox(height: FiftySpacing.lg),

              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.availablePrinters.length,
                  itemBuilder: (context, index) {
                    final printer = widget.availablePrinters[index];
                    final isSelected = _selectedPrinterIds.contains(printer.id);

                    return FiftyCard(
                      margin: EdgeInsets.only(bottom: FiftySpacing.sm),
                      padding: EdgeInsets.zero,
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
                      child: CheckboxListTile(
                        value: isSelected,
                        activeColor: FiftyColors.crimsonPulse,
                        checkColor: FiftyColors.terminalWhite,
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.terminalWhite,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: FiftySpacing.xs),
                            Wrap(
                              spacing: FiftySpacing.sm,
                              runSpacing: FiftySpacing.xs,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      printer.type == PrinterType.bluetooth
                                          ? Icons.bluetooth
                                          : Icons.wifi,
                                      size: 14,
                                      color: FiftyColors.hyperChrome,
                                    ),
                                    SizedBox(width: FiftySpacing.xs),
                                    Text(
                                      printer.type == PrinterType.bluetooth
                                          ? 'Bluetooth'
                                          : 'WiFi',
                                      style: TextStyle(
                                        color: FiftyColors.hyperChrome,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (printer.role != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: FiftySpacing.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      printer.role!.name.toUpperCase(),
                                      style: TextStyle(
                                        color: FiftyColors.crimsonPulse,
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

              SizedBox(height: FiftySpacing.xxl),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FiftyButton(
                    label: 'Cancel',
                    variant: FiftyButtonVariant.ghost,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: FiftySpacing.md),
                  FiftyButton(
                    label: 'Print to ${_selectedPrinterIds.length}',
                    icon: Icons.print,
                    disabled: _selectedPrinterIds.isEmpty,
                    onPressed: _selectedPrinterIds.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context, _selectedPrinterIds.toList());
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
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
}
