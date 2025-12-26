import 'package:audioplayers/audioplayers.dart';
import 'storage/audio_storage.dart';
import 'core/fade_preset.dart';
import 'channels/bgm_channel.dart';
import 'channels/sfx_channel.dart';
import 'channels/voice_acting_channel.dart';

/// **Fifty Audio Engine**
///
/// A singleton controller that initializes and exposes access to all core audio systems:
/// - [BgmChannel] for background music
/// - [SfxChannel] for UI / interaction sounds
/// - [VoiceActingChannel] for character voice lines
///
/// **Key Responsibilities:**
/// - Centralizes initialization of all audio managers
/// - Exposes unified access to sound subsystems
/// - Automatically wires BGM ducking during voice playback
/// - Provides global mute/unmute/stop + global fades
///
/// **Usage:**
/// ```dart
/// await FiftyAudioEngine.instance.initialize(['assets/bgm/theme.mp3']);
/// FiftyAudioEngine.instance.bgm.playNext();
/// FiftyAudioEngine.instance.sfx.playGroup('click');
/// FiftyAudioEngine.instance.voice.playVoice(myVoiceUrl);
/// ```
///
/// Part of the Fifty Design Language ecosystem.
class FiftyAudioEngine {
  /// **Singleton Instance**
  ///
  /// Access point for the entire audio system. Constructed via a private
  /// constructor to guarantee a single, long-lived instance.
  static final FiftyAudioEngine instance = FiftyAudioEngine._();

  FiftyAudioEngine._();

  /// **Persistent Audio Storage**
  ///
  /// Backed by [AudioStorage]. Used to persist volumes, mute states, and
  /// any per-channel preferences across app launches.
  late final AudioStorage _storage;

  /// **Background Music Manager**
  ///
  /// Long-form tracks (MP3/AAC/OGG). Uses `PlayerMode.mediaPlayer` under the hood,
  /// loops by default, and is designed to keep playing while other channels emit sounds.
  late final BgmChannel bgm;

  /// **Sound Effects Manager**
  ///
  /// Short UI/interaction sounds. Optimized for low latency and fire-and-forget
  /// patterns; can be pooled as needed.
  late final SfxChannel sfx;

  /// **Voice Acting Manager**
  ///
  /// Spoken lines / VO clips. When active, BGM volume is temporarily ducked and
  /// restored on completion.
  late final VoiceActingChannel voice;

  /// **Cached BGM Volume**
  ///
  /// Stores the current BGM volume so it can be restored after a voice-over
  /// ducking session finishes.
  double _bgmCachedVolume = 1.0;

  /// **BGM Audio Context (Mix, No Focus Steal)**
  ///
  /// - **Android:** `usageType=game`, `contentType=music`, `audioFocus=none`
  ///   (does **not** steal focus; keeps mixing with others)
  /// - **iOS:** `category=ambient`, `mixWithOthers`
  ///
  /// Use this to ensure BGM never pauses when other channels play.
  final _bgmContext = AudioContext(
    android: AudioContextAndroid(
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none, // don't steal focus
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: {},
    ),
  );

