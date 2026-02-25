/// Scroll Sequence Example - Menu Page
///
/// Landing page with FDL-styled title and navigation buttons
/// to the three demo pages.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/route_manager.dart';

/// FDL-styled menu page for the scroll sequence example app.
///
/// Displays the app title in display typography (Manrope uppercase),
/// a subtitle, three navigation buttons, and a version label.
class MenuPage extends StatelessWidget {
  /// Creates the menu page.
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Title.
              Text(
                'SCROLL',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.displayLarge,
                  fontWeight: FiftyTypography.extraBold,
                  letterSpacing: FiftyTypography.letterSpacingDisplay,
                  color: colorScheme.onSurface,
                  height: FiftyTypography.lineHeightDisplay,
                ),
              ),
              Text(
                'SEQUENCE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.displayLarge,
                  fontWeight: FiftyTypography.extraBold,
                  letterSpacing: FiftyTypography.letterSpacingDisplay,
                  color: colorScheme.primary,
                  height: FiftyTypography.lineHeightDisplay,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),

              // Subtitle.
              Text(
                'A FIFTY SHOWCASE',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelMedium,
                  fontWeight: FiftyTypography.semiBold,
                  letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              const Spacer(),

              // Navigation buttons.
              FiftyButton(
                label: 'BASIC DEMO',
                onPressed: () => Get.toNamed<void>(RouteManager.basicRoute),
                variant: FiftyButtonVariant.primary,
                expanded: true,
              ),
              const SizedBox(height: FiftySpacing.md),
              FiftyButton(
                label: 'PINNED DEMO',
                onPressed: () => Get.toNamed<void>(RouteManager.pinnedRoute),
                variant: FiftyButtonVariant.outline,
                expanded: true,
              ),
              const SizedBox(height: FiftySpacing.md),
              FiftyButton(
                label: 'MULTI DEMO',
                onPressed: () => Get.toNamed<void>(RouteManager.multiRoute),
                variant: FiftyButtonVariant.outline,
                expanded: true,
              ),

              const Spacer(),

              // Version label.
              Text(
                'fifty_scroll_sequence v0.1.0',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FiftyTypography.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: FiftySpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
