/// Battle Audio Coordinator
///
/// Audio integration service that coordinates game audio events with
/// [FiftyAudioEngine]. Manages background music playback and sound
/// effects for battle interactions (select, move, attack, capture, turn end).
///
/// Uses the singleton [FiftyAudioEngine.instance] directly following the
/// pattern established across the Fifty ecosystem.
///
/// **Usage:**
/// ```dart
/// final audio = Get.find<BattleAudioCoordinator>();
/// await audio.playBattleBgm();
/// await audio.playAttackSfx();
/// ```
library;

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Audio asset path constants for the battle feature.
abstract final class _BattleAudioAssets {
  /// BGM track paths.
  static const List<String> bgmTracks = [
    'audio/bgm/battle_theme.mp3',
  ];

  /// SFX group identifiers.
  static const String selectGroup = 'battle_select';
  static const String moveGroup = 'battle_move';
  static const String attackGroup = 'battle_attack';
  static const String captureGroup = 'battle_capture';
  static const String turnEndGroup = 'battle_turn_end';
  static const String abilityGroup = 'battle_ability';
  static const String achievementGroup = 'battle_achievement';

  /// SFX asset paths.
  static const List<String> selectSfx = [
    'audio/sfx/click.mp3',
  ];
  static const List<String> moveSfx = [
    'audio/sfx/footsteps.mp3',
  ];
  static const List<String> attackSfx = [
    'audio/sfx/sword_slash.mp3',
  ];
  static const List<String> captureSfx = [
    'audio/sfx/hit.mp3',
  ];
  static const List<String> turnEndSfx = [
    'audio/sfx/notification.mp3',
  ];
  static const List<String> abilitySfx = [
    'audio/sfx/sword_slash.mp3',
  ];
  static const List<String> achievementSfx = [
    'audio/sfx/achievement_unlock.mp3',
  ];
}

/// Coordinates game audio events with [FiftyAudioEngine].
///
/// Registered as a GetX controller so it can be lazily injected via
/// [BattleBindings] and automatically disposed when the battle route
/// is popped.
///
/// **Responsibilities:**
/// - BGM lifecycle (play, pause, resume, stop)
/// - SFX triggers for game events
/// - Global mute toggle
///
/// **Architecture Note:**
/// This is a SERVICE layer component. It wraps [FiftyAudioEngine] with
/// game-specific semantics. The [BattleActions] layer calls into this
/// coordinator; it never touches [FiftyAudioEngine] directly.
class BattleAudioCoordinator extends GetxController {
  /// Direct access to the audio engine singleton.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  /// Reactive mute state for UI binding.
  final RxBool _isMuted = false.obs;

  /// Whether all audio is currently muted.
  bool get isMuted => _isMuted.value;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _registerSfxGroups();
  }

  /// Registers all battle SFX groups with the engine's SFX channel.
  void _registerSfxGroups() {
    try {
      _engine.sfx
        ..registerGroup(
            _BattleAudioAssets.selectGroup, _BattleAudioAssets.selectSfx)
        ..registerGroup(
            _BattleAudioAssets.moveGroup, _BattleAudioAssets.moveSfx)
        ..registerGroup(
            _BattleAudioAssets.attackGroup, _BattleAudioAssets.attackSfx)
        ..registerGroup(
            _BattleAudioAssets.captureGroup, _BattleAudioAssets.captureSfx)
        ..registerGroup(
            _BattleAudioAssets.abilityGroup, _BattleAudioAssets.abilitySfx)
        ..registerGroup(
            _BattleAudioAssets.turnEndGroup, _BattleAudioAssets.turnEndSfx)
        ..registerGroup(_BattleAudioAssets.achievementGroup,
            _BattleAudioAssets.achievementSfx);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to register SFX groups: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // BGM Control
  // ---------------------------------------------------------------------------

  /// Starts the battle background music.
  ///
  /// Loads the battle BGM playlist and begins playback. If BGM is already
  /// playing, this effectively restarts from the beginning of the playlist.
  Future<void> playBattleBgm() async {
    try {
      await _engine.bgm.setVolume(0.4);
      await _engine.bgm.loadDefaultPlaylist(_BattleAudioAssets.bgmTracks);
      await _engine.bgm.resumeDefaultPlaylist();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play battle BGM: $e');
      }
    }
  }

  /// Stops the background music entirely.
  ///
  /// Use this when leaving the battle screen or when the game ends.
  Future<void> stopBgm() async {
    try {
      await _engine.bgm.stop();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to stop BGM: $e');
      }
    }
  }

  /// Pauses the background music.
  ///
  /// Use this for pause menus or when the app is backgrounded.
  Future<void> pauseBgm() async {
    try {
      await _engine.bgm.pause();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to pause BGM: $e');
      }
    }
  }

  /// Resumes paused background music.
  Future<void> resumeBgm() async {
    try {
      await _engine.bgm.resume();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to resume BGM: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // SFX Events
  // ---------------------------------------------------------------------------

  /// Plays the unit selection sound effect.
  Future<void> playSelectSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.selectGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play select SFX: $e');
      }
    }
  }

  /// Plays the unit movement sound effect.
  Future<void> playMoveSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.moveGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play move SFX: $e');
      }
    }
  }

  /// Plays the attack sound effect.
  Future<void> playAttackSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.attackGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play attack SFX: $e');
      }
    }
  }

  /// Plays the ability activation sound effect.
  Future<void> playAbilitySfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.abilityGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play ability SFX: $e');
      }
    }
  }

  /// Plays the capture (unit defeated) sound effect.
  Future<void> playCaptureSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.captureGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play capture SFX: $e');
      }
    }
  }

  /// Plays the turn-end sound effect.
  Future<void> playTurnEndSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.turnEndGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play turn end SFX: $e');
      }
    }
  }

  /// Plays the achievement unlock sound effect.
  Future<void> playAchievementSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.achievementGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to play achievement SFX: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Volume / Mute
  // ---------------------------------------------------------------------------

  /// Toggles the global mute state for all audio channels.
  ///
  /// When muted, all channels (BGM, SFX, Voice) are silenced.
  /// When unmuted, all channels are restored to their previous volumes.
  Future<void> toggleMute() async {
    try {
      if (_isMuted.value) {
        await _engine.unmuteAll();
        _isMuted.value = false;
      } else {
        await _engine.muteAll();
        _isMuted.value = true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to toggle mute: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onClose() {
    // Stop BGM when leaving the battle. Fire-and-forget since we are closing.
    _engine.bgm.stop();
    super.onClose();
  }
}
