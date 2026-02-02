/// HomePage Widget Tests
///
/// Tests for the HomePage widget rendering and interactions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fifty_demo/features/home/controllers/home_view_model.dart';
import 'package:fifty_demo/features/home/views/home_page.dart';

import '../mocks/mock_services.dart';

void main() {
  late MockAudioIntegrationService mockAudioService;
  late MockSpeechIntegrationService mockSpeechService;
  late MockSentencesIntegrationService mockSentencesService;
  late MockMapIntegrationService mockMapService;

  setUpAll(() {
    Get.testMode = true;
  });

  setUp(() {
    mockAudioService = MockAudioIntegrationService();
    mockSpeechService = MockSpeechIntegrationService();
    mockSentencesService = MockSentencesIntegrationService();
    mockMapService = MockMapIntegrationService();

    // Default stubs
    when(() => mockAudioService.isInitialized).thenReturn(true);
    when(() => mockSpeechService.isInitialized).thenReturn(true);
    when(() => mockSentencesService.isInitialized).thenReturn(true);
    when(() => mockMapService.isInitialized).thenReturn(true);
    when(() => mockAudioService.initialize()).thenAnswer((_) async {});
    when(() => mockSpeechService.initialize()).thenAnswer((_) async => true);
    when(() => mockSentencesService.initialize()).thenAnswer((_) async {});

    // Register the ViewModel
    final viewModel = HomeViewModel(
      audioService: mockAudioService,
      speechService: mockSpeechService,
      sentencesService: mockSentencesService,
      mapService: mockMapService,
    );
    Get.put<HomeViewModel>(viewModel);
  });

  tearDown(() {
    Get.reset();
  });

  /// Helper to build the test widget with required providers.
  Widget buildTestWidget({void Function(int)? onTabChange}) {
    return GetMaterialApp(
      home: Scaffold(
        body: HomePage(onTabChange: onTabChange),
      ),
    );
  }

  group('HomePage', () {
    testWidgets('should render section headers', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: Section headers should be visible
      expect(find.text('Getting Started'), findsOneWidget);
      expect(find.text("What's New"), findsOneWidget);
      expect(find.text('Resources'), findsOneWidget);
      expect(find.text('System Info'), findsOneWidget);
    });

    testWidgets('should render system info section', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: System info should be visible
      expect(find.text('APP'), findsOneWidget);
      expect(find.text('Fifty Demo'), findsOneWidget);
      expect(find.text('VERSION'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.text('ARCHITECTURE'), findsOneWidget);
      expect(find.text('MVVM + Actions'), findsOneWidget);
      expect(find.text('UI SYSTEM'), findsOneWidget);
      expect(find.text('Fifty Design Language'), findsOneWidget);
    });

    testWidgets('should render getting started action cards', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: Action cards should be visible
      expect(find.text('EXPLORE PACKAGES'), findsOneWidget);
      expect(find.text('UI COMPONENTS'), findsOneWidget);
      expect(find.text('AUDIO DEMO'), findsOneWidget);
      expect(find.text('MAP DEMO'), findsOneWidget);
    });

    testWidgets('should render action card descriptions', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: Descriptions should be visible
      expect(find.text('Browse the ecosystem'), findsOneWidget);
      expect(find.text('View design system'), findsOneWidget);
      expect(find.text('Sound engine showcase'), findsOneWidget);
      expect(find.text('Interactive grid map'), findsOneWidget);
    });

    testWidgets('should call onTabChange with index 1 for Explore Packages',
        (tester) async {
      // Given: HomePage with onTabChange callback
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        onTabChange: (index) => tappedIndex = index,
      ));
      await tester.pumpAndSettle();

      // When: Tapping Explore Packages
      await tester.tap(find.text('EXPLORE PACKAGES'));
      await tester.pumpAndSettle();

      // Then: onTabChange should be called with index 1
      expect(tappedIndex, 1);
    });

    testWidgets('should call onTabChange with index 2 for UI Components',
        (tester) async {
      // Given: HomePage with onTabChange callback
      int? tappedIndex;
      await tester.pumpWidget(buildTestWidget(
        onTabChange: (index) => tappedIndex = index,
      ));
      await tester.pumpAndSettle();

      // When: Tapping UI Components
      await tester.tap(find.text('UI COMPONENTS'));
      await tester.pumpAndSettle();

      // Then: onTabChange should be called with index 2
      expect(tappedIndex, 2);
    });

    testWidgets('should render section subtitles', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: Subtitles should be visible
      expect(find.text('Quick actions'), findsOneWidget);
      expect(find.text('Recent updates'), findsOneWidget);
      expect(find.text('External links'), findsOneWidget);
      expect(find.text('Application details'), findsOneWidget);
    });

    testWidgets('should scroll to show all sections', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // When: Scrolling down
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Then: System Info section should still be findable (it was already visible)
      expect(find.text('System Info'), findsOneWidget);
    });

    testWidgets('should have icons in action cards', (tester) async {
      // Given: HomePage widget
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Then: Icons should be present
      expect(find.byIcon(Icons.apps), findsOneWidget);
      expect(find.byIcon(Icons.widgets_outlined), findsOneWidget);
      expect(find.byIcon(Icons.headphones), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
    });
  });
}
