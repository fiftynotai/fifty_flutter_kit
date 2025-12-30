import 'dart:convert';

/// Converts a JSON map into an `ApodModel` instance.
///
/// [json] is the input JSON map from the NASA APOD API.
///
/// Returns an `ApodModel` object.
ApodModel apodModelFromJson(Map<String, dynamic> json) =>
    ApodModel.fromJson(json);

/// Converts an `ApodModel` instance into a JSON-encoded string.
///
/// [data] is the `ApodModel` to convert.
///
/// Returns the JSON-encoded string representation.
String apodModelToJson(ApodModel data) => json.encode(data.toJson());

/// **ApodModel**
///
/// A model representing NASA's Astronomy Picture of the Day (APOD).
///
/// This model is used to demonstrate the template's API integration
/// patterns with NASA's open API: apiFetch() -> ApiResponse -> ApiHandler.
///
/// **Fields**:
/// - `title`: Title of the astronomy picture
/// - `explanation`: Detailed description of the image
/// - `url`: URL to the standard resolution image/video
/// - `hdurl`: Optional URL to high definition version
/// - `date`: Date the image was featured (YYYY-MM-DD)
/// - `mediaType`: Type of media ("image" or "video")
/// - `copyright`: Optional copyright holder information
///
/// **Example JSON**:
/// ```json
/// {
///   "title": "The Eagle Nebula from Hubble",
///   "explanation": "The Eagle Nebula spans about 20 light-years...",
///   "url": "https://apod.nasa.gov/apod/image/2312/EagleNebula.jpg",
///   "hdurl": "https://apod.nasa.gov/apod/image/2312/EagleNebula_hd.jpg",
///   "date": "2023-12-15",
///   "media_type": "image",
///   "copyright": "NASA, ESA, Hubble"
/// }
/// ```
///
/// **API Source**: https://api.nasa.gov/planetary/apod
class ApodModel {
  /// Title of the astronomy picture.
  final String title;

  /// Detailed explanation/description of the image.
  final String explanation;

  /// URL to the standard resolution image or video.
  final String url;

  /// Optional URL to high definition version.
  final String? hdurl;

  /// Date the image was featured (YYYY-MM-DD format).
  final String date;

  /// Type of media: "image" or "video".
  final String mediaType;

  /// Optional copyright holder information.
  final String? copyright;

  /// Constructor to initialize all fields.
  ApodModel({
    required this.title,
    required this.explanation,
    required this.url,
    this.hdurl,
    required this.date,
    required this.mediaType,
    this.copyright,
  });

  /// Factory method to create an `ApodModel` from a JSON map.
  ///
  /// [json] is the JSON map containing the APOD details from the API.
  ///
  /// Returns an `ApodModel` instance.
  factory ApodModel.fromJson(Map<String, dynamic> json) => ApodModel(
        title: json['title'] as String,
        explanation: json['explanation'] as String,
        url: json['url'] as String,
        hdurl: json['hdurl'] as String?,
        date: json['date'] as String,
        mediaType: json['media_type'] as String,
        copyright: json['copyright'] as String?,
      );

  /// Converts the `ApodModel` instance into a JSON map.
  ///
  /// Returns a map representing the `ApodModel` instance.
  Map<String, dynamic> toJson() => {
        'title': title,
        'explanation': explanation,
        'url': url,
        'hdurl': hdurl,
        'date': date,
        'media_type': mediaType,
        'copyright': copyright,
      };
}
