import 'dart:async';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import '../widgets/add_printer_dialog.dart';
import '../widgets/printer_list_item.dart';

class PrinterManagementScreen extends StatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  State<PrinterManagementScreen> createState() => _PrinterManagementScreenState();
}

class _PrinterManagementScreenState extends State<PrinterManagementScreen> {
  final PrintingEngine _engine = PrintingEngine.instance;
  List<PrinterDevice> _printers = [];
  StreamSubscription<PrinterStatusEvent>? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _loadPrinters();
    _listenToStatusUpdates();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  void _loadPrinters() {
    setState(() {
      _printers = _engine.getAvailablePrinters();
    });
  }

  void _listenToStatusUpdates() {
    _statusSubscription = _engine.statusStream.listen((event) {
      // Reload printers when status changes
      _loadPrinters();

      // Show snackbar for important status changes
      if (event.newStatus == PrinterStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printer ${event.printerId}: ${event.message ?? "Error"}'),
            backgroundColor: FiftyColors.error,
          ),
        );
      }
    });
  }

  Future<void> _showAddPrinterDialog() async {
    final result = await showDialog<PrinterDevice>(
      context: context,
      builder: (context) => const AddPrinterDialog(),
    );

    if (result != null) {
      _engine.registerPrinter(result);
      _loadPrinters();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added printer: ${result.name}'),
            backgroundColor: FiftyColors.success,
          ),
        );
      }
    }
  }

  void _removePrinter(PrinterDevice printer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FiftyColors.gunmetal,
        title: Text(
          'Remove Printer',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        content: Text(
          'Are you sure you want to remove "${printer.name}"?',
          style: TextStyle(color: FiftyColors.hyperChrome),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: FiftyColors.hyperChrome),
            ),
          ),
          FiftyButton(
            label: 'Remove',
            variant: FiftyButtonVariant.danger,
            size: FiftyButtonSize.small,
            onPressed: () {
              _engine.removePrinter(printer.id);
              _loadPrinters();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed printer: ${printer.name}'),
                  backgroundColor: FiftyColors.warning,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _connectPrinter(PrinterDevice printer) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to ${printer.name}...'),
        backgroundColor: FiftyColors.gunmetal,
      ),
    );

    final success = await printer.connect();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
            ? 'Connected to ${printer.name}'
            : 'Failed to connect to ${printer.name}'),
          backgroundColor: success ? FiftyColors.success : FiftyColors.error,
        ),
      );
    }

    _loadPrinters();
  }

  Future<void> _disconnectPrinter(PrinterDevice printer) async {
    await printer.disconnect();
    _loadPrinters();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Disconnected from ${printer.name}'),
          backgroundColor: FiftyColors.gunmetal,
        ),
      );
    }
  }

  Future<void> _checkHealth(PrinterDevice printer) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checking ${printer.name}...'),
        backgroundColor: FiftyColors.gunmetal,
      ),
    );

    final healthy = await _engine.checkPrinterHealth(printer.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(healthy
            ? '${printer.name} is healthy'
            : '${printer.name} health check failed'),
          backgroundColor: healthy ? FiftyColors.success : FiftyColors.error,
        ),
      );
    }

    _loadPrinters();
  }

  Future<void> _checkAllPrinters() async {
    if (_printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No printers registered'),
          backgroundColor: FiftyColors.warning,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checking all printers...'),
        backgroundColor: FiftyColors.gunmetal,
      ),
    );

    final results = await _engine.checkAllPrinters();
    final healthy = results.values.where((h) => h).length;
    final total = results.length;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Health check: $healthy/$total printers healthy'),
          backgroundColor: healthy == total ? FiftyColors.success : FiftyColors.warning,
        ),
      );
    }

    _loadPrinters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Printer Management',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        backgroundColor: FiftyColors.voidBlack,
        actions: [
          IconButton(
            icon: Icon(Icons.health_and_safety, color: FiftyColors.terminalWhite),
            tooltip: 'Check all printers',
            onPressed: _checkAllPrinters,
          ),
        ],
      ),
      body: _printers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(FiftySpacing.lg),
              itemCount: _printers.length,
              itemBuilder: (context, index) {
                final printer = _printers[index];
                return PrinterListItem(
                  printer: printer,
                  onConnect: () => _connectPrinter(printer),
                  onDisconnect: () => _disconnectPrinter(printer),
                  onCheckHealth: () => _checkHealth(printer),
                  onRemove: () => _removePrinter(printer),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPrinterDialog,
        icon: Icon(Icons.add, color: FiftyColors.terminalWhite),
        label: Text(
          'Add Printer',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        backgroundColor: FiftyColors.crimsonPulse,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(FiftySpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print_disabled,
              size: 80,
              color: FiftyColors.hyperChrome,
            ),
            SizedBox(height: FiftySpacing.xxl),
            Text(
              'No Printers Registered',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: FiftyColors.hyperChrome,
                  ),
            ),
            SizedBox(height: FiftySpacing.md),
            Text(
              'Add your first Bluetooth or WiFi printer to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FiftyColors.hyperChrome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
