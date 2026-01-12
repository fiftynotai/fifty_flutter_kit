import 'package:fifty_printing_engine/src/devices/bluetooth_printer_device.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Represents a Bluetooth printer discovered during scanning.
///
/// Contains the printer name and MAC address from Bluetooth discovery.
/// Provides a convenience method to create a BluetoothPrinterDevice.
class DiscoveredPrinter {
  /// Display name of the discovered printer
  final String name;

  /// MAC address of the Bluetooth device
  final String macAddress;

  const DiscoveredPrinter({
    required this.name,
    required this.macAddress,
  });

  /// Create a BluetoothPrinterDevice from this discovered printer.
  ///
  /// Requires a unique ID and optional role, copy count, and paper size.
  ///
  /// Example:
  /// ```dart
  /// final discovered = DiscoveredPrinter(name: 'Kitchen Printer', macAddress: '00:11:22:33:44:55');
  /// final device = discovered.toDevice(
  ///   id: 'printer-1',
  ///   role: PrinterRole.kitchen,
  ///   defaultCopies: 2,
  ///   paperSize: PaperSize.mm80,
  /// );
  /// ```
  BluetoothPrinterDevice toDevice({
    required String id,
    PrinterRole? role,
    int defaultCopies = 1,
    PaperSize paperSize = PaperSize.mm80,
  }) {
    return BluetoothPrinterDevice(
      id: id,
      name: name,
      macAddress: macAddress,
      role: role,
      defaultCopies: defaultCopies,
      paperSize: paperSize,
    );
  }

  @override
  String toString() => 'DiscoveredPrinter(name: $name, mac: $macAddress)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveredPrinter &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          macAddress == other.macAddress;

  @override
  int get hashCode => name.hashCode ^ macAddress.hashCode;
}
