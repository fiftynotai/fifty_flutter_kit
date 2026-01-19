import 'package:flutter/widgets.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';

/// Controller for managing skill tree state and interactions.
///
/// The controller handles:
/// - Tree state management (nodes, connections, points)
/// - View state (zoom, pan, selection, hover)
/// - Unlock operations with results
/// - Progress serialization/deserialization
///
/// **Example:**
/// ```dart
/// final controller = SkillTreeController<AbilityData>(
///   tree: mySkillTree,
///   theme: SkillTreeTheme.dark(),
/// );
///
/// // Listen for changes
/// controller.addListener(() {
///   print('Tree updated: ${controller.availablePoints} points available');
/// });
///
/// // Unlock a skill
/// final result = await controller.unlock('fireball');
/// if (result.success) {
///   print('Unlocked ${result.node?.name}!');
/// }
/// ```
class SkillTreeController<T> extends ChangeNotifier {
  /// Creates a skill tree controller.
  ///
  /// **Parameters:**
  /// - [tree]: The skill tree to manage
  /// - [theme]: Optional theme (defaults to dark theme)
  /// - [initialZoom]: Initial zoom level (defaults to 1.0)
  /// - [initialPanOffset]: Initial pan offset (defaults to zero)
  SkillTreeController({
    required SkillTree<T> tree,
    SkillTreeTheme? theme,
    double initialZoom = 1.0,
    Offset initialPanOffset = Offset.zero,
  })  : _tree = tree,
        _theme = theme ?? SkillTreeTheme.dark(),
        _zoom = initialZoom,
        _panOffset = initialPanOffset;

  // ---- State ----

  SkillTree<T> _tree;
  SkillTreeTheme _theme;
  double _zoom;
  Offset _panOffset;
  String? _selectedNodeId;
  String? _hoveredNodeId;

  // ---- Getters ----

  /// The current skill tree.
  SkillTree<T> get tree => _tree;

  /// The current theme.
  SkillTreeTheme get theme => _theme;

  /// Current zoom level (1.0 = 100%).
  double get zoom => _zoom;

  /// Current pan offset.
  Offset get panOffset => _panOffset;

  /// ID of the currently selected node, if any.
  String? get selectedNodeId => _selectedNodeId;

  /// ID of the currently hovered node, if any.
  String? get hoveredNodeId => _hoveredNodeId;

  /// Available points for spending.
  int get availablePoints => _tree.availablePoints;

  /// Total points spent across all nodes.
  int get spentPoints => _tree.spentPoints;

  /// All nodes in the tree.
  List<SkillNode<T>> get nodes => _tree.nodes;

  /// All connections in the tree.
  List<SkillConnection> get connections => _tree.connections;

  /// The currently selected node, if any.
  SkillNode<T>? get selectedNode =>
      _selectedNodeId != null ? _tree.getNode(_selectedNodeId!) : null;

  /// The currently hovered node, if any.
  SkillNode<T>? get hoveredNode =>
      _hoveredNodeId != null ? _tree.getNode(_hoveredNodeId!) : null;

  // ---- Tree Operations ----

  /// Attempts to unlock or level up a node.
  ///
  /// Returns an [UnlockResult] indicating success or failure.
  /// Notifies listeners on success.
  ///
  /// **Example:**
  /// ```dart
  /// final result = await controller.unlock('fireball');
  /// if (result.success) {
  ///   // Show unlock animation
  /// } else if (result.reason == UnlockFailureReason.insufficientPoints) {
  ///   // Show "not enough points" message
  /// }
  /// ```
  Future<UnlockResult<T>> unlock(String nodeId) async {
    final result = _tree.unlock(nodeId);

    if (result.success) {
      notifyListeners();
    }

    return result;
  }

  /// Resets all nodes to level 0 and refunds all spent points.
  ///
  /// Clears selection and notifies listeners.
  void reset() {
    _tree.reset();
    _selectedNodeId = null;
    notifyListeners();
  }

  /// Resets a specific node and refunds its spent points.
  ///
  /// Note: This may leave dependent nodes in an invalid state.
  void resetNode(String nodeId) {
    _tree.resetNode(nodeId);
    if (_selectedNodeId == nodeId) {
      _selectedNodeId = null;
    }
    notifyListeners();
  }

  /// Adds points to the available pool.
  void addPoints(int amount) {
    _tree.addPoints(amount);
    notifyListeners();
  }

  /// Removes points from the available pool.
  void removePoints(int amount) {
    _tree.removePoints(amount);
    notifyListeners();
  }

