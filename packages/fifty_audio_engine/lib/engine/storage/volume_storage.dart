/// **Volume Storage Interface**
///
/// Abstracts persistent volume state for each audio group.
/// Used by audio managers to load/save user volume preferences.
///
/// ─────────────────────────────────────────────────────────────────────────────
abstract class VolumeStorage {
  double get bgmVolume;
  set bgmVolume(double value);

  double get sfxVolume;
  set sfxVolume(double value);

  double get voiceVolume;
  set voiceVolume(double value);
}
