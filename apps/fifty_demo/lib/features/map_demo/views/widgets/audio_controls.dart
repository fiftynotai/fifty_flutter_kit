/// Audio Controls Widget
///
/// BGM and SFX control buttons for map demo.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Audio controls widget.
///
/// Provides BGM and SFX toggle and playback controls.
class AudioControlsWidget extends StatelessWidget {
  const AudioControlsWidget({
    required this.bgmEnabled,
    required this.sfxEnabled,
    required this.bgmPlaying,
    required this.onPlayBgm,
    required this.onStopBgm,
    required this.onToggleBgm,
    required this.onToggleSfx,
    required this.onTestSfx,
    super.key,
  });

  final bool bgmEnabled;
  final bool sfxEnabled;
  final bool bgmPlaying;
  final VoidCallback onPlayBgm;
  final VoidCallback onStopBgm;
  final VoidCallback onToggleBgm;
  final VoidCallback onToggleSfx;
  final VoidCallback onTestSfx;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BGM Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: bgmEnabled
                        ? FiftyColors.crimsonPulse
                        : FiftyColors.hyperChrome,
                    size: 20,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    'BGM',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: bgmEnabled
                          ? FiftyColors.terminalWhite
                          : FiftyColors.hyperChrome,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    bgmPlaying ? '[PLAYING]' : '[STOPPED]',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.mono,
                      color: bgmPlaying
                          ? FiftyColors.igrisGreen
                          : FiftyColors.hyperChrome,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  FiftyButton(
                    label: bgmPlaying ? 'STOP' : 'PLAY',
                    onPressed: bgmPlaying ? onStopBgm : onPlayBgm,
                    variant: FiftyButtonVariant.secondary,
                    size: FiftyButtonSize.small,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  GestureDetector(
                    onTap: onToggleBgm,
                    child: Container(
                      padding: const EdgeInsets.all(FiftySpacing.xs),
                      decoration: BoxDecoration(
                        color: bgmEnabled
                            ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: bgmEnabled
                              ? FiftyColors.crimsonPulse
                              : FiftyColors.border,
                        ),
                      ),
                      child: Icon(
                        bgmEnabled ? Icons.volume_up : Icons.volume_off,
                        size: 16,
                        color: bgmEnabled
                            ? FiftyColors.crimsonPulse
                            : FiftyColors.hyperChrome,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: FiftyColors.border),
          const SizedBox(height: FiftySpacing.md),
          // SFX Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.speaker,
                    color: sfxEnabled
                        ? FiftyColors.crimsonPulse
                        : FiftyColors.hyperChrome,
                    size: 20,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    'SFX',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: sfxEnabled
                          ? FiftyColors.terminalWhite
                          : FiftyColors.hyperChrome,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    sfxEnabled ? '[ENABLED]' : '[DISABLED]',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.mono,
                      color: sfxEnabled
                          ? FiftyColors.igrisGreen
                          : FiftyColors.hyperChrome,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  FiftyButton(
                    label: 'TEST',
                    onPressed: onTestSfx,
                    variant: FiftyButtonVariant.secondary,
                    size: FiftyButtonSize.small,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  GestureDetector(
                    onTap: onToggleSfx,
                    child: Container(
                      padding: const EdgeInsets.all(FiftySpacing.xs),
                      decoration: BoxDecoration(
                        color: sfxEnabled
                            ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: sfxEnabled
                              ? FiftyColors.crimsonPulse
                              : FiftyColors.border,
                        ),
                      ),
                      child: Icon(
                        sfxEnabled ? Icons.volume_up : Icons.volume_off,
                        size: 16,
                        color: sfxEnabled
                            ? FiftyColors.crimsonPulse
                            : FiftyColors.hyperChrome,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
