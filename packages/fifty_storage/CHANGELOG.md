# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-31

### Added

- Initial release extracted from `fifty_arch`
- `TokenStorage` abstract contract for secure credential storage
- `SecureTokenStorage` implementation using `flutter_secure_storage`
  - Singleton pattern with in-memory caching
  - Synchronous reads after initialization
  - Platform secure storage (Keychain/Keystore)
- `PreferencesStorage` for lightweight app preferences using `get_storage`
  - Configurable container name via `configure()`
  - Theme mode, language code, and user ID support
  - Clear all preferences utility
- `AppStorageService` unified facade
  - Single initialization for both storage types
  - Simplified API for common storage operations
  - Preferences and token management in one place
- Comprehensive test suite with mocking support
- Full documentation with usage examples

### Changed

- Container name now configurable (was hardcoded as 'appName-app')
- Fixed incorrect absolute imports in original source
- Default container name is now 'fifty_storage'
