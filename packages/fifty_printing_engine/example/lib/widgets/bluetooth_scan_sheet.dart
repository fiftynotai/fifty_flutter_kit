import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
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
      padding: EdgeInsets.all(FiftySpacing.xxl),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.bluetooth_searching, color: FiftyColors.crimsonPulse),
              SizedBox(width: FiftySpacing.md),
              Text(
                'Scan for Bluetooth Printers',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: FiftyColors.terminalWhite,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: FiftyColors.hyperChrome),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.lg),

          // Loading State
          if (_isScanning) ...[
            Center(
              child: Padding(
                padding: EdgeInsets.all(FiftySpacing.xxxl),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: FiftyColors.crimsonPulse,
                    ),
                    SizedBox(height: FiftySpacing.lg),
                    Text(
                      'Scanning for Bluetooth printers...',
                      style: TextStyle(color: FiftyColors.terminalWhite),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Error State
          if (_error != null && !_isScanning) ...[
            Container(
              padding: EdgeInsets.all(FiftySpacing.lg),
              decoration: BoxDecoration(
                color: FiftyColors.error.withValues(alpha: 0.1),
                borderRadius: FiftyRadii.standardRadius,
                border: Border.all(color: FiftyColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: FiftyColors.error),
                  SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: FiftyColors.terminalWhite),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: FiftySpacing.lg),
            Center(
              child: Wrap(
                spacing: FiftySpacing.sm,
                alignment: WrapAlignment.center,
                children: [
                  if (_error!.contains('permission') || _error!.contains('Settings'))
                    FiftyButton(
                      label: 'Open Settings',
                      icon: Icons.settings,
                      onPressed: () async {
                        await _engine.openBluetoothSettings();
                      },
                    )
                  else
                    FiftyButton(
                      label: 'Retry',
                      icon: Icons.refresh,
                      onPressed: _scanForPrinters,
                    ),
                ],
              ),
            ),
          ],

          // Results
          if (!_isScanning && _error == null) ...[
            if (_discoveredPrinters.isEmpty) ...[
              Container(
                padding: EdgeInsets.all(FiftySpacing.xxxl),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 64,
                        color: FiftyColors.hyperChrome,
                      ),
                      SizedBox(height: FiftySpacing.lg),
                      Text(
                        'No Printers Found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: FiftyColors.hyperChrome,
                            ),
                      ),
                      SizedBox(height: FiftySpacing.sm),
                      Text(
                        'Make sure printer is paired in Bluetooth settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: FiftyColors.hyperChrome,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: FiftySpacing.xxl),
                      FiftyButton(
                        label: 'Scan Again',
                        icon: Icons.refresh,
                        variant: FiftyButtonVariant.secondary,
                        onPressed: _scanForPrinters,
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Text(
                '${_discoveredPrinters.length} printer(s) found',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: FiftyColors.hyperChrome,
                    ),
              ),
              SizedBox(height: FiftySpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _discoveredPrinters.length,
                  itemBuilder: (context, index) {
                    final printer = _discoveredPrinters[index];
                    return FiftyCard(
                      margin: EdgeInsets.only(bottom: FiftySpacing.sm),
                      padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context, printer);
                      },
                      scanlineOnHover: false,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: FiftyColors.crimsonPulse,
                          child: Icon(
                            Icons.print,
                            color: FiftyColors.terminalWhite,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          printer.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.terminalWhite,
                          ),
                        ),
                        subtitle: Text(
                          printer.macAddress,
                          style: TextStyle(
                            color: FiftyColors.hyperChrome,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: FiftyColors.hyperChrome,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: FiftySpacing.lg),
              Center(
                child: FiftyButton(
                  label: 'Scan Again',
                  icon: Icons.refresh,
                  variant: FiftyButtonVariant.ghost,
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
