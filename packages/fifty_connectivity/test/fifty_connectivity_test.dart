import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_connectivity/fifty_connectivity.dart';

void main() {
  group('ConnectivityConfig', () {
    setUp(() {
      ConnectivityConfig.reset();
    });

    test('has default labels', () {
      expect(ConnectivityConfig.labelSignalLost, 'SIGNAL LOST');
      expect(ConnectivityConfig.labelEstablishingUplink, 'ESTABLISHING UPLINK');
      expect(ConnectivityConfig.labelReconnecting, 'RECONNECTING');
      expect(ConnectivityConfig.labelRetryConnection, 'RETRY CONNECTION');
      expect(ConnectivityConfig.labelTryAgain, 'TRY AGAIN');
      expect(ConnectivityConfig.labelOfflineFor, 'Offline for:');
      expect(ConnectivityConfig.labelAttemptingRestore,
          'Attempting to restore uplink...');
      expect(ConnectivityConfig.labelConnectionLost,
          'Connection to server lost');
      expect(ConnectivityConfig.labelNoInternetSemantics,
          'No internet connection');
      expect(ConnectivityConfig.labelUplinkActive, 'UPLINK ACTIVE');
    });

    test('has default navigation settings', () {
      expect(ConnectivityConfig.navigateOff, isNull);
      expect(ConnectivityConfig.logoBuilder, isNull);
      expect(ConnectivityConfig.defaultNextRoute, '/auth');
      expect(ConnectivityConfig.splashDelaySeconds, 1);
    });

    test('reset restores defaults', () {
      // Change values
      ConnectivityConfig.labelSignalLost = 'CUSTOM';
      ConnectivityConfig.defaultNextRoute = '/custom';
      ConnectivityConfig.splashDelaySeconds = 5;

      // Reset
      ConnectivityConfig.reset();

      // Verify defaults restored
      expect(ConnectivityConfig.labelSignalLost, 'SIGNAL LOST');
      expect(ConnectivityConfig.defaultNextRoute, '/auth');
      expect(ConnectivityConfig.splashDelaySeconds, 1);
    });

    test('labels can be customized', () {
      ConnectivityConfig.labelSignalLost = 'CUSTOM SIGNAL LOST';
      expect(ConnectivityConfig.labelSignalLost, 'CUSTOM SIGNAL LOST');
    });

    test('navigateOff can be set', () {
      var called = false;
      ConnectivityConfig.navigateOff = (route) async {
        called = true;
      };

      ConnectivityConfig.navigateOff!('/test');
      expect(called, isTrue);
    });
  });

  group('ReachabilityService', () {
    test('creates with default values', () {
      final service = ReachabilityService();

      expect(service.host, 'google.com');
      expect(service.timeout, const Duration(seconds: 3));
      expect(service.strategy, ReachabilityStrategy.dnsLookup);
      expect(service.healthEndpoint, isNull);
    });

    test('creates with custom values', () {
      final service = ReachabilityService(
        host: 'custom.com',
        timeout: const Duration(seconds: 5),
        strategy: ReachabilityStrategy.httpHead,
        healthEndpoint: Uri.parse('https://custom.com/health'),
      );

      expect(service.host, 'custom.com');
      expect(service.timeout, const Duration(seconds: 5));
      expect(service.strategy, ReachabilityStrategy.httpHead);
      expect(service.healthEndpoint, Uri.parse('https://custom.com/health'));
    });
  });

  group('ConnectivityType', () {
    test('has all expected values', () {
      expect(ConnectivityType.values, contains(ConnectivityType.mobileData));
      expect(ConnectivityType.values, contains(ConnectivityType.wifi));
      expect(ConnectivityType.values, contains(ConnectivityType.disconnected));
      expect(ConnectivityType.values, contains(ConnectivityType.noInternet));
      expect(ConnectivityType.values, contains(ConnectivityType.connecting));
    });
  });

  group('UplinkStatus', () {
    test('has all expected values', () {
      expect(UplinkStatus.values, contains(UplinkStatus.online));
      expect(UplinkStatus.values, contains(UplinkStatus.offline));
      expect(UplinkStatus.values, contains(UplinkStatus.connecting));
    });
  });

  group('ReachabilityStrategy', () {
    test('has all expected values', () {
      expect(
          ReachabilityStrategy.values, contains(ReachabilityStrategy.dnsLookup));
      expect(
          ReachabilityStrategy.values, contains(ReachabilityStrategy.httpHead));
    });
  });
}
