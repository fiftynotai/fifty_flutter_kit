/// Fifty Utils - Pure Dart/Flutter utility functions
///
/// This package provides commonly used utility functions extracted from
/// the mvvm_actions template for reuse across Fifty Flutter Kit.
///
/// ## Extensions
///
/// - [DateTimeExtensions] - Date comparison, formatting, and relative time
/// - [DurationExtensions] - Duration formatting
/// - [HexColor] - Hex color string conversion
///
/// ## Responsive
///
/// - [ResponsiveUtils] - Device type detection and responsive values
/// - [DeviceType] - Enum for device types (mobile, tablet, desktop, wide)
///
/// ## State
///
/// - [ApiStatus] - Lifecycle status for API requests
/// - [ApiResponse] - Immutable request state container
/// - [PaginationResponse] - Pagination envelope with total rows
/// - [apiFetch] - Stream-based API fetch helper
library;

// Extensions
export 'src/extensions/date_time_extensions.dart';
export 'src/extensions/duration_extensions.dart';
export 'src/extensions/color_extensions.dart';

// Responsive
export 'src/responsive/responsive_utils.dart';

// State
export 'src/state/api_response.dart';