  /// Sets the available points to a specific value.
  void setPoints(int amount) {
    _tree.setPoints(amount);
    notifyListeners();
  }

  /// Gets the state of a specific node.
  SkillState getNodeState(String nodeId) {
    return _tree.getNodeState(nodeId);
  }

  /// Gets a node by ID.
  SkillNode<T>? getNode(String nodeId) {
    return _tree.getNode(nodeId);
  }

  /// Replaces the current tree with a new one.
  ///
  /// Resets selection and notifies listeners.
  void setTree(SkillTree<T> tree) {
    _tree = tree;
    _selectedNodeId = null;
    _hoveredNodeId = null;
    notifyListeners();
  }

  // ---- Theme ----

  /// Updates the theme.
  void setTheme(SkillTreeTheme theme) {
    if (_theme != theme) {
      _theme = theme;
      notifyListeners();
    }
  }

  // ---- Selection & Hover ----

  /// Selects a node by ID.
  ///
  /// Pass null to clear selection.
  void selectNode(String? nodeId) {
    if (_selectedNodeId != nodeId) {
      _selectedNodeId = nodeId;
      notifyListeners();
    }
  }

  /// Sets the hovered node by ID.
  ///
  /// Pass null to clear hover state.
  void hoverNode(String? nodeId) {
    if (_hoveredNodeId != nodeId) {
      _hoveredNodeId = nodeId;
      notifyListeners();
    }
  }

  /// Toggles selection on a node.
  ///
  /// If the node is already selected, clears selection.
  /// Otherwise, selects the node.
  void toggleSelection(String nodeId) {
    if (_selectedNodeId == nodeId) {
      _selectedNodeId = null;
    } else {
      _selectedNodeId = nodeId;
    }
    notifyListeners();
  }

  // ---- View Control ----

  /// Sets the zoom level.
  ///
  /// **Parameters:**
  /// - [zoom]: The new zoom level (typically 0.5 to 2.0)
  /// - [notify]: Whether to notify listeners (defaults to true)
  void zoomTo(double zoom, {bool notify = true}) {
    if (_zoom != zoom) {
      _zoom = zoom;
      if (notify) notifyListeners();
    }
  }

  /// Sets the pan offset.
  ///
  /// **Parameters:**
  /// - [offset]: The new pan offset
  /// - [notify]: Whether to notify listeners (defaults to true)
  void panTo(Offset offset, {bool notify = true}) {
    if (_panOffset != offset) {
      _panOffset = offset;
      if (notify) notifyListeners();
    }
  }

  /// Centers the view on a specific node.
  ///
  /// This requires knowing the node positions and view size,
  /// which should be provided by the view widget.
  ///
  /// **Parameters:**
  /// - [nodeId]: The ID of the node to focus on
  /// - [nodePositions]: Current calculated node positions
  /// - [viewSize]: The size of the view area
  void focusNode(
    String nodeId, {
    required Map<String, Offset> nodePositions,
    required Size viewSize,
  }) {
    final position = nodePositions[nodeId];
    if (position == null) return;

    // Calculate offset to center the node
    final centerX = viewSize.width / 2;
    final centerY = viewSize.height / 2;

    _panOffset = Offset(
      centerX - position.dx * _zoom,
      centerY - position.dy * _zoom,
    );

    _selectedNodeId = nodeId;
    notifyListeners();
  }

  /// Resets view to default zoom and pan.
  void resetView() {
    _zoom = 1.0;
    _panOffset = Offset.zero;
    notifyListeners();
  }

  // ---- Serialization ----

  /// Exports the current progress for saving.
  ///
  /// Returns a compact map containing only the progress data
  /// (available points and node levels), suitable for save files.
  ///
  /// **Example:**
  /// ```dart
  /// final progress = controller.exportProgress();
  /// await saveToFile(jsonEncode(progress));
  /// ```
  Map<String, dynamic> exportProgress() {
    return _tree.exportProgress();
  }

  /// Imports progress from a previously saved state.
  ///
  /// Updates node levels and available points without changing
  /// the tree structure. Notifies listeners after import.
  ///
  /// **Example:**
  /// ```dart
  /// final savedData = await loadFromFile();
  /// final progress = jsonDecode(savedData) as Map<String, dynamic>;
  /// controller.importProgress(progress);
  /// ```
  void importProgress(Map<String, dynamic> progress) {
    _tree.importProgress(progress);
    _selectedNodeId = null;
    notifyListeners();
  }

  /// Exports the entire tree (structure and progress) as JSON.
  ///
  /// Useful for serializing complete tree definitions.
  Map<String, dynamic> exportTree() {
    return _tree.toJson();
  }
}
