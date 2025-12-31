import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_storage/fifty_storage.dart';

void main() {
  group('PreferencesStorage configuration', () {
    test('default container name is fifty_storage', () {
      expect(PreferencesStorage.containerName, equals('fifty_storage'));
    });

    test('configure changes container name', () {
      // Save original
      final original = PreferencesStorage.containerName;

      // Act
      PreferencesStorage.configure(containerName: 'test_app');

      // Assert
      expect(PreferencesStorage.containerName, equals('test_app'));

      // Restore
      PreferencesStorage.configure(containerName: original);
    });
  });

  group('PreferencesStorage singleton', () {
    test('instance returns singleton', () {
      final a = PreferencesStorage.instance;
      final b = PreferencesStorage.instance;
      expect(identical(a, b), isTrue);
    });
  });
}
