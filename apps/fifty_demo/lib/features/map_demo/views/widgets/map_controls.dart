/// Map Controls Widget
///
/// Camera control buttons for map navigation.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Map controls widget.
///
/// Provides zoom and center camera buttons.
class MapControlsWidget extends StatelessWidget {
  const MapControlsWidget({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenter,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenter;

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: Icons.zoom_in,
            label: 'ZOOM IN',
            onTap: onZoomIn,
          ),
          _ControlButton(
            icon: Icons.zoom_out,
            label: 'ZOOM OUT',
            onTap: onZoomOut,
          ),
          _ControlButton(
            icon: Icons.center_focus_strong,
            label: 'CENTER',
            onTap: onCenter,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
              borderRadius: FiftyRadii.standardRadius,
              border: Border.all(
                color: FiftyColors.crimsonPulse.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              icon,
              color: FiftyColors.crimsonPulse,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: 10,
              color: FiftyColors.hyperChrome,
            ),
          ),
        ],
      ),
    );
  }
}
