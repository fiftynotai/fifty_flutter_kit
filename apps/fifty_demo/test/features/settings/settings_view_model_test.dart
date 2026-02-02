/// SettingsViewModel Unit Tests
///
/// Tests for the SettingsViewModel business logic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fifty_demo/features/settings/controllers/settings_view_model.dart';
import 'package:fifty_demo/features/settings/data/services/theme_service.dart';

import '../../mocks/mock_services.dart';

void main() {
  late SettingsViewModel viewModel;
  late MockThemeService mockThemeService;

  setUpAll(() {
    // Enable test mode to prevent GetX from trying to access Navigator
    Get.testMode = true;
  });

  setUp(() {
    mockThemeService = MockThemeService();

    // Default stub: no saved theme
    when(() => mockThemeService.getSavedThemeMode()).thenReturn(null);
    when(() => mockThemeService.saveThemeMode(any())).thenReturn(null);

    viewModel = SettingsViewModel(mockThemeService);
  });

  tearDown(() {
    // Clean up GetX state
    Get.reset();
  });

  group('SettingsViewModel', () {
    group('initialization', () {
      test('should have default dark theme mode', () {
        // Given: ViewModel is created
        // When: Checking initial theme mode
        // Then: Default is dark
        expect(viewModel.themeMode, AppThemeMode.dark);
      });

      test('should load saved theme mode on init', () {
        // Given: A saved light theme mode exists
        when(() => mockThemeService.getSavedThemeMode())
            .thenReturn(ThemeMode.light.toString());

        // When: ViewModel is initialized
        final vm = SettingsViewModel(mockThemeService);
        vm.onInit();

        // Then: Theme mode should be light
        expect(vm.themeMode, AppThemeMode.light);
      });

      test('should load saved system theme mode on init', () {
        // Given: A saved system theme mode exists
        when(() => mockThemeService.getSavedThemeMode())
            .thenReturn(ThemeMode.system.toString());

        // When: ViewModel is initialized
        final vm = SettingsViewModel(mockThemeService);
        vm.onInit();

        // Then: Theme mode should be system
        expect(vm.themeMode, AppThemeMode.system);
      });

      test('should default to dark when saved value is invalid', () {
        // Given: An invalid saved theme mode
        when(() => mockThemeService.getSavedThemeMode())
            .thenReturn('invalid_mode');

        // When: ViewModel is initialized
        final vm = SettingsViewModel(mockThemeService);
        vm.onInit();

        // Then: Theme mode should default to dark
        expect(vm.themeMode, AppThemeMode.dark);
      });
    });

    group('theme mode setter', () {
      test('should update theme mode to light', () {
        // Given: ViewModel with dark theme
        expect(viewModel.themeMode, AppThemeMode.dark);

        // When: Setting theme to light
        viewModel.themeMode = AppThemeMode.light;

        // Then: Theme mode is updated
        expect(viewModel.themeMode, AppThemeMode.light);
      });

      test('should update theme mode to system', () {
        // Given: ViewModel with dark theme
        expect(viewModel.themeMode, AppThemeMode.dark);

        // When: Setting theme to system
        viewModel.themeMode = AppThemeMode.system;

        // Then: Theme mode is updated
        expect(viewModel.themeMode, AppThemeMode.system);
      });

      test('should persist theme mode when changed', () {
        // Given: ViewModel
        // When: Setting theme to light
        viewModel.themeMode = AppThemeMode.light;

        // Then: Theme service should save the mode
        verify(() => mockThemeService.saveThemeMode(ThemeMode.light.toString()))
            .called(1);
      });

      test('should persist dark theme mode', () {
        // Given: ViewModel with light theme
        viewModel.themeMode = AppThemeMode.light;
        clearInteractions(mockThemeService);

        // When: Setting theme back to dark
        viewModel.themeMode = AppThemeMode.dark;

        // Then: Theme service should save dark mode
        verify(() => mockThemeService.saveThemeMode(ThemeMode.dark.toString()))
            .called(1);
      });

      test('should persist system theme mode', () {
        // Given: ViewModel
        // When: Setting theme to system
        viewModel.themeMode = AppThemeMode.system;

        // Then: Theme service should save system mode
        verify(
            () => mockThemeService.saveThemeMode(ThemeMode.system.toString()))
            .called(1);
      });
    });

    group('debug mode', () {
      test('should have debug mode off by default', () {
        // Given: ViewModel is created
        // When: Checking debug mode
        // Then: It should be off
        expect(viewModel.debugMode, false);
      });

      test('should toggle debug mode on', () {
        // Given: Debug mode is off
        expect(viewModel.debugMode, false);

        // When: Toggling debug mode
        viewModel.toggleDebugMode();

        // Then: Debug mode should be on
        expect(viewModel.debugMode, true);
      });

      test('should toggle debug mode off', () {
        // Given: Debug mode is on
        viewModel.toggleDebugMode();
        expect(viewModel.debugMode, true);

        // When: Toggling debug mode again
        viewModel.toggleDebugMode();

        // Then: Debug mode should be off
        expect(viewModel.debugMode, false);
      });
    });

    group('app information', () {
      test('should have correct app name', () {
        expect(SettingsViewModel.appName, 'Fifty Demo');
      });

      test('should have correct app version', () {
        expect(SettingsViewModel.appVersion, '1.0.0');
      });

      test('should have correct build number', () {
        expect(SettingsViewModel.buildNumber, '1');
      });

      test('should have correct architecture', () {
        expect(SettingsViewModel.architecture, 'MVVM + Actions');
      });

      test('should have correct design system', () {
        expect(SettingsViewModel.designSystem, 'Fifty Design Language v2');
      });

      test('should have correct framework version', () {
        expect(SettingsViewModel.frameworkVersion, 'Flutter 3.24+');
      });

      test('should have correct state management', () {
        expect(SettingsViewModel.stateManagement, 'GetX');
      });
    });

    group('about information', () {
      test('should have correct copyright', () {
        expect(SettingsViewModel.copyright, '2025 Fifty.ai');
      });

      test('should have correct license', () {
        expect(SettingsViewModel.license, 'MIT License');
      });

      test('should have correct repository URL', () {
        expect(SettingsViewModel.repositoryUrl,
            'https://github.com/fiftynotai/fifty_eco_system');
      });

      test('should have correct docs URL', () {
        expect(SettingsViewModel.docsUrl, 'https://fifty.ai/docs');
      });
    });
  });
}
