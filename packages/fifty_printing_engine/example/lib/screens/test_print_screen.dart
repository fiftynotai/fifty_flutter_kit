import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Print'),
      ),
      body: ListView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Routing Mode Selection
          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FiftySectionHeader(
                  title: 'Printing Mode',
                  showDivider: false,
                ),
                FiftySegmentedControl<PrintingMode>(
                  segments: [
                    FiftySegment(
                      value: PrintingMode.printToAll,
                      label: 'All',
                      icon: Icons.grid_view,
                    ),
                    FiftySegment(
                      value: PrintingMode.roleBasedRouting,
                      label: 'Role',
                      icon: Icons.category,
                    ),
                    FiftySegment(
                      value: PrintingMode.selectPerPrint,
                      label: 'Select',
                      icon: Icons.touch_app,
                    ),
                  ],
                  selected: _currentMode,
                  onChanged: (value) {
                    setState(() {
                      _currentMode = value;
                      _engine.setPrintingMode(_currentMode);
                    });
                  },
                  expanded: true,
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
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FiftySectionHeader(
                  title: 'Sample Tickets',
                  showDivider: false,
                ),
                _buildSampleTicketButton(
                  title: 'Kitchen Order',
                  description: 'Print a sample kitchen order ticket',
                  icon: Icons.restaurant_menu,
                  iconColor: colorScheme.tertiary,
                  onPressed: _printKitchenTicket,
                ),
                SizedBox(height: FiftySpacing.md),
                _buildSampleTicketButton(
                  title: 'Receipt',
                  description: 'Print a sample receipt',
                  icon: Icons.receipt_long,
                  iconColor: colorScheme.primary,
                  onPressed: _printReceiptTicket,
                ),
                SizedBox(height: FiftySpacing.md),
                _buildSampleTicketButton(
                  title: 'Simple Test',
                  description: 'Print a simple "Hello World" ticket',
                  icon: Icons.check_circle,
                  iconColor: colorScheme.secondary,
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
        description =
            'Manually select target printers before each print';
        icon = Icons.touch_app;
        color = colorScheme.secondary;
        break;
    }

    return Container(
      padding: EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: FiftySpacing.md),
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
    final printers = _engine.getAvailablePrinters();

    return FiftyCard(
      scanlineOnHover: false,
      margin: EdgeInsets.only(bottom: FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FiftySectionHeader(
            title: 'Role Mappings',
            showDivider: false,
          ),
          ...PrinterRole.values.map((role) {
            final rolePrinters =
                printers.where((p) => p.role == role).toList();
            return Padding(
              padding: EdgeInsets.only(bottom: FiftySpacing.sm),
              child: Row(
                children: [
                  FiftyBadge(
                    label: role.name,
                    variant: FiftyBadgeVariant.primary,
                  ),
                  SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: Text(
                      rolePrinters.isEmpty
                          ? 'No printers assigned'
                          : rolePrinters
                              .map((p) => p.name)
                              .join(', '),
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
          SizedBox(height: FiftySpacing.sm),
          Container(
            padding: EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: colorScheme.onTertiaryContainer, size: 20),
                SizedBox(width: FiftySpacing.sm),
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
    );
  }

  Widget _buildSampleTicketButton({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      scanlineOnHover: false,
      onTap: onPressed,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.2),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: FiftySpacing.lg),
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
                SizedBox(height: FiftySpacing.xs),
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
        ticket.text(
          'Hello World!',
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            align: PosAlign.center,
          ),
        );
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
    final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;

    if (printers.isEmpty) {
      _showSnackBar('No printers registered', fifty.warning);
      return;
    }

    final ticket = await generator();

    if (!mounted) return;
    final errorColor = Theme.of(context).colorScheme.error;

    _showSnackBar('Printing $ticketName...',
        Theme.of(context).colorScheme.surfaceContainerHighest);

    PrintResult result;
    if (_currentMode == PrintingMode.roleBasedRouting &&
        targetRole != null) {
      result =
          await _engine.print(ticket: ticket, targetRole: targetRole);
    } else if (_currentMode == PrintingMode.selectPerPrint) {
      if (!mounted) return;
      final selectedIds = await showFiftyDialog<List<String>>(
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
        fifty.success,
      );
    } else if (result.isPartialSuccess) {
      _showSnackBar(
        'Partial success: ${result.successCount}/${result.totalPrinters}',
        fifty.warning,
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
