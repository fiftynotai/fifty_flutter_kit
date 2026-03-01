import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'bluetooth_scan_sheet.dart';

class AddPrinterDialog extends StatefulWidget {
  const AddPrinterDialog({super.key});

  @override
  State<AddPrinterDialog> createState() => _AddPrinterDialogState();
}

class _AddPrinterDialogState extends State<AddPrinterDialog> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController(text: '9100');
  final _copiesController = TextEditingController(text: '1');

  PrinterType _selectedType = PrinterType.wifi;
  PrinterRole? _selectedRole;

  // Manual validation state
  String? _nameError;
  String? _addressError;
  String? _portError;
  String? _copiesError;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;

    // Name validation
    if (_nameController.text.isEmpty) {
      _nameError = 'Please enter a name';
      valid = false;
    } else {
      _nameError = null;
    }

    // Address validation
    if (_addressController.text.isEmpty) {
      _addressError =
          'Please enter ${_selectedType == PrinterType.bluetooth ? "MAC address" : "IP address"}';
      valid = false;
    } else {
      _addressError = null;
    }

    // Port validation (WiFi only)
    if (_selectedType == PrinterType.wifi) {
      final portText = _portController.text;
      if (portText.isEmpty) {
        _portError = 'Please enter port';
        valid = false;
      } else {
        final port = int.tryParse(portText);
        if (port == null || port < 1 || port > 65535) {
          _portError = 'Invalid port number';
          valid = false;
        } else {
          _portError = null;
        }
      }
    } else {
      _portError = null;
    }

    // Copies validation
    final copiesText = _copiesController.text;
    if (copiesText.isEmpty) {
      _copiesError = 'Please enter number of copies';
      valid = false;
    } else {
      final copies = int.tryParse(copiesText);
      if (copies == null || copies < 1 || copies > 10) {
        _copiesError = 'Must be between 1 and 10';
        valid = false;
      } else {
        _copiesError = null;
      }
    }

    setState(() {});
    return valid;
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
        _nameError = null;
        _addressError = null;
      });
    }
  }

  void _submit() {
    if (!_validate()) {
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

    return FiftyDialog(
      title: 'Add Printer',
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Printer Type
              FiftySegmentedControl<PrinterType>(
                segments: [
                  FiftySegment(
                    value: PrinterType.bluetooth,
                    label: 'Bluetooth',
                    icon: Icons.bluetooth,
                  ),
                  FiftySegment(
                    value: PrinterType.wifi,
                    label: 'WiFi',
                    icon: Icons.wifi,
                  ),
                ],
                selected: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _addressError = null;
                    _portError = null;
                  });
                },
                expanded: true,
              ),

              SizedBox(height: FiftySpacing.xxl),

              // Printer Name
              FiftyTextField(
                controller: _nameController,
                label: 'Printer Name',
                hint: 'Kitchen Printer',
                errorText: _nameError,
                prefix: const Icon(Icons.print),
                onChanged: (_) => setState(() => _nameError = null),
              ),

              SizedBox(height: FiftySpacing.lg),

              // Address (MAC or IP)
              FiftyTextField(
                controller: _addressController,
                label: _selectedType == PrinterType.bluetooth
                    ? 'MAC Address'
                    : 'IP Address',
                hint: _selectedType == PrinterType.bluetooth
                    ? '00:11:22:33:44:55'
                    : '192.168.1.100',
                errorText: _addressError,
                prefix: Icon(_selectedType == PrinterType.bluetooth
                    ? Icons.bluetooth
                    : Icons.lan),
                suffix: _selectedType == PrinterType.bluetooth
                    ? IconButton(
                        icon: Icon(
                          Icons.bluetooth_searching,
                          color: colorScheme.primary,
                        ),
                        tooltip: 'Scan for printers',
                        onPressed: _scanForBluetoothPrinters,
                      )
                    : null,
                onChanged: (_) => setState(() => _addressError = null),
              ),

              // Port (WiFi only)
              if (_selectedType == PrinterType.wifi) ...[
                SizedBox(height: FiftySpacing.lg),
                FiftyTextField(
                  controller: _portController,
                  label: 'Port',
                  hint: '9100',
                  errorText: _portError,
                  prefix: const Icon(Icons.numbers),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() => _portError = null),
                ),
              ],

              SizedBox(height: FiftySpacing.lg),

              // Printer Role (optional)
              FiftyDropdown<PrinterRole>(
                value: _selectedRole,
                label: 'Role (Optional)',
                hint: 'Select a role',
                items: PrinterRole.values.map((role) {
                  return FiftyDropdownItem(
                    value: role,
                    label: role.name.toUpperCase(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
              ),

              SizedBox(height: FiftySpacing.lg),

              // Default Copies
              FiftyTextField(
                controller: _copiesController,
                label: 'Default Copies',
                hint: '1',
                errorText: _copiesError,
                prefix: const Icon(Icons.copy_all),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() => _copiesError = null),
              ),

              SizedBox(height: FiftySpacing.lg),

              // Info card
              Container(
                padding: EdgeInsets.all(FiftySpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: FiftyRadii.lgRadius,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    SizedBox(width: FiftySpacing.sm),
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
      actions: [
        FiftyButton(
          label: 'Cancel',
          variant: FiftyButtonVariant.ghost,
          onPressed: () => Navigator.pop(context),
        ),
        FiftyButton(
          label: 'Add',
          onPressed: _submit,
        ),
      ],
    );
  }
}
