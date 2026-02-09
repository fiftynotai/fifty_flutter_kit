/// Voice Announcer Service
///
/// Manages voice-over announcements for key battle events such as match
/// start, unit captures, ability usage, and victory/defeat. Uses a
/// skip-if-busy policy to prevent overlapping voice lines, with a
/// cooldown window that resets after each announcement completes.
///
/// Designed for testability: accepts an optional [playVoice] callback
/// in the constructor. In production the callback defaults to
/// [FiftyAudioEngine.instance.voice.playVoice]; in tests a mock/spy
/// can be injected instead.
///
/// **Usage:**
/// ```dart
/// final announcer = VoiceAnnouncerService();
/// await announcer.announce(BattleAnnouncerEvent.matchStart);
/// await announcer.announce(
///   BattleAnnouncerEvent.unitCaptured,
///   unitType: UnitType.knight,
/// );
/// ```
library;

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';

import '../models/ability.dart';
import '../models/unit.dart';

/// Events that can trigger a voice announcement during battle.
enum BattleAnnouncerEvent {
  /// Played at the start of a new match.
  matchStart,

  /// Played when a unit is captured (defeated).
  unitCaptured,

  /// Played when an active ability is used.
  abilityUsed,

  /// Played when the commander's HP is critically low.
  commanderInDanger,

  /// Played when an objective tile is secured.
  objectiveSecured,

  /// Played when the turn timer enters the warning zone.
  turnWarning,

  /// Played when the current player wins the match.
  victory,

  /// Played when the current player loses the match.
  defeat,
}

/// Voice asset path constants for the battle announcer.
///
/// All paths are relative to the Flutter asset bundle root. The voice
/// channel must be configured with `AssetSource` resolution before
/// these paths will work.
abstract final class _VoiceAssets {
  /// Base directory for all voice-over audio files.
  static const String _base = 'audio/voice/';

  // ---------------------------------------------------------------------------
  // Generic event lines
  // ---------------------------------------------------------------------------

  /// Voice line for match start.
  static const String matchStart = '${_base}match_start.mp3';

  /// Generic voice line when a unit is captured.
  static const String unitCaptured = '${_base}unit_captured.mp3';

  /// Generic voice line when an ability is used.
  static const String abilityUsed = '${_base}ability_used.mp3';

  /// Voice line when the commander is in danger.
  static const String commanderInDanger = '${_base}commander_in_danger.mp3';

  /// Voice line when an objective is secured.
  static const String objectiveSecured = '${_base}objective_secured.mp3';

  /// Voice line for turn timer warning.
  static const String turnWarning = '${_base}turn_warning.mp3';

  /// Voice line for victory.
  static const String victory = '${_base}victory.mp3';

  /// Voice line for defeat.
  static const String defeat = '${_base}defeat.mp3';

  // ---------------------------------------------------------------------------
  // Per-unit-type capture lines
  // ---------------------------------------------------------------------------

  /// Specific voice lines when a particular unit type is captured.
  ///
  /// Falls back to [unitCaptured] if the unit type is not present.
  static const Map<UnitType, String> unitCaptureLines = {
    UnitType.commander: '${_base}captured_commander.mp3',
    UnitType.knight: '${_base}captured_knight.mp3',
    UnitType.shield: '${_base}captured_shield.mp3',
    UnitType.archer: '${_base}captured_archer.mp3',
    UnitType.mage: '${_base}captured_mage.mp3',
    UnitType.scout: '${_base}captured_scout.mp3',
  };

  // ---------------------------------------------------------------------------
  // Per-ability-type usage lines
  // ---------------------------------------------------------------------------

  /// Specific voice lines when a particular ability is used.
  ///
  /// Does NOT include [AbilityType.charge] because it is a passive ability
  /// that is never explicitly activated and therefore never announced.
  ///
  /// Falls back to [abilityUsed] if the ability type is not present.
  static const Map<AbilityType, String> abilityLines = {
    AbilityType.rally: '${_base}ability_rally.mp3',
    AbilityType.shoot: '${_base}ability_shoot.mp3',
    AbilityType.fireball: '${_base}ability_fireball.mp3',
    AbilityType.block: '${_base}ability_block.mp3',
    AbilityType.reveal: '${_base}ability_reveal.mp3',
  };
}

