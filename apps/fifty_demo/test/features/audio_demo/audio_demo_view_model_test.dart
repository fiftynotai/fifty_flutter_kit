/// AudioDemoViewModel Unit Tests
///
/// Tests for the AudioDemoViewModel business logic.
/// Note: Testing is limited due to singleton FiftyAudioEngine dependency.
/// Tests focus on state management and observable behavior.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:fifty_demo/features/audio_demo/controllers/audio_demo_view_model.dart';

void main() {
  late AudioDemoViewModel viewModel;

  setUpAll(() {
    // Enable test mode to prevent GetX from trying to access Navigator
    Get.testMode = true;
  });

  setUp(() {
    // Create ViewModel - note: it won't be fully initialized without real engine
    viewModel = AudioDemoViewModel();
  });

  tearDown(() {
    Get.reset();
  });

  group('AudioDemoViewModel', () {
    group('enums', () {
      test('AudioTrack should have 3 tracks', () {
        expect(AudioTrack.values.length, 3);
      });

      test('AudioTrack exploration should have correct values', () {
        expect(AudioTrack.exploration.displayName, 'Exploration');
        expect(AudioTrack.exploration.assetPath, 'audio/bgm/exploration.mp3');
      });

      test('AudioTrack combat should have correct values', () {
        expect(AudioTrack.combat.displayName, 'Combat');
        expect(AudioTrack.combat.assetPath, 'audio/bgm/combat.mp3');
      });

      test('AudioTrack peaceful should have correct values', () {
        expect(AudioTrack.peaceful.displayName, 'Peaceful');
        expect(AudioTrack.peaceful.assetPath, 'audio/bgm/peaceful.mp3');
      });

      test('SfxCategory should have 4 categories', () {
        expect(SfxCategory.values.length, 4);
      });

      test('SfxCategory should have correct display names', () {
        expect(SfxCategory.ui.displayName, 'UI');
        expect(SfxCategory.combat.displayName, 'Combat');
        expect(SfxCategory.environment.displayName, 'Environment');
        expect(SfxCategory.character.displayName, 'Character');
      });

      test('SoundEffect should have 16 sound effects', () {
        expect(SoundEffect.values.length, 16);
      });

      test('SoundEffect buttonClick should have correct values', () {
        expect(SoundEffect.buttonClick.category, SfxCategory.ui);
        expect(SoundEffect.buttonClick.displayName, 'Button Click');
        expect(SoundEffect.buttonClick.assetPath, 'audio/sfx/button_click.mp3');
      });

      test('VoiceLine should have 5 voice lines', () {
        expect(VoiceLine.values.length, 5);
      });

      test('VoiceLine welcome should have correct values', () {
        expect(VoiceLine.welcome.displayText, 'Welcome, adventurer!');
        expect(VoiceLine.welcome.assetPath, 'audio/voice/welcome.mp3');
      });
    });

    group('initial state', () {
      test('should not be initialized by default', () {
        // ViewModel won't initialize without engine
        expect(viewModel.isInitialized, false);
      });

      test('should have default BGM volume of 0.7', () {
        expect(viewModel.bgmVolume, 0.7);
      });

      test('should have default SFX volume of 0.8', () {
        expect(viewModel.sfxVolume, 0.8);
      });

      test('should have default voice volume of 1.0', () {
        expect(viewModel.voiceVolume, 1.0);
      });

      test('should have default master volume of 1.0', () {
        expect(viewModel.masterVolume, 1.0);
      });

      test('should have exploration as default track', () {
        expect(viewModel.currentTrack, AudioTrack.exploration);
      });

      test('should have UI as default SFX category', () {
        expect(viewModel.selectedCategory, SfxCategory.ui);
      });

      test('should not be muted by default', () {
        expect(viewModel.bgmMuted, false);
        expect(viewModel.sfxMuted, false);
        expect(viewModel.voiceMuted, false);
        expect(viewModel.masterMuted, false);
      });

      test('should have loop enabled by default', () {
        expect(viewModel.loopEnabled, true);
      });

      test('should not have shuffle enabled by default', () {
        expect(viewModel.shuffleEnabled, false);
      });

      test('should have voice ducking enabled by default', () {
        expect(viewModel.voiceDucking, true);
      });
    });

    group('track selection', () {
      test('should select a new track', () {
        // Given: Default track is exploration
        expect(viewModel.currentTrack, AudioTrack.exploration);

        // When: Selecting combat track
        viewModel.selectTrack(AudioTrack.combat);

        // Then: Current track should be combat
        expect(viewModel.currentTrack, AudioTrack.combat);
      });

      test('should reset position when selecting track', () {
        // Given: ViewModel
        // When: Selecting a track
        viewModel.selectTrack(AudioTrack.peaceful);

        // Then: Track should be updated (position is internal)
        expect(viewModel.currentTrack, AudioTrack.peaceful);
      });
    });

    group('SFX category selection', () {
      test('should select SFX category', () {
        // Given: Default category is UI
        expect(viewModel.selectedCategory, SfxCategory.ui);

        // When: Selecting combat category
        viewModel.selectSfxCategory(SfxCategory.combat);

        // Then: Category should be combat
        expect(viewModel.selectedCategory, SfxCategory.combat);
      });

      test('categorySoundEffects should return correct effects for UI', () {
        // Given: UI category selected
        viewModel.selectSfxCategory(SfxCategory.ui);

        // When: Getting category sound effects
        final effects = viewModel.categorySoundEffects;

        // Then: Should have 4 UI effects
        expect(effects.length, 4);
        expect(effects.every((e) => e.category == SfxCategory.ui), true);
      });

      test('categorySoundEffects should return correct effects for combat', () {
        // Given: Combat category selected
        viewModel.selectSfxCategory(SfxCategory.combat);

        // When: Getting category sound effects
        final effects = viewModel.categorySoundEffects;

        // Then: Should have 4 combat effects
        expect(effects.length, 4);
        expect(effects.every((e) => e.category == SfxCategory.combat), true);
      });

      test('categorySoundEffects should return correct effects for environment',
          () {
        // Given: Environment category selected
        viewModel.selectSfxCategory(SfxCategory.environment);

        // When: Getting category sound effects
        final effects = viewModel.categorySoundEffects;

        // Then: Should have 4 environment effects
        expect(effects.length, 4);
        expect(
            effects.every((e) => e.category == SfxCategory.environment), true);
      });

      test('categorySoundEffects should return correct effects for character',
          () {
        // Given: Character category selected
        viewModel.selectSfxCategory(SfxCategory.character);

        // When: Getting category sound effects
        final effects = viewModel.categorySoundEffects;

        // Then: Should have 4 character effects
        expect(effects.length, 4);
        expect(
            effects.every((e) => e.category == SfxCategory.character), true);
      });
    });

    group('shuffle toggle', () {
      test('should toggle shuffle on', () {
        // Given: Shuffle is off
        expect(viewModel.shuffleEnabled, false);

        // When: Toggling shuffle
        viewModel.toggleShuffle();

        // Then: Shuffle should be on
        expect(viewModel.shuffleEnabled, true);
      });

      test('should toggle shuffle off', () {
        // Given: Shuffle is on
        viewModel.toggleShuffle();
        expect(viewModel.shuffleEnabled, true);

        // When: Toggling shuffle again
        viewModel.toggleShuffle();

        // Then: Shuffle should be off
        expect(viewModel.shuffleEnabled, false);
      });
    });

    group('voice ducking toggle', () {
      test('should toggle voice ducking off', () {
        // Given: Voice ducking is on
        expect(viewModel.voiceDucking, true);

        // When: Toggling voice ducking
        viewModel.toggleVoiceDucking();

        // Then: Voice ducking should be off
        expect(viewModel.voiceDucking, false);
      });

      test('should toggle voice ducking on', () {
        // Given: Voice ducking is off
        viewModel.toggleVoiceDucking();
        expect(viewModel.voiceDucking, false);

        // When: Toggling voice ducking again
        viewModel.toggleVoiceDucking();

        // Then: Voice ducking should be on
        expect(viewModel.voiceDucking, true);
      });
    });

    group('available tracks and lines', () {
      test('should return all audio tracks', () {
        expect(viewModel.availableTracks, AudioTrack.values);
        expect(viewModel.availableTracks.length, 3);
      });

      test('should return all SFX categories', () {
        expect(viewModel.sfxCategories, SfxCategory.values);
        expect(viewModel.sfxCategories.length, 4);
      });

      test('should return all voice lines', () {
        expect(viewModel.voiceLines, VoiceLine.values);
        expect(viewModel.voiceLines.length, 5);
      });
    });

    group('progress and duration labels', () {
      test('should return 0 progress when duration is 0', () {
        // Duration is 0 by default (not initialized)
        expect(viewModel.bgmProgress, 0.0);
      });

      test('should return formatted position label', () {
        // Default is 00:00
        expect(viewModel.bgmPositionLabel, '00:00');
      });

      test('should return formatted duration label', () {
        // Default is 00:00
        expect(viewModel.bgmDurationLabel, '00:00');
      });
    });

    group('track index', () {
      test('should have default track index of 0', () {
        expect(viewModel.currentTrackIndex, 0);
      });
    });

    group('voice state', () {
      test('should not be playing voice by default', () {
        expect(viewModel.voicePlaying, false);
      });

      test('should have empty voice line by default', () {
        expect(viewModel.currentVoiceLine, '');
      });
    });

    group('fade state', () {
      test('should not be fading by default', () {
        expect(viewModel.isFading, false);
      });

      test('should have no last fade preset by default', () {
        expect(viewModel.lastFadePreset, isNull);
      });
    });

    group('last played SFX', () {
      test('should have no last played SFX by default', () {
        expect(viewModel.lastPlayedSfx, isNull);
      });
    });
  });
}
