import 'dart:async';
import 'dart:io';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/printer_status_event.dart';
import 'package:fifty_printing_engine/src/models/printing_mode.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/models/discovered_printer.dart';
import 'package:fifty_printing_engine/src/strategies/print_to_all_strategy.dart';
import 'package:fifty_printing_engine/src/strategies/role_based_routing_strategy.dart';
import 'package:fifty_printing_engine/src/strategies/select_per_print_strategy.dart';
import 'package:fifty_printing_engine/src/utils/printer_configuration_serializer.dart';
import 'package:fifty_printing_engine/src/utils/printer_discovery_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

/// Callback type for printer selection UI in SelectPerPrint mode
typedef PrinterSelectionCallback = Future<List<String>?> Function(
  List<PrinterDevice> availablePrinters,
  PrinterRole? suggestedRole,
);

/// **PrintingEngine**
///
/// Main orchestrator for multi-printer ESC/POS printing operations across Bluetooth and WiFi printers.
///
/// **Key Features:**
/// - Multi-printer management with Bluetooth discovery
/// - Flexible routing strategies (print to all, role-based, manual selection)
/// - Auto-connect to disconnected printers when printing
/// - Real-time status monitoring and health checks
/// - Per-printer copy count configuration with optional override
/// - Complete permission handling for Android/iOS
/// - Export/import configuration for persistence
///
/// **Usage Example:**
/// ```dart
/// final engine = PrintingEngine.instance;
///
/// // Discover and register Bluetooth printer
/// final printers = await engine.scanBluetoothPrinters();
/// engine.registerPrinter(printers.first.toDevice(
///   id: 'kitchen-1',
///   role: PrinterRole.kitchen,
///   defaultCopies: 2,
/// ));
///
/// // Configure routing
/// engine.setPrintingMode(PrintingMode.roleBasedRouting);
///
/// // Create and print ticket
/// final ticket = PrintTicket(PaperSize.mm80, profile);
/// ticket.text('Order #123', styles: PosStyles(bold: true));
/// ticket.feed(2);
/// ticket.cut();
///
/// final result = await engine.print(ticket: ticket, targetRole: PrinterRole.kitchen);
/// print('${result.successCount}/${result.totalPrinters} printers succeeded');
/// ```
///
// ────────────────────────────────────────────────
class PrintingEngine {
  // Singleton pattern
  static final PrintingEngine _instance = PrintingEngine._();
  static PrintingEngine get instance => _instance;
  PrintingEngine._();

  // State
  final Map<String, PrinterDevice> _printers = {};
  PrintingMode _printingMode = PrintingMode.printToAll;
  final Map<PrinterRole, List<String>> _roleMappings = {};
  Timer? _healthCheckTimer;

  // Debounce timer for configuration updates
  Timer? _updateDebounceTimer;
  final Map<String, PrinterDevice> _pendingUpdates = {};

  // Printer selection callback for SelectPerPrint mode
  PrinterSelectionCallback? _printerSelectionCallback;

  // Status event stream
  final _statusEventController = StreamController<PrinterStatusEvent>.broadcast();

  /// Stream of printer status events
  Stream<PrinterStatusEvent> get statusStream => _statusEventController.stream;

  /// Current role mappings
  Map<PrinterRole, List<String>> get roleMappings => Map.unmodifiable(_roleMappings);

  // Strategies
  final _strategies = {
    PrintingMode.printToAll: PrintToAllStrategy(),
    PrintingMode.selectPerPrint: SelectPerPrintStrategy(),
    PrintingMode.roleBasedRouting: RoleBasedRoutingStrategy(),
  };

