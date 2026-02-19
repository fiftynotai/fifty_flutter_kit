// ignore_for_file: avoid_print

import 'package:fifty_utils/fifty_utils.dart';

void main() {
  // ===========================================================================
  // FIFTY UTILS EXAMPLE
  // Demonstrating extensions, responsive utils, and state containers
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // DateTime Extensions
  // ---------------------------------------------------------------------------

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final lastWeek = now.subtract(const Duration(days: 7));

  print('Is today: ${now.isToday}'); // true
  print('Is yesterday: ${yesterday.isYesterday}'); // true
  print('Same day: ${now.isSameDay(yesterday)}'); // false
  print('Formatted: ${now.format('dd/MM/yyyy')}');
  print('Time ago: ${lastWeek.timeAgo()}'); // "7 days ago"

  // ---------------------------------------------------------------------------
  // Duration Extensions
  // ---------------------------------------------------------------------------

  const duration = Duration(hours: 2, minutes: 30, seconds: 15);
  print('Formatted: ${duration.format()}'); // "02:30:15"
  print('Compact: ${duration.formatCompact()}'); // "2h 30m"

  // ---------------------------------------------------------------------------
  // Color Extensions (HexColor)
  // ---------------------------------------------------------------------------

  final color = HexColor.fromHex('#FF5733');
  print('From hex: $color');
  print('To hex: ${color.toHex()}');

  // ---------------------------------------------------------------------------
  // ApiResponse — Immutable state container
  // ---------------------------------------------------------------------------

  // Success state
  final success = ApiResponse<String>.success('Hello, World!');
  print('Has data: ${success.hasData}'); // true
  print('Data: ${success.data}'); // "Hello, World!"

  // Loading state
  final loading = ApiResponse<String>.loading();
  print('Is loading: ${loading.isLoading}'); // true

  // Error state
  final error = ApiResponse<String>.error(Exception('Network error'));
  print('Has error: ${error.hasError}'); // true
  print('Error: ${error.error}');

  // ---------------------------------------------------------------------------
  // Responsive Utils (requires BuildContext in real app)
  // ---------------------------------------------------------------------------

  // In a real Flutter app with BuildContext:
  // final deviceType = ResponsiveUtils.deviceType(context);
  // final padding = ResponsiveUtils.padding(context);
  // final columns = ResponsiveUtils.gridColumns(context);
  // final value = ResponsiveUtils.valueByDevice(
  //   context,
  //   mobile: 16.0,
  //   tablet: 24.0,
  //   desktop: 32.0,
  // );

  print('ResponsiveUtils available for BuildContext-based usage');
}
