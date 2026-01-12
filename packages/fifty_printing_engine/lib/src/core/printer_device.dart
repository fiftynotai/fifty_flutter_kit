import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/printer_type.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';

/// **PrinterDevice**
///
/// Abstract base class for all printer device implementations.
///
/// **Key Features:**
/// - Defines common interface for all printer types (Bluetooth, WiFi, USB, etc.)
/// - Manages printer status lifecycle (disconnected → connecting → connected)
/// - Provides status change stream for real-time monitoring
/// - Supports role assignment for routing strategies
/// - Configurable default copy count per printer
/// - Auto-dispose pattern for resource cleanup
///
/// **Implementations:**
/// - `BluetoothPrinterDevice`: Bluetooth thermal printers
/// - `WiFiPrinterDevice`: Network ESC/POS printers
///
/// **Usage Example:**
/// ```dart
/// // Subclass implements connect(), disconnect(), print(), checkHealth()
/// class MyPrinterDevice extends PrinterDevice {
///   @override
///   Future<bool> connect() async {
///     updateStatus(PrinterStatus.connecting);
///     // Implementation...
///     updateStatus(PrinterStatus.connected);
///   }
/// }
/// ```
///
// ────────────────────────────────────────────────
abstract class PrinterDevice {
  /// Unique identifier for this printer
  final String id;

  /// Human-readable name for this printer
  final String name;

  /// Type of printer (bluetooth, wifi, usb)
  final PrinterType type;

  /// Role assigned to this printer (kitchen, receipt, both, etc.)
  final PrinterRole? role;

  /// Default number of copies to print (can be overridden per print job)
  final int defaultCopies;

  /// Paper size this printer uses (mm58, mm80)
  final PaperSize paperSize;

  /// Additional metadata for app-specific settings (e.g., autoPrintMode)
  final Map<String, dynamic>? metadata;

  /// Current status of the printer
  PrinterStatus _status = PrinterStatus.disconnected;

  /// Stream controller for status changes
  final _statusController = StreamController<PrinterStatus>.broadcast();

  /// Timestamp of last successful print (for health check caching)
  DateTime? _lastSuccessfulPrint;

  /// Duration to cache health check results after successful print
  /// If a print succeeds, we skip health check for subsequent prints within this window.
  /// This dramatically improves UX for consecutive prints while maintaining reliability.
  static const Duration healthCheckCacheDuration = Duration(seconds: 10);

  PrinterDevice({
    required this.id,
    required this.name,
    required this.type,
    this.role,
    this.defaultCopies = 1,
    this.paperSize = PaperSize.mm80,
    this.metadata,
  });

  /// Get the current status of the printer
  PrinterStatus get status => _status;

  /// Stream of status changes for this printer
  Stream<PrinterStatus> get statusStream => _statusController.stream;

  /// Update the printer status and emit event
  void updateStatus(PrinterStatus newStatus) {
    if (_status != newStatus) {
      _status = newStatus;

      // Clear health check cache when printer becomes unhealthy
      // This ensures next print attempt will do a fresh health check
      if (newStatus == PrinterStatus.disconnected ||
          newStatus == PrinterStatus.error ||
          newStatus == PrinterStatus.healthCheckFailed) {
        _lastSuccessfulPrint = null;
      }

      // Guard against adding to closed stream
      if (!_statusController.isClosed) {
        _statusController.add(newStatus);
      }
    }
  }

  /// Connect to the printer
  ///
  /// Returns true if connection succeeded, false otherwise.
  /// Updates status to [PrinterStatus.connecting] then [PrinterStatus.connected]
  /// or [PrinterStatus.error] based on result.
  Future<bool> connect();

  /// Disconnect from the printer
  ///
  /// Updates status to [PrinterStatus.disconnected].
  Future<void> disconnect();

