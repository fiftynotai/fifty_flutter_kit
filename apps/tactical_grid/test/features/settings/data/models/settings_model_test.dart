import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactical_grid/features/battle/models/game_state.dart';
import 'package:tactical_grid/features/settings/data/models/settings_model.dart';

void main() {
  // ---------------------------------------------------------------------------
  // SettingsModel.defaults()
  // ---------------------------------------------------------------------------

  group('SettingsModel.defaults()', () {
    test('bgmVolume defaults to 0.4', () {
      final model = SettingsModel.defaults();
      expect(model.bgmVolume, 0.4);
    });

    test('sfxVolume defaults to 1.0', () {
      final model = SettingsModel.defaults();
      expect(model.sfxVolume, 1.0);
    });

    test('voiceVolume defaults to 1.0', () {
      final model = SettingsModel.defaults();
      expect(model.voiceVolume, 1.0);
    });

    test('isMuted defaults to false', () {
      final model = SettingsModel.defaults();
      expect(model.isMuted, false);
    });

    test('defaultDifficulty defaults to easy', () {
      final model = SettingsModel.defaults();
      expect(model.defaultDifficulty, AIDifficulty.easy);
    });

    test('turnDuration defaults to 60', () {
      final model = SettingsModel.defaults();
      expect(model.turnDuration, 60);
    });

    test('warningThreshold defaults to 10', () {
      final model = SettingsModel.defaults();
      expect(model.warningThreshold, 10);
    });

    test('criticalThreshold defaults to 5', () {
      final model = SettingsModel.defaults();
      expect(model.criticalThreshold, 5);
    });

    test('themeMode defaults to dark', () {
      final model = SettingsModel.defaults();
      expect(model.themeMode, ThemeMode.dark);
    });
  });

  // ---------------------------------------------------------------------------
  // copyWith()
  // ---------------------------------------------------------------------------

  group('copyWith()', () {
    test('with no args returns object with same values', () {
      final original = SettingsModel.defaults();
      final copy = original.copyWith();

      expect(copy.bgmVolume, original.bgmVolume);
      expect(copy.sfxVolume, original.sfxVolume);
      expect(copy.voiceVolume, original.voiceVolume);
      expect(copy.isMuted, original.isMuted);
      expect(copy.defaultDifficulty, original.defaultDifficulty);
      expect(copy.turnDuration, original.turnDuration);
      expect(copy.warningThreshold, original.warningThreshold);
      expect(copy.criticalThreshold, original.criticalThreshold);
      expect(copy.themeMode, original.themeMode);
    });

    test('overrides bgmVolume', () {
      final model = SettingsModel.defaults().copyWith(bgmVolume: 0.8);
      expect(model.bgmVolume, 0.8);
      // Other fields unchanged.
      expect(model.sfxVolume, 1.0);
    });

    test('overrides sfxVolume', () {
      final model = SettingsModel.defaults().copyWith(sfxVolume: 0.5);
      expect(model.sfxVolume, 0.5);
      expect(model.bgmVolume, 0.4);
    });

    test('overrides voiceVolume', () {
      final model = SettingsModel.defaults().copyWith(voiceVolume: 0.3);
      expect(model.voiceVolume, 0.3);
    });

    test('overrides isMuted', () {
      final model = SettingsModel.defaults().copyWith(isMuted: true);
      expect(model.isMuted, true);
    });

    test('overrides defaultDifficulty', () {
      final model = SettingsModel.defaults()
          .copyWith(defaultDifficulty: AIDifficulty.hard);
      expect(model.defaultDifficulty, AIDifficulty.hard);
    });

    test('overrides turnDuration', () {
      final model = SettingsModel.defaults().copyWith(turnDuration: 30);
      expect(model.turnDuration, 30);
    });

    test('overrides warningThreshold', () {
      final model = SettingsModel.defaults().copyWith(warningThreshold: 15);
      expect(model.warningThreshold, 15);
    });

    test('overrides criticalThreshold', () {
      final model = SettingsModel.defaults().copyWith(criticalThreshold: 8);
      expect(model.criticalThreshold, 8);
    });

    test('overrides themeMode', () {
      final model =
          SettingsModel.defaults().copyWith(themeMode: ThemeMode.light);
      expect(model.themeMode, ThemeMode.light);
    });

    test('overrides all fields simultaneously', () {
      final model = SettingsModel.defaults().copyWith(
        bgmVolume: 0.1,
        sfxVolume: 0.2,
        voiceVolume: 0.3,
        isMuted: true,
        defaultDifficulty: AIDifficulty.medium,
        turnDuration: 45,
        warningThreshold: 20,
        criticalThreshold: 7,
        themeMode: ThemeMode.light,
      );

      expect(model.bgmVolume, 0.1);
      expect(model.sfxVolume, 0.2);
      expect(model.voiceVolume, 0.3);
      expect(model.isMuted, true);
      expect(model.defaultDifficulty, AIDifficulty.medium);
      expect(model.turnDuration, 45);
      expect(model.warningThreshold, 20);
      expect(model.criticalThreshold, 7);
      expect(model.themeMode, ThemeMode.light);
    });
  });

  // ---------------------------------------------------------------------------
  // toString()
  // ---------------------------------------------------------------------------

  group('toString()', () {
    test('returns readable representation', () {
      final model = SettingsModel.defaults();
      final str = model.toString();

      expect(str, contains('bgm: 0.4'));
      expect(str, contains('sfx: 1.0'));
      expect(str, contains('voice: 1.0'));
      expect(str, contains('muted: false'));
      expect(str, contains('difficulty: easy'));
      expect(str, contains('timer: 60s'));
      expect(str, contains('theme: dark'));
    });
  });

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  group('constructor', () {
    test('creates model with all required fields', () {
      const model = SettingsModel(
        bgmVolume: 0.7,
        sfxVolume: 0.8,
        voiceVolume: 0.9,
        isMuted: true,
        defaultDifficulty: AIDifficulty.hard,
        turnDuration: 90,
        warningThreshold: 20,
        criticalThreshold: 10,
        themeMode: ThemeMode.light,
      );

      expect(model.bgmVolume, 0.7);
      expect(model.sfxVolume, 0.8);
      expect(model.voiceVolume, 0.9);
      expect(model.isMuted, true);
      expect(model.defaultDifficulty, AIDifficulty.hard);
      expect(model.turnDuration, 90);
      expect(model.warningThreshold, 20);
      expect(model.criticalThreshold, 10);
      expect(model.themeMode, ThemeMode.light);
    });

    test('can be const', () {
      const model = SettingsModel(
        bgmVolume: 0.5,
        sfxVolume: 0.5,
        voiceVolume: 0.5,
        isMuted: false,
        defaultDifficulty: AIDifficulty.easy,
        turnDuration: 60,
        warningThreshold: 10,
        criticalThreshold: 5,
        themeMode: ThemeMode.dark,
      );
      expect(model.bgmVolume, 0.5);
    });
  });
}
