/// **Space Module**
///
/// A module demonstrating NASA API integration patterns.
///
/// This module provides data layer components for fetching space-related
/// data from NASA's open APIs including:
/// - Astronomy Picture of the Day (APOD)
/// - Near-Earth Objects (NEO)
/// - Mars Rover Photos
///
/// **Usage**:
/// ```dart
/// import 'package:fifty_arch/src/modules/space/space.dart';
///
/// final nasaService = NasaService();
/// final apod = await nasaService.fetchApod(apiKey: 'DEMO_KEY');
/// ```
///
/// **API Key**: Get a free NASA API key at https://api.nasa.gov/#signUp
/// For testing, use 'DEMO_KEY' (rate limited to 30 requests/hour).
library;

// Data Models
export 'data/models/apod_model.dart';
export 'data/models/neo_model.dart';
export 'data/models/mars_photo_model.dart';

// Services
export 'data/services/nasa_service.dart';

// Controllers
export 'controllers/space_view_model.dart';

// Actions
export 'actions/space_actions.dart';

// Bindings
export 'space_bindings.dart';

// Views
export 'views/orbital_command_page.dart';
export 'views/widgets/apod_card.dart';
export 'views/widgets/neo_list_tile.dart';
export 'views/widgets/mars_photo_card.dart';
export 'views/widgets/status_panel.dart';
