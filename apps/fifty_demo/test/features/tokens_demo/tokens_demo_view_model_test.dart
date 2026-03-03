/// TokensDemoViewModel Unit Tests
///
/// Tests for the TokensDemoViewModel business logic.
/// Verifies palette state tracking and display name computation.
library;

import 'package:fifty_demo/features/tokens_demo/controllers/tokens_demo_view_model.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late TokensDemoViewModel viewModel;

  setUpAll(() {
    Get.testMode = true;
  });

  setUp(() {
    FiftyTokens.reset();
    viewModel = TokensDemoViewModel();
  });

  tearDown(Get.reset);

  group('TokensDemoViewModel', () {
    group('initial state', () {
      test('should not be Baltic Blue when tokens are default', () {
        // onInit syncs with FiftyTokens.isConfigured which is false
        // after reset
        viewModel.onInit();
        expect(viewModel.isBalticBlue, false);
      });

      test('should report FDL v2 palette name by default', () {
        viewModel.onInit();
        expect(viewModel.paletteName, 'FDL v2');
      });

      test('should sync with FiftyTokens.isConfigured on init', () {
        // Given: tokens are configured
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: const Color(0xFF586994),
          ),
        );

        // When: ViewModel initializes
        viewModel.onInit();

        // Then: should detect configured state
        expect(viewModel.isBalticBlue, true);
        expect(viewModel.paletteName, 'Baltic Blue');

        // Cleanup
        FiftyTokens.reset();
      });
    });

    group('setBalticBlue', () {
      test('should set Baltic Blue state to true', () {
        viewModel.setBalticBlue(active: true);
        expect(viewModel.isBalticBlue, true);
      });

      test('should set Baltic Blue state to false', () {
        viewModel.setBalticBlue(active: true);
        viewModel.setBalticBlue(active: false);
        expect(viewModel.isBalticBlue, false);
      });
    });

    group('paletteName', () {
      test('should return Baltic Blue when active', () {
        viewModel.setBalticBlue(active: true);
        expect(viewModel.paletteName, 'Baltic Blue');
      });

      test('should return FDL v2 when not active', () {
        viewModel.setBalticBlue(active: false);
        expect(viewModel.paletteName, 'FDL v2');
      });
    });
  });
}
