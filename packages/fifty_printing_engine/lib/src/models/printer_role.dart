/// Roles that printers can be assigned for routing purposes
enum PrinterRole {
  /// Kitchen printer (for kitchen order tickets)
  kitchen,

  /// Receipt printer (for customer receipts and tax invoices)
  receipt,

  /// General purpose printer (can handle any print job)
  both,
}
