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
  /// Resumes paused playlist audio (no loading dialog - instant feedback).
  Future<void> onPlayBgmTapped(BuildContext context) async {
    await _viewModel.coordinator.resumeBgm();
    _viewModel.update();
  }

  /// Called when pause BGM button is tapped (no loading dialog).
  Future<void> onStopBgmTapped(BuildContext context) async {
    await _viewModel.coordinator.pauseBgm();
    _viewModel.update();
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

  /// Called to test SFX (no loading dialog).
  Future<void> onTestSfxTapped(BuildContext context) async {
    await _viewModel.coordinator.playEntityTapSfx();
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

  /// Called when a map entity is tapped (no loading dialog - instant SFX).
  Future<void> onEntityTapped(BuildContext context, String entityId) async {
    await _viewModel.coordinator.onEntityTapped(entityId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when add entity button is tapped.
  void onAddEntityTapped() {
    _viewModel.coordinator.onAddEntity();
    _viewModel.update();
  }

  /// Called when remove entity button is tapped.
  void onRemoveEntityTapped() {
    _viewModel.coordinator.onRemoveEntity();
    _viewModel.update();
  }

  /// Called when focus entity button is tapped.
  void onFocusEntityTapped() {
    _viewModel.coordinator.onFocusEntity();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when refresh button is tapped.
  void onRefreshTapped() {
    _viewModel.coordinator.onRefresh();
  }

  /// Called when reload button is tapped.
  Future<void> onReloadTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.coordinator.onReload();
      _viewModel.update();
    });
  }

  /// Called when clear button is tapped.
  void onClearTapped() {
    _viewModel.coordinator.onClear();
    _viewModel.update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Movement Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when move up button is tapped.
  void onMoveUpTapped() {
    _viewModel.coordinator.onMoveUp();
  }

  /// Called when move down button is tapped.
  void onMoveDownTapped() {
    _viewModel.coordinator.onMoveDown();
  }

  /// Called when move left button is tapped.
  void onMoveLeftTapped() {
    _viewModel.coordinator.onMoveLeft();
  }

  /// Called when move right button is tapped.
  void onMoveRightTapped() {
    _viewModel.coordinator.onMoveRight();
  }
}
