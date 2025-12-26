import 'dart:async';

import 'package:flutter/widgets.dart';

import 'base_audio_channel.dart';
import 'fade_preset.dart';

/// Action to apply when the app goes to background.
enum ChannelBackgroundAction {
  /// Do nothing.
  none,

  /// Pause playback (recommended for BGM/Voice).
  pause,

  /// Mute audio (keeps playback state; useful for continuous streams).
  mute,

  /// Stop playback completely.
  stop,
}

/// Lifecycle configuration per channel.
class ChannelLifecycleConfig {
  /// What to do when the app is backgrounded (paused/inactive/hidden).
  final ChannelBackgroundAction onBackground;

  /// Whether to resume on foreground if we paused.
  final bool resumeOnForeground;

  /// Whether to unmute on foreground if we muted.
  final bool unmuteOnForeground;

  /// Fade on background (applies before pause/mute/stop).
  final bool fadeOnBackground;

  /// Fade on foreground (applies after resume/unmute).
  final bool fadeOnForeground;

  /// Fade presets.
  final FadePreset fadeOutPreset;
  final FadePreset fadeInPreset;

  /// Stop on detached (app is being destroyed).
  final bool stopOnDetached;

  const ChannelLifecycleConfig({
    this.onBackground = ChannelBackgroundAction.pause,
    this.resumeOnForeground = true,
    this.unmuteOnForeground = true,
    this.fadeOnBackground = true,
    this.fadeOnForeground = true,
    this.fadeOutPreset = FadePreset.fast,
    this.fadeInPreset = FadePreset.normal,
    this.stopOnDetached = false,
  });
}

class ChannelLifecycleObserver extends WidgetsBindingObserver {
  final BaseAudioChannel channel;
  final ChannelLifecycleConfig cfg;
  bool _pausedByLifecycle = false;
  bool _mutedByLifecycle = false;

  ChannelLifecycleObserver(this.channel, this.cfg);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Fire-and-forget; sequencing matters for fades, so we await internally.
    unawaited(_handle(state));
  }

  Future<void> _handle(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      // Backgrounding: apply configured action.
        switch (cfg.onBackground) {
          case ChannelBackgroundAction.none:
            break;

          case ChannelBackgroundAction.pause:
            if (channel.isPlaying) {
              if (cfg.fadeOnBackground) {
                await channel.fadeOutVolume(cfg.fadeOutPreset);
              }
              await channel.pause();
              _pausedByLifecycle = true;
            }
            break;

          case ChannelBackgroundAction.mute:
            if (!channel.isMuted) {
              if (cfg.fadeOnBackground) {
                await channel.fadeOutVolume(cfg.fadeOutPreset);
              }
              await channel.mute();
              _mutedByLifecycle = true;
            }
            break;

          case ChannelBackgroundAction.stop:
            if (cfg.fadeOnBackground && channel.isPlaying) {
              await channel.fadeOutVolume(cfg.fadeOutPreset);
            }
            await channel.stop();
            _pausedByLifecycle = false;
            _mutedByLifecycle = false;
            break;
        }
        break;

      case AppLifecycleState.resumed:
      // Foregrounding: undo our action if requested.
        if (cfg.resumeOnForeground && _pausedByLifecycle) {
          await channel.resume();
          if (cfg.fadeOnForeground) {
            await channel.fadeInVolume(cfg.fadeInPreset);
          }
          _pausedByLifecycle = false;
        }
        if (cfg.unmuteOnForeground && _mutedByLifecycle) {
          await channel.unmute();
          if (cfg.fadeOnForeground) {
            await channel.fadeInVolume(cfg.fadeInPreset);
          }
          _mutedByLifecycle = false;
        }
        break;

      case AppLifecycleState.detached:
        if (cfg.stopOnDetached) {
          await channel.stop();
        }
        break;
    }
  }
}
