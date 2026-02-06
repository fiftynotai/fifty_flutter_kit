import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/order_model.dart';

/// **OrderConfirmation**
///
/// Success celebration widget displayed after order placement.
///
/// Features:
/// - Animated checkmark icon
/// - Confetti burst animation
/// - Order number display
/// - Order summary
/// - "Continue Shopping" button
///
/// **Example Usage:**
/// ```dart
/// OrderConfirmation(
///   order: completedOrder,
///   onContinueShopping: () => navigateToCatalog(),
/// )
/// ```
class OrderConfirmation extends StatefulWidget {
  /// The completed order.
  final OrderModel order;

  /// Callback when continue shopping button is pressed.
  final VoidCallback onContinueShopping;

  /// Callback when view order button is pressed.
  final VoidCallback? onViewOrder;

  /// Creates an [OrderConfirmation] widget.
  const OrderConfirmation({
    required this.order,
    required this.onContinueShopping,
    this.onViewOrder,
    super.key,
  });

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late AnimationController _contentController;

  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    // Check animation
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _checkScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_checkController);

    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Content animation
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOut,
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) _checkController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _confettiController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _contentController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: SneakerSpacing.allXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti and check mark
            SizedBox(
              height: 160,
              width: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Confetti
                  _ConfettiEffect(
                    animation: _confettiController,
                  ),

                  // Check circle
                  AnimatedBuilder(
                    animation: _checkController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _checkOpacity.value,
                        child: Transform.scale(
                          scale: _checkScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SneakerColors.grailGradient,
                        boxShadow: [
                          BoxShadow(
                            color: SneakerColors.burgundy.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 48,
                        color: SneakerColors.cream,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SneakerSpacing.xxl),

            // Content
            SlideTransition(
              position: _contentSlide,
              child: FadeTransition(
                opacity: _contentOpacity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success message
                    Text(
                      'ORDER CONFIRMED',
                      style: SneakerTypography.sectionTitle.copyWith(
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SneakerSpacing.md),

                    Text(
                      'Thank you for your purchase!',
                      style: SneakerTypography.body.copyWith(
                        color: SneakerColors.slateGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SneakerSpacing.xxxl),

                    // Order details card
                    _buildOrderCard(),
                    const SizedBox(height: SneakerSpacing.xxxl),

                    // Actions
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: SneakerSpacing.allLg,
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusLg,
        border: Border.all(color: SneakerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ORDER NUMBER',
                style: TextStyle(
                  fontFamily: SneakerTypography.fontFamily,
                  fontSize: 10,
                  fontWeight: SneakerTypography.semiBold,
                  letterSpacing: 1.5,
                  color: SneakerColors.slateGrey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: SneakerColors.burgundy.withValues(alpha: 0.2),
                  borderRadius: SneakerRadii.radiusSm,
                ),
                child: Text(
                  widget.order.id,
                  style: TextStyle(
                    fontFamily: SneakerTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: SneakerTypography.bold,
                    color: SneakerColors.cream,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SneakerSpacing.lg),
          Divider(color: SneakerColors.border, height: 1),
          const SizedBox(height: SneakerSpacing.lg),

          // Order summary
          _buildSummaryRow('Items', '${widget.order.itemCount}'),
          const SizedBox(height: SneakerSpacing.sm),
          _buildSummaryRow(
            'Subtotal',
            '\$${widget.order.subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: SneakerSpacing.sm),
          _buildSummaryRow(
            'Shipping',
            widget.order.shipping == 0
                ? 'FREE'
                : '\$${widget.order.shipping.toStringAsFixed(2)}',
            valueColor: widget.order.shipping == 0
                ? SneakerColors.hunterGreen
                : null,
          ),
          const SizedBox(height: SneakerSpacing.sm),
          _buildSummaryRow(
            'Tax',
            '\$${widget.order.tax.toStringAsFixed(2)}',
          ),
          const SizedBox(height: SneakerSpacing.lg),
          Divider(color: SneakerColors.border, height: 1),
          const SizedBox(height: SneakerSpacing.lg),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: SneakerTypography.cardTitle,
              ),
              Text(
                '\$${widget.order.total.toStringAsFixed(2)}',
                style: SneakerTypography.sectionTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: SneakerTypography.description.copyWith(
            color: SneakerColors.slateGrey,
          ),
        ),
        Text(
          value,
          style: SneakerTypography.description.copyWith(
            color: valueColor ?? SneakerColors.cream,
            fontWeight: SneakerTypography.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        // Continue shopping (primary)
        _ActionButton(
          label: 'CONTINUE SHOPPING',
          onPressed: widget.onContinueShopping,
          isPrimary: true,
        ),

        if (widget.onViewOrder != null) ...[
          const SizedBox(height: SneakerSpacing.md),
          // View order (secondary)
          _ActionButton(
            label: 'VIEW ORDER DETAILS',
            onPressed: widget.onViewOrder!,
            isPrimary: false,
          ),
        ],
      ],
    );
  }
}

/// Internal action button widget.
class _ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 300),
          padding: SneakerSpacing.allLg,
          decoration: BoxDecoration(
            gradient: widget.isPrimary ? SneakerColors.grailGradient : null,
            color: widget.isPrimary ? null : Colors.transparent,
            borderRadius: SneakerRadii.radiusMd,
            border: widget.isPrimary
                ? null
                : Border.all(color: SneakerColors.burgundy),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: SneakerColors.burgundy.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: SneakerTypography.label.copyWith(
              color: widget.isPrimary
                  ? SneakerColors.cream
                  : SneakerColors.burgundy,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Internal confetti effect widget.
class _ConfettiEffect extends StatelessWidget {
  final AnimationController animation;

  const _ConfettiEffect({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(160, 160),
          painter: _ConfettiPainter(
            progress: animation.value,
          ),
        );
      },
    );
  }
}

/// Custom painter for confetti particles.
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles;

  _ConfettiPainter({required this.progress})
      : _particles = _generateParticles();

  static List<_Particle> _generateParticles() {
    final random = math.Random(42); // Fixed seed for consistency
    return List.generate(20, (index) {
      return _Particle(
        angle: random.nextDouble() * 2 * math.pi,
        speed: 60 + random.nextDouble() * 40,
        color: [
          SneakerColors.burgundy,
          SneakerColors.powderBlush,
          SneakerColors.cream,
          SneakerColors.hunterGreen,
        ][index % 4],
        size: 4 + random.nextDouble() * 4,
        rotationSpeed: (random.nextDouble() - 0.5) * 4,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in _particles) {
      final distance = particle.speed * progress;
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final x = center.dx + math.cos(particle.angle) * distance;
      final y = center.dy + math.sin(particle.angle) * distance - 20 * progress;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotationSpeed * progress * math.pi);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Internal particle data class.
class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotationSpeed;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotationSpeed,
  });
}
