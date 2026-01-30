/// Audio Demo Actions
///
/// Handles user interactions for the audio demo feature.
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
  void onToggleBgmPlayback() {
    _viewModel.toggleBgmPlayback();
  }

  /// Called when play button is tapped.
  void onPlayBgm() {
    _viewModel.playBgm();
  }

  /// Called when pause button is tapped.
  void onPauseBgm() {
    _viewModel.pauseBgm();
  }

  /// Called when stop button is tapped.
  void onStopBgm() {
    _viewModel.stopBgm();
  }

  /// Called when BGM mute is toggled.
  void onToggleBgmMute() {
    _viewModel.toggleBgmMute();
  }

  /// Called when BGM volume changes.
  void onBgmVolumeChanged(double volume) {
    _viewModel.setBgmVolume(volume);
  }

  /// Called when BGM seek slider changes.
  void onBgmSeek(double progress) {
    _viewModel.seekBgm(progress);
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
        _viewModel.playSfx(sfx);
      },
      context: context,
    );
  }

  /// Called when SFX mute is toggled.
  void onToggleSfxMute() {
    _viewModel.toggleSfxMute();
  }

  /// Called when SFX volume changes.
  void onSfxVolumeChanged(double volume) {
    _viewModel.setSfxVolume(volume);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a voice line is played.
  Future<void> onPlayVoiceLine(BuildContext context, String line) async {
    await _presenter.actionHandlerWithoutLoading(
      () async {
        _viewModel.playVoiceLine(line);
      },
      context: context,
    );
  }

  /// Called when voice playback is stopped.
  void onStopVoice() {
    _viewModel.stopVoice();
  }

  /// Called when voice mute is toggled.
  void onToggleVoiceMute() {
    _viewModel.toggleVoiceMute();
  }

  /// Called when voice volume changes.
  void onVoiceVolumeChanged(double volume) {
    _viewModel.setVoiceVolume(volume);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Master Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when master volume changes.
  void onMasterVolumeChanged(double volume) {
    _viewModel.setMasterVolume(volume);
  }

  /// Called when master mute is toggled.
  void onToggleMasterMute() {
    _viewModel.toggleMasterMute();
  }

  /// Called when reset button is tapped.
  void onResetAll() {
    _viewModel.resetAll();
  }
}
