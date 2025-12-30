import 'dart:convert';
import 'package:flutter/services.dart';

import '../components/base/model.dart';

/// **Fifty Map Loader Service**
///
/// A utility service for loading and parsing map entities in the Fifty map engine.
///
/// **Current Features:**
/// - Load maps from JSON assets
/// - Deserialize a list of [FiftyMapEntity] from JSON
/// - Serialize map entities to JSON
///
/// **Usage:**
/// ```dart
/// // Load from asset bundle
/// final entities = await FiftyMapLoader.loadFromAssets('assets/maps/level1.json');
///
/// // Load from JSON string
/// final entities = FiftyMapLoader.loadFromJsonString(jsonString);
///
/// // Serialize to JSON
/// final json = FiftyMapLoader.toJsonString(entities);
/// ```
class FiftyMapLoader {
  FiftyMapLoader._();

  /// **Load and parse a JSON asset into map entities**
  ///
  /// - [path]: asset bundle path to a JSON file containing a list of entities
  /// - Throws [FormatException] if the JSON is not a list or elements are invalid.
  static Future<List<FiftyMapEntity>> loadFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw FormatException('Expected JSON list at asset: $path');
    }
    return decoded.map<FiftyMapEntity>((e) {
      if (e is! Map<String, dynamic>) {
        throw FormatException('Invalid entity JSON: $e');
      }
      return FiftyMapEntity.fromJson(e);
    }).toList();
  }

  /// **Deserialize from JSON string**
  ///
  /// - [jsonString]: JSON text representing a list of entities
  /// - Throws [FormatException] if parsing fails or structure is invalid.
  static List<FiftyMapEntity> loadFromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw FormatException('Expected JSON list');
    }
    return decoded.map<FiftyMapEntity>((e) {
      if (e is! Map<String, dynamic>) {
        throw FormatException('Invalid entity JSON: $e');
      }
      return FiftyMapEntity.fromJson(e);
    }).toList();
  }

  /// **Serialize a list of entities to JSON string**
  static String toJsonString(List<FiftyMapEntity> entities) {
    final list = entities.map((e) => e.toJson()).toList();
    return jsonEncode(list);
  }
}
