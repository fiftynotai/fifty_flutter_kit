/// Draft persistence for fifty_forms.
///
/// Provides [DraftManager] for auto-saving and restoring form data.
///
/// **Example:**
/// ```dart
/// // Initialize storage once at app startup
/// await DraftManager.initStorage();
///
/// // Create draft manager for a form
/// final draftManager = DraftManager(
///   controller: formController,
///   key: 'my_form',
/// );
///
/// // Start auto-save
/// draftManager.start();
///
/// // Restore previous draft if exists
/// await draftManager.restoreDraft();
/// ```
library;

export 'draft_manager.dart';