  /// **registerPrinter**
  ///
  /// Registers a printer device with the engine for use in print operations.
  ///
  /// **Key Features:**
  /// - Automatically listens to printer status changes
  /// - Emits status events via statusStream
  /// - Supports both Bluetooth and WiFi printers
  ///
  /// **Parameters:**
  /// - `device`: PrinterDevice to register (BluetoothPrinterDevice or WiFiPrinterDevice)
  ///
  /// **Usage Example:**
  /// ```dart
  /// engine.registerPrinter(BluetoothPrinterDevice(
  ///   id: 'kitchen-1',
  ///   name: 'Kitchen Printer',
  ///   macAddress: '00:11:22:33:44:55',
  ///   role: PrinterRole.kitchen,
  ///   defaultCopies: 2,
  /// ));
  /// ```
  ///
  // ────────────────────────────────────────────────
  void registerPrinter(PrinterDevice device) {
    _printers[device.id] = device;

    // Listen to printer status changes and emit events
    device.statusStream.listen((newStatus) {
      _statusEventController.add(PrinterStatusEvent(
        printerId: device.id,
        oldStatus: device.status,
        newStatus: newStatus,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// **updatePrinter**
  ///
  /// Updates an existing printer's configuration while preserving connection state and list position.
  ///
  /// **Key Features:**
  /// - Preserves runtime connection status (connected/disconnected/error)
  /// - Automatically reconnects if printer was connected before update
  /// - Maintains printer position in list (no reordering)
  /// - Updates in-place without removing from internal map
  /// - Prevents annoying UX of printer jumping to bottom of list
  /// - Debounces rapid changes (500ms) to prevent race conditions with slow WiFi reconnection
  ///
  /// **Parameters:**
  /// - `printerId`: ID of the printer to update
  /// - `updatedDevice`: New PrinterDevice with updated configuration
  ///
  /// **Usage Example:**
  /// ```dart
  /// final printer = engine.getAvailablePrinters().first;
  /// final updated = printer.copyWith(role: PrinterRole.kitchen);
  /// engine.updatePrinter(printer.id, updated);
  /// // Printer stays connected AND in same position
  /// ```
  ///
  /// **Debouncing:**
  /// Multiple rapid updates to the same printer are batched together.
  /// Only the final configuration is applied after 500ms of no changes.
  /// This prevents race conditions with slow WiFi socket reconnection.
  ///
  /// **Returns:**
  /// - `true` if update succeeded
  /// - `false` if printer not found
  ///
  // ────────────────────────────────────────────────
  bool updatePrinter(String printerId, PrinterDevice updatedDevice) {
    final oldPrinter = _printers[printerId];
    if (oldPrinter == null) return false;

    // Store pending update
    _pendingUpdates[printerId] = updatedDevice;

    // Cancel existing debounce timer
    _updateDebounceTimer?.cancel();

    // Debounce: Wait 500ms for rapid changes to settle
    // This prevents race conditions with slow WiFi reconnection (5s timeout)
    _updateDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performPendingUpdates();
    });

    return true;
  }

  /// Perform all pending printer updates
  ///
  /// Called after debounce timer expires (500ms of no changes).
  /// Applies all pending configuration updates at once.
  ///
  // ────────────────────────────────────────────────
  void _performPendingUpdates() {
    for (final entry in _pendingUpdates.entries) {
      final printerId = entry.key;
      final updatedDevice = entry.value;

      final oldPrinter = _printers[printerId];
      if (oldPrinter == null) continue;

      // Preserve runtime connection state
      final wasConnected = oldPrinter.status == PrinterStatus.connected;

      // Update printer in-place (preserves position in map)
      _printers[printerId] = updatedDevice;

      // Dispose old printer's resources (streams, connections)
      oldPrinter.dispose();

      // Subscribe to new printer's status stream
      updatedDevice.statusStream.listen((newStatus) {
        _statusEventController.add(PrinterStatusEvent(
          printerId: updatedDevice.id,
          oldStatus: updatedDevice.status,
          newStatus: newStatus,
          timestamp: DateTime.now(),
        ));
      });

      // Restore connection state if printer was connected
      if (wasConnected) {
        // Reconnect asynchronously (non-blocking)
        updatedDevice.connect().then((success) {
          if (!success) {
            // If reconnection fails, emit error event
            _statusEventController.add(PrinterStatusEvent(
              printerId: updatedDevice.id,
              oldStatus: PrinterStatus.connected,
              newStatus: PrinterStatus.error,
              timestamp: DateTime.now(),
            ));
          }
        });
      }
    }

    // Clear pending updates
    _pendingUpdates.clear();
  }

  /// Remove a printer from the engine
  void removePrinter(String printerId) {
    final printer = _printers.remove(printerId);
    printer?.dispose();
  }

  /// **clear**
  ///
  /// Removes and disposes all registered printers.
  /// Clears printer list completely while keeping engine alive.
  ///
  /// **Key Features:**
  /// - Disposes each printer properly (releases resources)
  /// - Clears internal printer map
  /// - Engine remains usable (can register new printers after)
  ///
  /// **Usage Example:**
  /// ```dart
  /// engine.clear(); // Remove all printers
  /// engine.registerPrinter(newPrinter); // Can add new printers
  /// ```
  ///
  /// **BR-083:** Used for complete printer removal and disposal cleanup
  ///
  // ────────────────────────────────────────────────
  void clear() {
    // Dispose all printers
    for (final printer in _printers.values) {
      printer.dispose();
    }

    // Clear printer map
    _printers.clear();
  }

  /// **reset**
  ///
  /// Resets all printer configurations to defaults.
  /// Printers stay registered but with default settings.
  ///
  /// **Default Configuration Per Printer:**
  /// - role: null (no role assigned)
  /// - autoPrintMode: manual (from metadata)
  /// - defaultCopies: 1
  /// - paperSize: mm80
  /// - metadata: empty map
  ///
  /// **Engine Configuration:**
  /// - Printing mode: printToAll
  /// - Role mappings: cleared
  ///
  /// **Usage Example:**
  /// ```dart
  /// final newConfig = engine.reset();
  /// // Save newConfig to storage
  /// ```
  ///
  /// **Returns:** New configuration map for storage
  ///
  /// **BR-083:** Used by reset button to reset all settings while keeping printers
  ///
  // ────────────────────────────────────────────────
  Map<String, dynamic> reset() {
    // Reset each printer to default configuration
    final printerIds = List.from(_printers.keys);  // Copy keys
    for (final printerId in printerIds) {
      final printer = _printers[printerId];
      if (printer != null) {
        final resetPrinter = printer.reset();  // Get reset version
        updatePrinter(printerId, resetPrinter);  // Replace with reset version
      }
    }

    // Reset printing mode to default
    setPrintingMode(PrintingMode.printToAll);

    // Clear role mappings
    _roleMappings.clear();

    // Return new configuration for storage
    return exportConfiguration();
  }

  /// Get all registered printers, optionally filtered by status
  List<PrinterDevice> getAvailablePrinters({PrinterStatus? filterByStatus}) {
    if (filterByStatus == null) {
      return _printers.values.toList();
    }
    return _printers.values.where((p) => p.status == filterByStatus).toList();
  }

  /// Get printers assigned to a specific role
  List<PrinterDevice> getPrintersByRole(PrinterRole role) {
    final printerIds = _roleMappings[role] ?? [];
    return _printers.values
        .where((p) => printerIds.contains(p.id) || p.role == role || p.role == PrinterRole.both)
        .toList();
  }

  /// Set the global printing mode
  void setPrintingMode(PrintingMode mode) {
    _printingMode = mode;
  }

  /// Get the current printing mode
  PrintingMode get printingMode => _printingMode;

  /// **setPrinterSelectionCallback**
  ///
  /// Register a callback for printer selection UI in SelectPerPrint mode.
  ///
  /// **Usage Example:**
  /// ```dart
  /// engine.setPrinterSelectionCallback((printers, suggestedRole) async {
  ///   // Show dialog and return selected printer IDs
  ///   final result = await showDialog(...);
  ///   return result?.map((p) => p.id).toList();
  /// });
  /// ```
  ///
  // ────────────────────────────────────────────────
  void setPrinterSelectionCallback(PrinterSelectionCallback? callback) {
    _printerSelectionCallback = callback;
  }

  /// Get the registered printer selection callback
  PrinterSelectionCallback? get selectionCallback => _printerSelectionCallback;

  /// Set role mapping for role-based routing
  ///
  /// Example:
  /// ```dart
  /// engine.setRoleMapping(PrinterRole.kitchen, ['printer-1', 'printer-2']);
  /// engine.setRoleMapping(PrinterRole.receipt, ['printer-3']);
  /// ```
  void setRoleMapping(PrinterRole role, List<String> printerIds) {
    _roleMappings[role] = printerIds;
  }

  /// Get role mapping for a specific role
  List<String> getRoleMapping(PrinterRole role) {
    return _roleMappings[role] ?? [];
  }

  /// **print**
  ///
  /// Executes a print operation using the configured routing strategy with automatic copy control.
  ///
  /// **Key Features:**
  /// - Routes to target printers based on current printing mode
  /// - Automatically attempts to connect disconnected printers
  /// - Supports per-printer default copies with optional override
  /// - Returns detailed success/failure results for each printer
  /// - Handles multiple printers concurrently
  ///
  /// **Parameters:**
  /// - `ticket`: PrintTicket to print (required)
  /// - `copies`: Number of copies (overrides printer defaults if specified)
  /// - `targetRole`: Target role for role-based routing
  /// - `targetPrinterIds`: Specific printer IDs for explicit selection
  /// - `regenerator`: Optional function to regenerate ticket with different paper size
  ///
  /// **Returns:**
  /// PrintResult with totalPrinters, successCount, failedCount, and per-printer details
  ///
  /// **Usage Example:**
  /// ```dart
  /// // Use printer defaults (kitchen: 2 copies, receipt: 1 copy)
  /// final result = await engine.print(ticket: ticket);
  ///
  /// // Override: print 3 copies on all target printers
  /// await engine.print(ticket: ticket, copies: 3);
  ///
  /// // Role-based routing with auto paper size conversion
  /// await engine.print(
  ///   ticket: ticket,
  ///   targetRole: PrinterRole.kitchen,
  ///   regenerator: (paperSize) => KitchenTicketGenerator.generate(paperSize, order, settings),
  /// );
  ///
  /// // Handle results
  /// if (result.isPartialSuccess) {
  ///   print('${result.successCount}/${result.totalPrinters} succeeded');
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  Future<PrintResult> print({
    required PrintTicket ticket,
    int? copies,
    PrinterRole? targetRole,
    List<String>? targetPrinterIds,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  }) async {
    final strategy = _strategies[_printingMode]!;

    // Get print result from strategy (determines which printers)
    final result = await strategy.execute(
      ticket: ticket,
      availablePrinters: _printers.values.toList(),
      targetRole: targetRole,
      targetPrinterIds: targetPrinterIds,
      regenerator: regenerator,
    );

    // If copies > 1 or printer has defaultCopies > 1, print additional copies
    if (copies != null && copies > 1) {
      // Override: print additional copies on all target printers
      for (int i = 1; i < copies; i++) {
        await strategy.execute(
          ticket: ticket,
          availablePrinters: _printers.values.toList(),
          targetRole: targetRole,
          targetPrinterIds: targetPrinterIds,
          regenerator: regenerator,
        );
      }
    } else {
      // Use printer defaults: check if any printer needs additional copies
      final targetPrinterIds = result.results.keys.toList();
      for (final printerId in targetPrinterIds) {
        final printer = _printers[printerId];
        if (printer != null && printer.defaultCopies > 1) {
          // Print additional copies for this specific printer
          for (int i = 1; i < printer.defaultCopies; i++) {
            await printer.print(ticket, regenerator: regenerator);
          }
        }
      }
    }

    return result;
  }

  /// Enable periodic health checks for all printers
  ///
  /// Health checks will run at the specified interval and update
  /// printer status if they fail.
  void enableHealthChecks({Duration interval = const Duration(minutes: 5)}) {
    disableHealthChecks(); // Cancel any existing timer

    _healthCheckTimer = Timer.periodic(interval, (_) async {
      await checkAllPrinters();
    });
  }

  /// Disable periodic health checks
  void disableHealthChecks() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
  }

  /// Manually check health of a specific printer
  ///
  /// Returns true if printer is healthy, false otherwise.
  Future<bool> checkPrinterHealth(String printerId) async {
    final printer = _printers[printerId];
    if (printer == null) return false;

    try {
      final isHealthy = await printer.checkHealth();
      if (!isHealthy) {
        printer.updateStatus(PrinterStatus.healthCheckFailed);
      }
      return isHealthy;
    } catch (e) {
      printer.updateStatus(PrinterStatus.error);
      return false;
    }
  }

  /// Check health of all registered printers
  ///
  /// Returns a map of printer IDs to health check results.
  Future<Map<String, bool>> checkAllPrinters() async {
    final results = <String, bool>{};

    for (final printer in _printers.values) {
      results[printer.id] = await checkPrinterHealth(printer.id);
    }

    return results;
  }

  // ────────────────────────────────────────────────
  // Bluetooth Discovery Methods
  // ────────────────────────────────────────────────

  /// **scanBluetoothPrinters**
  ///
  /// Discovers available Bluetooth printers with automatic permission and connectivity checks.
  ///
  /// **Key Features:**
  /// - Automatically checks Bluetooth permissions before scanning
  /// - Verifies Bluetooth is enabled on device
  /// - Filters to printer-like devices using comprehensive keyword list (20+ brands)
  /// - Returns paired devices on Android, nearby devices on iOS
  /// - Throws helpful errors directing to App Settings if permissions missing
  ///
  /// **Parameters:**
  /// - `filterPrintersOnly`: If true, filters to devices with printer-like names (EPSON, STAR, etc.)
  ///
  /// **Returns:**
  /// List of DiscoveredPrinter objects (name, macAddress, toDevice() helper)
  ///
  /// **Throws:**
  /// - `Exception`: If Bluetooth permissions not granted (lists missing permissions)
  /// - `Exception`: If Bluetooth not enabled
  ///
  /// **Usage Example:**
  /// ```dart
  /// try {
  ///   final printers = await engine.scanBluetoothPrinters(filterPrintersOnly: true);
  ///   for (final printer in printers) {
  ///     print('Found: ${printer.name}');
  ///   }
  ///
  ///   // Register discovered printer
  ///   engine.registerPrinter(printers.first.toDevice(
  ///     id: 'printer-1',
  ///     role: PrinterRole.kitchen,
  ///   ));
  /// } catch (e) {
  ///   if (e.toString().contains('Settings')) {
  ///     await engine.openBluetoothSettings();
  ///   }
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  Future<List<DiscoveredPrinter>> scanBluetoothPrinters({
    bool filterPrintersOnly = false,
  }) async {
    // 1. Check permissions FIRST (throws if missing)
    await requestBluetoothPermissions();

    // 2. Check Bluetooth enabled (now that we have permissions)
    final bluetoothEnabled = await PrintBluetoothThermal.bluetoothEnabled;

    if (!bluetoothEnabled) {
      throw Exception('Bluetooth is not enabled. Please enable Bluetooth in device settings.');
    }

    // 3. Scan for devices
    final List<BluetoothInfo> devices = await PrintBluetoothThermal.pairedBluetooths;

    // Convert to DiscoveredPrinter
    List<DiscoveredPrinter> discovered = devices
        .map((device) => DiscoveredPrinter(
              name: device.name,
              macAddress: device.macAdress, // Note: Package has typo "macAdress"
            ))
        .toList();

    // Filter to printers only if requested
    if (filterPrintersOnly) {
      discovered = discovered.where(
        (printer) => PrinterDiscoveryUtils.isPrinterName(printer.name)
      ).toList();
    }

    return discovered;
  }

  /// Check if Bluetooth is enabled on the device.
  ///
  /// Returns true if Bluetooth is enabled, false otherwise.
  Future<bool> isBluetoothEnabled() async {
    return  await PrintBluetoothThermal.bluetoothEnabled;
  }

  /// Check if Bluetooth permissions are granted.
  ///
  /// Returns true if permissions are granted, false otherwise.
  Future<bool> hasBluetoothPermissions() async {
    return await PrintBluetoothThermal.isPermissionBluetoothGranted;
  }

  /// Request Bluetooth permissions with platform-specific handling.
  ///
  /// **Android 12+:**
  /// - Checks bluetooth and nearbyWifiDevices permissions
  /// - Does NOT request (known Android 12+ limitation)
  /// - Throws helpful error directing to App Settings if missing
  /// - Workaround: Users must enable in Settings manually
  ///
  /// **iOS:**
  /// - No explicit permission check needed
  /// - iOS shows permission dialog automatically when Bluetooth APIs are used
  /// - Dialog triggered by PrintBluetoothThermal.pairedBluetooths call
  /// - Uses NSBluetoothAlwaysUsageDescription from Info.plist
  /// - Permission does NOT appear in iOS Settings (system-level, auto-granted)
  ///
  /// **Note:** Location permission is NOT required - print_bluetooth_thermal was specifically
  /// designed to avoid location permission requirements.
  ///
  /// Returns true if all required permissions are granted.
  /// Throws Exception with helpful message if permissions are missing (Android only).
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await PrintingEngine.instance.requestBluetoothPermissions();
  ///   final printers = await PrintingEngine.instance.scanBluetoothPrinters();
  /// } catch (e) {
  ///   // Android: Show error and "Open Settings" button
  ///   // iOS: Should not reach here (auto-grants)
  /// }
  /// ```
  Future<bool> requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      // Check required permissions (Android 12+ needs bluetooth + nearbyWifiDevices)
      // Note: print_bluetooth_thermal does NOT require location permission
      final bluetoothGranted = await permission_handler.Permission.bluetooth.isGranted;
      final nearbyGranted = await permission_handler.Permission.nearbyWifiDevices.isGranted;

      if (!bluetoothGranted || !nearbyGranted) {
        throw Exception(
          'Bluetooth permissions are required.\n\n'
          'Please enable the following in App Settings:\n'
          '${!bluetoothGranted ? '• Bluetooth\n' : ''}'
          '${!nearbyGranted ? '• Nearby devices\n' : ''}'
        );
      }

      return true;
    } else if (Platform.isIOS) {
      // iOS: No permission check needed
      // System automatically shows Bluetooth permission dialog when scanning
      // Dialog uses NSBluetoothAlwaysUsageDescription from Info.plist
      // Permission is system-level and doesn't appear in app Settings
      return true;
    }

    // Other platforms don't need permissions
    return true;
  }

