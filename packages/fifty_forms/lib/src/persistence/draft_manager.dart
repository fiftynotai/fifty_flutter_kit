import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../core/form_controller.dart';

/// Manages auto-saving and restoring form drafts.
///
/// Uses GetStorage for lightweight persistence. Automatically saves form data
/// after changes with a configurable debounce delay.
///
/// **Prerequisites:**
/// Initialize storage before using DraftManager:
/// ```dart
/// await GetStorage.init('fifty_forms_drafts');
/// ```
///
/// **Example:**
/// ```dart
/// final draftManager = DraftManager(
///   controller: formController,
///   key: 'registration_form',
///   debounce: Duration(seconds: 2),
/// );
///
/// // Auto-save starts when you call start()
/// draftManager.start();
///
/// // Check for existing draft
/// if (await draftManager.hasDraft()) {
///   await draftManager.restoreDraft();
/// }
///
/// // Clear draft after successful submission
/// await draftManager.clearDraft();
///
/// // Dispose when done
/// draftManager.dispose();
/// ```
///
/// **With auto-restore:**
/// ```dart
/// final draftManager = DraftManager(
///   controller: formController,
///   key: 'registration_form',
/// );
///
/// // Start and auto-restore if draft exists
/// draftManager.start();
/// final restored = await draftManager.restoreDraft();
/// if (restored != null) {
///   print('Restored draft from previous session');
/// }
/// ```
class DraftManager {
  /// Form controller to manage.
  final FiftyFormController controller;

  /// Storage key for this draft.
  ///
  /// Should be unique per form to avoid collisions.
  /// The actual storage key will be prefixed with 'fifty_forms_draft_'.
  final String key;

  /// Debounce duration for auto-save.
  ///
  /// After a change, waits this duration before saving.
  /// Defaults to 2 seconds.
  final Duration debounce;

  /// Custom storage container name.
  ///
  /// If not provided, uses the default 'fifty_forms_drafts'.
  final String? containerName;

  Timer? _debounceTimer;
  VoidCallback? _listener;
  bool _isActive = false;
  GetStorage? _storage;

  /// Creates a draft manager.
  ///
  /// [controller] is the form controller to manage.
  /// [key] is the unique storage key for this draft.
  /// [debounce] is the delay before auto-saving (default: 2 seconds).
  /// [containerName] is the GetStorage container name (default: 'fifty_forms_drafts').
  DraftManager({
    required this.controller,
    required this.key,
    this.debounce = const Duration(seconds: 2),
    this.containerName,
  });

  /// The full storage key used for persistence.
  String get _storageKey => 'fifty_forms_draft_$key';

  /// Gets the storage container name.
  String get _containerName => containerName ?? 'fifty_forms_drafts';

  /// Whether auto-save is currently active.
  bool get isActive => _isActive;

  /// Gets or initializes the storage instance.
  GetStorage get _box {
    _storage ??= GetStorage(_containerName);
    return _storage!;
  }

  /// Initializes storage for draft persistence.
  ///
  /// Call this once before using any DraftManager instances.
  /// Can be called with a custom container name.
  ///
  /// **Example:**
  /// ```dart
  /// // In main.dart
  /// await DraftManager.initStorage();
  /// // or with custom container
  /// await DraftManager.initStorage(containerName: 'my_app_drafts');
  /// ```
  static Future<void> initStorage({String? containerName}) async {
    await GetStorage.init(containerName ?? 'fifty_forms_drafts');
  }

  /// Starts auto-save listening.
  ///
  /// After calling this, any changes to the form controller will
  /// trigger an auto-save after the debounce delay.
  ///
  /// Does nothing if already started.
  void start() {
    if (_isActive) return;

    _listener = _onControllerChange;
    controller.addListener(_listener!);
    _isActive = true;
  }

  /// Stops auto-save listening.
  ///
  /// Cancels any pending debounce timer and removes the listener.
  /// Does not clear the saved draft.
  void stop() {
    _debounceTimer?.cancel();
    if (_listener != null) {
      controller.removeListener(_listener!);
      _listener = null;
    }
    _isActive = false;
  }

  void _onControllerChange() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, _saveDraft);
  }

  /// Manually saves the current form state as a draft.
  ///
  /// This is called automatically by auto-save, but can also be
  /// triggered manually (e.g., before navigating away).
  Future<void> saveDraft() async {
    await _saveDraft();
  }

  Future<void> _saveDraft() async {
    try {
      final values = controller.values;
      final json = jsonEncode(values);
      await _box.write(_storageKey, json);
    } catch (e) {
      // Silently fail - drafts are best-effort
      if (kDebugMode) {
        print('DraftManager: Failed to save draft: $e');
      }
    }
  }

  /// Checks if a draft exists.
  ///
  /// Returns true if a non-empty draft is stored for this key.
  Future<bool> hasDraft() async {
    final json = _box.read<String>(_storageKey);
    return json != null && json.isNotEmpty;
  }

  /// Restores the draft into the form controller.
  ///
  /// Loads stored values and sets them on the form controller.
  /// Validation is skipped during restore to avoid immediate errors.
  ///
  /// Returns the restored values, or null if no draft exists.
  ///
  /// **Example:**
  /// ```dart
  /// final restored = await draftManager.restoreDraft();
  /// if (restored != null) {
  ///   showSnackBar('Restored your previous draft');
  /// }
  /// ```
  Future<Map<String, dynamic>?> restoreDraft() async {
    try {
      final json = _box.read<String>(_storageKey);
      if (json == null || json.isEmpty) return null;

      final values = jsonDecode(json) as Map<String, dynamic>;

      for (final entry in values.entries) {
        controller.setValue(entry.key, entry.value, validate: false);
      }

      return values;
    } catch (e) {
      if (kDebugMode) {
        print('DraftManager: Failed to restore draft: $e');
      }
      return null;
    }
  }

  /// Clears the saved draft.
  ///
  /// Call this after successful form submission to clean up.
  ///
  /// **Example:**
  /// ```dart
  /// await controller.submit((values) async {
  ///   await api.save(values);
  ///   await draftManager.clearDraft();
  /// });
  /// ```
  Future<void> clearDraft() async {
    await _box.remove(_storageKey);
  }

  /// Disposes the draft manager.
  ///
  /// Stops auto-save and cancels any pending timers.
  /// Does not clear the saved draft.
  void dispose() {
    stop();
    _debounceTimer?.cancel();
  }
}
