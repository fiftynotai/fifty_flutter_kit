import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:fifty_map_engine/fifty_map_engine.dart';

/// **FiftyMapWidget**
///
/// High-level Flutter widget that embeds the interactive Fifty map.
///
/// This widget:
/// - Binds the provided [FiftyMapController] to a new [FiftyMapBuilder]
/// - Initializes with optional [initialEntities]
/// - Forwards tap events via [onEntityTap]
///
/// **Usage:**
/// ```dart
/// final controller = FiftyMapController();
/// FiftyMapWidget(
///   initialEntities: myEntities,
///   onEntityTap: (entity) => print('Tapped $entity'),
///   controller: controller,
/// )
/// ```
class FiftyMapWidget extends StatefulWidget {
  /// Initial entities to load into the map.
  final List<FiftyMapEntity> initialEntities;

  /// Callback for when a map entity is tapped.
  final FiftyMapTapCallback onEntityTap;

  /// Controller for dynamic map manipulation.
  final FiftyMapController controller;

  /// Creates a [FiftyMapWidget].
  ///
  /// - [initialEntities]: optional preloaded entities (defaults to empty)
  /// - [onEntityTap]: required tap callback
  /// - [controller]: required map engine controller
  const FiftyMapWidget({
    super.key,
    this.initialEntities = const [],
    required this.onEntityTap,
    required this.controller,
  });

  @override
  State<FiftyMapWidget> createState() => _FiftyMapWidgetState();
}

class _FiftyMapWidgetState extends State<FiftyMapWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.bind(
      FiftyMapBuilder(
        initialEntities: widget.initialEntities,
        onEntityTap: widget.onEntityTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: widget.controller.game);
  }
}
