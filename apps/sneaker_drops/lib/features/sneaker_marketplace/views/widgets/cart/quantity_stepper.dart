import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **QuantityStepper**
///
/// Quantity selector with +/- buttons for cart items.
///
/// Features:
/// - Minimum quantity: 1 (configurable)
/// - Maximum quantity: 10 (configurable)
/// - Animated value change with scale effect
/// - Disabled state for min/max boundaries
/// - Accessible button labels
///
/// **Example Usage:**
/// ```dart
/// QuantityStepper(
///   quantity: 2,
///   min: 1,
///   max: 10,
///   onChanged: (newQty) => updateQuantity(newQty),
/// )
/// ```
class QuantityStepper extends StatefulWidget {
  /// Creates a quantity stepper widget.
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 10,
  });

  /// Current quantity value.
  final int quantity;

  /// Minimum allowed quantity.
  final int min;

  /// Maximum allowed quantity.
  final int max;

  /// Callback when quantity changes.
  final ValueChanged<int> onChanged;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: SneakerAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: SneakerAnimations.bounce,
      ),
    );
  }

  @override
  void didUpdateWidget(QuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _decrement() {
    if (widget.quantity > widget.min) {
      widget.onChanged(widget.quantity - 1);
    }
  }

  void _increment() {
    if (widget.quantity < widget.max) {
      widget.onChanged(widget.quantity + 1);
    }
  }

  bool get _canDecrement => widget.quantity > widget.min;
  bool get _canIncrement => widget.quantity < widget.max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusMd,
        border: Border.all(
          color: SneakerColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: _canDecrement ? _decrement : null,
            enabled: _canDecrement,
            semanticLabel: 'Decrease quantity',
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Text(
                  widget.quantity.toString(),
                  style: SneakerTypography.price.copyWith(
                    fontWeight: SneakerTypography.bold,
                  ),
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: _canIncrement ? _increment : null,
            enabled: _canIncrement,
            semanticLabel: 'Increase quantity',
          ),
        ],
      ),
    );
  }
}

/// Internal stepper button widget.
class _StepperButton extends StatefulWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final String semanticLabel;

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.enabled,
      child: GestureDetector(
        onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          padding: SneakerSpacing.allSm,
          decoration: BoxDecoration(
            color: _isPressed
                ? SneakerColors.burgundy.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: SneakerRadii.radiusSm,
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.enabled
                ? SneakerColors.cream
                : SneakerColors.slateGrey.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
