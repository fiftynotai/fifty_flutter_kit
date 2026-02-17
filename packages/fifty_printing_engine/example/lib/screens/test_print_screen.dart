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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Print'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Routing Mode Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Printing Mode',
                    style: textTheme.titleMedium?.copyWith(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Tickets',
                    style: textTheme.titleMedium?.copyWith(
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
                    color: colorScheme.primary,
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
    final colorScheme = Theme.of(context).colorScheme;

    String description;
    IconData icon;
    Color color;

    switch (_currentMode) {
      case PrintingMode.printToAll:
        description = 'Prints to all registered printers';
        icon = Icons.grid_view;
        color = colorScheme.primary;
        break;
      case PrintingMode.roleBasedRouting:
        description = 'Routes to printers based on assigned roles';
        icon = Icons.category;
        color = colorScheme.tertiary;
        break;
      case PrintingMode.selectPerPrint:
        description = 'Manually select target printers before each print';
        icon = Icons.touch_app;
        color = colorScheme.secondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleMappingCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final printers = _engine.getAvailablePrinters();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role Mappings',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...PrinterRole.values.map((role) {
              final rolePrinters = printers.where((p) => p.role == role).toList();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.assignment, size: 14, color: colorScheme.onPrimaryContainer),
                          const SizedBox(width: 4),
                          Text(
                            role.name.toUpperCase(),
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rolePrinters.isEmpty
                            ? 'No printers assigned'
                            : rolePrinters.map((p) => p.name).join(', '),
                        style: TextStyle(
                          color: rolePrinters.isEmpty
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface,
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
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.onTertiaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Assign roles to printers in the Printer Management screen',
                      style: TextStyle(
                        color: colorScheme.onTertiaryContainer,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
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
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.print, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
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
    final printers = _engine.getAvailablePrinters();
    if (printers.isEmpty) {
      _showSnackBar('No printers registered', Colors.orange);
      return;
    }

    final ticket = await generator();

    if (!mounted) return;
    final errorColor = Theme.of(context).colorScheme.error;

    _showSnackBar('Printing $ticketName...', Theme.of(context).colorScheme.surfaceContainerHighest);

    PrintResult result;
    if (_currentMode == PrintingMode.roleBasedRouting && targetRole != null) {
      result = await _engine.print(ticket: ticket, targetRole: targetRole);
    } else if (_currentMode == PrintingMode.selectPerPrint) {
      if (!mounted) return;
      final selectedIds = await showDialog<List<String>>(
        context: context,
        builder: (context) => PrinterSelectionDialog(
          availablePrinters: printers,
        ),
      );

      if (selectedIds == null || selectedIds.isEmpty) {
        return;
      }

      result = await _engine.print(
        ticket: ticket,
        targetPrinterIds: selectedIds,
      );
    } else {
      result = await _engine.print(ticket: ticket);
    }

    setState(() {
      _lastResult = result;
    });

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
      _showSnackBar('Print failed on all printers', errorColor);
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
