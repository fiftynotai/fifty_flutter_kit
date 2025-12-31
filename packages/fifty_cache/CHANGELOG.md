# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-31

### Added

- Initial release extracted from fifty_arch infrastructure
- Core components:
  - `CacheManager` - Orchestrates cache reads/writes with policy and key strategy
  - `CacheStore` - Storage abstraction contract for pluggable backends
  - `CachePolicy` - Read/write decision contract with TTL selection
  - `CacheKeyStrategy` - Deterministic key building contract
- Built-in implementations:
  - `MemoryCacheStore` - In-memory store for testing and lightweight caching
  - `GetStorageCacheStore` - Persistent store using get_storage package
  - `SimpleTimeToLiveCachePolicy` - Fixed TTL caching for GET requests with 2xx responses
  - `DefaultCacheKeyStrategy` - URL + sorted query + header fingerprint keys
- Comprehensive test suite
- Full API documentation with examples
