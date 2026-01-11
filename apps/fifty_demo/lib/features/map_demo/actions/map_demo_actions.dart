/// Map Demo Actions
///
/// Handles user interactions for the map demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/map_demo_view_model.dart';

/// Actions for the map demo feature.
///
/// Provides map and audio control actions.
class MapDemoActions {
  MapDemoActions(this._viewModel, this._presenter);

  final MapDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static MapDemoActions get instance => Get.find<MapDemoActions>();

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the demo.
  Future<void> onInitialize(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.initialize();
      _viewModel.update();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when play BGM button is tapped.
  Future<void> onPlayBgmTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.startExplorationBgm();
      _viewModel.update();
    });
  }

  /// Called when stop BGM button is tapped.
  Future<void> onStopBgmTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.stopExplorationBgm();
      _viewModel.update();
    });
  }

  /// Called when BGM toggle is tapped.
  void onToggleBgm() {
    _viewModel.coordinator.toggleBgm();
    _viewModel.update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when SFX toggle is tapped.
  void onToggleSfx() {
    _viewModel.coordinator.toggleSfx();
    _viewModel.update();
  }

  /// Called to test SFX.
  Future<void> onTestSfxTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.playEntityTapSfx();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when zoom in button is tapped.
  void onZoomInTapped() {
    _viewModel.coordinator.onZoomIn();
  }

  /// Called when zoom out button is tapped.
  void onZoomOutTapped() {
    _viewModel.coordinator.onZoomOut();
  }

  /// Called when center button is tapped.
  void onCenterTapped() {
    _viewModel.coordinator.onCenterCamera();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a map entity is tapped.
  Future<void> onEntityTapped(BuildContext context, String entityId) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.onEntityTapped(entityId);
    });
  }
}
