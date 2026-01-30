/// Demo Scaffold Widget
///
/// A consistent scaffold wrapper for demo feature pages.
/// Provides a proper Scaffold with AppBar and theme-aware colors.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A consistent scaffold for demo pages.
///
/// Provides a proper Scaffold with AppBar for Material widget requirements.
/// Uses theme-aware colors for light/dark mode support.
class DemoScaffold extends StatelessWidget {
  const DemoScaffold({
    required this.child,
    super.key,
    this.title,
    this.actions,
    this.padding,
    this.showAppBar = true,
  });

  /// The main content of the scaffold.
  final Widget child;

  /// Optional title displayed in the AppBar.
  final String? title;

  /// Optional action widgets for the AppBar.
  final List<Widget>? actions;

  /// Custom padding for the body content.
  final EdgeInsets? padding;

  /// Whether to show the AppBar (defaults to true).
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectivePadding = padding ??
        const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: showAppBar
          ? AppBar(
              title: title != null
                  ? Text(
                      title!.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.titleMedium,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    )
                  : null,
              actions: actions,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent,
            )
          : null,
      body: Padding(
        padding: effectivePadding,
        child: child,
      ),
    );
  }
}
