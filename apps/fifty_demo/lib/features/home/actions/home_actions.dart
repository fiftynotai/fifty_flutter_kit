/// Home Actions
///
/// Handles user interactions for the home feature.
library;

import '../../../shared/services/audio_integration_service.dart';

/// Actions for the home feature.
///
/// Provides navigation and initialization actions.
class HomeActions {
  HomeActions({
    required AudioIntegrationService audioService,
  }) : _audioService = audioService;

  final AudioIntegrationService _audioService;

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a feature card is tapped.
  void onFeatureTapped(String featureId) {
    // Navigation handled by parent
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Audio Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a click sound effect.
  ///
  /// Note: SFX disabled - external URLs block hotlinking.
  /// To enable, add local audio files to assets/audio/sfx/.
  Future<void> onPlayClickSound() async {
    // SFX disabled - soundjay.com blocks hotlinking
    // To enable: add local asset and use _audioService.playSfx('assets/...')
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes audio service if needed.
  Future<void> onInitializeAudio() async {
    if (!_audioService.isInitialized) {
      await _audioService.initialize();
    }
  }
}
