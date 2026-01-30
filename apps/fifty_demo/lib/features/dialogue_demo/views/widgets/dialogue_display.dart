/// Dialogue Display Widget
///
/// Displays the current dialogue text with typing animation.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Dialogue display widget.
///
/// Shows text with speaker label and typing cursor.
class DialogueDisplay extends StatelessWidget {
  const DialogueDisplay({
    required this.text,
    required this.onTap,
    super.key,
    this.speaker,
    this.isTyping = false,
  });

  final String text;
  final String? speaker;
  final bool isTyping;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker label
            if (speaker != null && speaker!.isNotEmpty) ...[
              Text(
                speaker!,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
            ],
            // Dialogue text
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text.isEmpty ? 'Tap PLAY to start dialogue...' : text,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        color: text.isEmpty
                            ? colorScheme.onSurface.withValues(alpha: 0.7)
                            : colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // Typing cursor
                  if (isTyping)
                    const _TypingCursor(),
                ],
              ),
            ),
            const SizedBox(height: FiftySpacing.sm),
            // Hint
            Text(
              isTyping ? 'TAP TO SKIP' : 'TAP TO CONTINUE',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: 10,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingCursor extends StatefulWidget {
  const _TypingCursor();

  @override
  State<_TypingCursor> createState() => _TypingCursorState();
}

class _TypingCursorState extends State<_TypingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 20,
        color: colorScheme.primary,
      ),
    );
  }
}
