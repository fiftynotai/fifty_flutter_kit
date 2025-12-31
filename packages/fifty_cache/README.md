# fifty_cache

TTL-based HTTP response caching with pluggable stores and policies.

Part of the [Fifty Ecosystem](https://github.com/fiftynotai/fifty_eco_system) - a comprehensive Flutter toolkit.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Components](#components)
  - [CacheStore](#cachestore)
  - [CachePolicy](#cachepolicy)
  - [CacheKeyStrategy](#cachekeystrategy)
  - [CacheManager](#cachemanager)
- [Built-in Implementations](#built-in-implementations)
- [Custom Implementations](#custom-implementations)
- [Integration with mvvm_actions](#integration-with-mvvm_actions)
- [Testing](#testing)
- [API Reference](#api-reference)
- [Best Practices](#best-practices)
- [License](#license)
- [Ecosystem](#ecosystem)

---

## Overview

`fifty_cache` provides a contract-based caching system designed for HTTP response caching in Flutter applications. Originally extracted from `fifty_arch` to enable standalone use.

### Why fifty_cache?

- **Decoupled from HTTP** - Works with any HTTP client (Dio, http, GetConnect)
- **Contract-based** - Swap implementations without changing client code
- **Testable** - In-memory store for unit tests, persistent store for production
- **Flexible policies** - Control caching behavior per endpoint or globally

---

## Features

- **Contract-based design** - Swap implementations without changing client code
- **TTL-aware caching** - Entries automatically expire after configurable time-to-live
- **Pluggable stores** - In-memory for testing, GetStorage for persistence
- **Flexible policies** - Control what gets cached and for how long
- **Deterministic keys** - Stable cache keys from request parameters and headers
- **Header-aware keys** - Different cache entries for different locales/auth states

---

## Installation

### Path Dependency (Monorepo)

For projects within the Fifty ecosystem:

```yaml
dependencies:
  fifty_cache:
    path: ../fifty_cache
```

### Git Dependency

For external projects:

```yaml
dependencies:
  fifty_cache:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_cache
```

### Pub.dev (Future)

```yaml
dependencies:
  fifty_cache: ^0.1.0
```

---

## Quick Start

```dart
import 'package:fifty_cache/fifty_cache.dart';

// 1. Create components
final store = MemoryCacheStore();
final keyStrategy = const DefaultCacheKeyStrategy();
final policy = SimpleTimeToLiveCachePolicy(
  timeToLive: Duration(hours: 6),
);

// 2. Create cache manager
final cacheManager = CacheManager(store, keyStrategy, policy);

// 3. Try to read from cache before network request
final cached = await cacheManager.tryRead(
  'GET',
  'https://api.example.com/users',
  {'page': 1},
);

if (cached != null) {
  // Cache hit - use cached response
  print('Cache hit: $cached');
} else {
  // Cache miss - fetch from network
  final response = await http.get(
    Uri.parse('https://api.example.com/users?page=1'),
  );

  // Store successful response in cache
  await cacheManager.tryWrite(
    'GET',
    'https://api.example.com/users',
    {'page': 1},
    statusCode: response.statusCode,
    bodyString: response.body,
  );
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       CacheManager                              │
│  Orchestrates cache operations using store, policy, and keys    │
└─────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   CacheStore    │  │   CachePolicy   │  │ CacheKeyStrategy│
│   (Contract)    │  │   (Contract)    │  │   (Contract)    │
│                 │  │                 │  │                 │
│ - put()         │  │ - canRead()     │  │ - buildKey()    │
│ - get()         │  │ - canWrite()    │  │                 │
│ - remove()      │  │ - timeToLiveFor │  │                 │
│ - clear()       │  │                 │  │                 │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│MemoryCacheStore │  │SimpleTimeToLive │  │DefaultCacheKey  │
│GetStorageCache  │  │  CachePolicy    │  │    Strategy     │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

---

## Components

### CacheStore

Storage abstraction for persisting cached entries with TTL support.

**Contract:**

```dart
abstract class CacheStore {
  /// Store value with time-to-live
  Future<void> put(String key, String value, {required Duration ttl});

  /// Retrieve value (null if missing or expired)
  Future<String?> get(String key);

  /// Remove single entry
  Future<void> remove(String key);

  /// Remove all entries
  Future<void> clear();
}
```

### CachePolicy

Decides when to read/write cache and what TTL to apply.

**Contract:**

```dart
abstract class CachePolicy {
  /// Should attempt cache read?
  bool canRead(
    String method,
    String url,
    Map<String, dynamic>? query, {
    bool forceRefresh = false,
  });

  /// Should cache this response?
  bool canWrite(String method, String url, int? statusCode);

  /// What TTL to apply?
  Duration timeToLiveFor(String method, String url, int? statusCode);
}
```

### CacheKeyStrategy

Builds deterministic cache keys from request data.

**Contract:**

```dart
abstract class CacheKeyStrategy {
  /// Build deterministic cache key
  String buildKey(
    String url,
    Map<String, dynamic>? query, {
    String method = 'GET',
    Map<String, String>? headers,
  });
}
```

### CacheManager

Orchestrates cache operations using store, policy, and key strategy.

**API:**

```dart
class CacheManager {
  CacheManager(this.storage, this.keyStrategy, this.policy);

  /// Attempt cache read (respects policy)
  Future<String?> tryRead(
    String method,
    String url,
    Map<String, dynamic>? query, {
    bool forceRefresh = false,
    Map<String, String>? headers,
  });

  /// Attempt cache write (respects policy)
  Future<void> tryWrite(
    String method,
    String url,
    Map<String, dynamic>? query, {
    required int? statusCode,
    required String? bodyString,
    Map<String, String>? headers,
  });

  /// Remove specific entry
  Future<void> invalidate(
    String method,
    String url,
    Map<String, dynamic>? query, {
    Map<String, String>? headers,
  });

  /// Remove all entries
  Future<void> clear();
}
```

---

## Built-in Implementations

### MemoryCacheStore

In-memory store for testing and lightweight caching.

```dart
final store = MemoryCacheStore();

// Store with TTL
await store.put('key', 'value', ttl: Duration(minutes: 5));

// Retrieve (returns null if expired)
final cached = await store.get('key');

// Clear all
await store.clear();
```

**Use cases:**
- Unit testing
- Short-lived session caches
- Development environment

### GetStorageCacheStore

Persistent store using `get_storage` package.

```dart
// Create with async factory (ensures initialization)
final store = await GetStorageCacheStore.create(
  container: 'my_app_cache',
);

// Usage is identical to MemoryCacheStore
await store.put('key', 'value', ttl: Duration(hours: 6));
final cached = await store.get('key');
```

**Storage format:**
```json
{
  "body": "<raw response string>",
  "expiry": "2025-01-01T12:00:00.000Z"
}
```

**Use cases:**
- Production mobile apps
- Offline-first applications
- Cross-session caching

### SimpleTimeToLiveCachePolicy

Fixed TTL policy with sensible defaults.

```dart
final policy = SimpleTimeToLiveCachePolicy(
  timeToLive: Duration(hours: 12),
  cacheGetRequestsOnly: true,  // Default: true
);

// Check if we should read from cache
if (policy.canRead('GET', url, query)) {
  // Proceed with cache read
}

// Check if we should cache the response
if (policy.canWrite('GET', url, 200)) {
  // Proceed with cache write
}

// Get TTL for response
final ttl = policy.timeToLiveFor('GET', url, 200);
```

**Behavior:**
- Reads: Allowed for GET requests (unless `forceRefresh: true`)
- Writes: Allowed for GET requests with 2xx status codes
- TTL: Fixed duration for all responses

### DefaultCacheKeyStrategy

Builds human-readable, deterministic keys.

```dart
const strategy = DefaultCacheKeyStrategy();

final key = strategy.buildKey(
  'https://api.example.com/users',
  {'page': 1, 'limit': 10},
  method: 'GET',
  headers: {
    'Accept-Language': 'en',
    'Authorization': 'Bearer token123',
  },
);
// Output: 'GET https://api.example.com/users?limit=10&page=1 | H:lang=en,auth=1'
```

**Key components:**
1. HTTP method (uppercased)
2. URL
3. Query parameters (sorted alphabetically)
4. Header fingerprint:
   - `lang=<value>` from Accept-Language
   - `auth=1` or `auth=0` based on Authorization presence

**Security note:** Authorization token values are NOT stored in keys - only presence is indicated (`auth=1` vs `auth=0`).

---

## Custom Implementations

### Custom CacheStore (Redis Example)

```dart
class RedisCacheStore implements CacheStore {
  final RedisClient _redis;

  RedisCacheStore(this._redis);

  @override
  Future<void> put(String key, String value, {required Duration ttl}) async {
    await _redis.setex(key, ttl.inSeconds, value);
  }

  @override
  Future<String?> get(String key) async {
    return await _redis.get(key);
  }

  @override
  Future<void> remove(String key) async {
    await _redis.del(key);
  }

  @override
  Future<void> clear() async {
    await _redis.flushDb();
  }
}
```

### Custom CachePolicy (URL-based TTL)

```dart
class UrlBasedCachePolicy implements CachePolicy {
  final Map<String, Duration> _urlTtls;
  final Duration _defaultTtl;

  UrlBasedCachePolicy({
    required Map<String, Duration> urlTtls,
    Duration defaultTtl = const Duration(hours: 1),
  })  : _urlTtls = urlTtls,
        _defaultTtl = defaultTtl;

  @override
  bool canRead(
    String method,
    String url,
    Map<String, dynamic>? query, {
    bool forceRefresh = false,
  }) {
    if (forceRefresh) return false;
    return method.toUpperCase() == 'GET';
  }

  @override
  bool canWrite(String method, String url, int? statusCode) {
    if (method.toUpperCase() != 'GET') return false;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  @override
  Duration timeToLiveFor(String method, String url, int? statusCode) {
    // Match URL patterns to TTLs
    for (final entry in _urlTtls.entries) {
      if (url.contains(entry.key)) return entry.value;
    }
    return _defaultTtl;
  }
}

// Usage
final policy = UrlBasedCachePolicy(
  urlTtls: {
    '/users': Duration(hours: 24),      // User data: long TTL
    '/feed': Duration(minutes: 5),       // Feed: short TTL
    '/config': Duration(days: 7),        // Config: very long TTL
  },
  defaultTtl: Duration(hours: 1),
);
```

### Custom CacheKeyStrategy (Simple)

```dart
class SimpleCacheKeyStrategy implements CacheKeyStrategy {
  const SimpleCacheKeyStrategy();

  @override
  String buildKey(
    String url,
    Map<String, dynamic>? query, {
    String method = 'GET',
    Map<String, String>? headers,
  }) {
    final buffer = StringBuffer('$method:$url');
    if (query != null && query.isNotEmpty) {
      final sorted = query.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      buffer.write('?');
      buffer.write(sorted.map((e) => '${e.key}=${e.value}').join('&'));
    }
    return buffer.toString();
  }
}
```

---

## Integration with mvvm_actions

When using the `mvvm_actions` template, the cache integrates with the HTTP infrastructure:

```dart
// In your service class
class UserService extends GetxService {
  final ApiService _api;
  final CacheManager _cache;

  UserService(this._api, this._cache);

  Future<ApiResponse<List<User>>> getUsers({bool forceRefresh = false}) async {
    const url = '/users';
    final query = <String, dynamic>{};

    // Try cache first
    final cached = await _cache.tryRead(
      'GET',
      url,
      query,
      forceRefresh: forceRefresh,
    );

    if (cached != null) {
      final users = (jsonDecode(cached) as List)
          .map((e) => User.fromJson(e))
          .toList();
      return ApiResponse.success(users);
    }

    // Fetch from network
    final response = await _api.get(url, query: query);

    if (response.isSuccess) {
      // Cache successful response
      await _cache.tryWrite(
        'GET',
        url,
        query,
        statusCode: 200,
        bodyString: jsonEncode(response.data),
      );
    }

    return response;
  }
}
```

### Dependency Injection Setup

```dart
// In your bindings
class AppBindings extends Bindings {
  @override
  void dependencies() async {
    // Create cache store
    final cacheStore = await GetStorageCacheStore.create(
      container: 'app_cache',
    );

    // Create cache manager
    final cacheManager = CacheManager(
      cacheStore,
      const DefaultCacheKeyStrategy(),
      SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 6)),
    );

    Get.put<CacheManager>(cacheManager);
    Get.put<UserService>(UserService(Get.find(), Get.find()));
  }
}
```

---

## Testing

The package is designed for easy testing with `MemoryCacheStore`:

```dart
import 'package:fifty_cache/fifty_cache.dart';
import 'package:test/test.dart';

void main() {
  late CacheManager cacheManager;
  late MemoryCacheStore store;

  setUp(() {
    store = MemoryCacheStore();
    cacheManager = CacheManager(
      store,
      const DefaultCacheKeyStrategy(),
      SimpleTimeToLiveCachePolicy(timeToLive: Duration(hours: 1)),
    );
  });

  test('returns null on cache miss', () async {
    final cached = await cacheManager.tryRead(
      'GET',
      'https://api.example.com/users',
      null,
    );
    expect(cached, isNull);
  });

  test('returns cached value on cache hit', () async {
    // Write to cache
    await cacheManager.tryWrite(
      'GET',
      'https://api.example.com/users',
      null,
      statusCode: 200,
      bodyString: '{"users": []}',
    );

    // Read from cache
    final cached = await cacheManager.tryRead(
      'GET',
      'https://api.example.com/users',
      null,
    );
    expect(cached, equals('{"users": []}'));
  });

  test('respects forceRefresh parameter', () async {
    // Write to cache
    await cacheManager.tryWrite(
      'GET',
      'https://api.example.com/users',
      null,
      statusCode: 200,
      bodyString: '{"users": []}',
    );

    // Force refresh bypasses cache
    final cached = await cacheManager.tryRead(
      'GET',
      'https://api.example.com/users',
      null,
      forceRefresh: true,
    );
    expect(cached, isNull);
  });

  test('does not cache non-GET requests by default', () async {
    await cacheManager.tryWrite(
      'POST',
      'https://api.example.com/users',
      null,
      statusCode: 200,
      bodyString: '{"id": "123"}',
    );

    final cached = await cacheManager.tryRead(
      'POST',
      'https://api.example.com/users',
      null,
    );
    expect(cached, isNull);
  });

  test('invalidate removes specific entry', () async {
    await cacheManager.tryWrite(
      'GET',
      'https://api.example.com/users',
      null,
      statusCode: 200,
      bodyString: '{"users": []}',
    );

    await cacheManager.invalidate(
      'GET',
      'https://api.example.com/users',
      null,
    );

    final cached = await cacheManager.tryRead(
      'GET',
      'https://api.example.com/users',
      null,
    );
    expect(cached, isNull);
  });
}
```

---

## API Reference

### CacheStore

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `put` | `key`, `value`, `ttl` | `Future<void>` | Store value with TTL |
| `get` | `key` | `Future<String?>` | Retrieve value (null if missing/expired) |
| `remove` | `key` | `Future<void>` | Delete single entry |
| `clear` | - | `Future<void>` | Delete all entries |

### CachePolicy

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `canRead` | `method`, `url`, `query`, `forceRefresh` | `bool` | Should read from cache? |
| `canWrite` | `method`, `url`, `statusCode` | `bool` | Should write to cache? |
| `timeToLiveFor` | `method`, `url`, `statusCode` | `Duration` | TTL for this response |

### CacheKeyStrategy

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `buildKey` | `url`, `query`, `method`, `headers` | `String` | Build deterministic cache key |

### CacheManager

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `tryRead` | `method`, `url`, `query`, `forceRefresh`, `headers` | `Future<String?>` | Read if policy allows |
| `tryWrite` | `method`, `url`, `query`, `statusCode`, `bodyString`, `headers` | `Future<void>` | Write if policy allows |
| `invalidate` | `method`, `url`, `query`, `headers` | `Future<void>` | Remove specific entry |
| `clear` | - | `Future<void>` | Remove all entries |

---

## Best Practices

### 1. Choose the Right Store

| Scenario | Store | Reason |
|----------|-------|--------|
| Unit tests | `MemoryCacheStore` | No setup, instant operations |
| Development | `MemoryCacheStore` | Clears on hot restart |
| Production mobile | `GetStorageCacheStore` | Persists across sessions |
| Production web | Custom (IndexedDB) | Browser-native persistence |

### 2. Configure TTL Per Endpoint

```dart
// Frequently changing data: short TTL
final feedPolicy = SimpleTimeToLiveCachePolicy(
  timeToLive: Duration(minutes: 5),
);

// Rarely changing data: long TTL
final configPolicy = SimpleTimeToLiveCachePolicy(
  timeToLive: Duration(days: 7),
);
```

### 3. Use forceRefresh for Pull-to-Refresh

```dart
Future<void> onRefresh() async {
  await cacheManager.tryRead(
    'GET',
    url,
    query,
    forceRefresh: true,  // Bypass cache
  );
  // Then fetch from network...
}
```

### 4. Invalidate on Mutations

```dart
Future<void> createUser(User user) async {
  await api.post('/users', body: user.toJson());

  // Invalidate users list cache
  await cacheManager.invalidate('GET', '/users', null);
}
```

### 5. Include Headers for Locale-Aware Caching

```dart
final cached = await cacheManager.tryRead(
  'GET',
  url,
  query,
  headers: {'Accept-Language': currentLocale},
);
```

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Ecosystem

| Package | Description |
|---------|-------------|
| [fifty_tokens](../fifty_tokens) | Design tokens |
| [fifty_theme](../fifty_theme) | Theme system |
| [fifty_ui](../fifty_ui) | UI components |
| [mvvm_actions](../../templates/mvvm_actions) | Architecture template |
| **fifty_cache** | HTTP caching (this package) |
| [fifty_audio_engine](../fifty_audio_engine) | Audio management |
| [fifty_speech_engine](../fifty_speech_engine) | TTS/STT |
| [fifty_sentences_engine](../fifty_sentences_engine) | Dialogue system |
| [fifty_map_engine](../fifty_map_engine) | Map rendering |
