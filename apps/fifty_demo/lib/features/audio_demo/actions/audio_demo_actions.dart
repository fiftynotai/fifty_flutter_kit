/// Audio Demo Actions
///
/// Handles user interactions for the audio demo feature.
/// Connects to the actual FiftyAudioEngine through the ViewModel.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/audio_demo_view_model.dart';

/// Actions for the audio demo feature.
///
/// Provides audio playback and control actions for BGM, SFX, and Voice channels.
class AudioDemoActions {
  AudioDemoActions(this._viewModel, this._presenter);

  final AudioDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static AudioDemoActions get instance => Get.find<AudioDemoActions>();

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a BGM track is selected.
  void onTrackSelected(AudioTrack track) {
    _viewModel.selectTrack(track);
  }

  /// Called when play/pause button is tapped.
  Future<void> onToggleBgmPlayback() async {
    await _viewModel.toggleBgmPlayback();
  }

  /// Called when play button is tapped.
  Future<void> onPlayBgm() async {
    await _viewModel.playBgm();
  }

  /// Called when pause button is tapped.
  Future<void> onPauseBgm() async {
    await _viewModel.pauseBgm();
  }

  /// Called when stop button is tapped.
  Future<void> onStopBgm() async {
    await _viewModel.stopBgm();
  }

  /// Called when BGM mute is toggled.
  Future<void> onToggleBgmMute() async {
    await _viewModel.toggleBgmMute();
  }

  /// Called when BGM volume changes.
  Future<void> onBgmVolumeChanged(double volume) async {
    await _viewModel.setBgmVolume(volume);
  }

  /// Called when BGM seek slider changes.
  Future<void> onBgmSeek(double progress) async {
    await _viewModel.seekBgm(progress);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when SFX category is selected.
  void onSfxCategorySelected(SfxCategory category) {
    _viewModel.selectSfxCategory(category);
  }

  /// Called when a sound effect is triggered.
  Future<void> onPlaySfx(BuildContext context, SoundEffect sfx) async {
    await _presenter.actionHandlerWithoutLoading(
      () async {
        await _viewModel.playSfx(sfx);
      },
      context: context,
    );
  }

  /// Called when SFX mute is toggled.
  Future<void> onToggleSfxMute() async {
    await _viewModel.toggleSfxMute();
  }

  /// Called when SFX volume changes.
  Future<void> onSfxVolumeChanged(double volume) async {
    await _viewModel.setSfxVolume(volume);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a voice line is played.
  Future<void> onPlayVoiceLine(BuildContext context, VoiceLine voiceLine) async {
    await _presenter.actionHandlerWithoutLoading(
      () async {
        await _viewModel.playVoiceLine(voiceLine);
      },
      context: context,
    );
  }

  /// Called when voice playback is stopped.
  void onStopVoice() {
    _viewModel.stopVoice();
  }

  /// Called when voice mute is toggled.
  Future<void> onToggleVoiceMute() async {
    await _viewModel.toggleVoiceMute();
  }

  /// Called when voice volume changes.
  Future<void> onVoiceVolumeChanged(double volume) async {
    await _viewModel.setVoiceVolume(volume);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Master Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when master volume changes.
  Future<void> onMasterVolumeChanged(double volume) async {
    await _viewModel.setMasterVolume(volume);
  }

  /// Called when master mute is toggled.
  Future<void> onToggleMasterMute() async {
    await _viewModel.toggleMasterMute();
  }

  /// Called when reset button is tapped.
  Future<void> onResetAll() async {
    await _viewModel.resetAll();
  }
}
