import 'package:fifty_ui/fifty_ui.dart';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

/// Maps [PrinterStatus] to [FiftyStatusState] for status indicator display.
FiftyStatusState mapPrinterStatus(PrinterStatus status) {
  switch (status) {
    case PrinterStatus.connected:
      return FiftyStatusState.ready;
    case PrinterStatus.printing:
      return FiftyStatusState.loading;
    case PrinterStatus.connecting:
      return FiftyStatusState.loading;
    case PrinterStatus.error:
      return FiftyStatusState.error;
    case PrinterStatus.healthCheckFailed:
      return FiftyStatusState.error;
    case PrinterStatus.disconnected:
      return FiftyStatusState.offline;
  }
}
