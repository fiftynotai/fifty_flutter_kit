/// Fifty Demo App - Entry Point
///
/// Composite demo app showcasing all Fifty ecosystem packages working together.
/// Demonstrates audio, speech, sentences, and map engines with FDL styling.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/material.dart';

import 'app/fifty_demo_app.dart';
import 'core/di/service_locator.dart';

/// Main entry point for the Fifty Demo application.
///
/// Initializes Flutter bindings, sets up audio engine, dependency injection,
/// and runs the root app widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FiftyAudioEngine (before DI setup)
  await FiftyAudioEngine.instance.initialize();

  // Configure channels for URL-based playback (not assets)
  FiftyAudioEngine.instance.bgm.changeSource(UrlSource.new);
  FiftyAudioEngine.instance.sfx.changeSource(UrlSource.new);
  FiftyAudioEngine.instance.voice.changeSource(UrlSource.new);

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const FiftyDemoApp());
}
