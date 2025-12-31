import 'package:get/get.dart';
import 'package:fifty_utils/fifty_utils.dart';
import '/src/modules/space/data/models/apod_model.dart';
import '/src/modules/space/data/models/neo_model.dart';
import '/src/modules/space/data/models/mars_photo_model.dart';
import '/src/modules/space/data/services/nasa_service.dart';

/// **SpaceViewModel**
///
/// GetX controller responsible for managing space data state and
/// orchestrating data fetching via [NasaService].
///
/// This ViewModel demonstrates the template's recommended API pattern:
/// **apiFetch() -> ApiResponse -> ApiHandler**
///
/// **Why**
/// - Encapsulates space data business logic separate from UI.
/// - Provides reactive [ApiResponse] state for loading/success/error rendering.
/// - Showcases proper error handling and state management.
/// - Manages multiple independent data streams (APOD, NEO, Mars photos).
///
/// **Key Features**
/// - Reactive observables wrapped in [ApiResponse] for each data type.
/// - Automatic APOD and NEO fetch on initialization.
/// - Configurable rover selection for Mars photos.
/// - Refresh capability for pull-to-refresh or manual reload.
/// - Uses [apiFetch] helper to manage loading/success/error lifecycle.
///
/// **Example Usage**
/// ```dart
/// // In view
/// final spaceVM = Get.find<SpaceViewModel>();
///
/// // Trigger refresh
/// spaceVM.refreshApod();
///
/// // Access state
/// if (spaceVM.apod.value.hasData) {
///   final apodData = spaceVM.apod.value.data;
/// }
///
/// // Change rover and fetch photos
/// spaceVM.selectRover('opportunity');
/// spaceVM.fetchMarsPhotos(sol: 500);
/// ```
///
/// **API Pattern Flow**:
/// ```
/// 1. fetchX() called
/// 2. apiFetch() wraps service call
/// 3. Emits ApiResponse states: loading -> success/error
/// 4. UI reacts via ApiHandler widget
/// ```
class SpaceViewModel extends GetxController {
  /// Service used to fetch space data from NASA APIs.
  final NasaService _nasaService;

  /// NASA API key for requests.
  ///
  /// Uses 'DEMO_KEY' by default (rate-limited).
  /// Replace with your own key from https://api.nasa.gov for production.
  final String _apiKey;

  /// Constructor initializing the NASA service and optional API key.
  SpaceViewModel(this._nasaService, {String apiKey = 'DEMO_KEY'})
      : _apiKey = apiKey;

  // ════════════════════════════════════════════════════════════════
  // Reactive State
  // ════════════════════════════════════════════════════════════════

  /// Observable state holding the API response for Astronomy Picture of the Day.
  ///
  /// Wrapped in [ApiResponse] to track loading/success/error/idle states.
  /// UI widgets observe this via [ApiHandler] for reactive rendering.
  final Rx<ApiResponse<ApodModel>> apod = ApiResponse<ApodModel>.idle().obs;

  /// Observable state holding the API response for Near Earth Objects.
  ///
  /// Contains a list of NEOs approaching Earth within the queried date range.
  final Rx<ApiResponse<List<NeoModel>>> nearEarthObjects =
      ApiResponse<List<NeoModel>>.idle().obs;

  /// Observable state holding the API response for Mars rover photos.
  ///
  /// Contains photos from the selected rover and sol.
  final Rx<ApiResponse<List<MarsPhotoModel>>> marsPhotos =
      ApiResponse<List<MarsPhotoModel>>.idle().obs;

  /// Currently selected Mars rover.
  ///
  /// Options: 'curiosity', 'opportunity', 'spirit'
  final RxString selectedRover = 'curiosity'.obs;

  /// Currently selected Martian sol for Mars photos.
  final RxInt selectedSol = 1000.obs;

  // ════════════════════════════════════════════════════════════════
  // Lifecycle
  // ════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  /// Initializes the ViewModel by fetching initial data.
  void _initialize() {
    fetchApod();
    fetchNearEarthObjects();
  }

  // ════════════════════════════════════════════════════════════════
  // APOD Methods
  // ════════════════════════════════════════════════════════════════

  /// Fetches the Astronomy Picture of the Day from NASA.
  ///
  /// Uses [apiFetch] which:
  /// 1. Emits `loading` state immediately
  /// 2. Calls the service method
  /// 3. Emits `success` with data or `error` with message
  /// 4. Returns a Stream<ApiResponse<T>> for reactive updates
  ///
  /// **Parameters**
  /// - [date]: Optional date in YYYY-MM-DD format to fetch a specific day's APOD.
  ///
  /// **Example**:
  /// ```dart
  /// // Fetch today's APOD
  /// viewModel.fetchApod();
  ///
  /// // Fetch a specific date
  /// viewModel.fetchApod(date: '2023-12-25');
  /// ```
  void fetchApod({String? date}) {
    apiFetch(() => _nasaService.fetchApod(apiKey: _apiKey, date: date))
        .listen((value) => apod.value = value);
  }

