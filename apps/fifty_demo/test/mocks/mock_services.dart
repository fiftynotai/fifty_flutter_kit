/// Mock Services for Testing
///
/// Contains mock implementations of services used in ViewModels.
library;

import 'package:mocktail/mocktail.dart';

import 'package:fifty_demo/features/settings/data/services/theme_service.dart';
import 'package:fifty_demo/shared/services/audio_integration_service.dart';
import 'package:fifty_demo/shared/services/map_integration_service.dart';
import 'package:fifty_demo/shared/services/sentences_integration_service.dart';
import 'package:fifty_demo/shared/services/speech_integration_service.dart';

/// Mock ThemeService for SettingsViewModel tests.
class MockThemeService extends Mock implements ThemeService {}

/// Mock AudioIntegrationService for HomeViewModel tests.
class MockAudioIntegrationService extends Mock
    implements AudioIntegrationService {}

/// Mock SpeechIntegrationService for HomeViewModel tests.
class MockSpeechIntegrationService extends Mock
    implements SpeechIntegrationService {}

/// Mock SentencesIntegrationService for HomeViewModel tests.
class MockSentencesIntegrationService extends Mock
    implements SentencesIntegrationService {}

/// Mock MapIntegrationService for HomeViewModel tests.
class MockMapIntegrationService extends Mock implements MapIntegrationService {}
