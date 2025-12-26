import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import 'app/audio_demo_app.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize audio service
  await AudioService.instance.initialize();

  runApp(const AudioEngineExampleApp());
}

/// Example app demonstrating fifty_audio_engine capabilities.
class AudioEngineExampleApp extends StatelessWidget {
  const AudioEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Audio Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const AudioDemoApp(),
    );
  }
}