  /// Print a ticket to this printer using Template Method Pattern
  ///
  /// **Template Method Pattern:**
  /// This method defines the complete printing algorithm with automatic:
  /// - Pre-flight health check (verifies printer is reachable)
  /// - Auto-connect if disconnected
  /// - Paper size conversion if needed
  /// - Status management
  /// - Error handling
  ///
  /// Subclasses implement [printInternal] with device-specific byte transmission only.
  ///
  /// **Smart Paper Size Handling:**
  /// If ticket.paperSize != printer.paperSize and regenerator is provided,
  /// the ticket will be automatically regenerated with the printer's paper size.
  ///
  /// Returns true if print succeeded, false otherwise.
  /// Updates status throughout the operation.
  ///
  /// **Parameters:**
  /// - `ticket`: The ticket to print
  /// - `regenerator`: Optional function to regenerate ticket with different paper size
  ///
  /// **Usage Example:**
  /// ```dart
  /// await printer.print(
  ///   ticket,
  ///   regenerator: (paperSize) => KitchenTicketGenerator.generate(paperSize, order, settings),
  /// );
  /// ```
  ///
  // ────────────────────────────────────────────────
  Future<bool> print(
    PrintTicket ticket, {
    Future<PrintTicket> Function(PaperSize)? regenerator,
  }) async {
    // STEP 1: Health check DISABLED (BR-078)
    // Health check before print causes issues on iOS:
    // - Creates test socket while print socket is open
    // - iOS blocks after ~15 minutes due to connection limits
    // - socket.destroy() helps but not 100% reliable
    //
    // Trade-off accepted:
    // - No pre-flight health check (faster print attempts)
    // - Print failure naturally detects offline printer
    // - Health check still runs periodically for status monitoring
    // - Better UX: prints work immediately without blocking

    // Commented out for now - health check only used for status display
    // final now = DateTime.now();
    // final needsHealthCheck = _lastSuccessfulPrint == null ||
    //     now.difference(_lastSuccessfulPrint!) > healthCheckCacheDuration;
    //
    // if (needsHealthCheck) {
    //   final isHealthy = await checkHealth();
    //   if (!isHealthy) {
    //     updateStatus(PrinterStatus.healthCheckFailed);
    //     _lastSuccessfulPrint = null;
    //     return false;
    //   }
    //   if (status == PrinterStatus.healthCheckFailed || status == PrinterStatus.error) {
    //     updateStatus(PrinterStatus.disconnected);
    //   }
    // }

    // STEP 2: Auto-connect if needed (common logic)
    if (status != PrinterStatus.connected) {
      final connected = await connect();
      if (!connected) {
        _lastSuccessfulPrint = null; // Clear cache on failure
        return false;
      }
    }

    // STEP 3: Paper size conversion (common logic)
    PrintTicket finalTicket = ticket;
    if (ticket.paperSize != paperSize && regenerator != null) {
      // Regenerate ticket with printer's paper size
      finalTicket = await regenerator(paperSize);
    }

    // STEP 4: Device-specific printing (delegated to subclass)
    try {
      updateStatus(PrinterStatus.printing);
      final result = await printInternal(finalTicket);

      if (result) {
        // Success - cache timestamp for fast consecutive prints
        _lastSuccessfulPrint = DateTime.now();
        updateStatus(PrinterStatus.connected);
      } else {
        // Failure - clear cache to force health check next time
        _lastSuccessfulPrint = null;
        updateStatus(PrinterStatus.error);
      }

      return result;
    } catch (e) {
      _lastSuccessfulPrint = null; // Clear cache on exception
      updateStatus(PrinterStatus.error);
      return false;
    }
  }

  /// Device-specific print implementation
  ///
  /// Subclasses implement ONLY the byte transmission logic specific to their
  /// communication protocol (Bluetooth, WiFi, USB, etc.).
  ///
  /// The base class [print] method handles:
  /// - Pre-flight health check
  /// - Auto-connect
  /// - Paper size conversion
  /// - Status management
  /// - Error handling
  ///
  /// This method should:
  /// - Send ticket.bytes to the printer
  /// - Return true if transmission succeeded
  /// - Return false if transmission failed
  /// - Throw exception for unexpected errors
  ///
  /// **Usage Example:**
  /// ```dart
  /// class BluetoothPrinterDevice extends PrinterDevice {
  ///   @override
  ///   Future<bool> printInternal(PrintTicket ticket) async {
  ///     return await PrintBluetoothThermal.writeBytes(ticket.bytes);
  ///   }
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  @protected
  Future<bool> printInternal(PrintTicket ticket);

  /// Check if the printer is healthy and responsive
  ///
  /// Returns true if printer is healthy, false otherwise.
  /// May update status to [PrinterStatus.healthCheckFailed] if check fails.
  Future<bool> checkHealth();

  /// Create a copy of this printer with updated properties
  ///
  /// Returns a new instance of the same printer type with updated properties.
  /// Subclasses must implement this method with their specific return type.
  ///
  /// **Usage Example:**
  /// ```dart
  /// final updatedPrinter = printer.copyWith(
  ///   role: PrinterRole.kitchen,
  ///   paperSize: PaperSize.mm80,
  /// );
  /// ```
  ///
  // ────────────────────────────────────────────────
  PrinterDevice copyWith({
    PrinterRole? role,
    int? defaultCopies,
    PaperSize? paperSize,
    Map<String, dynamic>? metadata,
  });

  /// **reset**
  ///
  /// Resets this printer's configuration to default values.
  /// Returns a new PrinterDevice instance with default configuration.
  ///
  /// **Default Configuration:**
  /// - role: null (no role assigned)
  /// - autoPrintMode: manual (from metadata)
  /// - defaultCopies: 1
  /// - paperSize: mm80
  /// - metadata: empty map
  ///
  /// **Preserved:**
  /// - id, name, connection details (MAC, IP, port)
  ///
  /// **Usage Example:**
  /// ```dart
  /// final resetPrinter = printer.reset();
  /// engine.updatePrinter(resetPrinter);
  /// ```
  ///
  /// **Returns:** New PrinterDevice with default configuration (BR-083)
  ///
  // ────────────────────────────────────────────────
  PrinterDevice reset();

  /// Clean up resources when printer is no longer needed
  ///
  /// **IMPORTANT:** Automatically disconnects printer before cleanup to prevent
  /// orphaned device connections. Subclasses should call super.dispose().
  void dispose() {
    // Disconnect before disposing to prevent orphaned connections
    if (_status == PrinterStatus.connected || _status == PrinterStatus.printing) {
      disconnect(); // Fire and forget - synchronous cleanup
    }
    _statusController.close();
  }

  @override
  String toString() {
    return 'PrinterDevice(id: $id, name: $name, type: $type, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrinterDevice && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
