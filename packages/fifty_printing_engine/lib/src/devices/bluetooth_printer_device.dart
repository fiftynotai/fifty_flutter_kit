import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/printer_type.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Bluetooth thermal printer implementation
class BluetoothPrinterDevice extends PrinterDevice {
  /// MAC address of the Bluetooth printer
  final String macAddress;

  BluetoothPrinterDevice({
    required super.id,
    required super.name,
    required this.macAddress,
    super.role,
    super.defaultCopies,
    super.paperSize,
    super.metadata,
  }) : super(type: PrinterType.bluetooth);

  @override
  Future<bool> connect() async {
    try {
      updateStatus(PrinterStatus.connecting);

      // Debug logging
      debugPrint('🔵 Connecting to Bluetooth printer: $name');
      debugPrint('🔵 MAC Address: $macAddress');
      debugPrint('🔵 Paper Size: ${paperSize.name}');
      debugPrint('🔵 Metadata: $metadata');

      // Retry logic: Try 3 times with exponential backoff
      // Helps with printer sleep mode without disrupting Bluetooth stack
      const maxAttempts = 3;

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        debugPrint('🔵 Connection attempt $attempt/$maxAttempts');

        // Connect to Bluetooth printer
        final result = await PrintBluetoothThermal.connect(
          macPrinterAddress: macAddress,
        );

        debugPrint('🔵 Connection result: $result');

        if (result) {
          updateStatus(PrinterStatus.connected);
          debugPrint('✅ Connected successfully on attempt $attempt');
          return true;
        }

        // If not last attempt, wait before retry (exponential backoff)
        if (attempt < maxAttempts) {
          final delaySeconds = attempt * 2; // 2s, 4s
          debugPrint('⚠️ Attempt $attempt failed, retrying in ${delaySeconds}s...');
          debugPrint('💡 TIP: Press any button on the printer to wake it up');
          await Future.delayed(Duration(seconds: delaySeconds));
        }
      }

      // All attempts failed
      updateStatus(PrinterStatus.error);
      debugPrint('❌ Connection failed after $maxAttempts attempts');
      debugPrint('💡 Make sure printer is ON and press any button to wake it');
      return false;
    } catch (e) {
      updateStatus(PrinterStatus.error);
      debugPrint('❌ Connection exception: $e');
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
      updateStatus(PrinterStatus.disconnected);
    } catch (e) {
      updateStatus(PrinterStatus.error);
    }
  }

  /// Device-specific print implementation for Bluetooth printers
  ///
  /// Sends ticket bytes to Bluetooth thermal printer.
  /// The base class [print] method handles health check, auto-connect,
  /// paper size conversion, and status management.
  ///
  /// **BR-069 Fix:**
  /// - Adds timeout to prevent infinite hangs with stale connections
  /// - Bluetooth library manages connection state internally (no socket reuse issue)
  /// - Base class auto-connect handles reconnection when needed
  ///
  // ────────────────────────────────────────────────
  @override
  @protected
  Future<bool> printInternal(PrintTicket ticket) async {
    try {
      // NOTE: No manual reconnection needed for Bluetooth
      // The print_bluetooth_thermal library manages connection state internally
      // Base class already calls connect() if status != connected

      // Send bytes with timeout to prevent infinite hangs (BR-069)
      final result = await PrintBluetoothThermal.writeBytes(ticket.bytes).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('❌ Bluetooth print timeout - connection may be stale');
          return false;
        },
      );
      return result;
    } catch (e) {
      debugPrint('❌ Bluetooth print error: $e');
      return false;
    }
  }

  @override
  Future<bool> checkHealth() async {
    try {
      // Check if Bluetooth connection exists
      final connectionStatus = await PrintBluetoothThermal.connectionStatus;

      if (connectionStatus) {
        // Connection exists - printer is reachable
        // NOTE: Don't update status to "connected" here - only connect() should do that
        // This prevents breaking auto-connect logic in base class
        return true;
      } else {
        // No connection - printer is off or disconnected
        updateStatus(PrinterStatus.healthCheckFailed);
        return false;
      }
    } catch (e) {
      updateStatus(PrinterStatus.healthCheckFailed);
      return false;
    }
  }

  /// Create a copy of this printer with updated properties
  @override
  BluetoothPrinterDevice copyWith({
    String? id,
    String? name,
    String? macAddress,
    PrinterRole? role,
    int? defaultCopies,
    PaperSize? paperSize,
    Map<String, dynamic>? metadata,
  }) {
    return BluetoothPrinterDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      role: role ?? this.role,
      defaultCopies: defaultCopies ?? this.defaultCopies,
      paperSize: paperSize ?? this.paperSize,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  PrinterDevice reset() {
    return BluetoothPrinterDevice(
      id: id,
      name: name,
      macAddress: macAddress,
      role: null,  // Default: no role
      defaultCopies: 1,  // Default: 1 copy
      paperSize: PaperSize.mm80,  // Default: 80mm
      metadata: {},  // Default: empty (autoPrintMode will be manual)
    );
  }

  /// Serialize to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'type': 'bluetooth',
      'id': id,
      'name': name,
      'macAddress': macAddress,
      'role': role?.name,
      'defaultCopies': defaultCopies,
      'paperSize': paperSize.name,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Deserialize from JSON
  factory BluetoothPrinterDevice.fromJson(Map<String, dynamic> json) {
    return BluetoothPrinterDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      macAddress: json['macAddress'] as String,
      role: json['role'] != null
          ? PrinterRole.values.firstWhere((r) => r.name == json['role'])
          : null,
      defaultCopies: json['defaultCopies'] as int? ?? 1,
      paperSize: json['paperSize'] != null
          ? PaperSize.values.firstWhere(
              (p) => p.name == json['paperSize'],
              orElse: () => PaperSize.mm80,
            )
          : PaperSize.mm80,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
