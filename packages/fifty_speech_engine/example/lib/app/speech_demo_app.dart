/// Speech Demo App - Main application shell.
///
/// Provides the app structure with FDL theming and navigation.
library;

import 'package:flutter/material.dart';

import '../features/speech_demo/view/speech_demo_page.dart';
import '../shared/widgets/demo_scaffold.dart';

/// Main app shell for the speech demo.
class SpeechDemoApp extends StatelessWidget {
  const SpeechDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoScaffold(
      title: 'SPEECH ENGINE',
      subtitle: 'fifty.dev speech system demonstration',
      child: SpeechDemoPage(),
    );
  }
}
