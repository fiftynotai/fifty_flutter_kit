/// Section Label Widget
///
/// Reusable label for section headers in the UI showcase.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A styled section label widget.
///
/// Displays uppercase text with consistent FDL styling for
/// section headers throughout the app.
class SectionLabel extends StatelessWidget {
  /// Creates a section label.
  const SectionLabel({required this.label, super.key});

  /// The label text to display (will be shown as-is, uppercase recommended).
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        color: FiftyColors.slateGrey,
        letterSpacing: 1,
      ),
    );
  }
}
