/// Home ViewModel
///
/// Business logic for the home feature.
/// Displays ecosystem status and package information.
library;

import 'package:flutter/foundation.dart';

import '../../../shared/services/audio_integration_service.dart';
import '../../../shared/services/map_integration_service.dart';
import '../../../shared/services/sentences_integration_service.dart';
import '../../../shared/services/speech_integration_service.dart';

/// Package status information.
class PackageStatus {
  const PackageStatus({
    required this.name,
    required this.version,
    required this.isReady,
    this.description,
  });

  final String name;
  final String version;
  final bool isReady;
  final String? description;
}

/// ViewModel for the home feature.
///
/// Provides ecosystem status and navigation state.
class HomeViewModel extends ChangeNotifier {
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

  // ─────────────────────────────────────────────────────────────────────────
  // Package Information
  // ─────────────────────────────────────────────────────────────────────────

  /// List of all Fifty packages with their status.
  List<PackageStatus> get packages => [
        const PackageStatus(
          name: 'fifty_tokens',
          version: 'v0.2.0',
          isReady: true,
          description: 'Design tokens (colors, typography, spacing)',
        ),
        const PackageStatus(
          name: 'fifty_theme',
          version: 'v0.1.0',
          isReady: true,
          description: 'Theme system (dark/light themes)',
        ),
        const PackageStatus(
          name: 'fifty_ui',
          version: 'v0.5.0',
          isReady: true,
          description: 'UI components (buttons, cards, inputs)',
        ),
        PackageStatus(
          name: 'fifty_audio_engine',
          version: 'v0.7.0',
          isReady: _audioService.isInitialized,
          description: 'Audio (BGM, SFX, Voice channels)',
        ),
        PackageStatus(
          name: 'fifty_speech_engine',
          version: 'v0.1.0',
          isReady: _speechService.isInitialized,
          description: 'TTS/STT capabilities',
        ),
        PackageStatus(
          name: 'fifty_sentences_engine',
          version: 'v0.1.0',
          isReady: _sentencesService.isInitialized,
          description: 'Dialogue/sentence queue processing',
        ),
        PackageStatus(
          name: 'fifty_map_engine',
          version: 'v0.1.0',
          isReady: _mapService.isInitialized,
          description: 'Interactive grid map rendering',
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

  /// Initializes all services.
  Future<void> initializeServices() async {
    await _audioService.initialize();
    await _speechService.initialize();
    await _sentencesService.initialize();
    notifyListeners();
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
