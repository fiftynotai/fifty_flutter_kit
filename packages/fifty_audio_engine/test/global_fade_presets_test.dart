import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

void main() {
  group('GlobalFadePresets', () {
    test('uiClick maps to FadePreset.fast', () {
      expect(
        GlobalFadePresets.uiClick.duration,
        FadePreset.fast.duration,
      );
      expect(
        GlobalFadePresets.uiClick.curve,
        FadePreset.fast.curve,
      );
    });

    test('sceneChange maps to FadePreset.normal', () {
      expect(
        GlobalFadePresets.sceneChange.duration,
        FadePreset.normal.duration,
      );
      expect(
        GlobalFadePresets.sceneChange.curve,
        FadePreset.normal.curve,
      );
    });

    test('ambientShift maps to FadePreset.ambient', () {
      expect(
        GlobalFadePresets.ambientShift.duration,
        FadePreset.ambient.duration,
      );
      expect(
        GlobalFadePresets.ambientShift.curve,
        FadePreset.ambient.curve,
      );
    });

    test('bossEntrance maps to FadePreset.buildTension', () {
      expect(
        GlobalFadePresets.bossEntrance.duration,
        FadePreset.buildTension.duration,
      );
      expect(
        GlobalFadePresets.bossEntrance.curve,
        FadePreset.buildTension.curve,
      );
    });

    test('cinematic maps to FadePreset.cinematic', () {
      expect(
        GlobalFadePresets.cinematic.duration,
        FadePreset.cinematic.duration,
      );
      expect(
        GlobalFadePresets.cinematic.curve,
        FadePreset.cinematic.curve,
      );
    });

    test('voiceDuckingOut maps to FadePreset.fast', () {
      expect(
        GlobalFadePresets.voiceDuckingOut.duration,
        FadePreset.fast.duration,
      );
    });

    test('voiceDuckingIn maps to FadePreset.normal', () {
      expect(
        GlobalFadePresets.voiceDuckingIn.duration,
        FadePreset.normal.duration,
      );
    });

    test('levelTransition maps to FadePreset.normal', () {
      expect(
        GlobalFadePresets.levelTransition.duration,
        FadePreset.normal.duration,
      );
    });

    test('smoothExit maps to FadePreset.smoothExit', () {
      expect(
        GlobalFadePresets.smoothExit.duration,
        FadePreset.smoothExit.duration,
      );
      expect(
        GlobalFadePresets.smoothExit.curve,
        FadePreset.smoothExit.curve,
      );
    });
  });
}
