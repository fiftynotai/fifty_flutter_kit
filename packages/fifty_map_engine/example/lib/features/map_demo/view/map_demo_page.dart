/// Map Demo Page
///
/// Main page for demonstrating the fifty_map_engine capabilities.
/// Features an interactive map with FDL-styled control overlay.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../actions/map_actions.dart';
import '../viewmodel/map_viewmodel.dart';
import 'widgets/control_panel.dart';
import 'widgets/status_bar.dart';

/// Main page displaying the interactive map demo.
///
/// Features:
/// - FiftyMapWidget for map rendering
/// - Overlaid control panel for entity/camera manipulation
/// - Status bar showing current state
class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  late final MapActions _actions;

  @override
  void initState() {
    super.initState();
    _actions = serviceLocator<MapActions>();
    // Load initial entities after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actions.onLoadInitialEntities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: FiftyColors.darkBurgundy,
          body: Stack(
            children: [
              // Map Widget (takes full screen)
              Positioned.fill(
                child: FiftyMapWidget(
                  initialEntities: viewModel.initialEntities,
                  onEntityTap: _actions.onEntityTapped,
                  controller: viewModel.controller,
                ),
              ),

              // Status Bar (top left)
              Positioned(
                top: 16,
                left: 16,
                child: StatusBar(
                  status: viewModel.statusLabel,
                  entityCount: viewModel.entityCountLabel,
                  hasError: viewModel.hasError,
                  errorMessage: viewModel.lastError,
                ),
              ),

              // Control Panel (right side)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: ControlPanel(
                    onZoomIn: _actions.onZoomInTapped,
                    onZoomOut: _actions.onZoomOutTapped,
                    onCenterMap: _actions.onCenterMapTapped,
                    onAddEntity: _actions.onAddEntityTapped,
                    onRemoveEntity: _actions.onRemoveEntityTapped,
                    onFocusEntity: _actions.onFocusOnEntityTapped,
                    onRefresh: _actions.onLoadUpdatedRoom,
                    onDownload: _actions.onLoadInitialEntities,
                    onClear: _actions.onClearAllTapped,
                    onMoveUp: _actions.onMoveUpTapped,
                    onMoveDown: _actions.onMoveDownTapped,
                    onMoveLeft: _actions.onMoveLeftTapped,
                    onMoveRight: _actions.onMoveRightTapped,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
