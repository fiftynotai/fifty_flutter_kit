import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class BluetoothScanSheet extends StatefulWidget {
  const BluetoothScanSheet({super.key});

  @override
  State<BluetoothScanSheet> createState() => _BluetoothScanSheetState();
}

class _BluetoothScanSheetState extends State<BluetoothScanSheet> {
  final PrintingEngine _engine = PrintingEngine.instance;
  bool _isScanning = true;
  List<DiscoveredPrinter> _discoveredPrinters = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _scanForPrinters();
  }

  Future<void> _scanForPrinters() async {
    setState(() {
      _isScanning = true;
      _error = null;
    });

    try {
      // Scan for printers (package handles permissions + Bluetooth check internally)
      final printers = await _engine.scanBluetoothPrinters(
        filterPrintersOnly: true,  // Filter to printers using comprehensive keyword list
      );

      setState(() {
        _discoveredPrinters = printers;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.bluetooth_searching, color: Colors.blue),
              const SizedBox(width: 12),
              Text(
                'Scan for Bluetooth Printers',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Loading State
          if (_isScanning) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Scanning for Bluetooth printers...'),
                  ],
                ),
              ),
            ),
          ],

          // Error State
          if (_error != null && !_isScanning) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (_error!.contains('permission') || _error!.contains('Settings'))
                    FilledButton.icon(
                      onPressed: () async {
                        await _engine.openBluetoothSettings();
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Open Settings'),
                    )
                  else
                    FilledButton.icon(
                      onPressed: _scanForPrinters,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                ],
              ),
            ),
          ],

          // Results
          if (!_isScanning && _error == null) ...[
            if (_discoveredPrinters.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Printers Found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make sure printer is paired in Bluetooth settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: _scanForPrinters,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Scan Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(
                '${_discoveredPrinters.length} printer(s) found',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _discoveredPrinters.length,
                  itemBuilder: (context, index) {
                    final printer = _discoveredPrinters[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.print, color: Colors.white, size: 20),
                        ),
                        title: Text(
                          printer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          printer.macAddress,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pop(context, printer);
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: _scanForPrinters,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
