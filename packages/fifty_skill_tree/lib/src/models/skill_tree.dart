import 'connection_type.dart';
import 'skill_connection.dart';
import 'skill_node.dart';
import 'skill_state.dart';
import 'unlock_result.dart';

/// A mutable skill tree that manages skill nodes and their state.
///
/// The [SkillTree] handles:
/// - Node storage and retrieval
/// - Point management
/// - Unlock logic with prerequisite checking
/// - Progress serialization/deserialization
///
/// **Example:**
/// ```dart
/// final tree = SkillTree<void>(
///   id: 'warrior',
///   name: 'Warrior Skills',
/// );
///
/// tree.addNode(SkillNode(id: 'slash', name: 'Slash'));
/// tree.addNode(SkillNode(
///   id: 'power_slash',
///   name: 'Power Slash',
///   prerequisites: ['slash'],
/// ));
///
/// tree.addConnection(SkillConnection(
///   fromId: 'slash',
///   toId: 'power_slash',
/// ));
///
/// tree.addPoints(5);
/// final result = tree.unlock('slash');
/// ```
class SkillTree<T> {
  /// Creates a new skill tree.
  SkillTree({
    required this.id,
    required this.name,
    List<SkillNode<T>>? nodes,
    List<SkillConnection>? connections,
    int availablePoints = 0,
  }) : _availablePoints = availablePoints {
    if (nodes != null) {
      for (final node in nodes) {
        _nodes[node.id] = node;
      }
    }
    if (connections != null) {
      _connections.addAll(connections);
    }
  }

  /// Unique identifier for this skill tree.
  final String id;

  /// Display name for the skill tree.
  final String name;

  /// Internal storage for nodes indexed by ID.
  final Map<String, SkillNode<T>> _nodes = {};

  /// Internal storage for connections.
  final List<SkillConnection> _connections = [];

  /// Points available for spending on skills.
  int _availablePoints;

  /// Gets the list of all nodes in the tree.
  List<SkillNode<T>> get nodes => _nodes.values.toList();

  /// Gets the list of all connections.
  List<SkillConnection> get connections => List.unmodifiable(_connections);

  /// Gets the current available points.
  int get availablePoints => _availablePoints;

  /// Gets the total points spent across all nodes.
  int get spentPoints {
    return _nodes.values.fold(0, (sum, node) => sum + node.totalSpent);
  }

  /// Gets a node by its ID.
  ///
  /// Returns null if the node doesn't exist.
  SkillNode<T>? getNode(String id) => _nodes[id];

  /// Gets all nodes in a specific branch.
  List<SkillNode<T>> getNodesInBranch(String branch) {
    return _nodes.values.where((node) => node.branch == branch).toList();
  }

  /// Gets all nodes in a specific tier.
  List<SkillNode<T>> getNodesInTier(int tier) {
    return _nodes.values.where((node) => node.tier == tier).toList();
  }

  /// Gets all unlocked nodes (currentLevel > 0).
  List<SkillNode<T>> getUnlockedNodes() {
    return _nodes.values.where((node) => node.isUnlocked).toList();
  }

  /// Gets all available nodes (can be unlocked right now).
  List<SkillNode<T>> getAvailableNodes() {
    return _nodes.values
        .where((node) => getNodeState(node.id) == SkillState.available)
        .toList();
  }

  /// Adds a node to the tree.
  ///
  /// If a node with the same ID exists, it will be replaced.
  void addNode(SkillNode<T> node) {
    _nodes[node.id] = node;
  }

  /// Removes a node from the tree.
  ///
  /// Also removes any connections involving this node.
  void removeNode(String id) {
    _nodes.remove(id);
    _connections.removeWhere((c) => c.fromId == id || c.toId == id);
  }

  /// Adds a connection between nodes.
  void addConnection(SkillConnection connection) {
    _connections.add(connection);
  }

  /// Removes a specific connection.
  void removeConnection(String fromId, String toId) {
    _connections.removeWhere((c) => c.fromId == fromId && c.toId == toId);
  }

  /// Computes the current state of a node.
  ///
  /// Returns [SkillState.locked] if the node doesn't exist.
  SkillState getNodeState(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return SkillState.locked;

    // Check if maxed
    if (node.isMaxed) return SkillState.maxed;

    // Check if unlocked but not maxed
    if (node.isUnlocked) return SkillState.unlocked;

    // Check prerequisites
    if (!arePrerequisitesMet(nodeId)) return SkillState.locked;

    // Check exclusive connections
    if (_isLockedByExclusive(nodeId)) return SkillState.locked;

    // Check if we have enough points
    if (_availablePoints >= node.nextCost) return SkillState.available;

    return SkillState.locked;
  }

  /// Checks if this node can be unlocked right now.
  bool canUnlock(String nodeId) {
    return getNodeState(nodeId) == SkillState.available;
  }

  /// Checks if all prerequisites for a node are met.
  ///
  /// A prerequisite is met if the node is unlocked (level > 0).
  bool arePrerequisitesMet(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null) return false;

    for (final prereqId in node.prerequisites) {
      final prereq = _nodes[prereqId];
      if (prereq == null || !prereq.isUnlocked) {
        return false;
      }
    }

    // Also check required connections
    for (final connection in _connections) {
      if (connection.toId == nodeId &&
          connection.type == ConnectionType.required) {
        final fromNode = _nodes[connection.fromId];
        if (fromNode == null || !fromNode.isUnlocked) {
          return false;
        }
      }
    }

