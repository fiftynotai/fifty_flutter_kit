import 'package:get_storage/get_storage.dart';

/// **PreferencesStorage**
///
/// Singleton wrapper around `get_storage` for lightweight app preferences
/// such as theme mode, language code, and user identifier.
///
/// **Why**
/// - Provide a clear separation from secure token storage.
/// - Centralize container name and keys to avoid drift.
///
/// **Key Features**
/// - Configurable container name via [configure] (call before [initialize]).
/// - Async initialization with a dedicated container name.
/// - Simple getters/setters for common preferences.
/// - Utility to clear all preferences.
///
/// **Example**
/// ```dart
/// // Optional: configure container name before initialization
/// PreferencesStorage.configure(containerName: 'my_app');
///
/// await PreferencesStorage.instance.initialize();
/// PreferencesStorage.instance.languageCode = 'en';
/// ```
///
// ────────────────────────────────────────────────
class PreferencesStorage {
  PreferencesStorage._internal();

  static final PreferencesStorage _instance = PreferencesStorage._internal();
  static PreferencesStorage get instance => _instance;

  /// The container name used by GetStorage.
  ///
  /// Configure this before calling [initialize] using [configure].
  /// Defaults to 'fifty_storage'.
  static String _containerName = 'fifty_storage';

  /// Returns the current container name.
  static String get containerName => _containerName;

  /// **configure**
  ///
  /// Configure the container name before calling [initialize].
  ///
  /// This allows multiple apps using this package to have isolated storage.
  /// Must be called before [initialize] - calling after has no effect.
  ///
  /// **Parameters**
  /// - [containerName]: The GetStorage container name to use.
  ///
  /// **Example**
  /// ```dart
  /// PreferencesStorage.configure(containerName: 'my_app_preferences');
  /// await PreferencesStorage.instance.initialize();
  /// ```
  // ────────────────────────────────────────────────
  static void configure({required String containerName}) {
    _containerName = containerName;
  }

  // Keys
  static const String _kThemeMode = 'themeMode';
  static const String _kLanguageCode = 'languageCode';
  static const String _kUserId = 'userId';

  late GetStorage _box;

  /// **initialize**
  ///
  /// Initialize the GetStorage container for preferences.
  ///
  /// **Side Effects**
  /// - Opens/creates the container named [containerName].
  // ────────────────────────────────────────────────
  Future<void> initialize() async {
    await GetStorage.init(_containerName);
    _box = GetStorage(_containerName);
  }

  // ---------- Theme Mode ----------

  /// **themeMode**
  ///
  /// Read the saved theme mode (string) or `null` when not set.
  String? get themeMode => _box.read(_kThemeMode);

  /// **themeMode**
  ///
  /// Persist the theme mode (fire-and-forget write).
  set themeMode(String? value) => _box.write(_kThemeMode, value);

  // ---------- Language Code ----------

  /// **languageCode**
  String? get languageCode => _box.read(_kLanguageCode);

  /// **languageCode**
  set languageCode(String? value) => _box.write(_kLanguageCode, value);

  // ---------- User ID ----------

  /// **userId**
  String? get userId => _box.read(_kUserId);

  /// **userId**
  set userId(String? value) => _box.write(_kUserId, value);

  /// **clearAll**
  ///
  /// Erase all preferences in this container.
  // ────────────────────────────────────────────────
  Future<void> clearAll() => _box.erase();
}