  /// Refreshes the APOD data.
  ///
  /// Useful for pull-to-refresh gestures or manual reload.
  void refreshApod() {
    fetchApod();
  }

  // ════════════════════════════════════════════════════════════════
  // NEO Methods
  // ════════════════════════════════════════════════════════════════

  /// Fetches Near Earth Objects for the next 7 days from today.
  ///
  /// Uses [apiFetch] for consistent loading/error state management.
  ///
  /// **Parameters**
  /// - [startDate]: Optional start date in YYYY-MM-DD format.
  /// - [endDate]: Optional end date in YYYY-MM-DD format (max 7 days from start).
  ///
  /// **Example**:
  /// ```dart
  /// // Fetch NEOs for next 7 days
  /// viewModel.fetchNearEarthObjects();
  ///
  /// // Fetch NEOs for specific date range
  /// viewModel.fetchNearEarthObjects(
  ///   startDate: '2023-12-15',
  ///   endDate: '2023-12-17',
  /// );
  /// ```
  void fetchNearEarthObjects({String? startDate, String? endDate}) {
    final now = DateTime.now();
    final start = startDate ?? _formatDate(now);
    final end = endDate ?? _formatDate(now.add(const Duration(days: 7)));

    apiFetch(() => _nasaService.fetchNeoFeed(
          apiKey: _apiKey,
          startDate: start,
          endDate: end,
        )).listen((value) => nearEarthObjects.value = value);
  }

  /// Refreshes the NEO data.
  ///
  /// Useful for pull-to-refresh gestures or manual reload.
  void refreshNearEarthObjects() {
    fetchNearEarthObjects();
  }

  // ════════════════════════════════════════════════════════════════
  // Mars Photos Methods
  // ════════════════════════════════════════════════════════════════

  /// Fetches photos from the selected Mars rover.
  ///
  /// Uses [apiFetch] for consistent loading/error state management.
  ///
  /// **Parameters**
  /// - [sol]: Martian sol (day) to fetch photos from. Defaults to [selectedSol].
  /// - [camera]: Optional camera filter (e.g., 'FHAZ', 'NAVCAM').
  ///
  /// **Example**:
  /// ```dart
  /// // Fetch photos from current rover and sol
  /// viewModel.fetchMarsPhotos();
  ///
  /// // Fetch photos from a specific sol
  /// viewModel.fetchMarsPhotos(sol: 500);
  ///
  /// // Fetch photos from a specific camera
  /// viewModel.fetchMarsPhotos(sol: 1000, camera: 'MAST');
  /// ```
  void fetchMarsPhotos({int? sol, String? camera}) {
    final targetSol = sol ?? selectedSol.value;
    selectedSol.value = targetSol;

    apiFetch(() => _nasaService.fetchMarsPhotos(
          apiKey: _apiKey,
          rover: selectedRover.value,
          sol: targetSol,
          camera: camera,
        )).listen((value) => marsPhotos.value = value);
  }

  /// Selects a Mars rover and optionally fetches its photos.
  ///
  /// **Parameters**
  /// - [rover]: Rover name ('curiosity', 'opportunity', or 'spirit').
  /// - [autoFetch]: Whether to automatically fetch photos after selection.
  ///
  /// **Example**:
  /// ```dart
  /// // Select Opportunity rover and fetch its photos
  /// viewModel.selectRover('opportunity');
  ///
  /// // Select without auto-fetch
  /// viewModel.selectRover('spirit', autoFetch: false);
  /// ```
  void selectRover(String rover, {bool autoFetch = true}) {
    selectedRover.value = rover.toLowerCase();
    if (autoFetch) {
      fetchMarsPhotos();
    }
  }

  /// Refreshes the Mars photos data.
  ///
  /// Useful for pull-to-refresh gestures or manual reload.
  void refreshMarsPhotos() {
    fetchMarsPhotos();
  }

  // ════════════════════════════════════════════════════════════════
  // Utility Methods
  // ════════════════════════════════════════════════════════════════

  /// Refreshes all space data (APOD, NEO, Mars photos).
  ///
  /// Useful for a global refresh action.
  void refreshAll() {
    fetchApod();
    fetchNearEarthObjects();
    fetchMarsPhotos();
  }

  /// Formats a DateTime as YYYY-MM-DD string.
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
