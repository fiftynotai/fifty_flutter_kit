import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/printer_type.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// WiFi/Network ESC/POS printer implementation
class WiFiPrinterDevice extends PrinterDevice {
  /// IP address of the network printer
  final String ipAddress;

  /// Port number (default: 9100 for ESC/POS)
  final int port;

  /// Connection timeout duration
  final Duration timeout;

  /// Active socket connection
  Socket? _socket;

  WiFiPrinterDevice({
    required super.id,
    required super.name,
    required this.ipAddress,
    this.port = 9100,
    this.timeout = const Duration(seconds: 5),
    super.role,
    super.defaultCopies,
    super.paperSize,
    super.metadata,
  }) : super(type: PrinterType.wifi);

  @override
  Future<bool> connect() async {
    try {
      // Reuse existing socket if already connected
      // This prevents unnecessary reconnections for multi-copy prints
      if (_socket != null && status == PrinterStatus.connected) {
        debugPrint('✅ WiFi printer already connected, reusing socket: $name');
        return true;
      }

      debugPrint('🔵 Connecting to WiFi printer: $name');
      debugPrint('   IP Address: $ipAddress');
      debugPrint('   Port: $port');
      debugPrint('   Timeout: ${timeout.inSeconds}s');
      debugPrint('   Current Status: $status');

      updateStatus(PrinterStatus.connecting);

      // Only close socket if it exists but is unhealthy
      if (_socket != null && status != PrinterStatus.connected) {
        debugPrint('   Closing unhealthy socket before reconnect');
        await _closeSocket();
      }

      // Connect to network printer (only if no healthy socket)
      if (_socket == null) {
        debugPrint('   Creating new socket connection...');
        _socket = await Socket.connect(
          ipAddress,
          port,
          timeout: timeout,
        );
        debugPrint('   ✅ Socket created successfully');
      }

      updateStatus(PrinterStatus.connected);
      debugPrint('✅ WiFi printer connected successfully: $name');
      return true;
    } catch (e) {
      debugPrint('❌ WiFi printer connection failed:');
      debugPrint('   Printer: $name');
      debugPrint('   IP: $ipAddress:$port');
      debugPrint('   Error: $e');
      debugPrint('   Error Type: ${e.runtimeType}');

      updateStatus(PrinterStatus.error);
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _closeSocket();
    updateStatus(PrinterStatus.disconnected);
  }

  /// Device-specific print implementation for WiFi printers
  ///
  /// Sends ticket bytes to network ESC/POS printer via TCP socket.
  /// The base class [print] method handles health check, auto-connect,
  /// paper size conversion, and status management.
  ///
  /// **Simplified:** Removed redundant reconnection logic.
  /// Base class already handles health check and auto-connect.
  /// This method focuses only on byte transmission with timeout protection.
  ///
  // ────────────────────────────────────────────────
  @override
  @protected
  Future<bool> printInternal(PrintTicket ticket) async {
    try {
      debugPrint('🖨️ WiFi printInternal() starting for: $name');
      debugPrint('   Socket exists: ${_socket != null}');
      debugPrint('   Sending ${ticket.bytes.length} bytes to printer...');

      // Send ticket bytes to network printer
      _socket!.add(Uint8List.fromList(ticket.bytes));

      debugPrint('   Flushing socket (10s timeout)...');
      // Add timeout to prevent infinite hangs
      await _socket!.flush().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Print operation timeout - socket may be stale');
        },
      );

      debugPrint('✅ WiFi print completed successfully: $name');
      return true;
    } catch (e) {
      debugPrint('❌ WiFi printInternal() failed:');
      debugPrint('   Printer: $name');
      debugPrint('   Error: $e');
      debugPrint('   Error Type: ${e.runtimeType}');

      // Clean up socket on any error
      await _closeSocket();
      return false;
    }
  }

  @override
  Future<bool> checkHealth() async {
    // Simple health check: Verify printer port is reachable (printer is ON)
    // Creates a test socket to verify connectivity
    // NOTE: Does NOT verify firmware is ready - that's handled by printInternal timeout

    Socket? testSocket;
    try {
      debugPrint('🏥 WiFi health check starting: $name');
      debugPrint('   IP: $ipAddress:$port');

      // Quick connection test (port reachable = printer is on)
      testSocket = await Socket.connect(
        ipAddress,
        port,
        timeout: timeout,
      );

      debugPrint('   ✅ Test socket connected');

      // IMPORTANT: Use destroy() instead of close() to prevent socket accumulation
      // close() leaves socket in TIME_WAIT state (60-120s on iOS)
      // After ~15 minutes, accumulated TIME_WAIT sockets hit iOS/printer limit
      // destroy() immediately terminates without TIME_WAIT
      testSocket.destroy();

      debugPrint('   ✅ Test socket destroyed (no TIME_WAIT)');

      // Port is reachable - printer is on
      // NOTE: Don't update status to "connected" here - only connect() should do that
      // This prevents breaking auto-connect logic in base class
      debugPrint('✅ WiFi health check passed: $name');
      return true;
    } catch (e) {
      // Ensure socket is cleaned up even on error
      testSocket?.destroy();

      debugPrint('❌ WiFi health check failed:');
      debugPrint('   Printer: $name');
      debugPrint('   IP: $ipAddress:$port');
      debugPrint('   Error: $e');
      debugPrint('   Error Type: ${e.runtimeType}');

      // Port unreachable - printer is off
      updateStatus(PrinterStatus.healthCheckFailed);
      return false;
    }
  }

  /// Close the socket connection
  ///
  /// Uses destroy() for immediate cleanup instead of close().
  /// This prevents socket state issues after printer power cycles (BR-078 related).
  ///
  /// **Why destroy() instead of close():**
  /// - Immediate termination (no graceful shutdown)
  /// - Works on broken/stale sockets (printer off/on cycles)
  /// - No TIME_WAIT state accumulation
  /// - Prevents "StreamSink is bound to a stream" errors
  ///
  Future<void> _closeSocket() async {
    try {
      _socket?.destroy();  // Immediate forceful termination
      _socket = null;
    } catch (e) {
      // Ignore errors when closing
    }
  }

  @override
  void dispose() {
    _closeSocket();
    super.dispose();
  }

  /// Create a copy of this printer with updated properties
  @override
  WiFiPrinterDevice copyWith({
    String? id,
    String? name,
    String? ipAddress,
    int? port,
    Duration? timeout,
    PrinterRole? role,
    int? defaultCopies,
    PaperSize? paperSize,
    Map<String, dynamic>? metadata,
  }) {
    return WiFiPrinterDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      timeout: timeout ?? this.timeout,
      role: role ?? this.role,
      defaultCopies: defaultCopies ?? this.defaultCopies,
      paperSize: paperSize ?? this.paperSize,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  PrinterDevice reset() {
    return WiFiPrinterDevice(
      id: id,
      name: name,
      ipAddress: ipAddress,
      port: port,
      timeout: timeout,
      role: null,  // Default: no role
      defaultCopies: 1,  // Default: 1 copy
      paperSize: PaperSize.mm80,  // Default: 80mm
      metadata: {},  // Default: empty (autoPrintMode will be manual)
    );
  }

  /// Serialize to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'type': 'wifi',
      'id': id,
      'name': name,
      'ipAddress': ipAddress,
      'port': port,
      'role': role?.name,
      'defaultCopies': defaultCopies,
      'paperSize': paperSize.name,
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Deserialize from JSON
  factory WiFiPrinterDevice.fromJson(Map<String, dynamic> json) {
    return WiFiPrinterDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      ipAddress: json['ipAddress'] as String,
      port: json['port'] as int? ?? 9100,
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
