import 'dart:async';
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
            backgroundColor: Colors.red,
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
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _removePrinter(PrinterDevice printer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Printer'),
        content: Text('Are you sure you want to remove "${printer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _engine.removePrinter(printer.id);
              _loadPrinters();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed printer: ${printer.name}'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectPrinter(PrinterDevice printer) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to ${printer.name}...'),
      ),
    );

    final success = await printer.connect();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
            ? 'Connected to ${printer.name}'
            : 'Failed to connect to ${printer.name}'),
          backgroundColor: success ? Colors.green : Colors.red,
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
        ),
      );
    }
  }

  Future<void> _checkHealth(PrinterDevice printer) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checking ${printer.name}...'),
      ),
    );

    final healthy = await _engine.checkPrinterHealth(printer.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(healthy
            ? '${printer.name} is healthy'
            : '${printer.name} health check failed'),
          backgroundColor: healthy ? Colors.green : Colors.red,
        ),
      );
    }

    _loadPrinters();
  }

  Future<void> _checkAllPrinters() async {
    if (_printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No printers registered'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking all printers...'),
      ),
    );

    final results = await _engine.checkAllPrinters();
    final healthy = results.values.where((h) => h).length;
    final total = results.length;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Health check: $healthy/$total printers healthy'),
          backgroundColor: healthy == total ? Colors.green : Colors.orange,
        ),
      );
    }

    _loadPrinters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.health_and_safety),
            tooltip: 'Check all printers',
            onPressed: _checkAllPrinters,
          ),
        ],
      ),
      body: _printers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
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
        icon: const Icon(Icons.add),
        label: const Text('Add Printer'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print_disabled,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Printers Registered',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first Bluetooth or WiFi printer to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _showAddPrinterDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Printer'),
            ),
          ],
        ),
      ),
    );
  }
}
