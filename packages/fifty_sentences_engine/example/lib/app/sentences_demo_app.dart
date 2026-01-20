/// Sentences Demo App - Main application shell.
///
/// Provides the app structure with FDL theming and navigation.
library;

import 'package:flutter/material.dart';

import '../features/sentences_demo/view/sentences_demo_page.dart';

/// Main app shell for the sentences demo.
class SentencesDemoApp extends StatelessWidget {
  const SentencesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentences Engine'),
      ),
      body: const SentencesDemoPage(),
    );
  }
}
