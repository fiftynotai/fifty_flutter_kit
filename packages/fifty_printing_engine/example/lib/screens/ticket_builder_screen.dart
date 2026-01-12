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
        title: const Text('Ticket Builder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Instructions Card
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Build a custom ticket with text formatting',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Text Input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text Content',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter text to print',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Formatting Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formatting',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Bold and Underline
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Bold'),
                        selected: _bold,
                        onSelected: (value) {
                          setState(() {
                            _bold = value;
                          });
                        },
                      ),
                      FilterChip(
                        label: const Text('Underline'),
                        selected: _underline,
                        onSelected: (value) {
                          setState(() {
                            _underline = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Text Size
                  Text(
                    'Text Size',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
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

                  const SizedBox(height: 16),

                  // Alignment
                  Text(
                    'Alignment',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
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
          ),

          const SizedBox(height: 24),

          // Print Button
          FilledButton.icon(
            onPressed: _printCustomTicket,
            icon: const Icon(Icons.print),
            label: const Text('Print Custom Ticket'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 16),

          // Preview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
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
                            ? Colors.grey[400]
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
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
        const SnackBar(
          content: Text('Please enter some text'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if printers are registered
    final printers = _engine.getAvailablePrinters();
    if (printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No printers registered'),
          backgroundColor: Colors.orange,
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
      const SnackBar(
        content: Text('Printing custom ticket...'),
        backgroundColor: Colors.blue,
      ),
    );

    final result = await _engine.print(ticket: ticket);

    // Show result
    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printed to ${result.successCount} printer(s)'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result.isPartialSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Partial success: ${result.successCount}/${result.totalPrinters}'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Print failed on all printers'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
