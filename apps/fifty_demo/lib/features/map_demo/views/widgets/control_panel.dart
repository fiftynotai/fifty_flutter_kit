/// Control Panel Widget
///
/// FDL-styled control panel for map manipulation.
/// Provides zoom, entity, and movement controls.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Control panel with grouped action buttons.
///
/// Features:
/// - FiftyCard container with surfaceDark background
/// - FiftyIconButton controls with crimson glow on interaction
/// - Grouped sections: Zoom/Center, Add/Remove, Load/Clear, D-pad
class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterMap,
    required this.onAddEntity,
    required this.onRemoveEntity,
    required this.onFocusEntity,
    required this.onRefresh,
    required this.onReload,
    required this.onClear,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onMoveLeft,
    required this.onMoveRight,
  });

  // Camera controls
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenterMap;

  // Entity controls
  final VoidCallback onAddEntity;
  final VoidCallback onRemoveEntity;
  final VoidCallback onFocusEntity;

  // Load/Clear controls
  final VoidCallback onRefresh;
  final VoidCallback onReload;
  final VoidCallback onClear;

  // Movement controls
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      backgroundColor: FiftyColors.surfaceDark.withValues(alpha: 0.9),
      scanlineOnHover: false,
      hoverScale: 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Label
          _buildSectionLabel('CAMERA'),
          SizedBox(height: FiftySpacing.xs),

          // Zoom & Center controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                icon: Icons.zoom_in,
                tooltip: 'Zoom In',
                onPressed: onZoomIn,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.zoom_out,
                tooltip: 'Zoom Out',
                onPressed: onZoomOut,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.my_location,
                tooltip: 'Center Map',
                onPressed: onCenterMap,
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.md),
          const FiftyDivider(),
          SizedBox(height: FiftySpacing.md),

          // Section Label
          _buildSectionLabel('ENTITY'),
          SizedBox(height: FiftySpacing.xs),

          // Entity add/remove/focus controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                icon: Icons.add,
                tooltip: 'Add Entity',
                onPressed: onAddEntity,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.remove,
                tooltip: 'Remove Entity',
                onPressed: onRemoveEntity,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.center_focus_strong_rounded,
                tooltip: 'Focus on Entity',
                onPressed: onFocusEntity,
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.md),
          const FiftyDivider(),
          SizedBox(height: FiftySpacing.md),

          // Section Label
          _buildSectionLabel('MAP'),
          SizedBox(height: FiftySpacing.xs),

          // Load/clear controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                icon: Icons.refresh,
                tooltip: 'Refresh',
                onPressed: onRefresh,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.download,
                tooltip: 'Reload Map',
                onPressed: onReload,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.clear,
                tooltip: 'Clear All',
                onPressed: onClear,
              ),
            ],
          ),

          SizedBox(height: FiftySpacing.md),
          const FiftyDivider(),
          SizedBox(height: FiftySpacing.md),

          // Section Label
          _buildSectionLabel('MOVE'),
          SizedBox(height: FiftySpacing.xs),

          // D-pad movement controls
          _buildIconButton(
            icon: Icons.arrow_circle_up_outlined,
            tooltip: 'Move Up',
            onPressed: onMoveUp,
          ),
          SizedBox(height: FiftySpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                icon: Icons.arrow_circle_left_outlined,
                tooltip: 'Move Left',
                onPressed: onMoveLeft,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.arrow_circle_down_outlined,
                tooltip: 'Move Down',
                onPressed: onMoveDown,
              ),
              SizedBox(width: FiftySpacing.xs),
              _buildIconButton(
                icon: Icons.arrow_circle_right_outlined,
                tooltip: 'Move Right',
                onPressed: onMoveRight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.slateGrey,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return FiftyIconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
      variant: FiftyIconButtonVariant.secondary,
      size: FiftyIconButtonSize.medium,
    );
  }
}
