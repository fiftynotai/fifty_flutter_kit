import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tactical_grid/features/settings/data/services/settings_service.dart';

void main() {
  late SettingsService service;

  setUpAll(() async {
    // Ensure test bindings are initialized.
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock the path_provider platform channel to return a temp directory.
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

    // Initialize the GetStorage box used by SettingsService.
    await GetStorage.init('TacticalGridSettings');
  });

  setUp(() {
    // Create a fresh service and clear any leftover state.
    service = SettingsService();
    service.resetToDefaults();
  });

  // ---------------------------------------------------------------------------
  // Turn Duration
  // ---------------------------------------------------------------------------

  group('turnDuration', () {
    test('returns default (60) when storage is empty', () {
      expect(service.loadTurnDuration(), 60);
    });

    test('save and load round-trip', () {
      service.saveTurnDuration(45);
      expect(service.loadTurnDuration(), 45);
    });

    test('overwrites previous value', () {
      service.saveTurnDuration(30);
      service.saveTurnDuration(90);
      expect(service.loadTurnDuration(), 90);
    });
  });

  // ---------------------------------------------------------------------------
  // Warning Threshold
  // ---------------------------------------------------------------------------

  group('warningThreshold', () {
    test('returns default (10) when storage is empty', () {
      expect(service.loadWarningThreshold(), 10);
    });

    test('save and load round-trip', () {
      service.saveWarningThreshold(15);
      expect(service.loadWarningThreshold(), 15);
    });

    test('overwrites previous value', () {
      service.saveWarningThreshold(20);
      service.saveWarningThreshold(25);
      expect(service.loadWarningThreshold(), 25);
    });
  });

  // ---------------------------------------------------------------------------
  // Critical Threshold
  // ---------------------------------------------------------------------------

  group('criticalThreshold', () {
    test('returns default (5) when storage is empty', () {
      expect(service.loadCriticalThreshold(), 5);
    });

    test('save and load round-trip', () {
      service.saveCriticalThreshold(8);
      expect(service.loadCriticalThreshold(), 8);
    });

    test('overwrites previous value', () {
      service.saveCriticalThreshold(3);
      service.saveCriticalThreshold(7);
      expect(service.loadCriticalThreshold(), 7);
    });
  });

  // ---------------------------------------------------------------------------
  // Default Difficulty
  // ---------------------------------------------------------------------------

  group('defaultDifficulty', () {
    test('returns default ("easy") when storage is empty', () {
      expect(service.loadDefaultDifficulty(), 'easy');
    });

    test('save and load round-trip', () {
      service.saveDefaultDifficulty('hard');
      expect(service.loadDefaultDifficulty(), 'hard');
    });

    test('stores "medium" correctly', () {
      service.saveDefaultDifficulty('medium');
      expect(service.loadDefaultDifficulty(), 'medium');
    });

    test('overwrites previous value', () {
      service.saveDefaultDifficulty('easy');
      service.saveDefaultDifficulty('hard');
      expect(service.loadDefaultDifficulty(), 'hard');
    });
  });

  // ---------------------------------------------------------------------------
  // Theme Mode
  // ---------------------------------------------------------------------------

  group('themeMode', () {
    test('returns default ("dark") when storage is empty', () {
      expect(service.loadThemeMode(), 'dark');
    });

    test('save and load round-trip for light', () {
      service.saveThemeMode('light');
      expect(service.loadThemeMode(), 'light');
    });

    test('save and load round-trip for dark', () {
      service.saveThemeMode('dark');
      expect(service.loadThemeMode(), 'dark');
    });

    test('overwrites previous value', () {
      service.saveThemeMode('light');
      service.saveThemeMode('dark');
      expect(service.loadThemeMode(), 'dark');
    });
  });

  // ---------------------------------------------------------------------------
  // Mute State
  // ---------------------------------------------------------------------------

  group('muteState', () {
    test('returns default (false) when storage is empty', () {
      expect(service.loadMuteState(), false);
    });

    test('save and load round-trip for true', () {
      service.saveMuteState(true);
      expect(service.loadMuteState(), true);
    });

    test('save and load round-trip for false', () {
      service.saveMuteState(false);
      expect(service.loadMuteState(), false);
    });

    test('overwrites previous value', () {
      service.saveMuteState(true);
      service.saveMuteState(false);
      expect(service.loadMuteState(), false);
    });
  });

  // ---------------------------------------------------------------------------
  // resetToDefaults()
  // ---------------------------------------------------------------------------

  group('resetToDefaults()', () {
    test('clears all stored values and restores defaults', () {
      // Save non-default values.
      service.saveTurnDuration(45);
      service.saveWarningThreshold(20);
      service.saveCriticalThreshold(8);
      service.saveDefaultDifficulty('hard');
      service.saveThemeMode('light');
      service.saveMuteState(true);

      // Verify they were saved.
      expect(service.loadTurnDuration(), 45);
      expect(service.loadWarningThreshold(), 20);
      expect(service.loadCriticalThreshold(), 8);
      expect(service.loadDefaultDifficulty(), 'hard');
      expect(service.loadThemeMode(), 'light');
      expect(service.loadMuteState(), true);

      // Reset.
      service.resetToDefaults();

      // All values should return to defaults.
      expect(service.loadTurnDuration(), 60);
      expect(service.loadWarningThreshold(), 10);
      expect(service.loadCriticalThreshold(), 5);
      expect(service.loadDefaultDifficulty(), 'easy');
      expect(service.loadThemeMode(), 'dark');
      expect(service.loadMuteState(), false);
    });
  });
}
