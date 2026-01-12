import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
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
        title: Text(
          'Test Print',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        backgroundColor: FiftyColors.voidBlack,
      ),
      body: ListView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Routing Mode Selection
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Printing Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.md),
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
                SizedBox(height: FiftySpacing.md),
                _buildModeDescription(),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.lg),

          // Role Mapping (if role-based mode)
          if (_currentMode == PrintingMode.roleBasedRouting)
            _buildRoleMappingCard(),

          // Sample Tickets
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Tickets',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.lg),
                _buildSampleTicketButton(
                  title: 'Kitchen Order',
                  description: 'Print a sample kitchen order ticket',
                  icon: Icons.restaurant_menu,
                  color: FiftyColors.warning,
                  onPressed: _printKitchenTicket,
                ),
                SizedBox(height: FiftySpacing.md),
                _buildSampleTicketButton(
                  title: 'Receipt',
                  description: 'Print a sample receipt',
                  icon: Icons.receipt_long,
                  color: FiftyColors.crimsonPulse,
                  onPressed: _printReceiptTicket,
                ),
                SizedBox(height: FiftySpacing.md),
                _buildSampleTicketButton(
                  title: 'Simple Test',
                  description: 'Print a simple "Hello World" ticket',
                  icon: Icons.check_circle,
                  color: FiftyColors.success,
                  onPressed: _printSimpleTicket,
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.lg),

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
        color = FiftyColors.crimsonPulse;
        break;
      case PrintingMode.roleBasedRouting:
        description = 'Routes to printers based on assigned roles';
        icon = Icons.category;
        color = FiftyColors.crimsonPulse;
        break;
      case PrintingMode.selectPerPrint:
        description = 'Manually select target printers before each print';
        icon = Icons.touch_app;
        color = FiftyColors.success;
        break;
    }

    return Container(
      padding: EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: FiftyColors.terminalWhite,
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

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.lg),
      margin: EdgeInsets.only(bottom: FiftySpacing.lg),
      scanlineOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role Mappings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.terminalWhite,
                ),
          ),
          SizedBox(height: FiftySpacing.md),
          ...PrinterRole.values.map((role) {
            final rolePrinters = printers.where((p) => p.role == role).toList();
            return Padding(
              padding: EdgeInsets.only(bottom: FiftySpacing.sm),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: FiftySpacing.sm,
                      vertical: FiftySpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: FiftyColors.crimsonPulse.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.assignment, size: 14, color: FiftyColors.crimsonPulse),
                        SizedBox(width: FiftySpacing.xs),
                        Text(
                          role.name.toUpperCase(),
                          style: TextStyle(
                            color: FiftyColors.crimsonPulse,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      rolePrinters.isEmpty
                          ? 'No printers assigned'
                          : rolePrinters.map((p) => p.name).join(', '),
                      style: TextStyle(
                        color: rolePrinters.isEmpty
                            ? FiftyColors.hyperChrome
                            : FiftyColors.terminalWhite,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: FiftySpacing.sm),
          Container(
            padding: EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: FiftyColors.warning.withOpacity(0.1),
              borderRadius: FiftyRadii.standardRadius,
              border: Border.all(color: FiftyColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: FiftyColors.warning, size: 20),
                SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: Text(
                    'Assign roles to printers in the Printer Management screen',
                    style: TextStyle(
                      color: FiftyColors.terminalWhite,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    return FiftyCard(
      onTap: onPressed,
      padding: EdgeInsets.all(FiftySpacing.lg),
      scanlineOnHover: false,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: FiftySpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: FiftyColors.terminalWhite,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  description,
                  style: TextStyle(
                    color: FiftyColors.hyperChrome,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.print, color: FiftyColors.hyperChrome),
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
      _showSnackBar('No printers registered', FiftyColors.warning);
      return;
    }

    // Generate ticket
    final ticket = await generator();

    // Show printing message
    _showSnackBar('Printing $ticketName...', FiftyColors.gunmetal);

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
        FiftyColors.success,
      );
    } else if (result.isPartialSuccess) {
      _showSnackBar(
        'Partial success: ${result.successCount}/${result.totalPrinters}',
        FiftyColors.warning,
      );
    } else {
      _showSnackBar('Print failed on all printers', FiftyColors.error);
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
