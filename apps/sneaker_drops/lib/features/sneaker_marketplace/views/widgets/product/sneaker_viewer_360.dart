import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import 'sneaker_image.dart';

/// **SneakerViewer360**
///
/// Interactive 360-degree sneaker viewer with drag-to-rotate functionality.
///
/// Features:
/// - Drag horizontally to rotate the sneaker
/// - Shows frame index indicator (e.g., "1 / 24")
/// - Auto-rotate when idle (after 3 seconds)
/// - Zoom controls (optional)
/// - Loading progress indicator
///
/// For MVP: Simulates 360 rotation with single image that rotates on drag.
/// For production: Use 24-36 pre-rendered images for smooth rotation.
///
/// **Example Usage:**
/// ```dart
/// SneakerViewer360(
///   imageUrls: sneaker.images,
///   autoRotate: true,
/// )
/// ```
class SneakerViewer360 extends StatefulWidget {
  /// List of image URLs for 360 view (1 for MVP, 24-36 for full).
  final List<String> imageUrls;

  /// Primary image URL as fallback.
  final String? primaryImageUrl;

  /// Whether to auto-rotate when idle.
  final bool autoRotate;

  /// Duration before auto-rotate starts after user interaction.
  final Duration autoRotateDelay;

  /// Auto-rotate speed (degrees per second).
  final double autoRotateSpeed;

  /// Whether to show frame indicator.
  final bool showFrameIndicator;

  /// Whether to show zoom controls.
  final bool showZoomControls;

  /// Height of the viewer. Defaults to expanding to parent.
  final double? height;

  /// Creates a [SneakerViewer360] with the specified parameters.
  const SneakerViewer360({
    required this.imageUrls,
    this.primaryImageUrl,
    this.autoRotate = true,
    this.autoRotateDelay = const Duration(seconds: 3),
    this.autoRotateSpeed = 30.0,
    this.showFrameIndicator = true,
    this.showZoomControls = false,
    this.height,
    super.key,
  });

  @override
  State<SneakerViewer360> createState() => _SneakerViewer360State();
}

