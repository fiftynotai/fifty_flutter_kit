import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **DropCountdown**
///
/// Countdown timer for sneaker drops.
///
/// Features:
/// - Days:Hours:Minutes:Seconds display
/// - Monospace digits (tabular figures)
/// - Pulse animation on final minute
/// - "SOLD OUT" or "LIVE NOW" state after expiry
///
/// **Usage:**
/// ```dart
/// DropCountdown(
///   dropTime: DateTime.now().add(Duration(days: 3)),
///   onExpired: () => print('Drop is live!'),
/// )
/// ```
class DropCountdown extends StatefulWidget {
  /// The drop release time.
  final DateTime dropTime;

  /// Callback fired when the countdown reaches zero.
  final VoidCallback? onExpired;

  /// Whether to show a compact layout. Defaults to false.
  final bool compact;

  /// Label to show when expired. Defaults to "LIVE NOW".
  final String expiredLabel;

  /// Creates a [DropCountdown] with the specified parameters.
  const DropCountdown({
    required this.dropTime,
    this.onExpired,
    this.compact = false,
    this.expiredLabel = 'LIVE NOW',
    super.key,
  });

  @override
  State<DropCountdown> createState() => _DropCountdownState();
}

class _DropCountdownState extends State<DropCountdown>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isExpired = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    _calculateRemaining();
    _startTimer();
  }

  @override
  void didUpdateWidget(DropCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dropTime != oldWidget.dropTime) {
      _calculateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    final difference = widget.dropTime.difference(now);

    setState(() {
      if (difference.isNegative) {
        _remaining = Duration.zero;
        _isExpired = true;
      } else {
        _remaining = difference;
        _isExpired = false;
      }
    });

    // Start pulse animation in final minute
    if (!_isExpired && _remaining.inMinutes < 1) {
      _pulseController.repeat(reverse: true);
    } else if (_pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
      if (_isExpired) {
        _timer?.cancel();
        widget.onExpired?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isExpired) {
      return _buildExpiredState();
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    final isUrgent = _remaining.inMinutes < 1;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isUrgent ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: widget.compact
          ? _buildCompactLayout(days, hours, minutes, seconds, isUrgent)
          : _buildFullLayout(days, hours, minutes, seconds, isUrgent),
    );
  }

  Widget _buildExpiredState() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? SneakerSpacing.md : SneakerSpacing.lg,
        vertical: widget.compact ? SneakerSpacing.sm : SneakerSpacing.md,
      ),
      decoration: BoxDecoration(
        color: SneakerColors.hunterGreen,
        borderRadius: SneakerRadii.badge,
      ),
      child: Text(
        widget.expiredLabel,
        style: TextStyle(
          fontFamily: SneakerTypography.fontFamily,
          fontSize: widget.compact ? 10 : 12,
          fontWeight: SneakerTypography.bold,
          letterSpacing: 1.5,
          color: SneakerColors.cream,
        ),
      ),
    );
  }

  Widget _buildCompactLayout(
    int days,
    int hours,
    int minutes,
    int seconds,
    bool isUrgent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SneakerSpacing.md,
        vertical: SneakerSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isUrgent
            ? SneakerColors.burgundy.withValues(alpha: 0.3)
            : SneakerColors.darkBurgundy.withValues(alpha: 0.8),
        borderRadius: SneakerRadii.badge,
        border: Border.all(
          color: isUrgent
              ? SneakerColors.burgundy
              : SneakerColors.border,
        ),
      ),
      child: Text(
        _formatCompact(days, hours, minutes, seconds),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: SneakerTypography.bold,
          letterSpacing: 0.5,
          color: isUrgent ? SneakerColors.powderBlush : SneakerColors.cream,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _buildFullLayout(
    int days,
    int hours,
    int minutes,
    int seconds,
    bool isUrgent,
  ) {
    return Container(
      padding: const EdgeInsets.all(SneakerSpacing.lg),
      decoration: BoxDecoration(
        color: SneakerColors.darkBurgundy.withValues(alpha: 0.8),
        borderRadius: SneakerRadii.radiusLg,
        border: Border.all(
          color: isUrgent
              ? SneakerColors.burgundy
              : SneakerColors.border,
          width: isUrgent ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (days > 0) ...[
            _buildTimeUnit(days, 'D', isUrgent),
            _buildSeparator(isUrgent),
          ],
          _buildTimeUnit(hours, 'H', isUrgent),
          _buildSeparator(isUrgent),
          _buildTimeUnit(minutes, 'M', isUrgent),
          _buildSeparator(isUrgent),
          _buildTimeUnit(seconds, 'S', isUrgent),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label, bool isUrgent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedDefaultTextStyle(
          duration: SneakerAnimations.fast,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 24,
            fontWeight: SneakerTypography.extraBold,
            color: isUrgent ? SneakerColors.powderBlush : SneakerColors.cream,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          child: Text(value.toString().padLeft(2, '0')),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 10,
            fontWeight: SneakerTypography.semiBold,
            letterSpacing: 1,
            color: SneakerColors.slateGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparator(bool isUrgent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SneakerSpacing.sm),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 24,
          fontWeight: SneakerTypography.extraBold,
          color: isUrgent
              ? SneakerColors.powderBlush.withValues(alpha: 0.5)
              : SneakerColors.slateGrey,
        ),
      ),
    );
  }

  String _formatCompact(int days, int hours, int minutes, int seconds) {
    if (days > 0) {
      return '${days}d ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
