/// Speech-to-Text Controls Widget
///
/// Provides UI controls for STT functionality including microphone button,
/// listening status, and recognized text display.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **SpeechSttControls**
///
/// A callback-based widget for controlling speech-to-text functionality.
///
/// Provides a microphone button with listening state indicator,
/// recognized text display, and optional error handling.
///
/// **Why**
/// - Encapsulates STT control UI in a reusable, stateless widget
/// - Works with any state management solution (GetX, Provider, Bloc, etc.)
/// - Follows FDL design patterns for consistency across Fifty Flutter Kit
///
/// **Key Features**
/// - Enable/disable toggle
/// - Microphone button with pulsing animation when listening
/// - Recognized text display with clear option
/// - Error message display
/// - Availability indicator
/// - Compact mode for space-constrained layouts
///
/// **Example:**
/// ```dart
/// SpeechSttControls(
///   enabled: _sttEnabled,
///   onEnabledChanged: (value) => setState(() => _sttEnabled = value),
///   isListening: _isListening,
///   onListenPressed: () => _toggleListening(),
///   recognizedText: _recognizedText,
///   onClear: () => setState(() => _recognizedText = ''),
///   errorMessage: _errorMessage,
/// )
/// ```
class SpeechSttControls extends StatelessWidget {
  /// Creates STT controls widget.
  const SpeechSttControls({
    required this.enabled,
    required this.onEnabledChanged,
    required this.isListening,
    required this.onListenPressed,
    this.recognizedText = '',
    this.isAvailable = true,
    this.errorMessage,
    this.onClear,
    this.compact = false,
    this.showCard = true,
    this.hintText,
    super.key,
  });

  /// Whether STT is enabled.
  final bool enabled;

  /// Callback when STT enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Whether STT is currently listening.
  final bool isListening;

  /// Callback when microphone button is pressed.
  final VoidCallback onListenPressed;

  /// The text recognized from speech.
  final String recognizedText;

  /// Whether STT is available on this device.
  final bool isAvailable;

  /// Error message to display.
  final String? errorMessage;

  /// Callback when clear button is pressed.
  ///
  /// If null, clear button is hidden.
  final VoidCallback? onClear;

  /// Whether to use compact layout.
  final bool compact;

  /// Whether to wrap content in a FiftyCard.
  ///
  /// Set to false when embedding in another card.
  final bool showCard;

  /// Hint text shown below microphone button.
  ///
  /// Defaults to 'TAP TO SPEAK'.
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with toggle
        _SttHeader(
          enabled: enabled,
          onEnabledChanged: onEnabledChanged,
          isListening: isListening,
          isAvailable: isAvailable,
        ),

        // Microphone controls (only shown when enabled)
        if (enabled) ...[
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),

          // Mic button and status
          _MicrophoneSection(
            isListening: isListening,
            onPressed: isAvailable ? onListenPressed : null,
            hintText: hintText ?? 'TAP TO SPEAK',
            compact: compact,
          ),

          // Error message
          if (errorMessage != null && errorMessage!.isNotEmpty) ...[
            SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
            _ErrorDisplay(
              message: errorMessage!,
              compact: compact,
            ),
          ],

          // Recognized text
          if (recognizedText.isNotEmpty) ...[
            SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
            _RecognizedTextDisplay(
              text: recognizedText,
              onClear: onClear,
              compact: compact,
            ),
          ],
        ],

        // Not available message
        if (!isAvailable) ...[
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
          _NotAvailableMessage(compact: compact),
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

/// Header row with STT toggle and listening indicator.
class _SttHeader extends StatelessWidget {
  const _SttHeader({
    required this.enabled,
    required this.onEnabledChanged,
    required this.isListening,
    required this.isAvailable,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isListening;
  final bool isAvailable;

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
              isListening ? Icons.mic : Icons.mic_none,
              color: enabled
                  ? (isListening ? colorScheme.primary : colorScheme.onSurface)
                  : colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
            const SizedBox(width: FiftySpacing.sm),
            Text(
              'SPEECH-TO-TEXT',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FiftyTypography.semiBold,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (isListening) ...[
              const SizedBox(width: FiftySpacing.sm),
              _PulsingDot(),
            ],
          ],
        ),
        FiftySwitch(
          value: enabled,
          onChanged: isAvailable ? onEnabledChanged : null,
          size: FiftySwitchSize.small,
          enabled: isAvailable,
        ),
      ],
    );
  }
}

/// Pulsing dot indicator for listening state.
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: colorScheme.error.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.error.withValues(alpha: _animation.value * 0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Microphone button and status section.
class _MicrophoneSection extends StatelessWidget {
  const _MicrophoneSection({
    required this.isListening,
    required this.onPressed,
    required this.hintText,
    required this.compact,
  });

  final bool isListening;
  final VoidCallback? onPressed;
  final String hintText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonSize = compact ? 40.0 : 48.0;

    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: isListening
                  ? colorScheme.primary.withValues(alpha: 0.2)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isListening ? colorScheme.primary : colorScheme.outline,
                width: 2,
              ),
              boxShadow: isListening
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: isListening
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.7),
              size: compact ? 20 : 24,
            ),
          ),
        ),
        SizedBox(width: compact ? FiftySpacing.sm : FiftySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isListening ? 'LISTENING...' : hintText,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: compact ? FiftyTypography.bodySmall : FiftyTypography.bodyMedium,
                  fontWeight: FiftyTypography.semiBold,
                  color: isListening
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Display for recognized text.
class _RecognizedTextDisplay extends StatelessWidget {
  const _RecognizedTextDisplay({
    required this.text,
    required this.onClear,
    required this.compact,
  });

  final String text;
  final VoidCallback? onClear;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? FiftySpacing.sm : FiftySpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECOGNIZED:',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  fontWeight: FiftyTypography.semiBold,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: FiftyTypography.letterSpacingLabel,
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            '"$text"',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: compact ? FiftyTypography.bodySmall : FiftyTypography.bodyMedium,
              color: colorScheme.onSurface,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error message display.
class _ErrorDisplay extends StatelessWidget {
  const _ErrorDisplay({
    required this.message,
    required this.compact,
  });

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? FiftySpacing.sm : FiftySpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: compact ? 16 : 18,
            color: colorScheme.error,
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: compact ? FiftyTypography.bodySmall : FiftyTypography.bodyMedium,
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Message shown when STT is not available.
class _NotAvailableMessage extends StatelessWidget {
  const _NotAvailableMessage({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? FiftySpacing.sm : FiftySpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: compact ? 16 : 18,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              'Speech recognition not available on this device.',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: compact ? FiftyTypography.bodySmall : FiftyTypography.bodyMedium,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
