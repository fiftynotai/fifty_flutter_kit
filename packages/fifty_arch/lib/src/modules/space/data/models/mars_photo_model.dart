import 'dart:convert';

/// Converts a JSON List into a list of `MarsPhotoModel` instances.
///
/// [json] is the input JSON list from the NASA Mars Rover Photos API.
///
/// Returns a list of `MarsPhotoModel` objects.
List<MarsPhotoModel> marsPhotoModelFromJson(List<dynamic> json) =>
    List<MarsPhotoModel>.from(json.map((x) => MarsPhotoModel.fromJson(x)));

/// Converts a list of `MarsPhotoModel` instances into a JSON-encoded string.
///
/// [data] is the list of `MarsPhotoModel` to convert.
///
/// Returns the JSON-encoded string representation of the list.
String marsPhotoModelToJson(List<MarsPhotoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// **MarsPhotoModel**
///
/// A model representing a photo taken by NASA's Mars rovers.
///
/// This model is used to demonstrate the template's API integration
/// with NASA's Mars Rover Photos API.
///
/// **Fields**:
/// - `id`: Unique photo identifier
/// - `sol`: Martian sol (day) when the photo was taken
/// - `cameraName`: Short name of the camera (e.g., "FHAZ", "RHAZ")
/// - `cameraFullName`: Full name of the camera
/// - `imgSrc`: URL to the full-size image
/// - `earthDate`: Earth date when the photo was taken (YYYY-MM-DD)
/// - `roverName`: Name of the rover that took the photo
///
/// **Example JSON**:
/// ```json
/// {
///   "id": 102693,
///   "sol": 1000,
///   "camera": {
///     "name": "FHAZ",
///     "full_name": "Front Hazard Avoidance Camera"
///   },
///   "img_src": "http://mars.nasa.gov/msl-raw-images/...",
///   "earth_date": "2015-05-30",
///   "rover": {
///     "name": "Curiosity"
///   }
/// }
/// ```
///
/// **API Source**: https://api.nasa.gov/mars-photos/api/v1/rovers/{rover}/photos
class MarsPhotoModel {
  /// Unique identifier for the photo.
  final int id;

  /// Martian sol (day) when the photo was taken.
  final int sol;

  /// Short name of the camera (e.g., "FHAZ", "RHAZ", "MAST").
  final String cameraName;

  /// Full descriptive name of the camera.
  final String cameraFullName;

  /// URL to the full-size image.
  final String imgSrc;

  /// Earth date when the photo was taken (YYYY-MM-DD format).
  final String earthDate;

  /// Name of the rover that took the photo.
  final String roverName;

  /// Constructor to initialize all required fields.
  MarsPhotoModel({
    required this.id,
    required this.sol,
    required this.cameraName,
    required this.cameraFullName,
    required this.imgSrc,
    required this.earthDate,
    required this.roverName,
  });

  /// Factory method to create a `MarsPhotoModel` from NASA's JSON structure.
  ///
  /// [json] is the JSON map containing the photo details from the API.
  /// This method handles the nested camera and rover objects.
  ///
  /// Returns a `MarsPhotoModel` instance.
  factory MarsPhotoModel.fromJson(Map<String, dynamic> json) {
    // Extract camera info from nested structure
    final camera = json['camera'] as Map<String, dynamic>?;
    final camName = camera?['name'] as String? ?? '';
    final camFullName = camera?['full_name'] as String? ?? '';

    // Extract rover info from nested structure
    final rover = json['rover'] as Map<String, dynamic>?;
    final roverNameValue = rover?['name'] as String? ?? '';

    return MarsPhotoModel(
      id: json['id'] as int? ?? 0,
      sol: json['sol'] as int? ?? 0,
      cameraName: camName,
      cameraFullName: camFullName,
      imgSrc: json['img_src'] as String? ?? '',
      earthDate: json['earth_date'] as String? ?? '',
      roverName: roverNameValue,
    );
  }

  /// Converts the `MarsPhotoModel` instance into a JSON map.
  ///
  /// Note: This produces a flattened structure for simplicity.
  ///
  /// Returns a map representing the `MarsPhotoModel` instance.
  Map<String, dynamic> toJson() => {
        'id': id,
        'sol': sol,
        'camera_name': cameraName,
        'camera_full_name': cameraFullName,
        'img_src': imgSrc,
        'earth_date': earthDate,
        'rover_name': roverName,
      };
}
