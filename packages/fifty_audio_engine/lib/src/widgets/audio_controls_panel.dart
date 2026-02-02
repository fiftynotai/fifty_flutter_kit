/// Audio Controls Panel Widget
///
/// A callback-based panel for controlling BGM and SFX audio channels.
/// Part of the Fifty Audio Engine package.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **AudioControlsPanel**
///
/// A reusable panel widget for controlling background music (BGM) and
/// sound effects (SFX) in applications using the Fifty Audio Engine.
///
/// **Why**
/// - Provides a consistent UI for audio settings across applications
/// - Callback-based API allows integration with any state management solution
/// - Follows Fifty Design Language (FDL) for visual consistency
///
/// **Key Features**
/// - BGM controls: play/stop, enable/disable toggle
/// - SFX controls: test sound, enable/disable toggle
/// - Optional volume sliders for BGM and SFX
/// - Optional title header
/// - Compact mode for space-constrained layouts
///
/// **Example Usage**
/// ```dart
/// AudioControlsPanel(
///   bgmEnabled: audioViewModel.bgmEnabled,
///   bgmPlaying: audioViewModel.bgmPlaying,
///   sfxEnabled: audioViewModel.sfxEnabled,
///   onPlayBgm: () => audioViewModel.playBgm(),
///   onStopBgm: () => audioViewModel.stopBgm(),
///   onToggleBgm: () => audioViewModel.toggleBgm(),
///   onToggleSfx: () => audioViewModel.toggleSfx(),
///   onTestSfx: () => audioViewModel.testSfx(),
/// )
/// ```
///
/// **With Volume Controls**
/// ```dart
/// AudioControlsPanel(
///   bgmEnabled: true,
///   bgmPlaying: false,
///   sfxEnabled: true,
///   bgmVolume: 0.8,
///   sfxVolume: 1.0,
///   onPlayBgm: () {},
///   onStopBgm: () {},
///   onToggleBgm: () {},
///   onToggleSfx: () {},
///   onTestSfx: () {},
///   onBgmVolumeChanged: (v) => setBgmVolume(v),
///   onSfxVolumeChanged: (v) => setSfxVolume(v),
/// )
/// ```
class AudioControlsPanel extends StatelessWidget {
  /// Creates an audio controls panel.
  ///
  /// Required parameters:
  /// - [bgmEnabled]: Whether background music is enabled
  /// - [bgmPlaying]: Whether background music is currently playing
  /// - [sfxEnabled]: Whether sound effects are enabled
  /// - [onPlayBgm]: Callback to play background music
  /// - [onStopBgm]: Callback to stop background music
  /// - [onToggleBgm]: Callback to toggle background music enabled state
  /// - [onToggleSfx]: Callback to toggle sound effects enabled state
  /// - [onTestSfx]: Callback to play a test sound effect
  const AudioControlsPanel({
    required this.bgmEnabled,
    required this.bgmPlaying,
    required this.sfxEnabled,
    required this.onPlayBgm,
    required this.onStopBgm,
    required this.onToggleBgm,
    required this.onToggleSfx,
    required this.onTestSfx,
    this.title,
    this.bgmVolume,
    this.sfxVolume,
    this.onBgmVolumeChanged,
    this.onSfxVolumeChanged,
    this.compact = false,
    this.showCard = true,
    super.key,
  });

  /// Whether background music is enabled.
  final bool bgmEnabled;

  /// Whether background music is currently playing.
  final bool bgmPlaying;

  /// Whether sound effects are enabled.
  final bool sfxEnabled;

  /// Callback invoked when play BGM is requested.
  final VoidCallback onPlayBgm;

  /// Callback invoked when stop BGM is requested.
  final VoidCallback onStopBgm;

  /// Callback invoked when BGM enabled state should be toggled.
  final VoidCallback onToggleBgm;

  /// Callback invoked when SFX enabled state should be toggled.
  final VoidCallback onToggleSfx;

  /// Callback invoked when a test sound effect should be played.
  final VoidCallback onTestSfx;

  /// Optional title displayed at the top of the panel.
  ///
  /// If null, no title header is shown.
  final String? title;

  /// Current BGM volume level (0.0 to 1.0).
  ///
  /// If provided along with [onBgmVolumeChanged], a volume slider is shown.
  final double? bgmVolume;

  /// Current SFX volume level (0.0 to 1.0).
  ///
  /// If provided along with [onSfxVolumeChanged], a volume slider is shown.
  final double? sfxVolume;

