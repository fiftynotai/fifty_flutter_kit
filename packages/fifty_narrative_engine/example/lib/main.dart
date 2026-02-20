import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import 'app/narrative_demo_app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const NarrativeEngineExampleApp());
}

/// Example app demonstrating fifty_narrative_engine capabilities.
class NarrativeEngineExampleApp extends StatelessWidget {
  const NarrativeEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Narrative Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const NarrativeDemoApp(),
    );
  }
}
