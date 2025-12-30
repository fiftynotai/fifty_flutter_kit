/// **APIConfiguration**
///
/// Centralized configuration for API endpoints and environment selection.
///
/// **Why**
/// - Provide a single source of truth for all API base URLs and endpoints.
/// - Enable easy switching between staging and production environments.
/// - Prevent hardcoded URLs scattered across service classes.
///
/// **Key Features**
/// - `isDevelopment` flag to toggle between staging and production.
/// - Module-specific URL constants (auth, posts, etc.).
/// - Type-safe, compile-time constants for all endpoints.
///
/// **Usage Pattern**
/// All service classes should use these URLs instead of hardcoding them:
/// ```dart
/// class PostService extends ApiService {
///   Future<List<PostModel>> fetchPosts() async {
///     final response = await get(APIConfiguration.postsUrl);
///     return postModelFromJson(response.body);
///   }
/// }
/// ```
///
/// **Environment Configuration**
/// ```dart
/// final url = APIConfiguration.signInUrl; // Uses staging or production based on isDevelopment
/// ```
///
// ────────────────────────────────────────────────
class APIConfiguration {
  /// TODO: Set the value to `false` before pushing to the repository.
  /// This flag determines whether the app is running in development mode.
  static const bool isDevelopment = true;

  /// The base URL for the staging environment.
  ///
  /// Currently set to JSONPlaceholder for demonstration purposes.
  /// Replace with your actual staging API URL.
  static const String _stagingUrl = 'https://jsonplaceholder.typicode.com';

  /// The base URL for the production environment.
  ///
  /// Currently set to JSONPlaceholder for demonstration purposes.
  /// Replace with your actual production API URL.
  static const String _productionUrl = 'https://jsonplaceholder.typicode.com';

  /// The base URL used in the application.
  ///
  /// If `isDevelopment` is true, the staging URL will be used; otherwise, the production URL.
  static const String baseUrl = isDevelopment ? _stagingUrl : _productionUrl;

  // ────────────────────────────────────────────────
  // Auth Module URLs
  // ────────────────────────────────────────────────

  /// URL for signing in to the application.
  static const String signInUrl = '$baseUrl/signin';

  /// URL for signing up a new user.
  static const String signUpUrl = '$baseUrl/signup';

  /// URL for refreshing an existing user session.
  static const String refreshSessionUrl = '$baseUrl/token/refresh';

  // ────────────────────────────────────────────────
  // Posts Module URLs (Example)
  // ────────────────────────────────────────────────

  /// URL for fetching posts from JSONPlaceholder API.
  ///
  /// This is a demonstration endpoint using a free public API.
  /// Replace with your own posts endpoint when adapting this template.
  static const String postsUrl = '$baseUrl/posts';

  // ────────────────────────────────────────────────
  // NASA API Configuration
  // ────────────────────────────────────────────────

  /// NASA API key for accessing public NASA data endpoints.
  ///
  /// DEMO_KEY is rate-limited (30 requests/hour, 50 requests/day per IP).
  /// For production, register at https://api.nasa.gov for a free key.
  static const String nasaApiKey = 'DEMO_KEY';

  /// Base URL for all NASA API endpoints.
  static const String nasaBaseUrl = 'https://api.nasa.gov';

  /// Astronomy Picture of the Day (APOD) endpoint.
  ///
  /// Returns a different space image/video each day with explanation.
  /// Supports date range queries and random image selection.
  static const String apodEndpoint = '/planetary/apod';

  /// Near Earth Object (NEO) feed endpoint.
  ///
  /// Returns a list of asteroids based on their closest approach date.
  /// Requires start_date and end_date query parameters.
  static const String neoEndpoint = '/neo/rest/v1/feed';

  /// Mars Rover Photos endpoint.
  ///
  /// Returns photos taken by Mars rovers (Curiosity, Opportunity, Spirit).
  /// Supports filtering by sol, camera, and Earth date.
  static const String marsPhotosEndpoint = '/mars-photos/api/v1/rovers';
}
