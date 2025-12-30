import '/src/infrastructure/http/api_service.dart';
import '/src/modules/space/data/models/apod_model.dart';
import '/src/modules/space/data/models/neo_model.dart';
import '/src/modules/space/data/models/mars_photo_model.dart';

/// **NasaService**
///
/// Service layer for handling NASA API requests.
///
/// **Why**
/// - Encapsulates HTTP communication logic away from ViewModels.
/// - Extends [ApiService] to inherit auth headers, error handling, retry logic.
/// - Uses NASA's open APIs for real space data demonstration.
///
/// **Key Features**
/// - Fetches Astronomy Picture of the Day (APOD)
/// - Fetches Near-Earth Objects (NEO) feed
/// - Fetches Mars rover photos
/// - Returns typed model objects for each endpoint
/// - Requires NASA API key for all requests
///
/// **Example Usage**
/// ```dart
/// final nasaService = NasaService();
/// final apod = await nasaService.fetchApod(apiKey: 'YOUR_NASA_API_KEY');
/// ```
///
/// **API Documentation**: https://api.nasa.gov/
///
/// **Note**: Get a free API key at https://api.nasa.gov/#signUp
/// For demo purposes, you can use 'DEMO_KEY' (limited to 30 requests/hour).
class NasaService extends ApiService {
  /// Base URL for NASA API endpoints.
  static const String _nasaBaseUrl = 'https://api.nasa.gov';

  /// APOD endpoint path.
  static const String _apodPath = '/planetary/apod';

  /// NEO Feed endpoint path.
  static const String _neoFeedPath = '/neo/rest/v1/feed';

  /// Mars Rover Photos base endpoint path.
  static const String _marsPhotosBasePath = '/mars-photos/api/v1/rovers';

  /// **fetchApod**
  ///
  /// Fetches NASA's Astronomy Picture of the Day.
  ///
  /// [apiKey] is your NASA API key (or 'DEMO_KEY' for testing).
  /// [date] is an optional date in YYYY-MM-DD format to get a specific day's image.
  ///
  /// **Returns**: An [ApodModel] containing the image/video data.
  ///
  /// **Throws**: Exception if the API call fails or response is invalid.
  ///
  /// **Example**:
  /// ```dart
  /// final apod = await nasaService.fetchApod(apiKey: 'DEMO_KEY');
  /// print(apod.title); // "The Eagle Nebula from Hubble"
  /// ```
  Future<ApodModel> fetchApod({
    required String apiKey,
    String? date,
  }) async {
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      if (date != null) 'date': date,
    };

    final response = await get(
      '$_nasaBaseUrl$_apodPath',
      query: queryParams,
      headers: getUnauthorizedHeader(),
      useCache: true,
    );