class _SneakerViewer360State extends State<SneakerViewer360>
    with SingleTickerProviderStateMixin {
  /// Current frame index (0-based).
  int _currentFrame = 0;

  /// Current rotation angle in degrees (for MVP single-image mode).
  double _rotationAngle = 0.0;

  /// Last drag position for delta calculation.
  double _lastDragX = 0.0;

  /// Whether user is currently dragging.
  bool _isDragging = false;

  /// Animation controller for auto-rotate.
  late AnimationController _autoRotateController;

  /// Zoom level (1.0 = 100%).
  double _zoomLevel = 1.0;

  /// Minimum zoom level.
  static const double _minZoom = 1.0;

  /// Maximum zoom level.
  static const double _maxZoom = 2.5;

  /// Zoom step increment.
  static const double _zoomStep = 0.5;

  /// Whether we're in multi-frame mode (true 360 view).
  bool get _isMultiFrame => widget.imageUrls.length > 1;

  /// Total number of frames.
  int get _frameCount => widget.imageUrls.isEmpty ? 1 : widget.imageUrls.length;

  @override
  void initState() {
    super.initState();

    _autoRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (widget.autoRotate) {
      _startAutoRotateTimer();
    }
  }

  @override
  void dispose() {
    _autoRotateController.dispose();
    super.dispose();
  }

  /// Starts the auto-rotate timer.
  void _startAutoRotateTimer() {
    if (!widget.autoRotate) return;

    Future.delayed(widget.autoRotateDelay, () {
      if (mounted && !_isDragging) {
        _startAutoRotate();
      }
    });
  }

  /// Starts auto-rotation animation.
  void _startAutoRotate() {
    if (!mounted || _isDragging) return;

    _autoRotateController.repeat();
    _autoRotateController.addListener(_onAutoRotate);
  }

  /// Stops auto-rotation.
  void _stopAutoRotate() {
    _autoRotateController.stop();
    _autoRotateController.removeListener(_onAutoRotate);
  }

  /// Called on each auto-rotate tick.
  void _onAutoRotate() {
    if (!mounted) return;

    final delta = widget.autoRotateSpeed / 60; // Assume 60fps
    _updateRotation(delta);
  }

  /// Updates rotation based on delta.
  void _updateRotation(double delta) {
    setState(() {
      if (_isMultiFrame) {
        // Multi-frame: advance frames
        final framesPerDegree = _frameCount / 360.0;
        final frameDelta = (delta * framesPerDegree).round();
        _currentFrame = (_currentFrame + frameDelta) % _frameCount;
      } else {
        // Single image: rotate the image
        _rotationAngle = (_rotationAngle + delta) % 360.0;
      }
    });
  }

  /// Handles drag start.
  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    _lastDragX = details.localPosition.dx;
    _stopAutoRotate();
  }

  /// Handles drag update.
  void _onDragUpdate(DragUpdateDetails details) {
    final currentX = details.localPosition.dx;
    final delta = currentX - _lastDragX;
    _lastDragX = currentX;

    // Convert drag distance to rotation (negative for intuitive left-right)
    final rotationDelta = -delta * 0.5;
    _updateRotation(rotationDelta);
  }

  /// Handles drag end.
  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    _startAutoRotateTimer();
  }

  /// Zooms in.
  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + _zoomStep).clamp(_minZoom, _maxZoom);
    });
  }

  /// Zooms out.
  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - _zoomStep).clamp(_minZoom, _maxZoom);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: SneakerColors.darkBurgundy,
        borderRadius: SneakerRadii.radiusXl,
      ),
      child: Stack(
        children: [
          // Main viewer
          Positioned.fill(
            child: GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: _buildViewer(),
            ),
          ),

          // Frame indicator
          if (widget.showFrameIndicator && _isMultiFrame)
            Positioned(
              bottom: SneakerSpacing.md,
              left: 0,
              right: 0,
              child: _buildFrameIndicator(),
            ),

          // Zoom controls
          if (widget.showZoomControls)
            Positioned(
              bottom: SneakerSpacing.md,
              right: SneakerSpacing.md,
              child: _buildZoomControls(),
            ),

          // Drag hint
          if (!_isDragging)
            Positioned(
              bottom: SneakerSpacing.md,
              left: SneakerSpacing.md,
              child: _buildDragHint(),
            ),
        ],
      ),
    );
  }

  Widget _buildViewer() {
    final imageUrl = _getCurrentImageUrl();

    return Center(
      child: AnimatedScale(
        scale: _zoomLevel,
        duration: SneakerAnimations.fast,
        curve: SneakerAnimations.standard,
        child: _isMultiFrame
            ? SneakerImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              )
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(_rotationAngle * 3.14159 / 180),
                child: SneakerImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }

  String _getCurrentImageUrl() {
    if (widget.imageUrls.isEmpty) {
      return widget.primaryImageUrl ?? '';
    }

    if (_isMultiFrame) {
      return widget.imageUrls[_currentFrame];
    }

    return widget.imageUrls.first;
  }

  Widget _buildFrameIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: SneakerColors.glassBackground,
          borderRadius: SneakerRadii.radiusFull,
        ),
        child: Text(
          '${_currentFrame + 1} / $_frameCount',
          style: TextStyle(
            fontFamily: SneakerTypography.fontFamily,
            fontSize: 12,
            fontWeight: SneakerTypography.medium,
            color: SneakerColors.slateGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: SneakerColors.glassBackground,
        borderRadius: SneakerRadii.radiusMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(
            icon: Icons.add,
            onTap: _zoomLevel < _maxZoom ? _zoomIn : null,
            semanticLabel: 'Zoom in',
          ),
          Container(
            width: 24,
            height: 1,
            color: SneakerColors.border,
          ),
          _ZoomButton(
            icon: Icons.remove,
            onTap: _zoomLevel > _minZoom ? _zoomOut : null,
            semanticLabel: 'Zoom out',
          ),
        ],
      ),
    );
  }

  Widget _buildDragHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SneakerColors.glassBackground,
        borderRadius: SneakerRadii.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swipe,
            size: 16,
            color: SneakerColors.slateGrey,
          ),
          const SizedBox(width: 6),
          Text(
            'Drag to rotate',
            style: TextStyle(
              fontFamily: SneakerTypography.fontFamily,
              fontSize: 11,
              fontWeight: SneakerTypography.medium,
              color: SneakerColors.slateGrey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal zoom button widget.
class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: isEnabled ? SneakerColors.cream : SneakerColors.slateGrey,
          ),
        ),
      ),
    );
  }
}
