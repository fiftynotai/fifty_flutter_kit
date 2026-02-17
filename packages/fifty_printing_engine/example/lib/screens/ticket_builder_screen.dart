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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Builder'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Instructions Card
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Build a custom ticket with text formatting',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text Content',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    onChanged: (_) => setState(() {}),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formatting',
                    style: textTheme.titleMedium?.copyWith(
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
                    style: textTheme.labelLarge,
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
                    style: textTheme.labelLarge,
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
          ),

          const SizedBox(height: 16),

          // Preview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline),
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
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
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
        const SnackBar(content: Text('Please enter some text')),
      );
      return;
    }

    final printers = _engine.getAvailablePrinters();
    if (printers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No printers registered')),
      );
      return;
    }

    final profile = await CapabilityProfile.load();
    final ticket = PrintTicket(PaperSize.mm80, profile);

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

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printing custom ticket...')),
    );

    final result = await _engine.print(ticket: ticket);

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
          SnackBar(
            content: const Text('Print failed on all printers'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
