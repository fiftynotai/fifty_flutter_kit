import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fifty_arch/src/modules/connections/views/connection_overlay.dart';
import 'package:fifty_arch/src/modules/connections/controllers/connection_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectionOverlay', () {
    setUp(() {
      // Provide a ConnectionViewModel without auto init to avoid platform calls in tests.
      Get.put(ConnectionViewModel(autoInit: false));
    });

    tearDown(() async {
      await Get.delete<ConnectionViewModel>(force: true);
    });

    Widget buildApp(Widget child) => GetMaterialApp(
          theme: FiftyTheme.dark(),
          darkTheme: FiftyTheme.dark(),
          themeMode: ThemeMode.dark,
          home: Scaffold(body: child),
        );

    testWidgets('shows UplinkStatusBar when connecting, OfflineStatusCard when no internet, and nothing when connected', (tester) async {
      final vm = Get.find<ConnectionViewModel>();

      // Start with connecting - shows UplinkStatusBar with "ESTABLISHING UPLINK"
      vm.connectionType.value = ConnectivityType.connecting;
      await tester.pumpWidget(buildApp(const ConnectionOverlay(child: SizedBox.shrink())));
      await tester.pump();
      expect(find.byType(UplinkStatusBar), findsOneWidget);

      // Switch to no internet - shows OfflineStatusCard with "SIGNAL LOST"
      vm.connectionType.value = ConnectivityType.noInternet;
      await tester.pump();
      expect(find.byType(OfflineStatusCard), findsOneWidget);
      expect(find.text('SIGNAL LOST'), findsOneWidget);

      // Switch to connected - shows nothing
      vm.connectionType.value = ConnectivityType.wifi;
      await tester.pump();
      expect(find.byType(OfflineStatusCard), findsNothing);
      expect(find.byType(UplinkStatusBar), findsNothing);
    });
  });
}
