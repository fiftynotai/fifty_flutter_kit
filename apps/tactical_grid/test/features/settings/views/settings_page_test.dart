import 'dart:io';

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tactical_grid/features/settings/actions/settings_actions.dart';
import 'package:tactical_grid/features/settings/controllers/settings_view_model.dart';
import 'package:tactical_grid/features/settings/data/services/settings_service.dart';
import 'package:tactical_grid/features/settings/views/settings_page.dart';

/// Minimal in-memory stub for [SettingsService] to avoid real storage.
class _FakeSettingsService extends SettingsService {
  int _turnDuration = 60;
  int _warningThreshold = 10;
  int _criticalThreshold = 5;
  String _difficulty = 'easy';
  String _themeMode = 'dark';
  bool _muteState = false;

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
    _turnDuration = 60;
    _warningThreshold = 10;
    _criticalThreshold = 5;
    _difficulty = 'easy';
    _themeMode = 'dark';
    _muteState = false;
  }
}

/// Builds a test-safe ThemeData with FiftyThemeExtension but without
/// GoogleFonts (which cannot load in a test environment).
ThemeData _testTheme() {
  return ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      FiftyThemeExtension.dark(),
    ],
  );
}

void main() {
  late _FakeSettingsService fakeService;
  late SettingsViewModel viewModel;
  late SettingsActions actions;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock path_provider for GetStorage parent class.
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

    await GetStorage.init('TacticalGridSettings');
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;

    fakeService = _FakeSettingsService();
    viewModel = SettingsViewModel(fakeService);
    actions = SettingsActions(viewModel);

    Get.put<SettingsViewModel>(viewModel);
    Get.put<SettingsActions>(actions);
  });

  tearDown(() {
    Get.reset();
  });

  /// Wraps the [SettingsPage] in a GetMaterialApp with test-safe theme.
  Widget buildTestApp() {
    return GetMaterialApp(
      theme: _testTheme(),
      darkTheme: _testTheme(),
      themeMode: ThemeMode.dark,
      home: const SettingsPage(),
    );
  }

  // ---------------------------------------------------------------------------
  // Page rendering
  // ---------------------------------------------------------------------------

  group('SettingsPage rendering', () {
    testWidgets('renders SETTINGS title', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('renders Audio section header (uppercased by FiftySectionHeader)',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // FiftySectionHeader renders title.toUpperCase().
      expect(find.text('AUDIO'), findsOneWidget);
    });

    testWidgets('renders Gameplay section header (uppercased)',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('GAMEPLAY'), findsOneWidget);
    });

    testWidgets('renders Display section header (uppercased)', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('DISPLAY'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('DISPLAY'), findsOneWidget);
    });

    testWidgets('renders back button with arrow icon', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders RESET TO DEFAULTS button', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('RESET TO DEFAULTS'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('RESET TO DEFAULTS'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Audio section content
  // ---------------------------------------------------------------------------

  group('Audio section content', () {
    testWidgets('renders Master Mute label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Master Mute'), findsOneWidget);
    });

    testWidgets('renders BGM VOLUME label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('BGM VOLUME'), findsOneWidget);
    });

    testWidgets('renders SFX VOLUME label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('SFX VOLUME'), findsOneWidget);
    });

    testWidgets('renders VOICE VOLUME label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('VOICE VOLUME'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Gameplay section content
  // ---------------------------------------------------------------------------

  group('Gameplay section content', () {
    testWidgets('renders DEFAULT AI DIFFICULTY label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('DEFAULT AI DIFFICULTY'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('DEFAULT AI DIFFICULTY'), findsOneWidget);
    });

    testWidgets('renders difficulty buttons EASY, MEDIUM, HARD',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('EASY'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('EASY'), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      expect(find.text('HARD'), findsOneWidget);
    });

    testWidgets('renders TURN TIMER label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('TURN TIMER'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('TURN TIMER'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Display section content
  // ---------------------------------------------------------------------------

  group('Display section content', () {
    testWidgets('renders THEME MODE label', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('THEME MODE'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('THEME MODE'), findsOneWidget);
    });

    testWidgets('renders DARK and LIGHT theme options', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('DARK'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('DARK'), findsOneWidget);
      expect(find.text('LIGHT'), findsOneWidget);
    });
  });
}
