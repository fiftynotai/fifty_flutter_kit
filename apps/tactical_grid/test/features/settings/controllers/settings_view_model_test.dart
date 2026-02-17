import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tactical_grid/features/battle/models/game_state.dart';
import 'package:tactical_grid/features/settings/controllers/settings_view_model.dart';
import 'package:tactical_grid/features/settings/data/models/settings_model.dart';
import 'package:tactical_grid/features/settings/data/services/settings_service.dart';

/// A stub for [SettingsService] that overrides all load/save methods
/// with in-memory storage while still satisfying the type constraint.
///
/// Requires GetStorage('TacticalGridSettings') to be initialized so the
/// parent field initializer does not throw.
class _FakeSettingsService extends SettingsService {
  int _turnDuration = 60;
  int _warningThreshold = 10;
  int _criticalThreshold = 5;
  String _difficulty = 'easy';
  String _themeMode = 'dark';
  bool _muteState = false;

  bool resetCalled = false;

  @override
  int loadTurnDuration() => _turnDuration;
  @override
  void saveTurnDuration(int value) => _turnDuration = value;

  @override
  int loadWarningThreshold() => _warningThreshold;
  @override
  void saveWarningThreshold(int value) => _warningThreshold = value;

  @override
  int loadCriticalThreshold() => _criticalThreshold;
  @override
  void saveCriticalThreshold(int value) => _criticalThreshold = value;

  @override
  String loadDefaultDifficulty() => _difficulty;
  @override
  void saveDefaultDifficulty(String value) => _difficulty = value;

  @override
  String loadThemeMode() => _themeMode;
  @override
  void saveThemeMode(String value) => _themeMode = value;

  @override
  bool loadMuteState() => _muteState;
  @override
  void saveMuteState(bool value) => _muteState = value;

  @override
  void resetToDefaults() {
    resetCalled = true;
    _turnDuration = 60;
    _warningThreshold = 10;
    _criticalThreshold = 5;
    _difficulty = 'easy';
    _themeMode = 'dark';
    _muteState = false;
  }
}

