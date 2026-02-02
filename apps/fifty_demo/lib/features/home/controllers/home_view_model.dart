/// Home ViewModel
///
/// Business logic for the home feature.
/// Displays ecosystem status and package information.
library;

import 'package:get/get.dart';

import '../../../shared/services/audio_integration_service.dart';
import '../../../shared/services/map_integration_service.dart';
import '../../../shared/services/sentences_integration_service.dart';
import '../../../shared/services/speech_integration_service.dart';

/// Package category for grouping.
enum PackageCategory {
  designSystem('Design System'),
  engines('Engines'),
  features('Features'),
  utilities('Utilities');

  const PackageCategory(this.label);
  final String label;
}

/// Package status information.
class PackageStatus {
  const PackageStatus({
    required this.name,
    required this.version,
    required this.isReady,
    required this.category,
    this.description,
  });

  final String name;
  final String version;
  final bool isReady;
  final PackageCategory category;
  final String? description;
}

/// ViewModel for the home feature.
///
/// Provides ecosystem status and navigation state.
///
/// **Note:** No `onClose()` override needed. Services are injected dependencies
/// managed by their own bindings. RxBool observables are auto-disposed by GetX.
class HomeViewModel extends GetxController {
  HomeViewModel({
    required AudioIntegrationService audioService,
    required SpeechIntegrationService speechService,
    required SentencesIntegrationService sentencesService,
    required MapIntegrationService mapService,
  })  : _audioService = audioService,
        _speechService = speechService,
        _sentencesService = sentencesService,
        _mapService = mapService;

  final AudioIntegrationService _audioService;
  final SpeechIntegrationService _speechService;
  final SentencesIntegrationService _sentencesService;
  final MapIntegrationService _mapService;

  // Reactive state
  final RxBool _servicesInitialized = false.obs;
  bool get servicesInitialized => _servicesInitialized.value;

  // ─────────────────────────────────────────────────────────────────────────
  // Package Information
  // ─────────────────────────────────────────────────────────────────────────

  /// List of all Fifty packages with their status.
  List<PackageStatus> get packages => [
        // Design System packages
        const PackageStatus(
          name: 'fifty_tokens',
          version: 'v1.0.0',
          isReady: true,
          category: PackageCategory.designSystem,
          description: 'Design tokens (colors, typography, spacing)',
        ),
        const PackageStatus(
          name: 'fifty_theme',
          version: 'v1.0.0',
          isReady: true,
          category: PackageCategory.designSystem,
          description: 'Theme system (dark/light themes)',
        ),
        const PackageStatus(
          name: 'fifty_ui',
          version: 'v1.0.0',
          isReady: true,
          category: PackageCategory.designSystem,
          description: 'UI components (buttons, cards, inputs)',
        ),
        // Engine packages
        PackageStatus(
          name: 'fifty_audio_engine',
          version: 'v0.8.0',
          isReady: _audioService.isInitialized,
          category: PackageCategory.engines,
          description: 'Audio (BGM, SFX, Voice channels)',
        ),
        PackageStatus(
          name: 'fifty_speech_engine',
          version: 'v0.1.0',
          isReady: _speechService.isInitialized,
          category: PackageCategory.engines,
          description: 'TTS/STT capabilities',
        ),
        PackageStatus(
          name: 'fifty_sentences_engine',
          version: 'v0.1.0',
          isReady: _sentencesService.isInitialized,
          category: PackageCategory.engines,
          description: 'Dialogue/sentence queue processing',
        ),
        PackageStatus(
          name: 'fifty_map_engine',
          version: 'v0.1.0',
          isReady: _mapService.isInitialized,
          category: PackageCategory.engines,
          description: 'Interactive grid map rendering',
        ),
        const PackageStatus(
          name: 'fifty_printing_engine',
          version: 'v1.0.0',
          isReady: true,
          category: PackageCategory.engines,
          description: 'Document printing utilities',
        ),
        // Feature packages
        const PackageStatus(
          name: 'fifty_forms',
          version: 'v0.1.0',
          isReady: true,
          category: PackageCategory.features,
          description: 'Form validation & management',
        ),
        const PackageStatus(
          name: 'fifty_skill_tree',
          version: 'v0.2.0',
          isReady: true,
          category: PackageCategory.features,
          description: 'Skill progression system',
        ),
        const PackageStatus(
          name: 'fifty_achievement_engine',
          version: 'v0.1.1',
          isReady: true,
          category: PackageCategory.features,
          description: 'Achievement tracking system',
        ),
        // Utility packages
        const PackageStatus(
          name: 'fifty_cache',
          version: 'v0.1.0',
          isReady: true,
          category: PackageCategory.utilities,
          description: 'Caching layer for data',
        ),
        const PackageStatus(
          name: 'fifty_storage',
          version: 'v0.1.0',
          isReady: true,
          category: PackageCategory.utilities,
          description: 'Local storage abstraction',
        ),
        const PackageStatus(
          name: 'fifty_utils',
          version: 'v0.1.0',
          isReady: true,
          category: PackageCategory.utilities,
          description: 'Common utility functions',
        ),
        const PackageStatus(
          name: 'fifty_connectivity',
          version: 'v0.1.0',
          isReady: true,
          category: PackageCategory.utilities,
          description: 'Network connectivity monitoring',
        ),
      ];

  /// Number of ready packages.
  int get readyCount => packages.where((p) => p.isReady).length;

  /// Total number of packages.
  int get totalCount => packages.length;

  /// Whether all packages are ready.
  bool get allReady => readyCount == totalCount;

  /// Status message for display.
  String get statusMessage {
    if (allReady) {
      return 'ALL SYSTEMS OPERATIONAL';
    }
    return '$readyCount/$totalCount SYSTEMS READY';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Feature Cards
  // ─────────────────────────────────────────────────────────────────────────

  /// Feature card information.
  static const List<FeatureInfo> features = [
    FeatureInfo(
      id: 'map_demo',
      title: 'MAP DEMO',
      subtitle: 'Interactive grid map with audio integration',
      icon: 0xe55b, // Icons.map
    ),
    FeatureInfo(
      id: 'dialogue_demo',
      title: 'DIALOGUE DEMO',
      subtitle: 'Sentence engine with TTS/STT',
      icon: 0xe0b7, // Icons.chat
    ),
    FeatureInfo(
      id: 'ui_showcase',
      title: 'UI SHOWCASE',
      subtitle: 'Fifty Design Language components',
      icon: 0xe6e1, // Icons.widgets
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    initializeServices();
  }

  /// Initializes all services.
  Future<void> initializeServices() async {
    await _audioService.initialize();
    await _speechService.initialize();
    await _sentencesService.initialize();
    _servicesInitialized.value = true;
    update();
  }
}

/// Feature information for navigation cards.
class FeatureInfo {
  const FeatureInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final int icon;
}
