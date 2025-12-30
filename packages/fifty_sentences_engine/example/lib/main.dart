import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import 'app/sentences_demo_app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const SentencesEngineExampleApp());
}

/// Example app demonstrating fifty_sentences_engine capabilities.
class SentencesEngineExampleApp extends StatelessWidget {
  const SentencesEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Sentences Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const SentencesDemoApp(),
    );
  }
}
