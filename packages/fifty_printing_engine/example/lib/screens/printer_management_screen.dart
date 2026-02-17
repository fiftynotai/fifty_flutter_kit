import 'dart:async';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import '../widgets/add_printer_dialog.dart';
import '../widgets/printer_list_item.dart';

class PrinterManagementScreen extends StatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  State<PrinterManagementScreen> createState() =>
      _PrinterManagementScreenState();
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
      _loadPrinters();

      if (event.newStatus == PrinterStatus.error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Printer ${event.printerId}: ${event.message ?? "Error"}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  Future<void> _showAddPrinterDialog() async {
    final result = await showFiftyDialog<PrinterDevice>(
      context: context,
      builder: (context) => const AddPrinterDialog(),
    );

    if (result != null) {
      _engine.registerPrinter(result);
      _loadPrinters();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added printer: ${result.name}')),
        );
      }
    }
  }

  void _removePrinter(PrinterDevice printer) {
    showFiftyDialog(
      context: context,
      builder: (context) => FiftyDialog(
        title: 'Remove Printer',
        content:
            Text('Are you sure you want to remove "${printer.name}"?'),
        actions: [
          FiftyButton(
            label: 'Cancel',
            variant: FiftyButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
          FiftyButton(
            label: 'Remove',
            variant: FiftyButtonVariant.danger,
            onPressed: () {
              _engine.removePrinter(printer.id);
              _loadPrinters();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Removed printer: ${printer.name}')),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _connectPrinter(PrinterDevice printer) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connecting to ${printer.name}...')),
    );

    final success = await printer.connect();

    if (mounted) {
      final fifty =
          Theme.of(context).extension<FiftyThemeExtension>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Connected to ${printer.name}'
              : 'Failed to connect to ${printer.name}'),
          backgroundColor: success
              ? fifty.success
              : Theme.of(context).colorScheme.error,
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
        SnackBar(content: Text('Disconnected from ${printer.name}')),
      );
    }
  }

  Future<void> _checkHealth(PrinterDevice printer) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checking ${printer.name}...')),
    );

    final healthy = await _engine.checkPrinterHealth(printer.id);

    if (mounted) {
      final fifty =
          Theme.of(context).extension<FiftyThemeExtension>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(healthy
              ? '${printer.name} is healthy'
              : '${printer.name} health check failed'),
          backgroundColor: healthy
              ? fifty.success
              : Theme.of(context).colorScheme.error,
        ),
      );
    }

    _loadPrinters();
  }

  Future<void> _checkAllPrinters() async {
    if (_printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No printers registered')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking all printers...')),
    );

    final results = await _engine.checkAllPrinters();
    final healthy = results.values.where((h) => h).length;
    final total = results.length;

    if (mounted) {
      final fifty =
          Theme.of(context).extension<FiftyThemeExtension>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Health check: $healthy/$total printers healthy'),
          backgroundColor:
              healthy == total ? fifty.success : fifty.warning,
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
        actions: [
          FiftyIconButton(
            icon: Icons.health_and_safety,
            tooltip: 'Check all printers',
            onPressed: _checkAllPrinters,
          ),
        ],
      ),
      body: _printers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(FiftySpacing.lg),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FiftySpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print_disabled,
              size: 80,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: FiftySpacing.xxl),
            Text(
              'No Printers Registered',
              style:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
            ),
            const SizedBox(height: FiftySpacing.md),
            Text(
              'Add your first Bluetooth or WiFi printer to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
