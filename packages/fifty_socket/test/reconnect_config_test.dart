import 'package:fifty_socket/fifty_socket.dart';
import 'package:test/test.dart';

void main() {
  group('ReconnectConfig', () {
    test('default constructor has expected defaults', () {
      const config = ReconnectConfig();
      expect(config.enabled, isTrue);
      expect(config.baseRetrySeconds, 5);
      expect(config.maxRetries, 10);
      expect(config.exponentialBackoff, isTrue);
      expect(config.maxBackoffSeconds, 60);
    });

    test('custom values are applied', () {
      const config = ReconnectConfig(
        enabled: false,
        baseRetrySeconds: 10,
        maxRetries: 5,
        exponentialBackoff: false,
        maxBackoffSeconds: 120,
      );
      expect(config.enabled, isFalse);
      expect(config.baseRetrySeconds, 10);
      expect(config.maxRetries, 5);
      expect(config.exponentialBackoff, isFalse);
      expect(config.maxBackoffSeconds, 120);
    });

    test('.disabled has enabled=false', () {
      const config = ReconnectConfig.disabled;
      expect(config.enabled, isFalse);
    });

    test('.defaults matches default constructor', () {
      const config = ReconnectConfig.defaults;
      expect(config.enabled, isTrue);
      expect(config.baseRetrySeconds, 5);
      expect(config.maxRetries, 10);
      expect(config.exponentialBackoff, isTrue);
      expect(config.maxBackoffSeconds, 60);
    });
  });
}
