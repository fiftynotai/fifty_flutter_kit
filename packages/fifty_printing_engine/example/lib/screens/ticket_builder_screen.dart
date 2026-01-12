import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class TicketBuilderScreen extends StatefulWidget {
  const TicketBuilderScreen({super.key});

  @override
  State<TicketBuilderScreen> createState() => _TicketBuilderScreenState();
}

class _TicketBuilderScreenState extends State<TicketBuilderScreen> {
  final PrintingEngine _engine = PrintingEngine.instance;
  final _textController = TextEditingController();
  bool _bold = false;
  bool _underline = false;
  PosTextSize _textSize = PosTextSize.size1;
  PosAlign _align = PosAlign.left;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Builder',
          style: TextStyle(color: FiftyColors.terminalWhite),
        ),
        backgroundColor: FiftyColors.voidBlack,
      ),
      body: ListView(
        padding: EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Instructions Card
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            backgroundColor: FiftyColors.crimsonPulse.withOpacity(0.1),
            scanlineOnHover: false,
            child: Row(
              children: [
                Icon(Icons.info_outline, color: FiftyColors.crimsonPulse),
                SizedBox(width: FiftySpacing.md),
                Expanded(
                  child: Text(
                    'Build a custom ticket with text formatting',
                    style: TextStyle(
                      color: FiftyColors.terminalWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.lg),

          // Text Input
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Text Content',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.md),
                TextField(
                  controller: _textController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Enter text to print',
                    hintStyle: TextStyle(color: FiftyColors.hyperChrome),
                    border: OutlineInputBorder(
                      borderRadius: FiftyRadii.standardRadius,
                      borderSide: BorderSide(color: FiftyColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: FiftyRadii.standardRadius,
                      borderSide: BorderSide(color: FiftyColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: FiftyRadii.standardRadius,
                      borderSide: BorderSide(color: FiftyColors.crimsonPulse),
                    ),
                    filled: true,
                    fillColor: FiftyColors.voidBlack,
                  ),
                  style: TextStyle(color: FiftyColors.terminalWhite),
                  maxLines: 3,
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.lg),

          // Formatting Options
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formatting',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.lg),

                // Bold and Underline
                Wrap(
                  spacing: FiftySpacing.sm,
                  children: [
                    FilterChip(
                      label: Text(
                        'Bold',
                        style: TextStyle(
                          color: _bold
                              ? FiftyColors.terminalWhite
                              : FiftyColors.hyperChrome,
                        ),
                      ),
                      selected: _bold,
                      selectedColor: FiftyColors.crimsonPulse.withOpacity(0.3),
                      checkmarkColor: FiftyColors.crimsonPulse,
                      backgroundColor: FiftyColors.gunmetal,
                      onSelected: (value) {
                        setState(() {
                          _bold = value;
                        });
                      },
                    ),
                    FilterChip(
                      label: Text(
                        'Underline',
                        style: TextStyle(
                          color: _underline
                              ? FiftyColors.terminalWhite
                              : FiftyColors.hyperChrome,
                        ),
                      ),
                      selected: _underline,
                      selectedColor: FiftyColors.crimsonPulse.withOpacity(0.3),
                      checkmarkColor: FiftyColors.crimsonPulse,
                      backgroundColor: FiftyColors.gunmetal,
                      onSelected: (value) {
                        setState(() {
                          _underline = value;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: FiftySpacing.lg),

                // Text Size
                Text(
                  'Text Size',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.sm),
                SegmentedButton<PosTextSize>(
                  segments: const [
                    ButtonSegment(
                      value: PosTextSize.size1,
                      label: Text('1x'),
                    ),
                    ButtonSegment(
                      value: PosTextSize.size2,
                      label: Text('2x'),
                    ),
                    ButtonSegment(
                      value: PosTextSize.size3,
                      label: Text('3x'),
                    ),
                  ],
                  selected: {_textSize},
                  onSelectionChanged: (Set<PosTextSize> selection) {
                    setState(() {
                      _textSize = selection.first;
                    });
                  },
                ),

                SizedBox(height: FiftySpacing.lg),

                // Alignment
                Text(
                  'Alignment',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.sm),
                SegmentedButton<PosAlign>(
                  segments: const [
                    ButtonSegment(
                      value: PosAlign.left,
                      icon: Icon(Icons.format_align_left, size: 18),
                    ),
                    ButtonSegment(
                      value: PosAlign.center,
                      icon: Icon(Icons.format_align_center, size: 18),
                    ),
                    ButtonSegment(
                      value: PosAlign.right,
                      icon: Icon(Icons.format_align_right, size: 18),
                    ),
                  ],
                  selected: {_align},
                  onSelectionChanged: (Set<PosAlign> selection) {
                    setState(() {
                      _align = selection.first;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: FiftySpacing.xxl),

          // Print Button
          FiftyButton(
            label: 'Print Custom Ticket',
            icon: Icons.print,
            onPressed: _printCustomTicket,
            expanded: true,
            size: FiftyButtonSize.large,
          ),

          SizedBox(height: FiftySpacing.lg),

          // Preview Card
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                      ),
                ),
                SizedBox(height: FiftySpacing.md),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(FiftySpacing.lg),
                  decoration: BoxDecoration(
                    color: FiftyColors.voidBlack,
                    borderRadius: FiftyRadii.standardRadius,
                    border: Border.all(color: FiftyColors.border),
                  ),
                  child: Text(
                    _textController.text.isEmpty
                        ? 'Your text will appear here'
                        : _textController.text,
                    textAlign: _align == PosAlign.center
                        ? TextAlign.center
                        : _align == PosAlign.right
                            ? TextAlign.right
                            : TextAlign.left,
                    style: TextStyle(
                      fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                      decoration: _underline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      fontSize: _textSize == PosTextSize.size3
                          ? 24
                          : _textSize == PosTextSize.size2
                              ? 18
                              : 14,
                      color: _textController.text.isEmpty
                          ? FiftyColors.hyperChrome
                          : FiftyColors.terminalWhite,
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

  Future<void> _printCustomTicket() async {
    final text = _textController.text;

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter some text'),
          backgroundColor: FiftyColors.warning,
        ),
      );
      return;
    }

    // Check if printers are registered
    final printers = _engine.getAvailablePrinters();
    if (printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No printers registered'),
          backgroundColor: FiftyColors.warning,
        ),
      );
      return;
    }

    // Create ticket
    final profile = await CapabilityProfile.load();
    final ticket = PrintTicket(PaperSize.mm80, profile);

    // Add custom text with formatting
    ticket.text(
      text,
      styles: PosStyles(
        bold: _bold,
        underline: _underline,
        height: _textSize,
        width: _textSize,
        align: _align,
      ),
    );

    ticket.feed(2);
    ticket.cut();

    // Print
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Printing custom ticket...'),
        backgroundColor: FiftyColors.gunmetal,
      ),
    );

    final result = await _engine.print(ticket: ticket);

    // Show result
    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printed to ${result.successCount} printer(s)'),
            backgroundColor: FiftyColors.success,
          ),
        );
      } else if (result.isPartialSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Partial success: ${result.successCount}/${result.totalPrinters}'),
            backgroundColor: FiftyColors.warning,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Print failed on all printers'),
            backgroundColor: FiftyColors.error,
          ),
        );
      }
    }
  }
}
