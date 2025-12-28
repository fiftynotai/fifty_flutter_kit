import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import 'app/speech_demo_app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const SpeechEngineExampleApp());
}

/// Example app demonstrating fifty_speech_engine capabilities.
class SpeechEngineExampleApp extends StatelessWidget {
  const SpeechEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Speech Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const SpeechDemoApp(),
    );
  }
}
