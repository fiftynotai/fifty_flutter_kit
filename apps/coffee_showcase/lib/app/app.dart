/// Coffee Showcase - App Shell
///
/// MaterialApp with FDL dark theme. Single-page, no routing.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import '../features/showcase/views/showcase_page.dart';

/// Root application widget for the coffee showcase.
///
/// Uses [MaterialApp] directly (no GetX routing needed for a single page).
/// Forces dark theme via [FiftyTheme.dark] for the showcase aesthetic.
class CoffeeShowcaseApp extends StatelessWidget {
  /// Creates the coffee showcase app.
  const CoffeeShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Showcase',
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const ShowcasePage(),
    );
  }
}
