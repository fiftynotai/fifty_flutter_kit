import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:fifty_connectivity/fifty_connectivity.dart';

/// Fake [ConnectionViewModel] that exposes a manually-settable
/// [connectionType] without performing real connectivity checks.
///
/// Extends [ConnectionViewModel] with `autoInit: false` to skip real
/// connectivity monitoring while inheriting the full interface
/// (including [WidgetsBindingObserver]).
class FakeConnectionViewModel extends ConnectionViewModel {
  FakeConnectionViewModel() : super(autoInit: false);

  @override
  Future<void> getConnectivity() async {
    // No-op: skip real connectivity check.
  }
}

void main() {
  // Shared fake registered once to avoid ConnectionActions late final issue.
  // The singleton's _connectionViewModel is `late final`, so it can only be
  // set once per process. We register one FakeConnectionViewModel and reuse
  // it across all tests, resetting its reactive state in setUp.
  late FakeConnectionViewModel fakeVm;

  setUpAll(() {
    fakeVm = FakeConnectionViewModel();
    Get.put<ConnectionViewModel>(fakeVm);
  });

  setUp(() {
    // Reset to default state before each test.
    fakeVm.connectionType.value = ConnectivityType.connecting;
    ConnectivityConfig.navigateOff = null;
    ConnectivityConfig.splashDelaySeconds = 0;
  });

  tearDownAll(() {
    ConnectivityConfig.reset();
    ConnectionActions.resetForTesting();
    Get.reset();
  });

  /// Helper to pump the splash inside a GetMaterialApp.
  ///
  /// Pumps twice: once for initState, then a Duration.zero pump to flush
  /// the `Future.delayed(Duration.zero)` created by [ConnectionActions.initSplash].
  Future<void> pumpSplash(
    WidgetTester tester, {
    SplashContentBuilder? contentBuilder,
  }) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: ConnectivityCheckerSplash(
          contentBuilder: contentBuilder,
        ),
      ),
    );
    // Flush the Future.delayed(Duration(seconds: 0)) from initSplash.
    await tester.pump(Duration.zero);
    await tester.pump();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SplashConnectivityState enum
  // ─────────────────────────────────────────────────────────────────────────

  group('SplashConnectivityState enum', () {
    test('has exactly 3 values', () {
      expect(SplashConnectivityState.values.length, 3);
      expect(
        SplashConnectivityState.values,
        containsAll([
          SplashConnectivityState.checking,
          SplashConnectivityState.connected,
          SplashConnectivityState.failed,
        ]),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // contentBuilder - rendering per state
  // ─────────────────────────────────────────────────────────────────────────

  group('contentBuilder - rendering', () {
    testWidgets(
      'renders default ConnectionHandler content when contentBuilder is null',
      (tester) async {
        // Use a large surface to avoid overflow from ConnectionHandler widgets.
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1.0;

        fakeVm.connectionType.value = ConnectivityType.connecting;
        await pumpSplash(tester, contentBuilder: null);

        // ConnectionHandler should be in the tree.
        expect(find.byType(ConnectionHandler), findsOneWidget);

        // Clean up view overrides.
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      },
    );

    testWidgets(
      'renders builder output when contentBuilder is provided',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.connecting;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) =>
              const Text('custom-content'),
        );

        expect(find.text('custom-content'), findsOneWidget);
        // ConnectionHandler should NOT be in the tree.
        expect(find.byType(ConnectionHandler), findsNothing);
      },
    );

    testWidgets(
      'builder receives checking state when type is connecting',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.connecting;

        SplashConnectivityState? received;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            received = state;
            return Text('state:$state');
          },
        );

        expect(received, SplashConnectivityState.checking);
      },
    );

    testWidgets(
      'builder receives connected state when type is wifi',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.wifi;

        SplashConnectivityState? received;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            received = state;
            return Text('state:$state');
          },
        );

        expect(received, SplashConnectivityState.connected);
      },
    );

    testWidgets(
      'builder receives connected state when type is mobileData',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.mobileData;

        SplashConnectivityState? received;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            received = state;
            return Text('state:$state');
          },
        );

        expect(received, SplashConnectivityState.connected);
      },
    );

    testWidgets(
      'builder receives failed state when type is disconnected',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.disconnected;

        SplashConnectivityState? received;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            received = state;
            return Text('state:$state');
          },
        );

        expect(received, SplashConnectivityState.failed);
      },
    );

    testWidgets(
      'builder receives failed state when type is noInternet',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.noInternet;

        SplashConnectivityState? received;
        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            received = state;
            return Text('state:$state');
          },
        );

        expect(received, SplashConnectivityState.failed);
      },
    );
  });

  // ─────────────────────────────────────────────────────────────────────────
  // contentBuilder - retryAction
  // ─────────────────────────────────────────────────────────────────────────

  group('contentBuilder - retryAction', () {
    testWidgets(
      'retryAction callback can be invoked from builder',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.disconnected;

        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) {
            return ElevatedButton(
              onPressed: retry,
              child: const Text('Retry'),
            );
          },
        );

        // Tap the retry button -- should not throw.
        await tester.tap(find.text('Retry'));
        // Flush the Future.delayed from initSplash triggered by retry.
        await tester.pump(Duration.zero);
        await tester.pump();
      },
    );
  });

  // ─────────────────────────────────────────────────────────────────────────
  // contentBuilder - reactivity
  // ─────────────────────────────────────────────────────────────────────────

  group('contentBuilder - reactivity', () {
    testWidgets(
      'builder rebuilds when connectionType changes',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.connecting;

        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) =>
              Text('state:${state.name}'),
        );

        expect(find.text('state:checking'), findsOneWidget);

        // Change connectivity type.
        fakeVm.connectionType.value = ConnectivityType.wifi;
        await tester.pump();

        expect(find.text('state:connected'), findsOneWidget);

        // Change again.
        fakeVm.connectionType.value = ConnectivityType.noInternet;
        await tester.pump();

        expect(find.text('state:failed'), findsOneWidget);
      },
    );
  });

  // ─────────────────────────────────────────────────────────────────────────
  // contentBuilder - Scaffold preserved
  // ─────────────────────────────────────────────────────────────────────────

  group('contentBuilder - Scaffold preserved', () {
    testWidgets(
      'Scaffold exists in widget tree when builder is active',
      (tester) async {
        fakeVm.connectionType.value = ConnectivityType.connecting;

        await pumpSplash(
          tester,
          contentBuilder: (context, state, retry) =>
              const Text('inside-builder'),
        );

        expect(find.byType(Scaffold), findsWidgets);
        expect(find.text('inside-builder'), findsOneWidget);
      },
    );
  });
}