void main() {
  late _FakeSettingsService fakeService;
  late SettingsViewModel viewModel;

  setUpAll(() async {
    // Initialize Flutter test bindings (required by GetStorage).
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock path_provider for GetStorage.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return Directory.systemTemp.path;
        }
        return null;
      },
    );

    // Initialize the GetStorage box so the parent class field initializer
    // does not throw when creating _FakeSettingsService.
    await GetStorage.init('TacticalGridSettings');
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;

    fakeService = _FakeSettingsService();

    // Create the ViewModel without calling onInit (which accesses
    // AudioStorage.instance and FiftyAudioEngine.instance singletons
    // that require platform-channel initialization).
    viewModel = SettingsViewModel(fakeService);
  });

  // ---------------------------------------------------------------------------
  // Initial reactive state (before onInit)
  // ---------------------------------------------------------------------------

  group('initial reactive state', () {
    test('bgmVolume defaults to 0.4', () {
      expect(viewModel.bgmVolume.value, 0.4);
    });

    test('sfxVolume defaults to 1.0', () {
      expect(viewModel.sfxVolume.value, 1.0);
    });

    test('voiceVolume defaults to 1.0', () {
      expect(viewModel.voiceVolume.value, 1.0);
    });

    test('isMuted defaults to false', () {
      expect(viewModel.isMuted.value, false);
    });

    test('defaultDifficulty defaults to easy', () {
      expect(viewModel.defaultDifficulty.value, AIDifficulty.easy);
    });

    test('turnDuration defaults to 60', () {
      expect(viewModel.turnDuration.value, 60);
    });

    test('warningThreshold defaults to 10', () {
      expect(viewModel.warningThreshold.value, 10);
    });

    test('criticalThreshold defaults to 5', () {
      expect(viewModel.criticalThreshold.value, 5);
    });

    test('themeMode defaults to dark', () {
      expect(viewModel.themeMode.value, ThemeMode.dark);
    });
  });

  // ---------------------------------------------------------------------------
  // setDefaultDifficulty
  // ---------------------------------------------------------------------------

  group('setDefaultDifficulty', () {
    test('updates reactive value to hard', () {
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      expect(viewModel.defaultDifficulty.value, AIDifficulty.hard);
    });

    test('updates reactive value to medium', () {
      viewModel.setDefaultDifficulty(AIDifficulty.medium);
      expect(viewModel.defaultDifficulty.value, AIDifficulty.medium);
    });

    test('persists to service', () {
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      expect(fakeService.loadDefaultDifficulty(), 'hard');
    });

    test('updates reactive value back to easy', () {
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      viewModel.setDefaultDifficulty(AIDifficulty.easy);
      expect(viewModel.defaultDifficulty.value, AIDifficulty.easy);
    });
  });

  // ---------------------------------------------------------------------------
  // setTurnDuration
  // ---------------------------------------------------------------------------

  group('setTurnDuration', () {
    test('updates reactive value', () {
      viewModel.setTurnDuration(45);
      expect(viewModel.turnDuration.value, 45);
    });

    test('persists to service', () {
      viewModel.setTurnDuration(30);
      expect(fakeService.loadTurnDuration(), 30);
    });

    test('accepts boundary value 15', () {
      viewModel.setTurnDuration(15);
      expect(viewModel.turnDuration.value, 15);
    });

    test('accepts boundary value 120', () {
      viewModel.setTurnDuration(120);
      expect(viewModel.turnDuration.value, 120);
    });
  });

  // ---------------------------------------------------------------------------
  // setWarningThreshold
  // ---------------------------------------------------------------------------

  group('setWarningThreshold', () {
    test('updates reactive value for valid input', () {
      viewModel.setWarningThreshold(15);
      expect(viewModel.warningThreshold.value, 15);
    });

    test('persists to service', () {
      viewModel.setWarningThreshold(20);
      expect(fakeService.loadWarningThreshold(), 20);
    });

    test('clamps to criticalThreshold + 1 when set too low', () {
      // criticalThreshold defaults to 5, so min is 6.
      viewModel.setWarningThreshold(3);
      expect(viewModel.warningThreshold.value, 6);
    });

    test('clamps to 30 when set too high', () {
      viewModel.setWarningThreshold(50);
      expect(viewModel.warningThreshold.value, 30);
    });

    test('clamps correctly after criticalThreshold changes', () {
      viewModel.setCriticalThreshold(8);
      // Now minimum warning is 9.
      viewModel.setWarningThreshold(5);
      expect(viewModel.warningThreshold.value, 9);
    });

    test('accepts exact boundary value of criticalThreshold + 1', () {
      viewModel.setWarningThreshold(6);
      expect(viewModel.warningThreshold.value, 6);
    });
  });

  // ---------------------------------------------------------------------------
  // setCriticalThreshold
  // ---------------------------------------------------------------------------

  group('setCriticalThreshold', () {
    test('updates reactive value for valid input', () {
      viewModel.setCriticalThreshold(7);
      expect(viewModel.criticalThreshold.value, 7);
    });

    test('persists to service', () {
      viewModel.setCriticalThreshold(4);
      expect(fakeService.loadCriticalThreshold(), 4);
    });

    test('clamps to 3 when set too low', () {
      viewModel.setCriticalThreshold(1);
      expect(viewModel.criticalThreshold.value, 3);
    });

    test('clamps to warningThreshold - 1 when set too high', () {
      viewModel.setCriticalThreshold(15);
      expect(viewModel.criticalThreshold.value, 9);
    });

    test('accepts exact boundary value of 3', () {
      viewModel.setCriticalThreshold(3);
      expect(viewModel.criticalThreshold.value, 3);
    });

    test('accepts exact boundary value of warningThreshold - 1', () {
      viewModel.setCriticalThreshold(9);
      expect(viewModel.criticalThreshold.value, 9);
    });
  });

  // ---------------------------------------------------------------------------
  // setThemeMode
  // ---------------------------------------------------------------------------

  group('setThemeMode', () {
    test('updates reactive value to light', () {
      viewModel.setThemeMode(ThemeMode.light);
      expect(viewModel.themeMode.value, ThemeMode.light);
    });

    test('persists light to service as string', () {
      viewModel.setThemeMode(ThemeMode.light);
      expect(fakeService.loadThemeMode(), 'light');
    });

    test('updates reactive value to dark', () {
      viewModel.setThemeMode(ThemeMode.light);
      viewModel.setThemeMode(ThemeMode.dark);
      expect(viewModel.themeMode.value, ThemeMode.dark);
    });

    test('persists dark to service as string', () {
      viewModel.setThemeMode(ThemeMode.dark);
      expect(fakeService.loadThemeMode(), 'dark');
    });
  });

  // ---------------------------------------------------------------------------
  // resetToDefaults (non-audio aspects)
  // ---------------------------------------------------------------------------

  group('resetToDefaults', () {
    test('service.resetToDefaults() restores all default values', () {
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      viewModel.setTurnDuration(45);
      viewModel.setWarningThreshold(20);
      viewModel.setCriticalThreshold(8);
      viewModel.setThemeMode(ThemeMode.light);

      // Verify changed values persisted.
      expect(fakeService.loadTurnDuration(), 45);
      expect(fakeService.loadDefaultDifficulty(), 'hard');

      // Reset the service.
      fakeService.resetToDefaults();

      expect(fakeService.resetCalled, true);
      expect(fakeService.loadTurnDuration(), 60);
      expect(fakeService.loadWarningThreshold(), 10);
      expect(fakeService.loadCriticalThreshold(), 5);
      expect(fakeService.loadDefaultDifficulty(), 'easy');
      expect(fakeService.loadThemeMode(), 'dark');
      expect(fakeService.loadMuteState(), false);
    });
  });

  // ---------------------------------------------------------------------------
  // Reactive field independence
  // ---------------------------------------------------------------------------

  group('reactive field independence', () {
    test('changing turnDuration does not affect warningThreshold', () {
      final originalWarning = viewModel.warningThreshold.value;
      viewModel.setTurnDuration(90);
      expect(viewModel.warningThreshold.value, originalWarning);
    });

    test('changing difficulty does not affect turnDuration', () {
      final originalDuration = viewModel.turnDuration.value;
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      expect(viewModel.turnDuration.value, originalDuration);
    });

    test('changing themeMode does not affect difficulty', () {
      viewModel.setDefaultDifficulty(AIDifficulty.hard);
      viewModel.setThemeMode(ThemeMode.light);
      expect(viewModel.defaultDifficulty.value, AIDifficulty.hard);
    });
  });

  // ---------------------------------------------------------------------------
  // Clamping interaction between warning and critical
  // ---------------------------------------------------------------------------

  group('threshold clamping interaction', () {
    test('lowering critical then setting warning respects new floor', () {
      viewModel.setCriticalThreshold(3);
      viewModel.setWarningThreshold(4);
      expect(viewModel.warningThreshold.value, 4);
    });

    test('raising warning then setting critical respects new ceiling', () {
      viewModel.setWarningThreshold(25);
      viewModel.setCriticalThreshold(24);
      expect(viewModel.criticalThreshold.value, 24);
    });

    test('warning and critical stay correctly ordered after multiple changes', () {
      viewModel.setWarningThreshold(20);
      viewModel.setCriticalThreshold(10);
      viewModel.setWarningThreshold(12);
      viewModel.setCriticalThreshold(11);

      expect(viewModel.warningThreshold.value, 12);
      expect(viewModel.criticalThreshold.value, 11);
      expect(
        viewModel.criticalThreshold.value < viewModel.warningThreshold.value,
        true,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // SettingsModel.defaults alignment
  // ---------------------------------------------------------------------------

  group('default values match SettingsModel.defaults()', () {
    test('all reactive defaults align with model defaults', () {
      final defaults = SettingsModel.defaults();

      expect(viewModel.bgmVolume.value, defaults.bgmVolume);
      expect(viewModel.sfxVolume.value, defaults.sfxVolume);
      expect(viewModel.voiceVolume.value, defaults.voiceVolume);
      expect(viewModel.isMuted.value, defaults.isMuted);
      expect(viewModel.defaultDifficulty.value, defaults.defaultDifficulty);
      expect(viewModel.turnDuration.value, defaults.turnDuration);
      expect(viewModel.warningThreshold.value, defaults.warningThreshold);
      expect(viewModel.criticalThreshold.value, defaults.criticalThreshold);
      expect(viewModel.themeMode.value, defaults.themeMode);
    });
  });
}
