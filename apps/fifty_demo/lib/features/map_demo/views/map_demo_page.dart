/// Map Demo Page
///
/// Demonstrates map engine with audio integration.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../actions/map_demo_actions.dart';
import '../controllers/map_demo_view_model.dart';
import 'widgets/control_panel.dart';
import 'widgets/status_bar.dart';

/// Map demo page widget.
///
/// Shows map rendering with audio playback controls.
/// Automatically switches to landscape orientation on enter and
/// restores portrait orientation on exit.
class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  @override
  void initState() {
    super.initState();
    // Lock to landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Initialize map demo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MapDemoActions>()) {
        MapDemoActions.instance.onInitialize(context);
      }
    });
  }

  @override
  void dispose() {
    // Restore portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<MapDemoActions>();

        return Scaffold(
          backgroundColor: FiftyColors.surfaceDark,
          body: _buildFullscreenMap(context, viewModel, actions),
        );
      },
    );
  }

  /// Builds the fullscreen map with all overlays.
  Widget _buildFullscreenMap(
    BuildContext context,
    MapDemoViewModel viewModel,
    MapDemoActions actions,
  ) {
    return Stack(
      children: [
        // Map widget (fills entire screen)
        Positioned.fill(
          child: _buildMapWidget(context, viewModel, actions),
        ),

        // Safe area for overlays
        SafeArea(
          child: Stack(
            children: [
              // Top bar with back button, status, and audio controls
              Positioned(
                top: FiftySpacing.sm,
                left: FiftySpacing.sm,
                child: Row(
                  children: [
                    // Back button
                    _buildBackButton(context),
                    const SizedBox(width: FiftySpacing.sm),

                    // Status bar
                    StatusBar(
                      status: viewModel.mapStatusLabel,
                      entityCount: '${viewModel.entities.length} entities',
                      hasError: viewModel.coordinator.mapService.hasError,
                      errorMessage: viewModel.coordinator.mapService.lastError,
                    ),
                    const SizedBox(width: FiftySpacing.sm),

                    // BGM button
                    _buildAudioButton(
                      context,
                      icon: viewModel.bgmPlaying
                          ? Icons.music_note
                          : Icons.music_off,
                      active: viewModel.bgmPlaying,
                      tooltip: viewModel.bgmPlaying ? 'Pause BGM' : 'Play BGM',
                      onTap: () {
                        if (viewModel.bgmPlaying) {
                          actions.onStopBgmTapped(context);
                        } else {
                          actions.onPlayBgmTapped(context);
                        }
                      },
                    ),
                    const SizedBox(width: FiftySpacing.xs),

                    // SFX button
                    _buildAudioButton(
                      context,
                      icon: viewModel.sfxEnabled
                          ? Icons.volume_up
                          : Icons.volume_off,
                      active: viewModel.sfxEnabled,
                      tooltip: viewModel.sfxEnabled ? 'Mute SFX' : 'Unmute SFX',
                      onTap: actions.onToggleSfx,
                    ),
                  ],
                ),
              ),

              // Control panel overlay (right side, full height with scrolling)
              Positioned(
                top: FiftySpacing.sm,
                right: FiftySpacing.sm,
                bottom: FiftySpacing.sm,
                child: SingleChildScrollView(
                  child: ControlPanel(
                    onZoomIn: actions.onZoomInTapped,
                    onZoomOut: actions.onZoomOutTapped,
                    onCenterMap: actions.onCenterTapped,
                    onAddEntity: actions.onAddEntityTapped,
                    onRemoveEntity: actions.onRemoveEntityTapped,
                    onFocusEntity: actions.onFocusEntityTapped,
                    onRefresh: actions.onRefreshTapped,
                    onReload: () => actions.onReloadTapped(context),
                    onClear: actions.onClearTapped,
                    onMoveUp: actions.onMoveUpTapped,
                    onMoveDown: actions.onMoveDownTapped,
                    onMoveLeft: actions.onMoveLeftTapped,
                    onMoveRight: actions.onMoveRightTapped,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the back button overlay.
  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Get.back<void>(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FiftyColors.surfaceDark.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Icon(
          Icons.arrow_back,
          color: colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  /// Builds an audio control button (same style as back button).
  Widget _buildAudioButton(
    BuildContext context, {
    required IconData icon,
    required bool active,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: FiftyColors.surfaceDark.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          child: Icon(
            icon,
            color: active ? colorScheme.primary : colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Builds the map widget based on loading state.
  Widget _buildMapWidget(
    BuildContext context,
    MapDemoViewModel viewModel,
    MapDemoActions actions,
  ) {
    final controller = viewModel.controller;
    final colorScheme = Theme.of(context).colorScheme;

    // Show loading state
    if (viewModel.isMapLoading) {
      return Container(
        color: FiftyColors.surfaceDark,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.primary,
                ),
              ),
              const SizedBox(height: FiftySpacing.md),
              Text(
                'LOADING MAP...',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show placeholder if controller not ready
    if (controller == null || !viewModel.isMapLoaded) {
      return Container(
        color: FiftyColors.surfaceDark,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                size: 64,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(height: FiftySpacing.md),
              Text(
                'MAP NOT LOADED',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show the actual map widget - SizedBox.expand ensures it fills the space
    return SizedBox.expand(
      child: FiftyMapWidget(
        controller: controller,
        initialEntities: viewModel.entities,
        onEntityTap: (entity) => actions.onEntityTapped(context, entity.id),
      ),
    );
  }
}
