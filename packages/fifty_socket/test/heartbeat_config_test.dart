import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

void main() {
  group('HeartbeatConfig', () {
    test('default constructor has expected defaults', () {
      const config = HeartbeatConfig();
      expect(config.pingIntervalSeconds, 30);
      expect(config.timeoutSeconds, 60); // 2x ping interval
      expect(config.watchdogCheckIntervalSeconds, 15);
    });

    test('timeout defaults to 2x pingIntervalSeconds', () {
      const config = HeartbeatConfig(pingIntervalSeconds: 15);
      expect(config.timeoutSeconds, 30); // 2 * 15
    });

    test('custom timeout overrides 2x default', () {
      const config = HeartbeatConfig(
        pingIntervalSeconds: 30,
        timeoutSeconds: 90,
      );
      expect(config.timeoutSeconds, 90);
    });

    test('custom values are applied', () {
      const config = HeartbeatConfig(
        pingIntervalSeconds: 10,
        timeoutSeconds: 45,
        watchdogCheckIntervalSeconds: 5,
      );
      expect(config.pingIntervalSeconds, 10);
      expect(config.timeoutSeconds, 45);
      expect(config.watchdogCheckIntervalSeconds, 5);
    });

    test('.defaults matches default constructor', () {
      const config = HeartbeatConfig.defaults;
      expect(config.pingIntervalSeconds, 30);
      expect(config.timeoutSeconds, 60);
      expect(config.watchdogCheckIntervalSeconds, 15);
    });
  });
}
