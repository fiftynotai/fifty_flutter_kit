import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
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
class SpeechEngineExampleApp extends StatefulWidget {
  const SpeechEngineExampleApp({super.key});

  @override
  State<SpeechEngineExampleApp> createState() =>
      _SpeechEngineExampleAppState();
}

class _SpeechEngineExampleAppState extends State<SpeechEngineExampleApp> {
  bool _isBalticBlue = false;

  void _togglePreset() {
    setState(() {
      _isBalticBlue = !_isBalticBlue;
      if (_isBalticBlue) {
        FiftyTokens.load(FiftyPreset.balticBlue);
      } else {
        FiftyTokens.load(FiftyPreset.fdlV2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Speech Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: SpeechDemoApp(
        isBalticBlue: _isBalticBlue,
        onTogglePreset: _togglePreset,
      ),
    );
  }
}
