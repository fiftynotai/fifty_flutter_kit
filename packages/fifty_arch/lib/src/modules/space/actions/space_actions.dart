import 'package:flutter/material.dart';
import '/src/core/presentation/actions/action_presenter.dart';
import '/src/modules/space/controllers/space_view_model.dart';

/// **SpaceActions**
///
/// High-level user intents for space data screens. Wraps calls to
/// [SpaceViewModel] with a loader overlay and unified error handling via
/// [ActionPresenter]. Intended to be used directly from views.
///
/// **Why**
/// - Centralizes UX concerns (loader, toasts/snackbars, error surfaces).
/// - Keeps views thin: user interactions are handled here with proper feedback.
/// - Provides consistent loading states across all space-related operations.
///
/// **Key Features**
/// - Shows a global loader while actions execute.
/// - Catches exceptions, reports errors, and shows user feedback.
/// - Provides action methods for all space data operations.
///
/// **Example Usage**
/// ```dart
/// // From SpacePage on button press:
/// final actions = Get.find<SpaceActions>();
/// await actions.loadApod(context);
///
/// // Refresh all data:
/// await actions.refreshAll(context);
/// ```
///
// ────────────────────────────────────────────────
class SpaceActions {
  /// The ViewModel containing space data business logic.
  final SpaceViewModel _viewModel;

  /// The action presenter for handling loading states and errors.
  final ActionPresenter _presenter;

  /// Constructor initializing the ViewModel and presenter.
  SpaceActions(this._viewModel, this._presenter);

  // ════════════════════════════════════════════════════════════════
  // APOD Actions
  // ════════════════════════════════════════════════════════════════

  /// **loadApod**
  ///
  /// Loads the Astronomy Picture of the Day with loading overlay and
  /// error handling.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  /// - `date`: Optional date in YYYY-MM-DD format to fetch a specific day's APOD.
  ///
  /// **Side Effects**
  /// - Displays a global loader overlay while the action runs.
  /// - On error, shows an error snackbar via [ActionPresenter].
  ///
  /// **Example**:
  /// ```dart
  /// // Load today's APOD
  /// await spaceActions.loadApod(context);
  ///
  /// // Load a specific date
  /// await spaceActions.loadApod(context, date: '2023-12-25');
  /// ```
  // ────────────────────────────────────────────────
  Future<void> loadApod(BuildContext context, {String? date}) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.fetchApod(date: date);
      // Note: fetchApod is async via stream, so we don't await it directly
      // The loading state is managed by ApiResponse in the ViewModel
    });
  }

  // ════════════════════════════════════════════════════════════════
  // NEO Actions
  // ════════════════════════════════════════════════════════════════

  /// **loadNeoData**
  ///
  /// Loads Near Earth Objects data with loading overlay and error handling.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  /// - `startDate`: Optional start date in YYYY-MM-DD format.
  /// - `endDate`: Optional end date in YYYY-MM-DD format.
  ///
  /// **Side Effects**
  /// - Displays a global loader overlay while the action runs.
  /// - On error, shows an error snackbar via [ActionPresenter].
  ///
  /// **Example**:
  /// ```dart
  /// // Load NEOs for next 7 days
  /// await spaceActions.loadNeoData(context);
  ///
  /// // Load NEOs for specific range
  /// await spaceActions.loadNeoData(
  ///   context,
  ///   startDate: '2023-12-15',
  ///   endDate: '2023-12-17',
  /// );
  /// ```
  // ────────────────────────────────────────────────
  Future<void> loadNeoData(
    BuildContext context, {
    String? startDate,
    String? endDate,
  }) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.fetchNearEarthObjects(startDate: startDate, endDate: endDate);
    });
  }

  // ════════════════════════════════════════════════════════════════
  // Mars Photos Actions
  // ════════════════════════════════════════════════════════════════

  /// **loadMarsPhotos**
  ///
  /// Loads Mars rover photos with loading overlay and error handling.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  /// - `sol`: Martian sol (day) to fetch photos from. Defaults to 1000.
  /// - `camera`: Optional camera filter (e.g., 'FHAZ', 'NAVCAM').
  ///
  /// **Side Effects**
  /// - Displays a global loader overlay while the action runs.
  /// - On error, shows an error snackbar via [ActionPresenter].
  ///
  /// **Example**:
  /// ```dart
  /// // Load photos from current rover settings
  /// await spaceActions.loadMarsPhotos(context);
  ///
  /// // Load photos from a specific sol
  /// await spaceActions.loadMarsPhotos(context, sol: 500);
  /// ```
  // ────────────────────────────────────────────────
  Future<void> loadMarsPhotos(
    BuildContext context, {
    int? sol,
    String? camera,
  }) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.fetchMarsPhotos(sol: sol, camera: camera);
    });
  }

  /// **selectRover**
  ///
  /// Selects a Mars rover and optionally loads its photos with loading overlay.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  /// - `rover`: Rover name ('curiosity', 'opportunity', or 'spirit').
  /// - `autoFetch`: Whether to automatically fetch photos after selection.
  ///
  /// **Side Effects**
  /// - Updates the selected rover in the ViewModel.
  /// - If autoFetch is true, displays loader and fetches photos.
  ///
  /// **Example**:
  /// ```dart
  /// // Select Opportunity and load its photos
  /// await spaceActions.selectRover(context, 'opportunity');
  ///
  /// // Select without fetching
  /// await spaceActions.selectRover(context, 'spirit', autoFetch: false);
  /// ```
  // ────────────────────────────────────────────────
  Future<void> selectRover(
    BuildContext context,
    String rover, {
    bool autoFetch = true,
  }) async {
    if (autoFetch) {
      await _presenter.actionHandler(context, () async {
        _viewModel.selectRover(rover, autoFetch: true);
      });
    } else {
      _viewModel.selectRover(rover, autoFetch: false);
    }
  }

  // ════════════════════════════════════════════════════════════════
  // Refresh Actions
  // ════════════════════════════════════════════════════════════════

  /// **refreshAll**
  ///
  /// Refreshes all space data (APOD, NEO, Mars photos) with loading overlay.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  ///
  /// **Side Effects**
  /// - Displays a global loader overlay while the action runs.
  /// - Triggers refresh for APOD, NEO, and Mars photos.
  /// - On error, shows an error snackbar via [ActionPresenter].
  ///
  /// **Example**:
  /// ```dart
  /// // Refresh all space data
  /// await spaceActions.refreshAll(context);
  /// ```
  // ────────────────────────────────────────────────
  Future<void> refreshAll(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.refreshAll();
    });
  }

  /// **refreshApod**
  ///
  /// Refreshes only the APOD data with loading overlay.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  // ────────────────────────────────────────────────
  Future<void> refreshApod(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.refreshApod();
    });
  }

  /// **refreshNeoData**
  ///
  /// Refreshes only the NEO data with loading overlay.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  // ────────────────────────────────────────────────
  Future<void> refreshNeoData(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.refreshNearEarthObjects();
    });
  }

  /// **refreshMarsPhotos**
  ///
  /// Refreshes only the Mars photos data with loading overlay.
  ///
  /// **Parameters**
  /// - `context`: Build context used to show/hide the loader overlay.
  // ────────────────────────────────────────────────
  Future<void> refreshMarsPhotos(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      _viewModel.refreshMarsPhotos();
    });
  }
}
