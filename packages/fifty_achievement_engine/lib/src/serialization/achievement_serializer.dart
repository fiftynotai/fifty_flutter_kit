import '../models/models.dart';

/// Utility class for serializing and deserializing achievements.
///
/// Provides static methods for converting achievements to and from JSON,
/// with support for custom data serialization.
///
/// **Example:**
/// ```dart
/// // Serialize achievements with custom data
/// final json = AchievementSerializer.serializeAll<RewardData>(
///   achievements,
///   dataSerializer: (data) => data.toJson(),
/// );
///
/// // Deserialize with custom data
/// final achievements = AchievementSerializer.deserializeAll<RewardData>(
///   json,
///   dataDeserializer: (json) => RewardData.fromJson(json),
/// );
/// ```
class AchievementSerializer {
  AchievementSerializer._();

  /// Serializes a single achievement to a JSON map.
  ///
  /// [achievement] is the achievement to serialize.
  /// [dataSerializer] optionally serializes the custom data.
  static Map<String, dynamic> serialize<T>(
    Achievement<T> achievement, {
    Map<String, dynamic> Function(T data)? dataSerializer,
  }) {
    final json = achievement.toJson();

    // Serialize custom data if serializer provided and data exists
    if (dataSerializer != null && achievement.data != null) {
      json['data'] = dataSerializer(achievement.data as T);
    }

    return json;
  }

  /// Deserializes a single achievement from a JSON map.
  ///
  /// [json] is the JSON map to deserialize.
  /// [dataDeserializer] optionally deserializes the custom data.
  static Achievement<T> deserialize<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? dataDeserializer,
  }) {
    // Parse custom data if deserializer provided
    T? data;
    if (dataDeserializer != null && json['data'] != null) {
      data = dataDeserializer(json['data'] as Map<String, dynamic>);
    }

    final achievement = Achievement<T>.fromJson(json);

    // Return with data if we parsed any
    if (data != null) {
      return achievement.copyWith(data: data);
    }

    return achievement;
  }

  /// Serializes a list of achievements to a JSON list.
  static List<Map<String, dynamic>> serializeAll<T>(
    List<Achievement<T>> achievements, {
    Map<String, dynamic> Function(T data)? dataSerializer,
  }) {
    return achievements
        .map((a) => serialize<T>(a, dataSerializer: dataSerializer))
        .toList();
  }

  /// Deserializes a list of achievements from a JSON list.
  static List<Achievement<T>> deserializeAll<T>(
    List<dynamic> json, {
    T Function(Map<String, dynamic> json)? dataDeserializer,
  }) {
    return json
        .cast<Map<String, dynamic>>()
        .map((j) => deserialize<T>(j, dataDeserializer: dataDeserializer))
        .toList();
  }

  /// Serializes a complete achievement pack with metadata.
  ///
  /// Creates a versioned JSON structure with all achievements
  /// and optional metadata.
  static Map<String, dynamic> serializePack<T>(
    List<Achievement<T>> achievements, {
    required String packId,
    required String packName,
    Map<String, dynamic> Function(T data)? dataSerializer,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'version': '1.0.0',
      'packId': packId,
      'packName': packName,
      'achievements': serializeAll<T>(
        achievements,
        dataSerializer: dataSerializer,
      ),
      'metadata': {
        'achievementCount': achievements.length,
        'totalPoints': achievements.fold(0, (sum, a) => sum + a.points),
        'serializedAt': DateTime.now().toIso8601String(),
        ...?metadata,
      },
    };
  }

  /// Deserializes a complete achievement pack.
  static AchievementPack<T> deserializePack<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic> json)? dataDeserializer,
  }) {
    final achievementsJson = json['achievements'] as List<dynamic>;

    return AchievementPack<T>(
      version: json['version'] as String? ?? '1.0.0',
      packId: json['packId'] as String,
      packName: json['packName'] as String,
      achievements: deserializeAll<T>(
        achievementsJson,
        dataDeserializer: dataDeserializer,
      ),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );
  }

  /// Validates that a JSON map contains valid achievement data.
  ///
  /// Returns a list of validation errors, empty if valid.
  static List<String> validateJson(Map<String, dynamic> json) {
    final errors = <String>[];

    if (json['id'] is! String) {
      errors.add('Missing or invalid "id" field');
    }
    if (json['name'] is! String) {
      errors.add('Missing or invalid "name" field');
    }
    if (json['condition'] is! Map<String, dynamic>) {
      errors.add('Missing or invalid "condition" field');
    } else {
      final conditionJson = json['condition'] as Map<String, dynamic>;
      if (conditionJson['type'] is! String) {
        errors.add('Condition missing "type" field');
      }
    }

    return errors;
  }

  /// Validates a complete achievement pack JSON.
  static List<String> validatePackJson(Map<String, dynamic> json) {
    final errors = <String>[];

    if (json['packId'] is! String) {
      errors.add('Missing or invalid "packId" field');
    }
    if (json['packName'] is! String) {
      errors.add('Missing or invalid "packName" field');
    }
    if (json['achievements'] is! List) {
      errors.add('Missing or invalid "achievements" field');
    } else {
      final achievements = json['achievements'] as List<dynamic>;
      for (int i = 0; i < achievements.length; i++) {
        final achievementErrors = validateJson(
          achievements[i] as Map<String, dynamic>,
        );
        for (final error in achievementErrors) {
          errors.add('Achievement[$i]: $error');
        }
      }
    }

    return errors;
  }
}

/// A container for a group of related achievements.
class AchievementPack<T> {
  /// Creates an achievement pack.
  const AchievementPack({
    required this.version,
    required this.packId,
    required this.packName,
    required this.achievements,
    this.metadata = const {},
  });

  /// Schema version for compatibility.
  final String version;

  /// Unique identifier for this pack.
  final String packId;

  /// Display name for this pack.
  final String packName;

  /// The achievements in this pack.
  final List<Achievement<T>> achievements;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Total points from all achievements in the pack.
  int get totalPoints => achievements.fold(0, (sum, a) => sum + a.points);

  /// Number of achievements in the pack.
  int get count => achievements.length;

  @override
  String toString() {
    return 'AchievementPack($packId: $count achievements, $totalPoints points)';
  }
}