  /// Open app settings.
  ///
  /// Opens the system app settings where users can manually enable permissions.
  ///
  /// This is the recommended approach for Android 12+ where in-app permission
  /// requests for nearbyWifiDevices don't work reliably.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await engine.requestBluetoothPermissions();
  /// } catch (e) {
  ///   // Show error message
  ///   await engine.openBluetoothSettings();
  /// }
  /// ```
  Future<void> openBluetoothSettings() async {
    await permission_handler.openAppSettings();
  }

  // ────────────────────────────────────────────────
  // Persistence Helpers (Consumer Handles Storage)
  // ────────────────────────────────────────────────

  /// **exportConfiguration**
  ///
  /// Exports current engine configuration as JSON for persistence by consumer.
  ///
  /// **Key Features:**
  /// - Serializes all registered printers (including type, role, defaultCopies)
  /// - Includes printing mode and role mappings
  /// - Returns plain Map (consumer handles storage mechanism)
  /// - Package stays storage-agnostic
  ///
  /// **Returns:**
  /// `Map<String, dynamic>` containing full configuration (ready for jsonEncode)
  ///
  /// **Usage Example:**
  /// ```dart
  /// import 'dart:convert';
  ///
  /// // Save on app pause/exit
  /// final config = engine.exportConfiguration();
  /// await storage.save('printer_config', jsonEncode(config));
  /// ```
  ///
  // ────────────────────────────────────────────────
  Map<String, dynamic> exportConfiguration() {
    return PrinterConfigurationSerializer.export(this);
  }

  /// **importConfiguration**
  ///
  /// Restores engine configuration from previously exported JSON data.
  ///
  /// **Key Features:**
  /// - Clears existing configuration before importing
  /// - Recreates all printers with saved settings
  /// - Restores printing mode and role mappings
  /// - Re-initializes status monitoring for loaded printers
  ///
  /// **Parameters:**
  /// - `config`: Configuration Map from exportConfiguration() (after jsonDecode)
  ///
  /// **Usage Example:**
  /// ```dart
  /// import 'dart:convert';
  ///
  /// // Load on app start
  /// final configJson = await storage.load('printer_config');
  /// if (configJson != null) {
  ///   final config = jsonDecode(configJson);
  ///   engine.importConfiguration(config);
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  void importConfiguration(Map<String, dynamic> config) {
    PrinterConfigurationSerializer.import(this, config);
  }

  // ────────────────────────────────────────────────
  // Internal Helper Methods
  // ────────────────────────────────────────────────

  /// Clean up resources
  ///
  /// **BR-083:** Now uses clear() method for printer cleanup
  void dispose() {
    disableHealthChecks();
    _statusEventController.close();
    clear();  // Use clear() method for printer disposal
  }
}
