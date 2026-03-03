/// Fifty Demo App - Entry Point
///
/// Composite demo app showcasing all Fifty Flutter Kit packages working together.
/// Demonstrates audio, speech, sentences, and world engines with FDL styling.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:fifty_storage/fifty_storage.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
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

  // TS-003: Baltic Blue palette — visual configuration test
  FiftyTokens.configure(
    colors: FiftyPreset.fdlV2.colors.copyWith(
      primary: const Color(0xFF586994),        // Baltic Blue
      primaryHover: const Color(0xFF47567A),   // darkened
      secondary: const Color(0xFF7d869c),      // Lavender Grey
      secondaryHover: const Color(0xFF656D80), // darkened
      success: const Color(0xFFb4c4ae),        // Ash Grey
      accent: const Color(0xFFa2abab),         // Cool Steel
      background: const Color(0xFFe5e8b6),     // Cream
      backgroundDark: const Color(0xFF1A1D2B), // dark variant
      surface: const Color(0xFFD5D8A8),        // slightly darker Cream
      surfaceDark: const Color(0xFF2A2D3B),    // dark variant
      onPrimary: const Color(0xFFe5e8b6),     // Cream on Baltic Blue
      onBackground: const Color(0xFF1A1D2B),  // dark text on Cream
    ),
  );

  // Initialize FiftyAudioEngine (before app start)
  await FiftyAudioEngine.instance.initialize();

  // Configure channels: all use local assets for demo
  FiftyAudioEngine.instance.bgm.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.sfx.changeSource(AssetSource.new);
  FiftyAudioEngine.instance.voice.changeSource(AssetSource.new);

  runApp(const FiftyDemoApp());
}
