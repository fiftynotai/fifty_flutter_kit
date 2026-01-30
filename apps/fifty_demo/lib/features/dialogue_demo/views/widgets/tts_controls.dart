/// TTS Controls Widget
///
/// Text-to-speech settings controls.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// TTS controls widget.
///
/// Provides TTS toggle and auto-advance settings.
class TtsControls extends StatelessWidget {
  const TtsControls({
    required this.enabled,
    required this.autoAdvance,
    required this.onToggleTts,
    required this.onToggleAutoAdvance,
    super.key,
  });

  final bool enabled;
  final bool autoAdvance;
  final VoidCallback onToggleTts;
  final VoidCallback onToggleAutoAdvance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        children: [
          // TTS Toggle
          _SettingRow(
            icon: Icons.record_voice_over,
            label: 'TEXT-TO-SPEECH',
            value: enabled,
            onToggle: onToggleTts,
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          const SizedBox(height: FiftySpacing.md),
          // Auto-advance Toggle
          _SettingRow(
            icon: Icons.fast_forward,
            label: 'AUTO-ADVANCE',
            value: autoAdvance,
            onToggle: onToggleAutoAdvance,
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onToggle,
  });

  final IconData icon;
  final String label;
  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: value
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: FiftySpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyLarge,
                color: value
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 48,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value ? colorScheme.primary : colorScheme.outline,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: value
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
