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
      backgroundColor: Colors.transparent,
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

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: FiftyColors.hyperChrome),
      hintText: hintText,
      hintStyle: TextStyle(color: FiftyColors.hyperChrome.withValues(alpha: 0.5)),
      border: OutlineInputBorder(
        borderRadius: FiftyRadii.standardRadius,
        borderSide: BorderSide(color: FiftyColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.standardRadius,
        borderSide: BorderSide(color: FiftyColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.standardRadius,
        borderSide: BorderSide(color: FiftyColors.crimsonPulse),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.standardRadius,
        borderSide: BorderSide(color: FiftyColors.error),
      ),
      prefixIcon: Icon(prefixIcon, color: FiftyColors.hyperChrome),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: FiftyColors.voidBlack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FiftyCard(
        padding: EdgeInsets.all(FiftySpacing.xxl),
        scanlineOnHover: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Add Printer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: FiftyColors.terminalWhite,
                        ),
                  ),

                  SizedBox(height: FiftySpacing.xxl),

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

                  SizedBox(height: FiftySpacing.xxl),

                  // Printer Name
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: FiftyColors.terminalWhite),
                    decoration: _buildInputDecoration(
                      labelText: 'Printer Name',
                      hintText: 'Kitchen Printer',
                      prefixIcon: Icons.print,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: FiftySpacing.lg),

                  // Address (MAC or IP)
                  TextFormField(
                    controller: _addressController,
                    style: TextStyle(color: FiftyColors.terminalWhite),
                    decoration: _buildInputDecoration(
                      labelText: _selectedType == PrinterType.bluetooth
                          ? 'MAC Address'
                          : 'IP Address',
                      hintText: _selectedType == PrinterType.bluetooth
                          ? '00:11:22:33:44:55'
                          : '192.168.1.100',
                      prefixIcon: _selectedType == PrinterType.bluetooth
                          ? Icons.bluetooth
                          : Icons.lan,
                      suffixIcon: _selectedType == PrinterType.bluetooth
                          ? IconButton(
                              icon: Icon(
                                Icons.bluetooth_searching,
                                color: FiftyColors.crimsonPulse,
                              ),
                              tooltip: 'Scan for printers',
                              onPressed: _scanForBluetoothPrinters,
                            )
                          : null,
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
                    SizedBox(height: FiftySpacing.lg),
                    TextFormField(
                      controller: _portController,
                      style: TextStyle(color: FiftyColors.terminalWhite),
                      decoration: _buildInputDecoration(
                        labelText: 'Port',
                        hintText: '9100',
                        prefixIcon: Icons.numbers,
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

                  SizedBox(height: FiftySpacing.lg),

                  // Printer Role (optional)
                  DropdownButtonFormField<PrinterRole>(
                    value: _selectedRole,
                    dropdownColor: FiftyColors.gunmetal,
                    style: TextStyle(color: FiftyColors.terminalWhite),
                    decoration: _buildInputDecoration(
                      labelText: 'Role (Optional)',
                      hintText: '',
                      prefixIcon: Icons.assignment,
                    ),
                    items: PrinterRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(
                          role.name.toUpperCase(),
                          style: TextStyle(color: FiftyColors.terminalWhite),
                        ),
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
                  TextFormField(
                    controller: _copiesController,
                    style: TextStyle(color: FiftyColors.terminalWhite),
                    decoration: _buildInputDecoration(
                      labelText: 'Default Copies',
                      hintText: '1',
                      prefixIcon: Icons.copy_all,
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

                  SizedBox(height: FiftySpacing.lg),

                  // Info card
                  Container(
                    padding: EdgeInsets.all(FiftySpacing.md),
                    decoration: BoxDecoration(
                      color: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
                      borderRadius: FiftyRadii.standardRadius,
                      border: Border.all(
                        color: FiftyColors.crimsonPulse.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: FiftyColors.crimsonPulse,
                          size: 20,
                        ),
                        SizedBox(width: FiftySpacing.sm),
                        Expanded(
                          child: Text(
                            'Set default copies per printer. Can be overridden per print job.',
                            style: TextStyle(
                              fontSize: 12,
                              color: FiftyColors.terminalWhite,
                            ),
                          ),
                        ),
                      ],
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
                        label: 'Add',
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
