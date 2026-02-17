import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Builder'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        children: [
          // Instructions Card
          FiftyCard(
            scanlineOnHover: false,
            backgroundColor: colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: colorScheme.onPrimaryContainer),
                const SizedBox(width: FiftySpacing.md),
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

          const SizedBox(height: FiftySpacing.lg),

          // Text Input
          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FiftySectionHeader(
                  title: 'Text Content',
                  showDivider: false,
                ),
                FiftyTextField(
                  controller: _textController,
                  hint: 'Enter text to print',
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Formatting Options
          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FiftySectionHeader(
                  title: 'Formatting',
                  showDivider: false,
                ),

                // Bold and Underline
                Wrap(
                  spacing: FiftySpacing.sm,
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

                const SizedBox(height: FiftySpacing.lg),

                // Text Size
                const FiftySectionHeader(
                  title: 'Text Size',
                  size: FiftySectionHeaderSize.small,
                  showDivider: false,
                  showDot: false,
                ),
                FiftySegmentedControl<PosTextSize>(
                  segments: [
                    FiftySegment(
                      value: PosTextSize.size1,
                      label: '1x',
                    ),
                    FiftySegment(
                      value: PosTextSize.size2,
                      label: '2x',
                    ),
                    FiftySegment(
                      value: PosTextSize.size3,
                      label: '3x',
                    ),
                  ],
                  selected: _textSize,
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                  expanded: true,
                ),

                const SizedBox(height: FiftySpacing.lg),

                // Alignment
                const FiftySectionHeader(
                  title: 'Alignment',
                  size: FiftySectionHeaderSize.small,
                  showDivider: false,
                  showDot: false,
                ),
                FiftySegmentedControl<PosAlign>(
                  segments: [
                    FiftySegment(
                      value: PosAlign.left,
                      label: 'Left',
                      icon: Icons.format_align_left,
                    ),
                    FiftySegment(
                      value: PosAlign.center,
                      label: 'Center',
                      icon: Icons.format_align_center,
                    ),
                    FiftySegment(
                      value: PosAlign.right,
                      label: 'Right',
                      icon: Icons.format_align_right,
                    ),
                  ],
                  selected: _align,
                  onChanged: (value) {
                    setState(() {
                      _align = value;
                    });
                  },
                  expanded: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: FiftySpacing.xxl),

          // Print Button
          FiftyButton(
            icon: Icons.print,
            label: 'Print Custom Ticket',
            onPressed: _printCustomTicket,
            expanded: true,
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Preview Card
          FiftyCard(
            scanlineOnHover: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FiftySectionHeader(
                  title: 'Preview',
                  showDivider: false,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(FiftySpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: FiftyRadii.lgRadius,
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
                      fontWeight:
                          _bold ? FontWeight.bold : FontWeight.normal,
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
      final fifty =
          Theme.of(context).extension<FiftyThemeExtension>()!;
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Printed to ${result.successCount} printer(s)'),
            backgroundColor: fifty.success,
          ),
        );
      } else if (result.isPartialSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Partial success: ${result.successCount}/${result.totalPrinters}'),
            backgroundColor: fifty.warning,
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
