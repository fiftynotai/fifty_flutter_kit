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

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/ability.dart';
import '../models/unit.dart';
import 'voice_announcer_service.dart';

/// Audio asset path constants for the battle feature.
abstract final class _BattleAudioAssets {
  /// BGM track paths.
  static const List<String> bgmTracks = [
    'audio/bgm/battle_theme.mp3',
  ];
  static const String victoryBgm = 'audio/bgm/victory_fanfare.mp3';
  static const String defeatBgm = 'audio/bgm/defeat_theme.mp3';
  static const String menuBgm = 'audio/bgm/menu_theme.mp3';

  /// SFX group identifiers.
  static const String selectGroup = 'battle_select';
  static const String moveGroup = 'battle_move';
  static const String attackGroup = 'battle_attack';
  static const String captureGroup = 'battle_capture';
  static const String turnEndGroup = 'battle_turn_end';
  static const String abilityGroup = 'battle_ability';
  static const String abilityRallyGroup = 'battle_ability_rally';
  static const String abilityShootGroup = 'battle_ability_shoot';
  static const String abilityFireballGroup = 'battle_ability_fireball';
  static const String abilityBlockGroup = 'battle_ability_block';
  static const String abilityRevealGroup = 'battle_ability_reveal';
  static const String achievementGroup = 'battle_achievement';
  static const String timerWarningGroup = 'battle_timer_warning';
  static const String timerAlarmGroup = 'battle_timer_alarm';

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
    'audio/sfx/unit_defeat.mp3',
  ];
  static const List<String> turnEndSfx = [
    'audio/sfx/turn_change.mp3',
  ];
  static const List<String> abilitySfx = [
    'audio/sfx/ability_activate.mp3',
  ];
  static const List<String> abilityRallySfx = ['audio/sfx/rally_horn.mp3'];
  static const List<String> abilityShootSfx = ['audio/sfx/arrow_shot.mp3'];
  static const List<String> abilityFireballSfx = ['audio/sfx/fireball_cast.mp3'];
  static const List<String> abilityBlockSfx = ['audio/sfx/shield_block.mp3'];
  static const List<String> abilityRevealSfx = ['audio/sfx/reveal_pulse.mp3'];
  static const List<String> achievementSfx = [
    'audio/sfx/achievement_unlock.mp3',
  ];
  static const List<String> timerWarningSfx = [
    'audio/sfx/timer_tick.mp3',
  ];
  static const List<String> timerAlarmSfx = [
    'audio/sfx/timer_critical.mp3',
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
  /// Creates a [BattleAudioCoordinator].
  ///
  /// [voiceAnnouncer] is an optional [VoiceAnnouncerService] for voice-over
  /// announcements. When provided, the coordinator exposes convenience
  /// methods (`announceMatchStart`, `announceVictory`, etc.) that delegate
  /// to the announcer. When `null`, voice announcements are silently skipped.
  BattleAudioCoordinator([this._voiceAnnouncer]);

  /// Optional voice announcer for battle event voice-overs.
  final VoiceAnnouncerService? _voiceAnnouncer;

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
    _configureVoiceChannel();
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
        ..registerGroup(_BattleAudioAssets.abilityRallyGroup, _BattleAudioAssets.abilityRallySfx)
        ..registerGroup(_BattleAudioAssets.abilityShootGroup, _BattleAudioAssets.abilityShootSfx)
        ..registerGroup(_BattleAudioAssets.abilityFireballGroup, _BattleAudioAssets.abilityFireballSfx)
        ..registerGroup(_BattleAudioAssets.abilityBlockGroup, _BattleAudioAssets.abilityBlockSfx)
        ..registerGroup(_BattleAudioAssets.abilityRevealGroup, _BattleAudioAssets.abilityRevealSfx)
        ..registerGroup(
            _BattleAudioAssets.turnEndGroup, _BattleAudioAssets.turnEndSfx)
        ..registerGroup(_BattleAudioAssets.achievementGroup,
            _BattleAudioAssets.achievementSfx)
        ..registerGroup(_BattleAudioAssets.timerWarningGroup,
            _BattleAudioAssets.timerWarningSfx)
        ..registerGroup(_BattleAudioAssets.timerAlarmGroup,
            _BattleAudioAssets.timerAlarmSfx);
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

  /// Plays the victory fanfare BGM.
  ///
  /// Used when the player wins the match. Loads a single-track playlist
  /// with [_BattleAudioAssets.victoryBgm] and plays it once.
  Future<void> playVictoryBgm() async {
    try {
      await _engine.bgm.setVolume(0.5);
      await _engine.bgm.loadDefaultPlaylist([_BattleAudioAssets.victoryBgm]);
      await _engine.bgm.resumeDefaultPlaylist();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play victory BGM: $e');
      }
    }
  }

  /// Plays the defeat theme BGM.
  ///
  /// Used when the player loses the match. Loads a single-track playlist
  /// with [_BattleAudioAssets.defeatBgm] and plays it once.
  Future<void> playDefeatBgm() async {
    try {
      await _engine.bgm.setVolume(0.5);
      await _engine.bgm.loadDefaultPlaylist([_BattleAudioAssets.defeatBgm]);
      await _engine.bgm.resumeDefaultPlaylist();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play defeat BGM: $e');
      }
    }
  }

  /// Plays the menu theme BGM.
  ///
  /// Used on the main menu screen. Loads a single-track playlist
  /// with [_BattleAudioAssets.menuBgm] and plays it.
  Future<void> playMenuBgm() async {
    try {
      await _engine.bgm.setVolume(0.3);
      await _engine.bgm.loadDefaultPlaylist([_BattleAudioAssets.menuBgm]);
      await _engine.bgm.resumeDefaultPlaylist();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BattleAudioCoordinator] Failed to play menu BGM: $e');
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
  ///
  /// When [abilityType] is provided, plays the ability-specific SFX
  /// (e.g., rally_horn for Rally). Falls back to the generic activation
  /// sound if no specific SFX is mapped.
  Future<void> playAbilitySfx([AbilityType? abilityType]) async {
    try {
      final group = switch (abilityType) {
        AbilityType.rally => _BattleAudioAssets.abilityRallyGroup,
        AbilityType.shoot => _BattleAudioAssets.abilityShootGroup,
        AbilityType.fireball => _BattleAudioAssets.abilityFireballGroup,
        AbilityType.block => _BattleAudioAssets.abilityBlockGroup,
        AbilityType.reveal => _BattleAudioAssets.abilityRevealGroup,
        _ => _BattleAudioAssets.abilityGroup,
      };
      await _engine.sfx.playGroup(group);
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

  /// Plays the timer warning sound effect (10-second warning zone).
  Future<void> playTimerWarningSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.timerWarningGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to play timer warning SFX: $e');
      }
    }
  }

  /// Plays the timer alarm sound effect (5-second critical zone).
  Future<void> playTimerAlarmSfx() async {
    try {
      await _engine.sfx.playGroup(_BattleAudioAssets.timerAlarmGroup);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to play timer alarm SFX: $e');
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
  // Voice Channel Configuration
  // ---------------------------------------------------------------------------

  /// Configures the voice channel to use asset-based source resolution.
  ///
  /// By default the voice channel resolves paths as URLs. Since battle
  /// voice lines are bundled assets, we switch the source builder to
  /// [AssetSource] so that `playVoice('audio/voice/victory.mp3')` loads
  /// from the Flutter asset bundle instead of attempting a network fetch.
  void _configureVoiceChannel() {
    try {
      _engine.voice.changeSource(AssetSource.new);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to configure voice channel: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Voice Announcements
  // ---------------------------------------------------------------------------

  /// Announces the start of a new match.
  ///
  /// Delegates to [VoiceAnnouncerService.announce] with
  /// [BattleAnnouncerEvent.matchStart]. Silently skipped if no voice
  /// announcer was provided.
  Future<void> announceMatchStart() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.matchStart);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce match start: $e');
      }
    }
  }

  /// Announces that a unit has been captured (defeated).
  ///
  /// [unitType] specifies which unit was captured, allowing the announcer
  /// to select a unit-specific voice line.
  Future<void> announceUnitCaptured(UnitType unitType) async {
    try {
      await _voiceAnnouncer?.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: unitType,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce unit captured: $e');
      }
    }
  }

  /// Announces that an ability has been used.
  ///
  /// [abilityType] specifies which ability was activated, allowing the
  /// announcer to select an ability-specific voice line.
  Future<void> announceAbilityUsed(AbilityType abilityType) async {
    try {
      await _voiceAnnouncer?.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: abilityType,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce ability used: $e');
      }
    }
  }

  /// Announces that the commander is in danger (low HP).
  Future<void> announceCommanderInDanger() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.commanderInDanger);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce commander in danger: $e');
      }
    }
  }

  /// Announces that an objective tile has been secured.
  Future<void> announceObjectiveSecured() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.objectiveSecured);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce objective secured: $e');
      }
    }
  }

  /// Announces a turn timer warning (time is running low).
  Future<void> announceTurnWarning() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.turnWarning);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce turn warning: $e');
      }
    }
  }

  /// Announces victory for the current player.
  Future<void> announceVictory() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.victory);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce victory: $e');
      }
    }
  }

  /// Announces defeat for the current player.
  Future<void> announceDefeat() async {
    try {
      await _voiceAnnouncer?.announce(BattleAnnouncerEvent.defeat);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[BattleAudioCoordinator] Failed to announce defeat: $e');
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
