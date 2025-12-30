/// Demo scaffold widget providing consistent layout.
///
/// Wraps content with FDL-styled app bar and safe area handling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Scaffold with FDL styling for demo pages.
class DemoScaffold extends StatelessWidget {
  const DemoScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  /// Title displayed in the hero section.
  final String title;

  /// Subtitle displayed below the title.
  final String subtitle;

  /// Main content widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Hero header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.xl,
              ),
              child: FiftyHeroSection(
                title: title,
                subtitle: subtitle,
                titleSize: FiftyHeroSize.h2,
                glitchOnMount: true,
                titleGradient: const LinearGradient(
                  colors: [
                    FiftyColors.crimsonPulse,
                    FiftyColors.terminalWhite,
                  ],
                ),
              ),
            ),
            // Content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
