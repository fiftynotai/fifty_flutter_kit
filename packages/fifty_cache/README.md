# Fifty Cache

TTL-based HTTP response caching with pluggable stores and policies. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

---

## Features

- **Contract-based design** - Swap implementations without changing client code
- **TTL-aware caching** - Entries automatically expire after configurable time-to-live
- **Pluggable stores** - In-memory for testing, GetStorage for persistence
- **Flexible policies** - Control what gets cached and for how long
- **Deterministic keys** - Stable cache keys from request parameters and headers
- **Header-aware keys** - Different cache entries for different locales and auth states

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_cache:
    path: ../fifty_cache
```

For external projects using a Git dependency:

```yaml
dependencies:
  fifty_cache:
    git:
      url: https://github.com/fiftynotai/fifty_flutter_kit.git
      path: packages/fifty_cache
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

### Core Components

| Component | Description |
|-----------|-------------|
| `CacheStore` | Storage abstraction for persisting cached entries with TTL support |
| `CachePolicy` | Decides when to read/write cache and what TTL to apply |
| `CacheKeyStrategy` | Builds deterministic cache keys from request data |
| `CacheManager` | Orchestrates cache operations using store, policy, and key strategy |
| `MemoryCacheStore` | In-memory store for testing and lightweight caching |
| `GetStorageCacheStore` | Persistent store using the `get_storage` package |
| `SimpleTimeToLiveCachePolicy` | Fixed TTL policy with sensible defaults |
| `DefaultCacheKeyStrategy` | Builds human-readable, deterministic keys |

---

## API Reference

### CacheStore

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

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `put` | `key`, `value`, `ttl` | `Future<void>` | Store value with TTL |
| `get` | `key` | `Future<String?>` | Retrieve value (null if missing/expired) |
| `remove` | `key` | `Future<void>` | Delete single entry |
| `clear` | - | `Future<void>` | Delete all entries |

### CachePolicy

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

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `canRead` | `method`, `url`, `query`, `forceRefresh` | `bool` | Should read from cache? |
| `canWrite` | `method`, `url`, `statusCode` | `bool` | Should write to cache? |
| `timeToLiveFor` | `method`, `url`, `statusCode` | `Duration` | TTL for this response |

### CacheKeyStrategy

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

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `buildKey` | `url`, `query`, `method`, `headers` | `String` | Build deterministic cache key |

### CacheManager

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

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `tryRead` | `method`, `url`, `query`, `forceRefresh`, `headers` | `Future<String?>` | Read if policy allows |
| `tryWrite` | `method`, `url`, `query`, `statusCode`, `bodyString`, `headers` | `Future<void>` | Write if policy allows |
| `invalidate` | `method`, `url`, `query`, `headers` | `Future<void>` | Remove specific entry |
| `clear` | - | `Future<void>` | Remove all entries |

---

## Usage Patterns

### Built-in Stores

#### MemoryCacheStore

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

Use cases: unit testing, short-lived session caches, development environment.

#### GetStorageCacheStore

Persistent store using the `get_storage` package.

```dart
// Create with async factory (ensures initialization)
final store = await GetStorageCacheStore.create(
  container: 'my_app_cache',
);

// Usage is identical to MemoryCacheStore
await store.put('key', 'value', ttl: Duration(hours: 6));
final cached = await store.get('key');
```

Storage format:

```json
{
  "body": "<raw response string>",
  "expiry": "2025-01-01T12:00:00.000Z"
}
```

Use cases: production mobile apps, offline-first applications, cross-session caching.

### Built-in Policy

#### SimpleTimeToLiveCachePolicy

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

Behavior:
- Reads: allowed for GET requests (unless `forceRefresh: true`)
- Writes: allowed for GET requests with 2xx status codes
- TTL: fixed duration for all responses

### Built-in Key Strategy

#### DefaultCacheKeyStrategy

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

Key components:
1. HTTP method (uppercased)
2. URL
3. Query parameters (sorted alphabetically)
4. Header fingerprint: `lang=<value>` from Accept-Language, `auth=1` or `auth=0` based on Authorization presence

Security note: Authorization token values are NOT stored in keys — only presence is indicated (`auth=1` vs `auth=0`).

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

### Custom CacheKeyStrategy

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

### Integration with mvvm_actions

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

### Choosing the Right Store

| Scenario | Store | Reason |
|----------|-------|--------|
| Unit tests | `MemoryCacheStore` | No setup, instant operations |
| Development | `MemoryCacheStore` | Clears on hot restart |
| Production mobile | `GetStorageCacheStore` | Persists across sessions |
| Production web | Custom (IndexedDB) | Browser-native persistence |

### Configuring TTL Per Endpoint

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

### Using forceRefresh for Pull-to-Refresh

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

### Invalidating on Mutations

```dart
Future<void> createUser(User user) async {
  await api.post('/users', body: user.toJson());

  // Invalidate users list cache
  await cacheManager.invalidate('GET', '/users', null);
}
```

### Locale-Aware Caching

```dart
final cached = await cacheManager.tryRead(
  'GET',
  url,
  query,
  headers: {'Accept-Language': currentLocale},
);
```

### Testing with MemoryCacheStore

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
    await cacheManager.tryWrite(
      'GET',
      'https://api.example.com/users',
      null,
      statusCode: 200,
      bodyString: '{"users": []}',
    );

    final cached = await cacheManager.tryRead(
      'GET',
      'https://api.example.com/users',
      null,
    );
    expect(cached, equals('{"users": []}'));
  });

  test('respects forceRefresh parameter', () async {
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

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     | `GetStorageCacheStore` uses shared preferences-backed storage |
| iOS      | Yes     | `GetStorageCacheStore` uses shared preferences-backed storage |
| macOS    | Yes     | `MemoryCacheStore` recommended for desktop |
| Linux    | Yes     | `MemoryCacheStore` recommended for desktop |
| Windows  | Yes     | `MemoryCacheStore` recommended for desktop |
| Web      | Yes     | Implement custom store backed by IndexedDB for persistence |

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **Standalone caching layer** - Extracted from `fifty_arch` for use without the full architecture package; works with any HTTP client (Dio, http, GetConnect)
- **mvvm_actions compatibility** - Designed to slot directly into the `mvvm_actions` service layer pattern; `CacheManager` is injected via GetX bindings alongside `ApiService`
- **Contract-first architecture** - Follows the FDL principle of coding to interfaces; all three contracts (`CacheStore`, `CachePolicy`, `CacheKeyStrategy`) are swappable without touching call sites

---

## Version

**Current:** 0.1.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
