/// Sentences Demo App - Main application shell.
///
/// Provides the app structure with FDL theming and navigation.
library;

import 'package:flutter/material.dart';

import '../features/sentences_demo/view/sentences_demo_page.dart';
import '../shared/widgets/demo_scaffold.dart';

/// Main app shell for the sentences demo.
class SentencesDemoApp extends StatelessWidget {
  const SentencesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoScaffold(
      title: 'SENTENCES ENGINE',
      subtitle: 'fifty.dev dialogue processing system',
      child: SentencesDemoPage(),
    );
  }
}
