import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import '../examples/kitchen_ticket_example.dart';
import '../examples/receipt_ticket_example.dart';
import '../widgets/print_result_widget.dart';
import '../widgets/printer_selection_dialog.dart';

class TestPrintScreen extends StatefulWidget {
  const TestPrintScreen({super.key});

  @override
  State<TestPrintScreen> createState() => _TestPrintScreenState();
}

class _TestPrintScreenState extends State<TestPrintScreen> {
  final PrintingEngine _engine = PrintingEngine.instance;
  PrintingMode _currentMode = PrintingMode.printToAll;
  PrintResult? _lastResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Print'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Routing Mode Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Printing Mode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<PrintingMode>(
                    segments: const [
                      ButtonSegment(
                        value: PrintingMode.printToAll,
                        label: Text('All'),
                        icon: Icon(Icons.grid_view, size: 18),
                      ),
                      ButtonSegment(
                        value: PrintingMode.roleBasedRouting,
                        label: Text('Role'),
                        icon: Icon(Icons.category, size: 18),
                      ),
                      ButtonSegment(
                        value: PrintingMode.selectPerPrint,
                        label: Text('Select'),
                        icon: Icon(Icons.touch_app, size: 18),
                      ),
                    ],
                    selected: {_currentMode},
                    onSelectionChanged: (Set<PrintingMode> selection) {
                      setState(() {
                        _currentMode = selection.first;
                        _engine.setPrintingMode(_currentMode);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildModeDescription(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Role Mapping (if role-based mode)
          if (_currentMode == PrintingMode.roleBasedRouting)
            _buildRoleMappingCard(),

          // Sample Tickets
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Tickets',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSampleTicketButton(
                    title: 'Kitchen Order',
                    description: 'Print a sample kitchen order ticket',
                    icon: Icons.restaurant_menu,
                    color: Colors.orange,
                    onPressed: _printKitchenTicket,
                  ),
                  const SizedBox(height: 12),
                  _buildSampleTicketButton(
                    title: 'Receipt',
                    description: 'Print a sample receipt',
                    icon: Icons.receipt_long,
                    color: Colors.blue,
                    onPressed: _printReceiptTicket,
                  ),
                  const SizedBox(height: 12),
                  _buildSampleTicketButton(
                    title: 'Simple Test',
                    description: 'Print a simple "Hello World" ticket',
                    icon: Icons.check_circle,
                    color: Colors.green,
                    onPressed: _printSimpleTicket,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Last Print Result
          if (_lastResult != null)
            PrintResultWidget(result: _lastResult!),
        ],
      ),
    );
  }

  Widget _buildModeDescription() {
    String description;
    IconData icon;
    Color color;

    switch (_currentMode) {
      case PrintingMode.printToAll:
        description = 'Prints to all registered printers';
        icon = Icons.grid_view;
        color = Colors.blue;
        break;
      case PrintingMode.roleBasedRouting:
        description = 'Routes to printers based on assigned roles';
        icon = Icons.category;
        color = Colors.purple;
        break;
      case PrintingMode.selectPerPrint:
        description = 'Manually select target printers before each print';
        icon = Icons.touch_app;
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleMappingCard() {
    final printers = _engine.getAvailablePrinters();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role Mappings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...PrinterRole.values.map((role) {
              final rolePrinters = printers.where((p) => p.role == role).toList();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Chip(
                      label: Text(role.name.toUpperCase()),
                      avatar: const Icon(Icons.assignment, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rolePrinters.isEmpty
                            ? 'No printers assigned'
                            : rolePrinters.map((p) => p.name).join(', '),
                        style: TextStyle(
                          color: rolePrinters.isEmpty ? Colors.grey : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Assign roles to printers in the Printer Management screen',
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleTicketButton({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.print),
        ],
      ),
    );
  }

  Future<void> _printKitchenTicket() async {
    await _executePrint(
      ticketName: 'Kitchen Order',
      generator: () => KitchenTicketExample.generate(),
      targetRole: PrinterRole.kitchen,
    );
  }

  Future<void> _printReceiptTicket() async {
    await _executePrint(
      ticketName: 'Receipt',
      generator: () => ReceiptTicketExample.generate(),
      targetRole: PrinterRole.receipt,
    );
  }

  Future<void> _printSimpleTicket() async {
    await _executePrint(
      ticketName: 'Simple Test',
      generator: () async {
        final profile = await CapabilityProfile.load();
        final ticket = PrintTicket(PaperSize.mm80, profile);
        ticket.text('Hello World!', styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          align: PosAlign.center,
        ));
        ticket.feed(2);
        ticket.cut();
        return ticket;
      },
    );
  }

  Future<void> _executePrint({
    required String ticketName,
    required Future<PrintTicket> Function() generator,
    PrinterRole? targetRole,
  }) async {
    // Check if printers are registered
    final printers = _engine.getAvailablePrinters();
    if (printers.isEmpty) {
      _showSnackBar('No printers registered', Colors.orange);
      return;
    }

    // Generate ticket
    final ticket = await generator();

    // Show printing message
    _showSnackBar('Printing $ticketName...', Colors.blue);

    // Print based on mode
    PrintResult result;
    if (_currentMode == PrintingMode.roleBasedRouting && targetRole != null) {
      result = await _engine.print(ticket: ticket, targetRole: targetRole);
    } else if (_currentMode == PrintingMode.selectPerPrint) {
      // Show printer selection dialog
      final selectedIds = await showDialog<List<String>>(
        context: context,
        builder: (context) => PrinterSelectionDialog(
          availablePrinters: printers,
        ),
      );

      // User cancelled
      if (selectedIds == null || selectedIds.isEmpty) {
        return;
      }

      result = await _engine.print(
        ticket: ticket,
        targetPrinterIds: selectedIds,
      );
    } else {
      // Print to all
      result = await _engine.print(ticket: ticket);
    }

    // Update UI with result
    setState(() {
      _lastResult = result;
    });

    // Show result snackbar
    if (result.isSuccess) {
      _showSnackBar(
        'Printed to ${result.successCount} printer(s)',
        Colors.green,
      );
    } else if (result.isPartialSuccess) {
      _showSnackBar(
        'Partial success: ${result.successCount}/${result.totalPrinters}',
        Colors.orange,
      );
    } else {
      _showSnackBar('Print failed on all printers', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
