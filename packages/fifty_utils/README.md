# fifty_utils

Pure Dart/Flutter utilities - DateTime, Duration, Color extensions, responsive breakpoints, and async state containers.

Part of the [Fifty Ecosystem](../../README.md).

## Features

- **DateTime Extensions** - Date comparison, formatting, and relative time
- **Duration Extensions** - Duration formatting (HH:mm:ss and compact)
- **Color Extensions** - Hex color string conversion
- **Responsive Utils** - Device type detection and responsive values
- **API Response** - Immutable async state containers

## Installation

Add to your `pubspec.yaml`:

### Using Git

```yaml
dependencies:
  fifty_utils:
    git:
      url: https://github.com/aspect-build/fifty_eco_system
      path: packages/fifty_utils
```

### Using Path (Monorepo)

```yaml
dependencies:
  fifty_utils:
    path: ../fifty_utils
```

## Usage

### DateTime Extensions

```dart
import 'package:fifty_utils/fifty_utils.dart';

final date = DateTime.now();

// Date comparisons
if (date.isToday) print('Today!');
if (date.isYesterday) print('Yesterday');
if (date.isTomorrow) print('Tomorrow');

// Compare with other dates
final other = DateTime(2024, 10, 28);
if (date.isSameDay(other)) print('Same day');
if (date.isSameMonth(other)) print('Same month');
if (date.isSameYear(other)) print('Same year');

// Date manipulation
final start = date.startOfDay; // 00:00:00
final end = date.endOfDay;     // 23:59:59.999
final days = date.daysBetween(other);

// Formatting
String formatted = date.format();           // 28/10/2024
String custom = date.format('yyyy-MM-dd');  // 2024-10-28
String time = date.formatTime();            // 14:30
String dateTime = date.formatDateTime();    // 28/10/2024 14:30

// Relative time
String ago = date.timeAgo(); // "2 hours ago", "in 3 days", etc.
```

### Duration Extensions

```dart
import 'package:fifty_utils/fifty_utils.dart';

final duration = Duration(hours: 2, minutes: 5, seconds: 30);

// Standard format
String formatted = duration.format(); // "02:05:30"

// Compact format
String compact = duration.formatCompact(); // "2h 5m"
```

### Color Extensions

```dart
import 'package:fifty_utils/fifty_utils.dart';

// From hex string to Color
Color color = HexColor.fromHex('#aabbcc');
Color withAlpha = HexColor.fromHex('#80aabbcc');
Color noHash = HexColor.fromHex('aabbcc');

// From Color to hex string
String hex = color.toHex();                        // "#ffaabbcc"
String noHashHex = color.toHex(leadingHashSign: false); // "ffaabbcc"
```

### Responsive Utils

```dart
import 'package:fifty_utils/fifty_utils.dart';

// Device type detection
if (ResponsiveUtils.isMobile(context)) {
  // Mobile layout (< 600px)
}
if (ResponsiveUtils.isTablet(context)) {
  // Tablet layout (600-1024px)
}
if (ResponsiveUtils.isDesktop(context)) {
  // Desktop layout (1024-1440px)
}
if (ResponsiveUtils.isWideDesktop(context)) {
  // Wide desktop layout (>= 1440px)
}

// Get device type as enum
DeviceType type = ResponsiveUtils.deviceType(context);
switch (type) {
  case DeviceType.mobile:
    // ...
  case DeviceType.tablet:
    // ...
  case DeviceType.desktop:
    // ...
  case DeviceType.wide:
    // ...
}

// Responsive values
double padding = ResponsiveUtils.valueByDevice<double>(
  context,
  mobile: 16,
  tablet: 24,
  desktop: 32,
  wide: 40,
);

// Built-in helpers
double padding = ResponsiveUtils.padding(context);
double margin = ResponsiveUtils.margin(context);
int columns = ResponsiveUtils.gridColumns(context);
double fontSize = ResponsiveUtils.scaledFontSize(context, 16);

// Screen dimensions
double width = ResponsiveUtils.screenWidth(context);
double halfWidth = ResponsiveUtils.screenWidth(context, 0.5);
double height = ResponsiveUtils.screenHeight(context);

// Orientation
bool portrait = ResponsiveUtils.isPortrait(context);
bool landscape = ResponsiveUtils.isLandscape(context);
```

### API Response

```dart
import 'package:fifty_utils/fifty_utils.dart';

// Create responses
final idle = ApiResponse<User>.idle();
final loading = ApiResponse<User>.loading();
final success = ApiResponse.success(user);
final error = ApiResponse<User>.error(exception, stackTrace);

// Check status
if (response.isIdle) { /* No request made */ }
if (response.isLoading) { /* Request in progress */ }
if (response.isSuccess) { /* Request succeeded */ }
if (response.isError) { /* Request failed */ }

// Check data/error
if (response.hasData) print(response.data);
if (response.hasError) print(response.error);

// Use apiFetch for stream-based fetching
apiFetch(() => userService.getUser()).listen((state) {
  if (state.isLoading) showSpinner();
  if (state.hasData) showUser(state.data!);
  if (state.hasError) showError(state.error);
});

// Skip loading state
apiFetch(() => api.getData(), withLoading: false);

// Pagination response
final page = PaginationResponse(users, totalRows);
print('Showing ${page.data.length} of ${page.totalRows}');
```

