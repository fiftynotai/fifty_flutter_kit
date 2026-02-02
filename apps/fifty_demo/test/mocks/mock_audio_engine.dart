/// Mock Audio Engine for Testing
///
/// Contains mock implementations of FiftyAudioEngine channels.
/// Used for testing AudioDemoViewModel without real audio playback.
library;

import 'dart:async';

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:mocktail/mocktail.dart';

/// Mock BgmChannel for audio tests.
class MockBgmChannel extends Mock implements BgmChannel {}

/// Mock SfxChannel for audio tests.
class MockSfxChannel extends Mock implements SfxChannel {}

/// Mock VoiceActingChannel for audio tests.
class MockVoiceActingChannel extends Mock implements VoiceActingChannel {}

/// Fake FadePreset for registerFallbackValue.
class FakeFadePreset extends Fake implements FadePreset {}

/// Test helper to set up common BgmChannel stubs.
void setupMockBgmChannel(MockBgmChannel mock) {
  when(() => mock.isPlaying).thenReturn(false);
  when(() => mock.volume).thenReturn(0.7);
  when(() => mock.play(any())).thenAnswer((_) async {});
  when(() => mock.pause()).thenAnswer((_) async {});
  when(() => mock.stop()).thenAnswer((_) async {});
  when(() => mock.resume()).thenAnswer((_) async {});
  when(() => mock.setVolume(any())).thenAnswer((_) async {});
  when(() => mock.mute()).thenAnswer((_) async {});
  when(() => mock.unmute()).thenAnswer((_) async {});
  when(() => mock.playNext()).thenAnswer((_) async {});
  when(() => mock.playAtIndex(any())).thenAnswer((_) async {});
  when(() => mock.getDuration()).thenAnswer((_) async => const Duration(minutes: 3));
  when(() => mock.onPositionChanged).thenAnswer((_) => Stream<Duration>.empty());
  when(() => mock.fadeInVolume(any())).thenAnswer((_) async {});
  when(() => mock.fadeOutVolume(any())).thenAnswer((_) async {});
}

/// Test helper to set up common SfxChannel stubs.
void setupMockSfxChannel(MockSfxChannel mock) {
  when(() => mock.volume).thenReturn(0.8);
  when(() => mock.play(any())).thenAnswer((_) async {});
  when(() => mock.stop()).thenAnswer((_) async {});
  when(() => mock.setVolume(any())).thenAnswer((_) async {});
  when(() => mock.mute()).thenAnswer((_) async {});
  when(() => mock.unmute()).thenAnswer((_) async {});
  when(() => mock.registerGroup(any(), any())).thenReturn(null);
  when(() => mock.fadeInVolume(any())).thenAnswer((_) async {});
  when(() => mock.fadeOutVolume(any())).thenAnswer((_) async {});
}

/// Test helper to set up common VoiceActingChannel stubs.
void setupMockVoiceChannel(MockVoiceActingChannel mock) {
  when(() => mock.isPlaying).thenReturn(false);
  when(() => mock.volume).thenReturn(1.0);
  when(() => mock.playVoice(any(), any())).thenAnswer((_) async {});
  when(() => mock.stop()).thenAnswer((_) async {});
  when(() => mock.setVolume(any())).thenAnswer((_) async {});
  when(() => mock.mute()).thenAnswer((_) async {});
  when(() => mock.unmute()).thenAnswer((_) async {});
  when(() => mock.fadeInVolume(any())).thenAnswer((_) async {});
  when(() => mock.fadeOutVolume(any())).thenAnswer((_) async {});
}
