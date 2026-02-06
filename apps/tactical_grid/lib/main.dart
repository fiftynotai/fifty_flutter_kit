/// Tactical Grid - Entry Point
///
/// Turn-based tactics game showcasing fifty_flutter_kit packages.
/// Demonstrates audio engine, map engine, and FDL styling.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

/// Main entry point for the Tactical Grid application.
///
/// Initializes Flutter bindings, sets up audio engine, and runs the root app widget.
/// Dependency injection is handled by GetX via InitialBindings.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FiftyAudioEngine (before app start)
  await FiftyAudioEngine.instance.initialize();

  // Configure channels: all use local assets
  FiftyAudioEngine.instance.bgm.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.sfx.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.voice.changeSource(AssetSource.new);

  runApp(const TacticalGridApp());
}