  /// **SFX Audio Context (Mix With Others)**
  ///
  /// Keeps UI sounds from grabbing exclusive audio focus.
  /// - **Android mapping:** *no focus change* (mixes; does **not** duck others)
  /// - **iOS mapping:** mixes with others
  ///
  /// If you prefer SFX to **duck** BGM briefly, switch to:
  /// `AudioContextConfig(focus: AudioContextConfigFocus.duckOthers).build()`
  final _sfxContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers, // Android => none (mix)
  ).build();

  /// **Voice Audio Context (Duck Others)**
  ///
  /// Requests transient, ducking focus so speech lines reduce BGM volume without
  /// stopping it.
  /// - **Android mapping:** `gainTransientMayDuck`
  /// - **iOS mapping:** `duckOthers`
  final _voiceContext = AudioContextConfig(
    focus: AudioContextConfigFocus.duckOthers, // Android => gainTransientMayDuck
  ).build();

  /// **Initialize the Sound System**
  ///
  /// Must be called once during app/game startup, **before** any sound is used.
  ///
  /// **What it does:**
  /// - Bootstraps [AudioStorage] and loads persisted settings
  /// - Initializes BGM, SFX, and Voice channels with their audio contexts
  /// - Wires voice-ducking hooks into BGM
  /// - (Optional) Preloads a default BGM playlist and resumes it
  ///
  /// **Params:**
  /// - [bgmTracks]: Optional list of asset paths to seed the default BGM playlist
  ///
  /// **Example:**
  /// ```dart
  /// await FiftyAudioEngine.instance.initialize([
  ///   'assets/bgm/title.mp3',
  ///   'assets/bgm/level1.mp3',
  /// ]);
  /// ```
  Future<void> initialize([List<String>? bgmTracks]) async {
    await AudioStorage.instance.initialize();
    _storage = AudioStorage.instance;

    // Initialize individual audio managers
    BgmChannel.initialize(_storage, _bgmContext);
    bgm = BgmChannel.instance;

    SfxChannel.initialize(_storage, _sfxContext);
    sfx = SfxChannel.instance;

    VoiceActingChannel.initialize(_storage, _voiceContext);
    voice = VoiceActingChannel.instance;

    // Wire voice ducking behavior to BGM
    voice.onDucking = voiceOnDucking;
    voice.onRestore = voiceOnRestore;

    if (bgmTracks != null) {
      // Optional: Initialize default BGM playlist
      await bgm.loadDefaultPlaylist(bgmTracks);
      await bgm.resumeDefaultPlaylist();
    }
  }

  /// **Mute All**
  ///
  /// Mutes BGM, SFX, and Voice channels in parallel.
  /// Useful for global pause menus or backgrounding.
  ///
  /// **Note:** Volume values are preserved; only the muted state toggles.
  Future<void> muteAll() async {
    await Future.wait([
      bgm.mute(),
      sfx.mute(),
      voice.mute(),
    ]);
  }

  /// **Unmute All**
  ///
  /// Restores audible output for BGM, SFX, and Voice in parallel.
  Future<void> unmuteAll() async {
    await Future.wait([
      bgm.unmute(),
      sfx.unmute(),
      voice.unmute(),
    ]);
  }

  /// **Stop All**
  ///
  /// Stops any currently playing media across all channels.
  /// Recommended on scene transitions or app suspends when you want
  /// silence and a clean slate.
  Future<void> stopAll() async {
    await Future.wait([
      bgm.stop(),
      sfx.stop(),
      voice.stop(),
    ]);
  }

  /// **Fade All In**
  ///
  /// Smoothly fades all channels up to their target volumes using a shared
  /// [FadePreset]. Channels that are silent remain silent.
  ///
  /// **Params:**
  /// - [preset]: Fade timing curve (default: [FadePreset.normal])
  Future<void> fadeAllIn({FadePreset preset = FadePreset.normal}) async {
    await Future.wait([
      bgm.fadeInVolume(preset),
      sfx.fadeInVolume(preset),
      voice.fadeInVolume(preset),
    ]);
  }

  /// **Fade All Out**
  ///
  /// Smoothly fades all channels down to 0.0 volume using a shared [FadePreset].
  ///
  /// **Params:**
  /// - [preset]: Fade timing curve (default: [FadePreset.fast])
  Future<void> fadeAllOut({FadePreset preset = FadePreset.fast}) async {
    await Future.wait([
      bgm.fadeOutVolume(preset),
      sfx.fadeOutVolume(preset),
      voice.fadeOutVolume(preset),
    ]);
  }

  /// **Voice Ducking Hook**
  ///
  /// Called by [VoiceActingChannel] when a voice line **starts**.
  /// Caches the current BGM volume and then reduces it to a softer level
  /// (default `0.3`) to keep narration intelligible without hard-stopping music.
  ///
  /// **Note:** Adjust the target value to taste or expose it via config.
  Future<void> voiceOnDucking() async {
    _bgmCachedVolume = bgm.volume;
    await bgm.setVolume(0.3);
  }

  /// **Voice Restore Hook**
  ///
  /// Called by [VoiceActingChannel] when a voice line **ends**.
  /// Restores BGM volume to the cached level from [voiceOnDucking].
  Future<void> voiceOnRestore() async {
    await bgm.setVolume(_bgmCachedVolume);
  }
}