## API Reference

### DateTime Extensions

| Method | Description |
|--------|-------------|
| `isToday` | Check if date is today |
| `isYesterday` | Check if date was yesterday |
| `isTomorrow` | Check if date is tomorrow |
| `isSameDay(other)` | Check if same day as other |
| `isSameMonth(other)` | Check if same month as other |
| `isSameYear(other)` | Check if same year as other |
| `startOfDay` | Get start of day (00:00:00) |
| `endOfDay` | Get end of day (23:59:59.999) |
| `daysBetween(other)` | Days between dates |
| `format([pattern])` | Format date (default: dd/MM/yyyy) |
| `formatTime([pattern])` | Format time (default: HH:mm) |
| `formatDateTime([pattern])` | Format date+time |
| `timeAgo()` | Relative time string |

### Duration Extensions

| Method | Description |
|--------|-------------|
| `format()` | Format as HH:mm:ss |
| `formatCompact()` | Format as "2h 5m" |

### HexColor Extension

| Method | Description |
|--------|-------------|
| `HexColor.fromHex(hex)` | Parse hex string to Color |
| `toHex([leadingHashSign])` | Convert Color to hex string |

### ResponsiveUtils

| Method | Description |
|--------|-------------|
| `isMobile(context)` | Width < 600px |
| `isTablet(context)` | Width 600-1024px |
| `isDesktop(context)` | Width 1024-1440px |
| `isWideDesktop(context)` | Width >= 1440px |
| `deviceType(context)` | Get DeviceType enum |
| `valueByDevice(context, ...)` | Get value by device |
| `scaledFontSize(context, base)` | Scale font by device |
| `padding(context)` | Device-appropriate padding |
| `margin(context)` | Device-appropriate margin |
| `gridColumns(context)` | Responsive column count |
| `screenWidth(context, [%])` | Screen width |
| `screenHeight(context, [%])` | Screen height |
| `pixelRatio(context)` | Device pixel ratio |
| `isPortrait(context)` | Portrait orientation |
| `isLandscape(context)` | Landscape orientation |

### ApiStatus

| Value | Description |
|-------|-------------|
| `idle` | No request made yet |
| `loading` | Request in progress |
| `success` | Request completed successfully |
| `error` | Request failed |

### ApiResponse<E>

| Factory | Description |
|---------|-------------|
| `ApiResponse.idle()` | No request made |
| `ApiResponse.loading()` | Request in progress |
| `ApiResponse.success(data)` | Request succeeded |
| `ApiResponse.error(error, [st])` | Request failed |

| Property | Description |
|----------|-------------|
| `status` | Current ApiStatus |
| `data` | Response data (nullable) |
| `error` | Error object (nullable) |
| `stackTrace` | Error stack trace |
| `isIdle` | Status == idle |
| `isLoading` | Status == loading |
| `isSuccess` | Status == success |
| `isError` | Status == error |
| `hasData` | Data is not null |
| `hasError` | Error is not null |

### apiFetch<E>

```dart
Stream<ApiResponse<E>> apiFetch<E>(
  Future<E> Function() run, {
  bool withLoading = true,
  bool reportToSentry = true,
})
```

Emits a stream of request states: `loading? -> success | error`.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `run` | Async function to execute | required |
| `withLoading` | Emit loading state first | `true` |
| `reportToSentry` | Report errors to Sentry | `true` |

### PaginationResponse<E>

| Property | Description |
|----------|-------------|
| `data` | Paginated data |
| `totalRows` | Total available rows |

## Breakpoints

| Device | Width |
|--------|-------|
| Mobile | < 600px |
| Tablet | 600-1024px |
| Desktop | 1024-1440px |
| Wide | >= 1440px |

Breakpoints can be customized:

```dart
ResponsiveUtils.mobileBreakpoint = 600;
ResponsiveUtils.tabletBreakpoint = 1024;
ResponsiveUtils.desktopBreakpoint = 1440;
ResponsiveUtils.wideBreakpoint = 1440;
```

## Related Packages

- [mvvm_actions](../../templates/mvvm_actions/) - Template using fifty_utils for state management
- [fifty_tokens](../fifty_tokens/) - Design tokens for consistent styling
- [fifty_theme](../fifty_theme/) - Theme generation and management

## Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

## License

MIT License - see [LICENSE](LICENSE) for details.
