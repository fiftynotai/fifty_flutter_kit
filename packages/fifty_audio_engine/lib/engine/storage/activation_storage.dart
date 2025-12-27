/// **Activation Storage Interface**
///
/// Abstracts the persistent "active" state for each audio channel (BGM, SFX, Voice).
/// Implemented by storage services like [AudioMemoryService].
///
/// This allows you to store whether each sound type is enabled or disabled.
///
/// ─────────────────────────────────────────────────────────────────────────────
abstract class ActivationStorage {
  bool get isBgmActive;
  set isBgmActive(bool value);

  bool get isSfxActive;
  set isSfxActive(bool value);

  bool get isVoiceActive;
  set isVoiceActive(bool value);
}