    return true;
  }

  /// Checks if this node is locked due to an exclusive connection.
  bool _isLockedByExclusive(String nodeId) {
    // Find exclusive connections where this node is a target
    for (final connection in _connections) {
      if (connection.type == ConnectionType.exclusive &&
          connection.toId == nodeId) {
        // Check if any sibling (other exclusive target from same source)
        // is already unlocked
        for (final other in _connections) {
          if (other.type == ConnectionType.exclusive &&
              other.fromId == connection.fromId &&
              other.toId != nodeId) {
            final siblingNode = _nodes[other.toId];
            if (siblingNode != null && siblingNode.isUnlocked) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  /// Attempts to unlock or level up a node.
  ///
  /// Returns an [UnlockResult] indicating success or failure.
  UnlockResult<T> unlock(String nodeId) {
    final node = _nodes[nodeId];

    // Node not found
    if (node == null) {
      return UnlockResult<T>.failure(
        reason: UnlockFailureReason.nodeNotFound,
      );
    }

    // Already maxed
    if (node.isMaxed) {
      return UnlockResult<T>.failure(
        reason: UnlockFailureReason.alreadyMaxed,
        node: node,
      );
    }

    // Check prerequisites
    if (!arePrerequisitesMet(nodeId)) {
      return UnlockResult<T>.failure(
        reason: UnlockFailureReason.prerequisitesNotMet,
        node: node,
      );
    }

    // Check exclusive lock
    if (_isLockedByExclusive(nodeId)) {
      return UnlockResult<T>.failure(
        reason: UnlockFailureReason.lockedByExclusive,
        node: node,
      );
    }

    // Check points
    final cost = node.nextCost;
    if (_availablePoints < cost) {
      return UnlockResult<T>.failure(
        reason: UnlockFailureReason.insufficientPoints,
        node: node,
      );
    }

    // Perform unlock
    _availablePoints -= cost;
    final newLevel = node.currentLevel + 1;
    final updatedNode = node.copyWith(currentLevel: newLevel);
    _nodes[nodeId] = updatedNode;

    return UnlockResult<T>.success(
      node: updatedNode,
      pointsSpent: cost,
      newLevel: newLevel,
    );
  }

  /// Resets all nodes to level 0 and refunds all spent points.
  void reset() {
    final refund = spentPoints;
    for (final entry in _nodes.entries.toList()) {
      _nodes[entry.key] = entry.value.copyWith(currentLevel: 0);
    }
    _availablePoints += refund;
  }

  /// Resets a specific node and refunds its spent points.
  ///
  /// Note: This may leave dependent nodes in an invalid state
  /// (unlocked without prerequisites). Consider validating after.
  void resetNode(String nodeId) {
    final node = _nodes[nodeId];
    if (node == null || !node.isUnlocked) return;

    final refund = node.totalSpent;
    _nodes[nodeId] = node.copyWith(currentLevel: 0);
    _availablePoints += refund;
  }

  /// Adds points to the available pool.
  void addPoints(int amount) {
    if (amount < 0) return;
    _availablePoints += amount;
  }

  /// Removes points from the available pool.
  ///
  /// Cannot reduce below 0.
  void removePoints(int amount) {
    if (amount < 0) return;
    _availablePoints = (_availablePoints - amount).clamp(0, _availablePoints);
  }

  /// Sets the available points to a specific value.
  void setPoints(int amount) {
    if (amount < 0) return;
    _availablePoints = amount;
  }

  /// Converts the entire tree to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'availablePoints': _availablePoints,
      'nodes': _nodes.values.map((n) => n.toJson()).toList(),
      'connections': _connections.map((c) => c.toJson()).toList(),
    };
  }

  /// Exports only the progress (unlocked state) for save games.
  ///
  /// Returns a compact map of node IDs to their current levels.
  Map<String, dynamic> exportProgress() {
    final nodeProgress = <String, int>{};
    for (final node in _nodes.values) {
      if (node.currentLevel > 0) {
        nodeProgress[node.id] = node.currentLevel;
      }
    }
    return {
      'availablePoints': _availablePoints,
      'nodes': nodeProgress,
    };
  }

  /// Imports progress from a previously exported save.
  ///
  /// This updates node levels and available points without
  /// changing the tree structure.
  void importProgress(Map<String, dynamic> progress) {
    // Reset all nodes first
    for (final entry in _nodes.entries.toList()) {
      _nodes[entry.key] = entry.value.copyWith(currentLevel: 0);
    }

    // Apply saved progress
    _availablePoints = progress['availablePoints'] as int? ?? 0;

    final nodeProgress = progress['nodes'] as Map<String, dynamic>? ?? {};
    for (final entry in nodeProgress.entries) {
      final node = _nodes[entry.key];
      if (node != null) {
        final level = entry.value as int;
        _nodes[entry.key] = node.copyWith(
          currentLevel: level.clamp(0, node.maxLevel),
        );
      }
    }
  }

  /// Creates a skill tree from a JSON map.
  factory SkillTree.fromJson(Map<String, dynamic> json) {
    final nodesList = (json['nodes'] as List<dynamic>?)
        ?.map((n) => SkillNode<T>.fromJson(n as Map<String, dynamic>))
        .toList();

    final connectionsList = (json['connections'] as List<dynamic>?)
        ?.map((c) => SkillConnection.fromJson(c as Map<String, dynamic>))
        .toList();

    return SkillTree<T>(
      id: json['id'] as String,
      name: json['name'] as String,
      nodes: nodesList,
      connections: connectionsList,
      availablePoints: json['availablePoints'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'SkillTree(id: $id, name: $name, '
        'nodes: ${_nodes.length}, points: $_availablePoints)';
  }
}
