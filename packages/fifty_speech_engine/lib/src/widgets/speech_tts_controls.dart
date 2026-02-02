/// Text-to-Speech Controls Widget
///
/// Provides UI controls for TTS settings including enable/disable toggle
/// and optional rate, pitch, and volume sliders.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **SpeechTtsControls**
///
/// A callback-based widget for controlling text-to-speech settings.
///
/// Provides a TTS enable/disable toggle with optional sliders for
/// rate, pitch, and volume adjustment.
///
/// **Why**
/// - Encapsulates TTS control UI in a reusable, stateless widget
/// - Works with any state management solution (GetX, Provider, Bloc, etc.)
/// - Follows FDL design patterns for consistency across the ecosystem
///
/// **Key Features**
/// - Enable/disable toggle
/// - Rate slider (0.5x - 2.0x)
/// - Pitch slider (0.5x - 2.0x)
/// - Volume slider (0.0 - 1.0)
/// - Compact mode for space-constrained layouts
/// - Speaking indicator
///
/// **Example:**
/// ```dart
/// SpeechTtsControls(
///   enabled: _ttsEnabled,
///   onEnabledChanged: (value) => setState(() => _ttsEnabled = value),
///   rate: _rate,
///   onRateChanged: (value) => setState(() => _rate = value),
///   pitch: _pitch,
///   onPitchChanged: (value) => setState(() => _pitch = value),
///   volume: _volume,
///   onVolumeChanged: (value) => setState(() => _volume = value),
///   isSpeaking: _isSpeaking,
/// )
/// ```
class SpeechTtsControls extends StatelessWidget {
  /// Creates TTS controls widget.
  const SpeechTtsControls({
    required this.enabled,
    required this.onEnabledChanged,
    this.rate = 1.0,
    this.onRateChanged,
    this.pitch = 1.0,
    this.onPitchChanged,
    this.volume = 1.0,
    this.onVolumeChanged,
    this.isSpeaking = false,
    this.compact = false,
    this.showCard = true,
    super.key,
  });

  /// Whether TTS is enabled.
  final bool enabled;

  /// Callback when TTS enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Current speech rate (0.5 - 2.0).
  final double rate;

  /// Callback when rate changes.
  ///
  /// If null, rate slider is hidden.
  final ValueChanged<double>? onRateChanged;

  /// Current pitch (0.5 - 2.0).
  final double pitch;

  /// Callback when pitch changes.
  ///
  /// If null, pitch slider is hidden.
  final ValueChanged<double>? onPitchChanged;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Callback when volume changes.
  ///
  /// If null, volume slider is hidden.
  final ValueChanged<double>? onVolumeChanged;

  /// Whether TTS is currently speaking.
  final bool isSpeaking;

  /// Whether to use compact layout.
  final bool compact;

  /// Whether to wrap content in a FiftyCard.
  ///
  /// Set to false when embedding in another card.
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasSliders =
        onRateChanged != null || onPitchChanged != null || onVolumeChanged != null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with toggle
        _TtsHeader(
          enabled: enabled,
          onEnabledChanged: onEnabledChanged,
          isSpeaking: isSpeaking,
        ),

        // Sliders (only shown when enabled and callbacks provided)
        if (enabled && hasSliders) ...[
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),

          // Rate slider
          if (onRateChanged != null) ...[
            _SliderRow(
              icon: Icons.speed,
              label: 'RATE',
              value: rate,
              min: 0.5,
              max: 2.0,
              onChanged: onRateChanged!,
              labelBuilder: (v) => '${v.toStringAsFixed(1)}x',
              compact: compact,
            ),
            if (onPitchChanged != null || onVolumeChanged != null)
              SizedBox(height: compact ? FiftySpacing.xs : FiftySpacing.sm),
          ],

          // Pitch slider
          if (onPitchChanged != null) ...[
            _SliderRow(
              icon: Icons.tune,
              label: 'PITCH',
              value: pitch,
              min: 0.5,
              max: 2.0,
              onChanged: onPitchChanged!,
              labelBuilder: (v) => '${v.toStringAsFixed(1)}x',
              compact: compact,
            ),
            if (onVolumeChanged != null)
              SizedBox(height: compact ? FiftySpacing.xs : FiftySpacing.sm),
          ],

          // Volume slider
          if (onVolumeChanged != null)
            _SliderRow(
              icon: Icons.volume_up,
              label: 'VOLUME',
              value: volume,
              min: 0.0,
              max: 1.0,
              onChanged: onVolumeChanged!,
              labelBuilder: (v) => '${(v * 100).round()}%',
              compact: compact,
            ),
        ],
      ],
    );

    if (!showCard) return content;

    return FiftyCard(
      padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
      scanlineOnHover: false,
      child: content,
    );
  }
}

/// Header row with TTS toggle and speaking indicator.
class _TtsHeader extends StatelessWidget {
  const _TtsHeader({
    required this.enabled,
    required this.onEnabledChanged,
    required this.isSpeaking,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSpeaking ? Icons.record_voice_over : Icons.voice_over_off,
              color: enabled
                  ? (isSpeaking ? colorScheme.primary : colorScheme.onSurface)
                  : colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
            const SizedBox(width: FiftySpacing.sm),
            Text(
              'TEXT-TO-SPEECH',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FiftyTypography.semiBold,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (isSpeaking) ...[
              const SizedBox(width: FiftySpacing.sm),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        FiftySwitch(
          value: enabled,
          onChanged: onEnabledChanged,
          size: FiftySwitchSize.small,
        ),
      ],
    );
  }
}

/// Slider row with icon and label.
class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.labelBuilder,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String Function(double) labelBuilder;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          size: compact ? 16 : 18,
        ),
        SizedBox(width: compact ? FiftySpacing.xs : FiftySpacing.sm),
        SizedBox(
          width: compact ? 48 : 60,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: compact ? FiftyTypography.bodySmall : FiftyTypography.bodyMedium,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: FiftySlider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            showLabel: true,
            labelBuilder: labelBuilder,
          ),
        ),
      ],
    );
  }
}
