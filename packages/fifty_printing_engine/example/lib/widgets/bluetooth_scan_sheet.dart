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
      final printers = await _engine.scanBluetoothPrinters(
        filterPrintersOnly: true,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.bluetooth_searching, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Scan for Bluetooth Printers',
                style: textTheme.titleSmall?.copyWith(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text('Scanning for Bluetooth printers...'),
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
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: colorScheme.onErrorContainer),
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
                      icon: const Icon(Icons.settings),
                      label: const Text('Open Settings'),
                      onPressed: () async {
                        await _engine.openBluetoothSettings();
                      },
                    )
                  else
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      onPressed: _scanForPrinters,
                    ),
                ],
              ),
            ),
          ],

          // Results
          if (!_isScanning && _error == null) ...[
            if (_discoveredPrinters.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Printers Found',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make sure printer is paired in Bluetooth settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Scan Again'),
                        onPressed: _scanForPrinters,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(
                '${_discoveredPrinters.length} printer(s) found',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, printer);
                        },
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primary,
                          child: Icon(
                            Icons.print,
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          printer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          printer.macAddress,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                  onPressed: _scanForPrinters,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
