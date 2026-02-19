import 'dart:convert';
import 'package:flutter/services.dart';

import '../components/base/model.dart';

/// **Fifty World Loader Service**
///
/// A utility service for loading and parsing map entities in the Fifty world engine.
///
/// **Current Features:**
/// - Load maps from JSON assets
/// - Deserialize a list of [FiftyWorldEntity] from JSON
/// - Serialize map entities to JSON
///
/// **Usage:**
/// ```dart
/// // Load from asset bundle
/// final entities = await FiftyWorldLoader.loadFromAssets('assets/maps/level1.json');
///
/// // Load from JSON string
/// final entities = FiftyWorldLoader.loadFromJsonString(jsonString);
///
/// // Serialize to JSON
/// final json = FiftyWorldLoader.toJsonString(entities);
/// ```
class FiftyWorldLoader {
  FiftyWorldLoader._();

  /// **Load and parse a JSON asset into map entities**
  ///
  /// - [path]: asset bundle path to a JSON file containing a list of entities
  /// - Throws [FormatException] if the JSON is not a list or elements are invalid.
  static Future<List<FiftyWorldEntity>> loadFromAssets(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw FormatException('Expected JSON list at asset: $path');
    }
    return decoded.map<FiftyWorldEntity>((e) {
      if (e is! Map<String, dynamic>) {
        throw FormatException('Invalid entity JSON: $e');
      }
      return FiftyWorldEntity.fromJson(e);
    }).toList();
  }

  /// **Deserialize from JSON string**
  ///
  /// - [jsonString]: JSON text representing a list of entities
  /// - Throws [FormatException] if parsing fails or structure is invalid.
  static List<FiftyWorldEntity> loadFromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) {
      throw FormatException('Expected JSON list');
    }
    return decoded.map<FiftyWorldEntity>((e) {
      if (e is! Map<String, dynamic>) {
        throw FormatException('Invalid entity JSON: $e');
      }
      return FiftyWorldEntity.fromJson(e);
    }).toList();
  }

  /// **Serialize a list of entities to JSON string**
  static String toJsonString(List<FiftyWorldEntity> entities) {
    final list = entities.map((e) => e.toJson()).toList();
    return jsonEncode(list);
  }
}
