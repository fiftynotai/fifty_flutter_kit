import 'core/fade_preset.dart';

/// **Global Fade Presets**
///
/// Semantic and centralized presets to use across the entire game,
/// allowing developers to reference meaningful transitions by name.
///
/// These wrap common audio use cases like ambient changes, voice ducking,
/// and scene switching.
///
/// ─────────────────────────────────────────────────────────────────────────────
class GlobalFadePresets {
  /// Fast UI clicks or menu transitions
  static const FadePreset uiClick = FadePreset.fast;

  /// Transitioning between scenes (e.g., loading screens)
  static const FadePreset sceneChange = FadePreset.normal;

  /// Ambience shift like day/night or mood swap
  static const FadePreset ambientShift = FadePreset.ambient;

  /// Boss entrance music (build tension)
  static const FadePreset bossEntrance = FadePreset.buildTension;

  /// Exiting boss or dramatic moment
  static const FadePreset smoothExit = FadePreset.smoothExit;

  /// Full cinematic moments (e.g., intro, ending)
  static const FadePreset cinematic = FadePreset.cinematic;

  /// Character voice-over fades (BGM ducking)
  static const FadePreset voiceDuckingOut = FadePreset.fast;
  static const FadePreset voiceDuckingIn = FadePreset.normal;

  /// Level transitions
  static const FadePreset levelTransition = FadePreset.normal;
}