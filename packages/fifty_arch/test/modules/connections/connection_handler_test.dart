import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_arch/src/modules/locale/data/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionHandler', () {
    setUp(() {
      Get.put(ConnectionViewModel(autoInit: false));
      LocalizationService.init();
    });

    tearDown(() async {
      await Get.delete<ConnectionViewModel>(force: true);
    });

    Widget buildApp(Widget child) => GetMaterialApp(
          translations: LocalizationService(),
          locale: LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          theme: FiftyTheme.dark(),
          darkTheme: FiftyTheme.dark(),
          themeMode: ThemeMode.dark,
          home: Scaffold(body: child),
        );

    testWidgets('shows onConnectingWidget during connecting; renders connected only when connected; retry on tap when offline', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      int tries = 0;

      await tester.pumpWidget(buildApp(
        ConnectionHandler(
          connectedWidget: const Text('CONNECTED'),
          onConnectingWidget: const Text('CONNECTING...'),
          tryAgainAction: () => tries++,
        ),
      ));

      // Default is connecting → should show onConnectingWidget
      expect(find.text('CONNECTING...'), findsOneWidget);
      expect(find.text('CONNECTED'), findsNothing);

      // Offline → show FDL-styled retry UI with FiftyButton
      vm.connectionType.value = ConnectivityType.noInternet;
      await tester.pumpAndSettle();

      // FDL redesign shows "SIGNAL LOST" title and FiftyButton for retry
      expect(find.text('SIGNAL LOST'), findsOneWidget);
      expect(find.byType(FiftyButton), findsOneWidget);

      // Tap retry button (find FiftyButton)
      await tester.tap(find.byType(FiftyButton));
      await tester.pumpAndSettle();
      expect(tries, 1);

      // Mark as connected
      vm.connectionType.value = ConnectivityType.wifi;
      await tester.pumpAndSettle();
      expect(find.text('CONNECTED'), findsOneWidget);
    });

    testWidgets('shows default FDL loading indicator when no onConnectingWidget provided', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      vm.connectionType.value = ConnectivityType.connecting;

      await tester.pumpWidget(buildApp(
        ConnectionHandler(
          connectedWidget: const Text('CONNECTED'),
          tryAgainAction: () {},
          // No onConnectingWidget provided - should show default FDL indicator
        ),
      ));

      // Use pump() instead of pumpAndSettle() because FiftyLoadingIndicator has continuous animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should show FiftyLoadingIndicator with "ESTABLISHING UPLINK"
      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
    });

    testWidgets('shows FDL-styled offline card when disconnected', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      vm.connectionType.value = ConnectivityType.noInternet;

      await tester.pumpWidget(buildApp(
        ConnectionHandler(
          connectedWidget: const Text('CONNECTED'),
          tryAgainAction: () {},
        ),
      ));

      await tester.pumpAndSettle();

      // FDL offline UI shows:
      // - SIGNAL LOST title
      // - cloud_off icon
      // - FiftyCard container
      // - FiftyButton for retry
      expect(find.text('SIGNAL LOST'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.byType(FiftyCard), findsOneWidget);
      expect(find.byType(FiftyButton), findsOneWidget);
    });

    testWidgets('tryAgainAction is called when retry button tapped', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      vm.connectionType.value = ConnectivityType.noInternet;
      int tries = 0;

      await tester.pumpWidget(buildApp(
        ConnectionHandler(
          connectedWidget: const Text('CONNECTED'),
          tryAgainAction: () => tries++,
        ),
      ));

      await tester.pumpAndSettle();

      // Tap the FiftyButton
      await tester.tap(find.byType(FiftyButton));
      await tester.pumpAndSettle();

      expect(tries, 1);
    });

    testWidgets('custom notConnectedWidget is used when provided', (tester) async {
      final vm = Get.find<ConnectionViewModel>();
      vm.connectionType.value = ConnectivityType.noInternet;

      await tester.pumpWidget(buildApp(
        ConnectionHandler(
          connectedWidget: const Text('CONNECTED'),
          notConnectedWidget: const Text('CUSTOM OFFLINE'),
          tryAgainAction: () {},
        ),
      ));

      await tester.pumpAndSettle();

      // Should show custom widget instead of default FDL offline UI
      expect(find.text('CUSTOM OFFLINE'), findsOneWidget);
      expect(find.text('SIGNAL LOST'), findsNothing);
    });
  });
}
