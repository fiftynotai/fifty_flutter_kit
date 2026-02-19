/// HomeViewModel Unit Tests
///
/// Tests for the HomeViewModel business logic.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fifty_demo/features/home/controllers/home_view_model.dart';

import '../../mocks/mock_services.dart';

void main() {
  late HomeViewModel viewModel;
  late MockAudioIntegrationService mockAudioService;
  late MockSpeechIntegrationService mockSpeechService;
  late MockSentencesIntegrationService mockSentencesService;
  late MockMapIntegrationService mockMapService;

  setUpAll(() {
    // Enable test mode to prevent GetX from trying to access Navigator
    Get.testMode = true;
  });

  setUp(() {
    mockAudioService = MockAudioIntegrationService();
    mockSpeechService = MockSpeechIntegrationService();
    mockSentencesService = MockSentencesIntegrationService();
    mockMapService = MockMapIntegrationService();

    // Default stubs
    when(() => mockAudioService.isInitialized).thenReturn(false);
    when(() => mockSpeechService.isInitialized).thenReturn(false);
    when(() => mockSentencesService.isInitialized).thenReturn(false);
    when(() => mockMapService.isInitialized).thenReturn(false);
    when(() => mockAudioService.initialize()).thenAnswer((_) async {});
    when(() => mockSpeechService.initialize()).thenAnswer((_) async => true);
    when(() => mockSentencesService.initialize()).thenAnswer((_) async {});

    viewModel = HomeViewModel(
      audioService: mockAudioService,
      speechService: mockSpeechService,
      sentencesService: mockSentencesService,
      mapService: mockMapService,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeViewModel', () {
    group('initialization', () {
      test('should not be initialized by default', () {
        // Given: ViewModel is created
        // When: Checking servicesInitialized
        // Then: Should be false before onInit
        expect(viewModel.servicesInitialized, false);
      });

      test('should initialize services on onInit', () async {
        // Given: ViewModel is created
        // When: Calling onInit
        viewModel.onInit();

        // Allow async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Then: Services should be initialized
        verify(() => mockAudioService.initialize()).called(1);
        verify(() => mockSpeechService.initialize()).called(1);
        verify(() => mockSentencesService.initialize()).called(1);
      });
    });

    group('packages', () {
      test('should return correct number of packages', () {
        // Given: ViewModel is created
        // When: Accessing packages
        final packages = viewModel.packages;

        // Then: Should have 15 packages
        expect(packages.length, 15);
      });

      test('should have design system packages', () {
        // Given: ViewModel is created
        // When: Filtering design system packages
        final designSystemPackages = viewModel.packages
            .where((p) => p.category == PackageCategory.designSystem)
            .toList();

        // Then: Should have 3 design system packages
        expect(designSystemPackages.length, 3);
        expect(
          designSystemPackages.map((p) => p.name).toList(),
          containsAll(['fifty_tokens', 'fifty_theme', 'fifty_ui']),
        );
      });

      test('should have engine packages', () {
        // Given: ViewModel is created
        // When: Filtering engine packages
        final enginePackages = viewModel.packages
            .where((p) => p.category == PackageCategory.engines)
            .toList();

        // Then: Should have 5 engine packages
        expect(enginePackages.length, 5);
        expect(
          enginePackages.map((p) => p.name).toList(),
          containsAll([
            'fifty_audio_engine',
            'fifty_speech_engine',
            'fifty_sentences_engine',
            'fifty_world_engine',
            'fifty_printing_engine',
          ]),
        );
      });

      test('should have feature packages', () {
        // Given: ViewModel is created
        // When: Filtering feature packages
        final featurePackages = viewModel.packages
            .where((p) => p.category == PackageCategory.features)
            .toList();

        // Then: Should have 3 feature packages
        expect(featurePackages.length, 3);
        expect(
          featurePackages.map((p) => p.name).toList(),
          containsAll([
            'fifty_forms',
            'fifty_skill_tree',
            'fifty_achievement_engine',
          ]),
        );
      });

      test('should have utility packages', () {
        // Given: ViewModel is created
        // When: Filtering utility packages
        final utilityPackages = viewModel.packages
            .where((p) => p.category == PackageCategory.utilities)
            .toList();

        // Then: Should have 4 utility packages
        expect(utilityPackages.length, 4);
        expect(
          utilityPackages.map((p) => p.name).toList(),
          containsAll([
            'fifty_cache',
            'fifty_storage',
            'fifty_utils',
            'fifty_connectivity',
          ]),
        );
      });

      test('should reflect audio service initialization status', () {
        // Given: Audio service is initialized
        when(() => mockAudioService.isInitialized).thenReturn(true);

        // When: Accessing audio package
        final audioPackage = viewModel.packages
            .firstWhere((p) => p.name == 'fifty_audio_engine');

        // Then: Should show as ready
        expect(audioPackage.isReady, true);
      });

      test('should reflect speech service initialization status', () {
        // Given: Speech service is not initialized
        when(() => mockSpeechService.isInitialized).thenReturn(false);

        // When: Accessing speech package
        final speechPackage = viewModel.packages
            .firstWhere((p) => p.name == 'fifty_speech_engine');

        // Then: Should show as not ready
        expect(speechPackage.isReady, false);
      });

      test('should have correct version for fifty_tokens', () {
        // Given: ViewModel is created
        // When: Accessing fifty_tokens package
        final tokensPackage =
            viewModel.packages.firstWhere((p) => p.name == 'fifty_tokens');

        // Then: Should have version v1.0.0
        expect(tokensPackage.version, 'v1.0.0');
      });

      test('should have description for each package', () {
        // Given: ViewModel is created
        // When: Checking all packages
        // Then: Each should have a non-null description
        for (final package in viewModel.packages) {
          expect(package.description, isNotNull);
          expect(package.description, isNotEmpty);
        }
      });
    });

    group('readyCount', () {
      test('should count static ready packages', () {
        // Given: Services are not initialized
        when(() => mockAudioService.isInitialized).thenReturn(false);
        when(() => mockSpeechService.isInitialized).thenReturn(false);
        when(() => mockSentencesService.isInitialized).thenReturn(false);
        when(() => mockMapService.isInitialized).thenReturn(false);

        // When: Accessing readyCount
        final count = viewModel.readyCount;

        // Then: Should count only static ready packages (11 packages are always ready)
        // Design System (3) + Printing (1) + Features (3) + Utilities (4) = 11
        expect(count, 11);
      });

      test('should count all ready when services initialized', () {
        // Given: All services are initialized
        when(() => mockAudioService.isInitialized).thenReturn(true);
        when(() => mockSpeechService.isInitialized).thenReturn(true);
        when(() => mockSentencesService.isInitialized).thenReturn(true);
        when(() => mockMapService.isInitialized).thenReturn(true);

        // When: Accessing readyCount
        final count = viewModel.readyCount;

        // Then: All 15 packages should be ready
        expect(count, 15);
      });
    });

    group('totalCount', () {
      test('should return 15 total packages', () {
        // Given: ViewModel is created
        // When: Accessing totalCount
        // Then: Should be 15
        expect(viewModel.totalCount, 15);
      });
    });

    group('allReady', () {
      test('should return false when not all services initialized', () {
        // Given: Some services are not initialized
        when(() => mockAudioService.isInitialized).thenReturn(true);
        when(() => mockSpeechService.isInitialized).thenReturn(false);
        when(() => mockSentencesService.isInitialized).thenReturn(true);
        when(() => mockMapService.isInitialized).thenReturn(true);

        // When: Checking allReady
        // Then: Should be false
        expect(viewModel.allReady, false);
      });

      test('should return true when all services initialized', () {
        // Given: All services are initialized
        when(() => mockAudioService.isInitialized).thenReturn(true);
        when(() => mockSpeechService.isInitialized).thenReturn(true);
        when(() => mockSentencesService.isInitialized).thenReturn(true);
        when(() => mockMapService.isInitialized).thenReturn(true);

        // When: Checking allReady
        // Then: Should be true
        expect(viewModel.allReady, true);
      });
    });

    group('statusMessage', () {
      test('should show partial status when not all ready', () {
        // Given: Some services are not initialized
        when(() => mockAudioService.isInitialized).thenReturn(false);
        when(() => mockSpeechService.isInitialized).thenReturn(false);
        when(() => mockSentencesService.isInitialized).thenReturn(false);
        when(() => mockMapService.isInitialized).thenReturn(false);

        // When: Accessing statusMessage
        final message = viewModel.statusMessage;

        // Then: Should show partial status (11 static ready)
        expect(message, '11/15 SYSTEMS READY');
      });

      test('should show all operational when all ready', () {
        // Given: All services are initialized
        when(() => mockAudioService.isInitialized).thenReturn(true);
        when(() => mockSpeechService.isInitialized).thenReturn(true);
        when(() => mockSentencesService.isInitialized).thenReturn(true);
        when(() => mockMapService.isInitialized).thenReturn(true);

        // When: Accessing statusMessage
        final message = viewModel.statusMessage;

        // Then: Should show all operational
        expect(message, 'ALL SYSTEMS OPERATIONAL');
      });
    });

    group('features', () {
      test('should have 3 feature cards', () {
        // Given: ViewModel is created
        // When: Accessing features
        // Then: Should have 3 features
        expect(HomeViewModel.features.length, 3);
      });

      test('should have map demo feature', () {
        // Given: ViewModel is created
        // When: Finding map demo feature
        final mapDemo = HomeViewModel.features.firstWhere(
          (f) => f.id == 'map_demo',
        );

        // Then: Should have correct details
        expect(mapDemo.title, 'MAP DEMO');
        expect(mapDemo.subtitle, 'Interactive grid map with audio integration');
      });

      test('should have dialogue demo feature', () {
        // Given: ViewModel is created
        // When: Finding dialogue demo feature
        final dialogueDemo = HomeViewModel.features.firstWhere(
          (f) => f.id == 'dialogue_demo',
        );

        // Then: Should have correct details
        expect(dialogueDemo.title, 'DIALOGUE DEMO');
        expect(dialogueDemo.subtitle, 'Sentence engine with TTS/STT');
      });

      test('should have ui showcase feature', () {
        // Given: ViewModel is created
        // When: Finding ui showcase feature
        final uiShowcase = HomeViewModel.features.firstWhere(
          (f) => f.id == 'ui_showcase',
        );

        // Then: Should have correct details
        expect(uiShowcase.title, 'UI SHOWCASE');
        expect(uiShowcase.subtitle, 'Fifty Design Language components');
      });

      test('each feature should have an icon code', () {
        // Given: ViewModel is created
        // When: Checking all features
        // Then: Each should have a valid icon code
        for (final feature in HomeViewModel.features) {
          expect(feature.icon, isPositive);
        }
      });
    });
  });

  group('PackageStatus', () {
    test('should create with required fields', () {
      // Given: Required parameters
      // When: Creating PackageStatus
      const status = PackageStatus(
        name: 'test_package',
        version: 'v1.0.0',
        isReady: true,
        category: PackageCategory.utilities,
      );

      // Then: Should have correct values
      expect(status.name, 'test_package');
      expect(status.version, 'v1.0.0');
      expect(status.isReady, true);
      expect(status.category, PackageCategory.utilities);
      expect(status.description, isNull);
    });

    test('should create with optional description', () {
      // Given: All parameters including description
      // When: Creating PackageStatus
      const status = PackageStatus(
        name: 'test_package',
        version: 'v1.0.0',
        isReady: true,
        category: PackageCategory.utilities,
        description: 'A test package',
      );

      // Then: Should have description
      expect(status.description, 'A test package');
    });
  });

  group('PackageCategory', () {
    test('should have correct labels', () {
      expect(PackageCategory.designSystem.label, 'Design System');
      expect(PackageCategory.engines.label, 'Engines');
      expect(PackageCategory.features.label, 'Features');
      expect(PackageCategory.utilities.label, 'Utilities');
    });
  });

  group('FeatureInfo', () {
    test('should create with required fields', () {
      // Given: Required parameters
      // When: Creating FeatureInfo
      const info = FeatureInfo(
        id: 'test_feature',
        title: 'Test Feature',
        subtitle: 'A test feature description',
        icon: 0xe000,
      );

      // Then: Should have correct values
      expect(info.id, 'test_feature');
      expect(info.title, 'Test Feature');
      expect(info.subtitle, 'A test feature description');
      expect(info.icon, 0xe000);
    });
  });
}
