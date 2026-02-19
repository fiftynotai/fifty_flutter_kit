/// Fifty Demo App - Entry Point
///
/// Composite demo app showcasing all Fifty Flutter Kit packages working together.
/// Demonstrates audio, speech, sentences, and world engines with FDL styling.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:fifty_storage/fifty_storage.dart';
import 'package:flutter/material.dart';

import 'app/fifty_demo_app.dart';

/// Main entry point for the Fifty Demo application.
///
/// Initializes Flutter bindings, sets up audio engine, and runs the root app widget.
/// Dependency injection is handled by GetX via InitialBindings.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage for theme persistence
  PreferencesStorage.configure(containerName: 'fifty_demo');
  await PreferencesStorage.instance.initialize();

  // Initialize FiftyAudioEngine (before app start)
  await FiftyAudioEngine.instance.initialize();

  // Configure channels: all use local assets for demo
  FiftyAudioEngine.instance.bgm.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.sfx.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.voice.changeSource(AssetSource.new);

  runApp(const FiftyDemoApp());
}
