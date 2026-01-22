/// Fifty Demo App - Entry Point
///
/// Composite demo app showcasing all Fifty Flutter Kit packages working together.
/// Demonstrates audio, speech, sentences, and map engines with FDL styling.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/material.dart';

import 'app/fifty_demo_app.dart';

/// Main entry point for the Fifty Demo application.
///
/// Initializes Flutter bindings, sets up audio engine, and runs the root app widget.
/// Dependency injection is handled by GetX via InitialBindings.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FiftyAudioEngine (before app start)
  await FiftyAudioEngine.instance.initialize();

  // Configure channels: BGM/Voice use URLs, SFX uses local assets
  FiftyAudioEngine.instance.bgm.changeSource(UrlSource.new);
  FiftyAudioEngine.instance.sfx.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.voice.changeSource(UrlSource.new);

  runApp(const FiftyDemoApp());
}
