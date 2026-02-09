import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/ability.dart';
import 'package:tactical_grid/features/battle/models/unit.dart';
import 'package:tactical_grid/features/battle/services/voice_announcer_service.dart';

void main() {
  late VoiceAnnouncerService announcer;
  late List<String> playedPaths;

  /// A mock playVoice callback that records the path and completes instantly.
  Future<void> mockPlayVoice(String path) async {
    playedPaths.add(path);
  }

  setUp(() {
    playedPaths = [];
    announcer = VoiceAnnouncerService(playVoice: mockPlayVoice);
  });

  // ---------------------------------------------------------------------------
  // Initial state
  // ---------------------------------------------------------------------------

  group('initial state', () {
    test('enabled is true by default', () {
      expect(announcer.enabled, true);
    });

    test('isPlaying is false by default', () {
      expect(announcer.isPlaying, false);
    });
  });

  // ---------------------------------------------------------------------------
  // announce - basic event resolution
  // ---------------------------------------------------------------------------

  group('announce - basic events', () {
    test('matchStart plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.matchStart);
      expect(playedPaths, ['audio/voice/match_start.mp3']);
    });

    test('commanderInDanger plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.commanderInDanger);
      expect(playedPaths, ['audio/voice/commander_in_danger.mp3']);
    });

    test('objectiveSecured plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.objectiveSecured);
      expect(playedPaths, ['audio/voice/objective_secured.mp3']);
    });

    test('turnWarning plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.turnWarning);
      expect(playedPaths, ['audio/voice/turn_warning.mp3']);
    });

    test('victory plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths, ['audio/voice/victory.mp3']);
    });

    test('defeat plays correct asset path', () async {
      await announcer.announce(BattleAnnouncerEvent.defeat);
      expect(playedPaths, ['audio/voice/defeat.mp3']);
    });
  });

  // ---------------------------------------------------------------------------
  // announce - unit capture resolution
  // ---------------------------------------------------------------------------

  group('announce - unit captured', () {
    test('commander captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.commander,
      );
      expect(playedPaths, ['audio/voice/captured_commander.mp3']);
    });

    test('knight captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.knight,
      );
      expect(playedPaths, ['audio/voice/captured_knight.mp3']);
    });

    test('shield captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.shield,
      );
      expect(playedPaths, ['audio/voice/captured_shield.mp3']);
    });

    test('archer captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.archer,
      );
      expect(playedPaths, ['audio/voice/captured_archer.mp3']);
    });

    test('mage captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.mage,
      );
      expect(playedPaths, ['audio/voice/captured_mage.mp3']);
    });

    test('scout captured plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.unitCaptured,
        unitType: UnitType.scout,
      );
      expect(playedPaths, ['audio/voice/captured_scout.mp3']);
    });

    test('null unitType falls back to generic capture line', () async {
      await announcer.announce(BattleAnnouncerEvent.unitCaptured);
      expect(playedPaths, ['audio/voice/unit_captured.mp3']);
    });
  });

  // ---------------------------------------------------------------------------
  // announce - ability used resolution
  // ---------------------------------------------------------------------------

  group('announce - ability used', () {
    test('rally plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.rally,
      );
      expect(playedPaths, ['audio/voice/ability_rally.mp3']);
    });

    test('shoot plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.shoot,
      );
      expect(playedPaths, ['audio/voice/ability_shoot.mp3']);
    });

    test('fireball plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.fireball,
      );
      expect(playedPaths, ['audio/voice/ability_fireball.mp3']);
    });

    test('block plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.block,
      );
      expect(playedPaths, ['audio/voice/ability_block.mp3']);
    });

    test('reveal plays specific line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.reveal,
      );
      expect(playedPaths, ['audio/voice/ability_reveal.mp3']);
    });

    test('charge (passive) falls back to generic ability line', () async {
      await announcer.announce(
        BattleAnnouncerEvent.abilityUsed,
        abilityType: AbilityType.charge,
      );
      expect(playedPaths, ['audio/voice/ability_used.mp3']);
    });

    test('null abilityType falls back to generic ability line', () async {
      await announcer.announce(BattleAnnouncerEvent.abilityUsed);
      expect(playedPaths, ['audio/voice/ability_used.mp3']);
    });
  });

  // ---------------------------------------------------------------------------
  // enabled flag
  // ---------------------------------------------------------------------------

  group('enabled flag', () {
    test('when disabled, announce does nothing', () async {
      announcer.enabled = false;
      await announcer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths, isEmpty);
    });

    test('re-enabling allows announcements again', () async {
      announcer.enabled = false;
      await announcer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths, isEmpty);

      announcer.enabled = true;
      await announcer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths, ['audio/voice/victory.mp3']);
    });
  });

  // ---------------------------------------------------------------------------
  // skip-if-busy (isPlaying guard)
  // ---------------------------------------------------------------------------

  group('skip-if-busy policy', () {
    test('isPlaying is true immediately after announce', () async {
      await announcer.announce(BattleAnnouncerEvent.matchStart);
      expect(announcer.isPlaying, true);
    });

    test('second announce is skipped while isPlaying is true', () async {
      await announcer.announce(BattleAnnouncerEvent.matchStart);
      await announcer.announce(BattleAnnouncerEvent.victory);
      // Only the first announcement should have been played
      expect(playedPaths.length, 1);
      expect(playedPaths.first, 'audio/voice/match_start.mp3');
    });

    test('isPlaying resets after cooldown duration', () {
      fakeAsync((async) {
        announcer.announce(BattleAnnouncerEvent.matchStart);
        async.flushMicrotasks();
        expect(announcer.isPlaying, true);

        // Advance past the 2-second cooldown
        async.elapse(const Duration(seconds: 2));
        expect(announcer.isPlaying, false);
      });
    });

    test('can announce again after cooldown expires', () {
      fakeAsync((async) {
        announcer.announce(BattleAnnouncerEvent.matchStart);
        async.flushMicrotasks();

        // Advance past cooldown
        async.elapse(const Duration(seconds: 2));

        announcer.announce(BattleAnnouncerEvent.victory);
        async.flushMicrotasks();

        expect(playedPaths.length, 2);
        expect(playedPaths[0], 'audio/voice/match_start.mp3');
        expect(playedPaths[1], 'audio/voice/victory.mp3');
      });
    });
  });

  // ---------------------------------------------------------------------------
  // resetPlayingState
  // ---------------------------------------------------------------------------

  group('resetPlayingState', () {
    test('force-resets isPlaying to false', () async {
      await announcer.announce(BattleAnnouncerEvent.matchStart);
      expect(announcer.isPlaying, true);

      announcer.resetPlayingState();
      expect(announcer.isPlaying, false);
    });

    test('allows immediate re-announcement after reset', () async {
      await announcer.announce(BattleAnnouncerEvent.matchStart);
      announcer.resetPlayingState();

      await announcer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths.length, 2);
      expect(playedPaths[1], 'audio/voice/victory.mp3');
    });
  });

  // ---------------------------------------------------------------------------
  // error handling
  // ---------------------------------------------------------------------------

  group('error handling', () {
    test('resets isPlaying on playVoice error', () async {
      final errorAnnouncer = VoiceAnnouncerService(
        playVoice: (path) async => throw Exception('audio error'),
      );

      await errorAnnouncer.announce(BattleAnnouncerEvent.matchStart);
      expect(errorAnnouncer.isPlaying, false);
    });

    test('can announce again after error recovery', () async {
      var shouldFail = true;
      final errorAnnouncer = VoiceAnnouncerService(
        playVoice: (path) async {
          if (shouldFail) {
            shouldFail = false;
            throw Exception('audio error');
          }
          playedPaths.add(path);
        },
      );

      // First call fails, isPlaying resets
      await errorAnnouncer.announce(BattleAnnouncerEvent.matchStart);
      expect(errorAnnouncer.isPlaying, false);

      // Second call succeeds
      await errorAnnouncer.announce(BattleAnnouncerEvent.victory);
      expect(playedPaths, ['audio/voice/victory.mp3']);
    });
  });

  // ---------------------------------------------------------------------------
  // BattleAnnouncerEvent enum completeness
  // ---------------------------------------------------------------------------

  group('BattleAnnouncerEvent enum', () {
    test('has exactly 8 values', () {
      expect(BattleAnnouncerEvent.values.length, 8);
    });

    test('contains all expected events', () {
      expect(BattleAnnouncerEvent.values, containsAll([
        BattleAnnouncerEvent.matchStart,
        BattleAnnouncerEvent.unitCaptured,
        BattleAnnouncerEvent.abilityUsed,
        BattleAnnouncerEvent.commanderInDanger,
        BattleAnnouncerEvent.objectiveSecured,
        BattleAnnouncerEvent.turnWarning,
        BattleAnnouncerEvent.victory,
        BattleAnnouncerEvent.defeat,
      ]));
    });
  });
}
