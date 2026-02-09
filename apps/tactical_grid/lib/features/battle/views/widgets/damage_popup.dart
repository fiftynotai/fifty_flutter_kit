/// Damage Popup Widget
///
/// A floating damage number that rises and fades out above the target tile.
/// Used to provide visual feedback when a unit takes damage during combat.
///
/// **Animation (800 ms total):**
/// - **Position:** Translates upward by one [tileSize] with [Curves.easeOut].
/// - **Opacity:** Starts at 1.0, fades to 0.0 in the last 40% of the
///   duration (via [Interval(0.6, 1.0)]).
/// - **Scale:** Pop-in overshoot from 0.5 to 1.3 (0-15%), settle back to
///   1.0 (15-30%), then hold at 1.0 for the remainder.
///
/// **Visual:**
/// - Text displays "-{damage}" (e.g. "-2", "-3").
/// - Uses [FiftyColors.powderBlush] with a black drop shadow for readability
///   against any tile background.
///
/// **Usage:**
/// ```dart
/// DamagePopup(
///   damage: 3,
///   tileSize: 48.0,
///   onComplete: () => removeDamageOverlay(),
/// )
/// ```
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Floating damage number that animates upward and fades out.
///
/// When inserted into the widget tree the animation starts immediately.
/// Once the 800 ms animation completes, [onComplete] is called so the
/// parent can remove the overlay.
class DamagePopup extends StatefulWidget {
  /// The damage amount to display (shown as "-{damage}").
  final int damage;

  /// Tile size in logical pixels, used to scale font size and travel distance.
  final double tileSize;

  /// Called when the animation finishes so the parent can clean up the overlay.
  final VoidCallback onComplete;

  /// Creates a [DamagePopup].
  const DamagePopup({
    required this.damage,
    required this.tileSize,
    required this.onComplete,
    super.key,
  });

  @override
  State<DamagePopup> createState() => _DamagePopupState();
}

class _DamagePopupState extends State<DamagePopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _translateY;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Translate upward by one tile size over the full duration.
    _translateY = Tween<double>(
      begin: 0,
      end: -widget.tileSize * 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Fade out in the last 40% of the animation.
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0),
      ),
    );

    // Scale: pop-in overshoot (0-15%), settle (15-30%), hold (30-100%).
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 70,
      ),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _translateY.value),
          child: Opacity(
            opacity: _opacity.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          ),
        );
      },
      child: Text(
        '-${widget.damage}',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: widget.tileSize * 0.45,
          fontWeight: FiftyTypography.extraBold,
          color: FiftyColors.powderBlush,
          shadows: const [
            Shadow(
              color: Colors.black,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}