  /// Callback invoked when BGM volume is changed via slider.
  ///
  /// If null, no BGM volume slider is shown.
  final ValueChanged<double>? onBgmVolumeChanged;

  /// Callback invoked when SFX volume is changed via slider.
  ///
  /// If null, no SFX volume slider is shown.
  final ValueChanged<double>? onSfxVolumeChanged;

  /// Whether to use compact layout with reduced spacing.
  ///
  /// Defaults to false.
  final bool compact;

  /// Whether to wrap the content in a FiftyCard.
  ///
  /// Defaults to true. Set to false when embedding in another card.
  final bool showCard;

  bool get _showBgmVolumeSlider =>
      bgmVolume != null && onBgmVolumeChanged != null;

  bool get _showSfxVolumeSlider =>
      sfxVolume != null && onSfxVolumeChanged != null;

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    if (!showCard) {
      return content;
    }

    return FiftyCard(
      padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
      scanlineOnHover: false,
      child: content,
    );
  }

  Widget _buildContent(BuildContext context) {
    final spacing = compact ? FiftySpacing.sm : FiftySpacing.md;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional title
        if (title != null) ...[
          _buildTitle(context),
          SizedBox(height: spacing),
          _buildDivider(context),
          SizedBox(height: spacing),
        ],
        // BGM Row
        _buildBgmRow(context),
        // BGM Volume Slider
        if (_showBgmVolumeSlider) ...[
          SizedBox(height: spacing),
          _buildVolumeSlider(
            context,
            value: bgmVolume!,
            onChanged: onBgmVolumeChanged!,
            enabled: bgmEnabled,
          ),
        ],
        SizedBox(height: spacing),
        _buildDivider(context),
        SizedBox(height: spacing),
        // SFX Row
        _buildSfxRow(context),
        // SFX Volume Slider
        if (_showSfxVolumeSlider) ...[
          SizedBox(height: spacing),
          _buildVolumeSlider(
            context,
            value: sfxVolume!,
            onChanged: onSfxVolumeChanged!,
            enabled: sfxEnabled,
          ),
        ],
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title!.toUpperCase(),
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
        color: colorScheme.onSurface,
        letterSpacing: FiftyTypography.letterSpacingLabel,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(height: 1, color: colorScheme.outline);
  }

  Widget _buildBgmRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BGM Label with status
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.music_note,
                color: bgmEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                size: compact ? 18 : 20,
              ),
              SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
              Text(
                'BGM',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: bgmEnabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
              Text(
                bgmPlaying ? '[PLAYING]' : '[STOPPED]',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: bgmPlaying
                      ? successColor
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        // BGM Controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyButton(
              label: bgmPlaying ? 'STOP' : 'PLAY',
              onPressed: bgmPlaying ? onStopBgm : onPlayBgm,
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
            SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
            _buildToggleButton(
              context,
              enabled: bgmEnabled,
              onTap: onToggleBgm,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSfxRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // SFX Label with status
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.speaker,
                color: sfxEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                size: compact ? 18 : 20,
              ),
              SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
              Text(
                'SFX',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: sfxEnabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
              Text(
                sfxEnabled ? '[ENABLED]' : '[DISABLED]',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: sfxEnabled
                      ? successColor
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        // SFX Controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyButton(
              label: 'TEST',
              onPressed: onTestSfx,
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
            SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
            _buildToggleButton(
              context,
              enabled: sfxEnabled,
              onTap: onToggleSfx,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = compact ? 14.0 : 16.0;
    final padding = compact ? FiftySpacing.xs : FiftySpacing.xs;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: enabled
              ? colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: FiftyRadii.smRadius,
          border: Border.all(
            color: enabled ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Icon(
          enabled ? Icons.volume_up : Icons.volume_off,
          size: size,
          color: enabled
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(
    BuildContext context, {
    required double value,
    required ValueChanged<double> onChanged,
    required bool enabled,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          Icons.volume_down,
          size: compact ? 14 : 16,
          color: enabled
              ? colorScheme.onSurface.withValues(alpha: 0.7)
              : colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor:
                  enabled ? colorScheme.primary : colorScheme.outline,
              inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.3),
              thumbColor:
                  enabled ? colorScheme.primary : colorScheme.onSurface,
              overlayColor: colorScheme.primary.withValues(alpha: 0.2),
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: compact ? 6 : 8,
              ),
            ),
            child: Slider(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
        Icon(
          Icons.volume_up,
          size: compact ? 14 : 16,
          color: enabled
              ? colorScheme.onSurface.withValues(alpha: 0.7)
              : colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
