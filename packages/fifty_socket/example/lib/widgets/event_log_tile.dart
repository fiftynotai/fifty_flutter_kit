import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../controllers/socket_controller.dart';

/// A compact, timestamped event log entry widget.
///
/// Displays the entry in `[HH:mm:ss] message` format using a monospace
/// style for readability in a scrollable log view.
class EventLogTile extends StatelessWidget {
  /// Creates an event log tile for the given [entry].
  const EventLogTile({super.key, required this.entry});

  /// The event log entry to display.
  final EventLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final time = entry.timestamp;
    final timeString =
        '${_pad(time.hour)}:${_pad(time.minute)}:${_pad(time.second)}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs / 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '[$timeString] ',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FiftyTypography.medium,
                color: colorScheme.primary,
              ),
            ),
            TextSpan(
              text: entry.message,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FiftyTypography.regular,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pads a single-digit number with a leading zero.
  String _pad(int value) => value.toString().padLeft(2, '0');
}
