import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animation_constants.dart';

/// **AddToCartAnimation**
///
/// Flying arc animation from product to cart icon.
/// Creates a satisfying feedback when adding items to cart.
///
/// **Specs from design doc:**
/// - Duration: 300ms
/// - Curve: Curves.easeOut
/// - Bezier trajectory with control point 100px above
/// - Scale: 1.0 -> 0.3
/// - Opacity: 1.0 -> 0.0 in last 20%
///
/// **Usage:**
/// ```dart
/// // In your page state
/// final _cartAnimationKey = GlobalKey<AddToCartOverlayState>();
///
/// // In your build
/// Stack(
///   children: [
///     // Page content...
///     AddToCartOverlay(key: _cartAnimationKey),
///   ],
/// )
///
/// // When adding to cart
/// void onAddToCart(GlobalKey productKey, GlobalKey cartKey, String imageUrl) {
///   final productBox = productKey.currentContext?.findRenderObject() as RenderBox?;
///   final cartBox = cartKey.currentContext?.findRenderObject() as RenderBox?;
///
///   if (productBox != null && cartBox != null) {
///     final startPos = productBox.localToGlobal(Offset.zero);
///     final endPos = cartBox.localToGlobal(Offset.zero);
///
///     _cartAnimationKey.currentState?.trigger(
///       startPosition: startPos,
///       endPosition: endPos,
///       imageUrl: imageUrl,
///     );
///   }
/// }
/// ```
class AddToCartOverlay extends StatefulWidget {
  const AddToCartOverlay({super.key});

  @override
  State<AddToCartOverlay> createState() => AddToCartOverlayState();
}

class AddToCartOverlayState extends State<AddToCartOverlay> {
  final List<_FlyingItem> _items = [];

  /// Trigger the add to cart animation.
  ///
  /// [startPosition] - Global position of the product image
  /// [endPosition] - Global position of the cart icon
  /// [imageUrl] - URL of the product image (optional)
  /// [imageWidget] - Custom widget to animate (optional, takes precedence over imageUrl)
  /// [onComplete] - Callback when animation completes
  void trigger({
    required Offset startPosition,
    required Offset endPosition,
    String? imageUrl,
    Widget? imageWidget,
    VoidCallback? onComplete,
  }) {
    final reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (reduceMotion) {
      // Skip animation, just call completion
      onComplete?.call();
      return;
    }

    setState(() {
      _items.add(_FlyingItem(
        id: DateTime.now().millisecondsSinceEpoch,
        startPosition: startPosition,
        endPosition: endPosition,
        imageUrl: imageUrl,
        imageWidget: imageWidget,
        onComplete: () {
          onComplete?.call();
          setState(() {
            _items.removeWhere(
              (item) => item.id == DateTime.now().millisecondsSinceEpoch,
            );
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: _items.map((item) => _FlyingItemWidget(item: item)).toList(),
      ),
    );
  }
}

class _FlyingItem {
  final int id;
  final Offset startPosition;
  final Offset endPosition;
  final String? imageUrl;
  final Widget? imageWidget;
  final VoidCallback? onComplete;

  _FlyingItem({
    required this.id,
    required this.startPosition,
    required this.endPosition,
    this.imageUrl,
    this.imageWidget,
    this.onComplete,
  });
}

class _FlyingItemWidget extends StatefulWidget {
  final _FlyingItem item;

  const _FlyingItemWidget({required this.item});

  @override
  State<_FlyingItemWidget> createState() => _FlyingItemWidgetState();
}

class _FlyingItemWidgetState extends State<_FlyingItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: SneakerAnimations.addToCart,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SneakerAnimations.standard,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: SneakerAnimations.addToCartEndScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SneakerAnimations.standard,
    ));

    // Opacity fades out in the last 20%
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward().then((_) {
      widget.item.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calculate position along a quadratic bezier curve.
  Offset _calculateBezierPosition(double t) {
    final start = widget.item.startPosition;
    final end = widget.item.endPosition;

    // Control point is above the midpoint
    final midX = (start.dx + end.dx) / 2;
    final midY = math.min(start.dy, end.dy) -
        SneakerAnimations.addToCartControlHeight;
    final control = Offset(midX, midY);

    // Quadratic bezier formula: B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
    final oneMinusT = 1 - t;
    final x = oneMinusT * oneMinusT * start.dx +
        2 * oneMinusT * t * control.dx +
        t * t * end.dx;
    final y = oneMinusT * oneMinusT * start.dy +
        2 * oneMinusT * t * control.dy +
        t * t * end.dy;

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final position = _calculateBezierPosition(_progressAnimation.value);

        return Positioned(
          left: position.dx,
          top: position.dy,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (widget.item.imageWidget != null) {
      return SizedBox(
        width: 60,
        height: 60,
        child: widget.item.imageWidget,
      );
    }

    if (widget.item.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.item.imageUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white54,
        size: 24,
      ),
    );
  }
}

/// **AddToCartAnimationController**
///
/// Static controller for triggering add to cart animations from anywhere.
/// Requires an AddToCartOverlay to be present in the widget tree.
///
/// **Usage:**
/// ```dart
/// // Setup in main scaffold
/// final overlayKey = GlobalKey<AddToCartOverlayState>();
/// AddToCartAnimationController.initialize(overlayKey);
///
/// // Trigger from anywhere
/// AddToCartAnimationController.trigger(
///   context,
///   startPosition: productPosition,
///   endPosition: cartPosition,
///   imageUrl: sneaker.imageUrl,
/// );
/// ```
class AddToCartAnimationController {
  static GlobalKey<AddToCartOverlayState>? _overlayKey;

  /// Initialize with the overlay's global key.
  static void initialize(GlobalKey<AddToCartOverlayState> key) {
    _overlayKey = key;
  }

  /// Trigger the animation.
  static void trigger(
    BuildContext context, {
    required Offset startPosition,
    required Offset endPosition,
    String? imageUrl,
    Widget? imageWidget,
    VoidCallback? onComplete,
  }) {
    _overlayKey?.currentState?.trigger(
      startPosition: startPosition,
      endPosition: endPosition,
      imageUrl: imageUrl,
      imageWidget: imageWidget,
      onComplete: onComplete,
    );
  }

  /// Check if controller is initialized.
  static bool get isInitialized => _overlayKey != null;
}

/// **CartBounceAnimation**
///
/// Mixin providing a bounce animation for the cart icon when items are added.
///
/// **Usage:**
/// ```dart
/// class _CartIconState extends State<CartIcon>
///     with SingleTickerProviderStateMixin, CartBounceAnimationMixin {
///
///   void onItemAdded() {
///     triggerBounce();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Transform.scale(
///       scale: bounceScale,
///       child: CartIcon(),
///     );
///   }
/// }
/// ```
mixin CartBounceAnimationMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  bool _reduceMotion = false;

  @protected
  void initBounceAnimation() {
    _bounceController = AnimationController(
      duration: SneakerAnimations.medium,
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 0.9),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.1),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @protected
  void checkReducedMotionForBounce(BuildContext context) {
    _reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  @protected
  void disposeBounceAnimation() {
    _bounceController.dispose();
  }

  /// Trigger the bounce animation.
  void triggerBounce() {
    if (_reduceMotion) return;
    _bounceController.forward(from: 0);
  }

  /// Current scale value for the bounce.
  double get bounceScale => _bounceAnimation.value;

  /// The bounce animation for listening.
  Animation<double> get bounceAnimation => _bounceAnimation;
}
