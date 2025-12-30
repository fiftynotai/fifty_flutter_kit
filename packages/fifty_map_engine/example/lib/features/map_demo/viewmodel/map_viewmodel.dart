/// ViewModel for the Map Demo feature.
///
/// Exposes map engine state for the view to observe.
/// All state changes flow through the MapService.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:flutter/foundation.dart';

import '../service/map_service.dart';

/// ViewModel for map demo feature.
///
/// Provides a reactive interface to the MapService state.
class MapViewModel extends ChangeNotifier {
  MapViewModel({
    required MapService mapService,
  }) : _mapService = mapService {
    _mapService.addListener(_onServiceChanged);
  }

  final MapService _mapService;

  // ─────────────────────────────────────────────────────────────────────────
  // Controller Access
  // ─────────────────────────────────────────────────────────────────────────

  /// The map controller for direct manipulation.
  FiftyMapController get controller => _mapService.controller;

  // ─────────────────────────────────────────────────────────────────────────
  // Entities State
  // ─────────────────────────────────────────────────────────────────────────

  /// Current list of initial entities.
  List<FiftyMapEntity> get initialEntities => _mapService.initialEntities;

  /// Whether entities have been loaded.
  bool get hasEntities => _mapService.hasEntities;

  /// The test entity for demonstrations.
  FiftyMapEntity get testEntity => _mapService.testEntity;

  // ─────────────────────────────────────────────────────────────────────────
  // Loading State
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether a map load operation is in progress.
  bool get isLoading => _mapService.isLoading;

  /// Last error message (if any).
  String? get lastError => _mapService.lastError;

  /// Whether there is an error to display.
  bool get hasError => _mapService.hasError;

  // ─────────────────────────────────────────────────────────────────────────
  // Status Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Status label for current state.
  String get statusLabel {
    if (isLoading) return 'LOADING';
    if (hasError) return 'ERROR';
    if (hasEntities) return 'READY';
    return 'EMPTY';
  }

  /// Entity count label.
  String get entityCountLabel {
    final count = initialEntities.length;
    return '$count ${count == 1 ? 'entity' : 'entities'}';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Listener
  // ─────────────────────────────────────────────────────────────────────────

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _mapService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
