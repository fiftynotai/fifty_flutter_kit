/// Demo Scaffold Widget
///
/// A consistent scaffold wrapper for demo feature pages.
/// Provides standard padding and styling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A consistent scaffold for demo pages.
///
/// Provides standard padding, background color, and optional header.
class DemoScaffold extends StatelessWidget {
  const DemoScaffold({
    required this.child,
    super.key,
    this.title,
    this.actions,
    this.padding,
  });

  /// The main content of the scaffold.
  final Widget child;

  /// Optional title displayed in a header.
  final String? title;

  /// Optional action widgets for the header.
  final List<Widget>? actions;

  /// Custom padding (defaults to FiftySpacing.lg on all sides).
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FiftyColors.voidBlack,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.md,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || actions != null)
            Padding(
              padding: const EdgeInsets.only(bottom: FiftySpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamilyHeadline,
                        fontSize: FiftyTypography.section,
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.terminalWhite,
                        letterSpacing: 2,
                      ),
                    ),
                  if (actions != null) Row(children: actions!),
                ],
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
