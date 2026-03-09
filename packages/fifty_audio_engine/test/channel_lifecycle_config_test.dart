import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

// ChannelLifecycleConfig and ChannelBackgroundAction are exported
// via base_audio_channel.dart -> fifty_audio_engine.dart barrel.
import 'package:fifty_audio_engine/engine/core/channel_lifecycle_config.dart';

void main() {
  group('ChannelLifecycleConfig', () {
    test('default values are correct', () {
      final config = ChannelLifecycleConfig();

      expect(config.onBackground, ChannelBackgroundAction.pause);
      expect(config.resumeOnForeground, isTrue);
      expect(config.unmuteOnForeground, isTrue);
      expect(config.fadeOnBackground, isTrue);
      expect(config.fadeOnForeground, isTrue);
      expect(config.stopOnDetached, isFalse);
    });

    test('fade presets default to fast out and normal in', () {
      final config = ChannelLifecycleConfig();

      expect(
        config.fadeOutPreset.duration,
        FadePreset.fast.duration,
      );
      expect(
        config.fadeInPreset.duration,
        FadePreset.normal.duration,
      );
    });

    test('custom values are applied', () {
      final config = ChannelLifecycleConfig(
        onBackground: ChannelBackgroundAction.mute,
        resumeOnForeground: false,
        unmuteOnForeground: false,
        fadeOnBackground: false,
        fadeOnForeground: false,
        fadeOutPreset: FadePreset.cinematic,
        fadeInPreset: FadePreset.ambient,
        stopOnDetached: true,
      );

      expect(config.onBackground, ChannelBackgroundAction.mute);
      expect(config.resumeOnForeground, isFalse);
      expect(config.unmuteOnForeground, isFalse);
      expect(config.fadeOnBackground, isFalse);
      expect(config.fadeOnForeground, isFalse);
      expect(config.fadeOutPreset.duration, FadePreset.cinematic.duration);
      expect(config.fadeInPreset.duration, FadePreset.ambient.duration);
      expect(config.stopOnDetached, isTrue);
    });
  });

  group('ChannelBackgroundAction', () {
    test('has expected values', () {
      expect(ChannelBackgroundAction.values, hasLength(4));
      expect(ChannelBackgroundAction.values, contains(ChannelBackgroundAction.none));
      expect(ChannelBackgroundAction.values, contains(ChannelBackgroundAction.pause));
      expect(ChannelBackgroundAction.values, contains(ChannelBackgroundAction.mute));
      expect(ChannelBackgroundAction.values, contains(ChannelBackgroundAction.stop));
    });
  });
}
