import 'dart:ui';

import '../models/models.dart';

/// Utility class for serializing and deserializing skill trees.
///
/// Provides static methods for converting skill trees to and from JSON,
/// with support for custom data serialization.
///
/// **Example:**
/// ```dart
/// // Serialize a tree with custom data
/// final json = TreeSerializer.serialize<AbilityData>(
///   myTree,
///   dataSerializer: (data) => data.toJson(),
/// );
///
/// // Deserialize with custom data
/// final tree = TreeSerializer.deserialize<AbilityData>(
///   json,
///   dataDeserializer: (json) => AbilityData.fromJson(json),
/// );
/// ```
class TreeSerializer {
  TreeSerializer._();

  /// Serializes a skill tree to a JSON map.
  ///
  /// **Parameters:**
  /// - [tree]: The skill tree to serialize
  /// - [dataSerializer]: Optional function to serialize custom node data
  /// - [includeProgress]: Whether to include progress data (default true)
  /// - [includeMetadata]: Whether to include additional metadata (default true)
  ///
  /// **Returns:**
  /// A JSON-serializable map representing the tree.
  static Map<String, dynamic> serialize<T>(
    SkillTree<T> tree, {
    Map<String, dynamic> Function(T data)? dataSerializer,
    bool includeProgress = true,
    bool includeMetadata = true,
  }) {
    final result = <String, dynamic>{
      'id': tree.id,
      'name': tree.name,
      'version': '1.0.0', // Schema version for future compatibility
    };

    // Serialize nodes
    final nodesList = <Map<String, dynamic>>[];
    for (final node in tree.nodes) {
      final nodeJson = _serializeNode<T>(
        node,
        dataSerializer: dataSerializer,
        includeProgress: includeProgress,
      );
      nodesList.add(nodeJson);
    }
    result['nodes'] = nodesList;

    // Serialize connections
    final connectionsList = <Map<String, dynamic>>[];
    for (final connection in tree.connections) {
      connectionsList.add(_serializeConnection(connection));
    }
    result['connections'] = connectionsList;

    // Include progress if requested
    if (includeProgress) {
      result['availablePoints'] = tree.availablePoints;
    }

    // Include metadata if requested
    if (includeMetadata) {
      result['metadata'] = {
        'serializedAt': DateTime.now().toIso8601String(),
        'nodeCount': tree.nodes.length,
        'connectionCount': tree.connections.length,
      };
    }

    return result;
  }

  /// Deserializes a skill tree from a JSON map.
  ///
  /// **Parameters:**
  /// - [json]: The JSON map to deserialize
  /// - [dataDeserializer]: Optional function to deserialize custom node data
  ///
  /// **Returns:**
  /// A new [SkillTree] instance.
  static SkillTree<T> deserialize<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? dataDeserializer,
  }) {
    final id = json['id'] as String;
    final name = json['name'] as String;
    final availablePoints = json['availablePoints'] as int? ?? 0;

    // Deserialize nodes
    final nodesJson = json['nodes'] as List<dynamic>? ?? [];
    final nodes = <SkillNode<T>>[];
    for (final nodeJson in nodesJson) {
      final node = _deserializeNode<T>(
        nodeJson as Map<String, dynamic>,
        dataDeserializer: dataDeserializer,
      );
      nodes.add(node);
    }

    // Deserialize connections
    final connectionsJson = json['connections'] as List<dynamic>? ?? [];
    final connections = <SkillConnection>[];
    for (final connJson in connectionsJson) {
      final connection =
          _deserializeConnection(connJson as Map<String, dynamic>);
      connections.add(connection);
    }

    return SkillTree<T>(
      id: id,
      name: name,
      nodes: nodes,
      connections: connections,
      availablePoints: availablePoints,
    );
  }

  /// Serializes just the progress data from a tree.
  ///
  /// This is more compact than full serialization and is suitable
  /// for save files where the tree structure is known.
  static Map<String, dynamic> serializeProgress<T>(SkillTree<T> tree) {
    return tree.exportProgress();
  }

  /// Applies deserialized progress to an existing tree.
  ///
  /// Use this when you have a pre-defined tree structure and
  /// just need to restore progress.
  static void applyProgress<T>(
    SkillTree<T> tree,
    Map<String, dynamic> progress,
  ) {
    tree.importProgress(progress);
  }

  // ---- Private Helper Methods ----

  /// Serializes a single node.
  static Map<String, dynamic> _serializeNode<T>(
    SkillNode<T> node, {
    Map<String, dynamic> Function(T data)? dataSerializer,
    required bool includeProgress,
  }) {
    final json = <String, dynamic>{
      'id': node.id,
      'name': node.name,
      if (node.description != null) 'description': node.description,
      'maxLevel': node.maxLevel,
      'costs': node.costs,
      'prerequisites': node.prerequisites,
      'type': node.type.name,
      if (node.branch != null) 'branch': node.branch,
      'tier': node.tier,
    };

    // Include position if set
    if (node.position != null) {
      json['position'] = {
        'dx': node.position!.dx,
        'dy': node.position!.dy,
      };
    }

    // Include progress if requested
    if (includeProgress) {
      json['currentLevel'] = node.currentLevel;
    }

    // Serialize custom data if serializer provided and data exists
    if (dataSerializer != null && node.data != null) {
      json['data'] = dataSerializer(node.data as T);
    }

    return json;
  }

  /// Deserializes a single node.
  static SkillNode<T> _deserializeNode<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? dataDeserializer,
  }) {
    // Parse position if present
    Offset? position;
    if (json['position'] != null) {
      final posJson = json['position'] as Map<String, dynamic>;
      position = Offset(
        (posJson['dx'] as num).toDouble(),
        (posJson['dy'] as num).toDouble(),
      );
    }

    // Parse custom data if deserializer provided
    T? data;
    if (dataDeserializer != null && json['data'] != null) {
      data = dataDeserializer(json['data'] as Map<String, dynamic>);
    }

    return SkillNode<T>(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      currentLevel: json['currentLevel'] as int? ?? 0,
      maxLevel: json['maxLevel'] as int? ?? 1,
      costs: (json['costs'] as List<dynamic>?)?.cast<int>() ?? const [1],
      prerequisites:
          (json['prerequisites'] as List<dynamic>?)?.cast<String>() ?? const [],
      type: SkillType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => SkillType.passive,
      ),
      branch: json['branch'] as String?,
      tier: json['tier'] as int? ?? 0,
      position: position,
      data: data,
    );
  }

  /// Serializes a single connection.
  static Map<String, dynamic> _serializeConnection(SkillConnection connection) {
    return connection.toJson();
  }

  /// Deserializes a single connection.
  static SkillConnection _deserializeConnection(Map<String, dynamic> json) {
    return SkillConnection.fromJson(json);
  }
}

/// Extension methods for easy serialization on [SkillTree].
extension SkillTreeSerializationExtension<T> on SkillTree<T> {
  /// Serializes this tree to JSON.
  ///
  /// Shortcut for [TreeSerializer.serialize].
  Map<String, dynamic> serialize({
    Map<String, dynamic> Function(T data)? dataSerializer,
    bool includeProgress = true,
    bool includeMetadata = true,
  }) {
    return TreeSerializer.serialize<T>(
      this,
      dataSerializer: dataSerializer,
      includeProgress: includeProgress,
      includeMetadata: includeMetadata,
    );
  }
}
