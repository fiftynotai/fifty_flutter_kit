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
      padding: EdgeInsets.all(FiftySpacing.xxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(FiftyRadii.xxl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.bluetooth_searching, color: colorScheme.primary),
              SizedBox(width: FiftySpacing.md),
              Text(
                'Scan for Bluetooth Printers',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              FiftyIconButton(
                icon: Icons.close,
                tooltip: 'Close',
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
                    FiftyLoadingIndicator(
                      text: 'SCANNING',
                      style: FiftyLoadingStyle.dots,
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
                color: colorScheme.errorContainer,
                borderRadius: FiftyRadii.lgRadius,
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      color: colorScheme.onErrorContainer),
                  SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      _error!,
                      style:
                          TextStyle(color: colorScheme.onErrorContainer),
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
                  if (_error!.contains('permission') ||
                      _error!.contains('Settings'))
                    FiftyButton(
                      icon: Icons.settings,
                      label: 'Open Settings',
                      onPressed: () async {
                        await _engine.openBluetoothSettings();
                      },
                    )
                  else
                    FiftyButton(
                      icon: Icons.refresh,
                      label: 'Retry',
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
                padding: EdgeInsets.all(FiftySpacing.xxxl),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: FiftySpacing.lg),
                      Text(
                        'No Printers Found',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: FiftySpacing.sm),
                      Text(
                        'Make sure printer is paired in Bluetooth settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: FiftySpacing.xxl),
                      FiftyButton(
                        icon: Icons.refresh,
                        label: 'Scan Again',
                        variant: FiftyButtonVariant.outline,
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
              SizedBox(height: FiftySpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _discoveredPrinters.length,
                  itemBuilder: (context, index) {
                    final printer = _discoveredPrinters[index];
                    return FiftyCard(
                      scanlineOnHover: false,
                      margin: EdgeInsets.only(bottom: FiftySpacing.sm),
                      onTap: () {
                        Navigator.pop(context, printer);
                      },
                      child: FiftyListTile(
                        leadingIcon: Icons.print,
                        leadingIconColor: colorScheme.primary,
                        title: printer.name,
                        subtitle: printer.macAddress,
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
              SizedBox(height: FiftySpacing.lg),
              Center(
                child: FiftyButton(
                  icon: Icons.refresh,
                  label: 'Scan Again',
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
