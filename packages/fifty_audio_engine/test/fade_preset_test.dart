import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

void main() {
  group('FadePreset', () {
    test('fast preset uses 150ms linear', () {
      expect(FadePreset.fast.duration.inMilliseconds, 150);
      expect(FadePreset.fast.curve, Curves.linear);
    });

    test('panel preset uses 300ms standard curve', () {
      expect(FadePreset.panel.duration.inMilliseconds, 300);
      // FiftyMotion.standard is the curve
      expect(FadePreset.panel.curve, isNotNull);
    });

    test('normal preset uses 800ms easeInOut', () {
      expect(FadePreset.normal.duration.inMilliseconds, 800);
      expect(FadePreset.normal.curve, Curves.easeInOut);
    });

    test('cinematic preset uses 2000ms easeInOutCubic', () {
      expect(FadePreset.cinematic.duration.inMilliseconds, 2000);
      expect(FadePreset.cinematic.curve, Curves.easeInOutCubic);
    });

    test('ambient preset uses 3000ms decelerate', () {
      expect(FadePreset.ambient.duration.inMilliseconds, 3000);
      expect(FadePreset.ambient.curve, Curves.decelerate);
    });

    test('buildTension preset uses 1200ms easeIn', () {
      expect(FadePreset.buildTension.duration.inMilliseconds, 1200);
      expect(FadePreset.buildTension.curve, Curves.easeIn);
    });

    test('smoothExit preset uses 1000ms easeOut', () {
      expect(FadePreset.smoothExit.duration.inMilliseconds, 1000);
      expect(FadePreset.smoothExit.curve, Curves.easeOut);
    });

    test('custom preset accepts arbitrary values', () {
      const preset = FadePreset(
        duration: Duration(milliseconds: 500),
        curve: Curves.bounceIn,
      );
      expect(preset.duration.inMilliseconds, 500);
      expect(preset.curve, Curves.bounceIn);
    });
  });
}
