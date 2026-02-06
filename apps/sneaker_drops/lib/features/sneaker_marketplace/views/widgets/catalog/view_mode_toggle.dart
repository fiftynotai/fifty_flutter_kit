import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../controllers/catalog_view_model.dart';

/// **ViewModeToggle**
///
/// Toggle button group for switching between grid and list view modes.
///
/// Features:
/// - Two-state toggle (grid/list)
/// - Animated selection indicator
/// - Icon-only design for compact layout
/// - Accessible with semantic labels
///
/// **Example Usage:**
/// ```dart
/// ViewModeToggle(
///   mode: ViewMode.grid,
///   onChanged: (mode) => controller.setViewMode(mode),
/// )
/// ```
class ViewModeToggle extends StatelessWidget {
  /// Creates a [ViewModeToggle] with the specified parameters.
  const ViewModeToggle({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  /// Current view mode.
  final ViewMode mode;

  /// Callback when view mode changes.
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusMd,
        border: Border.all(color: SneakerColors.border),
      ),
      padding: const EdgeInsets.all(SneakerSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            icon: Icons.grid_view_rounded,
            isSelected: mode == ViewMode.grid,
            onTap: () => onChanged(ViewMode.grid),
            semanticLabel: 'Grid view',
          ),
          const SizedBox(width: SneakerSpacing.xs),
          _buildToggleButton(
            icon: Icons.view_list_rounded,
            isSelected: mode == ViewMode.list,
            onTap: () => onChanged(ViewMode.list),
            semanticLabel: 'List view',
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: SneakerAnimations.fast,
          padding: const EdgeInsets.all(SneakerSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? SneakerColors.burgundy
                : Colors.transparent,
            borderRadius: SneakerRadii.radiusSm,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected
                ? SneakerColors.cream
                : SneakerColors.slateGrey,
          ),
        ),
      ),
    );
  }
}