    return ApodModel.fromJson(response.body);
  }

  /// **fetchNeoFeed**
  ///
  /// Fetches Near-Earth Objects from NASA's NEO Feed API.
  ///
  /// [apiKey] is your NASA API key (or 'DEMO_KEY' for testing).
  /// [startDate] is the start date for the search in YYYY-MM-DD format.
  /// [endDate] is the end date for the search in YYYY-MM-DD format.
  ///
  /// **Note**: The feed date range is limited to 7 days maximum by NASA.
  ///
  /// **Returns**: A list of [NeoModel] objects for NEOs in the date range.
  ///
  /// **Throws**: Exception if the API call fails or response is invalid.
  ///
  /// **Example**:
  /// ```dart
  /// final neos = await nasaService.fetchNeoFeed(
  ///   apiKey: 'DEMO_KEY',
  ///   startDate: '2023-12-15',
  ///   endDate: '2023-12-16',
  /// );
  /// print(neos.length); // Number of NEOs found
  /// ```
  Future<List<NeoModel>> fetchNeoFeed({
    required String apiKey,
    required String startDate,
    required String endDate,
  }) async {
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      'start_date': startDate,
      'end_date': endDate,
    };

    final response = await get(
      '$_nasaBaseUrl$_neoFeedPath',
      query: queryParams,
      headers: getUnauthorizedHeader(),
      useCache: true,
    );

    // NASA returns NEOs grouped by date in near_earth_objects map
    final body = response.body as Map<String, dynamic>;
    final nearEarthObjects = body['near_earth_objects'] as Map<String, dynamic>?;

    if (nearEarthObjects == null) {
      return [];
    }

    // Flatten all NEOs from all dates into a single list
    final allNeos = <NeoModel>[];
    for (final dateKey in nearEarthObjects.keys) {
      final neosForDate = nearEarthObjects[dateKey] as List<dynamic>?;
      if (neosForDate != null) {
        allNeos.addAll(neoModelListFromJson(neosForDate));
      }
    }

    return allNeos;
  }

  /// **fetchMarsPhotos**
  ///
  /// Fetches photos from NASA's Mars rovers.
  ///
  /// [apiKey] is your NASA API key (or 'DEMO_KEY' for testing).
  /// [rover] is the rover name: "curiosity", "opportunity", or "spirit".
  /// [sol] is the Martian sol (day) to fetch photos from.
  /// [camera] is an optional camera filter (e.g., "FHAZ", "RHAZ", "MAST").
  /// [page] is the page number for pagination (25 photos per page).
  ///
  /// **Returns**: A list of [MarsPhotoModel] objects.
  ///
  /// **Throws**: Exception if the API call fails or response is invalid.
  ///
  /// **Available Cameras**:
  /// - Curiosity: FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM
  /// - Opportunity/Spirit: FHAZ, RHAZ, NAVCAM, PANCAM, MINITES
  ///
  /// **Example**:
  /// ```dart
  /// final photos = await nasaService.fetchMarsPhotos(
  ///   apiKey: 'DEMO_KEY',
  ///   rover: 'curiosity',
  ///   sol: 1000,
  /// );
  /// print(photos.first.imgSrc); // URL to the photo
  /// ```
  Future<List<MarsPhotoModel>> fetchMarsPhotos({
    required String apiKey,
    required String rover,
    required int sol,
    String? camera,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      'sol': sol.toString(),
      if (camera != null) 'camera': camera,
      if (page != null) 'page': page.toString(),
    };

    final response = await get(
      '$_nasaBaseUrl$_marsPhotosBasePath/$rover/photos',
      query: queryParams,
      headers: getUnauthorizedHeader(),
      useCache: true,
    );

    // NASA returns photos in a 'photos' array
    final body = response.body as Map<String, dynamic>;
    final photosJson = body['photos'] as List<dynamic>?;

    if (photosJson == null) {
      return [];
    }

    return marsPhotoModelFromJson(photosJson);
  }

  /// **fetchMarsPhotosByEarthDate**
  ///
  /// Fetches Mars rover photos by Earth date instead of Martian sol.
  ///
  /// [apiKey] is your NASA API key (or 'DEMO_KEY' for testing).
  /// [rover] is the rover name: "curiosity", "opportunity", or "spirit".
  /// [earthDate] is the Earth date in YYYY-MM-DD format.
  /// [camera] is an optional camera filter.
  /// [page] is the page number for pagination.
  ///
  /// **Returns**: A list of [MarsPhotoModel] objects.
  ///
  /// **Throws**: Exception if the API call fails or response is invalid.
  Future<List<MarsPhotoModel>> fetchMarsPhotosByEarthDate({
    required String apiKey,
    required String rover,
    required String earthDate,
    String? camera,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{
      'api_key': apiKey,
      'earth_date': earthDate,
      if (camera != null) 'camera': camera,
      if (page != null) 'page': page.toString(),
    };

    final response = await get(
      '$_nasaBaseUrl$_marsPhotosBasePath/$rover/photos',
      query: queryParams,
      headers: getUnauthorizedHeader(),
      useCache: true,
    );

    // NASA returns photos in a 'photos' array
    final body = response.body as Map<String, dynamic>;
    final photosJson = body['photos'] as List<dynamic>?;

    if (photosJson == null) {
      return [];
    }

    return marsPhotoModelFromJson(photosJson);
  }
}
