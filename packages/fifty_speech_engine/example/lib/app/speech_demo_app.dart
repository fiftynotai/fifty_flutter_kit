/// Speech Demo App - Main application shell.
///
/// Provides the app structure with FDL theming and navigation.
library;

import 'package:flutter/material.dart';

import '../features/speech_demo/view/speech_demo_page.dart';

/// Main app shell for the speech demo.
class SpeechDemoApp extends StatelessWidget {
  const SpeechDemoApp({
    super.key,
    required this.isBalticBlue,
    required this.onTogglePreset,
  });

  final bool isBalticBlue;
  final VoidCallback onTogglePreset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isBalticBlue ? 'Speech — BALTIC BLUE' : 'Speech Engine'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onTogglePreset,
        icon: Icon(isBalticBlue ? Icons.restore : Icons.palette),
        label: Text(isBalticBlue ? 'RESET FDL v2' : 'BALTIC BLUE'),
      ),
      body: const SpeechDemoPage(),
    );
  }
}
