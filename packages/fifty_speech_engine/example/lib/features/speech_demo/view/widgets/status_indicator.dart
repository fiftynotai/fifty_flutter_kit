/// Status indicator widget for speech state.
///
/// Displays the current state of the speech engine with
/// appropriate colors and animations.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Status indicator showing speech engine state.
///
/// Uses FDL v2 colors:
/// - Burgundy for active states (speaking, listening)
/// - Hunter green for success/ready
/// - Slate grey for idle
class StatusIndicator extends StatefulWidget {
  const StatusIndicator({
    super.key,
    required this.label,
    required this.isActive,
    this.isError = false,
  });

  /// Status label text.
  final String label;

  /// Whether the status represents an active state.
  final bool isActive;

  /// Whether there is an error.
  final bool isError;

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _indicatorColor {
    if (widget.isError) {
      return FiftyColors.warning;
    }
    if (widget.isActive) {
      return FiftyColors.burgundy;
    }
    return FiftyColors.hunterGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing indicator dot
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _indicatorColor.withValues(
                  alpha: widget.isActive ? _pulseAnimation.value : 1.0,
                ),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: _indicatorColor.withValues(
                            alpha: 0.5 * _pulseAnimation.value,
                          ),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        const SizedBox(width: FiftySpacing.sm),
        // Status label
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.medium,
            color: _indicatorColor,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
