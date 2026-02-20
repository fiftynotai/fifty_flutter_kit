/// Sentences Demo App - Main application shell.
///
/// Provides the app structure with FDL theming and navigation.
library;

import 'package:flutter/material.dart';

import '../features/narrative_demo/view/narrative_demo_page.dart';

/// Main app shell for the sentences demo.
class NarrativeDemoApp extends StatelessWidget {
  const NarrativeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Narrative Engine'),
      ),
      body: const NarrativeDemoPage(),
    );
  }
}