/// Service that plays voice announcements for key battle events.
///
/// Uses a skip-if-busy policy: if a voice line is currently playing,
/// subsequent calls to [announce] are silently dropped until the
/// cooldown window expires. This prevents announcement spam during
/// rapid game events.
///
/// **Architecture Note:**
/// This is a plain Dart class (not a GetxController) because it has no
/// reactive state that the UI needs to observe. It is owned and invoked
/// by [BattleAudioCoordinator], which IS a GetxController.
///
/// **Testability:**
/// Inject a mock [playVoice] callback via the constructor to verify
/// announcement behaviour without touching the audio engine.
///
/// **Example:**
/// ```dart
/// // Production
/// final announcer = VoiceAnnouncerService();
///
/// // Test
/// String? lastPath;
/// final announcer = VoiceAnnouncerService(
///   playVoice: (path) async { lastPath = path; },
/// );
/// await announcer.announce(BattleAnnouncerEvent.victory);
/// expect(lastPath, contains('victory'));
/// ```
class VoiceAnnouncerService {
  /// Creates a [VoiceAnnouncerService].
  ///
  /// [playVoice] is an optional callback for playing a voice asset at the
  /// given path. When omitted the service defaults to
  /// `FiftyAudioEngine.instance.voice.playVoice`.
  VoiceAnnouncerService({Future<void> Function(String path)? playVoice})
      : _playVoice =
            playVoice ?? FiftyAudioEngine.instance.voice.playVoice;

  /// The callback used to play voice audio files.
  final Future<void> Function(String path) _playVoice;

  /// Whether the announcer is enabled. Set to `false` to silence all
  /// announcements without removing the service.
  bool enabled = true;

  /// Internal guard preventing concurrent announcements.
  bool _isPlaying = false;

  /// Whether a voice line is currently playing (or within the cooldown
  /// window). Exposed for testing and debugging.
  bool get isPlaying => _isPlaying;

  /// Duration of the cooldown window after a voice line starts playing.
  ///
  /// Voice lines are typically 1-3 seconds. The cooldown prevents
  /// overlapping announcements by keeping [_isPlaying] true for this
  /// duration after the `_playVoice` future resolves.
  static const Duration _cooldownDuration = Duration(seconds: 2);

  /// Announces a battle event by playing the corresponding voice line.
  ///
  /// Uses a skip-if-busy policy: if [enabled] is `false` or another
  /// announcement is still within its cooldown window, the call returns
  /// immediately without playing anything.
  ///
  /// **Parameters:**
  /// - [event]: The battle event to announce.
  /// - [unitType]: Required when [event] is [BattleAnnouncerEvent.unitCaptured].
  ///   Used to select a unit-specific capture line.
  /// - [abilityType]: Required when [event] is [BattleAnnouncerEvent.abilityUsed].
  ///   Used to select an ability-specific usage line.
  Future<void> announce(
    BattleAnnouncerEvent event, {
    UnitType? unitType,
    AbilityType? abilityType,
  }) async {
    if (!enabled || _isPlaying) return;

    final path = _resolveAssetPath(
      event,
      unitType: unitType,
      abilityType: abilityType,
    );

    _isPlaying = true;
    try {
      await _playVoice(path);
      // Schedule a cooldown reset so concurrent announcements are blocked
      // while the voice line is audible. Voice lines are typically 1-3s.
      Future.delayed(_cooldownDuration, () {
        _isPlaying = false;
      });
    } catch (e) {
      _isPlaying = false;
      if (kDebugMode) {
        debugPrint('[VoiceAnnouncerService] Failed to announce: $e');
      }
    }
  }

  /// Resolves the audio asset path for the given [event].
  ///
  /// For [BattleAnnouncerEvent.unitCaptured], looks up [unitType] in
  /// [_VoiceAssets.unitCaptureLines] and falls back to the generic
  /// capture line if the type is not mapped.
  ///
  /// For [BattleAnnouncerEvent.abilityUsed], looks up [abilityType] in
  /// [_VoiceAssets.abilityLines] and falls back to the generic ability
  /// line if the type is not mapped.
  String _resolveAssetPath(
    BattleAnnouncerEvent event, {
    UnitType? unitType,
    AbilityType? abilityType,
  }) {
    return switch (event) {
      BattleAnnouncerEvent.matchStart => _VoiceAssets.matchStart,
      BattleAnnouncerEvent.unitCaptured =>
        _VoiceAssets.unitCaptureLines[unitType] ?? _VoiceAssets.unitCaptured,
      BattleAnnouncerEvent.abilityUsed =>
        _VoiceAssets.abilityLines[abilityType] ?? _VoiceAssets.abilityUsed,
      BattleAnnouncerEvent.commanderInDanger =>
        _VoiceAssets.commanderInDanger,
      BattleAnnouncerEvent.objectiveSecured =>
        _VoiceAssets.objectiveSecured,
      BattleAnnouncerEvent.turnWarning => _VoiceAssets.turnWarning,
      BattleAnnouncerEvent.victory => _VoiceAssets.victory,
      BattleAnnouncerEvent.defeat => _VoiceAssets.defeat,
    };
  }

  /// Force-resets the playing state.
  ///
  /// Useful for testing and error recovery scenarios where the cooldown
  /// timer may not have fired yet. In production, prefer letting the
  /// cooldown expire naturally.
  void resetPlayingState() {
    _isPlaying = false;
  }
}
