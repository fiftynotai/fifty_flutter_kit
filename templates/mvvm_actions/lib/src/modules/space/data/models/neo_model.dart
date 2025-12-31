import 'dart:convert';

/// Converts a JSON List of NEO objects into a list of `NeoModel` instances.
///
/// [json] is the input JSON list from the NASA NEO API (near_earth_objects values).
///
/// Returns a list of `NeoModel` objects.
List<NeoModel> neoModelListFromJson(List<dynamic> json) =>
    List<NeoModel>.from(json.map((x) => NeoModel.fromJson(x)));

/// Converts a list of `NeoModel` instances into a JSON-encoded string.
///
/// [data] is the list of `NeoModel` to convert.
///
/// Returns the JSON-encoded string representation of the list.
String neoModelListToJson(List<NeoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// **NeoModel**
///
/// A model representing a Near-Earth Object (NEO) from NASA's API.
///
/// This model handles the nested JSON structure from NASA's NEO Feed API,
/// extracting relevant data about asteroids that pass near Earth.
///
/// **Fields**:
/// - `id`: Unique NEO identifier
/// - `name`: Name/designation of the asteroid
/// - `estimatedDiameterMin`: Minimum estimated diameter in kilometers
/// - `estimatedDiameterMax`: Maximum estimated diameter in kilometers
/// - `closeApproachDate`: Date of closest approach to Earth
/// - `relativeVelocity`: Velocity relative to Earth in km/h
/// - `missDistance`: Distance from Earth at closest approach in kilometers
/// - `isPotentiallyHazardous`: Whether the asteroid is classified as hazardous
///
/// **Example JSON** (nested structure from NASA API):
/// ```json
/// {
///   "id": "3542519",
///   "name": "(2010 PK9)",
///   "estimated_diameter": {
///     "kilometers": {
///       "estimated_diameter_min": 0.0366906138,
///       "estimated_diameter_max": 0.0820427065
///     }
///   },
///   "is_potentially_hazardous_asteroid": false,
///   "close_approach_data": [{
///     "close_approach_date": "2023-12-15",
///     "relative_velocity": { "kilometers_per_hour": "65432.1" },
///     "miss_distance": { "kilometers": "7500000" }
///   }]
/// }
/// ```
///
/// **API Source**: https://api.nasa.gov/neo/rest/v1/feed
class NeoModel {
  /// Unique identifier for the NEO.
  final String id;

  /// Name or designation of the asteroid.
  final String name;

  /// Minimum estimated diameter in kilometers.
  final double estimatedDiameterMin;

  /// Maximum estimated diameter in kilometers.
  final double estimatedDiameterMax;

  /// Date of closest approach to Earth.
  final DateTime closeApproachDate;

  /// Velocity relative to Earth in kilometers per hour.
  final double relativeVelocity;

  /// Distance from Earth at closest approach in kilometers.
  final double missDistance;

  /// Whether the asteroid is classified as potentially hazardous.
  final bool isPotentiallyHazardous;

  /// Constructor to initialize all required fields.
  NeoModel({
    required this.id,
    required this.name,
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
    required this.closeApproachDate,
    required this.relativeVelocity,
    required this.missDistance,
    required this.isPotentiallyHazardous,
  });

  /// Factory method to create a `NeoModel` from NASA's nested JSON structure.
  ///
  /// [json] is the JSON map containing the NEO details from the API.
  /// This method handles the deeply nested structure of NASA's response.
  ///
  /// Returns a `NeoModel` instance.
  factory NeoModel.fromJson(Map<String, dynamic> json) {
    // Extract diameter from nested structure
    final diameter = json['estimated_diameter'] as Map<String, dynamic>?;
    final kmDiameter = diameter?['kilometers'] as Map<String, dynamic>?;
    final minDiameter = (kmDiameter?['estimated_diameter_min'] as num?)?.toDouble() ?? 0.0;
    final maxDiameter = (kmDiameter?['estimated_diameter_max'] as num?)?.toDouble() ?? 0.0;

    // Extract close approach data (use first entry if available)
    final closeApproachData = json['close_approach_data'] as List<dynamic>?;
    final firstApproach = closeApproachData?.isNotEmpty == true
        ? closeApproachData!.first as Map<String, dynamic>
        : <String, dynamic>{};

    // Parse close approach date
    final dateString = firstApproach['close_approach_date'] as String? ?? '';
    final approachDate = dateString.isNotEmpty
        ? DateTime.tryParse(dateString) ?? DateTime.now()
        : DateTime.now();

    // Extract velocity from nested structure
    final velocityData = firstApproach['relative_velocity'] as Map<String, dynamic>?;
    final velocityString = velocityData?['kilometers_per_hour'] as String? ?? '0';
    final velocity = double.tryParse(velocityString) ?? 0.0;

    // Extract miss distance from nested structure
    final missData = firstApproach['miss_distance'] as Map<String, dynamic>?;
    final missString = missData?['kilometers'] as String? ?? '0';
    final miss = double.tryParse(missString) ?? 0.0;

    return NeoModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      estimatedDiameterMin: minDiameter,
      estimatedDiameterMax: maxDiameter,
      closeApproachDate: approachDate,
      relativeVelocity: velocity,
      missDistance: miss,
      isPotentiallyHazardous: json['is_potentially_hazardous_asteroid'] as bool? ?? false,
    );
  }

  /// Converts the `NeoModel` instance into a JSON map.
  ///
  /// Note: This produces a flattened structure, not the original nested format.
  ///
  /// Returns a map representing the `NeoModel` instance.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'estimated_diameter_min_km': estimatedDiameterMin,
        'estimated_diameter_max_km': estimatedDiameterMax,
        'close_approach_date': closeApproachDate.toIso8601String().split('T').first,
        'relative_velocity_kmh': relativeVelocity,
        'miss_distance_km': missDistance,
        'is_potentially_hazardous': isPotentiallyHazardous,
      };
}
