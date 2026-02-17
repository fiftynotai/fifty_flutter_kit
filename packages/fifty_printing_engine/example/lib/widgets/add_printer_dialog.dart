import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'bluetooth_scan_sheet.dart';

class AddPrinterDialog extends StatefulWidget {
  const AddPrinterDialog({super.key});

  @override
  State<AddPrinterDialog> createState() => _AddPrinterDialogState();
}

class _AddPrinterDialogState extends State<AddPrinterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController(text: '9100');
  final _copiesController = TextEditingController(text: '1');

  PrinterType _selectedType = PrinterType.wifi;
  PrinterRole? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  Future<void> _scanForBluetoothPrinters() async {
    final discovered = await showModalBottomSheet<DiscoveredPrinter>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const BluetoothScanSheet(),
    );

    if (discovered != null) {
      setState(() {
        _nameController.text = discovered.name;
        _addressController.text = discovered.macAddress;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final id = 'printer-${DateTime.now().millisecondsSinceEpoch}';
    final name = _nameController.text;
    final copies = int.parse(_copiesController.text);

    PrinterDevice printer;

    if (_selectedType == PrinterType.bluetooth) {
      printer = BluetoothPrinterDevice(
        id: id,
        name: name,
        macAddress: _addressController.text,
        role: _selectedRole,
        defaultCopies: copies,
      );
    } else {
      printer = WiFiPrinterDevice(
        id: id,
        name: name,
        ipAddress: _addressController.text,
        port: int.parse(_portController.text),
        role: _selectedRole,
        defaultCopies: copies,
      );
    }

    Navigator.pop(context, printer);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(
        'Add Printer',
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Printer Type
                SegmentedButton<PrinterType>(
                  segments: const [
                    ButtonSegment(
                      value: PrinterType.bluetooth,
                      label: Text('Bluetooth'),
                      icon: Icon(Icons.bluetooth),
                    ),
                    ButtonSegment(
                      value: PrinterType.wifi,
                      label: Text('WiFi'),
                      icon: Icon(Icons.wifi),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (Set<PrinterType> selection) {
                    setState(() {
                      _selectedType = selection.first;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Printer Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Printer Name',
                    hintText: 'Kitchen Printer',
                    prefixIcon: Icon(Icons.print),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Address (MAC or IP)
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: _selectedType == PrinterType.bluetooth
                        ? 'MAC Address'
                        : 'IP Address',
                    hintText: _selectedType == PrinterType.bluetooth
                        ? '00:11:22:33:44:55'
                        : '192.168.1.100',
                    prefixIcon: Icon(_selectedType == PrinterType.bluetooth
                        ? Icons.bluetooth
                        : Icons.lan),
                    suffixIcon: _selectedType == PrinterType.bluetooth
                        ? IconButton(
                            icon: Icon(
                              Icons.bluetooth_searching,
                              color: colorScheme.primary,
                            ),
                            tooltip: 'Scan for printers',
                            onPressed: _scanForBluetoothPrinters,
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ${_selectedType == PrinterType.bluetooth ? "MAC address" : "IP address"}';
                    }
                    return null;
                  },
                ),

                // Port (WiFi only)
                if (_selectedType == PrinterType.wifi) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      hintText: '9100',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter port';
                      }
                      final port = int.tryParse(value);
                      if (port == null || port < 1 || port > 65535) {
                        return 'Invalid port number';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 16),

                // Printer Role (optional)
                DropdownButtonFormField<PrinterRole>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role (Optional)',
                    prefixIcon: Icon(Icons.assignment),
                    border: OutlineInputBorder(),
                  ),
                  items: PrinterRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Default Copies
                TextFormField(
                  controller: _copiesController,
                  decoration: const InputDecoration(
                    labelText: 'Default Copies',
                    hintText: '1',
                    prefixIcon: Icon(Icons.copy_all),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of copies';
                    }
                    final copies = int.tryParse(value);
                    if (copies == null || copies < 1 || copies > 10) {
                      return 'Must be between 1 and 10';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Info card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Set default copies per printer. Can be overridden per print job.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
