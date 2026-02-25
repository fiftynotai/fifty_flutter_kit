/// Utils Demo ViewModel
///
/// Business logic for the utils demo feature.
/// Demonstrates DateTime extensions, Color utilities, responsive breakpoints,
/// and ApiResponse state machine.
library;

import 'dart:async';

import 'package:fifty_utils/fifty_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ViewModel for the utils demo feature.
///
/// Manages demo state for DateTime extensions, Color utilities,
/// responsive utilities, and ApiResponse state machine.
class UtilsDemoViewModel extends GetxController {
  // ---------------------------------------------------------------------------
  // DateTime Demo State
  // ---------------------------------------------------------------------------

  /// Sample dates for demonstrating extensions.
  final List<DateTime> sampleDates = [
    DateTime.now(),
    DateTime.now().subtract(const Duration(minutes: 5)),
    DateTime.now().subtract(const Duration(hours: 3)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 30)),
    DateTime.now().subtract(const Duration(days: 365)),
    DateTime.now().add(const Duration(days: 2)),
  ];

  /// Gets human-readable label for each sample date.
  String labelForDate(int index) {
    switch (index) {
      case 0:
        return 'Now';
      case 1:
        return '5 minutes ago';
      case 2:
        return '3 hours ago';
      case 3:
        return 'Yesterday';
      case 4:
        return '30 days ago';
      case 5:
        return '1 year ago';
      case 6:
        return 'In 2 days';
      default:
        return 'Unknown';
    }
  }

  // ---------------------------------------------------------------------------
  // Color Demo State
  // ---------------------------------------------------------------------------

  /// Sample hex color strings for demonstrating HexColor.
  static const List<String> sampleHexColors = [
    '#FF5733',
    '#33FF57',
    '#3357FF',
    '#FF33F5',
    '#F5FF33',
    '#33FFF5',
  ];

  /// Parses a hex string to a Color.
  Color parseHexColor(String hex) {
    return HexColor.fromHex(hex);
  }

  /// Converts a Color to its hex string representation.
  String colorToHex(Color color) {
    return color.toHex();
  }

  // ---------------------------------------------------------------------------
  // ApiResponse Demo State
  // ---------------------------------------------------------------------------

  /// Current API response state.
  final Rx<ApiResponse<String>> apiState =
      Rx<ApiResponse<String>>(ApiResponse<String>.idle());

  /// Cycles the API response through all states.
  Future<void> cycleApiStates() async {
    // Idle -> Loading
    apiState.value = ApiResponse<String>.loading();
    update();

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    // Loading -> Success
    apiState.value = ApiResponse<String>.success(
      '{"user": "John Doe", "role": "admin"}',
    );
    update();

    await Future<void>.delayed(const Duration(milliseconds: 2000));

    // Success -> Loading (new request)
    apiState.value = ApiResponse<String>.loading();
    update();

    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // Loading -> Error
    apiState.value = ApiResponse<String>.error(
      Exception('Network timeout after 30s'),
    );
    update();

    await Future<void>.delayed(const Duration(milliseconds: 2000));

    // Error -> Idle (reset)
    apiState.value = ApiResponse<String>.idle();
    update();
  }

  /// Resets API state to idle.
  void resetApiState() {
    apiState.value = ApiResponse<String>.idle();
    update();
  }

  /// Gets a display label for the current API status.
  String get apiStatusLabel {
    switch (apiState.value.status) {
      case ApiStatus.idle:
        return 'IDLE';
      case ApiStatus.loading:
        return 'LOADING';
      case ApiStatus.success:
        return 'SUCCESS';
      case ApiStatus.error:
        return 'ERROR';
    }
  }

  /// Gets a color for the current API status.
  Color apiStatusColor(ColorScheme colorScheme) {
    switch (apiState.value.status) {
      case ApiStatus.idle:
        return colorScheme.onSurface.withValues(alpha: 0.5);
      case ApiStatus.loading:
        return colorScheme.primary;
      case ApiStatus.success:
        return colorScheme.tertiary;
      case ApiStatus.error:
        return colorScheme.error;
    }
  }
}
