/// Fifty Audio Engine Widgets
///
/// Reusable UI components for audio controls.
///
/// **Available Widgets:**
/// - [AudioControlsPanel]: Callback-based BGM and SFX controls panel
///
/// **Usage:**
/// ```dart
/// import 'package:fifty_audio_engine/fifty_audio_engine.dart';
///
/// AudioControlsPanel(
///   bgmEnabled: true,
///   bgmPlaying: false,
///   sfxEnabled: true,
///   onPlayBgm: () => audioEngine.playBgm(),
///   onStopBgm: () => audioEngine.stopBgm(),
///   onToggleBgm: () => audioEngine.toggleBgm(),
///   onToggleSfx: () => audioEngine.toggleSfx(),
///   onTestSfx: () => audioEngine.playSfx('test'),
/// )
/// ```
library;

export 'audio_controls_panel.dart';
